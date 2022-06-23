#include 'protheus.ch'
#include "rwmake.ch"
#include "TOPCONN.CH"      
#include "REPORT.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ BSAPDR02 ³ Autor ³ Diego Fernandes       ³ Data ³ 21/07/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relatorio para avaliacao de desempenho por                 ³±±
±±³          ³ colaborador                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ BSL					                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function BSAPDR02()

	Local _lPdf		  := .T.
	Local cArqPDF    := "BSAPDR02_"+DTOS(dDataBase)+"_"+StrTran(Time(),":","")
	Local _cLocal    := ""

	Private cPerg    := PADR("BSAPDR0002",10)
	Private oPrinter := Nil

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³CRIA PERGUNTAS       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ValPerg(cPerg)
	If !Pergunte(cPerg,.T.)
		Return
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³IMPRESSAO EM PDF     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If _lPdf .And. MV_PAR02 == 1
		lPreview 	:= .F.
		oPrinter	:= FWMSPrinter():New(cArqPDF,6,.F.,,.F.,,,,,,,.T.)
		oPrinter:SetPortrait()
		oPrinter:SetPaperSize(9)
		oPrinter:SetMargin(60,60,60,60)
	Else
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Cria arquivo excel para gerar relatorio  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		_cLocal     := AllTrim(cGetFile("", "Selecione a pasta ",0,"", .F., GETF_RETDIRECTORY+ GETF_LOCALHARD ))
		cArqTxt  	:= _cLocal + CriaTrab(, .F.) + ".CSV"
		cEol		:= CHR(13)+CHR(10)
		cNomTrb		:= FCreate(cArqTxt,0)
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³FILTRA DADOS PARA IMPRESSÃO     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MsgRun("Filtrando dados, aguarde...",,{|| fSelDados() })
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³FAZ A IMPRESSÃO DOS DADOS       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
	MsgRun("Imprimindo relatório, aguarde...",,{|| PrintReport() })

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PrintRepo ºAutor  ³Diego Fernandes     º Data ³  06/21/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Impressão dos dados 						                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Promaquina                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function PrintReport()

	Local cFilDet  := ""
	Local cItCom   := ""
	Local _cDescri := ""
	Local oExcel   := FWMSEXCEL():New()
	Local cTitle 	:= "Avaliação por colaborador - " + Time() + " - " + DTOC(dDataBase)
	Local cPasta   := "avaliação por colaborador"
	Local aCols    := ""

	Private cBitmap   := "\System\LGMID01.PNG"
	Private oFont14n := TFont():New('Arial',14,14,,.T.,,,,.T.,.F.)
	Private oFont14  := TFont():New('Arial',14,14,,.F.,,,,.T.,.F.)
	Private oFont10  := TFont():New('Arial',10,10,,.F.,,,,.T.,.F.)
	Private oFont10n := TFont():New('Arial',10,10,,.T.,,,,.T.,.F.)
	Private oFont08  := TFont():New('Arial',08,08,,.F.,,,,.T.,.F.)
	Private nColFim   := 560
	Private nLinha    := 0030
	Private nColIni   := 0010
	Private nLinQubra := 800
	Private _nQtdCarac := 110
	Private oBrush    := TBrush():New(,RGB(218,218,218))


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Monta cabecalho do relatorio			    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Cabec()

	dbSelectarea("TSQL")
	TSQL->(dbGotop())

	While TSQL->(!Eof())

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Retorna o resultado da pesquisa        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		_aRetResult := GetResult(TSQL->RD6_CODIGO,;
		TSQL->RD9_CODADO)

		_cAvalGest := _aRetResult[1]
		_cAutoAval := _aRetResult[2]
		_cConsenso := _aRetResult[3]

		If MV_PAR02 == 1

			oPrinter:Say(nLinha+=0008,nColIni+0020,Fdesc("RD0",TSQL->RD9_CODADO,"RD0_NOME",30),oFont08)
			oPrinter:Say(nLinha,nColIni+0360,_cAutoAval,oFont08) //auto avaliacao
			oPrinter:Say(nLinha,nColIni+0415,_cAvalGest,oFont08) //avaliacao gestor
			oPrinter:Say(nLinha,nColIni+0470,_cConsenso,oFont08) //consenso
		Else
			clinha := Fdesc("RD0",TSQL->RD9_CODADO,"RD0_NOME",30)+";"
			clinha += _cAutoAval+";"
			clinha += _cAvalGest+";"
			clinha += _cConsenso+";"
			fWrite(cNomTrb,cLinha+cEol)
		EndIf			

		TSQL->(dbSkip())
	EndDo

	If MV_PAR02 == 1
		oPrinter:Preview()
	Else
		FClose(cNomTrb)
		oExcelApp 	:= MsExcel():New()
		oExcelApp	:WorkBooks:Open( cArqTxt ) // Abre uma planilha
		oExcelApp	:SetVisible(.T.)
		lIntExcel 	:= .T.
	EndIf

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fSelDados ºAutor  ³Diego Fernandes     º Data ³  06/21/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Seleciona os dados a serem impressos                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BSL			                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fSelDados()

	Local cQuery := ""

	cQuery := " SELECT RD6_CODIGO, RD6_DESC, RD6_CODMOD, RD9_CODADO, RD6_CODPER, RD9_CODPRO "
	cQuery += " FROM "+RetSqlName("RD6")+" RD6 "
	cQuery += " LEFT JOIN "+RetSqlName("RD9")+" RD9 ON ( RD6_CODIGO = RD9_CODAVA AND RD9.D_E_L_E_T_ = ''  ) "
	cQuery += " WHERE RD6.D_E_L_E_T_ = '' "
	cQuery += " AND RD6_CODIGO = '"+MV_PAR01+"' "
	cQuery += " AND RD9_FILIAL = '"+xFilial("RD9")+"' "
	cQuery += " AND RD6_FILIAL = '"+xFilial("RD6")+"' "

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Se o alias existir fecha  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Select("TSQL") > 0
		dbSelectArea("TSQL")
		TSQL->(dbCloseArea())
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Cria alias  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TSQL",.F.,.T.)     

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ValPerg  ºAutor  ³Diego Fernandes     º Data ³  06/21/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Cria as perguntas 					                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Promaquina                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ValPerg(cPerg)

	Local aHelp	:= {}
	PutSx1(cPerg,'01', 'Avaliação?','' ,'' , 'mv_ch1', 'C', 6, 0, 0, 'G', '', '', '', ''   , 'mv_par01',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,"02"  ,"Imprimir?","" ,"" ,  "mv_ch2","C" ,1,0,0,"C","","","","","mv_par02","PDF"  ,""      ,""      ,""    ,"Excel" ,""     ,""      ,""    ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")             
return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ Cabec    ºAutor  ³Diego Fernandes     º Data ³  06/21/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Faz a impressão do cabecalho do relatorio                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Promaquina                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Cabec()

	If MV_PAR02 == 1

		nLinha  := 0030
		nColIni := 0010

		oPrinter:StartPage()

		oPrinter:Box(nLinha,nColIni-5,0080,nColFim)
		oPrinter:Box(0080,nColIni-5,0850,nColFim)		
		nLinha+=0015		
		//oPrinter:Say(nLinha,nColIni+250,"STATUS DAS AVALIAÇÕES",oFont10n)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Impressao do LOGO	  	 			    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
		oPrinter:SayBitmap(nLinha-10,420,cBitmap,0090,0035)

		oPrinter:Say(nLinha,nColIni,"Avaliação: ",oFont10n)
		oPrinter:Say(nLinha,nColIni+100,Capital(TSQL->RD6_DESC),oFont10)

		oPrinter:Say(nLinha+=0010,nColIni,"Modelo de avaliação: ",oFont10n)
		oPrinter:Say(nLinha,nColIni+100,Capital( Fdesc("RD3",TSQL->RD6_CODMOD,"RD3_DESC",50) ),oFont10)

		oPrinter:Say(nLinha+=0010,nColIni,"Período",oFont10n)
		oPrinter:Say(nLinha,nColIni+100,Capital( Fdesc("RDU",TSQL->RD6_CODPER,"RDU_DESC",50) ),oFont10)

		nLinha+= 20

		oPrinter:Say(nLinha+=0020,nColIni+0020,"Participantes",oFont10n)
		//Auto avaliação 
		oPrinter:Say(nLinha,nColIni+0360,"Auto",oFont10n)
		oPrinter:Say(nLinha+0010,nColIni+0360,"Avaliação",oFont10n)

		//Avaliacao Gestor
		oPrinter:Say(nLinha,nColIni+0415,"Avaliação",oFont10n)
		oPrinter:Say(nLinha+0010,nColIni+0415,"Gestor",oFont10n)

		//Avaliacao Consenso
		oPrinter:Say(nLinha,nColIni+0470,"Avaliação",oFont10n)
		oPrinter:Say(nLinha+0010,nColIni+0470,"Consenso",oFont10n)

		//Avaliacao Consenso
		oPrinter:Say(nLinha,nColIni+0525,"Colaborador",oFont10n)
		oPrinter:Say(nLinha+0010,nColIni+0525,"Avalia Gestor",oFont10n)

		nLinha+=0015	

	Else

		clinha := "Avaliaçao: " + TSQL->RD6_DESC+";"
		clinha += ""+";"
		clinha += ""+";"
		clinha += ""+";"
		fWrite(cNomTrb,cLinha+cEol)		

		clinha := "Modelo de avaliação: " + Capital(Fdesc("RD3",TSQL->RD6_CODMOD,"RD3_DESC",50))+";"
		clinha += ""+";"
		clinha += ""+";"
		clinha += ""+";"
		fWrite(cNomTrb,cLinha+cEol)

		clinha := "Período: " + Capital(Fdesc("RDU",TSQL->RD6_CODPER,"RDU_DESC",50))+";"
		clinha += ""+";"
		clinha += ""+";"
		clinha += ""+";"
		fWrite(cNomTrb,cLinha+cEol)

		clinha := "Participantes"+";"
		clinha += "Auto avaliação"+";"
		clinha += "Avaliação Gestor"+";"
		clinha += "Avaliação Consenso"+";"	
		fWrite(cNomTrb,cLinha+cEol)

	Endif

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ GetResultºAutor  ³Diego Fernandes     º Data ³  06/21/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao para retornar o resulta da pesquisa                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Promaquina                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GetResult(cRD6CODIGO,cRD9CODADO)

	Local cQuery   := ""
	Local aRetorno := {"Pendente","Pendente","Pendente"}

	cQuery := " SELECT RDB_TIPOAV, " 
	cQuery += " 		RDB_RESOBT "
	cQuery += " FROM "+RetSqlName("RDB")+" "
	cQuery += " WHERE RDB_CODAVA = '"+cRD6CODIGO+"' 
	cQuery += " AND RDB_CODADO = '"+cRD9CODADO+"' 
	cQuery += " AND D_E_L_E_T_ = '' 
	cQuery += " AND RDB_FILIAL = '"+xFilial("RDB")+"'
	cQuery += " ORDER BY RDB_TIPOAV "

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Se o alias existir fecha  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Select("TRES") > 0
		dbSelectArea("TRES")
		TRES->(dbCloseArea())
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Cria alias  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRES",.F.,.T.)

	dbSelectArea("TRES")
	TRES->(dbGotop())

	While TRES->(!Eof())

		If TRES->RDB_TIPOAV == "1"
			aRetorno[1] := "Concluído"  //"Avaliador"		
		ElseIf TRES->RDB_TIPOAV == "2"
			aRetorno[2]	:= 	"Concluído"//"Auto-Avaliacao"				
		ElseIf TRES->RDB_TIPOAV == "3"
			aRetorno[3]	:= 	"Concluído"//"Consenso"		
		EndIf

		TRES->(dbSkip())
	EndDo

Return(aRetorno)