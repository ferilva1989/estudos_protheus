// #########################################################################################
// Projeto:
// Modulo :
// Fonte  : IMPSB1
// ---------+-------------------+-----------------------------------------------------------
// Data     | Autor             | Descricao
// ---------+-------------------+-----------------------------------------------------------
// 14/07/16 | TOTVS | Developer Studio | Gerado pelo Assistente de C�digo
// ---------+-------------------+-----------------------------------------------------------
// #########################################################################################

#Include "RwMake.ch"

//------------------------------------------------------------------------------------------
/*/{Protheus.doc} novo
Leitura de Arquivo Texto

@author    TOTVS | Developer Studio - Gerado pelo Assistente de C�digo
@version   1.xx
@since     14/07/2016
/*/
//------------------------------------------------------------------------------------------

User Function IMPCLSA2()

	Local oDlgLeTxt

	//--< montagem da tela de processamento >---------------------------------------------------
	@ 200, 1 to 380, 380 Dialog oDlgLeTxt Title "Geração de Item Contábil"
	@ 02, 10 to 65, 180

	//Coloque um pequeno descritivo com o objetivo deste processamento
	@ 10, 18 say "Este programa ira criar Item Contábil baseado no cadastro"
	@ 18, 18 say "de Fornecedores sendo o codigo do Item Contábil a ser formado"
	@ 34, 18 say "por 'F' + ALLTRIM(SA2->A2_COD) + ALLTRIM(SA2->A2_LOJA)"
	@ 34, 80 say "CTD"

	@ 68, 128 bmpButton type 01 action eval({ || doIt(), close(oDlgLeTxt) })
	@ 68, 158 bmpButton type 02 action close(oDlgLeTxt)
	Activate dialog oDlgLeTxt Centered

Return

//------------------------------------------------------------------------------------------
/*/{Protheus.doc} doIt
Gerencia a execu��o do processo de exporta��o.

@author    TOTVS | Developer Studio - Gerado pelo Assistente de C�digo
@version   1.xx
@since     14/07/2016
/*/
//------------------------------------------------------------------------------------------

Static Function DoIt()

	Processa({|| doProcess() }, "Processando...")

Return(NIL)

//-------------------------------

Static Function DoProcess()

	dbSelectArea("SA2")
	SA2->(dbsetorder(1))
	SA2->(DbGoTop())
	SA2->(DBSEEK(XFILIAL("SA2")))
	Procregua(RecCount())

	While ! SA2->(eof()) .AND. SA2->A2_FILIAL = XFILIAL("SA2")

		IncProc(ALLTRIM(SA2->A2_NOME))
		DbSelectArea("CTD")
		CTD->(dbSetOrder(1))

		If !MsSeek(XFilial("CTD") + "F" + ALLTRIM(SA2->A2_COD) + ALLTRIM(SA2->A2_LOJA))

			RecLock("CTD",.T.) //Incluir
			CTD->CTD_FILIAL		:= xFilial("CTD")
			CTD->CTD_ITEM		:= "F" + ALLTRIM(SA2->A2_COD) + ALLTRIM(SA2->A2_LOJA)
			CTD->CTD_CLASSE     := "2"
			CTD->CTD_NORMAL     := ""
			CTD->CTD_DESC01     := ALLTRIM(SA2->A2_NOME)
			CTD->CTD_BLOQ       := "2"
			CTD->CTD_DTEXIS     := CTOD("01/01/1980")
			CTD->CTD_CLOBRG		:= "2"
			CTD->CTD_ACCLVL		:= "1"
			CTD->(MsUnlock())	//Libera registro

		EndIf
		
		SA2->(DbSkip())
		
	EndDo
	
Return(NIL)
