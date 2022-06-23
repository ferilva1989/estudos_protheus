// Projeto: BSL
// Modulo : SIGACOM
// Fonte  : MTCOLSE2 - Ponto de entrada para garantir que o vencimento do t�tulo n�o seja inferior a data real.
// ---------+-------------------+------------------------------------------------------------------------------
// Data     | Autor             | Descricao
// ---------+-------------------+------------------------------------------------------------------------------
// 11/06/19 | Silvano Franca    | Desenvolvimento
// ---------+-------------------+------------------------------------------------------------------------------

#Include 'Protheus.ch'
#Include 'Parmtype.ch'

User Function MTCOLSE2()
	Local aColsE2	:= PARAMIXB[1] //aCols de duplicatas
	Local nOpc		:= PARAMIXB[2] //0-Tela de visualiza��o / 1-Inclus�o ou Classifica��o
	Local nX		:= 0

	// Percorre o array dos t�tulos e verifica se algum deles ficar� vencido ap�s a inclus�o da NF.
	For nX := 1 to Len(aColsE2)
		If aColsE2[nX, 2] < Date() .and. !Empty(cCondicao)
			MsgAlert("A data de vencimento do t�tulo ficar� inferior a "+DtoC(Date())+" por favor selecione outra condi��o de pagamento ou corrija a data de emiss�o da nota fiscal.", "Aten��o - PE MTCOLSE2")
			cCondicao 	:= "   "
			cDescricao 	:= ""
			aColsE2 := {}
			aAdd(aColsE2, {"",StoD(""),0,0,0,0,0,0,0,0,0,0,0,0,0,"SE2",0,.F.})
			Exit
		EndIf
	Next nX

Return aColsE2