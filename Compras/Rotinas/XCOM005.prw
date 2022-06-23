#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"

#DEFINE ENTER CHR(13)+CHR(10)
#DEFINE cEOL CHR(13)+CHR(10)
/*------------------------------------------------------------------------------------------------------------------------------------------------*\
| Fonte:	 |	XCOM005.PRW                                                                                      	                               |
| Autor:	 |	Djalma Borges                                                                                                                      |
| Data:		 |	02/02/2016                                                                                                                         |
| Descrição: |	Ponto de Entrada para disparar wf de aprovação do pc a cada pedido gravado manualmente										       |
\*------------------------------------------------------------------------------------------------------------------------------------------------*/

User Function XCOM005(cPedido)

	Local oWF
	Local cIDWF := ""
	Local cSrLkWF := SuperGetMV("ZZ_SERVWF", ,"187.94.63.85:4007/")
	//Local cSrLkWF := "187.94.60.10:8754/"	// DESENV
	Local cNomeWF := 'APROVAPC'
	Local cLinkApr := "" 
	Local cEmail := ""
	Local cMailAp := ""
	Local cMsgBody := ""
	Local cNumAnt := ""          
	Local cQuery := ""
	Local cStSheetA1 := "" 
	Local cStSheetB1 := "" 
	Local aAprovaPC := {}
	Local cAprovAnt := ""
	Local cAprovador := ""
	Local nItem := 0
	Local cPedidoCom := ""
	Local nItens := 0
	Local nValorTT := 0
	Local nValorSC := 0
	Local cUserAprov := ""
	Local cChaveSAL := ""
	Local cChaveQPC := ""
	Local nDocuments := 0
	Local nCount := 0
	Local nDiasForn := 0
	Local dPrazoForn := Date()
	Local cPrazoForn := ""
	Local nDiasCateg := 0
	Local cArqTrab 	:= ""
	Local _cFilial	:= ""
	Local cNuser	:= ""
	Local cMailAp	:= ""
	Local cAliasDoc := GetNextAlias()
	Local aAnexos	:= {}
	Local cDirDoc	:= GetMv("MV_DIRDOC")
	Local aArea		:= GetArea()
	
	If Right(cDirDoc,1) <> "\"
		cDirDoc += "\"
	Endif
	
	cDirDoc += "CO" + cEmpAnt + "\" + If(FwModeAccess("ACB")="C","SHARED\","BR"+AllTrim(cFilAnt)+"\")	

	cQuery := "SELECT C7_FILIAL, C1_FILIAL, C1_NUM, C7_NUM, C1_SOLICIT, C7_USER, C1_EMISSAO, C7_EMISSAO, C7_ITEM, C7_PRODUTO, C7_DESCRI, C7_QUANT, C7_PRECO, C7_TOTAL"
	cQuery += ", C7_CC, C7_APROV, C7_CONAPRO, C7_FORNECE, C7_LOJA, C1_ZDTAPRO, C1_ZSCATSC, C1_ZCATCOM, C1_ZCATLIC, C1_DATPRF, C1_VUNIT "
	cQuery += "FROM " + RETSQLNAME("SC7") + " "
	cQuery += "LEFT JOIN " + RETSQLNAME("SC1") + " ON C1_FILIAL = C7_FILIAL AND C1_NUM = C7_NUMSC AND C7_NUM = C1_PEDIDO AND C1_ITEM = C7_ITEMSC AND C7_ITEM = C1_ITEMPED AND " + RETSQLNAME("SC1") + ".D_E_L_E_T_ <> '*' "
	cQuery += "WHERE " + RETSQLNAME("SC7") + ".D_E_L_E_T_ <> '*' AND C7_CONAPRO = 'B' AND C7_NUM ='"+cPedido+"' AND C7_CONTRA = ' ' "
	cQuery += "ORDER BY C7_APROV, C7_FILIAL, C7_NUM, C7_ITEM "

	cQuery := ChangeQuery(cQuery)
	If SELECT("QPC") <> 0
		QPC->(dbCloseArea())
	EndIf
	TCQUERY cQuery NEW ALIAS "QPC"

	// Copia da query para a tabela temporária
	dbSelectArea("QPC")
	QPC->(dbGoTop())

	cStSheetA1 := ""
	cStSheetB1 := ""

	oProcess:=TWFProcess():New(cNomeWF,"Pedidos de Compra aguardando Aprovação.")
	clArqHtml	:= "\workflow\AprovaPC1.htm"
	oProcess:NewTask(cNomeWF,clArqHtml)
	oHtml   := oProcess:oHtml

	//oWF := TWFProcess():New(cNomeWF, "Pedidos de Compra aguardando Aprovação.")                                               
	//oWF:NewTask(cNomeWF, "\workflow\AprovaPC1.htm")

	oHTML:ValByName('M0_NOMECOM', SM0->M0_NOMECOM)
	oHTML:ValByName('C1_FILIAL', SM0->M0_FILIAL)

	oHTML:ValByName('cChavePC1', QPC->C7_FILIAL + QPC->C7_NUM)

	cPedidoCom := QPC->C7_NUM
	_cFilial   := QPC->C7_FILIAL

	dbSelectArea("SC8")
	DBORDERNICKNAME("PEDIDOFORN")
	If SC8->(dbSeek(QPC->C7_FILIAL+QPC->C7_NUM+QPC->C7_FORNECE+QPC->C7_LOJA))
		nDiasForn := SC8->C8_PRAZO
		dPrazoForn := DaySum(QPC->C7_EMISSAO, nDiasForn)
		cPrazoForn := DTOC(dPrazoForn)
	Else
		cPrazoForn := "SEM COTAÇÃO"	
	EndIf

	If ALLTRIM(QPC->C1_ZCATCOM) == "Urgente/Emergente"
		nDiasCateg := GETMV("ZZ_PDEURGE")
	EndIf	
	//If ALLTRIM(QPC->C1_ZCATCOM) == "Contratação Simples"
	If ALLTRIM(QPC->C1_ZCATCOM) == "Contratacao Simples"
		nDiasCateg := GETMV("ZZ_PDECOSI")
	EndIf	
	//If ALLTRIM(QPC->C1_ZCATCOM) == "Pequenas contratações C/ parecer técnico"
	If ALLTRIM(QPC->C1_ZCATCOM) == "Pequenas contratacoes C/ parecer tecnico"
		nDiasCateg := GETMV("ZZ_PDEPECO")
	EndIf	
	//If ALLTRIM(QPC->C1_ZCATCOM) == "Grandes contratações C/ parecer técnico"
	If ALLTRIM(QPC->C1_ZCATCOM) == "Grandes contratacoes C/ parecer tecnico"
		nDiasCateg := GETMV("ZZ_PDEGRCO")
	EndIf	
	If Empty(QPC->C1_ZCATCOM)
		nDiasCateg := 0
	EndIf

	// Rafael Yera Barchi - 05/09/2018
	// Removido a pedido do usuário Ricardo Chagas
	//	nValorSC := RetValSC(QPC->C1_FILIAL, QPC->C1_NUM)
	nValorTT := RetValPC(QPC->C7_FILIAL, QPC->C7_NUM)

	//cStSheetA1 += '	    <th align=center style="vertical-align: middle;" BGCOLOR=LIGHTGRAY>Categ SC:<br>' + QPC->C1_ZSCATSC + '<br></th> '
	//cStSheetA1 += '	    <th align=center style="vertical-align: middle;" BGCOLOR=LIGHTGRAY>Prazo Categ:<br>' + CVALTOCHAR(nDiasCateg) + ' Dias<br></th> '
	//cStSheetA1 += '	    <th align=center style="vertical-align: middle;" BGCOLOR=LIGHTGRAY>Solicitante<br>' + ALLTRIM(QPC->C1_SOLICIT) + '<br></th> '
	//cStSheetA1 += '	    <th align=center style="vertical-align: middle;" BGCOLOR=LIGHTGRAY>Num. SC<br>' + QPC->C1_NUM + '<br></th> '
	//cStSheetA1 += '	    <th align=center style="vertical-align: middle;" BGCOLOR=LIGHTGRAY>Dt Aprov SC:<br>' + QPC->C1_ZDTAPRO + '<br></th> '
	//cStSheetA1 += '	    <th align=center style="vertical-align: middle;" BGCOLOR=LIGHTGRAY>Dt. Necessidade<br>' + QPC->C1_DATPRF + '<br></th> '
	// Rafael Yera Barchi - 05/09/2018
	// Removido a pedido do usuário Ricardo Chagas
	//	cStSheetA1 += '	    <th align=center style="vertical-align: middle;" BGCOLOR=LIGHTGRAY>Vlr SC:<br> R$ ' + Transform(nValorSC,"@E 999,999.99") + '<br></th> '
	cStSheetA1 += '	  <tr> '                                                                      
	cStSheetA1 += '	    <th align=center style="vertical-align: middle;" BGCOLOR=LIGHTGRAY>Unidade<br>' + FWFILIALNAME("01", QPC->C7_FILIAL, 1) + '<br></th> '
	//cStSheetA1 += '	    <th align=center style="vertical-align: middle;" BGCOLOR=LIGHTGRAY>Categ Compra:<br>' + QPC->C1_ZCATCOM + '<br></th> '
	//cStSheetA1 += '	    <th align=center style="vertical-align: middle;" BGCOLOR=LIGHTGRAY>Categ Licit:<br>' + QPC->C1_ZCATLIC + '<br></th> '
	cStSheetA1 += '	    <th align=center style="vertical-align: middle;" BGCOLOR=LIGHTGRAY>Comprador<br>' + ALLTRIM(USRRETNAME(QPC->C7_USER)) + '<br></th> '                                                                                           
	cStSheetA1 += '	    <th align=center style="vertical-align: middle;" BGCOLOR=LIGHTGRAY>Num. PC<br>' + QPC->C7_NUM + '<br></th> '
	cStSheetA1 += '	    <th align=center style="vertical-align: middle;" BGCOLOR=LIGHTGRAY>Data PC<br>' + SUBSTRING(QPC->C7_EMISSAO,7,2) + '/' + SUBSTRING(QPC->C7_EMISSAO,5,2) + '/' + SUBSTRING(QPC->C7_EMISSAO,1,4) + '<br></th> '
	//cStSheetA1 += '	    <th align=center style="vertical-align: middle;" BGCOLOR=LIGHTGRAY>Prazo Forn.<br>' + cPrazoForn + '<br></th> '
	cStSheetA1 += '	    <th align=center style="vertical-align: middle;" BGCOLOR=LIGHTGRAY>Vlr. PC<br> R$ ' + Transform(nValorTT,"@E 999,999,999.99") + '<br></th> '
	cStSheetA1 += '	    <th align=center style="vertical-align: middle;" BGCOLOR=LIGHTGRAY>Solicitante<br>' + ALLTRIM(QPC->C1_SOLICIT) + '<br></th> '
	cStSheetA1 += '	    <th align=center style="vertical-align: middle;" BGCOLOR=LIGHTGRAY>Num. SC<br>' + QPC->C1_NUM + '<br></th> '
	cStSheetA1 += '	    <th align=center style="vertical-align: middle;" BGCOLOR=LIGHTGRAY>Dt. Necessidade<br>' + SUBSTRING(QPC->C1_DATPRF,7,2) + '/' + SUBSTRING(QPC->C1_DATPRF,5,2) + '/' + SUBSTRING(QPC->C1_DATPRF,1,4) + '<br></th> '
	cStSheetA1 += '	</tr> '
	cStSheetA1 += '    <tr> '
	cStSheetA1 += '      <th align=center style="vertical-align: middle;">Item<br></th> '
	cStSheetA1 += '	     <th align=center style="vertical-align: middle;">Produto<br></th> '
	cStSheetA1 += '      <th align=center style="vertical-align: middle;">Descrição<br></th> '
	cStSheetA1 += '      <th align=center style="vertical-align: middle;">Quantidade<br></th> '
	cStSheetA1 += '	     <th align=center style="vertical-align: middle;">Vlr. Unitário<br></th> '
	cStSheetA1 += '	     <th align=center style="vertical-align: middle;">Vlr. Total<br></th> '
	cStSheetA1 += '	     <th align=center style="vertical-align: middle;">Fornecedor<br></th> '  
	cStSheetA1 += '	     <th align=center style="vertical-align: middle;">Centro de Custo<br></th> '
	cStSheetA1 += '    </tr> '

	cPedidoCom := QPC->C7_NUM

	While QPC->(!EOF())

		cStSheetB1 += '    <tr> '
		cStSheetB1 += '      <td align=center style="vertical-align: top;">' + QPC->C7_ITEM + '<br></td> '
		cStSheetB1 += '	     <td align=center style="vertical-align: top;">' + QPC->C7_PRODUTO + '<br></td> '
		cStSheetB1 += '      <td align=left   style="vertical-align: top;">' + ALLTRIM(QPC->C7_DESCRI) + '</td> '
		cStSheetB1 += '      <td align=center style="vertical-align: top;">' + CVALTOCHAR(QPC->C7_QUANT) + '</td> '
		cStSheetB1 += '	     <td align=center style="vertical-align: top;">R$ ' + Transform(QPC->C7_PRECO,"@E 999,999.99") + '</td> '
		cStSheetB1 += '	     <td align=center style="vertical-align: top;">R$ ' + Transform(QPC->C7_TOTAL,"@E 999,999.99") + '</td> '
		cStSheetB1 += '	     <td align=left   style="vertical-align: top;">' + ALLTRIM(POSICIONE("SA2",1,xFilial("SA2")+QPC->C7_FORNECE,"A2_NREDUZ")) + " - " + QPC->C7_LOJA + '</td> '                                        
		cStSheetB1 += '	     <td align=left   style="vertical-align: top;">' + ALLTRIM(POSICIONE("CTT",1,xFilial("CTT")+QPC->C7_CC,"CTT_DESC01")) + '</td> '
		cStSheetB1 += '    </tr> '	

		//Verifica existência de documentos no banco de conhecimento - Oficina1 - MH 11/02/2019
		
		cSql := "SELECT AC9_CODOBJ, ACB_OBJETO FROM "+RetSqlName("AC9")+" AC9, "+RetSqlName("ACB")+" ACB (NOLOCK) "
		cSql += " WHERE AC9_FILIAL = '"+xFilial("AC9")+"' "
		cSql += " AND AC9_FILENT = '"+_cFilial+"' "
		cSql += " AND AC9_ENTIDA = 'SC7' "
		cSql += " AND AC9_CODENT = '"+PadR(Alltrim(QPC->C7_FILIAL + QPC->C7_NUM + QPC->C7_ITEM),TamSX3("AC9_CODENT")[1])+"' "
		cSql += " AND AC9.D_E_L_E_T_ = ' ' "
		cSql += " AND ACB_FILIAL = '"+xFilial("ACB")+"' "
		cSql += " AND ACB_CODOBJ = AC9_CODOBJ "
		cSql += " AND ACB.D_E_L_E_T_ = ' ' "
		
		TcQuery cSql New Alias (cAliasDoc)
		
		While .NOT. Eof()
			aAdd(aAnexos, AllTrim(cDirDoc+(cAliasDoc)->ACB_OBJETO))
			DbSkip()
		EndDo	
		
		DbCloseArea(cAliasDoc)
		
		DbSelectArea("QPC")

		QPC->(dbSkip())
	EndDo
	QPC->(dbCloseArea())

	// Anexa documentos - Oficina1 - MH 11/02/2019
	
	oProcess:aAttFiles := aAnexos
	
	cStSheetB1 += '  </tbody> '
	cStSheetB1 += '</table> '

	oHTML:ValbyName("CodigoStyleSheetA1", cStSheetA1)
	oHTML:ValbyName("CodigoStyleSheetB1", cStSheetB1)

	//Verifica se exite documentos para serem liberado ainda
	dbSelectArea("SCR")
	SCR->(dbSetOrder(1))
	SCR->(dbGoTop())
	If SCR->(DBSeek(_cFilial + "PC"+cPedidoCom))
		//Verifica se existe aprovação para efetuar estorno
		While SCR->(!eof()) .and. SCR->CR_FILIAL == _cFilial .AND. Alltrim(SCR->CR_NUM) == cPedidoCom .AND. SCR->CR_TIPO == "PC" 
			IF SCR->CR_STATUS == "02" 
				cMailAp:=UsrRetMail(SCR->CR_USER)
				cNuser:=UsrRetName(SCR->CR_USER)
				lLiberado := .f.
			EndIf 
			SCR->(dbSkip())
		EndDo

	EndIf

	_user := Subs(cUsuario,7,15)
	oProcess:ClientName(_user)
	oProcess:cTo      := cMailAp//UsrRetMail(SY1->Y1_USER)  //AllTrim(GetMv("DBM_APRPED")) // DefiniÁ„o de e-mail padr„o, separar por ponto e vÌrgula
	oProcess:cBCC     := ''
	oProcess:cSubject := "BSL Workflow: Pedido de Compra " + cPedidoCom
	oProcess:cBody    := ""
	oProcess:bReturn  := "U_XCOMB005()"     //Define a FunÁ„o de Retorno

	cOldTo  := oProcess:cTo
	cOldCC  := oProcess:cCC
	cOldBCC := oProcess:cBCC

	//Uso um endereco invalido, apenas para criar o processo de workflow, mas sem envia-lo
	oProcess:cTo  := "000000" //"000001"
	oProcess:cCC  := NIL
	oProcess:cBCC := NIL
	
	cMailID    := oProcess:Start()  // Crio o processo e gravo o ID do processo de Workflow

	U_EnvLink(cMailID,cOldTo,cOldCC,cOldBCC,oProcess:cSubject, cFilAnt,"APROVAÇÃO DE PEDIDOS DE COMPRAS",oProcess,"000000", cNuser,"4",cPedidoCom)	

	RestArea(aArea)

Return

User Function XCOMB005(oProcess)

	Local cChaveSC1	:= oProcess:oHtml:RetByName("cChavePC1")
	Local _cFilial	:= SubStr(cChaveSC1, 1, 5)
	Local cPedido 	:= SubStr(cChaveSC1, 6, 6)
	Local cCheckBox1 := AllTrim(oProcess:oHtml:RetByName('AprRej1'))
	Local cMotivo    := AllTrim(oProcess:oHtml:RetByName('OBSERVAC1'))
	Local cMailAp := ""
	Local cNuser  := ""
	Local lLiberado := .T.
	Local cStSheetA1 := "" 
	Local cStSheetB1 := "" 
	Local aAprovaPC := {}
	Local cAprovAnt := ""
	Local cAprovador := ""
	Local nDiasForn := 0
	Local dPrazoForn := Date()
	Local cPrazoForn := ""
	Local nDiasCateg := 0
	Local oWF
	Local cNomeWF 	:= 'APROVAPC'
	Local nValorTT 	:= 0
	Local nValorSC 	:= 0
	Local cEmails  	:= ""
	Local lEmails   := .T.
	Local cPedidoCom := ""
	Local aArea		:= GetArea()
	Local aRetUser	:= {}
	
	oProcess:Finish()
	oProcess:Free()
	oProcess:= Nil

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Inicia Envio de Mensagem de Aviso³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	cQuery := "SELECT C7_FILIAL, C1_NUM, C7_NUM, C1_SOLICIT, C7_USER, C1_EMISSAO, C7_EMISSAO, C7_ITEM, C7_PRODUTO, C7_DESCRI, C7_QUANT, C7_PRECO, C7_TOTAL"
	cQuery += ", C7_CC, C7_APROV, C7_CONAPRO, C7_FORNECE, C7_LOJA, C1_ZDTAPRO, C1_ZSCATSC, C1_ZCATCOM, C1_ZCATLIC, C1_DATPRF, C1_VUNIT "
	cQuery += "FROM " + RETSQLNAME("SC7") + " "
	cQuery += "LEFT JOIN " + RETSQLNAME("SC1") + " ON C1_FILIAL = C7_FILIAL AND C1_NUM = C7_NUMSC AND C7_NUM = C1_PEDIDO AND C1_ITEM = C7_ITEMSC AND C7_ITEM = C1_ITEMPED AND " + RETSQLNAME("SC1") + ".D_E_L_E_T_ <> '*' "
	cQuery += "WHERE " + RETSQLNAME("SC7") + ".D_E_L_E_T_ <> '*' AND C7_CONAPRO = 'B' AND C7_NUM ='"+cPedido+"' "
	cQuery += "ORDER BY C7_APROV, C7_FILIAL, C7_NUM, C7_ITEM "

	cQuery := ChangeQuery(cQuery)
	If SELECT("QPC") <> 0
		QPC->(dbCloseArea())
	EndIf
	TCQUERY cQuery NEW ALIAS "QPC"

	If cCheckBox1 == "A"

		dbSelectArea("SCR")
		SCR->(dbSetOrder(1))
		SCR->(dbGoTop())
		If SCR -> ( DBSeek(_cFilial + "PC" + cPedido ))
			While SCR -> ( !EOF()) .and. SCR->CR_FILIAL == _cFilial .and. Alltrim(SCR->CR_NUM) == cPedido .AND. SCR->CR_TIPO == "PC"
				IF SCR->CR_STATUS == "02" 
					MaAlcDoc({SCR->CR_NUM,SCR->CR_TIPO,SCR->CR_TOTAL,SCR->CR_APROV,,SCR->CR_GRUPO,,,,,""},dDataBase,4)
					Exit		
				ENDIF	
				SCR->(dbSkip())
			EndDo
		ENDIF

		//Verifica se exite documentos para serem liberado ainda
		SCR->(dbGoTop())
		If SCR->(DBSeek(_cFilial + "PC" + cPedido ))
			//Verifica se existe aprovação para efetuar estorno
			While SCR->(!eof()) .and. SCR->CR_FILIAL == _cFilial .AND. Alltrim(SCR->CR_NUM) == cPedido .AND. SCR->CR_TIPO == "PC" 
				IF SCR->CR_STATUS == "02" 
					cMailAp:=UsrRetMail(SCR->CR_USER)
					cNuser:=UsrRetName(SCR->CR_USER)
					lLiberado := .f.
				EndIf 
				SCR->(dbSkip())
			EndDo

		EndIf
	EndIf	

	IF lLiberado == .f. .and. cCheckBox1 == "A"

		dbSelectArea("QPC")
		QPC->(dbGoTop())

		cStSheetA1 := ""
		cStSheetB1 := ""

		oProcess:=TWFProcess():New(cNomeWF,"Pedidos de Compra aguardando Aprovação.")
		clArqHtml	:= "\workflow\AprovaPC1.htm"
		oProcess:NewTask(cNomeWF,clArqHtml)
		oHtml   := oProcess:oHtml

		oHTML:ValByName('M0_NOMECOM', SM0->M0_NOMECOM)
		oHTML:ValByName('C1_FILIAL', SM0->M0_FILIAL)

		oHTML:ValByName('cChavePC1', QPC->C7_FILIAL + QPC->C7_NUM)

		cPedidoCom := QPC->C7_NUM
		_cFilial   := QPC->C7_FILIAL

		dbSelectArea("SC8")
		DBORDERNICKNAME("PEDIDOFORN")
		If SC8->(dbSeek(QPC->C7_FILIAL+QPC->C7_NUM+QPC->C7_FORNECE+QPC->C7_LOJA))
			nDiasForn := SC8->C8_PRAZO
			dPrazoForn := DaySum(QPC->C7_EMISSAO, nDiasForn)
			cPrazoForn := DTOC(dPrazoForn)
		Else
			cPrazoForn := "SEM COTAÇÃO"	
		EndIf

		If ALLTRIM(QPC->C1_ZCATCOM) == "Urgente/Emergente"
			nDiasCateg := GETMV("ZZ_PDEURGE")
		EndIf	
		//If ALLTRIM(QPC->C1_ZCATCOM) == "Contratação Simples"
		If ALLTRIM(QPC->C1_ZCATCOM) == "Contratacao Simples"
			nDiasCateg := GETMV("ZZ_PDECOSI")
		EndIf	
		//If ALLTRIM(QPC->C1_ZCATCOM) == "Pequenas contratações C/ parecer técnico"
		If ALLTRIM(QPC->C1_ZCATCOM) == "Pequenas contratacoes C/ parecer tecnico"
			nDiasCateg := GETMV("ZZ_PDEPECO")
		EndIf	
		//If ALLTRIM(QPC->C1_ZCATCOM) == "Grandes contratações C/ parecer técnico"
		If ALLTRIM(QPC->C1_ZCATCOM) == "Grandes contratacoes C/ parecer tecnico"
			nDiasCateg := GETMV("ZZ_PDEGRCO")
		EndIf	
		If Empty(QPC->C1_ZCATCOM)
			nDiasCateg := 0
		EndIf	
		
		nValorTT := RetValPC(QPC->C7_FILIAL, QPC->C7_NUM) // MH 12/08/2019

		//cStSheetA1 += '	    <th align=center style="vertical-align: middle;" BGCOLOR=LIGHTGRAY>Categ SC:<br>' + QPC->C1_ZSCATSC + '<br></th> '
		//cStSheetA1 += '	    <th align=center style="vertical-align: middle;" BGCOLOR=LIGHTGRAY>Prazo Categ:<br>' + CVALTOCHAR(nDiasCateg) + ' Dias<br></th> '
		//cStSheetA1 += '	    <th align=center style="vertical-align: middle;" BGCOLOR=LIGHTGRAY>Solicitante<br>' + ALLTRIM(QPC->C1_SOLICIT) + '<br></th> '
		//cStSheetA1 += '	    <th align=center style="vertical-align: middle;" BGCOLOR=LIGHTGRAY>Num. SC<br>' + QPC->C1_NUM + '<br></th> '
		//cStSheetA1 += '	    <th align=center style="vertical-align: middle;" BGCOLOR=LIGHTGRAY>Dt Aprov SC:<br>' + QPC->C1_ZDTAPRO + '<br></th> '
		//cStSheetA1 += '	    <th align=center style="vertical-align: middle;" BGCOLOR=LIGHTGRAY>Dt. Necessidade<br>' + QPC->C1_DATPRF + '<br></th> '
		// Rafael Yera Barchi - 05/09/2018
		// Removido a pedido do usuário Ricardo Chagas
		//	cStSheetA1 += '	    <th align=center style="vertical-align: middle;" BGCOLOR=LIGHTGRAY>Vlr SC:<br> R$ ' + Transform(nValorSC,"@E 999,999.99") + '<br></th> '
		cStSheetA1 += '	  <tr> '                                                                      
		cStSheetA1 += '	    <th align=center style="vertical-align: middle;" BGCOLOR=LIGHTGRAY>Unidade<br>' + FWFILIALNAME("01", QPC->C7_FILIAL, 1) + '<br></th> '
		//cStSheetA1 += '	    <th align=center style="vertical-align: middle;" BGCOLOR=LIGHTGRAY>Categ Compra:<br>' + QPC->C1_ZCATCOM + '<br></th> '
		//cStSheetA1 += '	    <th align=center style="vertical-align: middle;" BGCOLOR=LIGHTGRAY>Categ Licit:<br>' + QPC->C1_ZCATLIC + '<br></th> '
		cStSheetA1 += '	    <th align=center style="vertical-align: middle;" BGCOLOR=LIGHTGRAY>Comprador<br>' + ALLTRIM(USRRETNAME(QPC->C7_USER)) + '<br></th> '                                                                                           
		cStSheetA1 += '	    <th align=center style="vertical-align: middle;" BGCOLOR=LIGHTGRAY>Num. PC<br>' + QPC->C7_NUM + '<br></th> '
		cStSheetA1 += '	    <th align=center style="vertical-align: middle;" BGCOLOR=LIGHTGRAY>Data PC<br>' + SUBSTRING(QPC->C7_EMISSAO,7,2) + '/' + SUBSTRING(QPC->C7_EMISSAO,5,2) + '/' + SUBSTRING(QPC->C7_EMISSAO,1,4) + '<br></th> '
		//cStSheetA1 += '	    <th align=center style="vertical-align: middle;" BGCOLOR=LIGHTGRAY>Prazo Forn.<br>' + cPrazoForn + '<br></th> '
		cStSheetA1 += '	    <th align=center style="vertical-align: middle;" BGCOLOR=LIGHTGRAY>Vlr. PC<br> R$ ' + Transform(nValorTT,"@E 999,999,999.99") + '<br></th> '
		cStSheetA1 += '	    <th align=center style="vertical-align: middle;" BGCOLOR=LIGHTGRAY>Solicitante<br>' + ALLTRIM(QPC->C1_SOLICIT) + '<br></th> '
		cStSheetA1 += '	    <th align=center style="vertical-align: middle;" BGCOLOR=LIGHTGRAY>Num. SC<br>' + QPC->C1_NUM + '<br></th> '
		cStSheetA1 += '	    <th align=center style="vertical-align: middle;" BGCOLOR=LIGHTGRAY>Dt. Necessidade<br>' + SUBSTRING(QPC->C1_DATPRF,7,2) + '/' + SUBSTRING(QPC->C1_DATPRF,5,2) + '/' + SUBSTRING(QPC->C1_DATPRF,1,4) + '<br></th> '
		cStSheetA1 += '	</tr> '
		cStSheetA1 += '    <tr> '
		cStSheetA1 += '      <th align=center style="vertical-align: middle;">Item<br></th> '
		cStSheetA1 += '	     <th align=center style="vertical-align: middle;">Produto<br></th> '
		cStSheetA1 += '      <th align=center style="vertical-align: middle;">Descrição<br></th> '
		cStSheetA1 += '      <th align=center style="vertical-align: middle;">Quantidade<br></th> '
		cStSheetA1 += '	     <th align=center style="vertical-align: middle;">Vlr. Unitário<br></th> '
		cStSheetA1 += '	     <th align=center style="vertical-align: middle;">Vlr. Total<br></th> '
		cStSheetA1 += '	     <th align=center style="vertical-align: middle;">Fornecedor<br></th> '  
		cStSheetA1 += '	     <th align=center style="vertical-align: middle;">Centro de Custo<br></th> '
		cStSheetA1 += '    </tr> '

		While QPC->(!EOF())

			cStSheetB1 += '    <tr> '
			cStSheetB1 += '      <td align=center style="vertical-align: top;">' + QPC->C7_ITEM + '<br></td> '
			cStSheetB1 += '	     <td align=center style="vertical-align: top;">' + QPC->C7_PRODUTO + '<br></td> '
			cStSheetB1 += '      <td align=left   style="vertical-align: top;">' + ALLTRIM(QPC->C7_DESCRI) + '</td> '
			cStSheetB1 += '      <td align=center style="vertical-align: top;">' + CVALTOCHAR(QPC->C7_QUANT) + '</td> '
			cStSheetB1 += '	     <td align=center style="vertical-align: top;">R$ ' + Transform(QPC->C7_PRECO,"@E 999,999.99") + '</td> '
			cStSheetB1 += '	     <td align=center style="vertical-align: top;">R$ ' + Transform(QPC->C7_TOTAL,"@E 999,999.99") + '</td> '
			cStSheetB1 += '	     <td align=left   style="vertical-align: top;">' + ALLTRIM(POSICIONE("SA2",1,xFilial("SA2")+QPC->C7_FORNECE,"A2_NREDUZ")) + " - " + QPC->C7_LOJA + '</td> '                                        
			cStSheetB1 += '	     <td align=left   style="vertical-align: top;">' + ALLTRIM(POSICIONE("CTT",1,xFilial("CTT")+QPC->C7_CC,"CTT_DESC01")) + '</td> '
			cStSheetB1 += '    </tr> '	

			QPC->(dbSkip())
		EndDo

		cStSheetB1 += '  </tbody> '
		cStSheetB1 += '</table> '

		oHTML:ValbyName("CodigoStyleSheetA1", cStSheetA1)
		oHTML:ValbyName("CodigoStyleSheetB1", cStSheetB1)

		_user := Subs(cUsuario,7,15)
		oProcess:ClientName(_user)
		oProcess:cTo      := cMailAp//UsrRetMail(SY1->Y1_USER)  //AllTrim(GetMv("DBM_APRPED")) // DefiniÁ„o de e-mail padr„o, separar por ponto e vÌrgula
		oProcess:cBCC     := ''
		oProcess:cSubject := "BSL Workflow: Pedido de Compra " + cPedidoCom
		oProcess:cBody    := ""
		oProcess:bReturn  := "U_XCOMB005()"     //Define a FunÁ„o de Retorno

		cOldTo  := oProcess:cTo
		cOldCC  := oProcess:cCC
		cOldBCC := oProcess:cBCC

		//Uso um endereco invalido, apenas para criar o processo de workflow, mas sem envia-lo
		oProcess:cTo  := "000000" //"000001"
		oProcess:cCC  := NIL
		oProcess:cBCC := NIL

		cMailID    := oProcess:Start()  // Crio o processo e gravo o ID do processo de Workflow

		U_EnvLink(cMailID,cOldTo,cOldCC,cOldBCC,oProcess:cSubject, cFilAnt,"APROVAÇÃO DE PEDIDOS DE COMPRA",oProcess,"000000", cNuser,"4",cPedidoCom)		

	EndIf

	//Libera pedido de compras
	IF lLiberado == .T. .and. cCheckBox1 == "A"
		dbSelectArea("SC7")
		SC7->(dbSetOrder(1))

		If SC7->(dbSeek(_cFilial+cPedido))

			While SC7->(!EOF()) .AND. SC7->C7_FILIAL == _cFilial .and. SC7->C7_NUM == cPedido
				RecLock("SC7", .F.)

				SC7->C7_CONAPRO := "L"

				SC7->(MsUnLock())

				SC7->(dbSkip())
			EndDo
			
			// Envia email
			U_EnvPCApr(_cFilial,cPedido)
			
		Endif
	EndIf

	If cCheckBox1 == "R"

		dbSelectArea("SCR")
		SCR->(DBSetOrder(1))
		SCR->(dbGoTop())
		If SCR->(DBSeek(xFilial("SCR") + "PC" + cPedido))
			While SCR->(!eof()) .and. Alltrim(SCR->CR_NUM) == cPedido .AND. SCR->CR_TIPO == "PC"
				IF SCR->CR_STATUS == "02" 
					MaAlcDoc({SCR->CR_NUM,SCR->CR_TIPO,,SCR->CR_APROV,,SCR->CR_GRUPO,,,,dDataBase,cMotivo}, dDataBase ,6)		
				ENDIF	
				SCR->(dbSkip())
			EndDo
		ENDIF

		//rejeita o pedido
		dbSelectArea("SC7")
		SC7->(dbSetOrder(1))
		If SC7->(dbSeek(_cFilial+cPedido))
			While SC7->(!EOF()) .AND. SC7->C7_FILIAL == _cFilial .and. SC7->C7_NUM == cPedido
				RecLock("SC7", .F.)
				SC7->C7_CONAPRO := "R"
				SC7->(MsUnLock())
				SC7->(dbSkip())
			EndDo
		Endif

		DbSelectArea("SC1")
		SC1->(dbSetOrder(6))
		SC1->(dbSeek(_cFilial+cPEdido))

		oProcess:=TWFProcess():New(cNomeWF,"WORKFLOW PARA APROVACAO DE SC")
		clArqHtml	:= "\workflow\WFPEDIDOREPROVADO.html"
		oProcess:NewTask(cNomeWF,clArqHtml)
		oHtml   := oProcess:oHtml

		oHTML:ValByName('cNumSol', SC1->C1_NUM)
		oHTML:ValByName('cNumPed', cPedido)
		oHTML:ValByName('cMOTIVO', cMotivo)

		//Pega email do solicitante
		cMailAp:=UsrRetMail(SC1->C1_USER)

		//Pega email dos compradores
		dbSelectArea("SY1")
		SY1->(dbSetOrder(1))
		SY1->(dbGoTop())
		While SY1->(!EOF())
			If Alltrim(SY1->Y1_FILIAL) == substr(_cFilial,1,2)
				If !Empty(SY1->Y1_EMAIL) .and. lEmails == .T.
					cEmails := cEmails + "; " + ALLTRIM(SY1->Y1_EMAIL)
				EndIf	
				If !Empty(SY1->Y1_EMAIL) .and. lEmails == .F.
					cEmails := ALLTRIM(SY1->Y1_EMAIL)
					lEmails := .T.
				EndIf

			EndIf
			SY1->(dbSkip())
		EndDo	

		IF !Empty(cEmails)
			cMailAp:= cMailAp+"; "+cEmails
		Endif
		_user := cNuser//Subs(cUsuario,7,15)
		oProcess:ClientName(_user)
		oProcess:cTo      := cMailAp//UsrRetMail(SY1->Y1_USER)  //AllTrim(GetMv("DBM_APRPED")) // DefiniÁ„o de e-mail padr„o, separar por ponto e vÌrgula
		oProcess:cBCC     := ''
		oProcess:cSubject := "BSL Workflow: Pedido de Compra " + cPedidoCom + " reprovado!" 
		oProcess:cBody    := ""
		oProcess:bReturn  := ""     //Define a FunÁ„o de Retorno
		cMailID    := oProcess:Start()  // Crio o processo e gravo o ID do processo de Workflow	

	EndIf
	WfSendMail({cEmpAnt, cFilAnt})
	RestArea(aArea)
Return()

//------------------------------------------------------------------------------------------
/*/{Protheus.doc} RetValSC
// Retorna valor total da SC

@author    	Rafael Yera Barchi
@since     	05/09/2018
@version   	1.xx
@type 		function
@param		Nil

/*/
//------------------------------------------------------------------------------------------
Static Function RetValSC(_cFilSC, _cNumSC)

	Local cSQL 		:= ""
	Local nTotalSC	:= 0
	Local cAliasTRB	:= GetNextAlias()

	//--< Procedimentos >-------------------------------------------------------------------
	//------------------------------------------------------------------------
	// Aqui eu seleciono todos os status que devem ser integrados
	//------------------------------------------------------------------------
	cSQL := " SELECT SUM(C1_QUANT * C1_VUNIT) VALSC " + cEOL
	cSQL += "   FROM " + RetSqlName("SC1") + " SC1 " + cEOL
	cSQL += "  WHERE C1_FILIAL = '" + _cFilSC + "' " + cEOL
	cSQL += "    AND C1_NUM = '" + _cNumSC + "' " + cEOL
	cSQL += "    AND D_E_L_E_T_ = ' ' " + cEOL

	If Select(cAliasTRB) > 0
		(cAliasTRB)->(DBCloseArea())
	EndIf
	DBUseArea(.T., "TOPCONN", TCGenQry( , , cSQL), (cAliasTRB), .F., .T.)

	(cAliasTRB)->(DBSelectArea(cAliasTRB))
	(cAliasTRB)->(DBGoTop())
	While !(cAliasTRB)->(EOF())
		nTotalSC := (cAliasTRB)->VALSC 
		(cAliasTRB)->(DBSkip())
	EndDo

	If Select(cAliasTRB) > 0
		(cAliasTRB)->(DBCloseArea())
	EndIf

Return nTotalSC

//------------------------------------------------------------------------------------------
/*/{Protheus.doc} RetValPC
// Retorna valor total do PC

@author    	Rafael Yera Barchi
@since     	05/09/2018
@version   	1.xx
@type 		function
@param		Nil

/*/
//------------------------------------------------------------------------------------------
Static Function RetValPC(_cFilPC, _cNumPC)

	Local cSQL 		:= ""
	Local nTotalPC	:= 0
	Local cAliasTRB	:= GetNextAlias()

	//--< Procedimentos >-------------------------------------------------------------------
	//------------------------------------------------------------------------
	// Aqui eu seleciono todos os status que devem ser integrados
	//------------------------------------------------------------------------
	cSQL := " SELECT SUM(C7_TOTAL) VALPC " + cEOL
	cSQL += "   FROM " + RetSqlName("SC7") + " SC7 " + cEOL
	cSQL += "  WHERE C7_FILIAL = '" + _cFilPC + "' " + cEOL
	cSQL += "    AND C7_NUM = '" + _cNumPC + "' " + cEOL
	cSQL += "    AND D_E_L_E_T_ = ' ' " + cEOL

	If Select(cAliasTRB) > 0
		(cAliasTRB)->(DBCloseArea())
	EndIf
	DBUseArea(.T., "TOPCONN", TCGenQry( , , cSQL), (cAliasTRB), .F., .T.)

	(cAliasTRB)->(DBSelectArea(cAliasTRB))
	(cAliasTRB)->(DBGoTop())
	While !(cAliasTRB)->(EOF())
		nTotalPC := (cAliasTRB)->VALPC 
		(cAliasTRB)->(DBSkip())
	EndDo

	If Select(cAliasTRB) > 0
		(cAliasTRB)->(DBCloseArea())
	EndIf

Return nTotalPC

/*
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
++-------------------------------------------------------------------------++
++ Função    | ReePCApr   | Autor  | Rafael Gama		  | Data | 11/04/2019 ++
++-------------------------------------------------------------------------++
++ Descrição | Re-Envia email Pedido Aprovado para o Comprador pelo botao  ++
++-------------------------------------------------------------------------++
++ Obs       |  Rotina chamada pelo PE: MT121BRW                           ++
++-------------------------------------------------------------------------++
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
*/
User Function ReePCApr()

	IF SC7->C7_CONAPRO <> "B" .AND. SC7->C7_CONAPRO <> "R"
		U_EnvPCApr(SC7->C7_FILIAL,SC7->C7_NUM)
		MSGALERT("E-mail enviado.")
	Else
		MSGALERT("Status não permitido para o reenvio do WF!")
	Endif

Return
/*
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
++-------------------------------------------------------------------------++
++ Função    | EnvPCApr   | Autor  | Marcio Hernandes  | Data | 03/03/2019 ++
++-------------------------------------------------------------------------++
++ Descrição | Envia email Pedido Aprovado para o Comprador                ++
++-------------------------------------------------------------------------++
++ Obs       |                                                             ++
++-------------------------------------------------------------------------++
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
*/
User Function EnvPCApr(_cFilial,cPedido)
	Local aArea := GetArea()
	Local lRet := .T.
	Local cMailAp := ""
	Local cAliasDoc := GetNextAlias()
	Local aAnexos	:= {}
	Local cNomeWF 	:= 'APROVAPC'
	Local oProcess
	Local cEmailSol := ""
	Local dDtSolicit:= CtoD("")
	Local cCond 	:= ""
	Local cCodComp 	:= ""
	Local cNomeComp := ""
	Local cMsgBody 	:= ""
	Local aSM0		:= {}
	Local cDocAnex 	:= SuperGetMv("ES_DOCANPC",,"")
	Local aDocAnex 	:= {}
	Local cMailId	:= ""
	Local nTotPed 	:= 0
	Local nTotFre 	:= 0

	If .NOT. Empty(cDocAnex)
		aDocAnex := StrTokArr(cDocAnex,";")
	Endif

	DbSelectArea("SC7")
	SC7->(dbSetOrder(1))

	If SC7->(dbSeek(_cFilial+cPedido))
		// Envio do email com o pedido para o comprador - Oficina1 - MH
		cMailAp := ""

		IF Empty(SC7->C7_CONTRA)

			DbSelectArea("SY1")
			DbSetOrder(3)
			If MsSeek(xFilial("SY1")+SC7->C7_USER)
				cMailAp := SY1->Y1_EMAIL
			Endif
		Else
			DbSelectArea("SY1")
			DbGoTop()
			While !EOF()
				cMailAp += ALLTRIM(SY1->Y1_EMAIL)+";"
				dbSkip()
			EndDo
		Endif

		DbSelectArea("SA2")
		DbSetOrder(1)
		MsSeek(xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA)

		oProcess := TWFProcess():New(cNomeWF,"Pedido de Compra Aprovado")
		oProcess:NewTask(cNomeWF,"\workflow\WFPEDIDOAPROVADO.html")
		oHtml   := oProcess:oHtml

		DbSelectArea("SC1")
		SC1->(dbSetOrder(6))
		SC1->(dbSeek(_cFilial+cPedido))

		dDtSolicit:= Posicione("SC1" , 1 , xFilial("SC1")+SC7->C7_NUMSC, "C1_EMISSAO")
		cCond	  := SC7->C7_COND +" - " + Posicione("SE4",1,xFilial("SE4")+SC7->C7_COND,"E4_DESCRI")
		cCodComp  := SC7->C7_USER
		cNomeComp := AllTrim(UsrRetName(SC7->C7_USER))

		// Dados do Solicitante

		cNomeUser := AllTrim(SC1->C1_SOLICIT)

		// Defino a ordem
		PswOrder(2) // Ordem de nome

		// Efetuo a pesquisa, definindo se pesquiso usuário ou grupo
		If PswSeek(cNomeUser,.T.)

			// Obtenho o resultado conforme vetor
			aRetUser := PswRet(1)

			cEmailSol := Lower(alltrim(aRetUser[1,14]))

		EndIf

		aSM0 := FWArrFilAtu(,SC7->C7_FILIAL)

		DbSelectArea("SM0")
		SM0->(DbGoto(aSM0[SM0_RECNO]))

	/*
	oHtml:ValByName( "unifat"		, SC7->C7_FILIAL+" - "+FwFilialName(cEmpAnt,SC7->C7_FILIAL,1 ))
	oHtml:ValByName( "endempfat"	, AllTrim(SM0->M0_ENDCOB) + " " + SM0->M0_COMPCOB )
	oHtml:ValByName( "baiempfat"	, SM0->M0_BAIRCOB )
	oHtml:ValByName( "cepempfat"	, Transform(SM0->M0_CEPCOB,"@R 99999-999"))
	oHtml:ValByName( "cidempfat"	, AllTrim(SM0->M0_CIDCOB)+" - "+SM0->M0_ESTCOB )
	oHtml:ValByName( "cnpjempfat"	, Transform(SM0->M0_CGC,"@R 99.999.999/9999-99") )
	*/

		aSM0 := FwArrFilAtu(,SC7->C7_FILENT) // Retorna dados da filial

		DbSelectArea("SM0")
		SM0->(DbGoto(aSM0[SM0_RECNO]))

		oHtml:ValByName( "unientcom"	, SM0->M0_NOMECOM )
		oHtml:ValByName( "unient"		, SC7->C7_FILENT+" - "+FwFilialName(cEmpAnt,SC7->C7_FILENT,1 ))
		oHtml:ValByName( "endempent"	, AllTrim(SM0->M0_ENDENT)+ " " + SM0->M0_COMPENT )
		oHtml:ValByName( "baiempent"	, SM0->M0_BAIRENT )
		oHtml:ValByName( "cepempent"	, Transform(SM0->M0_CEPENT,"@R 99999-999"))
		oHtml:ValByName( "cidempent"	, AllTrim(SM0->M0_CIDENT)+" - "+SM0->M0_ESTENT )
		oHtml:ValByName( "cnpjempent"	, Transform(SM0->M0_CGC,"@R 99.999.999/9999-99") )

		oHtml:ValByName( "pedido"		, SC7->C7_NUM )
		oHtml:ValByName( "emissao"		, SC7->C7_EMISSAO )
		oHtml:ValByName( "fornecedor"	, SC7->C7_FORNECE+"-"+SC7->C7_LOJA )
		oHtml:ValByName( "lb_nome"		, AllTrim(SA2->A2_NOME) )
		oHtml:ValByName( "endereco"		, SA2->A2_END )
		oHtml:ValByName( "bairro"		, SA2->A2_BAIRRO )
		oHtml:ValByName( "cidade"		, SA2->A2_MUN)
		oHtml:ValByName( "emailforn"	, Lower(SA2->A2_EMAIL))
		oHtml:ValByName( "uf"			, SA2->A2_EST )
		oHtml:ValByName( "cep" 			, Transform(SA2->A2_CEP,"@R 99999-999") )
		oHtml:ValByName( "cnpj"	 		, Transform(SA2->A2_CGC,If(SA2->A2_TIPO="J","@R 99.999.999/9999-99","@R 999.999.999-99")) )
		oHtml:ValByName( "lb_solicitante",AllTrim(SC1->C1_SOLICIT))
		oHtml:ValByName( "emailsolicit"  ,cEmailSol)
		oHtml:ValByName( "condpag"		, cCond )
		oHtml:ValByName( "coduser"		, cCodComp )
		oHtml:ValByName( "comprador"	, cNomeComp )

		nTotPed := 0
		nTotFre := 0

		DbSelectArea("SC7")

		While SC7->(!EOF()) .AND. SC7->C7_FILIAL == _cFilial .and. SC7->C7_NUM == cPedido

			aAdd(oHtml:ValByName("it.item")   ,SC7->C7_ITEM)
			aAdd(oHtml:ValByName("it.codigo") ,SC7->C7_PRODUTO)
			aAdd(oHtml:ValByName("it.descri") ,SC7->C7_DESCRI)
			aAdd(oHtml:ValByName("it.obs")    ,SC7->C7_OBS)
			aAdd(oHtml:ValByName("it.dtneces"),cValToChar(SC7->C7_DATPRF))
			aAdd(oHtml:ValByName("it.um")     ,SC7->C7_UM)
			aAdd(oHtml:ValByName("it.quant")  ,TransForm(SC7->C7_QUANT,PesqPict("SC7","C7_QUANT")))
			aAdd(oHtml:ValByName("it.preco")  ,TransForm(SC7->C7_PRECO,PesqPict("SC7","C7_PRECO")))
			aAdd(oHtml:ValByName("it.total")  ,TransForm(SC7->C7_TOTAL,PesqPict("SC7","C7_TOTAL")))

			nTotPed += SC7->C7_TOTAL
			nTotFre += SC7->C7_VALFRE

			SC7->(dbSkip())
		EndDo

		oHtml:ValByName("lbFrete",TransForm(nTotFre,PesqPict("SC7","C7_VALFRE")))
		oHtml:ValByName("lbValor",TransForm(nTotPed+nTotFre,PesqPict("SC7","C7_TOTAL")))



		cMsgBody := "<html><p>" + "Prezado Fornecedor," + "</p>"
		cMsgBody += "<p>" + "Segue pedido de compra BSL - "+cPedido+"." + "</p>"
		cMsgBody += "<p>" + "Favor confirmar recebimento."+ "</p>"
		cMsgBody += "<p>" + "Atenciosamente,"+ "</p>" + "<p></p>"
		cMsgBody += "<p>" + "BSL - SUPRIMENTOS"+ "</p></html>"
	/*
	cMsgBody := "Prezado Fornecedor," + Chr(13)+Chr(10) 
	cMsgBody += "Segue pedido de compra BSL - "+cPedido+"." + chr(13)+Chr(10) 
	cMsgBody += "Favor confirmar recebimento." + chr(13)+Chr(10) 
	cMsgBody += "Atenciosamente,"+ chr(13)+Chr(10) 
	cMsgBody += "BSL - SUPRIMENTOS"+ chr(13)+Chr(10) 
	*/
		// Anexa documentos - Oficina1 - MH 26/02/2019

		oProcess:aAttFiles := aDocAnex

		oProcess:oWF:lHtmlBody := .F. // Enviar html como anexo

		If .NOT. Empty(cMailAp)
			oProcess:cTo      := cMailAp
			oProcess:cBCC     := ''
			oProcess:cSubject := "BSL - Pedido de Compra " + cPedido + " "
			oProcess:cBody    := cMsgBody
			oProcess:bReturn  := ""     //Define a FunÁ„o de Retorno
			cMailId := oProcess:Start()  // Crio o processo e gravo o ID do processo de Workflow
			Conout("Email aprovação enviado "+cMailId)
		Else
			lRet := .F.
			ConOut("XCOMB005 -> Pedido de Compra: "+cPedido+" Aprovado mas não existe email cadastrado para envio na SY1.")
		Endif
	Else
		lRet := .F.
	Endif

	RestArea(aArea)

Return lRet
