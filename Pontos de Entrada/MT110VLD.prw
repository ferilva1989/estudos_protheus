#Include 'protheus.ch'
#Include 'parmtype.ch'

User function MT110VLD()

	Local ExpN1		:= Paramixb[1]
	Local ExpL1		:= .T. //Validações do ClienteReturn ExpL1
	Local cCodUser	:= RetCodUsr() //Retorna o Codigo do Usuário

	If ExpN1 == 6 //.And. !cCodUser $ (SuperGetMV("ZZ_USRCOM",,""))
		ExpL1 := .F.
		MsgAlert( "Você não tem permissão para excluir Solicitações de Compra. Apenas usuários específicos podem fazer essa exclusão." + CRLF +;
		"Contate a equipe de Suprimentos!","MT110VLD" )
	Else
		ExpL1 := .T.
	EndIf

Return ExpL1