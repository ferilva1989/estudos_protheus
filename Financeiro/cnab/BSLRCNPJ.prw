#INCLUDE "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³BSLGCOM01  ºAutor  ³ Marcus Ferraz      º Data ³  Abr/2017  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gatilho para retornar o CNPJ e o Nome da empresa           º±±
±±º          ³ que será feito a retenção do imposto                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BSL                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function BSLRCNPJ(cNumNom, cCodRet)

	Local cRet := ""

	If Alltrim(cNumNom) == "N"

		If Alltrim(cCodRet) $ SuperGetMV("ZZ_CODRMAT", ,"5952|1708|3564|0561")

			cRet := Posicione("SM0",1,FWCodEmp()+substr(cFilAnt,1,2)+"001","M0_CGC")

		ElseIf Alltrim(cCodRet) $ SuperGetMV("ZZ_CODRFOR", ,"2631")

			cRet := Posicione("SA2",1,xFilial("SA2")+Substr(M->E2_TITPAI,17,6)+Substr(M->E2_TITPAI,23,2),"A2_CGC")

		ElseIf Alltrim(cCodRet) $ SuperGetMV("ZZ_CODRUNI", ,"2100")

			cRet := Posicione("SM0",1,FWCodEmp()+cFilAnt,"M0_CGC")
		Else
			cRet := ""
		EndIf

	Else
		If Alltrim(cCodRet) $ SuperGetMV("ZZ_CODRMAT", ,"5952|1708|3564|0561")  

			cRet := Posicione("SM0",1,FWCodEmp()+substr(cFilAnt,1,2)+"001","M0_NOMECOM")

		ElseIf Alltrim(cCodRet) $ SuperGetMV("ZZ_CODRFOR", ,"2631")

			cRet := Posicione("SA2",1,xFilial("SA2")+Substr(M->E2_TITPAI,17,6)+Substr(M->E2_TITPAI,23,2),"A2_NOME")

		ElseIf Alltrim(cCodRet) $ SuperGetMV("ZZ_CODRUNI", ,"2100")

			cRet := Posicione("SM0",1,FWCodEmp()+cFilAnt,"M0_NOMECOM")
		Else
			cRet := ""
		EndIf     

	EndIf


Return(cRet)