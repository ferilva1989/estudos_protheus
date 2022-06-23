#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"

/*------------------------------------------------------------------------------------------------------------------------------------------------*\
| Fonte:	 |	RCUSCOME.PRW                                                                                                                       |
| Autor:	 |	Djalma Borges                                                                                                                      |
| Data:		 |	25/02/2016                                                                                                                         |
| Descrição: |	Relatório de Custo de Colaborador mensal - EXCEL																			       |
\*------------------------------------------------------------------------------------------------------------------------------------------------*/

User Function RCUSCOME()

	Local oDlg

	Local oAnoMes
	Local cAnoMes := Space(6)

	Local oFilIni
	Local cFilIni := Space(5)
	Local oFilFim
	Local cFilFim := Space(5)

	Local oBtnOk
	Local oBtnCancel

	Define MSDialog oDlg Title "CUSTO DE COLABORADOR MENSAL" From 0,0 To 200,300 Pixel

	@10,10 Say "FILIAL INI: " Pixel Of oDlg
	@10,60 MSGet oFilIni Var cFilIni Size 20,10 Pixel Of oDlg

	@25,10 Say "FILIAL FIM: " Pixel Of oDlg
	@25,60 MSGet oFilFim Var cFilFim Size 20,10 Pixel Of oDlg

	@45,10 Say "ANO + MÊS: " Pixel Of oDlg
	@45,60 MSGet oAnoMes Var cAnoMes Size 50,10 Pixel Of oDlg

	@70,10 Button oBtnOk     Prompt "Ok"       Size 30,15 Pixel Action {||U_AgCuCoMe(cAnoMes, cFilIni, cFilFim), oDlg:End()} Of oDlg
	@70,70 Button oBtnCancel Prompt "Cancelar" Size 30,15 Pixel Action {||oDlg:End()} Of oDlg

	Activate MSDialog oDlg Centered

Return

User Function AgCuCoMe(cAnoMes, cFilIni, cFilFim)

	Processa( {|| U_ProcRCCM(cAnoMes, cFilIni, cFilFim) }, "Aguarde...", "Exportando dados para o Excel...",.F.)

Return

User Function ProcRCCM(cAnoMes, cFilIni, cFilFim)

	Local aCabec := {}
	Local aDados := {}
	Local aItens := {}
	Local cTitulo := ""
	Local cQuery := ""
	Local aReCusCoMe := {}
	Local cArqTrab := ""
	Local aTamSX3 := {}
	Local aCampos := {}
	Local nCount := ""
	Local cFilAnter := ""
	Local cMatAnt := ""
	Local cPdAnter := ""

	Local nSalario := 0
	Local nHoraExtra := 0
	Local nAdicInsal := 0
	Local nAdicNot := 0
	Local nSalFamil := 0
	Local nAuxCreche := 0
	Local nValeRef := 0
	Local nValeAlim := 0
	Local nValeTrans := 0
	Local nFatAssMed := 0
	Local nFGTS := 0
	Local nGpsInssTt := 0
	Local nTotProv := 0
	Local nDescRef := 0
	Local nDescVT := 0
	Local nDescAsMed := 0
	Local nDescCoPar:= 0
	Local nTotDesc := 0
	Local nProvAcFer := 0
	Local nProvAc13o := 0 
	Local nCustoTot := 0  

	Local cDataCal := ""
	Local dFechaMes := Date()

	Local lFilIniEx := .F.
	Local lFilFimEx := .F.

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

	cQuery := "SELECT RD_FILIAL, RD_MAT, RA_NOME, RA_ADMISSA, RA_DEMISSA, RD_PD, RD_DATARQ, RD_VALOR "
	cQuery += "FROM " + RetSqlName("SRD") + ", " + RetSqlName("SRA") + " "
	cQuery += "WHERE " + RetSqlName("SRD") + ".D_E_L_E_T_ <> '*' AND " + RetSqlName("SRA") + ".D_E_L_E_T_ <> '*' AND RD_FILIAL = RA_FILIAL AND RD_MAT = RA_MAT "
	If !Empty(cFilIni) .and. !Empty(cFilFim) 
		cQuery += " AND RD_FILIAL >= '" + cFilIni + "' AND RD_FILIAL <= '" + cFilFim + "'"
	Else
		cQuery += " AND RD_FILIAL = '" + xFilial("SRD") + "'"
	EndIf	
	cQuery += " AND RD_DATARQ = '" + cAnoMes + "' "
	cQuery += "ORDER BY RD_FILIAL, RA_NOME, RD_PD"
	cQuery := ChangeQuery(cQuery)
	If SELECT('ZQC') <> 0
		ZQC->(dbCloseArea())
	Endif
	TCQUERY cQuery NEW ALIAS "ZQC"

	If !ApOleClient("MSExcel")
		MsgAlert("Microsoft Excel não instalado!")
		Return Nil
	EndIf

	// Estrutura da tabela temporaria
	Aadd(aCampos, "RD_FILIAL")
	Aadd(aCampos, "RD_MAT")
	Aadd(aCampos, "RA_NOME")
	Aadd(aCampos, "RA_ADMISSA")
	Aadd(aCampos, "RA_DEMISSA")
	Aadd(aCampos, "RD_PD")
	Aadd(aCampos, "RD_DATARQ")
	Aadd(aCampos, "RD_VALOR")

	For nCount := 1 to Len(aCampos)
		aTamSx3 := TamSx3(aCampos[nCount])
		Aadd(aReCusCoMe, {aCampos[nCount], aTamSx3[3], aTamSx3[1], aTamSx3[2]})
	Next

	If SELECT("ZTC") <> 0
		ZTC->(dbCloseArea())
	EndIf
	// Cria a tabela temporária
	cArqTrab := CriaTrab(aReCusCoMe,.T.)
	MsCreate(cArqTrab, aReCusCoMe, "DBFCDX")
	// Atribui a tabela temporária ao alias ZTC
	dbUseArea(.T., "DBFCDX", cArqTrab, "ZTC", .T., .F.)
	dbSelectArea("ZTC")

	// Copia da query para a tabela temporária
	dbSelectArea("ZQC")
	ZQC->(dbGoTop())
	While ZQC->(!EOF())
		RECLOCK("ZTC", .T.)
		ZTC->RD_FILIAL 	:= ZQC->RD_FILIAL 	
		ZTC->RD_MAT 	:= ZQC->RD_MAT 		
		ZTC->RA_NOME	:= ZQC->RA_NOME 		
		ZTC->RA_ADMISSA := STOD(ZQC->RA_ADMISSA)
		ZTC->RA_DEMISSA	:= STOD(ZQC->RA_DEMISSA)
		ZTC->RD_PD		:= ZQC->RD_PD
		ZTC->RD_DATARQ 	:= ZQC->RD_DATARQ 	
		ZTC->RD_VALOR 	:= ZQC->RD_VALOR 	
		ZTC->(MSUNLOCK())
		ZQC->(dbSkip())
	EndDo		

	ZQC->(dbCloseArea())

	dbSelectArea("ZTC")
	dbGoTop()
	ProcRegua(RecCount())
	While ZTC->(!EOF()) 

		IncProc()       

		If ZTC->RD_PD $ GETMV("ZZ_RHSALAR") ;
		.or. ZTC->RD_PD $ GETMV("ZZ_RHHOREX") ;
		.or. ZTC->RD_PD $ GETMV("ZZ_RHADINS") ;
		.or. ZTC->RD_PD $ GETMV("ZZ_RHADNOT") ;
		.or. ZTC->RD_PD $ GETMV("ZZ_RHSALFA") ;
		.or. ZTC->RD_PD $ GETMV("ZZ_RHAUXCR") ;
		.or. ZTC->RD_PD $ GETMV("ZZ_RHVALER") ;
		.or. ZTC->RD_PD $ GETMV("ZZ_RHVALEA") ;
		.or. ZTC->RD_PD $ GETMV("ZZ_RHVALET") ;
		.or. ZTC->RD_PD $ GETMV("ZZ_RHFASSM") ;
		.or. ZTC->RD_PD $ GETMV("ZZ_RHCFGTS") ;
		.or. ZTC->RD_PD $ GETMV("ZZ_RHGPINS") ;
		.or. ZTC->RD_PD $ GETMV("ZZ_RHDESCR") ;
		.or. ZTC->RD_PD $ GETMV("ZZ_RHDESCT") ;
		.or. ZTC->RD_PD $ GETMV("ZZ_RHDASME") ;
		.or. ZTC->RD_PD $ GETMV("ZZ_RHDCOPA")

			If ZTC->RD_PD $ GETMV("ZZ_RHSALAR")
				nSalario := nSalario + ZTC->RD_VALOR
			EndIf	
			If ZTC->RD_PD $ GETMV("ZZ_RHHOREX")
				nHoraExtra := nHoraExtra + ZTC->RD_VALOR
			EndIf	
			If ZTC->RD_PD $ GETMV("ZZ_RHADINS")
				nAdicInsal := nAdicInsal + ZTC->RD_VALOR
			EndIf	
			If ZTC->RD_PD $ GETMV("ZZ_RHADNOT")
				nAdicNot := nAdicNot + ZTC->RD_VALOR
			EndIf	
			If ZTC->RD_PD $ GETMV("ZZ_RHSALFA")
				nSalFamil := nSalFamil + ZTC->RD_VALOR
			EndIf	
			If ZTC->RD_PD $ GETMV("ZZ_RHAUXCR")
				nAuxCreche := nAuxCreche + ZTC->RD_VALOR
			EndIf	
			If ZTC->RD_PD $ GETMV("ZZ_RHVALER")
				nValeRef := nValeRef + ZTC->RD_VALOR
			EndIf	
			If ZTC->RD_PD $ GETMV("ZZ_RHVALEA")
				nValeAlim := nValeAlim + ZTC->RD_VALOR
			EndIf	             
			If ZTC->RD_PD $ GETMV("ZZ_RHVALET")
				nValeTrans := nValeTrans + ZTC->RD_VALOR
			EndIf	
			If ZTC->RD_PD $ GETMV("ZZ_RHFASSM")
				nFatAssMed := nFatAssMed + ZTC->RD_VALOR
			EndIf	
			If ZTC->RD_PD $ GETMV("ZZ_RHCFGTS")
				nFGTS := nFGTS + ZTC->RD_VALOR
			EndIf	
			If ZTC->RD_PD $ GETMV("ZZ_RHGPINS")
				nGpsInssTt := nGpsInssTt + ZTC->RD_VALOR
			EndIf	

			nTotProv := nSalario + nHoraExtra + nAdicInsal + nAdicNot + nSalFamil + nAuxCreche + nValeRef + nValeAlim + nValeTrans + nFatAssMed + nFGTS + nGpsInssTt

			If ZTC->RD_PD $ GETMV("ZZ_RHDESCR")
				nDescRef := nDescRef + ZTC->RD_VALOR
			EndIf	             
			If ZTC->RD_PD $ GETMV("ZZ_RHDESCT")
				nDescVT := nDescVT + ZTC->RD_VALOR
			EndIf	
			If ZTC->RD_PD $ GETMV("ZZ_RHDASME")
				nDescAsMed := nDescAsMed + ZTC->RD_VALOR
			EndIf	
			If ZTC->RD_PD $ GETMV("ZZ_RHDCOPA")
				nDescCoPar := nDescCoPar + ZTC->RD_VALOR
			EndIf	

			nTotDesc := nDescRef + nDescVT + nDescAsMed + nDescCoPar  

			cDataCal := "01/" + SubStr(cAnoMes,5,2) + "/" + SubStr(cAnoMes,1,4)
			dFechaMes := LastDate(CTOD(cDataCal))

			nProvAcFer := 0
			nProvAc13o := 0

			dbSelectArea("SRT")
			dbOrderNickName("MATDTVERBA")

			dbSeek(ZTC->RD_FILIAL + ZTC->RD_MAT + DTOS(dFechaMes) + GETMV("ZZ_RHPROVF"))
			While SRT->(!EOF()) .and. ; 
			ZTC->RD_FILIAL + ZTC->RD_MAT + DTOS(dFechaMes)       + GETMV("ZZ_RHPROVF") == ;
			SRT->RT_FILIAL + SRT->RT_MAT + DTOS(SRT->RT_DATACAL) + SRT->RT_VERBA
				nProvAcFer := nProvAcFer + SRT->RT_VALOR
				SRT->(dbSkip())                                                         
			EndDo	

			dbSeek(ZTC->RD_FILIAL + ZTC->RD_MAT + DTOS(dFechaMes) + GETMV("ZZ_RHPROVD"))
			While SRT->(!EOF()) .and. ; 
			ZTC->RD_FILIAL + ZTC->RD_MAT + DTOS(dFechaMes)       + GETMV("ZZ_RHPROVD") == ;
			SRT->RT_FILIAL + SRT->RT_MAT + DTOS(SRT->RT_DATACAL) + SRT->RT_VERBA
				nProvAc13o := nProvAc13o + SRT->RT_VALOR
				SRT->(dbSkip())
			EndDo	

			//nProvAcFer := POSICIONE("SRT",dbNickOrder("SRT","MATDTVERBA"),ZTC->RD_FILIAL+ZTC->RD_MAT+DTOS(dFechaMes)+GETMV("ZZ_RHPROVF"),"RT_VALOR")
			//nProvAc13o := POSICIONE("SRT",dbNickOrder("SRT","MATDTVERBA"),ZTC->RD_FILIAL+ZTC->RD_MAT+DTOS(dFechaMes)+GETMV("ZZ_RHPROVD"),"RT_VALOR")

			nCustoTot := nTotProv - nTotDesc + nProvAcFer + nProvAc13o

		EndIf	

		cFilAnter := ZTC->RD_FILIAL
		cMatAnt   := ZTC->RD_MAT                      
		ZTC->(dbSkip())
		If ZTC->RD_FILIAL + ZTC->RD_MAT <> cFilAnter + cMatAnt
			ZTC->(dbSkip(-1))
			Aadd(aItens, CHR(160)+ZTC->RD_FILIAL) 
			Aadd(aItens, CHR(160)+ZTC->RD_MAT) 
			Aadd(aItens, CHR(160)+ZTC->RA_NOME) 
			Aadd(aItens, CHR(160)+DTOC(ZTC->RA_ADMISSA))
			Aadd(aItens, CHR(160)+DTOC(ZTC->RA_DEMISSA))
			Aadd(aItens, Transform(nSalario, "@E 999,999.99"))
			Aadd(aItens, Transform(nHoraExtra, "@E 999,999.99"))
			Aadd(aItens, Transform(nAdicInsal, "@E 999,999.99"))
			Aadd(aItens, Transform(nAdicNot, "@E 999,999.99"))
			Aadd(aItens, Transform(nSalFamil, "@E 999,999.99"))
			Aadd(aItens, Transform(nAuxCreche, "@E 999,999.99"))
			Aadd(aItens, Transform(nValeRef, "@E 999,999.99"))
			Aadd(aItens, Transform(nValeAlim, "@E 999,999.99"))
			Aadd(aItens, Transform(nValeTrans, "@E 999,999.99"))
			Aadd(aItens, Transform(nFatAssMed, "@E 999,999.99"))
			Aadd(aItens, Transform(nFGTS, "@E 999,999.99"))
			Aadd(aItens, Transform(nGpsInssTt, "@E 999,999.99"))
			Aadd(aItens, Transform(nTotProv, "@E 999,999.99"))
			Aadd(aItens, Transform(nDescRef, "@E 999,999.99"))
			Aadd(aItens, Transform(nDescVT, "@E 999,999.99"))
			Aadd(aItens, Transform(nDescAsMed, "@E 999,999.99"))
			Aadd(aItens, Transform(nDescCoPar, "@E 999,999.99"))
			Aadd(aItens, Transform(nTotDesc, "@E 999,999.99"))
			Aadd(aItens, Transform(nProvAcFer, "@E 999,999.99"))
			Aadd(aItens, Transform(nProvAc13o, "@E 999,999.99")) 
			Aadd(aItens, Transform(nCustoTot, "@E 999,999.99"))
			Aadd(aDados, aItens)
			aItens := {}
			nSalario := 0
			nHoraExtra := 0
			nAdicInsal := 0
			nAdicNot := 0
			nSalFamil := 0
			nAuxCreche := 0
			nValeRef := 0
			nValeAlim := 0
			nValeTrans := 0
			nFatAssMed := 0
			nFGTS := 0
			nGpsInssTt := 0
			nTotProv := 0
			nDescRef := 0
			nDescVT := 0
			nDescAsMed := 0
			nDescCoPar:= 0
			nTotDesc := 0
			nProvAcFer := 0
			nProvAc13o := 0 
			nCustoTot := 0		
		Else
			ZTC->(dbSkip(-1))		
		EndIf

		ZTC->(dbSkip())	

	EndDo

	Aadd(aCabec, "UNIDADE")
	Aadd(aCabec, "MATRÍCULA")
	Aadd(aCabec, "NOME")
	Aadd(aCabec, "DT ADMISSÃO")
	Aadd(aCabec, "DT DEMISSÃO")
	Aadd(aCabec, "SALÁRIO")
	Aadd(aCabec, "H.E.")
	Aadd(aCabec, "ADIC INSALUBR")
	Aadd(aCabec, "AD NOTURNO")
	Aadd(aCabec, "SAL FAMÍLIA")
	Aadd(aCabec, "AUX CRECHE")
	Aadd(aCabec, "VR")
	Aadd(aCabec, "VA")
	Aadd(aCabec, "VT")
	Aadd(aCabec, "FAT ASS MED.")
	Aadd(aCabec, "FGTS")
	Aadd(aCabec, "GPS INSS TOTAL")
	Aadd(aCabec, "TOTAL PROVENTOS")
	Aadd(aCabec, "DESC REFEIÇÃO")
	Aadd(aCabec, "DESC VT")
	Aadd(aCabec, "DESC ASS MED DP")
	Aadd(aCabec, "DESC CO PARTICIP")
	Aadd(aCabec, "TOTAL DESCONTOS")
	Aadd(aCabec, "PROVISÃO ACUM FÉRIAS")
	Aadd(aCabec, "PROVISÃO ACUM 13o")
	Aadd(aCabec, "CUSTO TOTAL")

	cTitulo := "Empresa: " + ALLTRIM(SM0->M0_NOMECOM) + " - Unidade: " + ALLTRIM(FWFILIALNAME(SUBSTR(xFilial("SRD"),1,2), xFilial("SRD"), 1)) + " | Filial Ini: " + cFilIni + " - Filial Fim: " + cFilFim + " | Período: " + cAnoMes

	DlgToExcel({ {"ARRAY", cTitulo, aCabec, aDados} })

	// Apaga a tabela temporária
	ZTC->(dbCloseArea())

Return  
