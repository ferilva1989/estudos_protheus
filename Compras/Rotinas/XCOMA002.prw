#include 'protheus.ch'
#include 'parmtype.ch'


/*==========================================================================
Funcao.........:	XCOMA002
Descricao......:	Rotina para validação de aprovação de pedido de compras
Autor..........:	Edie Carlos
Data...........:	07/2018
Parametros.....:	Nil
Retorno........:	Nil
==========================================================================*/

user function XCOMA002(cPed)

	Local 	lRet        := .T.
	Local 	cFunction	:= "XCOMA002"
	Local 	nRecCount   := 0
	Local 	cDoc		:= PadR(AllTrim(cPed), TamSX3("C7_NUM")[1])

	Private cAliasSC7 	:= GetNextAlias() 
	Private cLogArq		:= cFunction
	Private cLogDir		:= SuperGetMV("VT_LOGDIR", , "\log\")


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Faz select no pedido para verificar se nao existe bloqueio por alteração
	// de valor
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	BeginSql Alias cAliasSC7

		SELECT DISTINCT C7_NUMSC
		FROM %Table:SC7% SC7
		INNER JOIN %Table:SCR% SCR 
		ON CR_FILIAL = %xFilial:SCR% 
		AND CR_NUM = C7_NUMSC
		AND CR_TIPO IN ('SC', 'C2')
		AND SCR.D_E_L_E_T_ = ' ' 
		WHERE C7_FILIAL = %xFilial:SC7%  
		AND C7_NUM = %Exp:cDoc%
		AND CR_STATUS <> '03'
		AND SC7.D_E_L_E_T_ = ' '

	EndSql

	MemoWrite(cLogDir + cLogArq + ".sql", GetLastQuery()[2])

	Count To nRecCount

	If nRecCount > 0
		lRet := .F.
	EndIF

	If Select(cAliasSC7) > 0
		(cAliasSC7)->(DBCloseArea())
	EndIf

return(lRet)