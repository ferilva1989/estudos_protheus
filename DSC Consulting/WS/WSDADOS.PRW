#INCLUDE 'TOTVS.CH'
#INCLUDE 'APWEBSRV.CH'
#INCLUDE 'tryexception.ch'
#INCLUDE "TBICONN.CH"
#INCLUDE "PROTHEUS.CH"

// CONSULTA NOTA DE ENTRADA
WSSTRUCT SAIDACONS
	WSDATA FILCGC  		AS STRING
	WSDATA FORCGC  		AS STRING
	WSDATA EMISSA  		AS DATE
	WSDATA NNF     		AS STRING
	WSDATA CSER    		AS STRING
	WSDATA TOTNF  		AS FLOAT
	WSDATA CMSG			AS STRING
	WSDATA AITENCONS 	AS ARRAY OF SAIDAIT
ENDWSSTRUCT

WSSTRUCT SAIDAIT
	WSDATA CITEM  AS STRING
	WSDATA CPROD  AS STRING
	WSDATA NQUANT AS FLOAT
	WSDATA NVUNIT AS FLOAT
	WSDATA NTOTAL AS FLOAT
ENDWSSTRUCT

// GERA PRE-NOTA DE ENTRADA
WSSTRUCT ITENS
	WSDATA ITEM		AS STRING
	WSDATA COD		AS STRING 
	WSDATA QUANT	AS FLOAT
	WSDATA VUNIT	AS FLOAT  
	WSDATA CC		AS STRING 
ENDWSSTRUCT

WSSTRUCT DADOSENT
	WSDATA AITENS	AS ARRAY OF ITENS
ENDWSSTRUCT

WSSTRUCT DADOSSAI
	WSDATA MENSAGEM	AS STRING
	WSDATA CODSAI 	AS STRING
ENDWSSTRUCT

WSSERVICE WSDADOS Description "Integração Protheus e IW"

	// GERA PRE-NOTA	
	WSDATA CGCEMP      	AS STRING   
	WSDATA DOC         	AS STRING   
	WSDATA SERIE       	AS STRING
	WSDATA EMISSAO     	AS DATE
	WSDATA CGCFOR      	AS STRING
	WSDATA IWID			AS STRING
	WSDATA DUSER  	 	AS STRING
	WSDATA DTIME  	 	AS STRING
	WSDATA oEntrada		AS DADOSENT
	WSDATA SAIDA		AS DADOSSAI
	WSMETHOD GERANOTA Description "Gera Pre-Nota"

	// CONSULTA NOTA DE ENTRADA
	WSDATA CODIGO AS STRING
	WSDATA CUSER  AS STRING
	WSDATA CTIME  AS STRING
	WSDATA CSAIDA AS SAIDACONS
	WSMETHOD CONSULTA Description "Consulta Nota de Entrada"

ENDWSSERVICE

WSMETHOD CONSULTA WSRECEIVE CODIGO,CUSER,CTIME WSSEND CSAIDA WSSERVICE WSDADOS 

	Local aItensCon := {}
	Local aCabec    := {}
	Local aItensRet := {}
	Local lVal      := .F.
	Local h		:= 0

	Local lVal := fValid(CUSER,CTIME)

	IF lVal

		//35171044386134000168550010001210621001210623  // ZO_NFEID 

		RESET ENVIRONMENT
		PREPARE ENVIRONMENT EMPRESA '01' FILIAL '01001'

		cQry := " SELECT * "
		cQry += " FROM "+RetSqlName("SZO")+" SZO "
		cQry += " INNER JOIN "+RetSqlName("SZP")+" SZP "
		cQry += " ON ZO_FILIAL = ZP_FILIAL AND ZO_DOC = ZP_DOC AND ZO_SERIE = ZP_SERIE AND ZO_CGC = ZP_CGC "
		cQry += " WHERE SZO.D_E_L_E_T_='' "
		cQry += " AND SZP.D_E_L_E_T_='' "
		cQry += " AND ZO_NFEID = '"+ALLTRIM(::CODIGO)+"' 

		IF Select("TRZ") > 0
			TRZ->(dbCloseArea())
		EndIf
		cQry := ChangeQuery(cQry)
		dbUseArea(.T., "TOPCONN", TCGenQry(,,cQry), "TRZ", .F., .T.)
		DbSelectArea("TRZ")
		TRZ->(DbGotop())

		IF !EMPTY(TRZ->ZO_DOC) // SE TROUXE ALGUMA COISA NA QUERY

			_aArea := GetArea()                                  
			DbSelectArea("SM0")
			SM0->(DbGoTop())
			DO WHILE !SM0->(EOF())
				IF ALLTRIM(SM0->M0_CODFIL) == TRZ->ZO_FILIAL 
					cCGC := SM0->M0_CGC
					Exit
				ENDIF
				SM0->(DbSkip())
			ENDDO
			RestArea( _aArea ) 

			::CSAIDA:FILCGC := cCGC
			::CSAIDA:FORCGC := SUBSTR(TRZ->ZO_NFEID,7,14)
			::CSAIDA:EMISSA := STOD(TRZ->ZO_EMISSAO)
			::CSAIDA:CSER   := SUBSTR(TRZ->ZO_NFEID,24,3)
			::CSAIDA:NNF    := SUBSTR(TRZ->ZO_NFEID,27,9)
			::CSAIDA:TOTNF  := TRZ->ZO_VNF
			::CSAIDA:CMSG   := "OK"

			WHILE TRZ->(!EOF())
				Aadd(aItensCon,{TRZ->ZP_NITEM,TRZ->ZP_B1COD,TRZ->ZP_QCOM,TRZ->ZP_VUNCOM,TRZ->ZP_VPROD})
				TRZ->(dbSkip())
			ENDDO

			For h := 1 TO LEN(aItensCon ) 

				AAdd(::CSAIDA:AITENCONS,WsClassNew("SAIDAIT") )
				aItensRet := aTail(::CSAIDA:AITENCONS)

				aItensRet:CITEM  := aItensCon[h][1]
				aItensRet:CPROD  := aItensCon[h][2]
				aItensRet:NQUANT := aItensCon[h][3]
				aItensRet:NVUNIT := aItensCon[h][4]
				aItensRet:NTOTAL := aItensCon[h][5]

			Next h 

		ELSE
			::CSAIDA:FILCGC := ""
			::CSAIDA:FORCGC := ""
			::CSAIDA:EMISSA := stod("")
			::CSAIDA:CSER   := ""
			::CSAIDA:NNF    := ""
			::CSAIDA:TOTNF  := 0
			::CSAIDA:CMSG   := "NF NÃO ENCONTRADA!"

			AAdd(::CSAIDA:AITENCONS,WsClassNew("SAIDAIT") )
			aItensRet := aTail(::CSAIDA:AITENCONS)

			aItensRet:CITEM  := ""
			aItensRet:CPROD  := ""
			aItensRet:NQUANT := 0
			aItensRet:NVUNIT := 0
			aItensRet:NTOTAL := 0

		ENDIF

	ELSE
		::CSAIDA:FILCGC := ""
		::CSAIDA:FORCGC := ""
		::CSAIDA:EMISSA := stod("")
		::CSAIDA:CSER   := ""
		::CSAIDA:NNF    := ""
		::CSAIDA:TOTNF  := 0
		::CSAIDA:CMSG  := "FALHA NA AUTENTICAÇÃO DO USUÁRIO!"

		AAdd(::CSAIDA:AITENCONS,WsClassNew("SAIDAIT") )
		aItensRet := aTail(::CSAIDA:AITENCONS)

		aItensRet:CITEM  := ""
		aItensRet:CPROD  := ""
		aItensRet:NQUANT := 0
		aItensRet:NVUNIT := 0
		aItensRet:NTOTAL := 0

	ENDIF

Return .T.      

// METODO GERANOTA
WSMETHOD GERANOTA WSRECEIVE oEntrada,CGCEMP,DOC,SERIE,EMISSAO,CGCFOR,IWID,DUSER,DTIME WSSEND SAIDA WSSERVICE WSDADOS

	Local aSD1      := {}
	Local aSF1      := {}
	Local aItensLoc := {}
	Local cEmpp     := ""
	Local cFill     := ""
	Local cRetProd  := ""
	Local cBlqProd  := ""
	Local cRetCC    := ""
	Local cRetAS    := ""
	Local lValI     := fValid(DUSER,DTIME)
	Local m			:= 0
	Local h			:= 0

	IF lVali 

		RESET ENVIRONMENT
		PREPARE ENVIRONMENT EMPRESA '01' FILIAL '01001'

		// BUSCA A FILIAL CORRETA PRA INCLUIR A PRE-NOTA ATRAVES DO CNPJ INFORMADO
		_aArea := GetArea()                                  
		DbSelectArea("SM0")
		SM0->(DbGoTop())
		DO WHILE !SM0->(EOF())
			IF ALLTRIM(SM0->M0_CGC) == ::CGCEMP // SE FOR O CNPJ 
				cEmpp := SM0->M0_CODIGO
				cFill := SM0->M0_CODFIL
				Exit
			ENDIF
			SM0->(DbSkip())
		ENDDO
		RestArea( _aArea ) 

		IF EMPTY(cFill)
			::SAIDA:MENSAGEM := "Pré-nota não será gerada. Filial: " +::CGCEMP+ " não cadastrada no Protheus. Favor cadastrar!" 
			::SAIDA:CODSAI := "3"
			Return .T.
		ENDIF

		RESET ENVIRONMENT
		PREPARE ENVIRONMENT EMPRESA cEmpp FILIAL cFill 

		// BUSCA O COD E LOJA DO FORNECEDOR ATRAVES DO CNPJ
		cFor  := GETADVFVAL("SA2","A2_COD",xFilial("SA2") + ::CGCFOR, 3, "")
		cLoja := GETADVFVAL("SA2","A2_LOJA",xFilial("SA2") + ::CGCFOR, 3, "")
		cDoc  := ALLTRIM(::DOC)
		cSer  := ALLTRIM(::SERIE)
		cIwId := "ID IW: " + ALLTRIM(::IWID)  

		IF EMPTY(cFor)
			::SAIDA:MENSAGEM := "Pré-nota não será gerada. Fornecedor: " +::CGCFOR+ " não cadastrado no Protheus. Favor cadastrar!"
			::SAIDA:CODSAI := "3"
			Return .T.
		ENDIF 

		cNFExist  := GETADVFVAL("SF1", "F1_DOC", xFilial("SF1") + cDoc + cSer + cFor + cLoja, 1, "")

		IF !EMPTY(cNFExist)
			::SAIDA:MENSAGEM := "Pré-nota: "+ALLTRIM(cDoc) + " já cadastrada!"
			::SAIDA:CODSAI := "2"
			Return .T.
		ENDIF

		lAlt := .F.
		DbSelectArea("SA2")
		SA2->(DbGoTop())
		SA2->(DbSetOrder(1))
		IF SA2->(MsSeek( xFilial("SA2")+cFor+cLoja) )
			IF SA2->A2_XPER <> "1"
				Reclock("SA2",.F.)
				SA2->A2_XPER := "1"
				lAlt := .T.
				SA2->(MsUnlock())
			ENDIF
		ENDIF  

		AAdd(aSF1,{"F1_TIPO"	   	,"N"		  	,Nil})
		AAdd(aSF1,{"F1_FORMUL" 		,"N"		   	,Nil})
		AAdd(aSF1,{"F1_DOC"	   		,::DOC	   		,Nil}) 
		AAdd(aSF1,{"F1_SERIE"  		,::SERIE		,Nil})
		AAdd(aSF1,{"F1_EMISSAO"		,::EMISSAO   	,Nil})
		AAdd(aSF1,{"F1_FORNECE"		,cFor   		,Nil})
		AAdd(aSF1,{"F1_LOJA"   		,cLoja  	    ,Nil})
		AAdd(aSF1,{"F1_MENNOTA"		,cIwId  	    ,Nil})

		For m := 1 TO LEN(::oENTRADA:AITENS) 

			aItensTst := WsClassNew("ITENS")
			aItensTst := ::oENTRADA:AITENS[m] 

			//////////////////////////////////////////
			// VALIDA O PRODUTO //////////////////////
			//////////////////////////////////////////
			c_Pro  := GETADVFVAL("SB1","B1_COD",xFilial("SB1")+ aItensTst:COD,1,"")
			IF EMPTY(c_Pro)
				cRetProd := ALLTRIM(cRetProd) + ALLTRIM(aItensTst:COD) + " "    // VERIFICA SE O PRODUTO EXISTE
			ENDIF
			cProdBlq := GETADVFVAL("SB1","B1_MSBLQL",xFilial("SB1")+ aItensTst:COD,1,"")  // VERIFICA SE O PRODUTO ESTA BLOQUEADO
			IF cProdBlq == '1' // Produto bloqueado
				cBlqProd := cBlqProd + ALLTRIM(aItensTst:COD) + " "
			ENDIF 

			//////////////////////////////////////////
			// VALIDA O CENTRO DE CUSTO///////////////
			//////////////////////////////////////////
			c_CC := GETADVFVAL("CTT","CTT_CUSTO",xFilial("CTT")+aItensTst:CC,1,"")
			IF EMPTY(c_CC)
				cRetCC := ALLTRIM(cRetCC) + ALLTRIM(aItensTst:CC) + " "    // VERIFICA SE O CENTRO DE CUSTO EXISTE
			ENDIF

			cClasse := GETADVFVAL("CTT","CTT_CLASSE",xFilial("CTT")+aItensTst:CC,1, "")  // VERIFICA SE O PRODUTO ESTA BLOQUEADO
			IF cClasse == '1' // Classe Sintética
				cRetAS := ALLTRIM(cRetAS) + ALLTRIM(aItensTst:CC) + " "
			ENDIF 

		Next m 

		IF !EMPTY(cRetProd)
			::SAIDA:MENSAGEM := "Pré-nota não será gerada. Produto(s): " +cRetProd+ " não cadastrado(s) no Protheus. Favor cadastrar!"
			::SAIDA:CODSAI := "3"
			Return .T.
		ELSEIF !EMPTY(cBlqProd)
			::SAIDA:MENSAGEM := "Pré-nota não será gerada. Produto(s): " +cBlqProd+ " esta(o) bloqueado(s) no Protheus. Favor verificar!"
			::SAIDA:CODSAI := "3"
			Return .T.
		ELSEIF !EMPTY(cRetCC)
			::SAIDA:MENSAGEM := "Pré-nota não será gerada. Centro de custo(s): " +cRetCC+ " não cadastrado(s) no Protheus. Favor cadastrar!"
			::SAIDA:CODSAI := "3"
			Return .T.
		ELSEIF !EMPTY(cRetAS)
			::SAIDA:MENSAGEM := "Pré-nota não será gerada. Classe do(s) Centro de custo(s): " +cRetAS+ " sintética(s). Favor verificar!"
			::SAIDA:CODSAI := "3"
			Return .T.			
		ENDIF

		For h := 1 TO LEN( ::oENTRADA:AITENS ) 

			// armazena as informações num array local
			aItensLoc := WsClassNew("ITENS")
			aItensLoc := ::oENTRADA:AITENS[h]

			aItens := {}
			AAdd(aItens,{"D1_ITEM"		,aItensLoc:ITEM		   					,Nil})
			AAdd(aItens,{"D1_COD"		,ALLTRIM(aItensLoc:COD)	   		  		,Nil})
			AAdd(aItens,{"D1_QUANT"		,aItensLoc:QUANT			  		   	,Nil})
			AAdd(aItens,{"D1_VUNIT"		,aItensLoc:VUNIT			   		   	,Nil}) 
			AAdd(aItens,{"D1_TOTAL"		,aItensLoc:QUANT * aItensLoc:VUNIT		,Nil})
			AAdd(aItens,{"D1_CC"  		,ALLTRIM(aItensLoc:CC)			  		,Nil})
			AAdd(aSD1,aItens)
		Next h  

		lMsErroAuto := .F.
		MSExecAuto({|x,y,z| MATA140(x,y,z)},aSF1,aSD1,3)  // GERA A PRE-NOTA DE ENTRADA

		IF lMsErroAuto
			cRet := MostraErro()
			::SAIDA:MENSAGEM := cRet
			::SAIDA:CODSAI := "3"
		ELSE
			cRet := "A Pre-nota de entrada numero: "+cDoc+" foi importada com sucesso!"
			::SAIDA:MENSAGEM := cRet
			::SAIDA:CODSAI := "1"
		ENDIF  

		If lAlt 
			DbSelectArea("SA2")
			SA2->(DbGoTop())
			SA2->(DbSetOrder(1))
			If SA2->(MsSeek( xFilial("SA2")+cFor+cLoja ) )
				Reclock("SA2",.F.)
				SA2->A2_XPER := "2"
				SA2->(MsUnlock())
			EndIf
		EndIf

		//::SAIDA:MENSAGEM := cRet

	ELSE

		::SAIDA:MENSAGEM := "FALHA NA AUTENTICAÇÃO DO USUÁRIO!"
		::SAIDA:CODSAI := "3"
		Return .T.

	ENDIF

Return .T. 

Static Function fValid(cUserKey, cTime)

	Local dData:= DATE()
	Local cOut := ""  
	Local lOk := .F.
	Local cStr := "IntegraIW@Protheus#Z" 

	cStr += cValToChar(Year(dData)) 
	cStr += "#M" 
	cStr += cValToChar(Month(dData)) 
	cStr += "#D" 
	cStr += cValToChar(Day(dData)) 
	cStr += cTime
	cOut := SHA1(cStr) 

	IF cOut == LOWER(cUserKey)
		lOk := .T.
	ENDIF

Return(lOk)