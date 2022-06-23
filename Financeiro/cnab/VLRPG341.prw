#INCLUDE "PROTHEUS.CH" 

/*------------------------------------------------------------------------------------------------------------------------------------------------*\
| Fonte:	 |	VLRPG341.PRW                                                                                          	                           |
| Autor:	 |	Marcus Ferraz                                                                                                                      |
| Data:		 |	07/04/2016                                                                                                                         |
| Descri��o: |	Fun��o que retorna o valor liquido do titulo para o sispag ita�   															   |
\*------------------------------------------------------------------------------------------------------------------------------------------------*/

User Function VLRPG341()

	Local cValTit 	:= ""
	Local nValTit	:= 0

	//nValTit := somaabat(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,'P',SE2->E2_MOEDA,DDATABASE,SE2->E2_FORNECE,SE2->E2_LOJA)
	nValTit := SE2->E2_SALDO
	cValTit := padl(alltrim(StrTran(cValToChar(transform(nValTit, "@E 9999999999999.99")),',','')),15,"0")

Return(cValTit)
