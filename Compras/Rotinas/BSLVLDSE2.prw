#Include "Protheus.ch"
#Include "Parmtype.ch"

User Function BSLVLDSE2()

	Local lAut := .T.

	If FUNNAME() $ "MATA103"
		lAut := .F.
		MSGALERT( "N�o � permitido alterar o valor do t�tulo!", "Aten��o" )
	EndIf

Return(lAut)