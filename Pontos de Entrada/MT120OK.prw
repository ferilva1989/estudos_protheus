#include 'protheus.ch'
#include 'parmtype.ch'

/*==========================================================================
Funcao.........:	MT120OK
Descricao......:	Valida se o item nao se encontra em processo de aprovaçao
Autor..........:	Edie Carlos 
Data...........:	07/2018
Parametros.....:	
Retorno........:	Nil
==========================================================================*/

user function MT120OK()

	Local 	lRet       	:= .T.
	Local 	cNumSc     	:= ""
	Local 	nQtdScr    	:= 0
	Local 	nQtdAp     	:= 0
	Local 	lVlDif     	:= .F.
	Local 	lAprov     	:= .F.
	Local 	nPosItem	:= aScan(aHeader,{|x|Alltrim(x[2])=="C7_ITEM"})
	Local 	nPosProd	:= aScan(aHeader,{|x|Alltrim(x[2])=="C7_PRODUTO"})
	Local 	nPosPRC	 	:= aScan(aHeader,{|x|Alltrim(x[2])=="C7_PRECO"})
	Local 	cAliasSC7 	:= GetNextAlias()
	Local 	lRejet     	:= .T.

	Private lDvgSCxPC	:= SuperGetMV("ZZ_DVGSCPC", , .F.)


	// Parâmetro para habilitar/desabilitar a customização
	If lDvgSCxPC

		If Altera

			dbSelectArea("SCR")
			dbSetOrder(1)

			//Verifica se o pedido não esta em processo de aprovação 


			BeginSql Alias cAliasSC7

				SELECT	DISTINCT C7_ITEM,C7_PRODUTO,C7_NUM,C7_PRECO,C1_VUNIT,C7_NUMSC,C1_CC,C7_TOTAL
				FROM %Table:SC7% SC7
				INNER JOIN %Table:SC1% SC1 ON C1_FILIAL= %xFilial:SC1% AND C7_NUMSC = C1_NUM
				WHERE
				SC7.C7_FILIAL = %xFilial:SC7% AND
				SC7.C7_NUM = %Exp:SC7->C7_NUM% AND
				SC7.C7_CONAPRO = 'B' AND 
				SC7.%notdel% AND
				SC1.%notdel%

			EndSql

			cNumSc    := (cAliasSC7)->C7_NUMSC

			While (cAliasSC7)->(!EOF()) .AND. lRet

				//Verifica se o valor foi alterado

				nPos := aScan( aCols, {|x| x[nPosItem] == (cAliasSC7)->C7_ITEM .AND. x[nPosProd] == (cAliasSC7)->C7_PRODUTO } )

				IF aCols[nPos][nPosPRC] <> (cAliasSC7)->C7_TOTAL
					//Verifica se solicitação esta com aprovação em andamento quando usuario tenta alterar o valor
					IF SCR->(dbSeek(xFilial("SCR")+"C2"+(cAliasSC7)->C7_NUMSC)) //.AND. (cAliasSC7)->C7_NUMSC <> cNumSc

						While SCR->(!EOF()) .AND. SCR->CR_TIPO == "C2" .AND. Alltrim(SCR->CR_NUM) == (cAliasSC7)->C7_NUMSC
							IF Alltrim(SCR->CR_STATUS) == "03"
								nQtdAp++
							EndIf
							SCR->(dbSkip())
							nQtdScr++
						EndDo

						//verifica quantidade de resgistro aprovados
						IF nQtdAp <> nQtdScr
							MSGINFO("Pedido já se encontra em processo de aprovação e não pode ser alterado")
							lRet := .F.
						EndIF

					ENDIF
				ENDIF

				//Verificar quantidade de registro aprovado 
				IF SCR->(dbSeek(xFilial("SCR")+"C2"+(cAliasSC7)->C7_NUMSC)) //.AND. (cAliasSC7)->C7_NUMSC <> cNumSc

					While SCR->(!EOF()) .AND. SCR->CR_TIPO == "C2" .AND. Alltrim(SCR->CR_NUM) == (cAliasSC7)->C7_NUMSC
						IF Alltrim(SCR->CR_STATUS) == "03"
							nQtdAp++
						EndIf
						SCR->(dbSkip())
						nQtdScr++
					EndDo

					//verifica quantidade de resgistro aprovados
					IF nQtdAp <> nQtdScr 
						If !nQtdAp == 0
							MSGINFO("Pedido já se encontra em processo de aprovação e não pode ser alterado")
							lRet := .F.
						Endif
					EndIF		

				Endif 

				(cAliasSC7)->(dbSkip())
				cNumSc    := (cAliasSC7)->C7_NUMSC

			EndDo

		EndIF

	EndIf

Return(lRet)