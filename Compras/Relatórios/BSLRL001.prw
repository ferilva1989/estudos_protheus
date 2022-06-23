#include 'protheus.ch'
#include 'parmtype.ch'

user function BSLRL001()

	Local oReport
	Local aArea := GetArea()

	private cFile
	private cPerg       := "BSLRL001"

	// chama a rotina de pergunta (parâmetros)
	If !Pergunte(cPerg,.T.)
		RestArea( aArea )
		Return
	EndIf

	if FindFunction("TRepInUse") .And. TRepInUse()
		oReport := ReportDef()
		oReport:PrintDialog()

	endif

	RestArea( aArea )
	GFEDelTab(cFile)
return

Static Function ReportDef()

	Local oReport, oSection1

	oReport := TReport():New(cPerg, "Relatório de Suprimentos", cPerg, {|oReport| ReportPrint(oReport)}, "Relatório de Suprimentos")
	oReport:SetLandscape(.T.)  //Define a orientação de página do relatório como paisagem  ou retrato. .F.=Retrato; .T.=Paisagem
	oReport:HideParamPage()   	// Desabilita a impressao da pagina de parametros
	oReport:SetTotalInLine(.F.)
	oReport:nLineHeight := 45
	oReport:nfontbody   := 11
	oReport:cfontbody   := "Calibri"

	oSection1:= TRSection():New(oReport, "Relatório de Suprimentos", {"(cFile)"}, , .F., .T.)

	TRCell():New(oSection1,"C1_FILIAL"  , "(cFile)", "FILIAL"          		    ,"@!"/*Picture*/                    , TamSX3("C1_FILIAL")[1]  							,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.T.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/ .T.)
	TRCell():New(oSection1,"TPSC"       , "(cFile)", "TIPO SC"         		    ,"@!"/*Picture*/					, TamSX3("C1_FILIAL")[1]  							,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.T.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/ .T.)
	TRCell():New(oSection1,"C1_EMISSAO" , "(cFile)", "DATA SC"          		,"@!"/*Picture*/					, TamSX3("C1_EMISSAO")[1] 							,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.T.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/ .T.)
	TRCell():New(oSection1,"C1_NUM"     , "(cFile)", "NUM.SOLIC.COM"          	,"@!"/*Picture*/					, TamSX3("C1_NUM")[1]  	 							,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.T.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/ .T.)
	TRCell():New(oSection1,"C1_ITEM"    , "(cFile)", "NR.ITEM"          		,"@!"/*Picture*/					, TamSX3("C1_ITEM")[1]  	 						,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.T.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/ .T.)
	TRCell():New(oSection1,"C1_PRODUTO" , "(cFile)", "COD.ITEM"          		,"@!"/*Picture*/					, TamSX3("C1_PRODUTO")[1] 							,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.T.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/ .T.)
	TRCell():New(oSection1,"C1_DESCRI"  , "(cFile)", "DESCRIÇÃO ITEM"           ,"@!"/*Picture*/					, TamSX3("C1_DESCRI")[1]  							,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.T.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/ .T.)
	TRCell():New(oSection1,"PDIT"       , "(cFile)", "NUMERO DO PEDIDO + ITEM"  ,"@!"/*Picture*/					, TamSx3("C1_PEDIDO")[1] + TamSx3("C1_ITEMPED")[1]	,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.T.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/ .T.)
	TRCell():New(oSection1,"D1_DOC"     , "(cFile)", "NUMERO NF"                ,"@!"/*Picture*/					, TamSX3("D1_DOC")[1]  	 							,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.T.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/ .T.)
	TRCell():New(oSection1,"D1_ITEMPC"  , "(cFile)", "ITEM NF"                  ,"@!"/*Picture*/					, TamSX3("D1_ITEMPC")[1]  							,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.T.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/ .T.)
	TRCell():New(oSection1,"NFIT"       , "(cFile)", "NUMERO + ITEM NF"         ,"@!"/*Picture*/					, TamSX3("D1_DOC")[1] + TamSX3("D1_ITEMPC")[1]  	,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.T.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/ .T.)
	TRCell():New(oSection1,"C1_QUANT"   , "(cFile)", "QTDE SC"          		,"@e 999,999,999.99"/*Picture*/		, TamSX3("C1_QUANT")[1]   							,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.T.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/ .T.)
	TRCell():New(oSection1,"D1_QUANT"   , "(cFile)", "QTDE NF"                  ,"@e 999,999,999.99"/*Picture*/		, TamSX3("D1_QUANT")[1]   							,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.T.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/ .T.)
	TRCell():New(oSection1,"C7_QUJE"    , "(cFile)", "QT SD PED"          		,"@e 999,999,999.99"/*Picture*/		, TamSX3("C7_QUJE")[1]  	 						,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.T.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/ .T.)
	TRCell():New(oSection1,"D1_VUNIT"   , "(cFile)", "Valor Unitario"           ,"@e 999,999,999,999.99"/*Picture*/	, TamSX3("D1_VUNIT")[1]  							,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.T.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/ .T.)
	TRCell():New(oSection1,"D1_TOTAL"   , "(cFile)", "Valor Total"              ,"@e 999,999,999,999.99"/*Picture*/	, TamSX3("D1_TOTAL")[1]  							,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.T.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/ .T.)
	TRCell():New(oSection1,"C1_SOLICIT" , "(cFile)", "SOLICITANTE"          	,"@!"/*Picture*/					, TamSX3("C1_SOLICIT")[1] 							,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.T.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/ .T.)
	TRCell():New(oSection1,"C1_CC"      , "(cFile)", "CENTRO CUSTO"          	,"@!"/*Picture*/					, TamSX3("C1_CC")[1]  	 							,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.T.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/ .T.)
	TRCell():New(oSection1,"C7_DATPRF"  , "(cFile)", "DATA DESEJADA"            ,"@!"/*Picture*/					, TamSX3("C7_DATPRF")[1]  							,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.T.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/ .T.)
	TRCell():New(oSection1,"C7_OBS"     , "(cFile)", "OBSERVAÇÕES"          	,"@!"/*Picture*/					, TamSX3("C7_OBS")[1]   							,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.T.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/ .T.)
	TRCell():New(oSection1,"C1_ZDTAPRO" , "(cFile)", "DT. APROV. SC"            ,"@!"/*Picture*/					, TamSX3("C1_ZDTAPRO")[1]  							,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.T.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/ .T.)
	TRCell():New(oSection1,"C1_ZDTPRAZ" , "(cFile)", "PRAZO ATENDIM."           ,"@!"/*Picture*/					, TamSX3("C1_ZDTPRAZ")[1]  							,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.T.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/ .T.)
	TRCell():New(oSection1,"TPSC"       , "(cFile)", "DIAS RESTANTES"  		    ,"@!"/*Picture*/					, TamSX3("C1_FILIAL")[1]  							,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.T.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/ .T.)
	TRCell():New(oSection1,"TPSC"       , "(cFile)", "TEMPO ATENDIM." 		    ,"@!"/*Picture*/					, TamSX3("C1_FILIAL")[1]  							,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.T.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/ .T.)
	TRCell():New(oSection1,"C7_NUMCOT"  , "(cFile)", "NUM. COTAÇÃO"          	,"@!"/*Picture*/					, TamSX3("C7_NUMCOT")[1]   							,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.T.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/ .T.)
	TRCell():New(oSection1,"TPSC"       , "(cFile)", "DT. ENVIO COT." 		    ,"@!"/*Picture*/					, TamSX3("C1_FILIAL")[1]  							,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.T.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/ .T.)
	TRCell():New(oSection1,"C7_CONTRA"  , "(cFile)", "CONTRATO"          		,"@!"/*Picture*/					, TamSX3("C7_CONTRA")[1]  							,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.T.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/ .T.)
	TRCell():New(oSection1,"C1_ZCATCOM" , "(cFile)", "CATEGORIA COMPRA"         ,"@!"/*Picture*/					, TamSX3("C1_ZCATCOM")[1]  							,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.T.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/ .T.)
	TRCell():New(oSection1,"C1_ZCATLIC" , "(cFile)", "CATEGORIA LICITAÇÃO"      ,"@!"/*Picture*/					, TamSX3("C1_ZCATLIC")[1]  							,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.T.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/ .T.)
	TRCell():New(oSection1,"C7_EMISSAO" , "(cFile)", "DATA DO PEDIDO"           ,"@!"/*Picture*/					, TamSX3("C7_EMISSAO")[1] 							,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.T.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/ .T.)
	TRCell():New(oSection1,"C7_USER"    , "(cFile)", "COMPRADOR"                ,"@!"/*Picture*/					, TamSX3("C7_USER")[1]  							,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.T.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/ .T.)
	TRCell():New(oSection1,"C1_PEDIDO"  , "(cFile)", "NUM. PEDIDO"          	,"@!"/*Picture*/					, TamSX3("C1_PEDIDO")[1]  							,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.T.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/ .T.)
	TRCell():New(oSection1,"C1_ITEMPED" , "(cFile)", "ITEM PEDIDO"          	,"@!"/*Picture*/					, TamSX3("C1_ITEMPED")[1] 							,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.T.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/ .T.)
	TRCell():New(oSection1,"PDIT1"      , "(cFile)", "NUMERO DO PEDIDO + ITEM"  ,"@!"/*Picture*/					, TamSx3("C1_PEDIDO")[1] + TamSx3("C1_ITEMPED")[1]  ,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.T.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/ .T.)
	TRCell():New(oSection1,"C1_FORNECE" , "(cFile)", "FORNECEDOR"          	    ,"@!"/*Picture*/					, TamSX3("C1_FORNECE")[1] 							,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.T.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/ .T.)
	TRCell():New(oSection1,"C1_LOJA"    , "(cFile)", "LOJA"          		    ,"@!"/*Picture*/					, TamSX3("C1_LOJA")[1]  	 						,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.T.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/ .T.)
	TRCell():New(oSection1,"A2_NOME"    , "(cFile)", "FORNECEDOR"               ,"@!"/*Picture*/					, TamSX3("A2_NOME")[1]  	 						,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.T.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/ .T.)
	TRCell():New(oSection1,"CR_DATALIB" , "(cFile)", "DT. APROV. PEDIDO"        ,"@!"/*Picture*/					, TamSX3("CR_DATALIB")[1]  							,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.T.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/ .T.)
	TRCell():New(oSection1,"TPSC"       , "(cFile)", "TEMPO APROV. PEDIDO"    	,"@!"/*Picture*/					, TamSX3("C1_FILIAL")[1]  							,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.T.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/ .T.)
	TRCell():New(oSection1,"D1_DOC1"    , "(cFile)", "NUMERO NF"                ,"@!"/*Picture*/					, TamSX3("D1_DOC")[1]  	 							,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.T.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/ .T.)
	TRCell():New(oSection1,"D1_ZDTETG"  , "(cFile)", "DATA DE ENTREGA"          ,"@!"/*Picture*/					, TamSX3("D1_ZDTETG")[1]  							,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.T.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/ .T.)
	TRCell():New(oSection1,"D1_EMISSAO" , "(cFile)", "DATA NF"                  ,"@!"/*Picture*/					, TamSX3("D1_EMISSAO")[1] 							,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.T.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/ .T.)
	TRCell():New(oSection1,"D1_DTDIGI1" , "(cFile)", "DATA CLASSIFIC."          ,"@!"/*Picture*/					, TamSX3("D1_DTDIGIT")[1]  							,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.T.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/ .T.)
	TRCell():New(oSection1,"TPSC"       , "(cFile)", "TEMPO CLASSIFIC."      	,"@!"/*Picture*/					, TamSX3("C1_FILIAL")[1]  							,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.T.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/ .T.)
	//	TRCell():New(oSection1,"E2_BAIXA"   , "(cFile)", "DATA PGTO"                ,"@!"/*Picture*/					, TamSX3("E2_BAIXA")[1] 							,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.T.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/ .T.)
	TRCell():New(oSection1,"B1_GRUPO"   , "(cFile)", "GRUPO"                    ,"@!"/*Picture*/					, TamSX3("B1_GRUPO")[1]   							,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.T.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/ .T.)
	TRCell():New(oSection1,"D1_DTDIGIT" , "(cFile)", "DATA DA DIGITAÇÃO"        ,"@!"/*Picture*/					, TamSX3("C7_DATPRF")[1]  							,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.T.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/ .T.)

	oReport:SetTotalInLine(.F.)

	//Aqui, farei uma quebra  por seção
	oSection1:SetPageBreak(.T.)
	oSection1:SetTotalText(" ")

Return(oReport)

Static Function ReportPrint(oReport)
	Local oSection1 := oReport:Section(1)

	CarregaDados()

	(cFile)->(dbGoTop())
	oReport:SetMeter((cFile)->(LastRec()))
	oSection1:Init()
	While !oReport:Cancel() .And. (cFile)->(!Eof())

		oSection1:Cell("C1_FILIAL"  ):SetValue((cFile)->C1_FILIAL)
		oSection1:Cell("C1_EMISSAO" ):SetValue((cFile)->C1_EMISSAO)
		oSection1:Cell("C1_NUM"     ):SetValue((cFile)->C1_NUM)
		oSection1:Cell("C1_ITEM"    ):SetValue((cFile)->C1_ITEM)
		oSection1:Cell("C1_PRODUTO" ):SetValue((cFile)->C1_PRODUTO)
		oSection1:Cell("C1_DESCRI"  ):SetValue((cFile)->C1_DESCRI)
		oSection1:Cell("PDIT"       ):SetValue((cFile)->PDIT)
		oSection1:Cell("D1_DOC"     ):SetValue((cFile)->D1_DOC)
		oSection1:Cell("D1_ITEMPC"  ):SetValue((cFile)->D1_ITEMPC)
		oSection1:Cell("NFIT"       ):SetValue((cFile)->NFIT)
		oSection1:Cell("C1_QUANT"   ):SetValue((cFile)->C1_QUANT)
		oSection1:Cell("D1_QUANT"   ):SetValue((cFile)->D1_QUANT)
		oSection1:Cell("C7_QUJE"    ):SetValue((cFile)->C7_QUJE)
		oSection1:Cell("D1_VUNIT"   ):SetValue((cFile)->D1_VUNIT)
		oSection1:Cell("D1_TOTAL"   ):SetValue((cFile)->D1_TOTAL)
		oSection1:Cell("C1_SOLICIT" ):SetValue((cFile)->C1_SOLICIT)
		oSection1:Cell("C1_CC"      ):SetValue((cFile)->C1_CC)
		oSection1:Cell("C7_DATPRF"  ):SetValue((cFile)->C7_DATPRF)
		oSection1:Cell("C7_OBS"     ):SetValue((cFile)->C7_OBS)
		oSection1:Cell("C1_ZDTAPRO" ):SetValue((cFile)->C1_ZDTAPRO)
		oSection1:Cell("C1_ZDTPRAZ" ):SetValue((cFile)->C1_ZDTPRAZ)
		oSection1:Cell("C1_ZCATCOM" ):SetValue((cFile)->C1_ZCATCOM)
		oSection1:Cell("C1_ZCATLIC" ):SetValue((cFile)->C1_ZCATLIC)
		oSection1:Cell("C7_CONTRA"  ):SetValue((cFile)->C7_CONTRA)
		oSection1:Cell("C7_EMISSAO" ):SetValue((cFile)->C7_EMISSAO)
		oSection1:Cell("C7_USER"    ):SetValue(UsrRetName((cFile)->C7_USER))
		oSection1:Cell("C1_PEDIDO"  ):SetValue((cFile)->C1_PEDIDO)
		oSection1:Cell("C1_ITEMPED" ):SetValue((cFile)->C1_ITEMPED)
		oSection1:Cell("PDIT1"      ):SetValue((cFile)->PDIT1)
		oSection1:Cell("C1_FORNECE" ):SetValue((cFile)->C1_FORNECE)
		oSection1:Cell("C1_LOJA"    ):SetValue((cFile)->C1_LOJA)
		oSection1:Cell("A2_NOME"    ):SetValue((cFile)->A2_NOME)
		oSection1:Cell("CR_DATALIB" ):SetValue((cFile)->CR_DATALIB)
		oSection1:Cell("TPSC"       ):SetValue((cFile)->TPSC)
		oSection1:Cell("D1_DOC1"    ):SetValue((cFile)->D1_DOC1)
		oSection1:Cell("D1_ZDTETG"  ):SetValue((cFile)->D1_ZDTETG)
		oSection1:Cell("D1_EMISSAO" ):SetValue((cFile)->D1_EMISSAO)
		oSection1:Cell("D1_DTDIGI1" ):SetValue((cFile)->D1_DTDIGIT)
		oSection1:Cell("TPSC"       ):SetValue((cFile)->TPSC)
		//		oSection1:Cell("E2_BAIXA"   ):SetValue((cFile)->E2_BAIXA)
		oSection1:Cell("B1_GRUPO"   ):SetValue((cFile)->B1_GRUPO)
		oSection1:Cell("D1_DTDIGIT" ):SetValue((cFile)->D1_DTDIGIT)

		oSection1:PrintLine()
		(cFile)->(dbSkip())
	EndDo

	oSection1:Finish()
Return

/*
* Função......: CarregaDados()
* Parametros..:
* Objetivo....: Processar Query para obter informações para o Relatório
* Responsável.: RVogel
*
*/

Static Function CarregaDados()

	Local cQry

	cQry := " SELECT  "
	cQry += " SC1.C1_FILIAL,   "
	cQry += " '' TPSC, "
	cQry += " SC1.C1_EMISSAO,   "
	cQry += " SC1.C1_NUM,   "
	cQry += " SC1.C1_ITEM,   "
	cQry += " SC1.C1_PRODUTO,   "
	cQry += " SC1.C1_DESCRI,   "
	cQry += " SC1.C1_PEDIDO +SC1.C1_ITEMPED PDIT,  "
	cQry += " SC1.C1_PEDIDO +SC1.C1_ITEMPED PDIT1,  "
	cQry += " SC1.C1_QUJE,   "
	cQry += " SC1.C1_QUANT,   "
	cQry += " SC1.C1_PRECO,   "
	cQry += " SC1.C1_TOTAL,   "
	cQry += " SC1.C1_PEDIDO,   "
	cQry += " SC1.C1_ITEMPED,   "
	cQry += " SC1.C1_FORNECE,   "
	cQry += " SC1.C1_LOJA, "
	cQry += " SC1.C1_APROV,   "
	cQry += " SC1.C1_SOLICIT,   "
	cQry += " SC1.C1_CC, "
	cQry += " SC1.C1_ZDTAPRO, "
	cQry += " SC1.C1_ZDTPRAZ,   "
	cQry += " SC1.C1_ZCATCOM,   "
	cQry += " SC1.C1_ZCATLIC,   "
	cQry += " SC7.C7_USER, "
	cQry += " SC7.C7_FORNECE,   "
	cQry += " SC7.C7_NUM, "
	cQry += " SC7.C7_ITEM, "
	cQry += " SC7.C7_NUMSC,   "
	cQry += " SC7.C7_ITEMSC, "
	cQry += " SC7.C7_CONTRA,   "
	cQry += " SC7.C7_MEDICAO,   "
	cQry += " SC7.C7_PRODUTO,   "
	cQry += " SC7.C7_QUANT,   "
	cQry += " SC7.C7_EMISSAO,   "
	cQry += " SC7.C7_DATPRF,   "
	cQry += " SC7.C7_OBS,   "
	cQry += " SC7.C7_NUMCOT,   "
	cQry += " SC7.C7_QUJE,   "
	cQry += " SD1.D1_EMISSAO,   "
	cQry += " SD1.D1_DTDIGIT,   "
	cQry += " SD1.D1_DTDIGIT D1_DTDIGI1,   "
	cQry += " SD1.D1_DOC,   "
	cQry += " SD1.D1_DOC D1_DOC1,   "
	cQry += " SD1.D1_PEDIDO,   "
	cQry += " SD1.D1_ITEMPC,   "
	cQry += " SD1.D1_DOC + SD1.D1_ITEMPC NFIT,   "
	cQry += " SD1.D1_QUANT,   "
	cQry += " SD1.D1_VUNIT,   "
	cQry += " SD1.D1_TOTAL,   "
	cQry += " SD1.D1_ZDTETG,   "
	cQry += " SA2.A2_COD,   "
	cQry += " SA2.A2_LOJA,   "
	cQry += " SA2.A2_NOME,   "
	cQry += " SB1.B1_GRUPO ,   "
	cQry += " MAX(SCR.CR_DATALIB) CR_DATALIB  "
	cQry += " FROM   "
	cQry += " "+RetSqlName("SC1")+" SC1  "
	cQry += " LEFT JOIN   "
	cQry += " "+RetSqlName("SC7")+" SC7 ON (C7_FILIAL+C7_NUMSC+C7_ITEMSC+C7_PRODUTO = C1_FILIAL+C1_NUM+C1_ITEM+C1_PRODUTO AND SC7.D_E_L_E_T_ = '') "
	cQry += " LEFT JOIN   "
	cQry += " "+RetSqlName("SD1")+" SD1 ON (D1_FILIAL+D1_PEDIDO+D1_ITEMPC+D1_COD+D1_FORNECE+D1_LOJA = C7_FILIAL+C7_NUM+C7_ITEM+C7_PRODUTO+C7_FORNECE+C7_LOJA AND SD1.D_E_L_E_T_ = '')   "
	cQry += " LEFT JOIN "
	cQry += " "+RetSqlName("SB1")+" SB1 ON ( B1_COD = C1_PRODUTO AND SB1.D_E_L_E_T_ = '')  "
	cQry += " LEFT JOIN "
	cQry += " "+RetSqlName("SA2")+" SA2 ON (A2_COD+A2_LOJA = D1_FORNECE+D1_LOJA AND SA2.D_E_L_E_T_ = '') "
	cQry += " LEFT JOIN "
	cQry += " "+RetSqlName("SCR")+" SCR ON (CR_FILIAL+CR_NUM = C7_FILIAL+C7_NUM AND SCR.D_E_L_E_T_ = '') "
	cQry += " WHERE  "
	cQry += " SC1.D_E_L_E_T_ = ''  "
	cQry += " AND SC1.C1_APROV = 'L' "
	cQry += " AND C1_RESIDUO = ' '  "
	cQry += " AND SC1.C1_FILIAL  BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
	cQry += " AND SC1.C1_EMISSAO BETWEEN '"+DToS(MV_PAR03)+"' AND '"+DToS(MV_PAR04)+"'  "
	cQry += " AND SC1.C1_CC      BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'  "
	cQry += " GROUP BY "
	cQry += " SC1.C1_FILIAL,   "
	cQry += " SC1.C1_EMISSAO,   "
	cQry += " SC1.C1_NUM,   "
	cQry += " SC1.C1_ITEM,   "
	cQry += " SC1.C1_PRODUTO,   "
	cQry += " SC1.C1_DESCRI,   "
	cQry += " SC1.C1_PEDIDO +SC1.C1_ITEMPED,  "
	cQry += " SC1.C1_PEDIDO +SC1.C1_ITEMPED,  "
	cQry += " SC1.C1_QUJE,   "
	cQry += " SC1.C1_QUANT,   "
	cQry += " SC1.C1_PRECO,   "
	cQry += " SC1.C1_TOTAL,   "
	cQry += " SC1.C1_PEDIDO,   "
	cQry += " SC1.C1_ITEMPED,   "
	cQry += " SC1.C1_FORNECE,   "
	cQry += " SC1.C1_LOJA, "
	cQry += " SC1.C1_APROV,   "
	cQry += " SC1.C1_SOLICIT,   "
	cQry += " SC1.C1_CC,   "
	cQry += " SC1.C1_ZDTAPRO, "
	cQry += " SC1.C1_ZDTPRAZ,   "
	cQry += " SC1.C1_ZCATCOM,   "
	cQry += " SC1.C1_ZCATLIC,   "
	cQry += " SC7.C7_USER,   "
	cQry += " SC7.C7_FORNECE,   "
	cQry += " SC7.C7_NUM,   "
	cQry += " SC7.C7_ITEM,   "
	cQry += " SC7.C7_NUMSC,   "
	cQry += " SC7.C7_ITEMSC, "
	cQry += " SC7.C7_CONTRA,   "
	cQry += " SC7.C7_MEDICAO,   "
	cQry += " SC7.C7_PRODUTO,   "
	cQry += " SC7.C7_QUANT,   "
	cQry += " SC7.C7_EMISSAO,   "
	cQry += " SC7.C7_DATPRF,   "
	cQry += " SC7.C7_OBS, "
	cQry += " SC7.C7_NUMCOT,   "
	cQry += " SC7.C7_QUJE,   "
	cQry += " SD1.D1_EMISSAO,   "
	cQry += " SD1.D1_DTDIGIT,   "
	cQry += " SD1.D1_DTDIGIT,   "
	cQry += " SD1.D1_DOC,   "
	cQry += " SD1.D1_DOC, "
	cQry += " SD1.D1_PEDIDO,   "
	cQry += " SD1.D1_ITEMPC,   "
	cQry += " SD1.D1_DOC + SD1.D1_ITEMPC,  "
	cQry += " SD1.D1_QUANT,   "
	cQry += " SD1.D1_VUNIT,   "
	cQry += " SD1.D1_TOTAL,   "
	cQry += " SD1.D1_ZDTETG,   "
	cQry += " SA2.A2_COD,   "
	cQry += " SA2.A2_LOJA,   "
	cQry += " SA2.A2_NOME,   "
	cQry += " SB1.B1_GRUPO     "
	cQry += " ORDER BY "
	cQry += " SC1.C1_FILIAL, SC1.C1_EMISSAO, SC1.C1_NUM "

	cQry	:= ChangeQuery(cQry)
	cFile 	:= GetNextAlias()
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQry),cFile, .F., .T.)

	// Converte DATA AAAAMMDD para DDMMAAAA
	TCSetField(cFile, 'C1_EMISSAO', 'D')
	TCSetField(cFile, 'C7_EMISSAO', 'D')
	TCSetField(cFile, 'C7_DATPRF',  'D')
	TCSetField(cFile, 'D1_EMISSAO', 'D')
	TCSetField(cFile, 'D1_DTDIGIT', 'D')
	TCSetField(cFile, 'D1_DTDIGI1', 'D')
	TCSetField(cFile, 'C1_ZDTAPRO', 'D')
	TCSetField(cFile, 'C1_ZDTAPR1', 'D')
	TCSetField(cFile, 'C1_ZDTPRAZ', 'D')
	TCSetField(cFile, 'D1_ZDTETG',  'D')
	//	TCSetField(cFile, 'E2_BAIXA',   'D')
	TCSetField(cFile, 'CR_DATALIB', 'D')

	dbSelectArea( (cFile) )
	(cFile)->( dbGoTop() )

Return
