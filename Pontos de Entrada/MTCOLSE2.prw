// Projeto: BSL
// Modulo : SIGACOM
// Fonte  : MTCOLSE2 - Ponto de entrada para garantir que o vencimento do título não seja inferior a data real.
// ---------+-------------------+------------------------------------------------------------------------------
// Data     | Autor             | Descricao
// ---------+-------------------+------------------------------------------------------------------------------
// 11/06/19 | Silvano Franca    | Desenvolvimento
// ---------+-------------------+------------------------------------------------------------------------------

#Include 'Protheus.ch'
#Include 'Parmtype.ch'

User Function MTCOLSE2()
	Local aColsE2	:= PARAMIXB[1] //aCols de duplicatas
	Local nOpc		:= PARAMIXB[2] //0-Tela de visualização / 1-Inclusão ou Classificação
	Local nX		:= 0

	// Percorre o array dos títulos e verifica se algum deles ficará vencido após a inclusão da NF.
	For nX := 1 to Len(aColsE2)
		If aColsE2[nX, 2] < Date() .and. !Empty(cCondicao)
			MsgAlert("A data de vencimento do título ficará inferior a "+DtoC(Date())+" por favor selecione outra condição de pagamento ou corrija a data de emissão da nota fiscal.", "Atenção - PE MTCOLSE2")
			cCondicao 	:= "   "
			cDescricao 	:= ""
			aColsE2 := {}
			aAdd(aColsE2, {"",StoD(""),0,0,0,0,0,0,0,0,0,0,0,0,0,"SE2",0,.F.})
			Exit
		EndIf
	Next nX

Return aColsE2