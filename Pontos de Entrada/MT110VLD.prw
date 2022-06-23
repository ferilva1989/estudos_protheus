#Include 'protheus.ch'
#Include 'parmtype.ch'

User function MT110VLD()

	Local ExpN1		:= Paramixb[1]
	Local ExpL1		:= .T. //Valida��es do ClienteReturn ExpL1
	Local cCodUser	:= RetCodUsr() //Retorna o Codigo do Usu�rio

	If ExpN1 == 6 //.And. !cCodUser $ (SuperGetMV("ZZ_USRCOM",,""))
		ExpL1 := .F.
		MsgAlert( "Voc� n�o tem permiss�o para excluir Solicita��es de Compra. Apenas usu�rios espec�ficos podem fazer essa exclus�o." + CRLF +;
		"Contate a equipe de Suprimentos!","MT110VLD" )
	Else
		ExpL1 := .T.
	EndIf

Return ExpL1