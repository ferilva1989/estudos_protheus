#include "protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT910LOK  �Autor  � Fabiano Albuquerque� Data �  Jul/2015   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada para validar na linha os campo obrigat�rio���
���          � no cadastro de Produto.                                    ���
�������������������������������������������������������������������������͹��
���Uso       � BSL                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MT910LOK()

	Local aAreaAnt   := GETAREA()
	Local lRet       := .F.
	Local cCodPrd    := aCols[n,aScan(aHeader,{|x| AllTrim(x[2]) == 'D1_COD'})]
	Local aCampObr   := Strtokarr(GetMV("ES_CAMPOBR"), ",")
	Local cAux       := ""
	Local cCampo     := ""
	Local nAux      := 1

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

	EndIf

	RESTAREA(aAreaAnt)

Return lRet