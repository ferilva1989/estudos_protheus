#include 'protheus.ch'
#include 'parmtype.ch'

// #########################################################################################
// Projeto: BSL
// Modulo : SIGACOM
// Fonte  : MTA094RO
// ---------+-------------------+-----------------------------------------------------------
// Data     | Autor             | Descricao
// ---------+-------------------+-----------------------------------------------------------
// 21/08/18 | Edie Carlos       | Ponto de entrada para rejeita aprovação gerarada customizada 
//								|  do pedido de venda.
// ---------+-------------------+-----------------------------------------------------------

user function MTA094RO()
	Local aRotina := PARAMIXB[1]
	Local nX      := 0
	Local nPos    := 0

	aAdd(aRotina,{"Rejeita (Divergencia)","U_XCOMA001('5')" ,0,4}) 

Return (aRotina)