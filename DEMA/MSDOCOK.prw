#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MSDOCOK  � Autor � Raphael - Dema     � Data �  06/08/17   ���
�������������������������������������������������������������������������͹��
���Descricao � PE Apos a gravacao do Banco de Conhecimento.               ���
���          � Sera Usado para replicar oconhecimento para outras Tabelas ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function MSDOCOK

	Local aArea 	:= GetArea()
	Local aAreaE2 	:= SE2->(GetArea())
	Local cTable 	:= PARAMIXB[1]
	Local cID		:= AC9->AC9_CODOBJ

	If cTable == "SF1" // Se for Nota de Entrada, replica o Documento no SE2 (se Houver)
		dbSelectArea("SE2")
		dbSetOrder(6) // E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO
		dbSeek(SF1->(F1_FILIAL+F1_FORNECE+F1_LOJA+F1_SERIE+F1_DOC))
		While !Eof() .And. SE2->(E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM) == SF1->(F1_FILIAL+F1_FORNECE+F1_LOJA+F1_SERIE+F1_DOC)
			dbSelectArea("AC9")
			dbSetOrder(1) // AC9_FILIAL+AC9_CODOBJ+AC9_ENTIDA+AC9_FILENT+AC9_CODENT
			If !dbSeek(xFilial("AC9")+cID+"SE2"+SE2->(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA))
				RecLock("AC9",.T.)
				AC9->AC9_FILIAL 	:= xFilial("AC9")
				AC9->AC9_CODOBJ	:= cID
				AC9->AC9_ENTIDA	:= "SE2"
				AC9->AC9_FILENT	:= SE2->E2_FILIAL
				AC9->AC9_CODENT	:= SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)
				MsUnlock()
			EndIf

			dbSelectArea("SE2")
			dbSkip()
		EndDo
	EndIf

	RestArea(aAreaE2)
	RestArea(aArea)

Return()