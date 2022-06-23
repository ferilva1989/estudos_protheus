#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"        
#INCLUDE "PROTHEUS.CH" 
#INCLUDE "FWPrintSetup.ch"

/*------------------------------------------------------------------------------------------------------------------------------------------------*\
| Fonte:	 |	ROCPONEL.PRW                                                                                                                       |
| Autor:	 |	Djalma Borges                                                                                                                      |
| Data:		 |	11/03/2016                                                                                                                         |
| Descrição: |	Relatório de Ocorrências de Ponto Eletrônico em PDF																				   |
\*------------------------------------------------------------------------------------------------------------------------------------------------*/

User Function ROCPONEL()

	Local oDlg

	Local oDataIni
	Local dDataIni := CTOD("  /  /    ")
	Local oDataFim
	Local dDataFim := CTOD("  /  /    ")

	Local oFilIni
	Local cFilIni := Space(5)
	Local oFilFim
	Local cFilFim := Space(5)

	Local oBtnOk
	Local oBtnCancel

	Define MSDialog oDlg Title "OCORRÊNCIAS PONTO ELETRÔNICO" From 0,0 To 250,300 Pixel

	@10,10 Say "FILIAL INI: " Pixel Of oDlg
	@10,60 MSGet oFilIni Var cFilIni Size 20,10 Pixel Of oDlg

	@25,10 Say "FILIAL FIM: " Pixel Of oDlg
	@25,60 MSGet oFilFim Var cFilFim Size 20,10 Pixel Of oDlg

	@45,10 Say "DATA INI: " Pixel Of oDlg
	@45,60 MSGet oDataIni Var dDataIni Size 50,10 Pixel Of oDlg

	@60,10 Say "DATA FIM: " Pixel Of oDlg
	@60,60 MSGet oDataFim Var dDataFim Size 50,10 Pixel Of oDlg

	@80,10 Button oBtnOk     Prompt "Ok"       Size 30,15 Pixel Action {||U_AgOcPoEl(dDataIni, dDataFim, cFilIni, cFilFim), oDlg:End()} Of oDlg
	@80,70 Button oBtnCancel Prompt "Cancelar" Size 30,15 Pixel Action {||oDlg:End()} Of oDlg

	Activate MSDialog oDlg Centered

Return

User Function AgOcPoEl(dDataIni, dDataFim, cFilIni, cFilFim)

	Processa( {|| U_ProcOCPE(dDataIni, dDataFim, cFilIni, cFilFim) }, "Aguarde...", "Processando Relatório...",.F.)

Return

User Function ProcOCPE(dDataIni, dDataFim, cFilIni, cFilFim)

	Local cTitulo := "OCORRÊNCIAS PONTO ELETRÔNICO"
	Local NLIN := 80

	Local aRocponel := {}
	Local aRocponel2 := {}
	Local cArqTrab := ""
	Local aTamSX3 := {}
	Local aCampos := {}
	Local aCampos2 := {}
	Local nCount := 0
	Local nCount2 := 0
	Local nCount3 := 0
	Local nCount4 := 0
	Local cQuery := ""
	Local cQuery2 := ""
	Local lFilIniEx := .F.
	Local lFilFimEx := .F.
	Local nPagina := 0 
	Local nItens := 0  
	Local cDescrAnt := ""   
	Local nTtEvento := 0.00
	Local cNomeTrab := "" 
	Local aDir
	Local oPrn 
	Local aOcorrenc := {}
	Local nDiaSemana := 0 
	Local nHorarPadr := 0
	Local nHorarPont := 0  
	Local nHorPontAN := 0  
	Local aAreaZOT := {}
	Local aItemOcor := {}   
	Local cUltimaSeq := ""
	Local cDifHora := ""
	Local cHoraPon := ""
	Local cHoraPad := ""
	Local nHoraPon := 0
	Local nHoraPad := 0
	Local cExtAbsent := ""    
	Local cChaveDiaF := ""   
	Local dFirstDate
	Local dLastDate
	Local dDataTrab
	Local cSDataTrab := ""    
	Local nHoraIni1 := 0
	Local nHoraFim1 := 0
	Local nHoraIni2 := 0
	Local nHoraFim2 := 0
	Local nHoraIni3 := 0
	Local nHoraFim3 := 0
	Local nHoraIni4 := 0
	Local nHoraFim4 := 0
	Local cHoraIni1 := ""
	Local cHoraFim1 := ""
	Local cHoraIni2 := ""
	Local cHoraFim2 := ""
	Local cHoraIni3 := ""
	Local cHoraFim3 := ""
	Local cHoraIni4 := ""
	Local cHoraFim4 := "" 
	Local cHorasFer1 := ""
	Local cHorasFer2 := ""
	Local cHorasFer3 := ""
	Local cHorasFer4 := ""
	Local nHorasFer1 := 0
	Local nHorasFer2 := 0
	Local nHorasFer3 := 0
	Local nHorasFer4 := 0
	Local nHorasFer := 0
	Local cHorasFer := ""
	Local cDataFer := ""
	Local cHorasNot := ""
	Local nHorasNot := 0
	Local nAdNotIni := 0
	Local nAdNotFim := 0
	Local nHoraIniTr := 0
	Local nHoraFimTr := 0
	Local cHoraIniTr := 0
	Local cHoraFimTr := 0
	Local nHoraIniTr1 := 0
	Local nHoraFimTr1 := 0
	Local cHoraIniTr1 := 0
	Local cHoraFimTr1 := 0
	Local nHoraIniTr2 := 0
	Local nHoraFimTr2 := 0
	Local cHoraIniTr2 := 0
	Local cHoraFimTr2 := 0  
	Local nDiasTurno := 0 
	Local cMatricAnt := ""
	Local nResposta := 0                 
	Local nSdHrsHex := 0
	Local nSdHrsAbs := 0
	Local nSdHrAbsHe := 0
	Local nPosTurno := 0
	Local nDiasSeq := 0  
	Local lRegraExc

	If Empty(dDataIni) .or. Empty(dDataFim)
		MsgAlert("Necessário informar Data Inicial e Data Final.")	
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

	cQuery := "SELECT P8_FILIAL, P8_MAT, RA_NOME, P8_DATA, P8_HORA, P8_CC, RA_CODFUNC, RJ_DESC, RA_ADMISSA, P8_TURNO, R6_DESC, RA_SINDICA, RA_TNOTRAB, RA_SEQTURN, P8_ORDEM "
	cQuery += "FROM " + RetSqlName("SP8") + " LEFT JOIN " + RetSqlName("SR6") + " ON R6_TURNO = P8_TURNO AND " + RetSqlName("SR6") + ".D_E_L_E_T_ <> '*', " + RetSqlName("SRA") + ", " + RetSqlName("SRJ") + " "
	cQuery += "WHERE P8_DATA >= '" + DTOS(dDataIni) + "' AND P8_DATA <= '" + DTOS(dDataFim) + "' AND RA_MAT = P8_MAT AND RA_CODFUNC = RJ_FUNCAO "
	cQuery += "AND " + RetSqlName("SRA") + ".D_E_L_E_T_ <> '*' AND " + RetSqlName("SRJ") + ".D_E_L_E_T_ <> '*' AND " + RetSqlName("SP8") + ".D_E_L_E_T_ <> '*' AND "
	If !Empty(cFilIni) .and. !Empty(cFilFim) 
		cQuery += "P8_FILIAL >= '" + cFilIni + "' AND P8_FILIAL <= '" + cFilFim + "' "
	Else
		cQuery += "P8_FILIAL = '" + xFilial("SP8") + "' "
	EndIf	
	cQuery += "ORDER BY P8_FILIAL, RA_NOME, P8_DATA, P8_HORA "
	cQuery := ChangeQuery(cQuery)
	If SELECT('ZOP') <> 0
		ZOP->(dbCloseArea())
	Endif
	TCQUERY cQuery NEW ALIAS "ZOP"

	// Estrutura da tabela temporaria
	Aadd(aCampos, "P8_FILIAL")
	Aadd(aCampos, "P8_MAT")
	Aadd(aCampos, "RA_NOME")
	Aadd(aCampos, "P8_DATA")
	Aadd(aCampos, "P8_HORA")
	Aadd(aCampos, "P8_CC")
	Aadd(aCampos, "RA_CODFUNC")
	Aadd(aCampos, "RJ_DESC")
	Aadd(aCampos, "RA_ADMISSA")
	Aadd(aCampos, "P8_TURNO")
	Aadd(aCampos, "R6_DESC")
	Aadd(aCampos, "RA_SINDICA")
	Aadd(aCampos, "RA_TNOTRAB")
	Aadd(aCampos, "RA_SEQTURN")
	Aadd(aCampos, "P8_ORDEM")

	For nCount := 1 to Len(aCampos)
		aTamSx3 := TamSx3(aCampos[nCount])
		Aadd(aRocponel, {aCampos[nCount], aTamSx3[3], aTamSx3[1], aTamSx3[2]})
	Next

	If SELECT("ZOT") <> 0
		ZOT->(dbCloseArea())
	EndIf
	// Cria a tabela temporária
	cArqTrab := CriaTrab(aRocponel,.T.)
	MsCreate(cArqTrab, aRocponel, "DBFCDX")
	// Atribui a tabela temporária ao alias ZOT
	dbUseArea(.T., "DBFCDX", cArqTrab, "ZOT", .T., .F.)
	dbSelectArea("ZOT")

	// Copia da query para a tabela temporária
	dbSelectArea("ZOP")
	ZOP->(dbGoTop())
	While ZOP->(!EOF())
		RECLOCK("ZOT", .T.)             
		ZOT->P8_FILIAL 	:= ZOP->P8_FILIAL
		ZOT->P8_MAT 	:= ZOP->P8_MAT 		
		ZOT->RA_NOME 	:= ZOP->RA_NOME 	
		ZOT->P8_DATA	:= STOD(ZOP->P8_DATA)
		ZOT->P8_HORA	:= ZOP->P8_HORA 	
		ZOT->P8_CC 		:= ZOP->P8_CC 	
		ZOT->RA_CODFUNC	:= ZOP->RA_CODFUNC 		
		ZOT->RJ_DESC 	:= ZOP->RJ_DESC
		ZOT->RA_ADMISSA	:= STOD(ZOP->RA_ADMISSA)
		ZOT->P8_TURNO 	:= ZOP->P8_TURNO      
		ZOT->R6_DESC 	:= ZOP->R6_DESC      
		ZOT->RA_SINDICA	:= ZOP->RA_SINDICA      
		ZOT->RA_TNOTRAB	:= ZOP->RA_TNOTRAB      
		ZOT->RA_SEQTURN	:= ZOP->RA_SEQTURN      
		ZOT->P8_ORDEM	:= ZOP->P8_ORDEM      
		ZOT->(MSUNLOCK())
		ZOP->(dbSkip())
	EndDo		

	ZOP->(dbCloseArea())

	cQuery2 := "SELECT RA_FILIAL, RA_MAT, RA_NOME,P8_CC, RJ_DESC, P8_DATA, P8_HORA, P8_TURNO, P8_FUNCAO, P8_SEMANA, RA_REGRA, RA_ADMISSA "
	cQuery2 += "FROM " + RetSqlName("SRJ") + ", " + RetSqlName("SRA") + " LEFT JOIN " + RetSqlName("SP8") + " ON RA_MAT = P8_MAT AND RA_FILIAL = P8_FILIAL AND P8_DATA >= '" + DTOS(dDataIni) + "' AND P8_DATA <= '" + DTOS(dDataFim) + "' AND " + RetSqlName("SP8") + ".D_E_L_E_T_ <> '*' "
	cQuery2 += "WHERE " + RetSqlName("SRA") + ".D_E_L_E_T_ <> '*' AND RA_DEMISSA = ' ' AND " + RetSqlName("SRJ") + ".D_E_L_E_T_ <> '*' AND RA_CODFUNC = RJ_FUNCAO AND "
	If !Empty(cFilIni) .and. !Empty(cFilFim) 
		cQuery2 += "RA_FILIAL >= '" + cFilIni + "' AND RA_FILIAL <= '" + cFilFim + "' "
	Else
		cQuery2 += "RA_FILIAL = '" + xFilial("SRA") + "' "
	EndIf	
	cQuery2 += "ORDER BY RA_FILIAL, RA_MAT, P8_DATA, P8_HORA "
	cQuery2 := ChangeQuery(cQuery2)
	If SELECT('ZRA') <> 0
		ZRA->(dbCloseArea())
	Endif
	TCQUERY cQuery2 NEW ALIAS "ZRA"

	oFont1     := TFont():New("Arial"     ,20,20,,.T.,,,,,.F.)   // Negrito
	oFont2     := TFont():New("Arial"     ,12,12,,.T.,,,,,.T.)   // Negrito / Subinhado
	oFont3     := TFont():New("Arial"     ,10,10,,.T.,,,,,.F.)   // Negrito
	oFont4     := TFont():New("Arial"     ,10,10,,.F.,,,,,.F.)   // Normal
	oFont5     := TFont():New("Arial"     ,12,12,,.T.,,,,,.F.)   // Negrito
	oFont6     := TFont():New("Arial"     ,10,10,,.T.,,,,,.T.)   // Negrito / Sublinhado
	oFont7     := TFont():New("Vendana"   ,07,07,,.F.,,,,,.F.)   // Normal
	oFont8     := TFont():New("Vendana"   ,07,07,,.F.,,,,,.T.)   // Sublinhado
	oFont9     := TFont():New("Arial"     ,08,08,,.F.,,,,,.F.)   // Normal 

	cNomeTrab := CriaTrab(NIL, .F.)

	oPrn := FWMSPRINTER():New(cNomeTrab, 6, .T., "\spool\", .T.)
	oPrn:lServer := .F. 

	aDir := Directory("c:\relatoriosrh\","D")
	If Len(aDir) == 0
		MakeDir("c:\relatoriosrh\")	
	EndIf

	oPrn:cPathPDF := "c:\relatoriosrh\" 

	oPrn:SetLandscape()
	oPrn:SetPaperSize(9) 

	oPrn:StartPage()

	oPrn:Say(0100, 1000, cTitulo ,oFont1,050)
	oPrn:Say(0200, 0960, "| Filial Ini: " + cFilIni + " | Filial Fim: " + cFilFim + " | Data Ini: " + DTOC(dDataIni) + " | Data Fim: " + DTOC(dDataFim) + " |", oFont5, 050)

	NLIN := 300 

	oBrushCinza := TBrush():New(,Rgb(214,214,214)) 
	nItens := 1        

	//Confere se os registros da tabela SP8 (Ponto Eletrônico) estão de acordo com a tabela SPJ (Horário Padrão)
	dbSelectArea("SPJ")  
	SPJ->(dbSetOrder(1))
	dbSelectArea("SPF")  
	SPF->(dbSetOrder(1))
	dbSelectArea("SP3")
	SP3->(dbSetOrder(1))

	dbSelectArea("ZOT")
	ZOT->(dbgotop())  
	ProcRegua(0)
	While ZOT->(!EOF()) 

		IncProc()       

		//pega a última trf de turno/seq do funcionário
		If SPF->(dbSeek(ZOT->P8_FILIAL+ZOT->P8_MAT))
			While SPF->(!EOF()) .and. SPF->PF_FILIAL == ZOT->P8_FILIAL .and. SPF->PF_MAT == ZOT->P8_MAT
				SPF->(dbSkip())
				If SPF->PF_FILIAL <> ZOT->P8_FILIAL .or. SPF->PF_MAT <> ZOT->P8_MAT
					SPF->(dbSkip(-1))
					Exit
				EndIf
			EndDo
			cUltimaSeq := SPF->PF_SEQUEPA
		Else
			cUltimaSeq := ZOT->RA_SEQTURN
		EndIf

		nDiaSemana := DOW(ZOT->P8_DATA)

		//If ZOT->P8_TURNO $ "001|002|004|012|022"
		If ZOT->P8_TURNO $ GETMV("ZZ_TNOSEQS")
			nDiasTurno := DateDiffDay(SPF->PF_DATA, ZOT->P8_DATA)
			nPosTurno := RAT(ZOT->P8_TURNO, GETMV("ZZ_TNOSEQS"))
			nDiasSeq := Val(SubStr(GETMV("ZZ_TNOSEQS"), nPosTurno + 4, 1)) 
			nDiasSeq := nDiasSeq * 7
			nDiasTurno := MOD(nDiasTurno,nDiasSeq)
			If nDiasTurno >= 8 .or. nDiasTurno == 0
				cUltimaSeq := "02"
			ElseIf nDiasTurno <= 7 .and. nDiasTurno <> 0
				cUltimaSeq := "01"	
			EndIf
		EndIf

		//verifica quantos horários de entrada e saída estão previstas no turno/seq do funcionário
		If SPJ->(dbSeek(xFilial("SPJ") + ZOT->P8_TURNO + cUltimaSeq + CVALTOCHAR(nDiaSemana)))

			If Empty(SPJ->PJ_ENTRA1) .and. Empty(SPJ->PJ_ENTRA2) .and. Empty(SPJ->PJ_ENTRA3) .and. Empty(SPJ->PJ_ENTRA4)
				nHorarPadr := 0
			EndIf
			If !Empty(SPJ->PJ_ENTRA1) .and. Empty(SPJ->PJ_ENTRA2) .and. Empty(SPJ->PJ_ENTRA3) .and. Empty(SPJ->PJ_ENTRA4)
				nHorarPadr := 2
			EndIf
			If !Empty(SPJ->PJ_ENTRA1) .and. !Empty(SPJ->PJ_ENTRA2) .and. Empty(SPJ->PJ_ENTRA3) .and. Empty(SPJ->PJ_ENTRA4)
				nHorarPadr := 4
			EndIf
			If !Empty(SPJ->PJ_ENTRA1) .and. !Empty(SPJ->PJ_ENTRA2) .and. !Empty(SPJ->PJ_ENTRA3) .and. Empty(SPJ->PJ_ENTRA4)
				nHorarPadr := 6
			EndIf
			If !Empty(SPJ->PJ_ENTRA1) .and. !Empty(SPJ->PJ_ENTRA2) .and. !Empty(SPJ->PJ_ENTRA3) .and. !Empty(SPJ->PJ_ENTRA4)
				nHorarPadr := 8
			EndIf

			//conta quantos registros tem para o funcionário na mesma ordem
			aAreaZOT := ZOT->(GETAREA())                                 
			cChaveDiaF := ZOT->P8_FILIAL + ZOT->P8_MAT + P8_ORDEM
			While ZOT->(!EOF()) .and. ZOT->P8_FILIAL + ZOT->P8_MAT + P8_ORDEM == cChaveDiaF
				nHorarPont += 1
				cChaveDiaF := ZOT->P8_FILIAL + ZOT->P8_MAT + P8_ORDEM
				ZOT->(dbSkip())
			EndDo

			//compara se o número de entradas e saídas previstas na tabela de horário padrão bate com os registros no ponto com a mesma data
			//se não bater acusa como inconsistência
			If nHorarPadr <> nHorarPont

				ZOT->(dbSkip(-1))

				aItemOcor := {; 
				DTOC(ZOT->P8_DATA),; 
				"Ausência de marcação.",; 
				"",;
				ZOT->P8_FILIAL,;
				ZOT->P8_MAT,;
				ZOT->RA_NOME,;
				ZOT->P8_CC,;
				ZOT->RJ_DESC,;
				ZOT->RA_ADMISSA,;
				ZOT->R6_DESC;
				}	
				Aadd(aOcorrenc, aItemOcor)
				aItemOcor := {}

			Else

				ZOT->(RESTAREA(aAreaZOT))

				//Calcula adicional noturno se houver
				//If ZOT->P8_TURNO $ "002|022"
				If ZOT->P8_TURNO $ GETMV("ZZ_NOTURNO")
					aAreaZOT := ZOT->(GETAREA())                                 
					cChaveDiaF := ZOT->P8_FILIAL + ZOT->P8_MAT + P8_ORDEM
					While ZOT->(!EOF())	.and. ZOT->P8_FILIAL + ZOT->P8_MAT + P8_ORDEM == cChaveDiaF
						nHorPontAN += 1
						cChaveDiaF := ZOT->P8_FILIAL + ZOT->P8_MAT + P8_ORDEM
						ZOT->(dbSkip())
					EndDo                      
					ZOT->(RESTAREA(aAreaZOT))  

					If MOD(nHorPontAN, 2) == 0

						//If ZOT->RA_SINDICA == "05"
						//If ZOT->RA_SINDICA + "," $ "|05,22:00,07:00|"
						If ZOT->RA_SINDICA + "," $ GETMV("ZZ_SINDNOT")
							nPosSind := RAT(ZOT->RA_SINDICA + ",", GETMV("ZZ_SINDNOT"))
							nAdNotIni := Val(SubStr(GETMV("ZZ_SINDNOT"), nPosSind + 3, 5))
							nAdNotFim := Val(SubStr(GETMV("ZZ_SINDNOT"), nPosSind + 9, 5))
							//nAdNotIni := 22.00
							//nAdNotFim := 07.00
						Else
							nAdNotIni := Val(SubStr(GETMV("ZZ_HRADNOT"), 1, 5))
							nAdNotFim := Val(SubStr(GETMV("ZZ_HRADNOT"), 7, 5))				
							//nAdNotIni := 22.00
							//nAdNotFim := 05.00
						EndIf

						nHoraIniTr1 := ZOT->P8_HORA
						ZOT->(dbSkip())
						nHoraFimTr1 := ZOT->P8_HORA
						ZOT->(dbSkip(-1))

						If nHoraFimTr1 > nAdNotIni .or. nHoraFimTr1 <= nAdNotFim .or. nHoraIniTr1 < nAdNotFim .or. nHoraIniTr1 >= nAdNotIni

							If nHoraIniTr1 < nAdNotIni .and. nHoraIniTr1 > nAdNotFim
								nHoraIniTr1 := nAdNotIni
							EndIf	                 

							If nHoraFimTr1 > nAdNotFim .and. nHoraFimTr1 < nAdNotIni
								nHoraFimTr1 := nAdNotFim
							EndIf	                 

							cHoraIniTr1 := PADL(ALLTRIM(STRTRAN(Transform(nHoraIniTr1,  "99.99"), ".", ":")), 5, "0") + ":00"
							cHoraFimTr1 := PADL(ALLTRIM(STRTRAN(Transform(nHoraFimTr1,  "99.99"), ".", ":")), 5, "0") + ":00"
							nHorasNot := ELAPTIME(cHoraIniTr1, cHoraFimTr1)
							cHorasNot := PADL(ALLTRIM(STRTRAN(Transform(nHorasNot, "99.99"), ".", ":")), 5, "0") + ":00"

							aItemOcor := {; 
							DTOC(ZOT->P8_DATA),; 
							"Ad. Noturno",; 
							cHorasNot,;
							ZOT->P8_FILIAL,;
							ZOT->P8_MAT,;
							ZOT->RA_NOME,;
							ZOT->P8_CC,;
							ZOT->RJ_DESC,;
							ZOT->RA_ADMISSA,;
							ZOT->R6_DESC;
							}	
							Aadd(aOcorrenc, aItemOcor)
							aItemOcor := {}

						EndIf

						ZOT->(dbSkip(2))            
						nHoraIniTr2 := ZOT->P8_HORA
						ZOT->(dbSkip())            
						nHoraFimTr1 := ZOT->P8_HORA
						ZOT->(dbSkip(-1))

						If nHoraFimTr2 > nAdNotIni .or. nHoraFimTr2 <= nAdNotFim .or. nHoraIniTr2 < nAdNotFim .or. nHoraIniTr2 >= nAdNotIni

							If nHoraIniTr2 < nAdNotIni .and. nHoraIniTr2 > nAdNotFim
								nHoraIniTr2 := nAdNotIni
							EndIf	                 

							If nHoraFimTr2 > nAdNotFim .and. nHoraFimTr2 < nAdNotIni
								nHoraFimTr2 := nAdNotFim
							EndIf	                 

							cHoraIniTr2 := PADL(ALLTRIM(STRTRAN(Transform(nHoraIniTr2,  "99.99"), ".", ":")), 5, "0") + ":00"
							cHoraFimTr2 := PADL(ALLTRIM(STRTRAN(Transform(nHoraFimTr2,  "99.99"), ".", ":")), 5, "0") + ":00"
							nHorasNot := ELAPTIME(cHoraIniTr2, cHoraFimTr2)
							cHorasNot := PADL(ALLTRIM(STRTRAN(Transform(nHorasNot, "99.99"), ".", ":")), 5, "0") + ":00"

							aItemOcor := {; 
							DTOC(ZOT->P8_DATA),; 
							"Ad. Noturno",; 
							cHorasNot,;
							ZOT->P8_FILIAL,;
							ZOT->P8_MAT,;
							ZOT->RA_NOME,;
							ZOT->P8_CC,;
							ZOT->RJ_DESC,;
							ZOT->RA_ADMISSA,;
							ZOT->R6_DESC;
							}	
							Aadd(aOcorrenc, aItemOcor)
							aItemOcor := {}

						EndIf

						ZOT->(dbSkip(-2))

					EndIf

				Else

					cChaveDiaF := ZOT->P8_FILIAL + ZOT->P8_MAT + P8_ORDEM
					aAreaZOT := ZOT->(GETAREA())
					While ZOT->(!EOF())	.and. ZOT->P8_FILIAL + ZOT->P8_MAT + P8_ORDEM == cChaveDiaF
						nHorPontAN += 1
						cChaveDiaF := ZOT->P8_FILIAL + ZOT->P8_MAT + P8_ORDEM
						ZOT->(dbSkip())
					EndDo
					ZOT->(RESTAREA(aAreaZOT))  

					If MOD(nHorPontAN, 2) == 0      

						//If ZOT->RA_SINDICA == "05"
						//If ZOT->RA_SINDICA + "," $ "|05,22:00,07:00|"
						If ZOT->RA_SINDICA + "," $ GETMV("ZZ_SINDNOT")
							nPosSind := RAT(ZOT->RA_SINDICA + ",", GETMV("ZZ_SINDNOT"))
							nAdNotIni := Val(SubStr(GETMV("ZZ_SINDNOT"), nPosSind + 3, 5))
							nAdNotFim := Val(SubStr(GETMV("ZZ_SINDNOT"), nPosSind + 9, 5))
							//nAdNotIni := 22.00
							//nAdNotFim := 07.00
						Else
							nAdNotIni := Val(SubStr(GETMV("ZZ_HRADNOT"), 1, 5))
							nAdNotFim := Val(SubStr(GETMV("ZZ_HRADNOT"), 7, 5))				
							//nAdNotIni := 22.00
							//nAdNotFim := 05.00
						EndIf

						nHoraIniTr1 := ZOT->P8_HORA
						ZOT->(dbSkip())
						nHoraFimTr1 := ZOT->P8_HORA
						ZOT->(dbSkip(-1))

						If nHoraFimTr1 > nAdNotIni .or. nHoraFimTr1 <= nAdNotFim .or. nHoraIniTr1 < nAdNotFim .or. nHoraIniTr1 >= nAdNotIni

							If nHoraIniTr1 < nAdNotIni .and. nHoraIniTr1 > nAdNotFim
								nHoraIniTr1 := nAdNotIni
							EndIf	                 

							If nHoraFimTr1 > nAdNotFim .and. nHoraFimTr1 < nAdNotIni
								nHoraFimTr1 := nAdNotFim
							EndIf	                 

							cHoraIniTr1 := PADL(ALLTRIM(STRTRAN(Transform(nHoraIniTr1,  "99.99"), ".", ":")), 5, "0") + ":00"
							cHoraFimTr1 := PADL(ALLTRIM(STRTRAN(Transform(nHoraFimTr1,  "99.99"), ".", ":")), 5, "0") + ":00"
							nHorasNot := ELAPTIME(cHoraIniTr1, cHoraFimTr1)
							cHorasNot := PADL(ALLTRIM(STRTRAN(Transform(nHorasNot, "99.99"), ".", ":")), 5, "0") + ":00"

							aItemOcor := {; 
							DTOC(ZOT->P8_DATA),; 
							"Ad. Noturno",; 
							cHorasNot,;
							ZOT->P8_FILIAL,;
							ZOT->P8_MAT,;
							ZOT->RA_NOME,;
							ZOT->P8_CC,;
							ZOT->RJ_DESC,;
							ZOT->RA_ADMISSA,;
							ZOT->R6_DESC;
							}	
							Aadd(aOcorrenc, aItemOcor)
							aItemOcor := {}

						EndIf

						ZOT->(dbSkip(2))            
						nHoraIniTr2 := ZOT->P8_HORA
						ZOT->(dbSkip())            
						nHoraFimTr1 := ZOT->P8_HORA
						ZOT->(dbSkip(-1))

						If nHoraFimTr2 > nAdNotIni .or. nHoraFimTr2 <= nAdNotFim .or. nHoraIniTr2 < nAdNotFim .or. nHoraIniTr2 >= nAdNotIni

							If nHoraIniTr2 < nAdNotIni .and. nHoraIniTr2 > nAdNotFim
								nHoraIniTr2 := nAdNotIni
							EndIf	                 

							If nHoraFimTr2 > nAdNotFim .and. nHoraFimTr2 < nAdNotIni
								nHoraFimTr2 := nAdNotFim
							EndIf	                 

							cHoraIniTr2 := PADL(ALLTRIM(STRTRAN(Transform(nHoraIniTr2,  "99.99"), ".", ":")), 5, "0") + ":00"
							cHoraFimTr2 := PADL(ALLTRIM(STRTRAN(Transform(nHoraFimTr2,  "99.99"), ".", ":")), 5, "0") + ":00"
							nHorasNot := ELAPTIME(cHoraIniTr2, cHoraFimTr2)
							cHorasNot := PADL(ALLTRIM(STRTRAN(Transform(nHorasNot, "99.99"), ".", ":")), 5, "0") + ":00"

							aItemOcor := {; 
							DTOC(ZOT->P8_DATA),; 
							"Ad. Noturno",; 
							cHorasNot,;
							ZOT->P8_FILIAL,;
							ZOT->P8_MAT,;
							ZOT->RA_NOME,;
							ZOT->P8_CC,;
							ZOT->RJ_DESC,;
							ZOT->RA_ADMISSA,;
							ZOT->R6_DESC;
							}	
							Aadd(aOcorrenc, aItemOcor)
							aItemOcor := {}

						EndIf

						ZOT->(dbSkip(-2))

					EndIf

				EndIf							

				nHorPontAN := 0

				aAreaZOT := ZOT->(GETAREA())                                 

				If SP3->(dbSeek(ZOT->P8_FILIAL+DTOS(ZOT->P8_DATA)))

					cDataFer := DTOC(ZOT->P8_DATA)

					cSDataTrab := ZOT->P8_DATA
					nHoraIni1 := ZOT->P8_HORA
					ZOT->(dbSkip())

					If cSDataTrab == ZOT->P8_DATA
						cSDataTrab := ZOT->P8_DATA
						nHoraFim1 := ZOT->P8_HORA
						ZOT->(dbSkip())
					EndIf	

					If cSDataTrab == ZOT->P8_DATA 
						cSDataTrab := ZOT->P8_DATA         
						nHoraIni2 := ZOT->P8_HORA
						ZOT->(dbSkip())
					EndIf

					If cSDataTrab == ZOT->P8_DATA
						cSDataTrab := ZOT->P8_DATA	
						nHoraFim2 := ZOT->P8_HORA
						ZOT->(dbSkip())          
					EndIf	

					If cSDataTrab == ZOT->P8_DATA 
						cSDataTrab := ZOT->P8_DATA
						nHoraIni3 := ZOT->P8_HORA
						ZOT->(dbSkip())
					EndIf	

					If cSDataTrab == ZOT->P8_DATA 
						cSDataTrab := ZOT->P8_DATA
						nHoraFim3 := ZOT->P8_HORA
						ZOT->(dbSkip())          
					EndIf	

					If cSDataTrab == ZOT->P8_DATA 
						cSDataTrab := ZOT->P8_DATA	
						nHoraIni4 := ZOT->P8_HORA
						ZOT->(dbSkip())
					EndIf

					If cSDataTrab == ZOT->P8_DATA 
						cSDataTrab := ZOT->P8_DATA	
						nHoraFim4 := ZOT->P8_HORA
					EndIf	

					cHoraIni1 := PADL(ALLTRIM(STRTRAN(Transform(nHoraIni1, "99.99"), ".", ":")), 5, "0") + ":00"
					cHoraFim1 := PADL(ALLTRIM(STRTRAN(Transform(nHoraFim1, "99.99"), ".", ":")), 5, "0") + ":00"
					cHoraIni2 := PADL(ALLTRIM(STRTRAN(Transform(nHoraIni2, "99.99"), ".", ":")), 5, "0") + ":00"
					cHoraFim2 := PADL(ALLTRIM(STRTRAN(Transform(nHoraFim2, "99.99"), ".", ":")), 5, "0") + ":00"
					cHoraIni3 := PADL(ALLTRIM(STRTRAN(Transform(nHoraIni3, "99.99"), ".", ":")), 5, "0") + ":00"
					cHoraFim3 := PADL(ALLTRIM(STRTRAN(Transform(nHoraFim3, "99.99"), ".", ":")), 5, "0") + ":00"
					cHoraIni4 := PADL(ALLTRIM(STRTRAN(Transform(nHoraIni4, "99.99"), ".", ":")), 5, "0") + ":00"
					cHoraFim4 := PADL(ALLTRIM(STRTRAN(Transform(nHoraFim4, "99.99"), ".", ":")), 5, "0") + ":00"

					cHorasFer1 := ELAPTIME(cHoraIni1, cHoraFim1)
					cHorasFer2 := ELAPTIME(cHoraIni2, cHoraFim2)
					cHorasFer3 := ELAPTIME(cHoraIni3, cHoraFim3)
					cHorasFer4 := ELAPTIME(cHoraIni4, cHoraFim4) 

					nHorasFer1 := VAL(SubStr(cHorasFer1,1,2) + "." + SubStr(cHorasFer1,4,2))
					nHorasFer2 := VAL(SubStr(cHorasFer2,1,2) + "." + SubStr(cHorasFer2,4,2))
					nHorasFer3 := VAL(SubStr(cHorasFer3,1,2) + "." + SubStr(cHorasFer3,4,2))
					nHorasFer4 := VAL(SubStr(cHorasFer4,1,2) + "." + SubStr(cHorasFer4,4,2))

					nHorasFer := SomaHoras(nHorasFer1, nHorasFer2)
					nHorasFer := SomaHoras(nHorasFer,  nHorasFer3)
					nHorasFer := SomaHoras(nHorasFer,  nHorasFer4)

					cHorasFer := PADL(ALLTRIM(STRTRAN(Transform(nHorasFer, "99.99"), ".", ":")), 5, "0") + ":00"

					aItemOcor := {; 
					cDataFer,; 
					"H.E. Feriado",; 
					cHorasFer,;
					ZOT->P8_FILIAL,;
					ZOT->P8_MAT,;
					ZOT->RA_NOME,;
					ZOT->P8_CC,;
					ZOT->RJ_DESC,;
					ZOT->RA_ADMISSA,;
					ZOT->R6_DESC;
					}	
					Aadd(aOcorrenc, aItemOcor)
					aItemOcor := {} 

					ZOT->(dbSkip())

				Else

					ZOT->(RESTAREA(aAreaZOT))

					For nCount2 := 1 to nHorarPont

						nHoraPon := P8_HORA

						If nCount2 == 1
							nHoraPad := SPJ->PJ_ENTRA1
							cHoraPon := PADL(ALLTRIM(STRTRAN(Transform(nHoraPon, "99.99"), ".", ":")), 5, "0") + ":00"
							cHoraPad := PADL(ALLTRIM(STRTRAN(Transform(nHoraPad, "99.99"), ".", ":")), 5, "0") + ":00"
							If nHoraPon > nHoraPad
								cExtAbsent := "Absent"
								cDifHora := ELAPTIME(cHoraPad, cHoraPon)
							EndIf
							If nHoraPon < nHoraPad
								cExtAbsent := "Extra"
								cDifHora := ELAPTIME(cHoraPon, cHoraPad)
							EndIf
						EndIf
						If nCount2 == 2
							nHoraPad := SPJ->PJ_SAIDA1
							cHoraPon := PADL(ALLTRIM(STRTRAN(Transform(nHoraPon, "99.99"), ".", ":")), 5, "0") + ":00"
							cHoraPad := PADL(ALLTRIM(STRTRAN(Transform(nHoraPad, "99.99"), ".", ":")), 5, "0") + ":00"
							If nHoraPon > nHoraPad
								cExtAbsent := "Extra"
								cDifHora := ELAPTIME(cHoraPad, cHoraPon)
							EndIf
							If nHoraPon < nHoraPad
								cExtAbsent := "Absent"
								cDifHora := ELAPTIME(cHoraPon, cHoraPad)
							EndIf
						EndIf
						If nCount2 == 3
							nHoraPad := SPJ->PJ_ENTRA2
							cHoraPon := PADL(ALLTRIM(STRTRAN(Transform(nHoraPon, "99.99"), ".", ":")), 5, "0") + ":00"
							cHoraPad := PADL(ALLTRIM(STRTRAN(Transform(nHoraPad, "99.99"), ".", ":")), 5, "0") + ":00"
							If nHoraPon > nHoraPad
								cExtAbsent := "Absent"
								cDifHora := ELAPTIME(cHoraPad, cHoraPon)
							EndIf
							If nHoraPon < nHoraPad
								cExtAbsent := "Extra"
								cDifHora := ELAPTIME(cHoraPon, cHoraPad)
							EndIf
						EndIf
						If nCount2 == 4
							nHoraPad := SPJ->PJ_SAIDA2
							cHoraPon := PADL(ALLTRIM(STRTRAN(Transform(nHoraPon, "99.99"), ".", ":")), 5, "0") + ":00"
							cHoraPad := PADL(ALLTRIM(STRTRAN(Transform(nHoraPad, "99.99"), ".", ":")), 5, "0") + ":00"
							If nHoraPon > nHoraPad
								cExtAbsent := "Extra"
								cDifHora := ELAPTIME(cHoraPad, cHoraPon)
							EndIf
							If nHoraPon < nHoraPad
								cExtAbsent := "Absent"
								cDifHora := ELAPTIME(cHoraPon, cHoraPad)
							EndIf
						EndIf
						If nCount2 == 5
							nHoraPad := SPJ->PJ_ENTRA3
							cHoraPon := PADL(ALLTRIM(STRTRAN(Transform(nHoraPon, "99.99"), ".", ":")), 5, "0") + ":00"
							cHoraPad := PADL(ALLTRIM(STRTRAN(Transform(nHoraPad, "99.99"), ".", ":")), 5, "0") + ":00"
							If nHoraPon > nHoraPad
								cExtAbsent := "Absent"
								cDifHora := ELAPTIME(cHoraPad, cHoraPon)
							EndIf
							If nHoraPon < nHoraPad
								cExtAbsent := "Extra"
								cDifHora := ELAPTIME(cHoraPon, cHoraPad)
							EndIf
						EndIf
						If nCount2 == 6
							nHoraPad := SPJ->PJ_SAIDA3
							cHoraPon := PADL(ALLTRIM(STRTRAN(Transform(nHoraPon, "99.99"), ".", ":")), 5, "0") + ":00"
							cHoraPad := PADL(ALLTRIM(STRTRAN(Transform(nHoraPad, "99.99"), ".", ":")), 5, "0") + ":00"
							If nHoraPon > nHoraPad
								cExtAbsent := "Extra"
								cDifHora := ELAPTIME(cHoraPad, cHoraPon)
							EndIf
							If nHoraPon < nHoraPad
								cExtAbsent := "Absent"
								cDifHora := ELAPTIME(cHoraPon, cHoraPad)
							EndIf
						EndIf
						If nCount2 == 7
							nHoraPad := SPJ->PJ_ENTRA4
							cHoraPon := PADL(ALLTRIM(STRTRAN(Transform(nHoraPon, "99.99"), ".", ":")), 5, "0") + ":00"
							cHoraPad := PADL(ALLTRIM(STRTRAN(Transform(nHoraPad, "99.99"), ".", ":")), 5, "0") + ":00"
							If nHoraPon > nHoraPad
								cExtAbsent := "Absent"
								cDifHora := ELAPTIME(cHoraPad, cHoraPon)
							EndIf
							If nHoraPon < nHoraPad
								cExtAbsent := "Extra"
								cDifHora := ELAPTIME(cHoraPon, cHoraPad)
							EndIf
						EndIf
						If nCount2 == 8
							nHoraPad := SPJ->PJ_SAIDA4
							cHoraPon := PADL(ALLTRIM(STRTRAN(Transform(nHoraPon, "99.99"), ".", ":")), 5, "0") + ":00"
							cHoraPad := PADL(ALLTRIM(STRTRAN(Transform(nHoraPad, "99.99"), ".", ":")), 5, "0") + ":00"
							If nHoraPon > nHoraPad
								cExtAbsent := "Extra"
								cDifHora := ELAPTIME(cHoraPad, cHoraPon)
							EndIf
							If nHoraPon < nHoraPad
								cExtAbsent := "Absent"
								cDifHora := ELAPTIME(cHoraPon, cHoraPad)
							EndIf
						EndIf

						If cExtAbsent <> ""

							If cExtAbsent == "Extra"
								nSdHrsHex := SomaHoras(nSdHrsHex, VAL(SUBSTR(cDifHora,1,2) + "." + SUBSTR(cDifHora,4,2)))						
							EndIf                   

							If cExtAbsent == "Absent"
								nSdHrsAbs := SomaHoras(nSdHrsAbs, VAL(SUBSTR(cDifHora,1,2) + "." + SUBSTR(cDifHora,4,2)))						
							EndIf

						EndIf

						ZOT->(dbSkip())

					Next

					nSdHrsAbs := nSdHrsAbs - nSdHrsAbs - nSdHrsAbs

					nSdHrAbsHe := SomaHoras(nSdHrsHex, nSdHrsAbs)

					If nSdHrAbsHe > 0
						If nSdHrAbsHe - 0.10 <= 0
							nSdHrAbsHe := 0
							cExtAbsent := ""
						Else
							cExtAbsent := "Extra"
						EndIf
					EndIf

					If nSdHrAbsHe < 0
						If nSdHrAbsHe + 0.10 >= 0
							nSdHrAbsHe := 0
							cExtAbsent := ""
						Else
							nSdHrAbsHe := nSdHrAbsHe - nSdHrAbsHe - nSdHrAbsHe
							cExtAbsent := "Absent"
						EndIf
					EndIf		 

					cDifHora := PADL(ALLTRIM(STRTRAN(Transform(nSdHrAbsHe, "99.99"), ".", ":")), 5, "0") + ":00"

					If cExtAbsent == "Extra" .and. ALLTRIM(cDifHora) <> "00:00:00"
						aItemOcor := {; 
						DTOC(ZOT->P8_DATA),; 
						"Hora Extra",; 
						cDifHora,;
						ZOT->P8_FILIAL,;
						ZOT->P8_MAT,;
						ZOT->RA_NOME,;
						ZOT->P8_CC,;
						ZOT->RJ_DESC,;
						ZOT->RA_ADMISSA,;
						ZOT->R6_DESC;
						}	
						Aadd(aOcorrenc, aItemOcor)
						aItemOcor := {}         
					EndIf

					If cExtAbsent == "Absent" .and. ALLTRIM(cDifHora) <> "00:00:00"
						aItemOcor := {; 
						DTOC(ZOT->P8_DATA),; 
						"Absenteísmo",; 
						cDifHora,;
						ZOT->P8_FILIAL,;
						ZOT->P8_MAT,;
						ZOT->RA_NOME,;
						ZOT->P8_CC,;
						ZOT->RJ_DESC,;
						ZOT->RA_ADMISSA,;
						ZOT->R6_DESC;
						}	
						Aadd(aOcorrenc, aItemOcor)
						aItemOcor := {}         
					EndIf

					cExtAbsent := ""

					nSdHrAbsHe := 0
					nSdHrsHex  := 0
					nSdHrsAbs  := 0

				EndIf	

				nHorarPont := 0

				ZOT->(dbSkip(-1))

			EndIf 

			nHorarPont := 0

		EndIf
		ZOT->(dbSkip()) 
		nHorarPont := 0

	EndDo  

	//Confere se os registros da tabela SPJ (Horário Padrão) estão de acordo com a tabela SP8 (Ponto Eletrônico)
	dbSelectArea("SPJ")
	SPJ->(dbSetOrder(1)) 
	dbSelectArea("SP8")  
	SP8->(dbSetOrder(2))
	dbSelectArea("SP3")
	SP3->(dbSetOrder(1))
	dbSelectArea("SPF")  
	SPF->(dbSetOrder(1))

	dbSelectArea("ZRA")
	ZRA->(dbGoTop())
	cFilMatAnt := ""
	While ZRA->(!EOF())

		If cFilMatAnt <> ZRA->RA_FILIAL + ZRA->RA_MAT

			//If Empty(ZRA->P8_DATA) .and. ZRA->RA_REGRA <> '02'
			If ZRA->RA_REGRA $ GETMV("ZZ_EXCPONT")
				lRegraExc := .T.
			Else
				lRegraExc := .F.
			EndIf
			If Empty(ZRA->P8_DATA) .and. lRegraExc == .F.
				aItemOcor := {; 
				"",; 
				"Não há registros no ponto",; 
				"",;
				ZRA->RA_FILIAL,;
				ZRA->RA_MAT,;
				ZRA->RA_NOME,;
				"",;
				ZRA->RJ_DESC,;
				ZRA->RA_ADMISSA,;
				"";
				}	
				Aadd(aOcorrenc, aItemOcor)
				aItemOcor := {}         

				ZRA->(dbSkip())
				Loop
			EndIf

			//If Empty(ZRA->P8_DATA) .and. ZRA->RA_REGRA == '02'
			If Empty(ZRA->P8_DATA) .and. ZRA->RA_REGRA $ GETMV("ZZ_EXCPONT")
				ZRA->(dbSkip())
				Loop
			EndIf

			dFirstDate := dDataIni
			dLastDate  := dDataFim
			dDataTrab := dFirstDate
			For nCount3 := 1 to 31
				If dDataTrab <= dLastDate

					If SPF->(dbSeek(ZRA->RA_FILIAL+ZRA->RA_MAT))
						While SPF->(!EOF()) .and. SPF->PF_FILIAL == ZRA->RA_FILIAL .and. SPF->PF_MAT == ZRA->RA_MAT
							SPF->(dbSkip())
							If SPF->PF_FILIAL <> ZRA->RA_FILIAL .or. SPF->PF_MAT <> ZRA->RA_MAT
								SPF->(dbSkip(-1))
								Exit
							EndIf
						EndDo
						cUltimaSeq := SPF->PF_SEQUEPA
					Else
						cUltimaSeq := ZOT->RA_SEQTURN
					EndIf

					//If SPJ->(dbSeek(xFilial("SPJ") + ZRA->P8_TURNO + ZRA->P8_SEMANA + CVALTOCHAR(DOW(dDataTrab))))
					If SPJ->(dbSeek(xFilial("SPJ") + ZRA->P8_TURNO + cUltimaSeq + CVALTOCHAR(DOW(dDataTrab))))
						If SPJ->PJ_TPDIA == "S"
							If !SP8->(dbSeek(ZRA->RA_FILIAL+ZRA->RA_MAT+DTOS(dDataTrab))) .and. !SP3->(dbSeek(ZRA->RA_FILIAL+DTOS(dDataTrab)))
								aItemOcor := {; 
								DTOC(dDataTrab),; 
								"Falta Integral",; 
								"",;
								ZRA->RA_FILIAL,;
								ZRA->RA_MAT,;
								ZRA->RA_NOME,;
								ZRA->P8_CC,;
								ZRA->RJ_DESC,;
								DTOC(STOD(ZRA->(RA_ADMISSA))),;
								"";
								}	
								Aadd(aOcorrenc, aItemOcor)
								aItemOcor := {} 
							EndIf
						EndIf				
					Else
						nResposta := Aviso("Inconformidade", "O Turno: " + ZRA->P8_TURNO + ", Sequência: " + cUltimaSeq + ", Dia da Semana: " + DIASEMANA(dDataTrab) + ", do Funcionário " + ALLTRIM(ZRA->RA_NOME) + ", Filial: " + ZRA->RA_FILIAL + ", Matrícula: " + ZRA->RA_MAT + ", não foi localizado na tabela de Horário Padrão. Esta mensagem pode aparecer muitas vezes. Deseja continuar com o processamento?", {"SIM", "NÃO"})
						If nResposta == 1
							Exit
						EndIf
						If nResposta == 2
							Return
						EndIf
					EndIf
				EndIf		            
				dDataTrab := DaySum(dDataTrab, 1)
			Next 

		EndIf	

		cFilMatAnt := ZRA->RA_FILIAL + ZRA->RA_MAT

		ZRA->(dbSkip())
	EndDo

	//aSort(aOcorrenc, , , {|x, y| x[4]+x[6]+DTOS(CTOD(x[1])) < y[4]+y[6]+DTOS(CTOD(y[1]))}) 

	/*
	cDataP8 := aOcorrenc[nCount5][1] 
	For nCount5 := 1 to Len(aOcorrenc)
	If (ALLTRIM(aOcorrenc[nCount5][2]) == "Absenteísmo" .or. ALLTRIM(aOcorrenc[nCount5][2]) == "Hora Extra") .and. cDataP8 == aOcorrenc[nCount5][1]
	If ALLTRIM(aOcorrenc[nCount5][2]) == "Absenteísmo"
	nHoraP8Abs := VAL(aOcorrenc[nCount5][1]) - VAL(aOcorrenc[nCount5][1]) - VAL(aOcorrenc[nCount5][1])
	EndIf 
	If ALLTRIM(aOcorrenc[nCount5][2]) == "Hora Extra"
	nHoraP8Hor := VAL(aOcorrenc[nCount5][1])
	EndIf
	cDataP8 := aOcorrenc[nCount5][1]  
	EndIf
	nTtAbsHor := SomaHoras(VAL(nHoraP8Abs), VAL(nHoraP8Hor))
	If nTtAbsHora >= 0
	"Hora Extra"	
	Else
	"Absenteísmo"	
	EndIf
	Next
	*/

	aSort(aOcorrenc, , , {|x, y| x[4]+x[6]+x[2]+DTOS(CTOD(x[1])) < y[4]+y[6]+y[2]+DTOS(CTOD(y[1]))}) 

	//DlgToExcel({ {"ARRAY", "", aOcorrenc, aOcorrenc} })

	ZOT->(dbCloseArea())

	// Estrutura da tabela temporaria
	Aadd(aCampos2, "P8_FILIAL")
	Aadd(aCampos2, "P8_MAT")
	Aadd(aCampos2, "RA_NOME")
	Aadd(aCampos2, "P8_CC")
	Aadd(aCampos2, "RJ_DESC")
	Aadd(aCampos2, "R6_DESC")

	For nCount := 1 to Len(aCampos2)
		aTamSx3 := TamSx3(aCampos2[nCount])
		Aadd(aRocponel2, {aCampos2[nCount], aTamSx3[3], aTamSx3[1], aTamSx3[2]})
	Next

	Aadd(aRocPonel2, {"OCORRENCIA","C",50,0})
	Aadd(aRocPonel2, {"P8_DATA","C",10,0})
	Aadd(aRocPonel2, {"P8_HORA","C",8,0})
	Aadd(aRocPonel2, {"RA_ADMISSA","C",10,0})

	If SELECT("ZOA") <> 0
		ZOA->(dbCloseArea())
	EndIf
	// Cria a tabela temporária
	cArqTrab := CriaTrab(aRocponel2,.T.)
	MsCreate(cArqTrab, aRocponel2, "DBFCDX")
	// Atribui a tabela temporária ao alias ZOA
	dbUseArea(.T., "DBFCDX", cArqTrab, "ZOA", .T., .F.)
	dbSelectArea("ZOA")

	// Copia da array para a tabela temporária
	For nCount4 := 1 to Len(aOcorrenc)
		RECLOCK("ZOA", .T.)             
		ZOA->P8_FILIAL 	:= aOcorrenc[nCount4][4]
		ZOA->P8_MAT 	:= aOcorrenc[nCount4][5]
		ZOA->RA_NOME 	:= aOcorrenc[nCount4][6]
		ZOA->P8_DATA	:= aOcorrenc[nCount4][1]
		ZOA->P8_HORA	:= aOcorrenc[nCount4][3]
		ZOA->P8_CC 		:= aOcorrenc[nCount4][7]
		ZOA->RJ_DESC 	:= aOcorrenc[nCount4][8]
		ZOA->RA_ADMISSA	:= CVALTOCHAR(aOcorrenc[nCount4][9])
		ZOA->R6_DESC 	:= aOcorrenc[nCount4][10]
		ZOA->OCORRENCIA := aOcorrenc[nCount4][2]
		ZOA->(MSUNLOCK())
	Next

	dbSelectArea("ZOA")
	ZOA->(dbgotop())   
	While ZOA->(!EOF())

		If cMatricAnt <> ZOA->P8_FILIAL + ZOA->P8_MAT

			If NLIN < 2200 - 250

				NLIN += 100 

				oPrn:Box( NLIN-40, 0100-10, NLIN+10, 0300-10)
				oPrn:Say( NLIN, 0100, "UNIDADE",	oFont2,050)
				oPrn:Box( NLIN-40, 0300-10, NLIN+10, 0500-10)
				oPrn:Say( NLIN, 0300, "MAT",		oFont2,050)	
				oPrn:Box( NLIN-40, 0500-10, NLIN+10, 1100-10)
				oPrn:Say( NLIN, 0500, "NOME",		oFont2,050)
				oPrn:Box( NLIN-40, 1100-10, NLIN+10, 1500-10)
				oPrn:Say( NLIN, 1100, "C.CUSTO",	oFont2,050)
				oPrn:Box( NLIN-40, 1500-10, NLIN+10, 1900-10)
				oPrn:Say( NLIN, 1500, "FUNÇÃO",		oFont2,050)
				oPrn:Box( NLIN-40, 1900-10, NLIN+10, 2300-10)
				oPrn:Say( NLIN, 1900, "ADMISSÃO",	oFont2,050)
				oPrn:Box( NLIN-40, 2300-10, NLIN+10, 3000-10)
				oPrn:Say( NLIN, 2300, "HORÁRIO",	oFont2,050)              

				NLIN += 50

				oPrn:Say( NLIN, 0100, ZOA->P8_FILIAL,      						oFont3,050)
				oPrn:Say( NLIN, 0300, ZOA->P8_MAT,      						oFont3,050)
				oPrn:Say( NLIN, 0500, ZOA->RA_NOME, 							oFont3,050)
				oPrn:Say( NLIN, 1100, ZOA->P8_CC,								oFont3,050)
				oPrn:Say( NLIN, 1500, ZOA->RJ_DESC, 							oFont3,050)
				oPrn:Say( NLIN, 1900, ZOA->RA_ADMISSA,							oFont3,050)
				oPrn:Say( NLIN, 2300, ZOA->R6_DESC,								oFont3,050)

				NLIN += 100

				oPrn:Box( NLIN-40, 0100-10, NLIN+10, 0300-10)
				oPrn:Say( NLIN, 0100, "DATA",			oFont2,050)
				oPrn:Box( NLIN-40, 0300-10, NLIN+10, 0700-10)
				oPrn:Say( NLIN, 0300, "OCORRÊNCIA",			oFont2,050)	
				oPrn:Box( NLIN-40, 0700-10, NLIN+10, 0900-10)
				oPrn:Say( NLIN, 0700, "HORAS",			oFont2,050)

				NLIN += 50

				oPrn:Say(NLIN, 0100, ZOA->P8_DATA,					  													oFont4,050)			
				oPrn:Say(NLIN, 0300, ZOA->OCORRENCIA,																	oFont4,050)
				oPrn:Say(NLIN, 0700, ZOA->P8_HORA,																		oFont4,050)			

				nTtEvento := SomaHoras(nTtEvento, VAL(SUBSTR(ZOA->P8_HORA,1,2) + "." + SUBSTR(ZOA->P8_HORA,4,2)))

				cDescrAnt := ZOA->OCORRENCIA
				ZOA->(dbSkip())
				If ZOA->OCORRENCIA <> cDescrAnt
					ZOA->(dbSkip(-1))
					NLIN += 50
					oPrn:Say(NLIN, 0300, "Total da Ocorrência: ", 						oFont3,050)
					oPrn:Say(NLIN, 0700, PADL(ALLTRIM(STRTRAN(Transform(nTtEvento, "99.99"), ".", ":")), 5, "0"), 	oFont3,050)
					nTtEvento := 0.00
					NLIN += 50      
				Else
					ZOA->(dbSkip(-1))	
				EndIf

			Else	

				nPagina := nPagina + 1
				oPrn:Say(2300, 2700, "Página: " + CVALTOCHAR(nPagina), oFont4,050)
				oPrn:Say(2300, 1400, "Emissão: " + DTOC(Date()), oFont4,050)
				oPrn:EndPage()
				oPrn:StartPage()
				oPrn:Say(0100, 1000, cTitulo ,oFont1,050)
				oPrn:Say(0200, 0960, "| Filial Ini: " + cFilIni + " | Filial Fim: " + cFilFim + " | Data Ini: " + DTOC(dDataIni) + " | Data Fim: " + DTOC(dDataFim) + " |", oFont5, 050)
				NLIN := 300
				oPrn:Box( NLIN-40, 0100-10, NLIN+10, 0300-10)
				oPrn:Say( NLIN, 0100, "UNIDADE",	oFont2,050)
				oPrn:Box( NLIN-40, 0300-10, NLIN+10, 0500-10)
				oPrn:Say( NLIN, 0300, "MAT",		oFont2,050)	
				oPrn:Box( NLIN-40, 0500-10, NLIN+10, 1100-10)
				oPrn:Say( NLIN, 0500, "NOME",		oFont2,050)
				oPrn:Box( NLIN-40, 1100-10, NLIN+10, 1500-10)
				oPrn:Say( NLIN, 1100, "C.CUSTO",	oFont2,050)
				oPrn:Box( NLIN-40, 1500-10, NLIN+10, 1900-10)
				oPrn:Say( NLIN, 1500, "FUNÇÃO",		oFont2,050)
				oPrn:Box( NLIN-40, 1900-10, NLIN+10, 2300-10)
				oPrn:Say( NLIN, 1900, "ADMISSÃO",	oFont2,050)
				oPrn:Box( NLIN-40, 2300-10, NLIN+10, 3000-10)
				oPrn:Say( NLIN, 2300, "HORÁRIO",	oFont2,050)              
				NLIN += 50
				oPrn:Say( NLIN, 0100, ZOA->P8_FILIAL,      						oFont3,050)
				oPrn:Say( NLIN, 0300, ZOA->P8_MAT,      						oFont3,050)
				oPrn:Say( NLIN, 0500, ZOA->RA_NOME, 							oFont3,050)
				oPrn:Say( NLIN, 1100, ZOA->P8_CC,								oFont3,050)
				oPrn:Say( NLIN, 1500, ZOA->RJ_DESC, 							oFont3,050)
				oPrn:Say( NLIN, 1900, ZOA->RA_ADMISSA,							oFont3,050)
				oPrn:Say( NLIN, 2300, ZOA->R6_DESC,								oFont3,050)
				NLIN += 100
				oPrn:Box( NLIN-40, 0100-10, NLIN+10, 0300-10)
				oPrn:Say( NLIN, 0100, "DATA",			oFont2,050)
				oPrn:Box( NLIN-40, 0300-10, NLIN+10, 0700-10)
				oPrn:Say( NLIN, 0300, "OCORRÊNCIA",			oFont2,050)	
				oPrn:Box( NLIN-40, 0700-10, NLIN+10, 0900-10)
				oPrn:Say( NLIN, 0700, "HORAS",			oFont2,050)

				NLIN += 50

				oPrn:Say(NLIN, 0100, ZOA->P8_DATA,					  													oFont4,050)			
				oPrn:Say(NLIN, 0300, ZOA->OCORRENCIA,																	oFont4,050)
				oPrn:Say(NLIN, 0700, ZOA->P8_HORA,																		oFont4,050)			

				nTtEvento := SomaHoras(nTtEvento, VAL(SUBSTR(ZOA->P8_HORA,1,2) + "." + SUBSTR(ZOA->P8_HORA,4,2)))

				cDescrAnt := ZOA->OCORRENCIA
				ZOA->(dbSkip())
				If ZOA->OCORRENCIA <> cDescrAnt
					ZOA->(dbSkip(-1))
					NLIN += 50
					oPrn:Say(NLIN, 0300, "Total do Ocorrência: ", 						oFont3,050)
					oPrn:Say(NLIN, 0700, PADL(ALLTRIM(STRTRAN(Transform(nTtEvento, "99.99"), ".", ":")), 5, "0"), 	oFont3,050)
					nTtEvento := 0.00
					NLIN += 50      
				Else
					ZOA->(dbSkip(-1))	
				EndIf

			EndIf

		EndIf		

		If cMatricAnt == ZOA->P8_FILIAL + ZOA->P8_MAT

			NLIN += 50

			oPrn:Say(NLIN, 0100, ZOA->P8_DATA,					  													oFont4,050)			
			oPrn:Say(NLIN, 0300, ZOA->OCORRENCIA,																	oFont4,050)
			oPrn:Say(NLIN, 0700, ZOA->P8_HORA,																		oFont4,050)			

			nTtEvento := SomaHoras(nTtEvento, VAL(SUBSTR(ZOA->P8_HORA,1,2) + "." + SUBSTR(ZOA->P8_HORA,4,2)))

			cDescrAnt := ZOA->OCORRENCIA
			ZOA->(dbSkip())
			If ZOA->OCORRENCIA <> cDescrAnt
				ZOA->(dbSkip(-1))
				NLIN += 50
				oPrn:Say(NLIN, 0300, "Total do Ocorrência: ", 						oFont3,050)
				oPrn:Say(NLIN, 0700, PADL(ALLTRIM(STRTRAN(Transform(nTtEvento, "99.99"), ".", ":")), 5, "0"), 	oFont3,050)
				nTtEvento := 0.00
				NLIN += 50      
			Else
				ZOA->(dbSkip(-1))	
			EndIf

		EndIf	

		cMatricAnt := ZOA->P8_FILIAL + ZOA->P8_MAT

		ZOA->(dbSkip()) 

		If NLIN > 2200
			nPagina := nPagina + 1
			oPrn:Say(2300, 2700, "Página: " + CVALTOCHAR(nPagina), oFont4,050)
			oPrn:Say(2300, 1400, "Emissão: " + DTOC(Date()), oFont4,050)
			oPrn:EndPage()
			oPrn:StartPage()
			oPrn:Say(0100, 1000, cTitulo ,oFont1,050)
			oPrn:Say(0200, 0960, "| Filial Ini: " + cFilIni + " | Filial Fim: " + cFilFim + " | Data Ini: " + DTOC(dDataIni) + " | Data Fim: " + DTOC(dDataFim) + " |", oFont5, 050)
			NLIN := 300
		EndIf

	EndDo	

	nPagina := nPagina + 1
	oPrn:Say(2300, 2700, "Página: " + CVALTOCHAR(nPagina), oFont4,050)
	oPrn:Say(2300, 1400, "Emissão: " + DTOC(Date()), oFont4,050)
	oPrn:EndPage()

	oPrn:Preview()

	MS_FLUSH()   

	ZOA->(dbCloseArea())    
	ZRA->(dbCloseArea())

Return  
