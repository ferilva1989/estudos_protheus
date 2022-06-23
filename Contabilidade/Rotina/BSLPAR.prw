#INCLUDE "PROTHEUS.CH"

user function BSLPAR()

	Local oDlg, oBtn1, oSay1
	Local aPARAM   := {}
	Local oFont    := TFont():New("Courier New",,20,.T.)
	Local nNext

	AAdd(aPARAM,{ 'MV_DATAFIN', Ctod("  /  /  ") } )
	AAdd(aPARAM,{ 'MV_ULMES',   Ctod("  /  /  ") } )
	AAdd(aPARAM,{ 'MV_DBLQMOV', Ctod("  /  /  ") } )
	AAdd(aPARAM,{ 'MV_DATAFIS', Ctod("  /  /  ") } )
	AAdd(aPARAM,{ 'MV_DATADE',  Ctod("  /  /  ") } )
	AAdd(aPARAM,{ 'MV_DATAATE', Ctod("  /  /  ") } )

	// Buscando Definição dos Parametros.
	DbSelectArea("SX6")
	For nNext := 1 to Len(aPARAM)
		If SX6->(DbSeek(xFilial()+aPARAM[nNext,1]))
			aPARAM[nNext, 2] := CtoD(SubStr(SX6->X6_CONTEUD,7,2) + "/" + SubStr(SX6->X6_CONTEUD,5,2) + "/" + SubStr(SX6->X6_CONTEUD,1,4))
		EndIf
	Next

	DEFINE MSDIALOG oDlg TITLE 'ROTINA BLOQUEIO DE MOVIMENTOS' FROM 10,10 TO 22, 165

	oFont:Bold := .T.
	@ 005, 005 SAY oSay1 PROMPT "Modulo...... Descrição...................................... Parâmetros................................................" FONT oFont COLOR CLR_RED, CLR_RED OF oDlg PIXEL
	oFont:Bold := .F.

	@ 015, 005 SAY oSay1 PROMPT "Financeiro   Data de Bloqueio Financeiro                     Data Bloqueio:                                    " FONT oFont COLOR CLR_BLACK,CLR_RED OF oDlg PIXEL
	@ 025, 005 SAY oSay1 PROMPT "Estoque      Data de Fechamento do Estoque                   Data Fechamento:      							" FONT oFont COLOR CLR_BLACK,CLR_RED OF oDlg PIXEL
	@ 035, 005 SAY oSay1 PROMPT "Compras      Data de Bloqueio da Movimentação                Data Bloqueio:        			 				" FONT oFont COLOR CLR_BLACK,CLR_RED OF oDlg PIXEL
	@ 045, 005 SAY oSay1 PROMPT "Fiscal       Data limite para Movimentacao Fiscal            Data Bloqueio:                                    " FONT oFont COLOR CLR_BLACK,CLR_RED OF oDlg PIXEL
	@ 055, 005 SAY oSay1 PROMPT "Contábil     Data de Competência dos Lançamentos Contabeis   Data Bloqueio Inicio:          Data Bloqueio Fim: " FONT oFont COLOR CLR_BLACK,CLR_RED OF oDlg PIXEL

	@ 015, 420 MSGET aPARAM[01, 02] Picture "@D" SIZE 40,05 OF oDlg PIXEL
	@ 025, 420 MSGET aPARAM[02, 02] Picture "@D" SIZE 40,05 OF oDlg PIXEL
	@ 035, 420 MSGET aPARAM[03, 02] Picture "@D" SIZE 40,05 OF oDlg PIXEL
	@ 045, 420 MSGET aPARAM[04, 02] Picture "@D" SIZE 40,05 OF oDlg PIXEL
	@ 055, 420 MSGET aPARAM[05, 02] Picture "@D" SIZE 40,05 OF oDlg PIXEL
	@ 055, 560 MSGET aPARAM[06, 02] Picture "@D" SIZE 40,05 OF oDlg PIXEL

	@ 070, 510 BUTTON oBtn1 PROMPT 'CANCELAR' ACTION ( oDlg:End() )           SIZE 40, 013 OF oDlg PIXEL
	@ 070, 560 BUTTON oBtn1 PROMPT 'GRAVAR'   ACTION ( RecSX6(aParam, oDlg) ) SIZE 40, 013 OF oDlg PIXEL

	ACTIVATE DIALOG oDlg CENTER

Return .T.

/*
* Função.....: RECSX6()
*
* Objetivo...: Gravar os Parametros dos Movimentos
*/

Static Function RecSX6(aParam, oDlg, nNext)

	DbSelectArea("SX6")
	For nNext := 1 to Len(aPARAM)
		If SX6->(DbSeek(xFilial()+aPARAM[nNext,1]))
			RecLock("SX6",.F.)
			SX6->X6_CONTEUD := DtoS(aParam[nNext, 2])
			SX6->X6_CONTENG := DtoS(aParam[nNext, 2])
			SX6->X6_CONTSPA := DtoS(aParam[nNext, 2])
			MsUnLock()
		EndIf
	Next
	MsgInfo("Parametros Atualizado com Sucesso !")
	oDlg:End()

Return .T.