#INCLUDE "Topconn.ch"
#INCLUDE "Protheus.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "REPORT.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBSLR001  บAutor  ณ William Souza      บ Data ณ 17/12/2018   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Impressใo de pendencia de aprovadores de solicita็ใo de    บฑฑ
ฑฑบ          ณ compra.                                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BSL - Ethosx Consultoria e Solu็๕es                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function BSLR001()

	Local oButton1
	Local oRadMenu1
	Local nRadMenu1 := 1
	Local oSay1
	Static oDlg

	/*	RPCSetType(3)	
	RpcSetEnv( "01" , "01001" , "" , "" , 'COM' )  */   

	DEFINE MSDIALOG oDlg TITLE "Relatorio de Status de Aprova็ใo" FROM 000, 000  TO 200, 350 COLORS 0, 16777215 PIXEL

	@ 019, 018 SAY oSay1 PROMPT "Selecione o Relat๓rio" SIZE 089, 006 OF oDlg COLORS 0, 16777215 PIXEL
	@ 034, 017 RADIO oRadMenu1 VAR nRadMenu1 ITEMS "SC - Solicita็ใo de Compra","PC - Pedido de Compra" SIZE 126, 022 OF oDlg COLOR 0, 16777215 PIXEL
	@ 062, 017 BUTTON oButton1 PROMPT "Gerar" SIZE 037, 012 OF oDlg PIXEL action(BSLR001(nRadMenu1)) 
	@ 062, 058 BUTTON oButton1 PROMPT "Fechar" SIZE 037, 012 OF oDlg PIXEL action(oDlg:end())

	ACTIVATE MSDIALOG oDlg CENTERED

Return

Static Function BSLR001(nTipo)

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณDeclaracao de variaveis                   ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	Private oReport  := Nil
	Private oSecCab	 := Nil
	Private cPerg 	 := PadR ("BSLR001", Len (SX1->X1_GRUPO))
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณCriacao e apresentacao das perguntas      ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	//Filial de/ at้;
	u_zPutSX1(cPerg, "01", "Filial de?"      ,   "MV_PAR01", "MV_CH1", "C", TamSX3('C1_FILIAL')[01]  , 0, "G","","","","","","","","","Informe a filial")
	u_zPutSX1(cPerg, "02", "Filial at้?"     ,   "MV_PAR02", "MV_CH2", "C", TamSX3('C1_FILIAL')[01]  , 0, "G","","","","","","","","","Informe a filial")

	//Dt emissใo de/at้;
	u_zPutSX1(cPerg, "03", "Data Emissใo de?" ,  "MV_PAR03", "MV_CH3", "D",08                        , 0, "G","","","","","","","","","Informe a data inicial")
	u_zPutSX1(cPerg, "04", "Data Emissใo at้?",  "MV_PAR04", "MV_CH4", "D",08                        , 0, "G","","","","","","","","","Informe a data final")

	//Status doc (Pendente/ Aprovado/ Bloqueado/ Ambos)
	u_zPutSX1(cPerg, "06", "Status"           ,  "MV_PAR05", "MV_CH5", "C",1                         , 0, "C","","","","Aprovado","Pendente","Rejeitado","Todos","","Informe o status da solicita็ใo")

	//Numero do documento de/ at้;
	u_zPutSX1(cPerg, "07", "Documento de?"    ,  "MV_PAR06", "MV_CH6", "C", TamSX3('C1_NUM')[01]     , 0, "G","","","","","","","","","Informe o numero do pedido de compra ou solicita็ใo de compra")
	u_zPutSX1(cPerg, "08", "Documento at้?"   ,  "MV_PAR07", "MV_CH7", "C", TamSX3('C1_NUM')[01]     , 0, "G","","","","","","","","","Informe o numero do pedido de compra ou solicita็ใo de compra")

	//Produto de/ at้;
	u_zPutSX1(cPerg, "09", "Produto de?"      ,  "MV_PAR08", "MV_CH8", "C", TamSX3('C1_PRODUTO')[01] , 0, "G","","SB1","","","","","","","Informe o codigo do produto")
	u_zPutSX1(cPerg, "10", "Produto at้?"     ,  "MV_PAR09", "MV_CH9", "C", TamSX3('C1_PRODUTO')[01] , 0, "G","","SB1","","","","","","","Informe o codigo do produto")

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณDefinicoes/preparacao para impressao      ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	ReportDef(nTipo) 
	oReport	:PrintDialog()	

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBSLR001  บAutor  ณ William Souza      บ Data ณ 17/12/2018   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Defini็ใo da estrutura do relat๓rio.                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ReportDef(nTipo)

	oReport := TReport():New("BSLR001","Lista com pend๊ncia de aprova็ใo solicita็ใo/pedido de compra",cPerg,{|oReport| PrintReport(oReport,nTipo)},"Lista com pend๊ncia de aprova็ใo solicita็ใo/pedido de compra")
	oReport:SetTotalInLine(.F.)
	oReport:lParamPage := .F.
	oReport:oPage:SetPaperSize(9) //Folha A4
	oReport:SetLandScape() // Aqui que define Retrato ou Paisagem

	if nTipo == 1 
		oSecCab := TRSection():New( oReport , "Solicita็ใo de Compras", {"QRY"} ) 
		TRCell():New( oSecCab, "C1_FILIAL"	, "QRY", "Filial SC"			,,5,,,,,,,,,,,)
		TRCell():New( oSecCab, "C1_TPSC"	, "QRY", "Tipo SC"				,,1,,,,,,,,,,,)
		TRCell():New( oSecCab, "C1_NUM"		, "QRY", "Nro. SC"				,,6,,,,,,,,,,,)
		TRCell():New( oSecCab, "C1_ITEM"	, "QRY", "Item SC"				,,4,,,,,,,,,,,)
		TRCell():New( oSecCab, "C1_PRODUTO"	, "QRY", "Cod. Produto SC"		,,15,,,,,,,,,,,)
		TRCell():New( oSecCab, "C1_DESCRI"	, "QRY", "Descr. Produto SC"	,,40,,,,,,,,,,,)
		TRCell():New( oSecCab, "C1_QUANT"	, "QRY", "Quantidade SC"		,,14,,,,,,,,,,,)
		TRCell():New( oSecCab, "C1_VUNIT"	, "QRY", "Pre็o Unitแrio SC"	,,14,,,,,,,,,,,)
		TRCell():New( oSecCab, "C1_EMISSAO"	, "QRY", "Dt. Emissao SC"		,PesqPict("SC1","C1_EMISSAO"), 8,,{|| STOD(QRY->C1_EMISSAO)},,,,,,,,,)
//		TRCell():New( oSecCab, "C1_DATPRF"	, "QRY", "Dt. Necessidade SC"	,PesqPict("SC1","C1_DATPRF"), 8,,{|| STOD(QRY->C1_DATPRF)},,,,,,,,,)
		TRCell():New( oSecCab, "C1_OBS"		, "QRY", "Observa็๕es SC"		,,90,,,,,,,,,,,)	
		TRCell():New( oSecCab, "C1_SOLICIT"	, "QRY", "Solicitante"			,,25,,,,,,,,,,,)
//		TRCell():New( oSecCab, "DBM_APROV"	, "QRY", "Status SC"			,,1,,,,,,,,,,,)
		TRCell():New( oSecCab, "AK_LOGIN"	, "QRY", "Aprovador SC"			,,25,,,,,,,,,,,)
		TRCell():New( oSecCab, "CR_DATALIB"	, "QRY", "Dt. Aprova็ใo SC"		,PesqPict("SCR","CR_DATALIB"), 8,,{|| STOD(QRY->CR_DATALIB)},,,,,,,,,)
		TRCell():New( oSecCab, "C7_NUM"		, "QRY", "Nro. PC"				,,6,,,,,,,,,,,)
//		TRCell():New( oSecCab, "C7_ITEM"	, "QRY", "Item PC"				,,4,,,,,,,,,,,)
//		TRCell():New( oSecCab, "C7_PRODUTO"	, "QRY", "Cod. Produto PC"		,,15,,,,,,,,,,,)
//		TRCell():New( oSecCab, "C7_DESCRI"	, "QRY", "Descr. Produto PC"	,,40,,,,,,,,,,,)
		TRCell():New( oSecCab, "C7_QUANT"	, "QRY", "Quantidade PC"		,,14,,,,,,,,,,,)
		TRCell():New( oSecCab, "C7_PRECO"	, "QRY", "Pre็o Unitแrio PC"	,,14,,,,,,,,,,,)
		TRCell():New( oSecCab, "C7_TOTAL"	, "QRY", "Total PC"				,,14,,,,,,,,,,,)
		TRCell():New( oSecCab, "C7_EMISSAO"	, "QRY", "Dt. Emissao PC"		,PesqPict("SC7","C7_EMISSAO"), 8,,{|| STOD(QRY->C7_EMISSAO)},,,,,,,,,)
		TRCell():New( oSecCab, "C7_DATPRF"	, "QRY", "Dt. Necessidade PC"	,PesqPict("SC7","C7_DATPRF"), 8,,{|| STOD(QRY->C7_DATPRF)},,,,,,,,,)
//		TRCell():New( oSecCab, "C7_OBS"		, "QRY", "Observa็๕es PC"		,,90,,,,,,,,,,,)	
//		TRCell():New( oSecCab, "C7_SOLICIT"	, "QRY", "Solicitante"			,,25,,,,,,,,,,,)
		TRCell():New( oSecCab, "C7_FORNECE"	, "QRY", "Cod. Fornecedor"		,,6,,,,,,,,,,,)
		TRCell():New( oSecCab, "A2_NOME"	, "QRY", "Nome Fornecedor"		,,40,,,,,,,,,,,)
		TRCell():New( oSecCab, "C7_COMPRA"	, "QRY", "Cod. Comprador"		,,6,,,,,,,,,,,)
		TRCell():New( oSecCab, "Y1_NOME"	, "QRY", "Nome Comprador"		,,40,,,,,,,,,,,)
		TRCell():New( oSecCab, "C7_RESIDUO"	, "QRY", "Elim. Resํduo?"		,,1,,,,,,,,,,,)
		TRCell():New( oSecCab, "D1_DOC"		, "QRY", "Nro. NF"				,,9,,,,,,,,,,,)
//		TRCell():New( oSecCab, "D1_FORNECE"	, "QRY", "Cod. Fornecedor"		,,6,,,,,,,,,,,)
//		TRCell():New( oSecCab, "A2_NOME"	, "QRY", "Nome Fornecedor"		,,40,,,,,,,,,,,)
		TRCell():New( oSecCab, "D1_EMISSAO"	, "QRY", "Dt. Emissao NF"		,PesqPict("SD1","D1_EMISSAO"), 8,,{|| STOD(QRY->D1_EMISSAO)},,,,,,,,,)
		TRCell():New( oSecCab, "D1_DTDIGIT"	, "QRY", "Dt. Digita็ใo NF"		,PesqPict("SD1","D1_DTDIGIT"), 8,,{|| STOD(QRY->D1_DTDIGIT)},,,,,,,,,)
		TRCell():New( oSecCab, "C1_CONTA"	, "QRY", "Conta Contแbil"		,,20,,,,,,,,,,,)
		TRCell():New( oSecCab, "CT1_DESC01"	, "QRY", "Desc. C. Contแbil"	,,40,,,,,,,,,,,)
		TRCell():New( oSecCab, "C1_CC"		, "QRY", "Centro Custo"			,,20,,,,,,,,,,)
		TRCell():New( oSecCab, "CTT_DESC01"	, "QRY", "Desc. C. Custo"		,,40,,,,,,,,,,,)

		TRFunction():New(oSecCab:Cell("C1_NUM"),,"COUNT",,,,,.F.,.T.,.F.,oSecCab)

	Else
		oSecCab := TRSection():New( oReport , "Pedido de Compras", {"QRY2"} ) 
		TRCell():New( oSecCab, "C7_FILIAL"  , "QRY2", "Filial"             ,, 12,.f.,,,,,,,,,,)
		TRCell():New( oSecCab, "FORNECE"    , "QRY2", "Fornecedor"         ,, 30,.f.,,,,,,,,,,)  
		TRCell():New( oSecCab, "C7_EMISSAO" , "QRY2")//, "Dt.Emissใo"         ,, 25,.f.,,,,,,,,,,)
		TRCell():New( oSecCab, "C7_NUM"     , "QRY2")//, "Nro PC"             ,, 20,.f.,,,,,,,,,,)
		TRCell():New( oSecCab, "C7_NUMSC"   , "QRY2")//, "Nro SC"             ,, 20,.f.,,,,,,,,,,)  
		TRCell():New( oSecCab, "C7_ITEM"    , "QRY2")//, "Item"               ,, 10,.f.,,,,,,,,,,) 
		TRCell():New( oSecCab, "PRODUTO"    , "QRY2", "Produto"            ,, 100,.f.,,,,,,,,,,) 
		TRCell():New( oSecCab, "C7_QUANT"   , "QRY2")//, "Qtd"                ,, 20,.f.,,,,,,,,,,)  
		TRCell():New( oSecCab, "CR_USER"    , "QRY2", "Solicit."        ,, 40,.f.,{||POSICIONE("SAK",1,XFILIAL("SAK")+("QRY2")->CR_USER,"AK_NOME")})
		TRCell():New( oSecCab, "C7_CC"      , "QRY2")//, "CC"                 ,, 30,.f.,,,,,,,,,,)
		TRCell():New( oSecCab, "C7_OBS"     , "QRY2", "Observa็ใo"         ,, 100,.f.,,,,,,,,,,)
		TRCell():New( oSecCab, "CR_APROV"   , "QRY2", "Aprov."          ,, 40,.f.,{||POSICIONE("SAK",1,XFILIAL("SAK")+("QRY2")->CR_APROV,"AK_NOME")})
		TRCell():New( oSecCab, "CR_NIVEL"   , "QRY2")//, "Nํvel"              ,, 10,.f.,,,,,,,,,,)
		TRCell():New( oSecCab, "CR_STATUS"  , "QRY2")//, "Status"             ,, 25,.f.,,,,,,,,,,)
		TRCell():New( oSecCab, "CR_DATALIB" , "QRY2")//, "Dt.Lib"             ,, 20,.f.,,,,,,,,,,)  

		TRFunction():New(oSecCab:Cell("C7_NUM"),,"COUNT",,,,,.F.,.T.,.F.,oSecCab)
	EndIf	

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBSLR001  บAutor  ณ William Souza      บ Data ณ 17/12/2018   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function PrintReport(oReport,nTipo)

	Local cQuery     := ""

	Pergunte(cPerg,.F.)

	if nTipo == 1

		//query para trazer as solicita็๕es de compra

		cQuery += "SELECT DISTINCT		" + CRLF
		cQuery += "                     " + CRLF
		cQuery += "		A.C1_FILIAL,    " + CRLF
		cQuery += "		D.DBM_TIPO,	    " + CRLF
		cQuery += "		A.C1_TPSC,      " + CRLF
		cQuery += "		A.C1_NUM,	    " + CRLF
		cQuery += "		A.C1_ITEM,      " + CRLF
		cQuery += "		A.C1_PRODUTO,   " + CRLF
		cQuery += "		A.C1_DESCRI,    " + CRLF
		cQuery += "		A.C1_QUANT, 	" + CRLF 
		cQuery += "		A.C1_VUNIT,     " + CRLF
		cQuery += "		A.C1_EMISSAO,   " + CRLF
		cQuery += "		A.C1_DATPRF,    " + CRLF
		cQuery += "		A.C1_OBS,	    " + CRLF
		cQuery += "		A.C1_SOLICIT,   " + CRLF
		cQuery += "		D.DBM_APROV,    " + CRLF
		cQuery += "		E.AK_LOGIN,	    " + CRLF
		cQuery += "		C.CR_DATALIB,   " + CRLF
		cQuery += "		B.C7_NUM,	    " + CRLF
		cQuery += "		B.C7_FORNECE,   " + CRLF
		cQuery += "		I.A2_NOME,	    " + CRLF
		cQuery += "		B.C7_ITEM,      " + CRLF
		cQuery += "		B.C7_PRODUTO,   " + CRLF
		cQuery += "		B.C7_DESCRI,    " + CRLF
		cQuery += "		B.C7_QUANT, 	" + CRLF 
		cQuery += "		B.C7_PRECO,     " + CRLF
		cQuery += "		B.C7_TOTAL,     " + CRLF
		cQuery += "		B.C7_EMISSAO,   " + CRLF
		cQuery += "		B.C7_DATPRF,    " + CRLF
		cQuery += "		B.C7_OBS,	    " + CRLF
		cQuery += "		B.C7_SOLICIT,   " + CRLF
		cQuery += "		B.C7_COMPRA,	" + CRLF
		cQuery += "		J.Y1_NOME,		" + CRLF
		cQuery += "		B.C7_RESIDUO,	" + CRLF
		cQuery += "		H.D1_DOC,	    " + CRLF
//		cQuery += "		H.D1_FORNECE,   " + CRLF
//		cQuery += "		I.A2_NOME,	    " + CRLF
		cQuery += "		H.D1_EMISSAO,   " + CRLF
		cQuery += "		H.D1_DTDIGIT,   " + CRLF		
		cQuery += "   	A.C1_CONTA,	    " + CRLF
		cQuery += " 	G.CT1_DESC01,   " + CRLF
		cQuery += "   	A.C1_CC,	    " + CRLF
		cQuery += " 	F.CTT_DESC01    " + CRLF

		cQuery += " FROM  " + RetSqlName("SC1") + "  A			"  + CRLF 
		
		cQuery += " LEFT JOIN " + RetSqlName("SC7") + " B ON	" + CRLF
		cQuery += " 	B.C7_FILIAL = A.C1_FILIAL AND			" + CRLF
		cQuery += " 	B.C7_NUM = A.C1_PEDIDO AND				" + CRLF
		cQuery += " 	B.C7_NUMSC = A.C1_NUM AND				" + CRLF
		cQuery += " 	B.C7_PRODUTO = A.C1_PRODUTO AND			" + CRLF
		cQuery += " 	B.D_E_L_E_T_ = ''
		
		cQuery += "	LEFT JOIN " + RetSqlName("SCR") + " C ON	" + CRLF
		cQuery += "		C.CR_FILIAL  =  A.C1_FILIAL   AND		" + CRLF
		cQuery += "		C.CR_NUM     =  A.C1_NUM      AND 		" + CRLF
		cQuery += "		C.D_E_L_E_T_ = ''						" + CRLF
		
		cQuery += "	LEFT JOIN " + RetSqlName("DBM") + " D ON	" + CRLF
		cQuery += "		D.DBM_FILIAL = C.CR_FILIAL 	AND			" + CRLF
		cQuery += "		D.DBM_TIPO	 = C.CR_TIPO   	AND			" + CRLF
		cQuery += "		D.DBM_NUM    = C.CR_NUM    	AND			" + CRLF
		cQuery += "		D.DBM_ITEM   = A.C1_ITEM   	AND			" + CRLF
		cQuery += "		D.DBM_GRUPO	 = C.CR_GRUPO  	AND			" + CRLF
		cQuery += "		D.DBM_ITGRP	 = C.CR_ITGRP  	AND			" + CRLF
		cQuery += "		D.DBM_USER	 = C.CR_USER	AND			" + CRLF
		cQuery += "		D.DBM_USAPRO = C.CR_APROV	AND			" + CRLF
		cQuery += "		D.D_E_L_E_T_ = ''

		cQuery += " LEFT JOIN  " + RetSqlName("SAK") + " E ON	" + CRLF
		cQuery += "		E.AK_COD  = D.DBM_USAPRO AND			" + CRLF
		cQuery += "		E.AK_USER = D.DBM_USER	 AND			" + CRLF
		cQuery += "		E.D_E_L_E_T_ = '' 						" + CRLF
		
		cQuery += " LEFT JOIN " + RetSqlName("CTT") + " F ON	" + CRLF 
		cQuery += "		F.CTT_CUSTO = A.C1_CC AND				" + CRLF
		cQuery += "		F.D_E_L_E_T_ = ''						" + CRLF

		cQuery += " LEFT JOIN " + RetSqlName("CT1") + " G ON	" + CRLF
		cQuery += "		G.CT1_CONTA = A.C1_CONTA  AND 			" + CRLF
		cQuery += "		G.D_E_L_E_T_ = '' 						" + CRLF

		cQuery += "	LEFT JOIN " + RetSqlName("SD1") + " H ON	" + CRLF
		cQuery += "		H.D1_FILIAL  = B.C7_FILIAL AND  		" + CRLF
		cQuery += "		H.D1_PEDIDO  = B.C7_NUM AND				" + CRLF
		cQuery += "		H.D1_FORNECE = B.C7_FORNECE AND			" + CRLF
		cQuery += "		H.D1_LOJA    = B.C7_LOJA AND			" + CRLF
		cQuery += "		H.D1_COD     = B.C7_PRODUTO AND			" + CRLF
		cQuery += "		H.D1_ITEMPC	 = B.C7_ITEM AND			" + CRLF
		cQuery += "		H.D_E_L_E_T_ = ''             			" + CRLF

		cQuery += "	LEFT JOIN " + RetSqlName("SA2") + " I ON	" + CRLF
		cQuery += "		I.A2_COD = B.C7_FORNECE AND				" + CRLF
		cQuery += "		I.D_E_L_E_T_ = ''						" + CRLF
		
		cQuery += "	LEFT JOIN " + RetSqlName("SY1") + " J ON	" + CRLF
		cQuery += "		J.Y1_COD = B.C7_COMPRA					" + CRLF

		cQuery += " WHERE " + CRLF 
		cQuery += " 	A.C1_FILIAL BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "' AND" + CRLF 

		If !Empty(mv_par03) .and. !Empty(mv_par04)
			cQuery += " A.C1_EMISSAO BETWEEN '" + dtos(mv_par03) + "' AND '" + dtos(mv_par04) + "' AND" + CRLF
		EndIF

		cQuery += " D.DBM_TIPO   =	'SC' AND " + CRLF
		cQuery += " A.C1_RESIDUO <>	'S'  AND " + CRLF

		If mv_par05 == 1
			cQuery += " A.C1_APROV   =       'L' AND " + CRLF
			cQuery += " D.DBM_APROV  =       '" + cvaltochar(mv_par05) + "' AND " + CRLF
		ElseIf mv_par05 == 2 .Or. mv_par05 == 3
			cQuery += " A.C1_APROV   =       'B' AND " + CRLF
			cQuery += " D.DBM_APROV  =       '" + cvaltochar(mv_par05) + "' AND " + CRLF   
		EndIf

		cQuery += " 	A.C1_NUM BETWEEN '" + mv_par06 + "' AND '" + mv_par07 + "' AND" + CRLF 
		cQuery += " 	A.C1_PRODUTO BETWEEN '" + mv_par08 + "' AND '" + mv_par09 + "'" + CRLF

		cQuery += " ORDER BY " + CRLF
		cQuery += "		A.C1_FILIAL, A.C1_NUM, A.C1_ITEM " + CRLF

		cQuery := ChangeQuery(cQuery)

		If Select("QRY") > 0
			Dbselectarea("QRY")
			QRY->(DbClosearea())
		EndIf

		TcQuery cQuery New Alias "QRY"

		//oSecCab:BeginQuery()
		//oSecCab:EndQuery({{"QRY"},cQuery})    
		oSecCab:Print()

	Else

		//query para trazer o pedido de compra
		cQuery += " SELECT " + CRLF 
		cQuery += " 	A.C7_FILIAL, " + CRLF 
		cQuery += " 	A.C7_FORNECE +"+"'-'"+"+ A.C7_LOJA as 'FORNECE', " + CRLF  
		//cQuery += " 	, " + CRLF 
		cQuery += " 	A.C7_EMISSAO, " + CRLF   
		cQuery += " 	A.C7_NUMSC, " + CRLF 
		cQuery += " 	A.C7_NUM,  " + CRLF 
		cQuery += " 	A.C7_ITEM,  " + CRLF 
		//cQuery += " 	A.C7_PRODUTO, " + CRLF  
		cQuery += " 	RTRIM(A.C7_PRODUTO) +"+"'-'"+"+ A.C7_DESCRI AS 'PRODUTO', " + CRLF  
		cQuery += " 	A.C7_QUANT, " + CRLF  
		cQuery += " 	B.CR_USER, " + CRLF 
		cQuery += " 	A.C7_CC,  " + CRLF 
		cQuery += " 	A.C7_OBS, " + CRLF 
		//		cQuery += " 	B.CR_PRAZO, " + CRLF  
		cQuery += " 	B.CR_APROV, " + CRLF 
		cQuery += " 	B.CR_NIVEL, " + CRLF 
		cQuery += " 	B.CR_STATUS, " + CRLF 
		cQuery += " 	B.CR_DATALIB " + CRLF 
		cQuery += " FROM SC7010 A " + CRLF 

		cQuery += " INNER JOIN  SCR010 B  ON " + CRLF 	
		cQuery += " B.CR_NUM     =  A.C7_NUM      AND " + CRLF 
		cQuery += " B.CR_FILIAL  =  A.C7_FILIAL    AND " + CRLF 
		cQuery += " B.D_E_L_E_T_ = '' " + CRLF 

		cQuery += " WHERE  " + CRLF
		cQuery += " 	A.C7_FILIAL BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "' AND" + CRLF 	

		If !Empty(mv_par03) .and. !Empty(mv_par04)                               
			cQuery += " A.C7_EMISSAO BETWEEN '" + dtos(mv_par03) + "' AND '" + dtos(mv_par04) + "' AND" + CRLF
		EndIF	

		If     mv_par05 == 1 
			// 03=Liberado / 05=Liberado outro usuario
			cQuery += " B.CR_STATUS IN ('03','05')  AND " + CRLF   
		ElseIf mv_par05 == 2 
			// 01=Aguardando nivel anterior / 02=Pendente;
			cQuery += " B.CR_STATUS IN ('01','02')  AND " + CRLF   
		ElseIf mv_par05 == 3 
			// 06=Rejeitado / 04=Bloqueado;
			cQuery += " B.CR_STATUS IN ('04','06')  AND " + CRLF   
		EndIF		

		cQuery += "A.C7_NUM     BETWEEN '" + mv_par06 + "' AND '" + mv_par07 + "' AND" + CRLF 
		cQuery += "A.C7_PRODUTO BETWEEN '" + mv_par08 + "' AND '" + mv_par09 + "' AND " + CRLF 
		cQuery += "A.D_E_L_E_T_ = '' " + CRLF   

		cQuery := ChangeQuery(cQuery)

		If Select("QRY2") > 0
			Dbselectarea("QRY2")
			QRY->(DbClosearea())
		EndIf

		TcQuery cQuery New Alias "QRY2"

		//		oSecCab:BeginQuery()
		//		oSecCab:EndQuery({{"QRY2"},cQuery})    
		oSecCab:Print()

	EndIF

Return Nil

/*---------------------------------------------------*
| Fun็ใo: zPutSX1                                   |
| Desc:   User function para gravar pergunta no SX1 |
*---------------------------------------------------*/

User Function zPutSX1(cGrupo, cOrdem, cTexto, cMVPar, cVariavel, cTipoCamp, nTamanho, nDecimal, cTipoPar, cValid, cF3, cPicture, cDef01, cDef02, cDef03, cDef04, cDef05, cHelp)
	Local aArea       := GetArea()
	Local cChaveHelp  := ""
	Local nPreSel     := 0
	Default cGrupo    := Space(10)
	Default cOrdem    := Space(02)
	Default cTexto    := Space(30)
	Default cMVPar    := Space(15)
	Default cVariavel := Space(6)
	Default cTipoCamp := Space(1)
	Default nTamanho  := 0
	Default nDecimal  := 0
	Default cTipoPar  := "G"
	Default cValid    := Space(60)
	Default cF3       := Space(6)
	Default cPicture  := Space(40)
	Default cDef01    := Space(15)
	Default cDef02    := Space(15)
	Default cDef03    := Space(15)
	Default cDef04    := Space(15)
	Default cDef05    := Space(15)
	Default cHelp     := ""

	//Se tiver Grupo, Ordem, Texto, Parโmetro, Variแvel, Tipo e Tamanho, continua para a cria็ใo do parโmetro
	If !Empty(cGrupo) .And. !Empty(cOrdem) .And. !Empty(cTexto) .And. !Empty(cMVPar) .And. !Empty(cVariavel) .And. !Empty(cTipoCamp) .And. nTamanho != 0

		//Defini็ใo de variแveis
		cGrupo     := PadR(cGrupo, Len(SX1->X1_GRUPO), " ")           //Adiciona espa็os a direita para utiliza็ใo no DbSeek
		cChaveHelp := "P." + AllTrim(cGrupo) + AllTrim(cOrdem) + "."  //Define o nome da pergunta
		cMVPar     := Upper(cMVPar)                                   //Deixa o MV_PAR tudo em mai๚sculo
		nPreSel    := Iif(cTipoPar == "C", 1, 0)                      //Se for Combo, o pr้-selecionado serแ o Primeiro
		cDef01     := Iif(cTipoPar == "F", "56", cDef01)              //Se for File, muda a defini็ใo para ser tanto Servidor quanto Local
		nTamanho   := Iif(nTamanho > 60, 60, nTamanho)                //Se o tamanho for maior que 60, volta para 60 - Limita็ใo do Protheus
		nDecimal   := Iif(nDecimal > 9,  9,  nDecimal)                //Se o decimal for maior que 9, volta para 9
		nDecimal   := Iif(cTipoPar == "N", nDecimal, 0)               //Se nใo for parโmetro do tipo num้rico, serแ 0 o Decimal
		cTipoCamp  := Upper(cTipoCamp)                                //Deixa o tipo do Campo em mai๚sculo
		cTipoCamp  := Iif(! cTipoCamp $ 'C;D;N;', 'C', cTipoCamp)     //Se o tipo do Campo nใo estiver entre Caracter / Data / Num้rico, serแ Caracter
		cTipoPar   := Upper(cTipoPar)                                 //Deixa o tipo do Parโmetro em mai๚sculo
		cTipoPar   := Iif(Empty(cTipoPar), 'G', cTipoPar)             //Se o tipo do Parโmetro estiver em branco, serแ um Get
		nTamanho   := Iif(cTipoPar == "C", 1, nTamanho)               //Se for Combo, o tamanho serแ 1

		DbSelectArea('SX1')
		SX1->(DbSetOrder(1)) // Grupo + Ordem

		//Se nใo conseguir posicionar, a pergunta serแ criada
		If ! SX1->(DbSeek(cGrupo + cOrdem))
			RecLock('SX1', .T.)
			X1_GRUPO   := cGrupo
			X1_ORDEM   := cOrdem
			X1_PERGUNT := cTexto
			X1_PERSPA  := cTexto
			X1_PERENG  := cTexto
			X1_VAR01   := cMVPar
			X1_VARIAVL := cVariavel
			X1_TIPO    := cTipoCamp
			X1_TAMANHO := nTamanho
			X1_DECIMAL := nDecimal
			X1_GSC     := cTipoPar
			X1_VALID   := cValid
			X1_F3      := cF3
			X1_PICTURE := cPicture
			X1_DEF01   := cDef01
			X1_DEFSPA1 := cDef01
			X1_DEFENG1 := cDef01
			X1_DEF02   := cDef02
			X1_DEFSPA2 := cDef02
			X1_DEFENG2 := cDef02
			X1_DEF03   := cDef03
			X1_DEFSPA3 := cDef03
			X1_DEFENG3 := cDef03
			X1_DEF04   := cDef04
			X1_DEFSPA4 := cDef04
			X1_DEFENG4 := cDef04
			X1_DEF05   := cDef05
			X1_DEFSPA5 := cDef05
			X1_DEFENG5 := cDef05
			X1_PRESEL  := nPreSel

			//Se tiver Help da Pergunta
			If !Empty(cHelp)
				X1_HELP    := ""

				fPutHelp(cChaveHelp, cHelp)
			EndIf
			SX1->(MsUnlock())
		EndIf
	EndIf

	RestArea(aArea)
Return

/*---------------------------------------------------*
| Fun็ใo: fPutHelp                                  |
| Desc:   Fun็ใo que insere o Help do Parametro     |
*---------------------------------------------------*/

Static Function fPutHelp(cKey, cHelp, lUpdate)
	Local cFilePor  := "SIGAHLP.HLP"
	Local cFileEng  := "SIGAHLE.HLE"
	Local cFileSpa  := "SIGAHLS.HLS"
	Local nRet      := 0
	Default cKey    := ""
	Default cHelp   := ""
	Default lUpdate := .F.

	//Se a Chave ou o Help estiverem em branco
	If Empty(cKey) .Or. Empty(cHelp)
		Return
	EndIf

	//**************************** Portugu๊s
	nRet := SPF_SEEK(cFilePor, cKey, 1)

	//Se nใo encontrar, serแ inclusใo
	If nRet < 0
		SPF_INSERT(cFilePor, cKey, , , cHelp)

		//Senใo, serแ atualiza็ใo
	Else
		If lUpdate
			SPF_UPDATE(cFilePor, nRet, cKey, , , cHelp)
		EndIf
	EndIf



	//**************************** Ingl๊s
	nRet := SPF_SEEK(cFileEng, cKey, 1)

	//Se nใo encontrar, serแ inclusใo
	If nRet < 0
		SPF_INSERT(cFileEng, cKey, , , cHelp)

		//Senใo, serแ atualiza็ใo
	Else
		If lUpdate
			SPF_UPDATE(cFileEng, nRet, cKey, , , cHelp)
		EndIf
	EndIf

	//**************************** Espanhol
	nRet := SPF_SEEK(cFileSpa, cKey, 1)

	//Se nใo encontrar, serแ inclusใo
	If nRet < 0
		SPF_INSERT(cFileSpa, cKey, , , cHelp)

		//Senใo, serแ atualiza็ใo
	Else
		If lUpdate
			SPF_UPDATE(cFileSpa, nRet, cKey, , , cHelp)
		EndIf
	EndIf
Return