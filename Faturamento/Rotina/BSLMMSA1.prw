#INCLUDE "PROTHEUS.CH" 

/*------------------------------------------------------------------------------------------------------------------------------------------------*\
| Fonte:	 |	BSLMMSA1.PRW                                                                                          	                           |
| Autor:	 |	Marcus Ferraz                                                                                                                      |
| Data:		 |	29/06/2016                                                                                                                         |
| Descrição: |	Utilizado no cadastro de funções para retornar o texto do envio do mmenssager do protheus.                                         |
\*------------------------------------------------------------------------------------------------------------------------------------------------*/

User Function BSLMMSA1()

	//Local aAreaAnt   := GetArea()
	Local cCodCli	:= SA1->A1_COD +"/"+SA1->A1_LOJA
	Local cNomeCli 	:= SA1->A1_NOME
	Local cEmail	:= SA1->A1_EMAIL
	Local cCCusto	:= SA1->A1_XCCREC
	Local cTelCli	:= "("+SA1->A1_DDD+") "+Str(SA1->A1_TEL)
	Local cMens		:= ""

	cMens := "Cliente  : "+cCodCli+CRLF
	cMens += "Nome     : "+cNomeCli+CRLF
	cMens += "E-Mail   : "+cEmail+CRLF
	cMens += "C. Custo : "+cCCusto+CRLF
	cMens += "Telefone : "+cTelCli+CRLF

	//RestArea(aAreaAnt)

Return(cMens)