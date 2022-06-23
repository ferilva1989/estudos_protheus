// #########################################################################################
// Projeto: BSL
// Modulo : SIGACOM
// Fonte  : MT120ALT
// ---------+-------------------+-----------------------------------------------------------
// Data     | Autor             | Descricao
// ---------+-------------------+-----------------------------------------------------------
// 12/09/18 | Rafael Yera Barchi| Ponto de entrada na alteração do pedido de compra.
// ---------+-------------------+-----------------------------------------------------------

#INCLUDE "PROTHEUS.CH"


//------------------------------------------------------------------------------------------
/*/{Protheus.doc} MT120ALT
Ponto de entrada na alteração do pedido de compra.

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


	If lVldAlt .And. nOpcao == 4	//Alteração

		// Verifica se o pedido está em aprovação
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
			APMsgAlert("Este pedido está em processo de aprovação e não pode ser alterado. ")
		EndIf

		If lRet
			lRet := U_XCOMA002(SC7->C7_NUM)
			If !lRet
				APMsgAlert("Atenção! A (s) SC (s) deste pedido se encontra (m) em processo de aprovação por divergência de valores! Por essa razão, o pedido não pode ser aprovado! ")
			EndIf
		EndIf

	EndIf

Return lRet