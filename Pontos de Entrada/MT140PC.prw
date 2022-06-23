//Bibliotecas
#Include "Protheus.ch"

/*------------------------------------------------------------------------------------------------------*
| P.E.:  MT140PC                                                                                       |
| Desc:  Define se ser� obrigat�rio informar o pedido de compra na cria��o da Pr�-Nota                 |
| Links: http://tdn.totvs.com/pages/releaseview.action�pageId=6085510                                  |
*------------------------------------------------------------------------------------------------------*/

User Function MT140PC()

	Local lRet := ParamIXB[1]

	//Se vir da fun��o de MATA103, define que n�o ser� obrigat�rio
	If SA2->A2_XPER <> "1" .And. Upper(FunName()) == "MATA140"
        lRet := .T.
        If M->D1_PEDIDO == ""
        	MsgInfo( "N�o � permitida a inclus�o de Pr� Nota sem amarra��o com um Pedido de Compra." + CRLF +;
        		 "Entre em contato com a equipe de Suprimentos.","Aten��o! Pr� Nota sem Pedido de Compra!")
        EndIf
    Else
		lRet := .F.
    EndIf
	
Return lRet