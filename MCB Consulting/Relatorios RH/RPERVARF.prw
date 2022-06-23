#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"

/*------------------------------------------------------------------------------------------------------------------------------------------------*\
| Fonte:	 |	RPERVARF.PRW                                                                                                                       |
| Autor:	 |	Djalma Borges                                                                                                                      |
| Data:		 |	03/03/2016                                                                                                                         |
| Descrição: |	Relatório de Percentual de Variação de Folha de Pagamento Mês atual / Mês Anterior por evento - EXCEL 							   |
\*------------------------------------------------------------------------------------------------------------------------------------------------*/

User Function RPERVARF()

	Local oDlg

	Local oAnoMes1
	Local cAnoMes1 := Space(6)
	Local oAnoMes2
	Local cAnoMes2 := Space(6)

	Local oFilIni
	Local cFilIni := Space(5)
	Local oFilFim
	Local cFilFim := Space(5)

	Local oBtnOk
	Local oBtnCancel

	Define MSDialog oDlg Title "PERCENTUAL VARIAÇÃO FOLHA" From 0,0 To 250,300 Pixel

	@10,10 Say "FILIAL INI: " Pixel Of oDlg
	@10,60 MSGet oFilIni Var cFilIni Size 20,10 Pixel Of oDlg

	@25,10 Say "FILIAL FIM: " Pixel Of oDlg
	@25,60 MSGet oFilFim Var cFilFim Size 20,10 Pixel Of oDlg

	@45,10 Say "ANO1 + MÊS1: " Pixel Of oDlg
	@45,60 MSGet oAnoMes1 Var cAnoMes1 Size 50,10 Pixel Of oDlg

	@60,10 Say "ANO2 + MÊS2: " Pixel Of oDlg
	@60,60 MSGet oAnoMes2 Var cAnoMes2 Size 50,10 Pixel Of oDlg

	@85,10 Button oBtnOk     Prompt "Ok"       Size 30,15 Pixel Action {||U_AgPeVaFo(cAnoMes1, cAnoMes2, cFilIni, cFilFim), oDlg:End()} Of oDlg
	@85,70 Button oBtnCancel Prompt "Cancelar" Size 30,15 Pixel Action {||oDlg:End()} Of oDlg

	Activate MSDialog oDlg Centered

Return

User Function AgPeVaFo(cAnoMes1, cAnoMes2, cFilIni, cFilFim)

	Processa( {|| U_ProcRPVF(cAnoMes1, cAnoMes2, cFilIni, cFilFim) }, "Aguarde...", "Exportando dados para o Excel...",.F.)

Return

User Function ProcRPVF(cAnoMes1, cAnoMes2, cFilIni, cFilFim)

	Local aCabec := {}
	Local aDados := {}
	Local aItens := {}
	Local cTitulo := ""
	Local aRePerVarF := {}
	Local aRPerVarF2 := {}
	Local cArqTrab := ""
	Local aTamSX3 := {}
	Local aCampos := {}
	Local aCampos2 := {}
	Local nCount := ""

	Local cQryFolha := ""
	Local cQryFolha2 := ""
	Local cQryFer1  := ""
	Local cQryFer2  := ""
	Local cQryDecT1 := ""
	Local cQryDecT2 := ""

	Local lFilIniEx := .F.
	Local lFilFimEx := .F.

	Local cPdAnter   := ""
	Local cProvDescA := ""

	Local nProvMes1 := 0
	Local nProvMes2 := 0
	Local nPercProv := 0
	Local nDescMes1 := 0
	Local nDescMes2 := 0
	Local nPercDesc := 0
	Local nSaldoMes1 := 0
	Local nSaldoMes2 := 0
	Local nPercSaldo := 0

	Local nProvAcF1 := 0
	Local nProvAcF2 := 0
	Local nProvAcD1 := 0
	Local nProvAcD2 := 0

	Local cDataCal := ""
	Local dFechaMes := Date()   

	Local aQueryZTF := {}
	Local aItemQry := {}

	If Empty(cAnoMes1)
		MsgAlert("ANO1 + MÊS1 não infomado.")	
		Return
	EndIf

	If Empty(cAnoMes2)
		MsgAlert("ANO2 + MÊS2 não infomado.")	
		Return
	EndIf

	dbSelectArea("SM0")
	SM0->(dbGoTop())
	While SM0->(!EOF())
		If SM0->M0_CODIGO == cEmpAnt .and. ALLTRIM(SM0->M0_CODFIL) == ALLTRIM(cFilIni)
			lFilIniEx := .T.
			Exit
		EndIf
		SM0->(dbSkip())
	EndDo	
	If lFilIniEx == .F. .and. cFilIni <> "     "
		MsgAlert("FILIAL INI INVÁLIDA")
		Return
	EndIf	           

	SM0->(dbGoTop())
	While SM0->(!EOF())
		If SM0->M0_CODIGO == cEmpAnt .and. ALLTRIM(SM0->M0_CODFIL) == ALLTRIM(cFilFim)
			lFilFimEx := .T.
			Exit
		EndIf
		SM0->(dbSkip())
	EndDo	
	If lFilFimEx == .F. .and. cFilFim <> "     "
		MsgAlert("FILIAL FIM INVÁLIDA")
		Return
	EndIf

	cQryFolha := "SELECT "
	cQryFolha += "CASE WHEN " 
	cQryFolha += "(RD_PD >= '" + GetMV("ZZ_SRVINIP") + "' AND RD_PD <= '" + GetMV("ZZ_SRVFIMP") + "') OR  "
	cQryFolha += "(RD_PD >= '" + GetMV("ZZ_SRVINIB") + "' AND RD_PD <= '" + GetMV("ZZ_SRVFIMB") + "') "
	cQryFolha += "THEN 'P' ELSE 'D' END AS PROVDESC, "
	cQryFolha += "RD_FILIAL, RD_PD, RV_DESC, RD_DATARQ, RD_VALOR "
	cQryFolha += "FROM " + RetSqlName("SRD") + " "
	cQryFolha += "LEFT JOIN " + RetSqlName("SRV") + " ON RD_PD = RV_COD AND " + RetSqlName("SRV") + ".D_E_L_E_T_ <> '*' "
	cQryFolha += "WHERE RD_DATARQ = '" + cAnoMes1 + "' AND "
	If !Empty(cFilIni) .and. !Empty(cFilFim) 
		cQryFolha += "RD_FILIAL >= '" + cFilIni + "' AND RD_FILIAL <= '" + cFilFim + "' "
	Else
		cQryFolha += "RD_FILIAL = '" + xFilial("SRD") + "' "
	EndIf	                                                       
	cQryFolha += "AND RD_PD NOT IN " + FORMATIN(GETMV("ZZ_VERBNOT"), "|") + " "
	cQryFolha += "AND " + RetSqlName("SRD") + ".D_E_L_E_T_ <> '*' "
	cQryFolha += "ORDER BY PROVDESC DESC, RD_PD, RD_DATARQ, RD_FILIAL"
	cQryFolha := ChangeQuery(cQryFolha)
	If SELECT('ZQF') <> 0
		ZQF->(dbCloseArea())
	Endif
	TCQUERY cQryFolha NEW ALIAS "ZQF"

	cQryFolha2 := "SELECT "
	cQryFolha2 += "CASE WHEN " 
	cQryFolha2 += "(RC_PD >= '" + GetMV("ZZ_SRVINIP") + "' AND RC_PD <= '" + GetMV("ZZ_SRVFIMP") + "') OR  "
	cQryFolha2 += "(RC_PD >= '" + GetMV("ZZ_SRVINIB") + "' AND RC_PD <= '" + GetMV("ZZ_SRVFIMB") + "') "
	cQryFolha2 += "THEN 'P' ELSE 'D' END AS PROVDESC, "
	cQryFolha2 += "RC_FILIAL, RC_PD, RV_DESC, RC_DATA, RC_VALOR "
	cQryFolha2 += "FROM " + RetSqlName("SRC") + " "
	cQryFolha2 += "LEFT JOIN " + RetSqlName("SRV") + " ON RC_PD = RV_COD AND " + RetSqlName("SRV") + ".D_E_L_E_T_ <> '*' "
	cQryFolha2 += "WHERE "
	If !Empty(cFilIni) .and. !Empty(cFilFim) 
		cQryFolha2 += "RC_FILIAL >= '" + cFilIni + "' AND RC_FILIAL <= '" + cFilFim + "' "
	Else
		cQryFolha2 += "RC_FILIAL = '" + xFilial("SRC") + "' "
	EndIf	                                                       
	cQryFolha2 += "AND RC_PD NOT IN " + FORMATIN(GETMV("ZZ_VERBNOT"), "|") + " "
	cQryFolha2 += "AND " + RetSqlName("SRC") + ".D_E_L_E_T_ <> '*' "
	cQryFolha2 += "ORDER BY PROVDESC DESC, RC_PD, RC_DATA, RC_FILIAL"
	cQryFolha2 := ChangeQuery(cQryFolha2)
	If SELECT('ZQ2') <> 0
		ZQ2->(dbCloseArea())
	Endif
	TCQUERY cQryFolha2 NEW ALIAS "ZQ2"

	cDataCal := "01/" + SubStr(cAnoMes1,5,2) + "/" + SubStr(cAnoMes1,1,4)
	dFechaMes := LastDate(CTOD(cDataCal))
	cQryFer1 := "SELECT SUM(RT_VALOR) AS FERIAS1 "
	cQryFer1 += "FROM " + RetSqlName("SRT") + " "
	cQryFer1 += "WHERE RT_VERBA = '" + GETMV("ZZ_RHPROVF") + "' AND RT_DATACAL = '" + DTOS(dFechaMes) + "' AND " + RetSqlName("SRT") + ".D_E_L_E_T_ <> '*' AND "
	If !Empty(cFilIni) .and. !Empty(cFilFim) 
		cQryFer1 += "RT_FILIAL >= '" + cFilIni + "' AND RT_FILIAL <= '" + cFilFim + "' "
	Else
		cQryFer1 += "RT_FILIAL = '" + xFilial("SRD") + "' "
	EndIf	                           
	cQryFer1 := ChangeQuery(cQryFer1)
	If SELECT('ZF1') <> 0
		ZF1->(dbCloseArea())
	Endif
	TCQUERY cQryFer1 NEW ALIAS "ZF1"

	cDataCal := "01/" + SubStr(cAnoMes2,5,2) + "/" + SubStr(cAnoMes2,1,4)
	dFechaMes := LastDate(CTOD(cDataCal))
	cQryFer2 := "SELECT SUM(RT_VALOR) AS FERIAS2 "
	cQryFer2 += "FROM " + RetSqlName("SRT") + " "
	cQryFer2 += "WHERE RT_VERBA = '" + GETMV("ZZ_RHPROVF") + "' AND RT_DATACAL = '" + DTOS(dFechaMes) + "' AND " + RetSqlName("SRT") + ".D_E_L_E_T_ <> '*' AND "
	If !Empty(cFilIni) .and. !Empty(cFilFim) 
		cQryFer2 += "RT_FILIAL >= '" + cFilIni + "' AND RT_FILIAL <= '" + cFilFim + "' "
	Else
		cQryFer2 += "RT_FILIAL = '" + xFilial("SRD") + "' "
	EndIf	                           
	cQryFer2 := ChangeQuery(cQryFer2)
	If SELECT('ZF2') <> 0
		ZF2->(dbCloseArea())
	Endif
	TCQUERY cQryFer2 NEW ALIAS "ZF2"

	cDataCal := "01/" + SubStr(cAnoMes1,5,2) + "/" + SubStr(cAnoMes1,1,4)
	dFechaMes := LastDate(CTOD(cDataCal))
	cQryDecT1 := "SELECT SUM(RT_VALOR) AS DECTER1 "
	cQryDecT1 += "FROM " + RetSqlName("SRT") + " "
	cQryDecT1 += "WHERE RT_VERBA = '" + GETMV("ZZ_RHPROVD") + "' AND RT_DATACAL = '" + DTOS(dFechaMes) + "' AND " + RetSqlName("SRT") + ".D_E_L_E_T_ <> '*' AND "
	If !Empty(cFilIni) .and. !Empty(cFilFim) 
		cQryDecT1 += "RT_FILIAL >= '" + cFilIni + "' AND RT_FILIAL <= '" + cFilFim + "' "
	Else
		cQryDecT1 += "RT_FILIAL = '" + xFilial("SRD") + "' "
	EndIf	                           
	cQryDecT1 := ChangeQuery(cQryDecT1)
	If SELECT('ZD1') <> 0
		ZD1->(dbCloseArea())
	Endif
	TCQUERY cQryDecT1 NEW ALIAS "ZD1"

	cDataCal := "01/" + SubStr(cAnoMes2,5,2) + "/" + SubStr(cAnoMes2,1,4)
	dFechaMes := LastDate(CTOD(cDataCal))
	cQryDecT2 := "SELECT SUM(RT_VALOR) AS DECTER2 "
	cQryDecT2 += "FROM " + RetSqlName("SRT") + " "
	cQryDecT2 += "WHERE RT_VERBA = '" + GETMV("ZZ_RHPROVD") + "' AND RT_DATACAL = '" + DTOS(dFechaMes) + "' AND " + RetSqlName("SRT") + ".D_E_L_E_T_ <> '*' AND "
	If !Empty(cFilIni) .and. !Empty(cFilFim) 
		cQryDecT2 += "RT_FILIAL >= '" + cFilIni + "' AND RT_FILIAL <= '" + cFilFim + "' "
	Else
		cQryDecT2 += "RT_FILIAL = '" + xFilial("SRD") + "' "
	EndIf	                           
	cQryDecT2 := ChangeQuery(cQryDecT2)
	If SELECT('ZD2') <> 0
		ZD2->(dbCloseArea())
	Endif
	TCQUERY cQryDecT2 NEW ALIAS "ZD2"

	If !ApOleClient("MSExcel")
		MsgAlert("Microsoft Excel não instalado!")
		Return Nil
	EndIf

	// Estrutura da tabela temporaria
	Aadd(aCampos, "RD_FILIAL")
	Aadd(aCampos, "RD_PD")
	Aadd(aCampos, "RV_DESC")
	Aadd(aCampos, "RD_DATARQ")
	Aadd(aCampos, "RD_VALOR")
	Aadd(aRePerVarF,{"PROVDESC","C",1,0})
	For nCount := 1 to Len(aCampos)
		aTamSx3 := TamSx3(aCampos[nCount])
		Aadd(aRePerVarF, {aCampos[nCount], aTamSx3[3], aTamSx3[1], aTamSx3[2]})
	Next
	If SELECT("ZTF") <> 0
		ZTF->(dbCloseArea())
	EndIf
	// Cria a tabela temporária
	cArqTrab := CriaTrab(aRePerVarF,.T.)
	MsCreate(cArqTrab, aRePerVarF, "DBFCDX")
	// Atribui a tabela temporária ao alias ZTF
	dbUseArea(.T., "DBFCDX", cArqTrab, "ZTF", .T., .F.)
	dbSelectArea("ZTF")       

	// Copia da query1 para a tabela temporária
	dbSelectArea("ZQF")
	ZQF->(dbGoTop())
	While ZQF->(!EOF())
		RECLOCK("ZTF", .T.)
		ZTF->PROVDESC 	:= ZQF->PROVDESC 	
		ZTF->RD_FILIAL 	:= ZQF->RD_FILIAL 	
		ZTF->RD_PD 		:= ZQF->RD_PD 		
		ZTF->RV_DESC	:= ZQF->RV_DESC 		
		ZTF->RD_DATARQ	:= ZQF->RD_DATARQ
		ZTF->RD_VALOR 	:= ZQF->RD_VALOR 	
		ZTF->(MSUNLOCK())
		ZQF->(dbSkip())
	EndDo		        
	ZQF->(dbCloseArea())

	// Copia da query2 para a tabela temporária
	dbSelectArea("ZQ2")
	ZQ2->(dbGoTop())
	While ZQ2->(!EOF())
		RECLOCK("ZTF", .T.)
		ZTF->PROVDESC 	:= ZQ2->PROVDESC 	
		ZTF->RD_FILIAL 	:= ZQ2->RC_FILIAL 	
		ZTF->RD_PD 		:= ZQ2->RC_PD
		ZTF->RV_DESC	:= ZQ2->RV_DESC
		ZTF->RD_DATARQ	:= SUBSTR(ZQ2->RC_DATA,1,6)
		ZTF->RD_VALOR 	:= ZQ2->RC_VALOR 	
		ZTF->(MSUNLOCK())
		ZQ2->(dbSkip())
	EndDo		
	ZQ2->(dbCloseArea()) 

	dbSelectArea("ZTF")
	ZTF->(dbGoTop())    
	While ZTF->(!EOF()) 
		Aadd(aItemQry, ZTF->PROVDESC)  // 1
		Aadd(aItemQry, ZTF->RD_FILIAL) // 2
		Aadd(aItemQry, ZTF->RD_PD)     // 3
		Aadd(aItemQry, ZTF->RV_DESC)   // 4
		Aadd(aItemQry, ZTF->RD_DATARQ) // 5
		Aadd(aItemQry, ZTF->RD_VALOR)  // 6
		Aadd(aQueryZTF, aItemQry)
		aItemQry := {}     
		ZTF->(dbSkip())
	EndDo

	aSort(aQueryZTF, , , {|X, Y| X[1] >  Y[1] .or. ;    
	X[1] == Y[1] .and. X[3] <  Y[3] .or. ;
	X[1] == Y[1] .and. X[3] == Y[3] .and. X[5] < Y[5] .or. ; 
	X[1] == Y[1] .and. X[3] == Y[3] .and. X[5] == Y[5] .and. X[2] < Y[2]})

	// Estrutura da tabela temporaria
	Aadd(aCampos2, "RD_FILIAL")
	Aadd(aCampos2, "RD_PD")
	Aadd(aCampos2, "RV_DESC")
	Aadd(aCampos2, "RD_DATARQ")
	Aadd(aCampos2, "RD_VALOR")
	Aadd(aRPerVarF2,{"PROVDESC","C",1,0})
	For nCount := 1 to Len(aCampos2)
		aTamSx3 := TamSx3(aCampos2[nCount])
		Aadd(aRPerVarF2, {aCampos2[nCount], aTamSx3[3], aTamSx3[1], aTamSx3[2]})
	Next
	If SELECT("ZTA") <> 0
		ZTA->(dbCloseArea())
	EndIf
	// Cria a tabela temporária
	cArqTrab := CriaTrab(aRPerVarF2,.T.)
	MsCreate(cArqTrab, aRPerVarF2, "DBFCDX")
	// Atribui a tabela temporária ao alias ZTA
	dbUseArea(.T., "DBFCDX", cArqTrab, "ZTA", .T., .F.)
	dbSelectArea("ZTA")

	// Copia do array para a tabela temporária
	For nCount := 1 to Len(aQueryZTF)
		RECLOCK("ZTA", .T.)
		ZTA->PROVDESC 	:= aQueryZTF[nCount][1] 	
		ZTA->RD_FILIAL 	:= aQueryZTF[nCount][2] 	
		ZTA->RD_PD 		:= aQueryZTF[nCount][3] 		
		ZTA->RV_DESC	:= aQueryZTF[nCount][4] 		
		ZTA->RD_DATARQ	:= aQueryZTF[nCount][5]
		ZTA->RD_VALOR 	:= aQueryZTF[nCount][6] 	
		ZTA->(MSUNLOCK())
	Next

	dbSelectArea("ZTA")
	ZTA->(dbGoTop())
	ProcRegua(RecCount())
	cProvDescA := ZTA->PROVDESC
	While ZTA->(!EOF()) 

		IncProc()       

		If ZTA->PROVDESC == "P"
			If ZTA->RD_DATARQ == cAnoMes1
				nProvMes1 := nProvMes1 + ZTA->RD_VALOR
			EndIf	
			If ZTA->RD_DATARQ == cAnoMes2
				nProvMes2 := nProvMes2 + ZTA->RD_VALOR
			EndIf	
		EndIf

		If ZTA->PROVDESC == "D"
			If ZTA->RD_DATARQ == cAnoMes1
				nDescMes1 := nDescMes1 + ZTA->RD_VALOR
			EndIf	
			If ZTA->RD_DATARQ == cAnoMes2
				nDescMes2 := nDescMes2 + ZTA->RD_VALOR
			EndIf	
		EndIf				

		cPdAnt := ZTA->RD_PD                      
		ZTA->(dbSkip())
		If ZTA->RD_PD <> cPdAnt

			ZTA->(dbSkip(-1))
			Aadd(aItens, CHR(160)+ZTA->RD_PD) 
			Aadd(aItens, CHR(160)+ZTA->RV_DESC)                

			nPercProv  := (nProvMes2 / nProvMes1 * 100) - 100
			If nProvMes2 == 0 
				nPercProv := -100
			EndIf
			If nProvMes1 == 0
				nPercProv := 100
			EndIf		
			If nProvMes2 == 0 .and. nProvMes1 == 0
				nPercProv := 0
			EndIf

			nPercDesc  := (nDescMes2 / nDescMes1 * 100) - 100
			If nDescMes2 == 0 
				nPercDesc := -100
			EndIf
			If nDescMes1 == 0
				nPercDesc := 100
			EndIf		
			If nDescMes2 == 0 .and. nDescMes1 == 0
				nPercDesc := 0
			EndIf

			Aadd(aItens, Transform(nProvMes1, "@E 999,999.99"))
			Aadd(aItens, Transform(nProvMes2, "@E 999,999.99"))
			Aadd(aItens, Transform(nPercProv, "@E 999,999.99"))
			Aadd(aItens, Transform(nDescMes1, "@E 999,999.99"))
			Aadd(aItens, Transform(nDescMes2, "@E 999,999.99"))
			Aadd(aItens, Transform(nPercDesc, "@E 999,999.99"))

			Aadd(aDados, aItens)

			aItens := {}

			nProvMes1  := 0
			nProvMes2  := 0
			nPercProv  := 0
			nDescMes1  := 0
			nDescMes2  := 0
			nPercDesc  := 0
			nPercSaldo := 0

		Else
			ZTA->(dbSkip(-1))		
		EndIf

		cProvDescA := ZTA->PROVDESC
		ZTA->(dbSkip())	
		If ZTA->PROVDESC <> cProvDescA
			ZTA->(dbSkip(-1))
			Aadd(aItens, CHR(160)+"") 
			Aadd(aItens, CHR(160)+"")                
			Aadd(aItens, CHR(160)+"")
			Aadd(aItens, CHR(160)+"")
			Aadd(aItens, CHR(160)+"")
			Aadd(aItens, CHR(160)+"")
			Aadd(aItens, CHR(160)+"")
			Aadd(aItens, CHR(160)+"")
			Aadd(aDados, aItens)
			aItens := {}	 
		Else
			ZTA->(dbSkip(-1))	
		EndIf	       

		ZTA->(dbSkip())	

	EndDo

	Aadd(aItens, CHR(160)+GETMV("ZZ_RHPROVF")) 
	Aadd(aItens, CHR(160)+POSICIONE("SRV",1,xFilial("SRV")+GETMV("ZZ_RHPROVF"),"RV_DESC"))                
	Aadd(aItens, Transform(ZF1->FERIAS1, "@E 999,999.99"))
	Aadd(aItens, Transform(ZF2->FERIAS2, "@E 999,999.99"))
	Aadd(aItens, Transform((ZF2->FERIAS2 / ZF1->FERIAS1 * 100) - 100, "@E 999,999.99"))
	Aadd(aItens, 0) 
	Aadd(aItens, 0)                
	Aadd(aItens, 0)
	Aadd(aDados, aItens)
	aItens := {}

	Aadd(aItens, CHR(160)+GETMV("ZZ_RHPROVD")) 
	Aadd(aItens, CHR(160)+POSICIONE("SRV",1,xFilial("SRV")+GETMV("ZZ_RHPROVD"),"RV_DESC"))                
	Aadd(aItens, Transform(ZD1->DECTER1, "@E 999,999.99"))
	Aadd(aItens, Transform(ZD2->DECTER2, "@E 999,999.99"))
	Aadd(aItens, Transform((ZD2->DECTER2 / ZD1->DECTER1 * 100) - 100, "@E 999,999.99"))
	Aadd(aItens, 0) 
	Aadd(aItens, 0)                
	Aadd(aItens, 0)
	Aadd(aDados, aItens)
	aItens := {}

	Aadd(aCabec, "COD")
	Aadd(aCabec, "VERBA")
	Aadd(aCabec, "PROV M1 (R$)")
	Aadd(aCabec, "PROV M2 (R$)")
	Aadd(aCabec, "PROV M2/M1 (%)")
	Aadd(aCabec, "DESC M1 (R$)")
	Aadd(aCabec, "DESC M2 (R$)")
	Aadd(aCabec, "DESC M2/M1 (%)")

	cTitulo := "Empresa: " + ALLTRIM(SM0->M0_NOMECOM) + " - Unidade: " + ALLTRIM(FWFILIALNAME(SUBSTR(xFilial("SRD"),1,2), xFilial("SRD"), 1)) + " | Filial Ini: " + cFilIni + " - Filial Fim: " + cFilFim + " | Mês 1: " + cAnoMes1 + " | Mês 2: " + cAnoMes2 + " | "

	DlgToExcel({ {"ARRAY", cTitulo, aCabec, aDados} })

	// Apaga a tabela temporária
	ZTF->(dbCloseArea())
	ZF1->(dbCloseArea())
	ZF2->(dbCloseArea())
	ZD1->(dbCloseArea())
	ZD2->(dbCloseArea())
	ZTA->(dbCloseArea())

Return Nil  
