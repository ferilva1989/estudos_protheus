#include "protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT100LOK  �Autor  � Fabiano Albuquerque� Data �  Jul/2016   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada para validar na linha os campo obrigat�rio���
���          � no cadastro de Produto.                                    ���
�������������������������������������������������������������������������͹��
���Uso       � BSL                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MT100LOK()

	LOCAL aAreaAnt   := GetArea()
	Local lRet       := .T.
	Local cCodPrd    := aCols[n,aScan(aHeader,{|x| AllTrim(x[2]) == 'D1_COD'})]
	Local aCampObr   := Strtokarr(GetMV("ES_CAMPOBR"), ",")
	Local cAux       := ""
	Local cCampo     := ""
	Local nAux       := 1
	Local nPosCC	 := aScan(aHeader,{|x|Alltrim(x[2])=="D1_CC"})
	Local nPosRat	 := aScan(aHeader,{|x|Alltrim(x[2])=="D1_RATEIO"})

	If !aCols[n][Len(aCols[n])] // Se n�o estiver deletado

		If !Empty(cCodPrd) .And. Len(aCampObr) >= 1

			DbSelectArea("SB1")
			SB1->(DbSetOrder(1))
			SB1->(DbSeek(xFilial("SB1") + cCodPrd))

			DbSelectArea("SX3")
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
				Aviso("Campos Obrigat�rios","Os seguintes campos n�o foram preenchido no cadastro de produto: " + SubStr(cCampo,1,Len(cCampo)-5) +".",{"OK"})
			EndIF

		EndIF

		//Efetuado altera��o conforme solicita��o da Contabilidade - Marcus Ferraz - 24/04/2017
		If nPosCC > 0 .And. nPosRat > 0 .And. lRet
			If Empty(aCols[n][nPosCC]) .And. aCols[n][nPosRat] == "2"
				lRet := .F.
			ElseIf Empty(aCols[n][nPosCC]) .And. aCols[n][nPosRat] == "1" .And. Len(aBackColsSDE) == 0
				lRet := .F.
			EndIf

			If !lRet
				Aviso("Centro de Custo Obrigat�rio","O Centro de Custo n�o foi informado no Item ou no Rateio, verifique!",{"OK"})
			EndIf    
		EndIf

	EndIf	
	RestArea(aAreaAnt)

Return lRet