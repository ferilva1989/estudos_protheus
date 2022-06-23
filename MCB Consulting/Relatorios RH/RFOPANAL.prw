#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"

/*------------------------------------------------------------------------------------------------------------------------------------------------*\
| Fonte:	 |	RFOPANAL.PRW                                                                                                                       |
| Autor:	 |	Djalma Borges                                                                                                                      |
| Data:		 |	08/03/2016                                                                                                                         |
| Descrição: |	Relatório de Folha de Pagamento Analítica em Excel 													 							   |
\*------------------------------------------------------------------------------------------------------------------------------------------------*/

User Function RFOPANAL()

	Local oDlg

	Local oAnoMes
	Local cAnoMes := Space(6)

	Local oFilIni
	Local cFilIni := Space(5)
	Local oFilFim
	Local cFilFim := Space(5)

	Local oBtnOk
	Local oBtnCancel

	Define MSDialog oDlg Title "FOLHA PAGAMENTO ANALÍTICA" From 0,0 To 200,300 Pixel

	@10,10 Say "FILIAL INI: " Pixel Of oDlg
	@10,60 MSGet oFilIni Var cFilIni Size 20,10 Pixel Of oDlg

	@25,10 Say "FILIAL FIM: " Pixel Of oDlg
	@25,60 MSGet oFilFim Var cFilFim Size 20,10 Pixel Of oDlg

	@45,10 Say "ANO + MÊS: " Pixel Of oDlg
	@45,60 MSGet oAnoMes Var cAnoMes Size 50,10 Pixel Of oDlg

	@65,10 Button oBtnOk     Prompt "Ok"       Size 30,15 Pixel Action {||U_AgFoPaAn(cAnoMes, cFilIni, cFilFim), oDlg:End()} Of oDlg
	@65,70 Button oBtnCancel Prompt "Cancelar" Size 30,15 Pixel Action {||oDlg:End()} Of oDlg

	Activate MSDialog oDlg Centered

Return

User Function AgFoPaAn(cAnoMes, cFilIni, cFilFim)

	Processa( {|| U_ProcRFPA(cAnoMes, cFilIni, cFilFim) }, "Aguarde...", "Exportando dados para o Excel...",.F.)

Return

User Function ProcRFPA(cAnoMes, cFilIni, cFilFim)

	Local aCabec := {}
	Local aDados := {}
	Local aItens := {}
	Local cTitulo := ""
	Local aReFoPaAn := {}
	Local cArqTrab := ""
	Local aTamSX3 := {}
	Local aCampos := {}
	Local nCount := ""
	Local nCount2 := ""
	Local nCount3 := ""
	Local cQuery := ""
	Local lFilIniEx := .F.
	Local lFilFimEx := .F.  
	Local nValorPN := 0  
	Local lAcumVerba := .F.
	Local cCodAnt := ""    
	Local nPosItem := 0   
	Local nPosColuna := 0

	If Empty(cAnoMes)
		MsgAlert("ANO + MÊS não infomado.")	
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

	cQuery := "SELECT RD_FILIAL, RD_MAT, RA_NOME, RD_PD, RV_DESC, RD_VALOR, RD_DATARQ "
	cQuery += "FROM " + RetSqlName("SRD") + ", " + RetSqlName("SRA") + ", SRV010 "
	cQuery += "WHERE " + RetSqlName("SRD") + ".D_E_L_E_T_ <> '*' AND " + RetSqlName("SRA") + ".D_E_L_E_T_ <> '*' AND RD_MAT = RA_MAT AND RD_PD = RV_COD AND RD_DATARQ = '" + cAnoMes + "' AND "
	If !Empty(cFilIni) .and. !Empty(cFilFim) 
		cQuery += "RD_FILIAL >= '" + cFilIni + "' AND RD_FILIAL <= '" + cFilFim + "' "
	Else
		cQuery += "RD_FILIAL = '" + xFilial("SRD") + "' "
	EndIf	
	cQuery += "AND RD_PD NOT IN " + FORMATIN(GETMV("ZZ_VERBNOT"), "|") + " "
	cQuery += "ORDER BY RD_PD, RD_FILIAL, RA_NOME "

	cQuery := ChangeQuery(cQuery)
	If SELECT('ZQF') <> 0
		ZQF->(dbCloseArea())
	Endif
	TCQUERY cQuery NEW ALIAS "ZQF"

	If !ApOleClient("MSExcel")
		MsgAlert("Microsoft Excel não instalado!")
		Return Nil
	EndIf

	// Estrutura da tabela temporaria
	Aadd(aCampos, "RD_FILIAL")
	Aadd(aCampos, "RD_MAT")
	Aadd(aCampos, "RA_NOME")
	Aadd(aCampos, "RD_PD")
	Aadd(aCampos, "RV_DESC")
	Aadd(aCampos, "RD_VALOR")
	Aadd(aCampos, "RD_DATARQ")

	For nCount := 1 to Len(aCampos)
		aTamSx3 := TamSx3(aCampos[nCount])
		Aadd(aReFoPaAn, {aCampos[nCount], aTamSx3[3], aTamSx3[1], aTamSx3[2]})
	Next

	If SELECT("ZTF") <> 0
		ZTF->(dbCloseArea())
	EndIf
	// Cria a tabela temporária
	cArqTrab := CriaTrab(aReFoPaAn,.T.)
	MsCreate(cArqTrab, aReFoPaAn, "DBFCDX")
	// Atribui a tabela temporária ao alias ZTF
	dbUseArea(.T., "DBFCDX", cArqTrab, "ZTF", .T., .F.)
	dbSelectArea("ZTF")       

	// Copia da query para a tabela temporária
	dbSelectArea("ZQF")
	ZQF->(dbGoTop())
	While ZQF->(!EOF())
		RECLOCK("ZTF", .T.)
		ZTF->RD_FILIAL 	:= ZQF->RD_FILIAL 	
		ZTF->RD_MAT 	:= ZQF->RD_MAT 	
		ZTF->RA_NOME	:= ZQF->RA_NOME 		
		ZTF->RD_PD		:= ZQF->RD_PD 		
		ZTF->RV_DESC	:= ZQF->RV_DESC 		
		ZTF->RD_VALOR	:= ZQF->RD_VALOR
		ZTF->RD_DATARQ 	:= ZQF->RD_DATARQ 	
		ZTF->(MSUNLOCK())
		ZQF->(dbSkip())
	EndDo		

	ZQF->(dbCloseArea())

	dbSelectArea("ZTF")
	dbGoTop()
	ProcRegua(RecCount())

	Aadd(aCabec, "UNIDADE+NOME")
	Aadd(aCabec, "UNIDADE")
	Aadd(aCabec, "MATRÍCULA")
	Aadd(aCabec, "NOME")

	While ZTF->(!EOF()) 

		IncProc()       

		If lAcumVerba == .F.

			Aadd(aCabec, CHR(160) + ZTF->RD_PD + " - " + ZTF->RV_DESC )

			nPosItem := Ascan(aDados, {|x|x[3] == CHR(160)+ZTF->RD_MAT})

			If nPosItem == 0
				Aadd(aItens, CHR(160)+ZTF->RD_FILIAL+ZTF->RA_NOME) 
				Aadd(aItens, CHR(160)+ZTF->RD_FILIAL) 
				Aadd(aItens, CHR(160)+ZTF->RD_MAT) 
				Aadd(aItens, CHR(160)+ZTF->RA_NOME) 
				If (Val(ZTF->RD_PD) >= Val(GetMV("ZZ_SRVINIP")) .and. Val(ZTF->RD_PD) <= Val(GetMV("ZZ_SRVFIMP"))) .or. (Val(ZTF->RD_PD) >= Val(GetMV("ZZ_SRVINIB")) .and. Val(ZTF->RD_PD) <= Val(GetMV("ZZ_SRVFIMB")))
					nValorPN := ZTF->RD_VALOR
				EndIf
				If Val(ZTF->RD_PD) >= Val(GetMV("ZZ_SRVINID")) .and. Val(ZTF->RD_PD) <= Val(GetMV("ZZ_SRVFIMD"))
					nValorPN := ZTF->RD_VALOR - ZTF->RD_VALOR - ZTF->RD_VALOR
				EndIf
				nPosColuna := Ascan(aCabec, CHR(160) + ZTF->RD_PD + " - " + ZTF->RV_DESC)
				For nCount2 := 1 to nPosColuna - 4 - 1
					Aadd(aItens, "")
				Next
				Aadd(aItens, Transform(nValorPN, "@E 999,999.99")) 
				Aadd(aDados, aItens)
				aItens := {}
			Else
				If (Val(ZTF->RD_PD) >= Val(GetMV("ZZ_SRVINIP")) .and. Val(ZTF->RD_PD) <= Val(GetMV("ZZ_SRVFIMP"))) .or. (Val(ZTF->RD_PD) >= Val(GetMV("ZZ_SRVINIB")) .and. Val(ZTF->RD_PD) <= Val(GetMV("ZZ_SRVFIMB")))
					nValorPN := ZTF->RD_VALOR
				EndIf
				If Val(ZTF->RD_PD) >= Val(GetMV("ZZ_SRVINID")) .and. Val(ZTF->RD_PD) <= Val(GetMV("ZZ_SRVFIMD"))
					nValorPN := ZTF->RD_VALOR - ZTF->RD_VALOR - ZTF->RD_VALOR
				EndIf
				nPosColuna := Ascan(aCabec, CHR(160) + ZTF->RD_PD + " - " + ZTF->RV_DESC)
				If Len(aDados[nPosItem]) >= nPosColuna
					aDados[nPosItem][nPosColuna] := Transform(nValorPN, "@E 999,999.99")
				Else
					For nCount2 := 1 to nPosColuna - Len(aDados[nPosItem]) - 1
						Aadd(aDados[nPosItem], "")
					Next
					Aadd(aDados[nPosItem], Transform(nValorPN, "@E 999,999.99"))	
				EndIf
			EndIf

			cCodAnt := ZTF->RD_PD
			ZTF->(dbSkip())	
			If cCodAnt == ZTF->RD_PD
				lAcumVerba := .T.			
			Else
				lAcumVerba := .F.	
			EndIf           
			ZTF->(dbSkip(-1))	

		Else                                      

			nPosItem := Ascan(aDados, {|x|x[3] == CHR(160)+ZTF->RD_MAT})

			If nPosItem == 0
				Aadd(aItens, CHR(160)+ZTF->RD_FILIAL+ZTF->RA_NOME)
				Aadd(aItens, CHR(160)+ZTF->RD_FILIAL) 
				Aadd(aItens, CHR(160)+ZTF->RD_MAT) 
				Aadd(aItens, CHR(160)+ZTF->RA_NOME) 
				If (Val(ZTF->RD_PD) >= Val(GetMV("ZZ_SRVINIP")) .and. Val(ZTF->RD_PD) <= Val(GetMV("ZZ_SRVFIMP"))) .or. (Val(ZTF->RD_PD) >= Val(GetMV("ZZ_SRVINIB")) .and. Val(ZTF->RD_PD) <= Val(GetMV("ZZ_SRVFIMB")))
					nValorPN := ZTF->RD_VALOR
				EndIf
				If Val(ZTF->RD_PD) >= Val(GetMV("ZZ_SRVINID")) .and. Val(ZTF->RD_PD) <= Val(GetMV("ZZ_SRVFIMD"))
					nValorPN := ZTF->RD_VALOR - ZTF->RD_VALOR - ZTF->RD_VALOR
				EndIf
				nPosColuna := Ascan(aCabec, CHR(160) + ZTF->RD_PD + " - " + ZTF->RV_DESC)
				For nCount2 := 1 to nPosColuna - 4 - 1
					Aadd(aItens, "")
				Next
				Aadd(aItens, Transform(nValorPN, "@E 999,999.99")) 
				Aadd(aDados, aItens)
				aItens := {}
			Else
				If (Val(ZTF->RD_PD) >= Val(GetMV("ZZ_SRVINIP")) .and. Val(ZTF->RD_PD) <= Val(GetMV("ZZ_SRVFIMP"))) .or. (Val(ZTF->RD_PD) >= Val(GetMV("ZZ_SRVINIB")) .and. Val(ZTF->RD_PD) <= Val(GetMV("ZZ_SRVFIMB")))
					nValorPN := ZTF->RD_VALOR
				EndIf
				If Val(ZTF->RD_PD) >= Val(GetMV("ZZ_SRVINID")) .and. Val(ZTF->RD_PD) <= Val(GetMV("ZZ_SRVFIMD"))
					nValorPN := ZTF->RD_VALOR - ZTF->RD_VALOR - ZTF->RD_VALOR
				EndIf
				nPosColuna := Ascan(aCabec, CHR(160) + ZTF->RD_PD + " - " + ZTF->RV_DESC)
				If Len(aDados[nPosItem]) >= nPosColuna
					aDados[nPosItem][nPosColuna] := Transform(nValorPN, "@E 999,999.99")
				Else
					For nCount2 := 1 to nPosColuna - Len(aDados[nPosItem]) - 1
						Aadd(aDados[nPosItem], "")
					Next
					Aadd(aDados[nPosItem], Transform(nValorPN, "@E 999,999.99"))	
				EndIf
			EndIf	

			cCodAnt := ZTF->RD_PD
			ZTF->(dbSkip())	
			If cCodAnt == ZTF->RD_PD
				lAcumVerba := .T.			
			Else
				lAcumVerba := .F.	
			EndIf           
			ZTF->(dbSkip(-1))	

		EndIf

		ZTF->(dbSkip())	

	EndDo

	cTitulo := "Empresa: " + ALLTRIM(SM0->M0_NOMECOM) + " - Unidade: " + ALLTRIM(FWFILIALNAME(SUBSTR(xFilial("SRD"),1,2), xFilial("SRD"), 1)) + " | Filial Ini: " + cFilIni + " - Filial Fim: " + cFilFim + " | Mês: " + cAnoMes

	Asort(aDados, , , {|x, y| y[1] > x[1]})

	For nCount3 := 1 to Len(aDados)
		ADel(aDados[nCount3], 1 )
	Next	

	aDel(aCabec, 1 )

	DlgToExcel({ {"ARRAY", cTitulo, aCabec, aDados} })

	// Apaga a tabela temporária
	ZTF->(dbCloseArea())

Return  
