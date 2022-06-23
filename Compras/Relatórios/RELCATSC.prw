#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"

/*------------------------------------------------------------------------------------------------------------------------------------------------*\
| Fonte:	 |	RELCATSC.PRW                                                                                                                       |
| Autor:	 |	Djalma Borges                                                                                                                      |
| Data:		 |	10/11/2015                                                                                                                         |
| Descrição: |	Relatório de itens da Solicitação de Compra com informações referentes à customização de categorização.						       |
\*------------------------------------------------------------------------------------------------------------------------------------------------*/

User Function RELCATSC()

	Local oDlg
	Local oDataIni
	Local dDataIni := dDataBase
	Local oDataFim
	Local dDataFim := dDataBase
	Local oProdIni
	Local cProdIni := Space(10)
	Local oProdFim
	Local cProdFim := Space(10)
	Local oFilIni
	Local cFilIni := Space(5)
	Local oFilFim
	Local cFilFim := Space(5)
	Local oSolicit
	Local cSolicit := Space(6)
	Local oNumSCIni
	Local cNumSCIni := Space(6)
	Local oNumSCFim
	Local cNumSCFim := Space(6)

	Local oBtnOk
	Local oBtnCancel

	Define MSDialog oDlg Title "FOLLOW-UP SOLICITAÇÕES DE COMPRA" From 0,0 To 400,300 Pixel

	@10,10 Say "FILIAL INI: " Pixel Of oDlg
	@10,60 MSGet oFilIni Var cFilIni Size 20,10 Pixel Of oDlg

	@25,10 Say "FILIAL FIM: " Pixel Of oDlg
	@25,60 MSGet oFilFim Var cFilFim Size 20,10 Pixel Of oDlg

	@45,10 Say "DATA INI: " Pixel Of oDlg
	@45,60 MSGet oDataIni Var dDataIni Size 50,10 Pixel Of oDlg

	@60,10 Say "DATA FIM: " Pixel Of oDlg
	@60,60 MSGet oDataFim Var dDataFim Size 50,10 Pixel Of oDlg

	@80,10 Say "NUM.SC INI: " Pixel Of oDlg
	@80,60 MSGet oNumSCIni Var cNumSCIni Size 50,10 Pixel F3 "SC1" Of oDlg

	@95,10 Say "NUM.SC FIM: " Pixel Of oDlg
	@95,60 MSGet oNumSCFim Var cNumSCFim Size 50,10 Pixel F3 "SC1" Of oDlg				

	@115,10 Say "PRODUTO INI: " Pixel Of oDlg
	@115,60 MSGet oProdIni Var cProdIni Size 50,10 Pixel F3 "SB1" Of oDlg

	@130,10 Say "PRODUTO FIM: " Pixel Of oDlg
	@130,60 MSGet oProdFim Var cProdFim Size 50,10 Pixel F3 "SB1" Of oDlg

	@150,10 Say "SOLICITANTE: " Pixel Of oDlg
	@150,60 MSGet oSolicit Var cSolicit Size 50,10 Pixel F3 "SAI" Of oDlg

	@170,10 Button oBtnOk     Prompt "Ok"       Size 30,15 Pixel Action {||U_AgProces(dDataIni, dDataFim, cProdIni, cProdFim, cFilIni, cFilFim, cNumSCIni, cNumSCFim, cSolicit), oDlg:End()} Of oDlg
	@170,70 Button oBtnCancel Prompt "Cancelar" Size 30,15 Pixel Action {||oDlg:End()} Of oDlg

	Activate MSDialog oDlg Centered

Return

User Function AgProces(dDataIni, dDataFim, cProdIni, cProdFim, cFilIni, cFilFim, cNumSCIni, cNumSCFim, cSolicit)

	Processa( {|| U_ProcExc(dDataIni, dDataFim, cProdIni, cProdFim, cFilIni, cFilFim, cNumSCIni, cNumSCFim, cSolicit) }, "Aguarde...", "Exportando dados para o Excel...",.F.)

Return

User Function ProcExc(dDataIni, dDataFim, cProdIni, cProdFim, cFilIni, cFilFim, cNumSCIni, cNumSCFim, cSolicit)

	Local aCabec := {}
	Local aDados := {}

	Local dDtLibPed := ""
	Local cNumCotac := ""
	Local dDataCotac := ""
	Local dDtPedido := ""
	Local cNumPed := ""
	Local cItemPed := ""
	Local dDataNF := "" 
	Local dDtClassif := ""
	Local dVctoPagar := ""
	Local dDtEntrega := "" 
	Local nDiasRest := 0
	Local nTempoAt := 0
	Local nTAprPed := 0
	Local cTitulo := ""
	Local cContrato := ""
	Local nTempoClas := 0
	Local cComprador := ""
	Local nQtSdPed := 0
	Local cDocSD1 := "" 
	Local nQtNota := 0
	Local nParcEtg := 0
	Local nItensRepl := 0
	Local nCount := 0
	Local cFornece := ""
	Local cLojaForn := ""

	Local cQuery := ""

	Local lFilIniEx := .F.
	Local lFilFimEx := .F.

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
	ALERT("QRY NOVA")
	cQuery := "SELECT *"
	cQuery += "FROM " + RetSqlName("SC1")
	cQuery += "WHERE " + RetSqlName("SC1") + ".D_E_L_E_T_ <> '*' AND C1_APROV = 'L' AND C1_RESIDUO <> 'S' "
	If !Empty(cFilIni) .and. !Empty(cFilFim)
		cQuery += "AND C1_FILIAL >= '" + cFilIni + "' AND C1_FILIAL <= '" + cFilFim + "' "
	Else
		cFilIni := xFilial("SC1")
		cFilFim := xFilial("SC1")
		cQuery += "AND C1_FILIAL >= '" + cFilIni + "' AND C1_FILIAL <= '" + cFilFim + "' "
	EndIf	
	If DTOC(dDataIni) <> "  /  /    " .and. DTOC(dDataFim) <> "  /  /    "
		cQuery += "AND C1_EMISSAO >= '" + DTOS(dDataIni) + "' AND C1_EMISSAO <= '" + DTOS(dDataFim) + "' "
	EndIf	
	If cNumSCIni <> "      " .and. cNumSCFim <> "      "
		cQuery += "AND C1_NUM >= '" + cNumSCIni + "' AND C1_NUM <= '" + cNumScFim + "' "
	EndIf	
	If cProdIni <> "          " .and. cProdFim <> "          "
		cQuery += "AND C1_PRODUTO >= '" + cProdIni + "' AND C1_PRODUTO <= '" + cProdFim + "' "
	EndIf	
	If cSolicit <> "      "	
		cQuery += "AND C1_SOLICIT = '" + UsrRetName(cSolicit) + "' "
	EndIf	
	cQuery += "ORDER BY C1_FILIAL, C1_NUM, C1_ITEM"

	cQuery := ChangeQuery(cQuery)
	If SELECT('QSC') <> 0
		QSC->(dbCloseArea())
	Endif
	TCQUERY cQuery NEW ALIAS "QSC"

	If !ApOleClient("MSExcel")
		MsgAlert("Microsoft Excel não instalado!")
		Return Nil
	EndIf

	aCabec := ;
	{"FILIAL",;
	"TIPO SC",;
	"DATA SC",;
	"NUM.SOLIC.COM",;
	"NR.ITEM",;
	"COD.ITEM",;
	"DESCRIÇÃO ITEM",;
	"QTDE SC",;
	"QTDE NF",;
	"QT SD PED",;
	"SOLICITANTE",;
	"CENTRO CUSTO",;
	"DATA DESEJADA",;
	"OBSERVAÇÕES",;
	"DT. APROV. SC",;
	"PRAZO ATENDIM.",;
	"DIAS RESTANTES",;
	"TEMPO ATENDIM.",;
	"NUM. COTAÇÃO",;
	"DT. ENVIO COT.",;
	"CONTRATO",;
	"CATEGORIA COMPRA",;
	"CATEGORIA LICITAÇÃO",;
	"DATA DO PEDIDO",;
	"COMPRADOR",;
	"NUM. PEDIDO",;
	"FORNECEDOR",;
	"LOJA",;
	"ITEM PEDIDO",;
	"DT. APROV. PEDIDO",;
	"TEMPO APROV. PEDIDO",;    
	"NUMERO NF",;
	"DATA ENTREGA",;
	"DATA NF",;
	"DATA CLASSIFIC.",;
	"TEMPO CLASSIFIC.",;
	"DATA PGTO"}

	dbSelectArea("SCR")
	dbSetOrder(1)

	dbSelectArea("SC8")
	DBORDERNICKNAME("NUMPRODTIT")

	dbSelectArea("SC7")
	DBORDERNICKNAME("PEDPRODITE")

	dbSelectArea("SD1")
	DBORDERNICKNAME("PEDCODITEM")

	dbSelectArea("SE2")
	DBORDERNICKNAME("NUMVENCTO")

	//dbSelectArea("SF1")
	//dbSetOrder(1)

	dbSelectArea("QSC")
	dbGoTop()
	ProcRegua(RecCount())
	While QSC->(!EOF()) 

		IncProc()       

		If !Empty(QSC->C1_PEDIDO)
			If SCR->(dbSeek(QSC->C1_FILIAL+"PC"+QSC->C1_PEDIDO))
				dDtLibPed := SCR->CR_DATALIB
			Else
				dDtLibPed := CTOD("  /  /    ")
			EndIf	
		Else
			dDtLibPed := CTOD("  /  /    ")
		EndIf	

		If QSC->C1_ZDTPRAZ <> "        " .and. DTOC(dDtLibPed) <> "  /  /    "
			nTempoAt := DateDiffDay(dDtLibPed, STOD(QSC->C1_ZDTAPRO))
		Else
			nTempoAt := 0
		EndIf				 

		If SC8->(dbSeek(QSC->C1_FILIAL+QSC->C1_NUM+QSC->C1_PRODUTO+QSC->C1_ITEM))
			cNumCotac := SC8->C8_NUM
			dDataCotac := SC8->C8_EMISSAO
			If SC8->C8_TPDOC == "1"
				cContrato := "N"
			ElseIf SC8->C8_TPDOC == "2"
				cContrato := "S"
			EndIf		
		Else
			cNumCotac := ""
			dDataCotac := CTOD("  /  /    ")
			cContrato := ""
		EndIf

		If SC7->(dbSeek(QSC->C1_FILIAL+QSC->C1_PEDIDO+QSC->C1_PRODUTO+QSC->C1_ITEM))

			dDtPedido := SC7->C7_EMISSAO
			cNumPed := SC7->C7_NUM
			cItemPed := SC7->C7_ITEM
			cComprador := Alltrim(UsrRetName(SC7->C7_USER))
			cFornece := SC7->C7_FORNECE 
			cLojaForn := SC7->C7_LOJA

			If SD1->(dbSeek(SC7->C7_FILIAL+SC7->C7_NUM+SC7->C7_PRODUTO+SC7->C7_ITEM))

				While SD1->(!EOF()) .and. SD1->D1_FILIAL == SC7->C7_FILIAL ;
				.and. SD1->D1_PEDIDO == SC7->C7_NUM .and. SD1->D1_COD == SC7->C7_PRODUTO .and. SD1->D1_ITEMPC == SC7->C7_ITEM
					nParcEtg += 1	
					SD1->(dbSkip())
				EndDo

				SD1->(dbSeek(SC7->C7_FILIAL+SC7->C7_NUM+SC7->C7_PRODUTO+SC7->C7_ITEM))

				If nItensRepl > 0
					For nCount := 1 to (nParcEtg - (nParcEtg - nItensRepl))
						SD1->(dbSkip())
					Next	
				EndIf	

				dDtEntrega := SD1->D1_ZDTETG
				dDataNf := SD1->D1_EMISSAO
				cDocSD1 := SD1->D1_DOC
				nQtNota := SD1->D1_QUANT

				If nItensRepl == 0
					nQtSdPed := QSC->C1_QUANT - SD1->D1_QUANT
				Else
					nQtSdPed := nQtSdPed - SD1->D1_QUANT
				EndIf

				If Empty(SD1->D1_TES)
					dDtPreNF := SD1->D1_DTDIGIT
					dDtClass := CTOD("  /  /    ")
				Else
					dDtPreNF := CTOD("  /  /    ")
					dDtClass := SD1->D1_DTDIGIT
					If DTOC(dDtEntrega) <> "  /  /    "
						nTempoClas := DateDiffDay(dDtClass, dDtEntrega)
					Else
						nTempoClas := 0
					EndIf		
				EndIf

				If SE2->(dbSeek(SD1->D1_FILIAL+SD1->D1_DOC))
					dVctoPagar := SE2->E2_VENCTO
				Else
					dVctoPagar := CTOD("  /  /    ")	
				EndIf

			Else

				dDataNf := CTOD("  /  /    ")	
				dDtPreNF := CTOD("  /  /    ")	
				dDtClass := CTOD("  /  /    ")	
				dVctoPagar := CTOD("  /  /    ")	
				dDtEntrega := CTOD("  /  /    ")	
				cDocSD1 := ""
				nQtSdPed := 0
				nQtNota := 0

			EndIf

		Else

			dDataNf := CTOD("  /  /    ")	
			dDtPreNF := CTOD("  /  /    ")	
			dDtClass := CTOD("  /  /    ")	
			dVctoPagar := CTOD("  /  /    ")	
			dDtEntrega := CTOD("  /  /    ")	
			cDocSD1 := ""
			nQtSdPed := 0
			nQtNota := 0

			dDtPedido := CTOD("  /  /    ")	
			cNumPed := ""
			cItemPed := ""
			cComprador := ""
			cFornece := ""
			cLojaForn := ""

		EndIf

		If DTOC(dDtPedido) <> "  /  /    " .and. DTOC(dDtLibPed) <> "  /  /    "
			nTAprPed := DateDiffDay(dDtPedido, dDtLibPed)
		Else
			nTAprPed := 0
		EndIf				 

		If QSC->C1_ZDTPRAZ <> "        " .and. DTOC(dDtPedido) == "  /  /    " 
			nDiasRest := DateDiffDay(dDataBase, STOD(QSC->C1_ZDTPRAZ) )
			If DTOS(dDataBase) > QSC->C1_ZDTPRAZ
				nDiasRest := nDiasRest - nDiasRest - nDiasRest
			EndIf	
		Else
			nDiasRest := 0
		EndIf

		AAdd(aDados,;
		{CHR(160)+QSC->C1_FILIAL,;
		CHR(160)+QSC->C1_ZCATSC,;
		CHR(160)+DTOC(STOD(QSC->C1_EMISSAO)),;
		CHR(160)+QSC->C1_NUM,;
		CHR(160)+QSC->C1_ITEM,;
		CHR(160)+QSC->C1_PRODUTO,;
		CHR(160)+QSC->C1_DESCRI,;
		QSC->C1_QUANT,;
		nQtNota,;
		nQtSdPed,;
		CHR(160)+QSC->C1_SOLICIT,;
		CHR(160)+QSC->C1_CC,;
		CHR(160)+DTOC(STOD(QSC->C1_DATPRF)),;
		CHR(160)+QSC->C1_OBS,;
		CHR(160)+DTOC(STOD(QSC->C1_ZDTAPRO)),;
		CHR(160)+DTOC(STOD(QSC->C1_ZDTPRAZ)),;
		nDiasRest,;
		nTempoAt,;
		CHR(160)+cNumCotac,;
		CHR(160)+DTOC(dDataCotac),;
		CHR(160)+cContrato,;
		CHR(160)+QSC->C1_ZCATCOM,;
		CHR(160)+QSC->C1_ZCATLIC,;
		CHR(160)+DTOC(dDtPedido),;
		CHR(160)+cComprador,;		
		CHR(160)+cNumPed,;
		CHR(160)+cFornece,;
		CHR(160)+cLojaForn,;
		CHR(160)+cItemPed,;
		CHR(160)+DTOC(dDtLibPed),;
		nTAprPed,;
		CHR(160)+cDocSD1,;
		CHR(160)+DTOC(dDtEntrega),;
		CHR(160)+DTOC(dDataNF),;
		CHR(160)+DTOC(dDtClass),;
		nTempoClas,;
		CHR(160)+DTOC(dVctoPagar)})

		If nParcEtg > 1 .and. nItensRepl < (nParcEtg - 1)
			If nParcEtg == (nItensRepl + 1)
				nItensRepl := 0
			EndIf	
			nParcEtg := 0
			nItensRepl += 1
			Loop       
		EndIf

		nParcEtg := 0
		nItensRepl := 0

		QSC->(dbSkip())

	EndDo

	QSC->(dbCloseArea())

	cTitulo := "Empresa: " + ALLTRIM(SM0->M0_NOMECOM) + " - Filial: " + ALLTRIM(FWFILIALNAME(SUBSTR(xFilial("SC1"),1,2), xFilial("SC1"), 1)) + " | Filial Ini: " + cFilIni + " - Filial Fim: " + cFilFim + " | Período: " + DTOC(dDataIni) + " - " + DTOC(dDataFim) + " | De Num.SC: " + cNumSCIni + " - Até Num.SC: " + cNumSCFim + " | De Produto: " + cProdIni + " - Até Produto: " + cProdFim + " | Solicitante: " + cSolicit

	DlgToExcel({ {"ARRAY", cTitulo, aCabec, aDados} })

Return Nil
