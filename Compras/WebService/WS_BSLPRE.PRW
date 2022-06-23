#include 'protheus.ch'
#include 'apwebsrv.ch'
#Include "TopConn.ch"
#Include "aarray.ch"
#Include "json.ch"
#Include "xmlxfun.CH"

#Define STR_PULA Chr(13) + Chr(10)
WsService WS_BSLPRE Description "Serviço de integração Protheus x IW"
	WsData cString	 	As String 	
	WsData cCodFilial	As String
	WsData cDataInicio	As String 
	WsData cDataFim	 	As String 
	WsData cUserKey	 	As String 
	WsData cTime	 	As String
	WsData cXml			As String 
	WsMethod GetInsPreNf Description "Método para Inlcuir a pré-nota"
	//WsMethod GetDelPreNf Description "Método para Deletar a pré-nota"
	//WsMethod GetAltPreNf Description "Método para Alterar a pré-nota"
EndWsService

WsMethod GetInsPreNf WsReceive cUserKey, cTime, cXml WsSend cString WsService WS_BSLPRE

	Local cError	:= ""
	Local cWarning	:= ""  
	Local oXmlNf
	Local aItmNf	:= {}
	Local aNf		:= {}
	Local i			:= 1
	Local bOk := fValid(cUserKey, cTime)

	If bOk

		oXmlNf := XmlParser ( cXml, "_", @cError, @cWarning) 

		IF valType(oXmlNf:_NOTA) == "O"

			//XmlNode2Arr(oXmlNf:_NOTA:_NFE, "_NFE")
			For i := 1 to Len(oXmlNf:_NOTA:_NFE)

				AAdd(aItmNf,oXmlNf:_NOTA:_NFE[i]:_FILIAL:TEXT	)
				AAdd(aItmNf,oXmlNf:_NOTA:_NFE[i]:_NOTA:Text		)
				AAdd(aItmNf,oXmlNf:_NOTA:_NFE[i]:_SERIE:Text	)
				AAdd(aItmNf,oXmlNf:_NOTA:_NFE[i]:_PRODUTO:Text	)
				AAdd(aItmNf,oXmlNf:_NOTA:_NFE[i]:_QUANT:Text	)
				AAdd(aItmNf,oXmlNf:_NOTA:_NFE[i]:_VALOR:Text	)
				AAdd(aItmNf,oXmlNf:_NOTA:_NFE[i]:_CCUSTO:Text	)
				AAdd(aItmNf,oXmlNf:_NOTA:_NFE[i]:_CNPJ:Text		)
				AAdd(aItmNf,oXmlNf:_NOTA:_NFE[i]:_DTEMIS:Text	)
				AAdd(aItmNf,oXmlNf:_NOTA:_NFE[i]:_DTENTR:Text	)
				AAdd(aItmNf,oXmlNf:_NOTA:_NFE[i]:_QUEBRA:Text	)
				AAdd(aNf,aItmNf)
				aItmNf := {}

			Next i

			cDados := u_BSLCOM003(aItmNf)

		Else
			cDados := "Erro no XML, TAG NFE não Existe" 
		EndIf

	Else
		cDados := "Erro"
	EndIf

	::cString := cDados 

Return .T.

Static Function fQryAr(cQuery) 

	Local aRet    := {} 
	Local aRet1   := {} 
	Local aRetNomes
	Local nRegAtu := 0 
	Local x       := 0 

	cQuery := ChangeQuery(cQuery) 
	TCQUERY cQuery NEW ALIAS "_TRB" 

	dbSelectArea("_TRB") 
	aRet1   := Array(Fcount()) 
	nRegAtu := 1 

	While !Eof() 

		For x:=1 To Fcount() 
			aRet1[x] := FieldGet(x) 
		Next 
		Aadd(aRet,aclone(aRet1)) 

		dbSkip() 
		nRegAtu += 1 
	Enddo 

	aRetNomes := DBStruct()

	dbSelectArea("_TRB") 
	_TRB->(DbCloseArea()) 

Return({aRetNomes, aRet}) 

Static Function fValid(cUserKey, cTime) 
	Local dData:= Date()
	Local sOut := ""  
	Local bOk := .F.
	Local sStr := "Sysphera@Protheus#Y" 
	sStr += cValToChar(Year(dData)) 
	sStr += "#M" 
	sStr += cValToChar(Month(dData)) 
	sStr += "#D" 
	sStr += cValToChar(Day(dData)) 
	sStr += cTime
	sOut := SHA1( sStr ) 

	IF sOut == LOWER(cUserKey)
		bOk := .T.
	ENDIF

Return(bOk)