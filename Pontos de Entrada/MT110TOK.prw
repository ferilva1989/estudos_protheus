#include 'protheus.ch'
#include 'parmtype.ch'

/*==========================================================================
Funcao.........:	MT110TOK
Descricao......:	Rotina para validação de alteração solicitação de compras
Autor..........:	Edie Carlos
Data...........:	07/2018
Parametros.....:	Nil
Retorno........:	Nil
==========================================================================*/

User Function MT110TOK()

	Local 	lBloc   	:= .F. 
	Local 	lRet    	:= .T.
	Local 	nQtdAp  	:= 0
	Local 	nQtdScr 	:= 0

	Private lDvgSCxPC	:= SuperGetMV("ZZ_DVGSCPC", , .F.)


	//Verifica se solicitação esta com aprovação em andamento quando usuario tenta alterar o valor
	dbSelectArea("SCR")
	SCR->(dbSeek(xFilial("SCR")+CA110NUM))
	IF SCR->(dbSeek(xFilial("SCR")+"SC"+CA110NUM))

		While SCR->(!EOF()) .AND. SCR->CR_TIPO == "SC" .AND. Alltrim(SCR->CR_NUM) == CA110NUM
			IF Alltrim(SCR->CR_STATUS) == "03"
				nQtdAp++
			EndIf

			IF Alltrim(SCR->CR_STATUS) == "05"
				lBloc:= .T.
			EndIf
			SCR->(dbSkip())
			nQtdScr++
		EndDo

		// Parâmetro para habilitar/desabilitar a customização
		If lDvgSCxPC		
			//verifica quantidade de resgistro aprovados
			IF (nQtdAp <> nQtdScr .AND. nQtdAp > 0) .and. !lBloc
				MSGINFO("Pedido já se encontra em processo de aprovação e não pode ser alterado")
				lRet := .F.
			EndIF
		EndIf

	ENDIF


return (lRet)