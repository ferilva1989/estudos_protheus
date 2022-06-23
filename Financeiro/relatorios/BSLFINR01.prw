#INCLUDE "PROTHEUS.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"      
#INCLUDE "REPORT.CH"             

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ BSLFINR01³ Autor ³ Marcus Ferraz         ³ Data ³ 16/12/16 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relatório de itens do faturamento                          |±±
±±³          ³                                                            |±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ BSL                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

user function BSLFINR01()

	Local oReport
	If TRepInUse()	//verifica se relatorios personalizaveis esta disponivel
		oReport := ReportDef()
		oReport:PrintDialog()	
	EndIf
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ REPORT   ³ Autor ³ Marcus Ferraz         ³ Data ³ 08/02/17 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao Principal de Impressao                               ±±
±±³          ³                                                             ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ BSL                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function ReportDef()

	Local oReport
	Local oSection     

	cPerg    := PADR("BSLFINR01",10)
	ValPerg()
	Pergunte(cPerg,.T.)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Selecao dos dados a Serem Impressos    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MsAguarde({|| fSelDados()},"Selecionando Itens")

	oReport := TReport():New("BSLFINR01","Relatório de Faturamento.",cPerg,{|oReport| PrintReport(oReport)},"Este Relatórios irá imprimir informações dos produtos comprados, para auxilio no faturamento")

	oSection1 := TRSection():New(oReport,OemToAnsi("NF ENTRADA"),{"TEMP"})

	TRCell():New(oSection1,"FILIAL"		,"TEMP","FILIAL"       		,"@!",05)
	TRCell():New(oSection1,"ITEM"		,"TEMP","ITEM"	         	,"@!",04)
	TRCell():New(oSection1,"GRUPO"		,"TEMP","GRUPO" 	       	,"@!",03)
	TRCell():New(oSection1,"PRODUTO"	,"TEMP","PRODUTO" 	       	,"@!",15)
	TRCell():New(oSection1,"DESCR"		,"TEMP","DESCR" 	       	,"@!",30)
	TRCell():New(oSection1,"UNID"		,"TEMP","UNID"	 	       	,"@!",02)
	TRCell():New(oSection1,"QUANT"		,"TEMP","QUANT"	 	       	,"@E 9,999,999.9999",12)
	TRCell():New(oSection1,"VUNIT"		,"TEMP","VUNIT"	 	       	,"@E 999,999,999.9999",14)
	TRCell():New(oSection1,"TOTAL"		,"TEMP","TOTAL"	 	       	,"@E 999,999,999.9999",14)
	TRCell():New(oSection1,"OBS"		,"TEMP","OBS"	 	       	,"@!",30)
	TRCell():New(oSection1,"CCUSTO"		,"TEMP","CCUSTO" 	       	,"@!",20)
	TRCell():New(oSection1,"TES"		,"TEMP","TES"	 	       	,"@!",03)
	TRCell():New(oSection1,"FORNEC"		,"TEMP","FORNEC" 	       	,"@!",06)
	TRCell():New(oSection1,"LOJA"		,"TEMP","LOJA" 	       		,"@!",02)
	TRCell():New(oSection1,"DTENTR"		,"TEMP","DTENTR" 	       	,"@!",08)
	TRCell():New(oSection1,"DOC"		,"TEMP","DOC"	 	       	,"@!",09)
	TRCell():New(oSection1,"SERIE"		,"TEMP","SERIE"	 	       	,"@!",03)
	TRCell():New(oSection1,"EMISSAO"	,"TEMP","EMISSAO" 	       	,"@!",08)
	TRCell():New(oSection1,"DTDIGIT"	,"TEMP","DTDIGIT" 	       	,"@!",08)
	TRCell():New(oSection1,"PEDIDO"		,"TEMP","PEDIDO" 	       	,"@!",06)	



Return oReport

Static Function PrintReport(oReport)

	Local oSection1 := oReport:Section(1)  

	// Selecao dos Itens
	MsAguarde({|| fSelDados()} , "Selecionando Dados") 

	// Impressao 

	DbSelectArea("TEMP")  
	DbGoTop() 
	While  !Eof() 
		oReport:SetMeter(RecCount())
		oSection1:Init()
		If oReport:Cancel()
			Exit
		EndIf
		oSection1:PrintLine()   
		DbSelectArea("TEMP")
		oReport:IncMeter()  
		DbSkip() 
	End
	oSection1:Finish()     
Return



//Selecao dos Dados
Static Function fSelDados()

	// Criacao arquivo de Trabalho Principal
	cQuery  := ''
	_aStru	:= {} 

	AADD(_aStru,{"FILIAL"		,"C",09,0})
	AADD(_aStru,{"ITEM"			,"C",04,0})
	AADD(_aStru,{"GRUPO"		,"C",03,0})
	AADD(_aStru,{"PRODUTO"		,"C",15,0})
	AADD(_aStru,{"DESCR"		,"C",30,0})
	AADD(_aStru,{"UNID"			,"C",02,0})
	AADD(_aStru,{"QUANT"		,"N",12,4})
	AADD(_aStru,{"VUNIT"		,"N",14,2})
	AADD(_aStru,{"TOTAL"		,"N",14,2})
	AADD(_aStru,{"OBS"			,"C",30,0})
	AADD(_aStru,{"CCUSTO"		,"C",20,0})
	AADD(_aStru,{"TES"			,"C",03,0})
	AADD(_aStru,{"FORNEC"		,"C",06,0})
	AADD(_aStru,{"LOJA"			,"C",02,0})
	AADD(_aStru,{"DTENTR"		,"D",08,0})
	AADD(_aStru,{"DOC"			,"C",09,0})
	AADD(_aStru,{"SERIE"		,"C",03,0})
	AADD(_aStru,{"EMISSAO"		,"D",08,0})
	AADD(_aStru,{"DTDIGIT"		,"D",08,0})
	AADD(_aStru,{"PEDIDO"		,"C",06,0})


	_cArq     := CriaTrab(_aStru,.T.)
	_cIndice  := CriaTrab(Nil,.F.)

	If Sele("TEMP") <> 0
		TEMP->(DbCloseArea())
	Endif

	dbUseArea(.T.,,_cArq,"TEMP",.F.,.F.)  

	IndRegua("TEMP",_cIndice,"DOC",,,"Selecionando Registros...")

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Seleciona Dados nas tabelas Correspondentes
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	cQuery := " SELECT  "				+CRLF
	cQuery += " 	D1_FILIAL FILIAL, "	+CRLF
	cQuery += " 	D1_ITEM ITEM,  "	+CRLF
	cQuery += " 	B1_GRUPO GRUPO,  "	+CRLF
	cQuery += " 	B1_COD PRODUTO,  "	+CRLF
	cQuery += " 	B1_DESC DESCR, "	+CRLF
	cQuery += " 	B1_UM UNID, "		+CRLF
	cQuery += " 	D1_QUANT QUANT,  "	+CRLF
	cQuery += " 	D1_VUNIT VUNIT, "	+CRLF
	cQuery += " 	D1_TOTAL TOTAL, "	+CRLF
	cQuery += " 	C7_OBS OBS,  "		+CRLF
	cQuery += " 	D1_CC CCUSTO,  "	+CRLF
	cQuery += " 	D1_TES TES, "		+CRLF
	cQuery += " 	D1_FORNECE FORNEC,"	+CRLF
	cQuery += " 	D1_LOJA LOJA,	"	+CRLF
	cQuery += " 	D1_ZDTETG DTENTR, "	+CRLF
	cQuery += " 	D1_DOC DOC,  "		+CRLF
	cQuery += " 	D1_SERIE SERIE, "	+CRLF
	cQuery += " 	C7_EMISSAO EMISSAO,"+CRLF
	cQuery += " 	D1_DTDIGIT DTDIGIT,"+CRLF
	cQuery += " 	C7_NUM PEDIDO  "	+CRLF
	cQuery += " FROM  "					+CRLF
	cQuery += " 	SD1010 D1, "		+CRLF 
	cQuery += " 	SC7010 C7, "		+CRLF
	cQuery += " 	SB1010 B1  "		+CRLF
	cQuery += " WHERE   "				+CRLF
	cQuery += " 	D1.D_E_L_E_T_ = ' ' "						+CRLF 
	cQuery += " 	AND C7.D_E_L_E_T_ = ' '  "					+CRLF
	cQuery += " 	AND B1.D_E_L_E_T_ = ' '  "					+CRLF
	cQuery += " 	AND D1_FILIAL = C7_FILIAL  "				+CRLF
	cQuery += " 	AND D1_PEDIDO = C7_NUM  "					+CRLF
	cQuery += " 	AND D1_ITEMPC = C7_ITEM  "					+CRLF
	cQuery += " 	AND B1_COD = D1_COD  "						+CRLF
	cQuery += " 	AND D1_FILIAL >= '"+MV_PAR01+"'  "			+CRLF
	cQuery += " 	AND D1_FILIAL <= '"+MV_PAR02+"'  "			+CRLF
	cQuery += " 	AND C7_EMISSAO >= '"+DTOS(MV_PAR03)+"'   "	+CRLF
	cQuery += " 	AND C7_EMISSAO <= '"+DTOS(MV_PAR04)+"'  "	+CRLF
	cQuery += " 	AND D1_FORNECE >= '"+MV_PAR05+"'  "			+CRLF
	cQuery += " 	AND D1_FORNECE <= '"+MV_PAR06+"'  "			+CRLF 
	cQuery += " 	AND D1_LOJA >= '"+MV_PAR07+"'  "			+CRLF
	cQuery += " 	AND D1_LOJA <= '"+MV_PAR08+"'  "			+CRLF
	cQuery += " 	AND D1_PEDIDO >= '"+MV_PAR09+"'  "			+CRLF
	cQuery += " 	AND D1_PEDIDO <= '"+MV_PAR10+"'  "			+CRLF
	cQuery += " 	AND D1_DOC >= '"+MV_PAR11+"'  "				+CRLF
	cQuery += " 	AND D1_DOC <= '"+MV_PAR12+"'  "				+CRLF
	cQuery += " 	AND D1_SERIE >= '"+MV_PAR13+"'  "			+CRLF
	cQuery += " 	AND D1_SERIE <= '"+MV_PAR14+"'  "			+CRLF
	cQuery += " 	AND D1_COD >= '"+MV_PAR15+"'  	"			+CRLF
	cQuery += " 	AND D1_COD <= '"+MV_PAR16+"'  	"			+CRLF
	cQuery += " 	AND B1_GRUPO >= '"+MV_PAR17+"'  	"		+CRLF
	cQuery += " 	AND B1_GRUPO <= '"+MV_PAR18+"'  	"		+CRLF
	cQuery += " 	AND D1_CC >= '"+MV_PAR19+"'  		"		+CRLF
	cQuery += " 	AND D1_CC <= '"+MV_PAR20+"'  		"		+CRLF

	cQuery := ChangeQuery(cQuery)

	If Sele("TSQL")	<> 0
		TSQL->(DbCloseArea())
	Endif

	TCQUERY cQuery NEW ALIAS "TSQL"



	dbSelectArea("TSQL")
	dbGotop()                

	Do While TSQL->(!Eof())

		RecLock("TEMP",.T.)
		TEMP->FILIAL 	:= TSQL->FILIAL
		TEMP->ITEM 		:= TSQL->ITEM
		TEMP->GRUPO 	:= TSQL->GRUPO
		TEMP->PRODUTO 	:= TSQL->PRODUTO
		TEMP->DESCR 	:= TSQL->DESCR
		TEMP->UNID 		:= TSQL->UNID
		TEMP->QUANT 	:= TSQL->QUANT
		TEMP->VUNIT 	:= TSQL->VUNIT
		TEMP->TOTAL 	:= TSQL->TOTAL
		TEMP->OBS 		:= TSQL->OBS
		TEMP->CCUSTO 	:= TSQL->CCUSTO
		TEMP->TES 		:= TSQL->TES
		TEMP->FORNEC 	:= TSQL->FORNEC
		TEMP->DTENTR 	:= StoD(TSQL->DTENTR)
		TEMP->DOC 		:= TSQL->DOC
		TEMP->SERIE 	:= TSQL->SERIE
		TEMP->EMISSAO 	:= StoD(TSQL->EMISSAO)
		TEMP->DTDIGIT 	:= StoD(TSQL->DTDIGIT)
		TEMP->PEDIDO 	:= TSQL->PEDIDO
		TSQL->(DbSkip())
	Enddo   

	If Sele("TSQL")	<> 0
		TSQL->(DbCloseArea())
	Endif


Return  


Static Function ValPerg()

	Local aHelp	:= {}

	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³          Definicao das perguntas do relatorio.               ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	*/

	PutSx1(cPerg, '01', 'Filial de          ?','' ,'' , 'mv_ch1', 'C', 05, 0,0, 'G', '', '', '', '', 'mv_par01',,,'','','','','','','','','','','','','','', ,,) 
	PutSx1(cPerg, '02', 'Filial Ate         ?','' ,'' , 'mv_ch2', 'C', 05, 0,0, 'G', '', '', '', '', 'mv_par02',,,'','','','','','','','','','','','','','', ,,) 
	PutSx1(cPerg, '03', 'Emissao de         ?','' ,'' , 'mv_ch3', 'D', 08, 0,0, 'G', '', '', '', '', 'mv_par03',,,'','','','','','','','','','','','','','', ,,) 
	PutSx1(cPerg, '04', 'Emissao Ate 		?','' ,'' , 'mv_ch4', 'D', 08, 0,0, 'G', '', '', '', '', 'mv_par04',,,'','','','','','','','','','','','','','', ,,) 
	PutSx1(cPerg, '05', 'Fornec de          ?','' ,'' , 'mv_ch5', 'C', 06, 0,0, 'G', '', 'SA2', '', '', 'mv_par05',,,'','','','','','','','','','','','','','', ,,) 
	PutSx1(cPerg, '06', 'Fornec Ate         ?','' ,'' , 'mv_ch6', 'C', 06, 0,0, 'G', '', 'SA2', '', '', 'mv_par06',,,'','','','','','','','','','','','','','', ,,) 
	PutSx1(cPerg, '07', 'Loja de	        ?','' ,'' , 'mv_ch7', 'C', 02, 0,0, 'G', '', '', '', '', 'mv_par07',,,'','','','','','','','','','','','','','', ,,) 
	PutSx1(cPerg, '08', 'Loja Ate           ?','' ,'' , 'mv_ch8', 'C', 02, 0,0, 'G', '', '', '', '', 'mv_par08',,,'','','','','','','','','','','','','','', ,,) 
	PutSx1(cPerg, '09', 'Pedido de	        ?','' ,'' , 'mv_ch9', 'C', 06, 0,0, 'G', '', '', '', '', 'mv_par09',,,'','','','','','','','','','','','','','', ,,) 
	PutSx1(cPerg, '10', 'Pedido Ate         ?','' ,'' , 'mv_cha', 'C', 06, 0,0, 'G', '', '', '', '', 'mv_par10',,,'','','','','','','','','','','','','','', ,,)
	PutSx1(cPerg, '11', 'Nota de	        ?','' ,'' , 'mv_chb', 'C', 09, 0,0, 'G', '', '', '', '', 'mv_par11',,,'','','','','','','','','','','','','','', ,,) 
	PutSx1(cPerg, '12', 'Nota Ate           ?','' ,'' , 'mv_chc', 'C', 09, 0,0, 'G', '', '', '', '', 'mv_par12',,,'','','','','','','','','','','','','','', ,,)                   
	PutSx1(cPerg, '13', 'Serie de	        ?','' ,'' , 'mv_chd', 'C', 03, 0,0, 'G', '', '', '', '', 'mv_par13',,,'','','','','','','','','','','','','','', ,,) 
	PutSx1(cPerg, '14', 'Serie Ate          ?','' ,'' , 'mv_che', 'C', 03, 0,0, 'G', '', '', '', '', 'mv_par14',,,'','','','','','','','','','','','','','', ,,)
	PutSx1(cPerg, '15', 'Produto de         ?','' ,'' , 'mv_chf', 'C', 15, 0,0, 'G', '', 'SB1', '', '', 'mv_par15',,,'','','','','','','','','','','','','','', ,,) 
	PutSx1(cPerg, '16', 'Produto Ate        ?','' ,'' , 'mv_chg', 'C', 15, 0,0, 'G', '', 'SB1', '', '', 'mv_par16',,,'','','','','','','','','','','','','','', ,,)
	PutSx1(cPerg, '17', 'Grupo de	        ?','' ,'' , 'mv_chh', 'C', 03, 0,0, 'G', '', 'SBM', '', '', 'mv_par17',,,'','','','','','','','','','','','','','', ,,) 
	PutSx1(cPerg, '18', 'Grupo Ate  	    ?','' ,'' , 'mv_chi', 'C', 03, 0,0, 'G', '', 'SBM', '', '', 'mv_par18',,,'','','','','','','','','','','','','','', ,,)
	PutSx1(cPerg, '19', 'C. Custo de        ?','' ,'' , 'mv_chj', 'C', 20, 0,0, 'G', '', 'CTT', '', '', 'mv_par19',,,'','','','','','','','','','','','','','', ,,) 
	PutSx1(cPerg, '20', 'C. Custo Ate       ?','' ,'' , 'mv_chk', 'C', 20, 0,0, 'G', '', 'CTT', '', '', 'mv_par20',,,'','','','','','','','','','','','','','', ,,)

	return Nil

return