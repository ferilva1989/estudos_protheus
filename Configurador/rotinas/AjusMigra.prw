#Include "Protheus.Ch"
#Include "TopConn.Ch"

#Define _enter_ Chr(13)+Chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AjusMigra ºAutor  ³Aderson Sousa       º Data ³  24/06/2015 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ajusta os itens para migração							  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BSL - Virada Tst para Prd						          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function AjusMigra(nOper)
	Private nHandle :=  FCreate("\Log_Ajuste_"+DtoS(Date())+".log")

	default nOper := 1

	RpcSetType(3)
	RpcSetEnv("01", "01001",,,'CFG',, {"SIX","SX1","SX2","SX3","SX5","SX6","SX7"})  
	FWrite(nHandle, "Empresa 01")
	MsgRun("Empresa 01","Aguarde...",{|| fProc01(nOper) })
	RpcClearEnv()

	FClose(nHandle)

	MsgInfo("Fim da rotina")

Return(.t.)

Static Function fProc01(nOper)
	Local aCampos 	:= {}
	Local nX		:= 0

	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±± AJUSTA DO SIX - INDICES  ±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	*/         

	If nOper == 0 .Or. nOper == 9

		SIX->(DbSetOrder(1))
		SIX->(DbGoTop())

		While SIX->(!EOF())
			FWrite(nHandle, _enter_+AllTrim(Str(SIX->(Recno())))+" - Atualizando do SIX: "+AllTrim(SIX->(INDICE+ORDEM)))
			TcInternal( 60, RetSqlName( SIX->INDICE ) + '|' + RetSqlName( SIX->INDICE ) + SIX->ORDEM ) // Exclui sem precisar baixar o TOP
			SIX->(DbSkip())
		EndDo
	EndIf

	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±± AJUSTA DO SX3 - CAMPOS   ±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	*/

	If nOper == 1 .Or. nOper == 9

		SX2->(DbGoTop())         

		//Atualiza os campos das Tabelas
		While SX2->(!EOF())
			FWrite(nHandle, _enter_+AllTrim(Str(SX2->(Recno())))+" - Atualizando do SX2: "+AllTrim(SX2->(X2_CHAVE)))
			X31UpdTable(SX2->(X2_CHAVE))
			SX2->(DbSkip()) 
		EndDo

	EndIf

Return(.t.)