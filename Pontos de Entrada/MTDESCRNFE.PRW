#INCLUDE 'RWMAKE.CH'

/////////////////////////////////////////////////////////////////////////
//   Programa para Impressao do RPS         						   //
/////////////////////////////////////////////////////////////////////////

User Function MTDESCRNFE()

	Local    aDescr  := {}
	Local    cPedido := ""
	Local    cQuery  := ""
	Local	 cNDoc   := ParamIXB[1]
	Local	 cSerie  := ParamIXB[2]
	Local	 cClient := Left(ParamIXB[3]+Space(6), 6)
	Local	 cLoja   := ParamIXB[4]

	Private  cTexto  := ""

	DbSelectArea("SD2")
	SD2->(DbSetOrder(3)) // D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
	SD2->(DbSeek(xFilial("SD2") + cNDoc + cSerie + cClient + cLoja))

	DbSelectArea("SC5")
	SC5->(DbSetOrder(1))
	SC5->(DbSeek(xFilial("SC5") + SD2->D2_PEDIDO))

	cTexto  += Alltrim(SC5->C5_MENNOTA) + "|"
	//IF Alltrim(SD2->D2_COD) == "5002000003"
	//	cTexto  += Alltrim(FORMULA("005")) + "|"
	//ELSE                                                 
	cTexto  += Alltrim(FORMULA(SC5->C5_MENPAD)) + "|"
	//ENDIF

	IF SF2->F2_TOTIMP > 0
		cTexto += "|" + "|" + "Valor Aproximado dos Tributos R$ " + Alltrim(Transform(SF2->F2_TOTIMP,"@E 999,999,999.99")) + " Fonte: IBPT"
	End

Return(cTexto)