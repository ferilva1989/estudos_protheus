#Include "Totvs.ch"


/*==========================================================================
Funcao.........:	MT120FIM
Descricao......:	P.E. na Confirmacao de Inclusao / Alteracao / Exclusao
do Pedido de Compra (Gravacao de dados adicionais)
Autor..........:	Edie Carlos 
Data...........:	21/08/2018
Parametros.....:	Nil
Retorno........:	Nil
==========================================================================*/
User Function MT120FIM()

	Local 	nOpcao 		:= PARAMIXB[1]
	Local 	cPedido		:= PARAMIXB[2]
	Local 	nOpcA		:= PARAMIXB[3]
	Local 	cNumSc    	:= ""
	Local 	aAreaC7		:= SC7->(GetArea())
	Local 	aAreaAT		:= GetArea()
	Local 	nTotal   	:= 0
	Local 	lSCR      	:= .F.
	Local 	nValLimt  	:= 0 
	Local 	aDados    	:= {}
	Local 	_nX       	:= 0

	Private cGrupo    	:= ""
	Private cAliasSC7 	:= GetNextAlias() 
	Private _lInclui 	:= nOpcao == 3
	Private _lAltera 	:= nOpcao == 4	
	Private _lExclui 	:= nOpcao == 5
	Private lDvgSCxPC	:= SuperGetMV("ZZ_DVGSCPC", , .F.)


	// Par‚metro para habilitar/desabilitar a customizaÁ„o
	If lDvgSCxPC 

		If (nOpcA <> 0) .And. (_lInclui .Or. _lAltera) .And. !l120Auto

			//?ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
			//? Faz select no pedido com solicitaÁ„o de compras para verificar se o
			// do pedido est· diferente da solicitaÁ„o
			//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
			BeginSql Alias cAliasSC7

				SELECT	DISTINCT C7_NUM,C7_TOTAL,C1_VUNIT,C7_NUMSC,C1_CC,C1_ITEM,C1_QUANT,SC7.C7_QUANT,C1_USER
				FROM %Table:SC7% SC7
				INNER JOIN %Table:SC1% SC1 
				ON C1_FILIAL= %xFilial:SC1% 
				AND C7_NUMSC = C1_NUM 
				AND C7_ITEMSC = C1_ITEM			
				AND C7_PRODUTO = C1_PRODUTO 
				AND SC1.%notdel% 
				//INNER JOIN %Table:DBL% DBL ON DBL_FILIAL= %xFilial:DBL% AND C1_CC = DBL_CC
				WHERE
				SC7.C7_FILIAL = %xFilial:SC7% AND
				SC7.C7_NUM = %Exp:cPedido% AND
				SC7.C7_NUMSC <>'' AND
				SC7.C7_TOTAL <> (SC1.C1_VUNIT * SC7.C7_QUANT) AND 
				SC7.C7_CONAPRO = 'B' AND
				SC7.%notdel% 
				ORDER BY C1_CC            

			EndSql


			//?ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
			//? Verifica se o valor passou 10%          .    ?
			//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
			While (cAliasSC7)->(!EOF())
				nValLimt := (10/100)*(cAliasSC7)->C1_VUNIT * (cAliasSC7)->C7_QUANT + (cAliasSC7)->C1_VUNIT * (cAliasSC7)->C7_QUANT
				IF  (cAliasSC7)->C7_TOTAL > nValLimt  //.OR. nValLimt < (cAliasSC7)->C7_TOTAL
					aAdd(aDados,{(cAliasSC7)->C7_NUMSC,(cAliasSC7)->C7_TOTAL,(cAliasSC7)->C1_CC})  
				EndIf
				(cAliasSC7)->(dbSkip())
			EndDo

			aDados := aSort(aDados, , , {|x,y| x[3] < y[3]})

			//?ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
			//? Verifica se os itens bloqueados fazem parte do mesmo grupo de aprovaÁ„o ?
			//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
			IF !Empty(aDados)
				DBL->(dbSelectArea("DBL"))
				DBL->(dbSetOrder(2))
				DBL->(dbSeek(xFilial("DBL")+aDados[1][3]))
				cGrupo := DBL->DBL_GRUPO
				For _nX := 1 to len(aDados)
					IF DBL->(dbSeek(xFilial("DBL")+aDados[_nX][3]))
						IF cGrupo == DBL->DBL_GRUPO
							nTotal  += aDados[_nX][2]
							cNumSc  := aDados[_nX][1]
							lSCR    := .T.
						Else
							GeraBloq(cNumSc,nTotal)//Gera SCR
							ConOut("GraDBM / Num: " + cNumSc + " / Grupo: ")
							GraDBM(cNumSc,nTotal,cGrupo)	//Gera Tabela DBM com os itens 
							U_XCOMA003(cNumSc,"")//Envia WorkFlow para grupo de aprovaÁ„o
							lSCR    := .T.
							cNumSc  := aDados[_nX][1]
							nTotal  := 0
							cGrupo  := DBL->DBL_GRUPO
						ENDIF  
					EndIf
				Next _nX

				GeraBloq(cNumSc, nTotal)
				//				GraDBM(cNumSc, nTotal, cGrupo)	//Gera Tabela DBM com os itens 

				//Caso gerou SCR GERA TABELA DBM
				If lSCR
					ConOut("GraDBM-SCR / Num: " + cNumSc + " / Grupo: ")
					GraDBM(cNumSc, nTotal, cGrupo)
					//Envia WF 
					U_XCOMA003(cNumSc,"",cPedido)
				EndIf
			Else
				//Envia e-mail para grupo de aprovaÁ„o de compras 
				U_XCOM005(cPedido)	

			ENDIF

		EndIF

		If (nOpcA <> 0) .And. _lExclui
			//VERIFICA SE EXISTE APROVA«?O PARA EXCUIR 
			TCSQLExec(" UPDATE " + RetSQLName("SCR") + " SET D_E_L_E_T_ = '*' WHERE CR_FILIAL = '" + xFilial("SCR") + "' AND CR_NUM = '" + SC7->C7_NUMSC + "' AND CR_TIPO = 'C2' AND D_E_L_E_T_ = ' ' ")
		EndIf

	Else

		//Envia e-mail para grupo de aprovaÁ„o de compras 
		If  (nOpcA <> 0) .And. (_lInclui .Or. _lAltera) .And. !l120Auto
			U_XCOM005(cPedido)
		EndIF

	EndIf

	RestArea(aAreaC7)
	RestArea(aAreaAT)

Return Nil



/*==========================================================================
Funcao.........:	GeraBloq
Descricao......:	Rotina para geraÁ„o bloqueio
Autor..........:	Edie Carlos
Data...........:	07/2018
Parametros.....:	Nil
Retorno........:	Nil
==========================================================================*/
Static Function GeraBloq(cNumSc,nTotal)

	//?ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
	//? Verifica se ja n„o foi criado bloqueio da solictaÁ„o             .    ?
	//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
	If _lAltera 
		SCR->(DBORDERNICKNAME("SCRARPOSC"))
		SCR->(dbGoTop())
		If SCR->(DBSeek(xFilial("SCR") + PADR(cNumSc, TamSX3("CR_NUM")[1]) + "C2" + cGrupo))
			//Verifica se existe aprovaÁ„o para efetuar estorno
			While SCR->(!eof()) .And. Alltrim(SCR->CR_NUM) == cNumSc .And. SCR->CR_TIPO == "C2" .And. SCR->CR_GRUPO == cGrupo
				MaAlcDoc({SCR->CR_NUM, "C2", SCR->CR_VALLIB, , , SCR->CR_GRUPO, , 1, 1, SCR->CR_EMISSAO}, , 3)
				SCR->(dbSkip())
			EndDo
		EndIf
	EndIf

	//?ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
	//? Gera bloqueio na SCR                                            .    ?
	//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
	MaAlcDoc({cNumSc, "C2", nTotal, , , cGrupo, , 1, 1, dDataBase}, , 1)

Return()



/*==========================================================================
Funcao.........:	GraDBM
Descricao......:	Rotina para gravaÁ„o tabela DBM
Autor..........:	Edie Carlos
Data...........:	07/2018
Parametros.....:	Nil
Retorno........:	Nil
==========================================================================*/
Static Function GraDBM(cNum, nTotal, cGrupo)

	Local aAreaSCR  := SCR->(GetArea())


	DBM->(dbSelectArea("DBM"))
	DBM->(dbSetOrder(1))
	If DBM->(dbSeek(xFilial("DBM") + "C2" + PADR(cNum, TamSX3("DBM_NUM")[1]) + PADR(cGrupo, TamSX3("DBM_GRUPO")[1])))
		While !DBM->(EOF()) .And. DBM->DBM_FILIAL == xFilial("DBM") .And. DBM->DBM_NUM == PADR(cNum, TamSX3("DBM_NUM")[1])
			RecLock("DBM", .F.)
			DBM->(dbDelete())
			DBM->(MsUnLock())
			DBM->(dbSkip())
		EndDo
	ENDIF

	//	TCSQLExec(" UPDATE " + RetSQLName("DBM") + " SET D_E_L_E_T_ = '*' WHERE DBM_FILIAL = '" +xFilial("DBM")+ "' AND DBM_NUM = '"+cNum+"' AND DBM_TIPO='C2' AND DBM_GRUPO='"+cGrupo+"' AND D_E_L_E_T_ = ' ' ")

	//VERIFICA QUANTIDADE DE ITENS 
	(cAliasSC7)->(dbGoTop())
	While !(cAliasSC7)->(EOF())
		SCR->(DBSelectArea("SCR"))
		SCR->(DBOrderNickName("SCRARPOSC"))	//CR_FILIAL+CR_NUM+CR_TIPO+CR_GRUPO
		IF SCR->(DBSeek(xFilial("SCR") + PADR(cNum, TamSX3("CR_NUM")[1]) + "C2" + PADR(cGrupo, TamSX3("CR_GRUPO")[1])))
			While !SCR->(EOF()) .And. SCR->CR_TIPO == "C2" .And. SCR->CR_NUM == PADR(cNum, TamSX3("CR_NUM")[1]) .And. SCR->CR_GRUPO == PADR(cGrupo, TamSX3("CR_GRUPO")[1])
				RecLock("DBM", .T.)
				DBM->DBM_FILIAL := xFilial("DBM")
				DBM->DBM_TIPO   := "C2"
				DBM->DBM_NUM    := SCR->CR_NUM
				DBM->DBM_ITEM   := (cAliasSC7)->C1_ITEM
				DBM->DBM_GRUPO  := SCR->CR_GRUPO
				DBM->DBM_ITGRP  := SCR->CR_ITGRP
				DBM->DBM_USER   := SCR->CR_USER
				DBM->DBM_APROV  := "1"
				DBM->DBM_USAPRO := SCR->CR_APROV
				DBM->DBM_VALOR  := (cAliasSC7)->C7_TOTAL	//(cAliasSC7)->C1_QUANT * (cAliasSC7)->C1_VUNIT	//SCR->CR_TOTAL
				DBM->(MSUnLock())
				SCR->(dbSkip())
			EndDo
		EndIf
		(cAliasSC7)->(dbSkip())
	EndDo

	RestArea(aAreaSCR)

Return()