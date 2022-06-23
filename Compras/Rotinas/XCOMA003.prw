#include 	"rwmake.ch"
#include 	"TbiConn.ch"
#include 	"TbiCode.ch"
#INCLUDE 	"PROTHEUS.CH"
#INCLUDE 	"topconn.ch"

#DEFINE 	cEOL			Chr(13) + Chr(10)


user function XCOMA003(cNumSc,cTipo,cPedido)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Declaração de Variaveis³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	Local 	nRec      	:= 0
	Local 	cObs       	:= ""
	Local 	cTipoSCR   	:= IIF(cTipo == '05', '06', '02')

	Private oHtml
	Private _aRetUser 	:= {}
	Private cAliasAPR	:= GetNextAlias()


	SetPrvt("OHTML,OHTML2,_lCreditOk,_lEstoq_Ok,_nOpcao")
	SetPrvt("_cPedido,_cCliente,_aSCSemEst,_aOPSemEst,_lSemCredito,_cPedido")
	SetPrvt("_nQtd,_cNumsc1,_cItemSc1,_csubject")
	SetPrvt("wvlrtot","wvlrtab")
	SetPrvt("nCount,_user")
	SetPrvt("cTO, cCC, cBCC, cSubject, cBody")


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Faz select no pedido com solicitação de compras para verificar se o
	// do pedido está diferente da solcitação
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	BeginSQL Alias cAliasAPR

		SELECT CR_NUM,C7_FILIAL,CR_GRUPO,CR_USER,DBM_ITEM,C7_DESCRI,C7_TOTAL,C1_VUNIT,C7_NUM,C7_UM,C7_QUANT,C1_QUANT,C1_SOLICIT,ISNULL(CONVERT(VARCHAR(2047), CONVERT(VARBINARY(2047), CR_OBS)),'') AS CR_OBS 
		FROM %Table:SCR% SCR
		LEFT JOIN %Table:DBM% DBM ON CR_NUM = DBM_NUM AND DBM_TIPO='C2' AND CR_APROV = DBM_USAPRO 
		AND CR_USER = DBM_USER AND CR_GRUPO = DBM_GRUPO AND DBM_FILIAL = %xFilial:DBM%

		INNER JOIN %Table:SC7% SC7 ON C7_NUMSC = CR_NUM AND C7_ITEM = DBM_ITEM AND C7_FILIAL = %xFilial:SC7%
		INNER JOIN %Table:SC1% SC1 ON C1_NUM = C7_NUMSC AND C1_ITEM = C7_ITEMSC AND C1_FILIAL = %xFilial:SC1% 


		WHERE CR_NUM= %Exp:cNumSc%  
		AND C7_NUMSC = %Exp:cNumSc%
		AND CR_TIPO='C2' 
		AND DBM_TIPO='C2'
		AND SCR.%notdel%
		AND DBM.%notdel%
		AND SC7.%notdel%
		AND SC1.%notdel%
		AND CR_STATUS=%Exp:cTipoSCR%		   

	EndSql

	COUNT TO nRec
	//CASO TENHA DADOS
	If nRec > 0
		dbSelectArea(cAliasAPR)
		(cAliasAPR)->(dbGoTop())

		cObs:= (cAliasAPR)->CR_OBS

		// Defino a ordem
		PswOrder(1) // Ordem de nome

		// Efetuo a pesquisa, definindo se pesquiso usuario ou grupo
		If PswSeek(ALLTRIM((cAliasAPR)->CR_USER),.T.)
			// Obtenho o resultado conforme vetor
			_aRetUser := PswRet(1)


		EndIf

		oProcess:=TWFProcess():New("00001","WORKFLOW PARA APROVACAO DE SC")
		clArqHtml	:= "\workflow\WFAPRODIFPEDSC.html"
		oProcess:NewTask("WFSOL",clArqHtml)
		oHtml   := oProcess:oHtml

		oHtml:ValByName("cUnidade"	, SM0->M0_FILIAL)
		oHtml:ValByName("cUsrSC"	, (cAliasAPR)->C1_SOLICIT)

		oHtml:ValByName("it.1"		, {})
		oHtml:ValByName("it.2"	, {})
		oHtml:ValByName("it.3"		, {})
		oHtml:ValByName("it.4"			, {})
		oHtml:ValByName("it.5"		, {})
		oHtml:ValByName("it.6"		, {})

		oHtml:ValByName("NumSC"	, (cAliasAPR)->CR_NUM)
		oHtml:ValByName("cMOTIVO",cObs)
		oHtml:ValByName("cGrupo"	, (cAliasAPR)->CR_GRUPO)
		oHtml:ValByName("cFilial"	, (cAliasAPR)->C7_FILIAL)
		oHtml:ValByName("cPedido"	, (cAliasAPR)->C7_NUM)

		While (cAliasAPR)->(!EOF())

			aadd(oHtml:ValByName("it.1")       ,(cAliasAPR)->CR_NUM			) //Item Cotacao
			aadd(oHtml:ValByName("it.2")       ,(cAliasAPR)->C7_NUM		) //Cod Produto
			aadd(oHtml:ValByName("it.3")       ,(cAliasAPR)->C7_DESCRI		) //Descricao Produto
			aadd(oHtml:ValByName("it.4")       ,(cAliasAPR)->C7_QUANT			) //Unidade Medida
			aadd(oHtml:ValByName("it.5")       ,"R$ "+TRANSFORM( (cAliasAPR)->C1_VUNIT,'@E 99,999,999.99' )) //Quantidade Solicitada
			aadd(oHtml:ValByName("it.6")       ,"R$ "+TRANSFORM( (cAliasAPR)->C7_TOTAL,'@E 99,999,999.99' )) //Valor Unitario


			(cAliasAPR)->(dbSkip())

		EndDo


		_user := Subs(cUsuario,7,15)
		oProcess:ClientName(_user)
		oProcess:cTo      := _aRetUser[1][14]//UsrRetMail(SY1->Y1_USER)  //AllTrim(GetMv("DBM_APRPED")) // DefiniÁ„o de e-mail padr„o, separar por ponto e vÌrgula
		oProcess:cBCC     := ''
		oProcess:cSubject := " BSL - Aprovação Pedido x Solicitação "
		oProcess:cBody    := ""
		oProcess:bReturn  := "U_XCOMA03B"     //Define a FunÁ„o de Retorno


		cOldTo  := oProcess:cTo
		cOldCC  := oProcess:cCC
		cOldBCC := oProcess:cBCC


		//Uso um endereco invalido, apenas para criar o processo de workflow, mas sem envia-lo
		oProcess:cTo  := __cUserID //"000001"
		oProcess:cCC  := NIL
		oProcess:cBCC := NIL

		cMailID    := oProcess:Start()  // Crio o processo e gravo o ID do processo de Workflow

		U_EnvLink(cMailID,cOldTo,cOldCC,cOldBCC,oProcess:cSubject, cFilAnt,"Revisao de compras",oProcess,__cUserID, _aRetUser[1][2],"3",cNumSc)

		(cAliasAPR)->(dbCloseArea())
	Else
		(cAliasAPR)->(dbCloseArea())
		//MsgStop("Problemas no Envio do E-Mail de Aprovação!","ATENÇÃO!")
	EndIf

Return()


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³XCOMA03B  ºAutor  ³Edie Carlos         º Data ³  23/07/2018 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retor Workflow de Aprovacao de Solicitacao de Compras      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP12                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±    
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function XCOMA03B(oProcess)


	Local 	cNumSc		:= Alltrim(oProcess:oHtml:RetByName("NumSC"))
	Local 	cMotivo		:= oProcess:oHtml:RetByName("cMOTIVO")
	Local 	cAprov		:= oProcess:oHtml:RetByName("cAPROV")
	Local 	cGrupo		:= oProcess:oHtml:RetByName("cGrupo")
	Local	_cFilial	:= oProcess:oHtml:RetByName("cFilial")
	Local 	cPedido		:= oProcess:oHtml:RetByName("cPedido")
	Local 	cMailAp   	:= ""
	Local 	cNuser    	:= ""
	Local 	lLiberado 	:= .T.
	Local 	lLibOk    	:= .T.
	Local 	cSQL		:= ""
	Local 	cFunction	:= "XCOMA003"

	Private oHtml
	Private cAliasTRB	:= GetNextAlias()
	Private cAliasAPV	:= GetNextAlias()
	Private cAliasAPC	:= GetNextAlias()
	Private cLogArq		:= cFunction
	Private cLogDir		:= SuperGetMV("VT_LOGDIR", , "\log\")


	oProcess:Finish()
	oProcess:Free()
	oProcess:= Nil

	ConOut("AVISO POR TIMEOUT SC:"+cNumSc+" Solicitante:")
	ConOut(alltrim(cMotivo))
	ConOut(cAprov)


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Inicia Envio de Mensagem de Aviso³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	BeginSQL Alias cAliasAPV

		SELECT * 
		FROM %Table:SCR%  SCR
		WHERE CR_NUM= %Exp:cNumSc%
		AND CR_TIPO = "C2"
		AND CR_FILIAL = %xFilial:SCR% 
		AND CR_STATUS = "02" 
		AND CR_GRUPO = %Exp:cGrupo%
		AND SCR.%notdel%

	EndSql


	//STATUS LIBERACAO DO DOCUMENTO

	IF cAprov == "L"

		dbSelectArea("SCR")
		SCR->(DBORDERNICKNAME("SCRARPOSC"))
		SCR->(dbGoTop())
		If SCR->(DBSeek(_cFilial + PADR(cNumSc,TAMSX3("CR_NUM")[1])+ "C2" +cGrupo))
			While SCR->(!eof()) .and. Alltrim(SCR->CR_NUM) == cNumSc .AND. SCR->CR_TIPO == "C2" .AND. SCR->CR_GRUPO == cGrupo
				IF SCR->CR_STATUS == "02"
					MaAlcDoc({SCR->CR_NUM,SCR->CR_TIPO,SCR->CR_TOTAL,SCR->CR_APROV,,SCR->CR_GRUPO,,,,,""},dDataBase,4)
					exit
				ENDIF
				SCR->(dbSkip())
			EndDo
		ENDIF

		//Verifica se exite documentos para serem liberado ainda
		SCR->(dbGoTop())
		If SCR->(DBSeek(_cFilial + PADR(cNumSc,TAMSX3("CR_NUM")[1])+ "C2" +cGrupo))
			//Verifica se existe aprovação para efetuar estorno
			While SCR->(!eof()) .and. SCR->CR_FILIAL == _cFilial .AND. Alltrim(SCR->CR_NUM) == cNumSc .AND. SCR->CR_TIPO == "C2" .AND. SCR->CR_GRUPO == cGrupo
				IF SCR->CR_STATUS == "02"
					cMailAp:=UsrRetMail(SCR->CR_USER)
					cNuser:=UsrRetName(SCR->CR_USER)
					lLiberado := .f.
				EndIf
				SCR->(dbSkip())
			EndDo
			(cAliasAPV)->(dbCloseArea())
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se esta tudo aprovador, se nao existe nenhum grupo pendente
		//  para aprovação
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lLiberado
			SCR->(dbSetOrder(1))
			SCR->(dbGoTop())
			If SCR->(DBSeek(_cFilial + "C2" + PADR(cNumSc,TAMSX3("CR_NUM")[1])))
				While SCR->(!EOF()) .and. SCR->CR_FILIAL == _cFilial .AND. Alltrim(SCR->CR_NUM) == cNumSc .AND. SCR->CR_TIPO == "C2"
					IF SCR->CR_STATUS == "02"
						lLiberado := .F.
						lLibOk    := .F.
					EndIF
					SCR->(dbSkip())
				EndDo
			EndIf

		EndIf

	EndIf

	IF lLiberado == .f. .and. cAprov == "L" .AND. lLibOk
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Faz select no pedido com solicitação de compras para verificar se o
		// do pedido está diferente da solcitação
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		BeginSQL Alias cAliasTRB

			SELECT CR_NUM,CR_USER,C7_FILIAL,CR_GRUPO,DBM_ITEM,C7_DESCRI,C7_TOTAL,C1_VUNIT,C7_NUM,C7_UM,C7_QUANT,C1_QUANT,ISNULL(CONVERT(VARCHAR(2047), CONVERT(VARBINARY(2047), CR_OBS)),'') AS CR_OBS 
			FROM %Table:SCR%  SCR
			LEFT JOIN %Table:DBM% DBM ON CR_NUM = DBM_NUM AND DBM_TIPO='C2' AND CR_APROV = DBM_USAPRO 
			AND CR_USER = DBM_USER AND CR_GRUPO = DBM_GRUPO AND DBM_FILIAL = %xFilial:DBM%

			INNER JOIN %Table:SC7% SC7 ON C7_NUMSC = CR_NUM AND C7_ITEM = DBM_ITEM AND C7_FILIAL = %xFilial:SC7%
			INNER JOIN %Table:SC1% SC1 ON C1_NUM = C7_NUMSC AND C1_ITEM = C7_ITEMSC AND C1_FILIAL = %xFilial:SC1% 


			WHERE CR_NUM= %Exp:cNumSc%  
			AND C7_NUMSC = %Exp:cNumSc%
			AND CR_TIPO='C2' 
			AND CR_GRUPO = %Exp:cGrupo%
			AND DBM_TIPO='C2'
			AND SCR.%notdel%
			AND DBM.%notdel%
			AND SC7.%notdel%
			AND SC1.%notdel%
			AND CR_STATUS='02'	   

		EndSql

		COUNT TO nRec
		//CASO TENHA DADOS
		If nRec > 0
			dbSelectArea((cAliasTRB))
			(cAliasTRB)->(dbGoTop())

			oProcess:=TWFProcess():New("00001","WORKFLOW PARA APROVACAO DE SC")
			clArqHtml	:= "\workflow\WFAPRODIFPEDSC.html"
			oProcess:NewTask("WFSOL",clArqHtml)
			oHtml   := oProcess:oHtml

			oHtml:ValByName("it.1"		, {})
			oHtml:ValByName("it.2"	, {})
			oHtml:ValByName("it.3"		, {})
			oHtml:ValByName("it.4"			, {})
			oHtml:ValByName("it.5"		, {})
			oHtml:ValByName("it.6"		, {})

			oHtml:ValByName("NumSC"	, (cAliasTRB)->CR_NUM)
			oHtml:ValByName("cGrupo"	, (cAliasTRB)->CR_GRUPO)
			oHtml:ValByName("cFilial"	, (cAliasTRB)->C7_FILIAL)
			oHtml:ValByName("cPedido"	, (cAliasTRB)->C7_NUM)
			oHtml:ValByName("cMOTIVO","")

			While (cAliasTRB)->(!EOF())

				aadd(oHtml:ValByName("it.1")       ,(cAliasTRB)->CR_NUM			) //Item Cotacao
				aadd(oHtml:ValByName("it.2")       ,(cAliasTRB)->C7_NUM		) //Cod Produto
				aadd(oHtml:ValByName("it.3")       ,(cAliasTRB)->C7_DESCRI		) //Descricao Produto
				aadd(oHtml:ValByName("it.4")       ,(cAliasTRB)->C7_QUANT			) //Unidade Medida
				aadd(oHtml:ValByName("it.5")       ,"R$ "+TRANSFORM( (cAliasTRB)->C1_VUNIT * (cAliasTRB)->C1_QUANT ,'@E 99,999,999.99' )) //Quantidade Solicitada
				aadd(oHtml:ValByName("it.6")       ,"R$ "+TRANSFORM( (cAliasTRB)->C7_TOTAL,'@E 99,999,999.99' )) //Valor Unitario


				(cAliasTRB)->(dbSkip())

			EndDo


			_user := Subs(cUsuario,7,15)
			oProcess:ClientName(_user)
			oProcess:cTo      := cMailAp//UsrRetMail(SY1->Y1_USER)  //AllTrim(GetMv("DBM_APRPED")) // DefiniÁ„o de e-mail padr„o, separar por ponto e vÌrgula
			oProcess:cBCC     := ''
			oProcess:cSubject := " BSL - Aprovação Pedido x Solicitação "
			oProcess:cBody    := ""
			oProcess:bReturn  := "U_XCOMA03B"     //Define a FunÁ„o de Retorno


			cOldTo  := oProcess:cTo
			cOldCC  := oProcess:cCC
			cOldBCC := oProcess:cBCC


			//Uso um endereco invalido, apenas para criar o processo de workflow, mas sem envia-lo
			oProcess:cTo  := "000000" //"000001"
			oProcess:cCC  := NIL
			oProcess:cBCC := NIL

			cMailID    := oProcess:Start()  // Crio o processo e gravo o ID do processo de Workflow

			U_EnvLink(cMailID,cOldTo,cOldCC,cOldBCC,oProcess:cSubject, cFilAnt,"Solicitação de Compras",oProcess,"000000", cNuser,"3")

			(cAliasTRB)->(dbCloseArea())
		Else
			(cAliasTRB)->(dbCloseArea())
			//MsgStop("Problemas no Envio do E-Mail de Aprovação!","ATENÇÃO!")
		EndIf

	EndIf


	If cAprov == "R"

		dbSelectArea("SCR")
		SCR->(DBSetOrder(1))
		SCR->(dbGoTop())
		If SCR->(DBSeek(xFilial("SCR") + "C2" + cNumSc))
			While SCR->(!eof()) .and. Alltrim(SCR->CR_NUM) == cNumSc .AND. SCR->CR_TIPO == "C2"
				IF SCR->CR_STATUS == "02"
					MaAlcDoc({SCR->CR_NUM,SCR->CR_TIPO,,SCR->CR_APROV,,SCR->CR_GRUPO,,,,dDataBase,cMotivo}, dDataBase ,6)
				ENDIF
				SCR->(dbSkip())
			EndDo
		ENDIF
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Faz select no pedido com solicitação de compras para verificar se o
		// do pedido está diferente da solcitação
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		/*
		BeginSQL Alias "APRTMP"

		SELECT CR_NUM,CR_USER,DBM_ITEM,C7_DESCRI,C7_TOTAL,C1_VUNIT,C7_NUM,C7_UM,C7_QUANT,C1_QUANT,ISNULL(CONVERT(VARCHAR(2047), CONVERT(VARBINARY(2047), CR_OBS)),'') AS CR_OBS 
		FROM %Table:SCR% SCR
		LEFT JOIN %Table:DBM% DBM 
		ON DBM_FILIAL = %xFilial:DBM%
		AND CR_NUM = DBM_NUM 
		AND DBM_TIPO = 'C2' 
		AND CR_APROV = DBM_USAPRO 
		AND CR_USER = DBM_USER 
		AND CR_GRUPO = DBM_GRUPO 
		AND DBM.%notdel%
		INNER JOIN %Table:SC7% SC7 
		ON C7_FILIAL = %xFilial:SC7%
		AND C7_NUMSC = CR_NUM 
		AND C7_ITEM = DBM_ITEM 
		AND SC7.%notdel%
		INNER JOIN %Table:SC1% SC1 
		ON C1_FILIAL = %xFilial:SC1%
		AND C1_NUM = C7_NUMSC 
		AND C1_ITEM = C7_ITEMSC 
		AND SC1.%notdel%
		WHERE CR_FILIAL = %xFilial:SCR%
		AND CR_NUM= %Exp:cNumSc%  
		AND C7_NUMSC = %Exp:cNumSc%
		AND CR_TIPO = 'C2' 
		AND DBM_TIPO = 'C2'
		AND CR_STATUS = '02'
		AND SCR.%notdel%

		EndSql
		*/
		cSQL := "	SELECT CR_NUM,CR_USER,DBM_ITEM,C7_DESCRI,C7_TOTAL,C1_VUNIT,C7_NUM,C7_UM,C7_QUANT,C1_QUANT,ISNULL(CONVERT(VARCHAR(2047), CONVERT(VARBINARY(2047), CR_OBS)),'') AS CR_OBS " + cEOL
		cSQL += "	FROM " + RetSQLName("SCR") + " SCR " + cEOL
		cSQL += "	LEFT JOIN " + RetSQLName("DBM") + " DBM " + cEOL
		cSQL += "	ON DBM_FILIAL = '" + xFilial("DBM") + "' " + cEOL
		cSQL += "	AND CR_NUM = DBM_NUM " + cEOL
		cSQL += "	AND DBM_TIPO = 'C2' " + cEOL
		cSQL += "	AND CR_APROV = DBM_USAPRO " + cEOL
		cSQL += "	AND CR_USER = DBM_USER " + cEOL
		cSQL += "	AND CR_GRUPO = DBM_GRUPO " + cEOL
		cSQL += "	AND DBM.D_E_L_E_T_ = ' ' " + cEOL
		cSQL += "	INNER JOIN " + RetSQLName("SC7") + " SC7 " + cEOL
		cSQL += "	ON C7_FILIAL = '" + xFilial("SC7") + "' " + cEOL
		cSQL += "	AND C7_NUMSC = CR_NUM " + cEOL
		cSQL += "	AND C7_ITEM = DBM_ITEM " + cEOL
		cSQL += "	AND SC7.D_E_L_E_T_ = ' ' " + cEOL
		cSQL += "	INNER JOIN " + RetSQLName("SC1") + " SC1 " + cEOL
		cSQL += "	ON C1_FILIAL = '" + xFilial("SC1") + "' " + cEOL
		cSQL += "	AND C1_NUM = C7_NUMSC " + cEOL
		cSQL += "	AND C1_ITEM = C7_ITEMSC " + cEOL
		cSQL += "	AND SC1.D_E_L_E_T_ = ' ' " + cEOL
		cSQL += "	WHERE CR_FILIAL = '" + xFilial("SCR") + "' " + cEOL
		cSQL += "	AND CR_NUM = '" + cNumSc + "' " + cEOL
		cSQL += "	AND C7_NUMSC = '" + cNumSc + "' " + cEOL
		cSQL += "	AND CR_TIPO = 'C2' " + cEOL
		cSQL += "	AND DBM_TIPO = 'C2' " + cEOL
		cSQL += "	AND CR_STATUS = '02' " + cEOL
		cSQL += "	AND SCR.D_E_L_E_T_ = ' ' " + cEOL

		MemoWrite(cLogDir + cLogArq + ".sql", cSQL)

		If Select(cAliasAPC) > 0
			(cAliasAPC)->(DBCloseArea())
		EndIf
		DBUseArea(.T., "TOPCONN", TCGenQry( , , cSQL), (cAliasAPC), .F., .T.)

		COUNT TO nRec
		//CASO TENHA DADOS
		If nRec > 0
			dbSelectArea((cAliasAPC))
			(cAliasAPC)->(dbGoTop())

			oProcess:=TWFProcess():New("00001","WORKFLOW PARA APROVACAO DE SC")
			clArqHtml	:= "\workflow\WfLinkSBL.html"
			oProcess:NewTask("WFSOL",clArqHtml)
			oHtml   := oProcess:oHtml

			oHtml:ValByName("it.1"		, {})
			oHtml:ValByName("it.2"	, {})
			oHtml:ValByName("it.3"		, {})
			oHtml:ValByName("it.4"			, {})
			oHtml:ValByName("it.5"		, {})
			oHtml:ValByName("it.6"		, {})

			oHtml:ValByName("NumSC"	, (cAliasAPC)->CR_NUM)
			oHtml:ValByName("cMOTIVO",cMotivo)

			While (cAliasAPC)->(!EOF())

				aadd(oHtml:ValByName("it.1")       ,(cAliasAPC)->CR_NUM			) //Item Cotacao
				aadd(oHtml:ValByName("it.2")       ,(cAliasAPC)->C7_NUM		) //Cod Produto
				aadd(oHtml:ValByName("it.3")       ,(cAliasAPC)->C7_DESCRI		) //Descricao Produto
				aadd(oHtml:ValByName("it.4")       ,(cAliasAPC)->C7_QUANT			) //Unidade Medida
				aadd(oHtml:ValByName("it.5")       ,"R$ "+TRANSFORM( (cAliasAPC)->C1_VUNIT * (cAliasAPC)->C1_QUANT,'@E 99,999,999.99' )) //Quantidade Solicitada
				aadd(oHtml:ValByName("it.6")       ,"R$ "+TRANSFORM( (cAliasAPC)->C7_TOTAL,'@E 99,999,999.99' )) //Valor Unitario


				(cAliasAPC)->(dbSkip())

			EndDo


			_user := Subs(cUsuario,7,15)
			oProcess:ClientName(_user)
			oProcess:cTo      := cMailAp//UsrRetMail(SY1->Y1_USER)  //AllTrim(GetMv("DBM_APRPED")) // DefiniÁ„o de e-mail padr„o, separar por ponto e vÌrgula
			oProcess:cBCC     := ''
			oProcess:cSubject := " BSL - Aprovação Pedido x Solicitação Reprovada "
			oProcess:cBody    := ""
			oProcess:bReturn  := ""     //Define a FunÁ„o de Retorno


			cOldTo  := oProcess:cTo
			cOldCC  := oProcess:cCC
			cOldBCC := oProcess:cBCC


			//Uso um endereco invalido, apenas para criar o processo de workflow, mas sem envia-lo
			//oProcess:cTo  := "000000" //"000001"
			//oProcess:cCC  := NIL
			//oProcess:cBCC := NIL

			cMailID    := oProcess:Start()  // Crio o processo e gravo o ID do processo de Workflow

			//U_EnvLink(cMailID,cOldTo,cOldCC,cOldBCC,oProcess:cSubject, cFilAnt,"Solicitação de Compras",oProcess,"000000", cNuser)

			(cAliasAPC)->(dbCloseArea())
		Else
			(cAliasAPC)->(dbCloseArea())
			//MsgStop("Problemas no Envio do E-Mail de Aprovação!","ATENÇÃO!")
		EndIf

	EndIf

	IF lLiberado == .T. .and. cAprov == "L" .AND. lLibOk
		U_XCOM005(cPedido)
	EndIF

Return()
