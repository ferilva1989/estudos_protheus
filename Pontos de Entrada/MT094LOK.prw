#include 'protheus.ch'
#include 'parmtype.ch'

// #########################################################################################
// Projeto: BSL
// Modulo : SIGACOM
// Fonte  : MT094LOK
// ---------+-------------------+-----------------------------------------------------------
// Data     | Autor             | Descricao
// ---------+-------------------+-----------------------------------------------------------
// 21/08/18 | Edie Carlos       | Ponto de entrada validar aprovação.
// ---------+-------------------+-----------------------------------------------------------

user function MT094LOK()

	Local 	lRet 		:= .T.

	Private lDvgSCxPC	:= SuperGetMV("ZZ_DVGSCPC", , .F.)


	If SCR->CR_TIPO == "C2"
		U_XCOMA001()
		lRet := .F.
	EndIf

	// Parâmetro para habilitar/desabilitar a customização
	If lDvgSCxPC
		If SCR->CR_TIPO == "PC"		
			lRet := U_XCOMA002(SCR->CR_NUM)		
			If !lRet
				APMsgAlert("Atenção! A (s) SC (s) deste pedido se encontra (m) em processo de aprovação por divergência de valores! Por essa razão, o pedido não pode ser aprovado! ")
			EndIF
		EndIf
	EndIf

return(lRet)