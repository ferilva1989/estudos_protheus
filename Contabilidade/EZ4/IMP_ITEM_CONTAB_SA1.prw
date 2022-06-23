// #########################################################################################
// Projeto:
// Modulo :
// Fonte  : IMPSB1
// ---------+-------------------+-----------------------------------------------------------
// Data     | Autor             | Descricao
// ---------+-------------------+-----------------------------------------------------------
// 14/07/16 | TOTVS | Developer Studio | Gerado pelo Assistente de C�digo
// ---------+-------------------+-----------------------------------------------------------

#include "rwmake.ch"

//------------------------------------------------------------------------------------------
/*/{Protheus.doc} novo
Leitura de Arquivo Texto

@author    TOTVS | Developer Studio - Gerado pelo Assistente de C�digo
@version   1.xx
@since     14/07/2016
/*/
//------------------------------------------------------------------------------------------
user function IMPCLSA1()
	local oDlgLeTxt

	//--< montagem da tela de processamento >---------------------------------------------------
	@ 200,  1 to 380, 380 dialog oDlgLeTxt title "Gera��o de Item de Classe"
	@ 02, 10 to 65, 180

	//Coloque um pequeno descritivo com o objetivo deste processamento
	@ 10, 18 say "Este programa ira criar Item de Classe baseado no cadastro"
	@ 18, 18 say "de clientes sendo o codigo do Item de Classe ser� formado"
	@ 34, 18 say "por ALLTRIM(SA1->A1_COD)+ALLTRIM(SA1->A1_LOJA)"
	@ 34, 80 say "CTD"

	@ 68, 128 bmpButton type 01 action eval({ || doIt(), close(oDlgLeTxt) })
	@ 68, 158 bmpButton type 02 action close(oDlgLeTxt)
	activate dialog oDlgLeTxt centered


return

//------------------------------------------------------------------------------------------
/*/{Protheus.doc} doIt
Gerencia a execu��o do processo de exporta��o.

@author    TOTVS | Developer Studio - Gerado pelo Assistente de C�digo
@version   1.xx
@since     14/07/2016
/*/
//------------------------------------------------------------------------------------------
static function doIt()

	Processa({|| doProcess() }, "Processando...")


return(NIL)
//-------------------------------
static function doProcess()

	dbSelectArea("SA1")
	SA1->(dbsetorder(1))
	SA1->(DbGoTop())
	SA1->(DBSEEK(XFILIAL("SA1")))
	procregua(reccount())

	While ! SA1->(eof()) .AND. SA1->A1_FILIAL = XFILIAL("SA1")

		incproc(ALLTRIM(SA1->A1_NOME))
		dbSelectArea("CTD")
		CTD->(dbSetOrder(1))

		If !MsSeek(Xfilial("CTD") + ALLTRIM(SA1->A1_COD) + ALLTRIM(SA1->A1_LOJA))
			RecLock("CTD",.T.) 	//Incluir
			CTD->CTD_FILIAL 		:= xFilial("CTD")
			CTD->CTD_ITEM				:= "C" + ALLTRIM(SA1->A1_COD) + ALLTRIM(SA1->A1_LOJA)
			CTD->CTD_CLASSE     := "2"
			CTD->CTD_NORMAL     := ""
			CTD->CTD_DESC01     := ALLTRIM(SA1->A1_NOME)
			CTD->CTD_BLOQ       := "2"
			CTD->CTD_DTEXIS     := CTOD("01/01/1980")
			CTD->CTD_CLOBRG			:= "2"
			CTD->CTD_ACCLVL			:= "1"
			CTD->(MsUnlock()) 	//Libera registro
		ENDif

		SA1->(dbSkip())

	EndDo

return(NIL)
//--< fim de arquivo >----------------------------------------------------------------------
