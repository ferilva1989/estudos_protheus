// #########################################################################################
// Projeto: BSL
// Modulo : SIGACOM
// Fonte  : MT120ALT
// ---------+-------------------+-----------------------------------------------------------
// Data     | Autor             | Descricao
// ---------+-------------------+-----------------------------------------------------------
// 12/09/18 | Rafael Yera Barchi| Ponto de entrada na altera��o do pedido de compra.
// ---------+-------------------+-----------------------------------------------------------

#INCLUDE "PROTHEUS.CH"


//------------------------------------------------------------------------------------------
/*/{Protheus.doc} MT120ALT
Ponto de entrada na altera��o do pedido de compra.

@author    Rafael Yera Barchi 
@version   1.xx
@since     12/09/2018
/*/
//------------------------------------------------------------------------------------------
User Function MT120ALT()

	Local lRet 		:= .T.
	Local cSQL		:= ""
	Local cEOL		:= Chr(13) + Chr(10)
	Local cAliasTRB	:= GetNextAlias()
	Local nOpcao	:= ParamIXB[1]
	Local lVldAlt	:= SuperGetMV("ZZ_VLDALT", , .T.)


	If lVldAlt .And. nOpcao == 4	//Altera��o

		// Verifica se o pedido est� em aprova��o
		cSQL := " SELECT CR_FILIAL, CR_NUM, CR_TIPO, CR_STATUS " + cEOL
		cSQL += "   FROM " + RetSQLName("SCR") + " SCR " + cEOL
		cSQL += "  WHERE CR_FILIAL = '" + SC7->C7_FILIAL + "' " + cEOL
		cSQL += "    AND CR_NUM = '" + SC7->C7_NUM + "' " + cEOL
		cSQL += "    AND CR_STATUS <> '03' " + cEOL
		cSQL += "    AND D_E_L_E_T_ = ' ' " + cEOL

		If Select(cAliasTRB) > 0
			(cAliasTRB)->(DBCloseArea())
		EndIf
		DBUseArea(.T., "TOPCONN", TCGenQry( , , cSQL), (cAliasTRB), .F., .T.)

		(cAliasTRB)->(DBSelectArea(cAliasTRB))
		(cAliasTRB)->(DBGoTop())
		While !(cAliasTRB)->(EOF())	
			lRet := .F.
			(cAliasTRB)->(DBSkip())
		EndDo

		If Select(cAliasTRB) > 0
			(cAliasTRB)->(DBCloseArea())
		EndIf

		If !lRet
			APMsgAlert("Este pedido est� em processo de aprova��o e n�o pode ser alterado. ")
		EndIf

		If lRet
			lRet := U_XCOMA002(SC7->C7_NUM)
			If !lRet
				APMsgAlert("Aten��o! A (s) SC (s) deste pedido se encontra (m) em processo de aprova��o por diverg�ncia de valores! Por essa raz�o, o pedido n�o pode ser aprovado! ")
			EndIf
		EndIf

	EndIf

Return lRet