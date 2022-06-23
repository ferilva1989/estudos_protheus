#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT110LOK  ºAutor  ³ Fabiano Albuquerqueº Data ³  Jul/2015   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada para validar na linha os campo obrigatórioº±±
±±º          ³ no cadastro de Produto.                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BSL                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT110LOK()

	Local aAreaAnt   := GetArea()
	Local lRet       := .T.
	Local cCodPrd    := aCols[n,aScan(aHeader,{|x| AllTrim(x[2]) == 'C1_PRODUTO'})]
	Local aCampObr   := Strtokarr(GetMV("ES_CAMPOBR"), ",")
	Local cAux       := ""
	Local cCampo     := ""
	Local nAux       := 1
	Local nPosCC	 := aScan(aHeader,{|x|Alltrim(x[2])=="C1_CC"})
	Local nPosRat	 := aScan(aHeader,{|x|Alltrim(x[2])=="C1_RATEIO"})
	Local nPCCRat	 := aScan(aCPHSCX,{|x|Alltrim(x[2])=="CX_CC"})

	// Djalma Borges - 17/02/2016
	//Local nPosCatSC  := aScan(aHeader,{|x| AllTrim(x[2]) == 'C1_ZCATSC'})
	Local nPosString := aScan(aHeader,{|x| AllTrim(x[2]) == 'C1_ZSCATSC'})
	Local nCount := 0
	//Edie Carlos - AtosData
	Local lVldCC     := SUPERGETMV("ES_VLDCCSC", .T., .T.)
	Local cGrupo     := ""

	If !aCols[n][Len(aCols[n])] // Se não estiver deletado
		If !Empty(cCodPrd) .And. Len(aCampObr) >= 1

			SB1->(DbSetOrder(1))
			SB1->(DbSeek(xFilial("SB1") + cCodPrd))

			SX3->(DbSetOrder(2))

			For nAux:=1 To Len(aCampObr)
				cAux:='SB1->' + aCampObr[nAux]

				IF Empty(&cAux)
					SX3->(DbSeek(aCampObr[nAux]))
					cCampo += X3Titulo(aCampObr[nAux]) + ", "
				EndIF
			Next

			IF !Empty (cCampo)
				lRet := .F.
				Aviso("Campos Obrigatórios","Os seguintes campos não foram preenchido no cadastro de produto: " + SubStr(cCampo,1,Len(cCampo)-5) +".",{"OK"})
			EndIF

		EndIF

		//Valida centro de custo rotina de aprovação - Edie Carlos AtosData
		IF lVldCC
			//Verifica se o centro de custo esta amarrado em algum grupo de aprovação
			dbSelectArea("DBL")
			DbOrderNickName("XAPROVACAO")

			IF DBL->(dbSeek(xFilial("DBL")+aCols[n][nPosCC]))
				cGrupo := DBL->DBL_GRUPO
			EndIF

			//Verifica se o grupo esta configurado para aprovação de solictação de compras

			dbSelectArea("SAL")
			dbSetOrder(1)

			IF !Empty(cGrupo)
				IF SAL->(DBSeek(xFilial("SAL") +cGrupo))
					IF SAL->AL_DOCSC
						lRet := .T.
					ENDIF
				ENDIF
			ELSE
				MSGINFO("Centro de custo informado nao esta cadastrado no controle de aprovação! Entre em contato com administrador do sistema")
				lRet := .F.
			EndIF

		ENDIF



		If nPosCC > 0 .And. nPosRat > 0 .And. lRet
			If Empty(aCols[n][nPosCC]) .And. aCols[n][nPosRat] == "2"
				lRet := .F.
			ElseIf Empty(aCols[n][nPosCC]) .And. aCols[n][nPosRat] == "1" .And. nPCCRat > 0 .And. Len(ACPISCX) == 0
				lRet := .F.
			EndIf

			If !lRet
				Aviso("Centro de Custo Obrigatório","O Centro de Custo não foi informado no Item ou no Rateio, verifique!",{"OK"})
			EndIf    
		EndIf

	EndIf

	RestArea(aAreaAnt)


	// Forçar a mesma categoria para todos os itens da SC - Djalma Borges 17/02/2016
	//If aCols[n][nPosCatSC] <> aCols[1][nPosCatSC]
	//MsgAlert("Todos os itens desta SC irão seguir a mesma Categoria do primeiro item. Se deseja alterar a Categoria para todos os itens, altere a Categoria do primeiro item.")
	//EndIf	

	/*If aCols[n][nPosCatSC] = "N"
	aCols[n][nPosString] := "NORMAL"
	ElseIf aCols[n][nPosCatSC] = "U" 	
	aCols[n][nPosString] := "URGENTE/EMERGENTE"
	EndIf

	If n > 1
	aCols[n][nPosCatSC] := aCols[1][nPosCatSC]
	EndIf
	If n == 1
	For nCount := 1 to Len(aCols)
	aCols[nCount][nPosCatSC] := aCols[1][nPosCatSC]
	If aCols[nCount][nPosCatSC] = "N"
	aCols[nCount][nPosString] := "NORMAL"
	ElseIf aCols[nCount][nPosCatSC] = "U" 	
	aCols[nCount][nPosString] := "URGENTE/EMERGENTE"
	EndIf						
	Next
	EndIf*/		

	GETDREFRESH()

Return lRet