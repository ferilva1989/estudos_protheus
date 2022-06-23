#INCLUDE "PROTHEUS.CH"

/*------------------------------------------------------------------------------------------------------------------------------------------------*\
| Fonte:	 |	MT120ISC.PRW                                                                                                                       |
| Autor:	 |	Djalma Borges                                                                                                                      |
| Data:		 |	16/11/2015                                                                                                                         |
| Descrição: |	Ponto de Entrada para preencher os campos de categoria de compra e licitação na inclusão do Pedido.								   |
\*------------------------------------------------------------------------------------------------------------------------------------------------*/

User Function MT120ISC()

	Local nPosVrUnit := aScan(aHeader,{|x| AllTrim(x[2]) == 'C7_PRECO'}) // Djalma 28/04/2016
	Local nPosVrTot  := aScan(aHeader,{|x| AllTrim(x[2]) == 'C7_TOTAL'}) // Trazer Vr da SC para o Pedido

	aCols[n][nPosVrUnit] := SC1->C1_VUNIT
	aCols[n][nPosVrTot]  := SC1->C1_VUNIT * SC1->C1_QUANT

Return