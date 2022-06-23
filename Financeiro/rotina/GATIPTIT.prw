#Include 'PROTHEUS.CH'
#Include 'TOTVS.CH'
#Include 'PARMTYPE.CH'

// ----------------------------------------------------------------------------------------------------//
// Projeto: Implantação RM Corpore																	   //
// Modulo : RH RM x Financeiro Protheus																   //
// Fonte  : GATIPTIT.prw																			   //
// -----------+-------------------+--------------------------------------------------------------------//
// Data       | Autor             | Descricao														   //
// -----------+-------------------+--------------------------------------------------------------------//
// 19/07/2018 | Filipe.Silva      | Esse programa atualiza a natureza correta do título na integração  //
// -----------+-------------------+--------------------------------------------------------------------//

User Function GATIPTIT()

	Local cTpTit	:= M->E2_TIPO
	Local cNatur	:= ""

	If cTpTit == "131" .Or. cTpTit == "132"
		cNatur := "2111016"
	ElseIf cTpTit == "ADI"
		cNatur := "2171004"
	ElseIf cTpTit == "ASS"
		cNatur := "2111019"
	ElseIf cTpTit == "BEN"
		cNatur := "2111007"
	ElseIf cTpTit == "BON"
		cNatur := "2111010"
	ElseIf cTpTit == "EMP"
		cNatur := "2111021"
	ElseIf cTpTit == "FER"
		cNatur := "2111017"
	ElseIf cTpTit == "FGT"
		cNatur := "2111012"
	ElseIf cTpTit == "FOL"
		cNatur := "2111001"
	ElseIf cTpTit == "GPS"
		cNatur := "2111011"
	ElseIf cTpTit == "IRR"
		cNatur := "2111013"
	ElseIf cTpTit == "PEN"
		cNatur := "2111002"
	ElseIf cTpTit == "RES"
		cNatur := "2111015"
	ElseIf cTpTit == "SIN"
		cNatur := "2111018"
	ElseIf cTpTit == "RPA"
		cNatur := "2111025"		
	EndIf

Return(cNatur)