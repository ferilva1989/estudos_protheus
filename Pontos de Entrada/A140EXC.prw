#Include "Protheus.ch"
#include "Parmtype.ch"

User Function A140Exc()

	Local ExpL1 := .F.// Bloqueia exclusão de Pré-Nota
	Local cCodUser := RetCodUsr() //Retorna o Codigo do Usuário

	If cCodUser $ (SuperGetMV("ZZ_USPRENF",,""))
		MsgAlert( "Você não tem permissão para excluir pré-nota de entrada. Apenas usuários específicos podem fazer essa exclusão." + CRLF +;
		"Contate o administrador do sistema!","A140EXC" )
	Else
		ExpL1 := .T.
	EndIf

Return ExpL1