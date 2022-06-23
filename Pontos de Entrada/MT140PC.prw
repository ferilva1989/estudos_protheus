//Bibliotecas
#Include "Protheus.ch"

/*------------------------------------------------------------------------------------------------------*
| P.E.:  MT140PC                                                                                       |
| Desc:  Define se será obrigatório informar o pedido de compra na criação da Pré-Nota                 |
| Links: http://tdn.totvs.com/pages/releaseview.actionçpageId=6085510                                  |
*------------------------------------------------------------------------------------------------------*/

User Function MT140PC()

	Local lRet := ParamIXB[1]

	//Se vir da função de MATA103, define que não será obrigatório
	If SA2->A2_XPER <> "1" .And. Upper(FunName()) == "MATA140"
        lRet := .T.
        If M->D1_PEDIDO == ""
        	MsgInfo( "Não é permitida a inclusão de Pré Nota sem amarração com um Pedido de Compra." + CRLF +;
        		 "Entre em contato com a equipe de Suprimentos.","Atenção! Pré Nota sem Pedido de Compra!")
        EndIf
    Else
		lRet := .F.
    EndIf
	
Return lRet