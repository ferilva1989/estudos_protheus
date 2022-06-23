#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

//------------------------------------------------------------------------------
/*/	{Protheus.doc} MATA030

Programa de atualização de Clientes.

@sample	MATA030( xRotAuto, nOpcAuto, oDlgOwner, cFilDef, aAddFil, cVDefault )

@param		ExpX1 = Determina se é rotina automática 
ExpN1 = Numero da opção da operação
ExpO1 = Objeto da tela
ExpC1 = Filtro Default do Browse
ExpA1 = Array de filtro
ExpC2 = Visão inicial Default		 

@return	Verdadeiro

@author	Marcus Ferraz
@since		
@version	12
/*/

User Function MATA030()
	Local aParam     := PARAMIXB
	Local xRet       := .T.
	Local oObj       := ''
	Local cIdPonto   := ''
	Local cIdModel   := ''
	Local lIsGrid    := .F.

	Local nLinha     := 0
	Local nQtdLinhas := 0
	Local cMsg       := ''


	If aParam <> NIL

		oObj       := aParam[1]
		cIdPonto   := aParam[2]
		cIdModel   := aParam[3]
		lIsGrid    := ( Len( aParam ) > 3 )

		If lIsGrid
			nQtdLinhas := oObj:GetQtdLine()
			nLinha     := oObj:nLine
		EndIf

		If cIdPonto == 'MODELCOMMITTTS'
			EnviaMail()			              	          
		EndIf

	EndIf

Return xRet


/*
***********************************************
* Progrma: EnviaMail    Autor: Marcus Ferraz  *
* Descrição: Envia email.                     *
* Data: 07/07/2016                            *
* Parametros:                                 *
*                                             *
***********************************************
*/ 

Static Function EnviaMail()

	Local _cHTML := ""

	_cHTML:='<HTML><HEAD><TITLE></TITLE>'
	_cHTML+='<META http-equiv=Content-Type content="text/html; charset=windows-1252">'
	_cHTML+='<META content="MSHTML 6.00.6000.16735" name=GENERATOR></HEAD>'
	_cHTML+='<BODY>'
	_cHTML+='<H1><FONT color=#ff0000>Cadastro de novo Cliente</FONT></H1>'
	_cHTML+='<TABLE cellSpacing=0 cellPadding=0 width="100%" bgColor=#afeeee background="" '
	_cHTML+='border=1>'
	_cHTML+='  <TBODY>'
	_cHTML+='  <TR>'
	_cHTML+='    <TD>Código Cliente:'+SA1->(A1_COD+A1_LOJA)+'</TD>'
	_cHTML+='  </TR>'
	_cHTML+='  <TR>'
	_cHTML+='    <TD>Nome Cliente:'+SA1->A1_NOME+'</TD>'
	_cHTML+='  </TR>'
	_cHTML+='  <TR>'
	_cHTML+='    <TD>E-mail:'+SA1->A1_EMAIL+'</TD>'
	_cHTML+='  </TR>'
	_cHTML+='  <TR>'
	_cHTML+='    <TD>Centro de Custo:'+SA1->A1_CC+'</TD>'
	_cHTML+='  </TR>'
	_cHTML+='  </TBODY></TABLE>'
	_cHTML+='<P>&nbsp;</P>'
	_cHTML+='</BODY></HTML>'

	// Envia o e-mail
	U_ENVMAIL("marcus.ferraz@deltadecisao.com.br","meuemail@dominio.com.br","TESTE DE  ENVIO DE EMAIL...",_cHTML,NIL,.F.)

Return