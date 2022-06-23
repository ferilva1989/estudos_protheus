#Include "Protheus.ch"
#include "Parmtype.ch"

User Function A140Exc()

	Local ExpL1 := .F.// Bloqueia exclus�o de Pr�-Nota
	Local cCodUser := RetCodUsr() //Retorna o Codigo do Usu�rio

	If cCodUser $ (SuperGetMV("ZZ_USPRENF",,""))
		MsgAlert( "Voc� n�o tem permiss�o para excluir pr�-nota de entrada. Apenas usu�rios espec�ficos podem fazer essa exclus�o." + CRLF +;
		"Contate o administrador do sistema!","A140EXC" )
	Else
		ExpL1 := .T.
	EndIf

Return ExpL1