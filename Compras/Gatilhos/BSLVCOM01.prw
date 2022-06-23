/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �BSLGCOM01  �Autor  � Marcus Ferraz      � Data �  Mar/2016   ���
�������������������������������������������������������������������������͹��
���Desc.     � Fun��o para validar se a quantidade informada na           ���
���          � pr�-nota e nota � maior que a quantidade do pedido.        ���
�������������������������������������������������������������������������͹��
���Uso       � BSL                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function BSLVCOM01(nItem)

	Local nPosQtd 	:= AScan(aHeader,{|x|Alltrim(x[2])=="D1_QUANT"})
	Local nPosPed 	:= AScan(aHeader,{|x|Alltrim(x[2])=="D1_PEDIDO"})
	Local nPosItm 	:= AScan(aHeader,{|x|Alltrim(x[2])=="D1_ITEMPC"})
	Local nQtdPed 	:= 0
	Local lRet		:= .T.

	//Soma a quantidade pendente no pedido.
	nQtdPed := GetAdvFVal("SC7","C7_QUANT",cFilant+aCols[nItem,nPosPed]+aCols[nItem,nPosItm],1)
	nQtdPed -= GetAdvFVal("SC7","C7_QUJE",cFilant+aCols[nItem,nPosPed]+aCols[nItem,nPosItm],1)

	//S� executa a valida��o se o campo Pedido estiver preenchido.
	If !Empty(Alltrim(aCols[nItem,nPosPed]))
		If nQtdPed < aCols[nItem,nPosQtd]
			lRet := .F.
			Aviso("Nf x Pedido","Quantidade informada � maior que o saldo do pedido",{"OK"})
		Endif
	EndIf

Return(lRet)
