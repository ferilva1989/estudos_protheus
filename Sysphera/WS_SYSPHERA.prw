#include 'protheus.ch'
#include 'apwebsrv.ch'
#Include "TopConn.ch"
#Include "aarray.ch"
#Include "json.ch"

#Define STR_PULA Chr(13) + Chr(10)

WsService WS_SYSPHERA Description "Serviço para extração de dados para o SYSPHERA"
	WsData cString	 As String 	
	WsData cCodFilial	 As String
	WsData cCodMoeda	 As String 
	WsData cDataInicio	 As String 
	WsData cDataFim	 As String 
	WsData cUserKey	 As String 
	WsData cTime	 As String 
	WsData cRecnoInicial	 As String
	WsData cRecnoFinal	 As String
	WsData cRecnoIntervalo	 As String
	WsMethod GetPlanoDeContas Description "Método que retorna o plano de contas"
	WsMethod GetCentroDeCustos Description "Método que retorna os centro de custos"
	WsMethod GetGrupoEmpresa Description "Método que retorna a lista de grupo de empresas"
	WsMethod GetFiliais Description "Método que retorna a lista de filiais"
	WsMethod GetIntervaloRazao Description "Método que retorna os intervalos do razão contábil" 
	WsMethod GetRazao Description "Método que retorna o razão contábil"
	WsMethod GetBalancete Description "Método que retorna o balancete contábil"
EndWsService

WsMethod GetPlanoDeContas WsReceive cUserKey, cTime WsSend cString WsService WS_SYSPHERA

	Local cQuery := ""
	Local aRet := {} 
	Local cDados := ""

	Local bOk := fValid(cUserKey, cTime)

	IF bOk
		cQuery := " SELECT " + STR_PULA
		cQuery += "   CT1_FILIAL,CT1_CONTA,CT1_DESC01,CT1_CLASSE, " + STR_PULA
		cQuery += "   CT1_NORMAL,CT1_RES,CT1_BLOQ,CT1_CTASUP,R_E_C_N_O_ " + STR_PULA
		cQuery += " FROM " + STR_PULA
		cQuery += "   "+RetSQLName("CT1")+" CT1 " + STR_PULA
		cQuery += " WHERE " + STR_PULA
		cQuery += "   CT1.D_E_L_E_T_ = '' " + STR_PULA

		aRet := fQryAr(cQuery)
		cDados := ToJson(aRet)
	ELSE
		cDados := "Erro" 
	ENDIF

	::cString := cDados 

Return .T.

WsMethod GetCentroDeCustos WsReceive cUserKey, cTime WsSend cString WsService WS_SYSPHERA

	Local cQuery := ""
	Local aRet := {} 
	Local cDados := ""

	Local bOk := fValid(cUserKey, cTime)
	IF bOk
		cQuery := " SELECT " + STR_PULA
		cQuery += "   CTT_FILIAL,CTT_CUSTO,CTT_CLASSE,CTT_NORMAL,CTT_DESC01,CTT_BLOQ,R_E_C_N_O_ " + STR_PULA
		cQuery += " FROM " + STR_PULA
		cQuery += "   "+RetSQLName("CTT")+" CTT " + STR_PULA
		cQuery += " WHERE " + STR_PULA
		cQuery += "   CTT.D_E_L_E_T_ = '' " + STR_PULA

		aRet := fQryAr(cQuery)
		cDados := ToJson(aRet)
	ELSE
		cDados := "Erro" 
	ENDIF

	::cString := cDados 

Return .T.

WsMethod GetGrupoEmpresa WsReceive cUserKey, cTime WsSend cString WsService WS_SYSPHERA

	Local aRet := {}, aLinha := {}
	Local cDados := ""
	Local nGrp := 1

	Local bOk := fValid(cUserKey, cTime)
	IF bOk
		aUnitNeg:= FWAllGrpCompany()

		For nGrp := 1 To Len(aUnitNeg)
			cUnidNeg := aUnitNeg[nGrp]
			cUnidNegName := FWGrpName(cUnidNeg)

			aLinha := {cUnidNeg, cUnidNegName}

			AAdd(aRet, aLinha)

		Next

		cDados := ToJson({{{"COD", "C", "", ""}, {"DESC", "C", "", ""}}, aRet})
	ELSE
		cDados := "Erro" 
	ENDIF

	::cString := cDados 

Return .T.

WsMethod GetFiliais WsReceive cUserKey, cTime WsSend cString WsService WS_SYSPHERA

	Local aRet    := {} 
	Local cDados := ""

	Local bOk := fValid(cUserKey, cTime)
	IF bOk
		DbSelectArea("SM4")
		aRet := FWEmpLoad(.T.)
		cDados := ToJson(aRet)
	ELSE
		cDados := "Erro" 
	ENDIF

	::cString := cDados 

Return .T.

WsMethod GetIntervaloRazao WsReceive cUserKey, cTime, cCodFilial, cCodMoeda, cDataInicio, cDataFim, cRecnoIntervalo WsSend cString WsService WS_SYSPHERA

	Local cQuery := ""
	Local aRet := {} 
	Local aRetDados := {} 
	Local aRetNomes := {} 
	Local cDados := ""
	Local nPos := 0
	Local nPosAcum := Int(Val(cRecnoIntervalo))
	Local bFinalizou := .F.

	Local bOk := fValid(cUserKey, cTime)
	IF bOk
		cQuery := " SELECT CT2.R_E_C_N_O_ " + STR_PULA
		cQuery += " FROM "+RetSQLName("CT2")+" AS CT2" + STR_PULA
		cQuery += " WHERE CT2.CT2_FILIAL = '"+ cCodFilial +"' AND CT2.CT2_DATA >= '"+cDataInicio+"' AND CT2.CT2_DATA <= '"+cDataFim+"' AND CT2.CT2_TPSALD = '1' AND " + STR_PULA
		cQuery += " CT2.CT2_MOEDLC = '"+cCodMoeda+"' AND (CT2.CT2_DC = '1' OR CT2.CT2_DC = '2' OR CT2.CT2_DC = '3') AND CT2.CT2_VALOR <> 0 AND CT2.D_E_L_E_T_ = ' ' " + STR_PULA

		aRet := fQryAr(cQuery)

		aRetNomes := aRet[1]
		aRetDados := aRet[2]

		aRet := {}

		If Len(aRetDados) == 0
			cDados := "EMPTY"
		ElseIf Empty(aRetDados)
			Aadd(aRet,"0")
			cDados := "EMPTY"
		Else
			//Adiciona sempre o primeiro registro, como início dos intervalos
			Aadd(aRet,aRetDados[1])

			WHILE nPos < LEN(aRetDados)
				nPos++

				If nPos == nPosAcum
					If (nPos+1) <= Len(aRetDados)
						//Adiciona o próximo registro
						Aadd(aRet,aRetDados[nPos+1])
					Else
						//Adiciona o registro atual + 1
						Aadd(aRet,{aRetDados[nPos][1]+1})
					EndIf
					nPosAcum := nPosAcum + Int(Val(cRecnoIntervalo))
					bFinalizou := .T.
				Else
					bFinalizou := .F.
				EndIf

			ENDDO

			//Se o ultimo intervalo ficou pela metade, adicionamos o ultimo registro + 1
			If bFinalizou == .F.
				Aadd(aRet,{aRetDados[nPos][1]+1})
			EndIf

			cDados := ToJson({aRetNomes, aRet})
		EndIf
	ELSE
		cDados := "Erro" 
	ENDIF

	::cString := cDados 

Return .T.

WsMethod GetRazao WsReceive cUserKey, cTime, cCodFilial, cCodMoeda, cDataInicio, cDataFim, cRecnoInicial, cRecnoFinal WsSend cString WsService WS_SYSPHERA

	Local cQuery := ""
	Local aRet := {} 
	Local cDados := ""

	Local bOk := fValid(cUserKey, cTime)
	IF bOk
		cQuery := " SELECT CT2.CT2_FILIAL AS FILIAL, CT1.CT1_CONTA AS CONTA, COALESCE (CT2.CT2_CCD, ' ') AS CUSTO, COALESCE (CT2.CT2_ITEMD, ' ') AS ITEM, COALESCE (CT2.CT2_CLVLDB, ' ') AS CLVL, COALESCE (CT2.CT2_DATA, " + STR_PULA
		cQuery += " ' ') AS DDATA, COALESCE (CT2.CT2_TPSALD, ' ') AS TPSALD, COALESCE (CT2.CT2_DC, ' ') AS DC, COALESCE (CT2.CT2_LOTE, ' ') AS LOTE, COALESCE (CT2.CT2_SBLOTE, ' ') AS SUBLOTE, " + STR_PULA
		cQuery += " COALESCE (CT2.CT2_DOC, ' ') AS DOC, COALESCE (CT2.CT2_LINHA, ' ') AS LINHA, COALESCE (CT2.CT2_CREDIT, ' ') AS XPARTIDA, COALESCE (CT2.CT2_HIST, ' ') AS HIST, COALESCE (CT2.CT2_SEQHIS, ' ') " + STR_PULA
		cQuery += " AS SEQHIS, COALESCE (CT2.CT2_SEQLAN, ' ') AS SEQLAN, '1 - CREDITO' AS TIPOLAN, COALESCE (CT2.CT2_VALOR, 0) AS VALOR, COALESCE (CT2.CT2_EMPORI, ' ') AS EMPORI, COALESCE (CT2.CT2_FILORI, ' ') AS FILORI " + STR_PULA
		cQuery += " FROM "+RetSQLName("CT1")+" CT1 INNER JOIN "+RetSQLName("CT2")+" AS CT2" + STR_PULA
		cQuery += " ON CT2.CT2_FILIAL = '"+ cCodFilial +"' AND CT2.CT2_DEBITO = CT1.CT1_CONTA AND CT2.CT2_DATA >= '"+cDataInicio+"' AND CT2.CT2_DATA <= '"+cDataFim+"' AND CT2.CT2_TPSALD = '1' AND " + STR_PULA
		cQuery += " CT2.CT2_MOEDLC = '"+cCodMoeda+"' AND (CT2.CT2_DC = '1' OR CT2.CT2_DC = '3') AND CT2.CT2_VALOR <> 0 AND CT2.D_E_L_E_T_ = ' ' " + STR_PULA
		cQuery += " WHERE (CT1.CT1_FILIAL = '  ') AND (CT1.CT1_CLASSE = '2') AND (CT1.D_E_L_E_T_ = ' ') AND CT2.R_E_C_N_O_ >= "+cRecnoInicial+" AND CT2.R_E_C_N_O_ < "+cRecnoFinal+" " + STR_PULA
		cQuery += " UNION " + STR_PULA
		cQuery += " SELECT CT2.CT2_FILIAL AS FILIAL, CT1.CT1_CONTA AS CONTA, COALESCE (CT2.CT2_CCC, ' ') AS CUSTO, COALESCE (CT2.CT2_ITEMC, ' ') AS ITEM, COALESCE (CT2.CT2_CLVLCR, ' ') AS CLVL, COALESCE (CT2.CT2_DATA, " + STR_PULA
		cQuery += " ' ') AS DDATA, COALESCE (CT2.CT2_TPSALD, ' ') AS TPSALD, COALESCE (CT2.CT2_DC, ' ') AS DC, COALESCE (CT2.CT2_LOTE, ' ') AS LOTE, COALESCE (CT2.CT2_SBLOTE, ' ') AS SUBLOTE, " + STR_PULA
		cQuery += " COALESCE (CT2.CT2_DOC, ' ') AS DOC, COALESCE (CT2.CT2_LINHA, ' ') AS LINHA, COALESCE (CT2.CT2_DEBITO, ' ') AS XPARTIDA, COALESCE (CT2.CT2_HIST, ' ') AS HIST, COALESCE (CT2.CT2_SEQHIS, ' ') " + STR_PULA
		cQuery += " AS SEQHIS, COALESCE (CT2.CT2_SEQLAN, ' ') AS SEQLAN, '2 - DEBITO' AS TIPOLAN, COALESCE (CT2.CT2_VALOR, 0) AS VALOR, COALESCE (CT2.CT2_EMPORI, ' ') AS EMPORI, COALESCE (CT2.CT2_FILORI, ' ') AS FILORI " + STR_PULA
		cQuery += " FROM "+RetSQLName("CT1")+" AS CT1 INNER JOIN "+RetSQLName("CT2")+" AS CT2 " + STR_PULA
		cQuery += " ON CT2.CT2_FILIAL = '"+cCodFilial+"' AND CT2.CT2_CREDIT = CT1.CT1_CONTA AND CT2.CT2_DATA >= '"+cDataInicio+"' AND CT2.CT2_DATA <= '"+cDataFim+"' AND CT2.CT2_TPSALD = '1' AND " + STR_PULA
		cQuery += " CT2.CT2_MOEDLC = '"+cCodMoeda+"' AND (CT2.CT2_DC = '2' OR CT2.CT2_DC = '3') AND CT2.CT2_VALOR <> 0 AND CT2.D_E_L_E_T_ = ' ' " + STR_PULA
		cQuery += " WHERE (CT1.CT1_FILIAL = '  ') AND (CT1.CT1_CLASSE = '2') AND (CT1.D_E_L_E_T_ = ' ') AND CT2.R_E_C_N_O_ >= "+cRecnoInicial+" AND CT2.R_E_C_N_O_ < "+cRecnoFinal+" " + STR_PULA
		cQuery += " ORDER BY CONTA, DDATA " + STR_PULA

		aRet := fQryAr(cQuery)
		cDados := ToJson(aRet)
	ELSE
		cDados := "Erro" 
	ENDIF

	::cString := cDados 

Return .T.

WsMethod GetBalancete WsReceive cUserKey, cTime, cCodFilial, cCodMoeda, cDataInicio, cDataFim WsSend cString WsService WS_SYSPHERA

	Local cQuery := ""
	Local aRet := {} 
	Local cDados := ""

	Local bOk := fValid(cUserKey, cTime)
	IF bOk
		cQuery := " SELECT CONTA, NORMAL, CTARES, SUPERIOR, TIPOCONTA, GRUPO, NATCTA, CT1DTEXSF, DESCCTA, SALDOANTDB, SALDOANTCR, SALDODEB, SALDOCRD " + STR_PULA
		cQuery += " FROM ( " + STR_PULA
		cQuery += " SELECT CT1_CONTA AS CONTA, CT1_NORMAL AS NORMAL, CT1_RES AS CTARES, CT1_CTASUP AS SUPERIOR, CT1_CLASSE AS TIPOCONTA, CT1_GRUPO AS GRUPO, CT1_NATCTA AS NATCTA, CT1_DTEXSF AS CT1DTEXSF, CT1_DESC01 AS DESCCTA, " + STR_PULA
		cQuery += " (SELECT SUM(CQ1_DEBITO) AS SALDOANTDB FROM "+RetSQLName("CQ1")+" AS CQ1 WHERE (ARQ.CT1_CONTA = CQ1_CONTA) AND (CQ1_MOEDA = '"+cCodMoeda+"') AND (CQ1_TPSALD = '1') AND (CQ1_DATA < '"+cDataInicio+"') AND (D_E_L_E_T_ = ' ') AND (CQ1_FILIAL = '"+cCodFilial+"')) AS SALDOANTDB, " + STR_PULA
		cQuery += " (SELECT SUM(CQ1_CREDIT) AS SALDOANTCR FROM "+RetSQLName("CQ1")+" AS CQ1 WHERE (ARQ.CT1_CONTA = CQ1_CONTA) AND (CQ1_MOEDA = '"+cCodMoeda+"') AND (CQ1_TPSALD = '1') AND (CQ1_DATA < '"+cDataInicio+"') AND (D_E_L_E_T_ = ' ') AND (CQ1_FILIAL = '"+cCodFilial+"')) AS SALDOANTCR, " + STR_PULA
		cQuery += " (SELECT SUM(CQ1_DEBITO) AS SALDODEB FROM "+RetSQLName("CQ1")+" AS CQ1 WHERE (ARQ.CT1_CONTA = CQ1_CONTA) AND (CQ1_MOEDA = '"+cCodMoeda+"') AND (CQ1_TPSALD = '1') AND (CQ1_DATA >= '"+cDataInicio+"') AND (CQ1_DATA <= '"+cDataFim+"') AND (D_E_L_E_T_ = ' ') AND (CQ1_FILIAL = '"+cCodFilial+"')) AS SALDODEB, " + STR_PULA
		cQuery += " (SELECT SUM(CQ1_CREDIT) AS SALDOCRD FROM "+RetSQLName("CQ1")+" AS CQ1 WHERE (ARQ.CT1_CONTA = CQ1_CONTA) AND (CQ1_MOEDA = '"+cCodMoeda+"') AND (CQ1_TPSALD = '1') AND (CQ1_DATA >= '"+cDataInicio+"') AND (CQ1_DATA <= '"+cDataFim+"') AND (D_E_L_E_T_ = ' ') AND (CQ1_FILIAL = '"+cCodFilial+"')) AS SALDOCRD " + STR_PULA
		cQuery += " FROM "+RetSQLName("CT1")+" AS ARQ WHERE (CT1_FILIAL = '  ') AND (CT1_CLASSE = '2') AND (D_E_L_E_T_ = ' ')) AS SALDOARQ " + STR_PULA

		aRet := fQryAr(cQuery)
		cDados := ToJson(aRet)
	ELSE
		cDados := "Erro" 
	ENDIF

	::cString := cDados 

Return .T.

Static Function fQryAr(cQuery) 

	Local aRet    := {} 
	Local aRet1   := {} 
	Local aRetNomes
	Local nRegAtu := 0 
	Local x       := 0 

	cQuery := ChangeQuery(cQuery) 
	TCQUERY cQuery NEW ALIAS "_TRB" 

	dbSelectArea("_TRB") 
	aRet1   := Array(Fcount()) 
	nRegAtu := 1 

	While !Eof() 

		For x:=1 To Fcount() 
			aRet1[x] := FieldGet(x) 
		Next 
		Aadd(aRet,aclone(aRet1)) 

		dbSkip() 
		nRegAtu += 1 
	Enddo 

	aRetNomes := DBStruct()

	dbSelectArea("_TRB") 
	_TRB->(DbCloseArea()) 

Return({aRetNomes, aRet}) 

Static Function fValid(cUserKey, cTime) 
	Local dData:= Date()
	Local sOut := ""  
	Local bOk := .F.
	Local sStr := "Sysphera@Protheus#Y" 
	sStr += cValToChar(Year(dData)) 
	sStr += "#M" 
	sStr += cValToChar(Month(dData)) 
	sStr += "#D" 
	sStr += cValToChar(Day(dData)) 
	sStr += cTime
	sOut := SHA1( sStr ) 

	IF sOut == LOWER(cUserKey)
		bOk := .T.
	ENDIF
Return(bOk)