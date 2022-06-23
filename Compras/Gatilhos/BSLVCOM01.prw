/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBSLGCOM01  บAutor  ณ Marcus Ferraz      บ Data ณ  Mar/2016   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo para validar se a quantidade informada na           บฑฑ
ฑฑบ          ณ pr้-nota e nota ้ maior que a quantidade do pedido.        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BSL                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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

	//S๓ executa a valida็ใo se o campo Pedido estiver preenchido.
	If !Empty(Alltrim(aCols[nItem,nPosPed]))
		If nQtdPed < aCols[nItem,nPosQtd]
			lRet := .F.
			Aviso("Nf x Pedido","Quantidade informada ้ maior que o saldo do pedido",{"OK"})
		Endif
	EndIf

Return(lRet)
