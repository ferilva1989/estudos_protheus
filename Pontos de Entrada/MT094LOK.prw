#include 'protheus.ch'
#include 'parmtype.ch'

// #########################################################################################
// Projeto: BSL
// Modulo : SIGACOM
// Fonte  : MT094LOK
// ---------+-------------------+-----------------------------------------------------------
// Data     | Autor             | Descricao
// ---------+-------------------+-----------------------------------------------------------
// 21/08/18 | Edie Carlos       | Ponto de entrada validar aprova��o.
// ---------+-------------------+-----------------------------------------------------------

user function MT094LOK()

	Local 	lRet 		:= .T.

	Private lDvgSCxPC	:= SuperGetMV("ZZ_DVGSCPC", , .F.)


	If SCR->CR_TIPO == "C2"
		U_XCOMA001()
		lRet := .F.
	EndIf

	// Par�metro para habilitar/desabilitar a customiza��o
	If lDvgSCxPC
		If SCR->CR_TIPO == "PC"		
			lRet := U_XCOMA002(SCR->CR_NUM)		
			If !lRet
				APMsgAlert("Aten��o! A (s) SC (s) deste pedido se encontra (m) em processo de aprova��o por diverg�ncia de valores! Por essa raz�o, o pedido n�o pode ser aprovado! ")
			EndIF
		EndIf
	EndIf

return(lRet)