#Include "Protheus.ch"
#Include "Parmtype.ch"

User Function BSLVLDSE2()

	Local lAut := .T.

	If FUNNAME() $ "MATA103"
		lAut := .F.
		MSGALERT( "Não é permitido alterar o valor do título!", "Atenção" )
	EndIf

Return(lAut)