#INCLUDE "rwmake.ch"                                     
#INCLUDE "protheus.ch"
#INCLUDE "totvs.ch"
#INCLUDE "Topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT103IPC  �Autor  Leandro Godoy        � Data �  14/08/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �    Ponto de entrada para exportar descri��o do pedido      ���
���          �     de compra para pre-nota ou doc. entrada                ���
�������������������������������������������������������������������������͹��
���Uso       � Brazil Senior Living                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MT103IPC
	Local nItem := PARAMIXB[1]
	Local nPosCod := AScan(aHeader,{|x|Alltrim(x[2])=="D1_COD"})
	Local nPosDes := AScan(aHeader,{|x|Alltrim(x[2])=="D1_XDESC"})

	If nPosCod > 0 .And. nItem > 0 .And. nPosDes > 0
		aCols[nItem,nPosDes] := SC7->C7_DESCRI
	Endif

Return



