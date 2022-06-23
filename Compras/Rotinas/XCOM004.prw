#INCLUDE 	"RWMAKE.CH"
#INCLUDE 	"TBICONN.CH"
#INCLUDE 	"TBICODE.CH"
#INCLUDE 	"PROTHEUS.CH"
#INCLUDE 	"TOPCONN.CH"

#DEFINE 	cEOL 			CHR(13) + CHR(10)


// #################################################################################################
// Projeto: BSL
// Modulo : SIGACOM
// Fonte  : XCOM004
// ---------+-------------------+-------------------------------------------------------------------
// Data     | Autor             |Descricao
// ---------+-------------------+-------------------------------------------------------------------
// 21/08/18 | Edie Carlos       |WorkFlow aprovao de solicitacao de compras
// ---------+-------------------+-------------------------------------------------------------------
// 14/02/19 | Alceu Pereira     |Alteracao da querie principal para utilizar o posicionamento da SC1.
//			|					|Alterado para envio para Grupo de Aprov. diferentes. 
//			|					|Modificado o While retirado a comparacao pelo grupo.#1
// ---------+-------------------+--------------------------------------------------------------------

User function XCOM004(nOpcao, oProcess,cRotina)

	Local 	cGrupo    	:= ""
	Local 	nRec    	:= 0
	Local 	cLogArq		:= ""
	Local 	cLogDir		:= SuperGetMV("VT_LOGDIR", , "\log\")
	Local 	_cNumSC   	:= ""
	Local cAliasAC9	:= GetNextAlias()
	Local aAnexo		:= {}
	Local nX			:= 0
	Local cDirDocs	:= MsDocPath()
	Local cQuery		:= ""

	Private lCab        := .T.
	Private oHTML		:= Nil
	Private _aRetUser 	:= {}
	Private cAliasAPR 	:= GetNextAlias()

	Default oProcess	:= Nil


	SetPrvt("OHTML,OHTML2,_nOpcao")
	SetPrvt("_nQtd,_cNumsc1,_cItemSc1,_csubject")
	SetPrvt("nCount,_user")
	SetPrvt("cTO, cCC, cBCC, cSubject, cBody")

	//##################################
	//?Faz select no pedido com solicitao de compras para verificar se o
	// do pedido est?diferente da solcitao
	//##################################?

	//#1
	//Alterada a Querie aproveitando o posicionanemnto do SC1
	//para filtar
	BeginSQL Alias cAliasAPR

		SELECT C1_FILIAL,C1_NUM,C1_ITEM,C1_PRODUTO,C1_DESCRI,C1_QUANT,C1_VUNIT,C1_SOLICIT,C1_CC,C1_EMISSAO,C1_OBS,C1_PEDIDO,DBM_GRUPO
		FROM  %table:SC1% SC1
		INNER JOIN %table:SCR% SCR
		ON CR_FILIAL = C1_FILIAL
		AND CR_NUM = C1_NUM
		AND SCR.D_E_L_E_T_ <> '*'
		INNER JOIN  %table:DBM% DBM
		ON DBM_FILIAL = CR_FILIAL
		AND DBM_TIPO = CR_TIPO
		AND DBM_NUM = CR_NUM
		AND DBM_ITEM = C1_ITEM
		AND DBM_GRUPO = CR_GRUPO
		AND DBM_ITGRP = CR_ITGRP
		AND DBM_USER = CR_USER
		AND DBM_USAPRO = CR_APROV
		AND DBM.D_E_L_E_T_ <> '*'
		WHERE  CR_FILIAL = %xFilial:DBM%
		AND CR_TIPO = 'SC'
		AND CR_NUM = %Exp:SC1->C1_NUM%
		AND CR_STATUS = '02'
		AND SC1.D_E_L_E_T_ <> '*'
		ORDER BY  C1_CC, C1_ITEM

	EndSQL

	cLogArq := "XCOM004_01"
	MemoWrite(cLogDir + cLogArq + ".sql", GetLastQuery()[2])

	COUNT TO nRec
	//CASO TENHA DADOS
	If nRec > 0

		SCR->(dbSelectArea("SCR"))
		SCR->(dbSetOrder(4))

		(cAliasAPR)->(dbSelectArea(cAliasAPR))
		(cAliasAPR)->(dbGoTop())

		While !(cAliasAPR)->( EOF() ) .And. Empty( (cAliasAPR ) -> C1_PEDIDO )

			cGrupo := (cAliasAPR)->DBM_GRUPO

			IF lCab //monta cabeçalho do html quando lCab for .T.

				//³ Abertura do Arquivo de Trabalho
				If (Select(cAliasAC9) > 0, (cAliasAC9)->(dbCloseArea()),"")

					// Verifica se existe banco de conhecimento
					cQuery := " SELECT * FROM "+RetSqlName("AC9")+" AC9 "+CRLF
					cQuery += " INNER JOIN "+RetSqlName("ACB")+" ACB ON ACB_FILIAL = AC9_FILIAL AND ACB_CODOBJ =AC9_CODOBJ AND ACB.D_E_L_E_T_ <> '*'  "+CRLF
					cQuery += " WHERE AC9.D_E_L_E_T_ <> '*' AND AC9_ENTIDA = 'SC1'  "+CRLF
					cQuery += " AND AC9_CODENT LIKE '"+(cAliasAPR)->C1_FILIAL+(cAliasAPR)->C1_NUM+"%' "+CRLF

					TcQuery cQuery New Alias (cAliasAC9)

					(cAliasAC9)->(dbGoTop())
					//Adiciona os arquivos do banco do conhecimento no array
					While (cAliasAC9)->(!EOF())
						AADD(aAnexo, cDirDocs+"\"+ALLTRIM((cAliasAC9)->ACB_OBJETO) )
						(cAliasAC9)->(dbSkip())
					EndDo

					oProcess 	:= TWFProcess():New("APROVSC", "WORKFLOW PARA APROVACAO DE SC")
					clArqHTML	:= "\workflow\WfSC.html"
					oProcess:NewTask("WFSOL", clArqHTML)
					oHTML   	:= oProcess:oHTML

					IF Len(aAnexo) > 0 // adiciona os arquivos do banco de conhecimento no e-mail
						For nX := 1 To Len(aAnexo)
							oProcess:AttachFile(aAnexo[nX])
						Next
					Endif

					oHTML:ValByName("it.1"		, {})
					oHTML:ValByName("it.2"		, {})
					oHTML:ValByName("it.3"		, {})
					oHTML:ValByName("it.4"		, {})
					oHTML:ValByName("it.5"		, {})
					oHTML:ValByName("it.6"		, {})
					oHTML:ValByName("it.7"		, {})
					oHTML:ValByName("it.8"		, {})
					oHTML:ValByName("it.9"		, {})
					oHTML:ValByName("it.10"		, {})

					oHTML:ValByName("cUnidade"	, SM0->M0_FILIAL			)
					oHTML:ValByName("cNumSC"	, (cAliasAPR)->C1_NUM		)
					oHTML:ValByName("cFilial"	, (cAliasAPR)->C1_FILIAL	)
					oHTML:ValByName("cGrupo"	, cGrupo	)
					_cNumSC :=  (cAliasAPR)->C1_NUM

					// Rafael Yera Barchi - 05/09/2018
					// Alterado a pedido do usu?io Filipe Silva
					//				oHTML:ValByName("cUsrSC"	, Subs(cUsuario,7,15))
					oHTML:ValByName("cUsrSC"	, (cAliasAPR)->C1_SOLICIT	)
				EndIF

				//Monta o "corpo"

				AAdd(oHTML:ValByName("it.1")       , (cAliasAPR)->C1_ITEM)	//Item da Solicitao
				AAdd(oHTML:ValByName("it.2")       , (cAliasAPR)->C1_NUM)	//Cod Produto
				AAdd(oHTML:ValByName("it.3")       , (cAliasAPR)->C1_DESCRI) 	//Descricao Produto
				AAdd(oHTML:ValByName("it.4")       , (cAliasAPR)->C1_QUANT) 	//Quantidade Solicitada
				AAdd(oHTML:ValByName("it.5")       , "R$ " + TRANSFORM((cAliasAPR)->C1_VUNIT, '@E 999,999,999.99')) 	//Valor Unit?io
				AAdd(oHTML:ValByName("it.6")       , "R$ " + TRANSFORM((cAliasAPR)->C1_VUNIT * (cAliasAPR)->C1_QUANT, '@E 999,999,999.99')) 	//Valor Total
				AAdd(oHTML:ValByName("it.7")       , (cAliasAPR)->C1_CC) 	//Centro de Custo
				AAdd(oHTML:ValByName("it.8")       , POSICIONE("CTT", 1, xFilial("CTT") + (cAliasAPR)->C1_CC,"CTT_DESC01")) 	//Descricao Centro de Custo
				AAdd(oHTML:ValByName("it.9")       , STOD((cAliasAPR)->C1_EMISSAO)) 	//Data da Solicitao

				// Rafael Yera Barchi - 05/09/2018
				// Foi substitu?o o campo de categoria pela observao, a pedido do Sr. Filipe Silva
				//			AAdd(oHTML:ValByName("it.10")      , (cAliasAPR)->C1_ZSCATSC)																) 	//Categoria
				AAdd(oHTML:ValByName("it.10")      , (cAliasAPR)->C1_OBS																	) 	//Observao

				(cAliasAPR)->(dbSkip())

				If cGrupo <> (cAliasAPR)->DBM_GRUPO

					SCR->(dbSelectArea("SCR"))
					SCR->(dbSetOrder(4))
					SCR->(dbGoTop())
					//Verifica usuario para envio wf para aprovao
					//If SCR->(dbSeek(xFilial("SCR")+"SC"+PADR(SC1->C1_NUM,TAMSX3("CR_NUM")[1] )))
					If SCR->(DBSeek(xFilial("SCR") + PADR(SC1->C1_NUM,TAMSX3("CR_NUM")[1])+PADR("SC",TAMSX3("CR_TIPO")[1])+cGrupo))

						//#1
						//Alterada a Comparacao do While retirado o grupo.
						While SCR->(!eof()) .And. SCR->CR_FILIAL == xFilial("SCR") .And. Alltrim(SCR->CR_NUM) == Alltrim(SC1->C1_NUM) .And. Alltrim(SCR->CR_TIPO) == "SC"

							IF SCR->CR_STATUS == "02"
								PswOrder(1) // Ordem de nome
								// Efetuo a pesquisa, definindo se pesquiso usuario ou grupo
								If PswSeek(ALLTRIM(SCR->CR_USER),.T.)
									// Obtenho o resultado conforme vetor
									_aRetUser := PswRet(1)
									exit
								EndIf
							EndIf
							SCR->(dbSkip())
						EndDo
					Else
						APMsgInfo("Ocorreu um erro no disparo do workflow. Por favor, verifique com o administrador do sistema. ")
						Return()
					EndIf


					//Envia workflow
					_user := Subs(cUsuario,7,15)
					oProcess:ClientName(_user)
					oProcess:cTo      := _aRetUser[1][14]//UsrRetMail(SY1->Y1_USER)  //AllTrim(GetMv("DBM_APRPED")) // Defini?o de e-mail padr, separar por ponto e v?gula
					oProcess:cBCC     := ''
					oProcess:cSubject := "BSL Workflow: Solicitação de Compra " + _cNumSC
					oProcess:cBody    := ""
					oProcess:bReturn  := "U_XCOMA004"     //Define a Fun?o de Retorno


					cOldTo  := oProcess:cTo
					cOldCC  := oProcess:cCC
					cOldBCC := oProcess:cBCC


					//Uso um endereco invalido, apenas para criar o processo de workflow, mas sem envia-lo
					oProcess:cTo  := __cUserID //"000001"
					oProcess:cCC  := NIL
					oProcess:cBCC := NIL

					cMailID    := oProcess:Start()  // Crio o processo e gravo o ID do processo de Workflow

					U_EnvLink(cMailID,cOldTo,cOldCC,cOldBCC,oProcess:cSubject, cFilAnt,"Solicitao de Compras",oProcess,__cUserID, _aRetUser[1][2],"1")

					oProcess:Finish()
					oProcess:Free()
					oProcess:= Nil
					lCab:= .T.
				Else
					lCab:= .F.
				EndIf

			EndDo
/*
		If Empty( (cAliasAPR ) -> C1_PEDIDO )
			APMsgAlert("Workflow enviado ao aprovador.","Aviso!")
			(cAliasAPR)->(dbCloseArea())
		EndIf
*/
		Else

			(cAliasAPR)->(dbCloseArea())

		EndIf

		//³ Abertura do Arquivo de Trabalho
		If (Select(cAliasAC9) > 0, (cAliasAC9)->(dbCloseArea()),"")

			Return()

/*
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
++-------------------------------------------------------------------------++
++ Função    | ReeSCApr   | Autor  | Filipe Silva      | Data | 11/07/2019 ++
++-------------------------------------------------------------------------++
++ Descrição | Reenvia e-mail de WF SC									   ++
++-------------------------------------------------------------------------++
++ Obs       |  Rotina chamada pelo PE: MTA110MNU                          ++
++-------------------------------------------------------------------------++
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
*/

User Function ReeSCApr()

	IF SC1->C1_RESIDUO <> "S" .AND. SC1->C1_APROV <> "L"
		U_XCOM004(SC1->C1_FILIAL,SC1->C1_NUM)
		MSGALERT("E-mail enviado com sucesso.")
	Else
		MSGALERT("Status não permitido para o reenvio do WF SC!")
	Endif

Return

/*
#######################################
Programa  ?COMA03B  ?utor  ?die Carlos         ?Data ? 23/07/2018 ?esc.     ?Retor Workflow de Aprovacao de Solicitacao de Compras                                                                    
#?*/
User Function XCOMA004(oProcess)

	Local 	cNumSc		:= Alltrim(oProcess:oHTML:RetByName("cNumSC"))
	Local 	_cFilial  	:= Alltrim(oProcess:oHTML:RetByName("cFilial")) 
	Local 	cMotivo		:= oProcess:oHTML:RetByName("cMOTIVO")
	Local 	cAprov		:= oProcess:oHTML:RetByName("cAPROV")
	Local 	cGrupo  	:= oProcess:oHTML:RetByName("cGrupo")
	Local 	cMailAp   	:= ""
	Local 	cNuser    	:= ""
	Local 	lLiberado 	:= .T.
	Local 	_cNumSC   	:= ""
	Local 	cTpOper   	:= ""
	Local 	cEmails   	:= ""
	Local 	lEmails 	:= .F.
	Local 	cLogArq		:= ""
	Local 	cLogDir		:= SuperGetMV("VT_LOGDIR", , "\log\")	
	Local cAliasAC9	:= GetNextAlias()
	Local aAnexo		:= {}
	Local nX			:= 0
	Local cDirDocs	:= MsDocPath()
	Local cQuery		:= ""

	Private oHTML		:= Nil
	Private cAliasAPR2	:= GetNextAlias()
	Private cAliasAPR3	:= GetNextAlias()
	Private cAliasAPR4	:= GetNextAlias()


	SetPrvt("OHTML,OHTML2,_lCreditOk,_lEstoq_Ok,_nOpcao")
	SetPrvt("_cPedido,_cCliente,_aSCSemEst,_aOPSemEst,_lSemCredito,_cPedido")
	SetPrvt("_nQtd,_cNumsc1,_cItemSc1,_csubject")
	SetPrvt("wvlrtot","wvlrtab")
	SetPrvt("nCount,_user")
	SetPrvt("cTO, cCC, cBCC, cSubject, cBody")


	oProcess:Finish()
	oProcess:Free()
	oProcess:= Nil

	ConOut("AVISO POR TIMEOUT SC:"+cNumSc+" Solicitante:")
	ConOut(alltrim(cMotivo))
	ConOut(cAprov)

	//STATUS LIBERACAO DO DOCUMENTO

	SC1->(DbSelectArea(1))
	SC1->(DbSeek( _cFilial+cNumSc ))

	IF cAprov == "L"

		SCR->(dbSelectArea("SCR"))
		SCR->(dbSetOrder(4))
		SCR->(dbGoTop())
		If SCR->(DBSeek(_cFilial + PADR(cNumSc,TAMSX3("CR_NUM")[1])+PADR("SC",TAMSX3("CR_TIPO")[1])+cGrupo))
			While SCR->(!eof()) .And. SCR->CR_FILIAL == _cFilial .And. Alltrim(SCR->CR_NUM) == cNumSc .And. SCR->CR_TIPO == "SC" .AND. SCR->CR_GRUPO == cGrupo
				IF SCR->CR_STATUS == "02" 
					MaAlcDoc({SCR->CR_NUM,SCR->CR_TIPO,SCR->CR_TOTAL,SCR->CR_APROV,,SCR->CR_GRUPO,,,,,""},dDataBase,4)		
					Exit
				ENDIF	
				SCR->(dbSkip())
			EndDo
		ENDIF

		//Verifica se exite documentos para serem liberado ainda
		SCR->(dbGoTop())

		If SCR->(DBSeek(_cFilial + PADR(cNumSc,TAMSX3("CR_NUM")[1])+PADR("SC",TAMSX3("CR_TIPO")[1])+cGrupo))
			//Verifica se existe aprovao para efetuar estorno
			While !SCR->(EOF()) .And. SCR->CR_FILIAL == _cFilial .And. Alltrim(SCR->CR_NUM) == cNumSc .And. SCR->CR_TIPO == "SC" .AND. SCR->CR_GRUPO == cGrupo 
				IF SCR->CR_STATUS == "02" 
					cMailAp		:= UsrRetMail(SCR->CR_USER)
					cNuser		:= UsrRetName(SCR->CR_USER)					
					lLiberado 	:= .F.
				EndIf 
				SCR->(dbSkip())
			EndDo
		EndIf

	EndIF

	//##################################
	//Verifica se nao existe nenhum grupo pendente 
	//##################################?

	If lLiberado .And. cAprov == "L"
		SCR->(dbSelectArea("SCR"))
		SCR->(dbSetOrder(1))
		SCR->(dbGoTop())
		SCR->(DBSeek(_cFilial + PADR("SC",TAMSX3("CR_TIPO")[1])+ PADR(cNumSc,TAMSX3("CR_NUM")[1])))
		While !SCR->(EOF()) .And. SCR->CR_FILIAL == _cFilial .And. Alltrim(SCR->CR_NUM) == cNumSc .And. SCR->CR_TIPO == "SC"
			IF SCR->CR_STATUS == "02"
				Return()
			EndIF
			SCR->(dbSkip())
		EndDo
	EndIf

	IF !lLiberado  .And. cAprov == "L" 
		//##################################
		//?Faz select no pedido com solicitao de compras para verificar se o
		// do pedido est?diferente da solcitao
		//##################################?		

		//#1
		//Substituida a Querie anterior
		//Nesta foi colocado para respeitar o grupo aprovador 
		//e tambem filial e numero da solicitacao
		BeginSQL Alias cAliasAPR2

			SELECT C1_FILIAL,C1_NUM,C1_ITEM,C1_PRODUTO,C1_DESCRI,C1_QUANT,C1_VUNIT,C1_SOLICIT,C1_CC,C1_EMISSAO,C1_OBS,DBM_GRUPO 
			FROM %table:SC1% SC1 
			INNER JOIN %table:SCR% SCR 
			ON CR_FILIAL = C1_FILIAL 
			AND CR_NUM = C1_NUM 
			AND SCR.D_E_L_E_T_ <> '*' 
			INNER JOIN %table:DBM% DBM 
			ON DBM_FILIAL = CR_FILIAL 
			AND DBM_TIPO = CR_TIPO 
			AND DBM_NUM = CR_NUM 
			AND DBM_ITEM = C1_ITEM 
			AND DBM_GRUPO = CR_GRUPO 
			AND DBM_ITGRP = CR_ITGRP 
			AND DBM_USER = CR_USER  
			AND DBM_USAPRO = CR_APROV 
			AND DBM.D_E_L_E_T_ <> '*' 
			WHERE CR_FILIAL = %EXP:_cFilial%
			AND CR_TIPO = 'SC'
			AND CR_NUM = %Exp:cNumSc%
			AND CR_STATUS = '02' 
			AND CR_GRUPO = %Exp:cGrupo%
			AND SC1.D_E_L_E_T_ <> '*'  
			ORDER BY  C1_ITEM,C1_CC

		EndSQL

		cLogArq := "XCOM004_02"
		MemoWrite(cLogDir + cLogArq + ".sql", GetLastQuery()[2])		

		COUNT TO nRec
		//CASO TENHA DADOS
		If nRec > 0
			(cAliasAPR2)->(dbSelectArea(cAliasAPR2))
			(cAliasAPR2)->(dbGoTop())

			//³ Abertura do Arquivo de Trabalho
			If (Select(cAliasAC9) > 0, (cAliasAC9)->(dbCloseArea()),"")

			// Verifica se existe banco de conhecimento
			cQuery := " SELECT * FROM "+RetSqlName("AC9")+" AC9 "+CRLF
			cQuery += " INNER JOIN "+RetSqlName("ACB")+" ACB ON ACB_FILIAL = AC9_FILIAL AND ACB_CODOBJ =AC9_CODOBJ AND ACB.D_E_L_E_T_ <> '*'  "+CRLF
			cQuery += " WHERE AC9.D_E_L_E_T_ <> '*' AND AC9_ENTIDA = 'SC1'  "+CRLF
			cQuery += " AND AC9_CODENT LIKE '"+(cAliasAPR2)->C1_FILIAL+(cAliasAPR2)->C1_NUM+"%' "+CRLF

			TcQuery cQuery New Alias (cAliasAC9)

			(cAliasAC9)->(dbGoTop())
			//Adiciona os arquivos do banco do conhecimento no array
			While (cAliasAC9)->(!EOF())
				AADD(aAnexo, cDirDocs+"\"+ALLTRIM((cAliasAC9)->ACB_OBJETO) )
				(cAliasAC9)->(dbSkip())
			EndDo			

			oProcess:=TWFProcess():New("APROVSC","WORKFLOW PARA APROVACAO DE SC")
			clArqHTML	:= "\workflow\WfSC.HTML"
			oProcess:NewTask("WFSOL",clArqHTML)
			oHTML   := oProcess:oHTML

			IF Len(aAnexo) > 0 // adiciona os arquivos do banco de conhecimento no e-mail
				For nX := 1 To Len(aAnexo)
					oProcess:AttachFile(aAnexo[nX])	
				Next 
			Endif			

			oHTML:ValByName("it.1"		, {})
			oHTML:ValByName("it.2"		, {})
			oHTML:ValByName("it.3"		, {})
			oHTML:ValByName("it.4"		, {})
			oHTML:ValByName("it.5"		, {})
			oHTML:ValByName("it.6"		, {})
			oHTML:ValByName("it.7"		, {})
			oHTML:ValByName("it.8"		, {})
			oHTML:ValByName("it.9"		, {})
			oHTML:ValByName("it.10"		, {})

			oHTML:ValByName("cUnidade"	, SM0->M0_FILIAL)
			oHTML:ValByName("cUsrSC"	, cNuser )
			oHTML:ValByName("cNumSC"	, (cAliasAPR2)->C1_NUM)
			oHTML:ValByName("cFilial"	, (cAliasAPR2)->C1_FILIAL)
			oHTML:ValByName("cGrupo"	, cGrupo)
			_cNumSC :=  (cAliasAPR2)->C1_NUM


			While (cAliasAPR2)->(!EOF())

				AAdd(oHTML:ValByName("it.1")       , (cAliasAPR2)->C1_ITEM			) //Item Cotacao
				AAdd(oHTML:ValByName("it.2")       , (cAliasAPR2)->C1_NUM		) //Cod Produto
				AAdd(oHTML:ValByName("it.3")       , (cAliasAPR2)->C1_DESCRI		) //Descricao Produto
				AAdd(oHTML:ValByName("it.4")       , (cAliasAPR2)->C1_QUANT			) //Unidade Medida
				AAdd(oHTML:ValByName("it.5")       , "R$ "+TRANSFORM( (cAliasAPR2)->C1_VUNIT,'@E 999,999,999.99' )) //Quantidade Solicitada
				AAdd(oHTML:ValByName("it.6")       , "R$ "+TRANSFORM( (cAliasAPR2)->C1_VUNIT * (cAliasAPR2)->C1_QUANT,'@E 999,999,999.99' )) //Quantidade Solicitada
				AAdd(oHTML:ValByName("it.7")       , (cAliasAPR2)->C1_CC		) //Descricao Produto
				AAdd(oHTML:ValByName("it.8")       , POSICIONE("CTT", 1, xFilial("CTT") + (cAliasAPR2)->C1_CC,"CTT_DESC01")		) //Descricao Produto
				AAdd(oHTML:ValByName("it.9")       , STOD((cAliasAPR2)->C1_EMISSAO)			) //Item Cotacao

				// Rafael Yera Barchi - 05/09/2018
				// Foi substitu?o o campo de categoria pela observao, a pedido do Sr. Filipe Silva				
				//				AAdd(oHTML:ValByName("it.10")       , (cAliasAPR2)->C1_ZSCATSC)	//(cAliasAPR2)->C1_ZSCATSC			)
				AAdd(oHTML:ValByName("it.10")       , (cAliasAPR2)->C1_OBS											)

				(cAliasAPR2)->(dbSkip())

			EndDo


			_user := cNuser//Subs(cUsuario,7,15)
			oProcess:ClientName(_user)
			oProcess:cTo      := cMailAp//UsrRetMail(SY1->Y1_USER)  //AllTrim(GetMv("DBM_APRPED")) // Defini?o de e-mail padr, separar por ponto e v?gula
			oProcess:cBCC     := ''
			oProcess:cSubject := "BSL Workflow: Solicitação de Compra " + _cNumSC
			oProcess:cBody    := ""
			oProcess:bReturn  := "U_XCOMA004"     //Define a Fun?o de Retorno


			cOldTo  := oProcess:cTo
			cOldCC  := oProcess:cCC
			cOldBCC := oProcess:cBCC


			//Uso um endereco invalido, apenas para criar o processo de workflow, mas sem envia-lo
			oProcess:cTo  := "000000" //"000001"
			oProcess:cCC  := NIL
			oProcess:cBCC := NIL
			cTpOper:="1"

			cMailID    := oProcess:Start()  // Crio o processo e gravo o ID do processo de Workflow

			U_EnvLink(cMailID,cOldTo,cOldCC,cOldBCC,oProcess:cSubject, cFilAnt,"Solicitao de Compras",oProcess,"000000", cNuser,cTpOper,_cNumSC)

			(cAliasAPR2)->(dbCloseArea())
		Else
			(cAliasAPR2)->(dbCloseArea())
			//APMsgAlert("Problemas no Envio do E-Mail de Aprovao!","ATENO!")
		EndIf

	EndIf


	If cAprov == "R"

		SCR->(dbSelectArea("SCR"))
		SCR->(DBSetOrder(1))
		SCR->(dbGoTop())
		If SCR->(DBSeek(_cFilial + "SC" + cNumSc))
			While SCR->(!eof()) .And. SCR->CR_FILIAL == _cFilial .And. Alltrim(SCR->CR_NUM) == cNumSc .And. SCR->CR_TIPO == "SC"
				IF SCR->CR_STATUS == "02" 
					MaAlcDoc({SCR->CR_NUM,SCR->CR_TIPO,,SCR->CR_APROV,,SCR->CR_GRUPO,,,,dDataBase,cMotivo}, dDataBase ,6)
					//atualiza solicitao como rejeitada
					cQuery := " UPDATE " + RetSQLName("SC1")
					cQuery += " SET C1_APROV = '"+cAprov+"'"
					cQuery += " WHERE C1_FILIAL='"+_cFilial+"' AND C1_NUM = '"+cNumSc+"' AND D_E_L_E_T_ = ' ' "

					TcSqlExec(cQuery)
					TCREFRESH(RetSqlName("SC1"))

					exit

				ENDIF	
				SCR->(dbSkip())
			EndDo
		ENDIF
		//##################################
		//?Faz select no pedido com solicitao de compras para verificar se o
		// do pedido est?diferente da solcitao
		//##################################?		

		BeginSQL Alias cAliasAPR3

			SELECT * 
			FROM %Table:SC1% SC1
			INNER JOIN %Table:SB1% SB1 
			ON B1_FILIAL = %xFilial:SB1% 
			AND B1_COD = C1_PRODUTO
			AND SB1.D_E_L_E_T_ = ' '			       
			WHERE C1_FILIAL = %Exp:_cFilial%
			AND C1_NUM= %Exp:cNumSc%  
			AND SC1.D_E_L_E_T_ = ' '

		EndSQL

		cLogArq := "XCOM004_03"
		MemoWrite(cLogDir + cLogArq + ".sql", GetLastQuery()[2])

		COUNT TO nRec
		//CASO TENHA DADOS
		If nRec > 0
			(cAliasAPR3)->(dbSelectArea(cAliasAPR3))
			(cAliasAPR3)->(dbGoTop())

			oProcess:=TWFProcess():New("APROVSC","WORKFLOW PARA APROVACAO DE SC")
			clArqHTML	:= "\workflow\WfSCReprovada.HTML"
			oProcess:NewTask("WFSOL",clArqHTML)
			oHTML   := oProcess:oHTML

			oHTML:ValByName("it.1"		, {})
			oHTML:ValByName("it.2"		, {})
			oHTML:ValByName("it.3"		, {})
			oHTML:ValByName("it.4"		, {})
			oHTML:ValByName("it.5"		, {})
			oHTML:ValByName("it.6"		, {})
			oHTML:ValByName("it.7"		, {})
			oHTML:ValByName("it.8"		, {})
			oHTML:ValByName("it.9"		, {})
			oHTML:ValByName("it.10"		, {})

			cMailAp:=UsrRetMail((cAliasAPR3)->C1_USER)
			cNuser:=UsrRetName((cAliasAPR3)->C1_USER)
			_cNumSC:= (cAliasAPR3)->C1_NUM

			oHTML:ValByName("cUnidade"	, SM0->M0_FILIAL)
			oHTML:ValByName("cUsrSC"	, cNuser )
			oHTML:ValByName("cNumSC"	, (cAliasAPR3)->C1_NUM)
			oHTML:ValByName("cMotivo"	, cMotivo)


			While (cAliasAPR3)->(!EOF())

				AAdd(oHTML:ValByName("it.1")       , (cAliasAPR3)->C1_ITEM			) //Item Cotacao
				AAdd(oHTML:ValByName("it.2")       , (cAliasAPR3)->C1_NUM		) //Cod Produto
				AAdd(oHTML:ValByName("it.3")       , (cAliasAPR3)->C1_DESCRI		) //Descricao Produto
				AAdd(oHTML:ValByName("it.4")       , (cAliasAPR3)->C1_QUANT			) //Unidade Medida
				AAdd(oHTML:ValByName("it.5")       , "R$ "+TRANSFORM( (cAliasAPR3)->C1_VUNIT,'@E 999,999,999.99' )) //Quantidade Solicitada
				AAdd(oHTML:ValByName("it.6")       , "R$ "+TRANSFORM( (cAliasAPR3)->C1_VUNIT * (cAliasAPR3)->C1_QUANT,'@E 999,999,999.99' )) //Quantidade Solicitada
				AAdd(oHTML:ValByName("it.7")       , (cAliasAPR3)->C1_CC		) //Descricao Produto
				AAdd(oHTML:ValByName("it.8")       , POSICIONE("CTT", 1, xFilial("CTT") + (cAliasAPR3)->C1_CC,"CTT_DESC01")		) //Descricao Produto
				AAdd(oHTML:ValByName("it.9")       , STOD((cAliasAPR3)->C1_EMISSAO)			) //Item Cotacao

				// Rafael Yera Barchi - 05/09/2018
				// Foi substitu?o o campo de categoria pela observao, a pedido do Sr. Filipe Silva				
				//				AAdd(oHTML:ValByName("it.10")       , (cAliasAPR3)->C1_ZSCATSC)	//(cAliasAPR)->C1_ZSCATSC			) //Item Cotacao
				AAdd(oHTML:ValByName("it.10")       , (cAliasAPR3)->C1_OBS											) //Item Cotacao

				(cAliasAPR3)->(dbSkip())

			EndDo


			_user := cNuser//Subs(cUsuario,7,15)
			oProcess:ClientName(_user)
			oProcess:cTo      := cMailAp//UsrRetMail(SY1->Y1_USER)  //AllTrim(GetMv("DBM_APRPED")) // Defini?o de e-mail padr, separar por ponto e v?gula
			oProcess:cBCC     := ''
			oProcess:cSubject := "BSL Workflow: Solicitação de Compra " + _cNumSC + " reprovada"
			oProcess:cBody    := ""
			oProcess:bReturn  := ""     //Define a Fun?o de Retorno


			//			cOldTo  := oProcess:cTo
			//			cOldCC  := oProcess:cCC
			//			cOldBCC := oProcess:cBCC


			//Uso um endereco invalido, apenas para criar o processo de workflow, mas sem envia-lo
			//oProcess:cTo  := "000000" //"000001"
			//oProcess:cCC  := NIL
			//oProcess:cBCC := NIL

			cMailID    := oProcess:Start()  // Crio o processo e gravo o ID do processo de Workflow

			//			U_EnvLink(cMailID,cOldTo,cOldCC,cOldBCC,oProcess:cSubject, cFilAnt,"Solicitao de Compras",oProcess,"000000", cNuser,"2",_cNumSC)

			(cAliasAPR3)->(dbCloseArea())
		Else
			(cAliasAPR3)->(dbCloseArea())
			//APMsgAlert("Problemas no Envio do E-Mail de Aprovao!","ATENO!")
		EndIf
	EndIf

	IF  cAprov == "L" .And. lLiberado == .T.
		//U_WFAPRSCR(_cFilial+cNumSc)

		SC1->(dbSelectArea("SC1"))
		SC1->(dbSetOrder(1))
		If SC1->(dbSeek(_cFilial+cNumSc))

			While !SC1->(EOF()) .And. SC1->C1_FILIAL == _cFilial .And. SC1->C1_NUM == cNumSc
				RECLOCK("SC1",.F.)
				SC1->C1_APROV := "L"
				//SC1->C1_NOMAPRO := AllTrim(oWF:oHTML:RetByName('cAprovador')) 
				//SC1->C1_ZAPROVA := AllTrim(oWF:oHTML:RetByName('cAprovador'))
				SC1->C1_ZDTAPRO := Date()
				SC1->(MSUNLOCK())
				SC1->(dbSkip())
			EndDo	
		EndIF

		//envia e-mail para solicitante
		//##################################
		//?Faz select no pedido com solicitao de compras para verificar se o
		// do pedido est?diferente da solcitao
		//##################################?		

		BeginSQL Alias cAliasAPR4

			SELECT * 
			FROM %Table:SC1% SC1
			INNER JOIN %Table:SB1% SB1 
			ON B1_FILIAL = %xFilial:SB1% 
			AND B1_COD = C1_PRODUTO
			AND SB1.D_E_L_E_T_ = ' '
			WHERE C1_FILIAL = %Exp:_cFilial% 
			AND C1_NUM = %Exp:cNumSc%
			AND SC1.D_E_L_E_T_ = ' '

		EndSQL

		cLogArq := "XCOM004_04"
		MemoWrite(cLogDir + cLogArq + ".sql", GetLastQuery()[2])		

		COUNT TO nRec

		//CASO TENHA DADOS
		If nRec > 0

			(cAliasAPR4)->(dbSelectArea(cAliasAPR4))
			(cAliasAPR4)->(dbGoTop())

			oProcess:=TWFProcess():New("APROVSC","WORKFLOW PARA APROVACAO DE SC")
			clArqHTML	:= "\workflow\WfSCAprovado.HTML"
			oProcess:NewTask("WFSOL",clArqHTML)
			oHTML   := oProcess:oHTML

			oHTML:ValByName("it.1"		, {})
			oHTML:ValByName("it.2"		, {})
			oHTML:ValByName("it.3"		, {})
			oHTML:ValByName("it.4"		, {})
			oHTML:ValByName("it.5"		, {})
			oHTML:ValByName("it.6"		, {})
			oHTML:ValByName("it.7"		, {})
			oHTML:ValByName("it.8"		, {})
			oHTML:ValByName("it.9"		, {})
			oHTML:ValByName("it.10"		, {})

			cMailAp:=UsrRetMail((cAliasAPR4)->C1_USER)
			cNuser:=UsrRetName((cAliasAPR4)->C1_USER)
			_cNumSC:= (cAliasAPR4)->C1_NUM

			oHTML:ValByName("cUnidade"	, SM0->M0_FILIAL)
			oHTML:ValByName("cUsrSC"	, cNuser )
			oHTML:ValByName("cNumSC"	, (cAliasAPR4)->C1_NUM)
			oHTML:ValByName("cMotivo"	, cMotivo)

			While (cAliasAPR4)->(!EOF())

				AAdd(oHTML:ValByName("it.1")       , (cAliasAPR4)->C1_ITEM			) //Item Cotacao
				AAdd(oHTML:ValByName("it.2")       , (cAliasAPR4)->C1_NUM		) //Cod Produto
				AAdd(oHTML:ValByName("it.3")       , (cAliasAPR4)->C1_DESCRI		) //Descricao Produto
				AAdd(oHTML:ValByName("it.4")       , (cAliasAPR4)->C1_QUANT			) //Unidade Medida
				AAdd(oHTML:ValByName("it.5")       , "R$ "+TRANSFORM( (cAliasAPR4)->C1_VUNIT,'@E 999,999,999.99' )) //Quantidade Solicitada
				AAdd(oHTML:ValByName("it.6")       , "R$ "+TRANSFORM( (cAliasAPR4)->C1_VUNIT * (cAliasAPR4)->C1_QUANT,'@E 999,999,999.99' )) //Quantidade Solicitada
				AAdd(oHTML:ValByName("it.7")       , (cAliasAPR4)->C1_CC		) //Descricao Produto
				AAdd(oHTML:ValByName("it.8")       , POSICIONE("CTT", 1, xFilial("CTT") + (cAliasAPR4)->C1_CC,"CTT_DESC01")		) //Descricao Produto
				AAdd(oHTML:ValByName("it.9")       , STOD((cAliasAPR4)->C1_EMISSAO)			) //Item Cotacao

				// Rafael Yera Barchi - 05/09/2018
				// Foi substitu?o o campo de categoria pela observao, a pedido do Sr. Filipe Silva				
				//				AAdd(oHTML:ValByName("it.10")       , (cAliasAPR4)->C1_ZSCATSC)	//(cAliasAPR4)->C1_ZSCATSC			) //Item Cotacao
				AAdd(oHTML:ValByName("it.10")       , (cAliasAPR4)->C1_OBS											) //Item Cotacao

				(cAliasAPR4)->(dbSkip())

			EndDo

			(cAliasAPR4)->(dbCloseArea())

		EndIF

	EndIF

	//³ Abertura do Arquivo de Trabalho
	If (Select(cAliasAC9) > 0, (cAliasAC9)->(dbCloseArea()),"")

Return()
