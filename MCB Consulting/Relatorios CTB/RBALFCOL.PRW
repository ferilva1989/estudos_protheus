#INCLUDE "PROTHEUS.CH"
#INCLUDE 'FWMVCDEF.CH'
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

/*------------------------------------------------------------------------------------------------------------------------------------------------*\
| Fonte:	 |	RBALFCOL.PRW                                                                                                                       |
| Autor:	 |	Djalma Borges                                                                                                                      |
| Data:		 |	18/04/2016                                                                                                                         |
| Descrição: |	Balancete Financeiro Colunado por filiais selecionadas no markbrowse da SM0														   |
\*------------------------------------------------------------------------------------------------------------------------------------------------*/

User Function RBALFCOL()  

	Local oCheck  	:= LoadBitmap( GetResources(), "CHECKED" )
	Local oNoCheck	:= LoadBitmap( GetResources(), "UNCHECKED" )
	Local oFont1  	:= TFont():New("MS Sans Serif",,028,,.T.,,,,,.F.,.F.)
	Local oSay1,oSay2
	Local oDlg2
	Local aObjects := {}
	Local aPosObj  := {}

	Local oContaIni 
	Local cContaIni := Space(9)
	Local oContaFim 
	Local cContaFim := Space(9)
	Local oAnoMes
	Local cAnoMes := Space(6)
	Local oDlg     

	Local aItCombo1 := {"NÃO", "SIM"}
	Local cCombo1 := aItCombo1[1]
	Local oCombo1
	Local oDataApur
	Local dDataApur := CTOD("  /  /    ")

	Private _aItens := {}     
	Private _oFilSelec 

	dbSelectArea("SM0")
	SM0->(dbGoTop())
	While SM0->(!EOF())
		Aadd(_aItens, {.F., M0_CODFIL, ALLTRIM(M0_FILIAL)})
		SM0->(dbSkip())
	EndDo           
	SM0->(dbGoTop())

	DEFINE MSDIALOG oDlg2 TITLE "Bal. Fin. colunado por Filiais selecionadas" FROM 0,0 TO 500,300 OF GetWndDefault() COLORS 0, 16777215 PIXEL

	//MARKBROWSE DO ARRAY ALIMENTADO PELA SM0
	_oFilSelec := TCBrowse():New(0, 0, 153, 100, , {}, {}, oDlg2, , , , , {||}, , , , , , , .F., , .T., , .F., , , )
	_oFilSelec:SetArray(_aItens)
	_oFilSelec:AddColumn( TCColumn():New("  " ,{ || If(_aItens[_oFilSelec:nAt,1], oCheck , oNoCheck )},,,,"CENTER",20,.t.,.T.,,,,.F.,) )
	_oFilSelec:AddColumn( TCColumn():New("Filial" ,{ || _aItens[_oFilSelec:nAt,2]},"@!",,,"LEFT",40,.F.,.T.,,,,.F.,) )
	_oFilSelec:AddColumn( TCColumn():New("Unidade " ,{ || _aItens[_oFilSelec:nAt,3]},"@!",,,"LEFT",70,.F.,.T.,,,,.F.,) )
	_oFilSelec:bLDblClick := {||_aItens[ _oFilSelec:nAt , 1 ] := !_aItens[ _oFilSelec:nAt , 1 ], _oFilSelec:Refresh() }
	_oFilSelec:bHeaderClick := {||SelectAll()}
	_oFilSelec:GoTop()

	@110,10 Say "ANO + MÊS: " Pixel Of oDlg2
	@110,50 MSGet oAnoMes Var cAnoMes Size 50,10 Pixel Of oDlg

	@135,10 Say "Pos. Ant. L/P ? " Pixel Of oDlg2
	oCombo1 := TComboBox():New(135,050,{|u|if(PCount()>0,cCombo1:=u,cCombo1)},aItCombo1,50,13,oDlg,,,,,,.T.,,,,,,,,,'cCombo1')

	@155,10 Say "Data L/P: " Pixel Of oDlg2                
	@155,50 MSGet oDataApur Var dDataApur Size 50,10 Pixel Of oDlg

	@180,10 Say "CONTA INI: " Pixel Of oDlg2
	@180,50 MSGet oContaIni Var cContaIni Size 50,10 Pixel F3 "CT1" Of oDlg

	@200,10 Say "CONTA FIM: " Pixel Of oDlg2
	@200,50 MSGet oContaFim Var cContaFim Size 50,10 Pixel F3 "CT1" Of oDlg

	tButton():New(225,010, "OK"      , , {||oDlg2:End(), AgRelator(cContaIni, cContaFim, cAnoMes, cCombo1, dDataApur)}, 040, 015,,,,.T.)
	tButton():New(225,100, "Cancelar", , {||oDlg2:End()}                       			                              , 040, 015,,,,.T.)

	ACTIVATE MSDIALOG oDlg2 CENTERED

Return

Static Function AgRelator(cContaIni, cContaFim, cAnoMes, cCombo1, dDataApur)

	Processa( {|| ProcRelat(cContaIni, cContaFim, cAnoMes, cCombo1, dDataApur) }, "Aguarde...", "Processando os dados que serão exportados para o Excel...",.F.)

Return

Static Function ProcRelat(cContaIni, cContaFim, cAnoMes, cCombo1, dDataApur)

	Local cQuery := ""
	Local aCabec := {}
	Local aDados := {}
	Local aDados2 := {}
	Local aDados3 := {}
	Local aDadosBFC := {}
	Local aItens := {}   
	Local aCampos := {}
	Local aTamSx3 := {}
	Local nCount := 0
	Local nCount2 := 0
	Local nCount3 := 0        
	Local nCount4 := 0
	Local nCount5 := 0
	Local nCount6 := 0
	Local aBalFinCol := {}
	Local cArqTrab := ""
	Local aSaldoSint := {}
	Local nValorSint := 0
	Local cFilialAnt := ""
	Local cChaveAnt  := ""
	Local cCtaSupAnt := ""
	Local dDataini := ""
	Local dDataFim := ""
	Local cFilAtual := xFilial("CT2")      
	Local nFiliais := 0    
	Local nLenDados3 := 0 
	Local nOpcPosAnt := 0    
	Local lCtaZerada := .F.

	dDataIni := CTOD("01/" + SubStr(cAnoMes,5,2) + "/" + SubStr(cAnoMes,1,4))
	dDataFim := LastDate(dDataIni)

	//LOOP PARA CADA FILIAL SELECIONADA NA MARKBROWSE
	For nCount4 := 1 to Len(_aItens)

		//ZERA AS VARIÁVEIS PARA CADA FILIAL
		cQuery := ""
		aDadosBFC := {}
		aItens := {}   
		aCampos := {}
		aTamSx3 := {}
		aBalFinCol := {}
		cArqTrab := ""
		aSaldoSint := {}
		nValorSint := 0
		cFilialAnt := "" 
		cChaveAnt  := ""
		cCtaSupAnt := ""

		//SE A FILIAL FOI SELECIONADA NA MARKBROWSE
		If _aItens[nCount4][1] == .T.

			cFilAnt := _aItens[nCount4][2]

			cQuery := "SELECT CT1_CONTA, CT1_DESC01, CT1_CTASUP, CT2_FILIAL, "

			cQuery += "(SELECT SUM(CT2D.CT2_VALOR) "
			cQuery += "FROM " + RetSqlName("CT2") + " CT2D "
			cQuery += "WHERE CT2D.D_E_L_E_T_ <> '*' AND CT2D.CT2_DEBITO = " + RetSqlName("CT1") + ".CT1_CONTA AND CT2D.CT2_DATA >= '" + DTOS(dDataIni) + "' AND CT2D.CT2_DATA <= '" + DTOS(dDataFim) + "' AND CT2D.CT2_FILIAL = '" + cFilAnt + "') AS VALORDEB, "

			cQuery += "(SELECT SUM(CT2C.CT2_VALOR) "
			cQuery += "FROM " + RetSqlName("CT2") + " CT2C "
			cQuery += "WHERE CT2C.D_E_L_E_T_ <> '*' AND CT2C.CT2_CREDIT = " + RetSqlName("CT1") + ".CT1_CONTA AND CT2C.CT2_DATA >= '" + DTOS(dDataIni) + "' AND CT2C.CT2_DATA <= '" + DTOS(dDataFim) + "' AND CT2C.CT2_FILIAL = '" + cFilAnt + "') AS VALORCRED, "

			cQuery += "(SELECT SUM(CT2D1.CT2_VALOR) "
			cQuery += "FROM " + RetSqlName("CT1") + " CT1D1 "
			cQuery += "   LEFT JOIN " + RetSqlName("CT2") + " CT2D1 "
			cQuery += "      ON CT2D1.D_E_L_E_T_ <> '*' AND CT2D1.CT2_FILIAL = '" + cFilAnt + "' AND CT1D1.CT1_CONTA = CT2D1.CT2_DEBITO AND CT2D1.CT2_DATA >= '" + DTOS(dDataIni) + "' AND CT2D1.CT2_DATA <= '" + DTOS(dDataFim) + "' AND CT1D1.CT1_CTASUP = " + RetSqlName("CT1") + ".CT1_CONTA "
			cQuery += "WHERE CT1D1.D_E_L_E_T_ <> '*') AS VRDEBSINT1, "

			cQuery += "(SELECT SUM(CT2C1.CT2_VALOR) "
			cQuery += "FROM " + RetSqlName("CT1") + " CT1C1 "
			cQuery += "   LEFT JOIN " + RetSqlName("CT2") + " CT2C1 "
			cQuery += "      ON CT2C1.D_E_L_E_T_ <> '*' AND CT2C1.CT2_FILIAL = '" + cFilAnt + "' AND CT1C1.CT1_CONTA = CT2C1.CT2_CREDIT AND CT2C1.CT2_DATA >= '" + DTOS(dDataIni) + "' AND CT2C1.CT2_DATA <= '" + DTOS(dDataFim) + "' AND CT1C1.CT1_CTASUP = " + RetSqlName("CT1") + ".CT1_CONTA "
			cQuery += "WHERE CT1C1.D_E_L_E_T_ <> '*') AS VRCRESINT1, "

			cQuery += "(SELECT SUM(CT2D2.CT2_VALOR) "
			cQuery += "FROM " + RetSqlName("CT1") + " CT1D2 "
			cQuery += "   LEFT JOIN " + RetSqlName("CT2") + " CT2D2 "
			cQuery += "      ON CT2D2.D_E_L_E_T_ <> '*' AND CT2D2.CT2_FILIAL = '" + cFilAnt + "' AND CT1D2.CT1_CONTA = CT2D2.CT2_DEBITO AND CT2D2.CT2_DATA >= '" + DTOS(dDataIni) + "' AND CT2D2.CT2_DATA <= '" + DTOS(dDataFim) + "' AND SUBSTRING(CT1D2.CT1_CTASUP,1,4) = " + RetSqlName("CT1") + ".CT1_CONTA "
			cQuery += "WHERE CT1D2.D_E_L_E_T_ <> '*') AS VRDEBSINT2, "

			cQuery += "(SELECT SUM(CT2C2.CT2_VALOR) "
			cQuery += "FROM " + RetSqlName("CT1") + " CT1C2 "
			cQuery += "   LEFT JOIN " + RetSqlName("CT2") + " CT2C2 "
			cQuery += "      ON CT2C2.D_E_L_E_T_ <> '*' AND CT2C2.CT2_FILIAL = '" + cFilAnt + "' AND CT1C2.CT1_CONTA = CT2C2.CT2_CREDIT AND CT2C2.CT2_DATA >= '" + DTOS(dDataIni) + "' AND CT2C2.CT2_DATA <= '" + DTOS(dDataFim) + "' AND SUBSTRING(CT1C2.CT1_CTASUP,1,4) = " + RetSqlName("CT1") + ".CT1_CONTA "
			cQuery += "WHERE CT1C2.D_E_L_E_T_ <> '*') AS VRCRESINT2, "

			cQuery += "(SELECT SUM(CT2D3.CT2_VALOR) "
			cQuery += "FROM " + RetSqlName("CT1") + " CT1D3 "
			cQuery += "   LEFT JOIN " + RetSqlName("CT2") + " CT2D3 "
			cQuery += "      ON CT2D3.D_E_L_E_T_ <> '*' AND CT2D3.CT2_FILIAL = '" + cFilAnt + "' AND CT1D3.CT1_CONTA = CT2D3.CT2_DEBITO AND CT2D3.CT2_DATA >= '" + DTOS(dDataIni) + "' AND CT2D3.CT2_DATA <= '" + DTOS(dDataFim) + "' AND SUBSTRING(CT1D3.CT1_CTASUP,1,2) = " + RetSqlName("CT1") + ".CT1_CONTA "
			cQuery += "WHERE CT1D3.D_E_L_E_T_ <> '*') AS VRDEBSINT3, "

			cQuery += "(SELECT SUM(CT2C3.CT2_VALOR) "
			cQuery += "FROM " + RetSqlName("CT1") + " CT1C3 "
			cQuery += "   LEFT JOIN " + RetSqlName("CT2") + " CT2C3 "
			cQuery += "      ON CT2C3.D_E_L_E_T_ <> '*' AND CT2C3.CT2_FILIAL = '" + cFilAnt + "' AND CT1C3.CT1_CONTA = CT2C3.CT2_CREDIT AND CT2C3.CT2_DATA >= '" + DTOS(dDataIni) + "' AND CT2C3.CT2_DATA <= '" + DTOS(dDataFim) + "' AND SUBSTRING(CT1C3.CT1_CTASUP,1,2) = " + RetSqlName("CT1") + ".CT1_CONTA "
			cQuery += "WHERE CT1C3.D_E_L_E_T_ <> '*') AS VRCRESINT3, "

			cQuery += "(SELECT SUM(CT2D4.CT2_VALOR) "
			cQuery += "FROM " + RetSqlName("CT1") + " CT1D4 "
			cQuery += "   LEFT JOIN " + RetSqlName("CT2") + " CT2D4 "
			cQuery += "      ON CT2D4.D_E_L_E_T_ <> '*' AND CT2D4.CT2_FILIAL = '" + cFilAnt + "' AND CT1D4.CT1_CONTA = CT2D4.CT2_DEBITO AND CT2D4.CT2_DATA >= '" + DTOS(dDataIni) + "' AND CT2D4.CT2_DATA <= '" + DTOS(dDataFim) + "' AND SUBSTRING(CT1D4.CT1_CTASUP,1,1) = " + RetSqlName("CT1") + ".CT1_CONTA "
			cQuery += "WHERE CT1D4.D_E_L_E_T_ <> '*') AS VRDEBSINT4, "

			cQuery += "(SELECT SUM(CT2C4.CT2_VALOR) "
			cQuery += "FROM " + RetSqlName("CT1") + " CT1C4 "
			cQuery += "   LEFT JOIN " + RetSqlName("CT2") + " CT2C4 "
			cQuery += "      ON CT2C4.D_E_L_E_T_ <> '*' AND CT2C4.CT2_FILIAL = '" + cFilAnt + "' AND CT1C4.CT1_CONTA = CT2C4.CT2_CREDIT AND CT2C4.CT2_DATA >= '" + DTOS(dDataIni) + "' AND CT2C4.CT2_DATA <= '" + DTOS(dDataFim) + "' AND SUBSTRING(CT1C4.CT1_CTASUP,1,1) = " + RetSqlName("CT1") + ".CT1_CONTA "
			cQuery += "WHERE CT1C4.D_E_L_E_T_ <> '*') AS VRCRESINT4 "

			cQuery += "FROM " + RetSqlName("CT1") + " "
			cQuery += "   LEFT JOIN " + RetSqlName("CT2") + " "
			cQuery += "      ON " + RetSqlName("CT2") + ".D_E_L_E_T_ <> '*' AND CT2_FILIAL = '" + cFilAnt + "' AND (CT1_CONTA = CT2_DEBITO OR CT1_CONTA = CT2_CREDIT) AND CT2_DATA >= '" + DTOS(dDataIni) + "' AND CT2_DATA <= '" + DTOS(dDataFim) + "' "
			cQuery += "WHERE " + RetSqlName("CT1") + ".D_E_L_E_T_ <> '*' "
			If !Empty(cContaIni) .and. !Empty(cContaFim)
				cQuery += "AND CT1_CONTA >= '" + cContaIni + "' AND CT1_CONTA <= '" + cContaFim + "' "
			EndIf	
			cQuery += "GROUP BY CT1_CONTA, CT1_CTLALU, CT1_DESC01, CT1_RES, CT1_CTASUP, CT2_FILIAL "
			cQuery += "ORDER BY CT1_CONTA "

			cQuery := ChangeQuery(cQuery)
			If SELECT('ZQB') <> 0
				ZQB->(dbCloseArea())
			Endif
			TCQUERY cQuery NEW ALIAS "ZQB"

			If !ApOleClient("MSExcel")
				MsgAlert("Microsoft Excel não instalado!")
				Return Nil
			EndIf

			ProcRegua(ZQB->(RecCount()))	

			While ZQB->(!EOF()) 

				IncProc()

				If Len(ALLTRIM(ZQB->CT1_CONTA)) == 1
					Aadd(aItens, CHR(160) + ZQB->CT1_CONTA)
				EndIf	                   
				If Len(ALLTRIM(ZQB->CT1_CONTA)) == 2
					Aadd(aItens, CHR(160) + SubStr(ZQB->CT1_CONTA,1,1) + "." + SubStr(ZQB->CT1_CONTA,2,1))
				EndIf	                   
				If Len(ALLTRIM(ZQB->CT1_CONTA)) == 4
					Aadd(aItens, CHR(160) + SubStr(ZQB->CT1_CONTA,1,1) + "." + SubStr(ZQB->CT1_CONTA,2,1) + "." + SubStr(ZQB->CT1_CONTA,3,2))
				EndIf	
				If Len(ALLTRIM(ZQB->CT1_CONTA)) == 6
					Aadd(aItens, CHR(160) + SubStr(ZQB->CT1_CONTA,1,1) + "." + SubStr(ZQB->CT1_CONTA,2,1) + "." + SubStr(ZQB->CT1_CONTA,3,2) + "." + SubStr(ZQB->CT1_CONTA,5,2))
				EndIf	
				If Len(ALLTRIM(ZQB->CT1_CONTA)) == 9
					Aadd(aItens, CHR(160) + SubStr(ZQB->CT1_CONTA,1,1) + "." + SubStr(ZQB->CT1_CONTA,2,1) + "." + SubStr(ZQB->CT1_CONTA,3,2) + "." + SubStr(ZQB->CT1_CONTA,5,2)+ "." + SubStr(ZQB->CT1_CONTA,7,3))
				EndIf	

				Aadd(aItens, CHR(160) + ZQB->CT1_DESC01)

				If ZQB->VALORDEB       <> 0 .or. ZQB->VALORCRED  <> 0
					Aadd(aItens, ZQB->VALORDEB   - ZQB->VALORCRED)
				ElseIf ZQB->VRDEBSINT1 <> 0 .or. ZQB->VRCRESINT1 <> 0
					Aadd(aItens, ZQB->VRDEBSINT1 - ZQB->VRCRESINT1)
				ElseIf ZQB->VRDEBSINT2 <> 0 .or. ZQB->VRCRESINT2 <> 0
					Aadd(aItens, ZQB->VRDEBSINT2 - ZQB->VRCRESINT2)
				ElseIf ZQB->VRDEBSINT3 <> 0 .or. ZQB->VRCRESINT3 <> 0
					Aadd(aItens, ZQB->VRDEBSINT3 - ZQB->VRCRESINT3)
				ElseIf ZQB->VRDEBSINT4 <> 0 .or. ZQB->VRCRESINT4 <> 0
					Aadd(aItens, ZQB->VRDEBSINT4 - ZQB->VRCRESINT4)
				Else
					Aadd(aItens, 0)
				EndIf	

				Aadd(aItens, ZQB->CT1_CONTA)
				Aadd(aItens, ZQB->CT1_CTASUP)          
				Aadd(aItens, ZQB->CT2_FILIAL)

				Aadd(aDadosBFC, aItens)
				aItens := {}

				ZQB->(dbSkip())

			EndDo

			ZQB->(dbCloseArea())

			// Estrutura da tabela temporaria
			Aadd(aCampos, "CT1_CONTA")
			Aadd(aCampos, "CT1_DESC01")
			Aadd(aCampos, "CT1_CTASUP")
			Aadd(aCampos, "CT2_FILIAL")

			For nCount := 1 to Len(aCampos)
				aTamSx3 := TamSx3(aCampos[nCount])
				Aadd(aBalFinCol, {aCampos[nCount], aTamSx3[3], aTamSx3[1], aTamSx3[2]})
			Next

			Aadd(aBalFinCol, {"MOVPERIODO","N",16,2})
			Aadd(aBalFinCol, {"SALDOATUAL","N",16,2})
			Aadd(aBalFinCol, {"CONTAMASK","C",20,0})

			If SELECT("ZTB") <> 0
				ZTB->(dbCloseArea())
			EndIf
			// Cria a tabela temporária
			cArqTrab := CriaTrab(aBalFinCol,.T.)
			MsCreate(cArqTrab, aBalFinCol, "DBFCDX")
			// Atribui a tabela temporária ao alias ZTB
			dbUseArea(.T., "DBFCDX", cArqTrab, "ZTB", .T., .F.)
			dbSelectArea("ZTB")

			_cNArq1:= cArqTrab + "1.ntx"
			Index on CT1_CONTA To &_cNArq1
			Set Index to &_cNArq1

			// Copia do array para a tabela temporária
			If cCombo1 == "NÃO"
				nOpcPosAnt := 0
			EndIf
			If cCombo1 == "SIM"	
				nOpcPosAnt := 1
			EndIf
			For nCount2 := 1 to Len(aDadosBFC)
				RECLOCK("ZTB", .T.)             
				ZTB->CT2_FILIAL := aDadosBFC[nCount2][6]
				ZTB->CT1_CONTA 	:= aDadosBFC[nCount2][4]
				ZTB->CT1_DESC01	:= aDadosBFC[nCount2][2]
				ZTB->MOVPERIODO	:= aDadosBFC[nCount2][3]
				ZTB->SALDOATUAL := SaldoConta(aDadosBFC[nCount2][4], dDataFim, "01", "1", 1, nOpcPosAnt, dDataApur)
				ZTB->SALDOATUAL := ZTB->SALDOATUAL - ZTB->SALDOATUAL - ZTB->SALDOATUAL
				ZTB->CT1_CTASUP := aDadosBFC[nCount2][5]
				ZTB->CONTAMASK  := aDadosBFC[nCount2][1]
				ZTB->(MSUNLOCK())
			Next

			aDadosFBC := {}

			//SOMA O SALDO ATUAL DAS CONTAS ANALÍTICAS PARA JOGAR NAS RESPECTIVAS CONTAS SINTÉTICAS
			dbSelectArea("ZTB")
			ZTB->(dbSetOrder(1))
			ZTB->(dbgotop())   
			While ZTB->(!EOF())
				If Len(ALLTRIM(ZTB->CT1_CONTA)) == 9 .and. ZTB->SALDOATUAL <> 0 
					nValorSint := nValorSint + ZTB->SALDOATUAL
				EndIf		
				cFilialAnt := ZTB->CT2_FILIAL
				cChaveAnt  := ZTB->CT1_CONTA
				cCtaSupAnt := ALLTRIM(ZTB->CT1_CTASUP)
				ZTB->(dbSkip())
				If VAL(cCtaSupAnt) <> VAL(ZTB->CT1_CTASUP) .and. Len(ALLTRIM(cChaveAnt)) == 9
					Aadd(aSaldoSint, {cCtaSupAnt, nValorSint, cFilialAnt})
					nValorSint := 0
				EndIf
			EndDo   

			For nCount3 := 1 to Len(aSaldoSint)
				If Len(ALLTRIM(aSaldoSint[nCount3][1])) == 6 .and. aSaldoSint[nCount3][2] <> 0
					nValorSint := nValorSint + aSaldoSint[nCount3][2]                         
				EndIf	
				cFilialAnt := aSaldoSint[nCount3][3]
				cChaveAnt  := aSaldoSint[nCount3][1]
				cCtaSupAnt := SubStr(aSaldoSint[nCount3][1],1,4)
				If nCount3 < Len(aSaldoSint)
					If VAL(cCtaSupAnt) <> VAL(SubStr(aSaldoSint[nCount3+1][1],1,4)).and. Len(ALLTRIM(cChaveAnt)) == 6
						Aadd(aSaldoSint, {cCtaSupAnt, nValorSint, cFilialAnt})
						nValorSint := 0
					EndIf                       
				EndIf
			Next

			For nCount3 := 1 to Len(aSaldoSint)
				If Len(ALLTRIM(aSaldoSint[nCount3][1])) == 4 .and. aSaldoSint[nCount3][2] <> 0
					nValorSint := nValorSint + aSaldoSint[nCount3][2] 
				EndIf		
				cFilialAnt := aSaldoSint[nCount3][3]
				cChaveAnt  := aSaldoSint[nCount3][1]
				cCtaSupAnt := SubStr(aSaldoSint[nCount3][1],1,2)
				If nCount3 < Len(aSaldoSint)
					If VAL(cCtaSupAnt) <> VAL(SubStr(aSaldoSint[nCount3+1][1],1,2)) .and. Len(ALLTRIM(cChaveAnt)) == 4
						Aadd(aSaldoSint, {cCtaSupAnt, nValorSint, cFilialAnt})
						nValorSint := 0
					EndIf                       
				EndIf
			Next

			For nCount3 := 1 to Len(aSaldoSint)
				If Len(ALLTRIM(aSaldoSint[nCount3][1])) == 2 .and. aSaldoSint[nCount3][2] <> 0
					nValorSint := nValorSint + aSaldoSint[nCount3][2] 
				EndIf		
				cFilialAnt := aSaldoSint[nCount3][3]
				cChaveAnt  := aSaldoSint[nCount3][1]
				cCtaSupAnt := SubStr(aSaldoSint[nCount3][1],1,1)
				If nCount3 < Len(aSaldoSint)
					If VAL(cCtaSupAnt) <> VAL(SubStr(aSaldoSint[nCount3+1][1],1,1)).and. Len(ALLTRIM(cChaveAnt)) == 2
						Aadd(aSaldoSint, {cCtaSupAnt, nValorSint, cFilialAnt})
						nValorSint := 0
					EndIf       
				EndIf
			Next         

			For nCount3 := 1 to Len(aSaldoSint)
				If ZTB->(dbSeek(ALLTRIM(aSaldoSint[nCount3][1])))
					RECLOCK("ZTB", .F.)
					ZTB->SALDOATUAL := aSaldoSint[nCount3][2] 
					ZTB->CT2_FILIAL := aSaldoSint[nCount3][3] 
					ZTB->(MSUNLOCK())
				EndIf
			Next	

			aSaldoSint := {}       

			dbSelectArea("ZTB")
			ZTB->(dbSetOrder(1))
			ZTB->(dbgotop())   
			While ZTB->(!EOF())
				Aadd(aItens, CHR(160) + cFilAnt)
				Aadd(aItens, ZTB->CONTAMASK)
				Aadd(aItens, ZTB->CT1_DESC01)
				Aadd(aItens, Transform(ZTB->MOVPERIODO, "@E 999,999,999.99"))    
				Aadd(aItens, Transform(ZTB->SALDOATUAL, "@E 999,999,999.99"))    
				Aadd(aDados, aItens)
				aItens := {}
				ZTB->(dbSkip())
			EndDo   

		EndIf

	Next                   

	//MONTA O ARRAY DO CABEÇALHO QUE SERÁ PASSADO PARA O EXCEL DE FORMA DINÂMICA, PELAS FILIAIS SELECIONADAS
	Aadd(aCabec, "CONTA")
	Aadd(aCabec, "DESCRIÇÃO")
	For nCount4 := 1 to Len(_aItens)
		If _aItens[nCount4][1] == .T.
			nFiliais := nFiliais + 1
			Aadd(aCabec, "MOV. PER. - " + _aItens[nCount4][2])
		EndIf
	Next
	For nCount4 := 1 to Len(_aItens) 
		If _aItens[nCount4][1] == .T.
			Aadd(aCabec, "SD. ATUAL - " + _aItens[nCount4][2])
		EndIf
	Next

	//PASSA OS DADOS PARA OUTRO ARRAY, JOGANDO VALOR ZERO PARA AS POSIÇÕES NÃO ALIMENTADAS
	aItens := {}
	For nCount4 := 1 to Len(aDados)
		nPosItem := Ascan(aDados2, {|x|x[1] == aDados[nCount4][2]})
		If nPosItem == 0
			Aadd(aItens, aDados[nCount4][2]) // cod
			Aadd(aItens, aDados[nCount4][3]) // desc
			Aadd(aItens, aDados[nCount4][4]) // mov.
			Aadd(aItens, aDados[nCount4][5]) // saldo
			Aadd(aDados2, aItens)
			aItens := {}
		Else
			Aadd(aDados2[nPosItem], aDados[nCount4][4])
			Aadd(aDados2[nPosItem], aDados[nCount4][5])
		EndIf
	Next

	cFilAnt := cFilAtual

	//JOGA PARA OUTRO ARRAY INVERTENDO A ORDEM DAS COLUNAS PARA DEIXAR AS COLUNAS DE MOV. E SALDO, LADO A LADO POR FILIAL
	aItens := {}
	For nCount4 := 1 to Len(aDados2)               
		Aadd(aItens, aDados2[nCount4][01]) // cod
		Aadd(aItens, aDados2[nCount4][02]) // desc
		Aadd(aItens, aDados2[nCount4][03]) // mov.1
		For nCount5 := 1 to nFiliais - 1	
			If Len(aDados2[nCount4]) >= 03 + (nCount5 * 2)
				Aadd(aItens, aDados2[nCount4][03 + (nCount5 * 2)]) // mov.2/3/4/5/etc ...
			Else
				Aadd(aItens, 0)
			EndIf	
		Next	
		Aadd(aItens, aDados2[nCount4][04]) // saldo1
		For nCount5 := 1 to nFiliais -1	
			If Len(aDados2[nCount4]) >= 04 + (nCount5 * 2)
				Aadd(aItens, aDados2[nCount4][04 + (nCount5 * 2)]) // saldo2/3/4/5/etc...
			Else
				Aadd(aItens, 0)
			EndIf	
		Next	
		Aadd(aDados3, aItens)
		aItens := {}
	Next	

	//ORGANIZA POR CONTA
	Asort(aDados3, , , {|x, y| y[1] > x[1]})

	//DELETA AS LINHAS DO ARRAY QUE ESTIVER COM TODOS OS VALORES DA CONTA ZERADA
	For nCount5 := 1 to Len(aDados3)
		If nCount5 <= Len(aDados3)
			lCtaZerada := .T.
			For nCount6 := 3 to Len(aDados3[nCount5])
				If Val(aDados3[nCount5][nCount6]) <> 0
					lCtaZerada := .F.
				EndIf
			Next
			If lCtaZerada == .T.
				ADel(aDados3, nCount5)
				Asize(aDados3, Len(aDados3) - 1)
				nCount5 := nCount5 - 1
			EndIf	
		EndIf
	Next

	cTitulo := "Empresa: " + ALLTRIM(SM0->M0_NOMECOM) + " - Unidade: " + ALLTRIM(FWFILIALNAME(SUBSTR(xFilial("CT2"),1,2), xFilial("CT2"), 1)) + " | Mês: " + cAnoMes + " | Pos. Ant. L/P?: " + cCombo1 + " | Data L/P: " + DTOC(dDataApur)

	DlgToExcel({ {"ARRAY", cTitulo, aCabec, aDados3} })

	ZTB->(dbCloseArea())

Return	            

Static Function SelectAll()

	Local nCount := 0
	For nCount := 1 to Len(_aItens)
		_aItens[nCount,1] := !_aItens[nCount,1]
	Next		
	_oFilSelec:Refresh()

Return