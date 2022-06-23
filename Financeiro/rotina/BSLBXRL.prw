#include 'protheus.ch'
#include 'parmtype.ch'

user function BSLBXRL()

	local oReport
	local aArea := GetArea()

	private cTabTemp
	private cPerg       := "BSLBXRL"

	// chama a rotina de validação da pergunta
	validaPergunta(cPerg)

	// chama a rotina de pergunta (parâmetros)
	Pergunte(cPerg,.T.)

	if FindFunction("TRepInUse") .And. TRepInUse()
		//-- Interface de impressao
		oReport := ReportDef()
		oReport:PrintDialog()
	endif

	RestArea( aArea )
	GFEDelTab(cTabTemp)

Return

Static Function ReportDef()

	local oReport, oSection0, oSection1
	local aOrdem  := {}

	//--------------------------------------------------------------------------
	//Criacao do componente de impressao
	//--------------------------------------------------------------------------
	//TReport():New
	//ExpC1 : Nome do relatorio
	//ExpC2 : Titulo
	//ExpC3 : Pergunte
	//ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao
	//ExpC5 : Descricao
	//--------------------------------------------------------------------------

	oReport:= TReport():New(cPerg, "Financeiro", cPerg, {|oReport| ReportPrint(oReport)}, "Relatório Log de Processamento Cnab.")
	oReport:SetLandscape(.T.)   //Define a orientação de página do relatório como paisagem  ou retrato. .F.=Retrato; .T.=Paisagem
	oReport:SetTotalInLine(.T.) //Define se os totalizadores serão impressos em linha ou coluna
	oReport:HideParamPage()   	// Desabilita a impressao da pagina de parametros

	if !Empty(oReport:uParam)
		Pergunte(oReport:uParam,.F.)
	endif

	Aadd( aOrdem, "Financeiro" ) // "Movimentação Doc Carga"

	oSection0 := TRSection():New(oReport,"-",{"ZZ3"},{"-"})
	oSection0:Hide()
	oSection0:Disable()
	oSection0:lReadOnly := .T.
	oSection0:lUserVisible := .F.

	oSection1 := TRSection():New(oReport,"Relatório Log de Processamento Cnab",{"(cTabTemp)"},aOrdem)
	oSection1:SetTotalInLine(.T.)
	oSection1:SetHeaderSection(.T.) //Define que imprime cabeçalho das células na quebra de seção



	TRCell():New(oSection1,"(cTabTemp)->Z3_FILIAL"	, "(cTabTemp)", "Filial"          		/*cTitle*/,"@!"/*Picture*/, TamSX3("Z3_FILIAL")[1]  						,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.T.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.T.)
	TRCell():New(oSection1,"(cTabTemp)->Z3_DATA"	, "(cTabTemp)", "Data Processamento"	/*cTitle*/,"@!"/*Picture*/, TamSX3("Z3_DATA")[1]  						,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.T.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.T.)
	TRCell():New(oSection1,"(cTabTemp)->Z3_HORA"	, "(cTabTemp)", "Hora Processamento"	/*cTitle*/,"@!"/*Picture*/, TamSX3("Z3_HORA")[1]  						,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.T.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.T.)
	TRCell():New(oSection1,"(cTabTemp)->Z3_ORIGEM"	, "(cTabTemp)", "Origem do Registro"	/*cTitle*/,"@!"/*Picture*/, TamSX3("Z3_ORIGEM")[1]  						,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.T.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.T.)
	TRCell():New(oSection1,"(cTabTemp)->Z3_IDCNAB"	, "(cTabTemp)", "ID Cnab"				/*cTitle*/,"@!"/*Picture*/, TamSX3("Z3_IDCNAB")[1]  						,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.T.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.T.)
	TRCell():New(oSection1,"(cTabTemp)->Z3_PREFIXO"	, "(cTabTemp)", "Prefixo"			    /*cTitle*/,"@!"/*Picture*/, TamSX3("Z3_PREFIXO")[1],/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.T.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.T.)
	TRCell():New(oSection1,"(cTabTemp)->Z3_NUM"		, "(cTabTemp)", "Numero Título"			/*cTitle*/,"@!"/*Picture*/, TamSX3("Z3_NUM")[1]   ,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.T.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.T.)
	TRCell():New(oSection1,"(cTabTemp)->Z3_CLIFOR"	, "(cTabTemp)", "Cliente / Fornecedor"  /*cTitle*/,"@!"/*Picture*/, TamSX3("Z3_CLIFOR")[1]   ,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.T.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.T.)
	TRCell():New(oSection1,"(cTabTemp)->Z3_PARCELA"	, "(cTabTemp)", "Parcela"				/*cTitle*/,"@!"/*Picture*/, TamSX3("Z3_PARCELA")[1] 						,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.T.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.T.)
	TRCell():New(oSection1,"(cTabTemp)->Z3_TIPO"	, "(cTabTemp)", "Tipo"					/*cTitle*/,"@!"/*Picture*/, TamSX3("Z3_TIPO")[1]  						,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.T.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.T.)
	TRCell():New(oSection1,"(cTabTemp)->Z3_PROCESS"	, "(cTabTemp)", "Processado"	    	/*cTitle*/,"@!"/*Picture*/, TamSX3("Z3_PROCESS")[1]  						,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.T.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.T.)
	TRCell():New(oSection1,"(cTabTemp)->Z3_CODERR"	, "(cTabTemp)", "Codigo Ocorrência"    	/*cTitle*/,"@!"/*Picture*/, TamSX3("Z3_CODERR")[1] 	 					,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.T.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.T.)
	TRCell():New(oSection1,"(cTabTemp)->Z3_DESCERR"	, "(cTabTemp)", "Descrição"	    		/*cTitle*/,"@!"/*Picture*/, TamSX3("Z3_DESCERR")[1]  						,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.T.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.T.)
	TRCell():New(oSection1,"(cTabTemp)->Z3_ARQ"		, "(cTabTemp)", "Nome Arquivo"	    	/*cTitle*/,"@!"/*Picture*/, TamSX3("Z3_ARQ")[1]  						,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.T.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.T.)
	TRCell():New(oSection1,"(cTabTemp)->Z3_DATABX"	, "(cTabTemp)", "Data de Baixa"			/*cTitle*/,"@!"/*Picture*/, TamSX3("Z3_DATABX")[1]  						,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.T.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.T.)
	TRCell():New(oSection1,"(cTabTemp)->Z3_OBS"		, "(cTabTemp)", "Observações"	    	/*cTitle*/,"@!"/*Picture*/, TamSX3("Z3_OBS")[1]  						,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/.T.,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/.T.)

Return(oReport)

Static Function ReportPrint(oReport)
	Local oSection1 := oReport:Section(2)
	Local aGCList 	:= {}

	aGCList := oReport:GetGCList()	// Função retorna array com filiais que o usuário tem acesso

	CarregaDados(aGCList)

	//----------------------------------------------------------
	//Seta regua de processamento
	//----------------------------------------------------------
	(cTabTemp)->(dbGoTop())
	oReport:SetMeter((cTabTemp)->(LastRec()))

	oSection1:Init()

	While !oReport:Cancel() .And. (cTabTemp)->(!Eof())
		oSection1:PrintLine()
		(cTabTemp)->(dbSkip())
	EndDo

	oSection1:Finish()
Return

Static Function CarregaDados(aGCList)

	Local cQuery

	cQuery := " SELECT 			"
	cQuery += " 	Z3_FILIAL, 	"
	cQuery += " 	Z3_DATA, 	"
	cQuery += " 	Z3_HORA, 	"
	cQuery += " 	CASE Z3_ORIGEM "
	cQuery += " 	   WHEN 1 THEN 'Contas a Receber'"
	cQuery += " 	   WHEN 2 THEN 'Contas a Pagar  '"
	cQuery += " 	END AS Z3_ORIGEM, "
	cQuery += " 	Z3_IDCNAB, "
	cQuery += " 	Z3_PREFIXO, "
	cQuery += " 	Z3_NUM, 	"
	cQuery += " 	Z3_PARCELA, "
	cQuery += " 	Z3_TIPO, "
	cQuery += " 	CASE Z3_PROCESS "
	cQuery += " 	   WHEN 'S' THEN 'SIM'"
	cQuery += " 	   WHEN 'N' THEN 'NAO'"
	cQuery += " 	END AS Z3_PROCESS, "
	cQuery += " 	Z3_CODERR, 	"
	cQuery += " 	Z3_DESCERR, "
	cQuery += " 	Z3_ARQ, 	"
	cQuery += " 	Z3_DATABX,	"
	cQuery += " 	Z3_OBS,	"
	cQuery += "     Z3_CLIFOR "
	cQuery += " FROM " + RetSqlName("ZZ3")
	cQuery += " WHERE "
	cQuery += "     Z3_DATA BETWEEN '" + DToS(MV_PAR01) + "' AND '" + DToS(MV_PAR02) + "'"

	If MV_PAR03 == 1
		cQuery += "     AND Z3_ORIGEM = '1'"
	ElseIf MV_PAR03 == 2
		cQuery += "     AND Z3_ORIGEM = '2'"
	EndIf

	cQuery		:= ChangeQuery(cQuery)
	cTabTemp 	:= GetNextAlias()
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),cTabTemp, .F., .T.)

	// Converte DATA AAAAMMDD para DDMMAAAA
	TCSetField(cTabTemp, 'Z3_DATA',   'D')
	TCSetField(cTabTemp, 'Z3_DATABX', 'D')

	dbSelectArea( (cTabTemp) )
	(cTabTemp)->( dbGoTop() )
Return
