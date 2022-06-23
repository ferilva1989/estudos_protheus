#include "PROTHEUS.ch"
#include "rwmake.ch"
#include "TOPCONN.CH"      
#include "REPORT.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ BSAPDR01 ³ Autor ³ Diego Fernandes       ³ Data ³ 21/07/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relatorio para avaliacao de desempenho por                 ³±±
±±³          ³ colaborador                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ BSL					                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function BSAPDR01()

	Local _lPdf		  := .T.
	Local cArqPDF    := "BSAPDR01_"+DTOS(dDataBase)+"_"+StrTran(Time(),":","")
	Local _cLocal    := ""

	Private cPerg    := "BSAPDR01"
	Private oPrinter := Nil
	Private oExcelApp:= Nil
	Private cTitle   := "Avaliação por colaborador"
	Private cPasta   := "avaliação por colaborador"
	Private aCols    := ""
	Private cEol     := ""

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
	If _lPdf .And. MV_PAR07 == 1	
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
	Local _aMsg    := {}
	Local _nX      := 0
	Local _cJustifica := ""

	Private oFont14n  := TFont():New('Arial',14,14,,.T.,,,,.T.,.F.)
	Private oFont14   := TFont():New('Arial',14,14,,.F.,,,,.T.,.F.)
	Private oFont10   := TFont():New('Arial',10,10,,.F.,,,,.T.,.F.)
	Private oFont10n  := TFont():New('Arial',10,10,,.T.,,,,.T.,.F.)
	Private oFont08   := TFont():New('Arial',08,08,,.F.,,,,.T.,.F.)
	Private oFont08n  := TFont():New('Arial',08,08,,.T.,,,,.T.,.F.)
	Private cBitmap   := "\System\LGMID01.PNG"
	Private nColFim   := 560
	Private nLinha    := 0030
	Private nColIni   := 0010
	Private nLinQubra := 810
	Private _cCpf     := ""
	Private _cCargo   := ""
	Private _cAvaliador := ""
	Private _nQtdCarac := 110
	Private oBrush    := TBrush():New(,RGB(218,218,218))

	dbSelectarea("TSQL")
	TSQL->(dbGotop())

	While TSQL->(!Eof())

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Posicione no cadastro de funcionarios    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		_cCpf   := ""
		_cCargo := ""
		_cAvaliador := ""

		dbSelectArea("RD0")
		dbSetOrder(1)
		If MsSeek(xFilial("RD0")+TSQL->RDB_CODADO)

			_cCpf := RD0->RD0_CIC

			dbSelectArea("SRA")
			dbSetOrder(5) //cpf
			If MsSeek(xFilial("SRA")+_cCpf)	
				_cCargo := Fdesc("SQ3",SRA->RA_CARGO,"Q3_DESCSUM",30)
			EndIf

		EndIf	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Posiciona no itens avaliados x avaliadores ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		/*dbSelectArea("RDA")
		dbSetOrder(1)
		If MsSeek(xFilial("RDA")+TSQL->RD6_CODIGO+TSQL->RD9_CODADO+TSQL->RD9_CODPRO)
		_cAvaliador := Fdesc("RD0",RDA->RDA_CODDOR,"RD0_NOME",30)
		EndIf*/
		_cAvaliador := Fdesc("RD0",TSQL->RDB_CODDOR,"RD0_NOME",30)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Monta cabecalho do relatorio			    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
		Cabec()					

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Filtra os itens (Perguntas)  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cFilDet := " SELECT RD8_CODMOD, RD8_CODCOM, RD8_ITECOM, RD8_HABIL, RD8_CODQUE, RD8_ORDEM "
		cFilDet += " FROM "+RetSqlName("RD8")+" "
		cFilDet += " WHERE RD8_CODMOD = '"+TSQL->RD6_CODMOD+"' "
		cFilDet += " AND D_E_L_E_T_ = '' "
		cFilDet += " AND RD8_FILIAL = '"+xFilial("RD8")+"' "
		cFilDet += " ORDER BY RD8_ITECOM, RD8_ORDEM "

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Se o alias existir fecha  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If Select("TRD8") > 0
			dbSelectArea("TRD8")
			TRD8->(dbCloseArea())
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Cria alias  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cFilDet),"TRD8",.F.,.T.)

		cItCom := ""

		While TRD8->(!Eof())

			If cItCom <> TRD8->RD8_ITECOM
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ faz a impressão da justificativa      ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ			
				If !Empty(_cJustifica)
					_aMsg := QuebrTxt(_cJustifica, _nQtdCarac)
					For _nX := 1 To Len(_aMsg)

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Quebra de pagina para o mesmo colaborador  ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
						If nLinha > nLinQubra
							Cabec()
							nLinha+=20
						EndIf 

						If _nX  == 1
							oPrinter:Say(nLinha+=0008,nColIni,"Justificativa:",oFont08n)
							oPrinter:Say(nLinha,nColIni+50,_aMsg[_nX],oFont08)
						Else
							oPrinter:Say(nLinha+=0008,nColIni,_aMsg[_nX],oFont08)
						EndIf
					Next _nX
				EndIf
				_cJustifica := ""
				nLinha+=0005

				dbSelectArea("RD2")
				dbSetOrder(1)
				If MsSeek(xFilial("RD2")+TRD8->RD8_CODCOM+TRD8->RD8_ITECOM)

					If MV_PAR07 == 1				
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Quebra de pagina para o mesmo colaborador  ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
						If nLinha > nLinQubra
							Cabec()
							nLinha+=5
						EndIf 

						//oPrinter:Box(nLinha+=003,nColIni-5,nLinha,nColFim)
						oPrinter:FillRect( {nLinha+5, nColIni-4, nLinha+33, nColFim-1}, oBrush )
						oPrinter:Say(nLinha+=0020,nColIni,RD2->RD2_DESC,oFont10n)


						//Auto avaliação 
						oPrinter:Say(nLinha,nColIni+0380,"Auto",oFont10n)
						oPrinter:Say(nLinha+0010,nColIni+0380,"Avaliação",oFont10n)

						//Avaliacao Gestor
						oPrinter:Say(nLinha,nColIni+0435,"Avaliação",oFont10n)
						oPrinter:Say(nLinha+0010,nColIni+0435,"Gestor",oFont10n)

						//Avaliacao Consenso
						oPrinter:Say(nLinha,nColIni+0490,"Avaliação",oFont10n)
						oPrinter:Say(nLinha+0010,nColIni+0490,"Consenso",oFont10n)

					Else

						clinha := ""+";"
						clinha += ""+";"
						clinha += ""+";"
						clinha += ""+";"
						fWrite(cNomTrb,cLinha+cEol)

						clinha := Alltrim(RD2->RD2_DESC) +";"
						clinha += "Auto Avaliação"+";"
						clinha += "Avaliação Gestor"+";"
						clinha += "Avaliação Consenso"+";"
						fWrite(cNomTrb,cLinha+cEol)				

					EndIf	

				EndIf

				cItCom := TRD8->RD8_ITECOM

				nLinha+=0015			
			EndIf

			dbSelectArea("RBG")
			dbSetOrder(1)

			If MsSeek(xFilial("RBG")+TRD8->RD8_HABIL)

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Posiciona no cadastro de habilidades   ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				_cDescri := Alltrim(StrTran(RBG->RBG_XDETHA,CHR(13)+CHR(10),""))

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Retorna o resultado da pesquisa        ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				_aRetResult := GetResult(TRD8->RD8_CODCOM,;
				TRD8->RD8_ITECOM,;
				TSQL->RD6_CODIGO,;
				TSQL->RDB_CODADO,;
				TRD8->RD8_CODQUE,;
				TSQL->RDB_CODDOR)

				_cAvalGest  := Transform(_aRetResult[1],"@E 999")
				_cAutoAval  := Transform(_aRetResult[2],"@E 999")
				_cConsenso  := Transform(_aRetResult[3],"@E 999")
				_cJustifica += " "+_aRetResult[4]

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Realiza a impressão em PDF ou EXCEL    ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ												
				If MV_PAR07 == 1				

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Quebra de pagina para o mesmo colaborador  ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
					If nLinha > nLinQubra
						Cabec()
						nLinha+=5
					EndIf

					oPrinter:Say(nLinha+008,nColIni+0380,_cAutoAval,oFont08) //auto avaliacao
					oPrinter:Say(nLinha+008,nColIni+0435,_cAvalGest,oFont08) //avaliacao gestor
					oPrinter:Say(nLinha+008,nColIni+0490,_cConsenso,oFont08) //consenso				
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Trata mesagem do campo MEMO		      ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					_aMsg := QuebrTxt(_cDescri, _nQtdCarac)

					For _nX := 1 To Len(_aMsg)

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Quebra de pagina para o mesmo colaborador  ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
						If nLinha > nLinQubra
							Cabec()
							nLinha+=5
						EndIf

						If _nX  == 1
							oPrinter:Say(nLinha+=0008,nColIni,"> "+_aMsg[_nX],oFont08)
						Else
							oPrinter:Say(nLinha+=0008,nColIni,_aMsg[_nX],oFont08)
						EndIf
					Next _nX

					nLinha+=0005											

				Else

					clinha := Alltrim(_cDescri) +";"
					clinha += _cAutoAval+";"
					clinha += _cAvalGest+";"
					clinha += _cConsenso+";"
					fWrite(cNomTrb,cLinha+cEol)		

				EndIf

			EndIf

			TRD8->(dbSkip())
		EndDo

		If MV_PAR07 == 1	
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ faz a impressão da justificativa      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ			
			If !Empty(_cJustifica)
				_aMsg := QuebrTxt(_cJustifica, _nQtdCarac)
				For _nX := 1 To Len(_aMsg)

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Quebra de pagina para o mesmo colaborador  ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
					If nLinha > nLinQubra
						Cabec()
						nLinha+=20
					EndIf 

					If _nX  == 1
						oPrinter:Say(nLinha+=0008,nColIni,"Justificativa:",oFont08n)
						oPrinter:Say(nLinha,nColIni+50,_aMsg[_nX],oFont08)
					Else
						oPrinter:Say(nLinha+=0008,nColIni,_aMsg[_nX],oFont08)
					EndIf
				Next _nX
			EndIf
			_cJustifica := ""
			nLinha+=0005

			oPrinter:EndPage()
		Else

			clinha := ""+";"
			clinha += ""+";"
			clinha += ""+";"
			clinha += ""+";"
			fWrite(cNomTrb,cLinha+cEol)

		EndIf

		TSQL->(dbSkip())
	EndDo

	If MV_PAR07 == 1
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
±±ºUso       ³ Promaquina                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fSelDados()

	Local cQuery := ""

	cQuery := " SELECT DISTINCT RD6_CODIGO, RD6_CODMOD, RDB_CODADO, RDB_CODDOR, RD6_CODPER, RDB_CODPRO "
	cQuery += " FROM "+RetSqlName("RD6")+" RD6 "
	cQuery += " LEFT JOIN "+RetSqlName("RDB")+" RDB ON ( RD6_CODIGO = RDB_CODAVA AND RDB.D_E_L_E_T_ = ''  ) "
	cQuery += " WHERE RD6.D_E_L_E_T_ = '' "
	cQuery += " AND RD6_CODIGO BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
	cQuery += " AND RD6_CODMOD BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
	cQuery += " AND RDB_CODADO BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "
	cQuery += " AND RDB_FILIAL = '"+xFilial("RD9")+"' "
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

	PutSx1(cPerg,'01', 'Avaliação de			 ?','' ,'' , 'mv_ch1', 'C', 6, 0, 0, 'G', '', 'RD6', '', ''   , 'mv_par01',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'02', 'Avaliação ate 	 		 ?','' ,'' , 'mv_ch2', 'C', 6, 0, 0, 'G', '', 'RD6', '', ''   , 'mv_par02',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'03', 'Modelo de Avaliação de   ?','' ,'' , 'mv_ch3', 'C', 6, 0, 0, 'G', '', 'RD3', '', ''   , 'mv_par03',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'04', 'Modelo de Avaliação ate  ?','' ,'' , 'mv_ch4', 'C', 6, 0, 0, 'G', '', 'RD3', '', ''   , 'mv_par04',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'05', 'Colaborador de			 ?','' ,'' , 'mv_ch5', 'C', 6, 0, 0, 'G', '', 'RD0', '', ''   , 'mv_par05',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'06', 'Colaborador ate  		 ?','' ,'' , 'mv_ch6', 'C', 6, 0, 0, 'G', '', 'RD0', '', ''   , 'mv_par06',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,"07"  ,"Imprimir? 			     ?","" ,"" ,  "mv_ch7","C" ,1,0,0,"C","","","","","mv_par07","PDF"  ,""      ,""      ,""    ,"Excel" ,""     ,""      ,""    ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")

return
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
Static Function GetResult(cRD8CODCOM, cRD8ITECOM, cRD6CODIGO, cRD9CODADO, cRD8CODQUE, cRDBCODDOR)

	Local cQuery := ""
	Local aRetorno := {0,0,0,""}
	//MSMM(RDB->RDB_CODJUS)

	cQuery := " SELECT RDB_TIPOAV, " 
	cQuery += " 		RDB_RESOBT, "
	cQuery += " 		R_E_C_N_O_ AS RDBREC "
	cQuery += " FROM "+RetSqlName("RDB")+" "
	cQuery += " WHERE RDB_CODAVA = '"+cRD6CODIGO+"' 
	cQuery += " AND RDB_CODADO = '"+cRD9CODADO+"' 
	cQuery += " AND D_E_L_E_T_ = '' 
	cQuery += " AND RDB_CODCOM = '"+cRD8CODCOM+"' 
	cQuery += " AND RDB_ITECOM = '"+cRD8ITECOM+"' 
	cQuery += " AND RDB_CODQUE = '"+cRD8CODQUE+"'"
	cQuery += " AND RDB_CODDOR = '"+cRDBCODDOR+"'
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

		dbSelectArea("RDB")
		dbGoto(TRES->RDBREC)

		If TRES->RDB_TIPOAV == "1"
			aRetorno[1] := 	TRES->RDB_RESOBT  //"Avaliador"		
		ElseIf TRES->RDB_TIPOAV == "2"
			aRetorno[2]	:= 	TRES->RDB_RESOBT//"Auto-Avaliacao"					
		ElseIf TRES->RDB_TIPOAV == "3"
			aRetorno[3]	:= 	TRES->RDB_RESOBT//"Consenso"
		EndIf

		aRetorno[4] += ApdMsMm( RDB->RDB_CODJUS)

		TRES->(dbSkip())
	EndDo

Return(aRetorno)
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

	If MV_PAR07 == 1

		nLinha  := 0030
		nColIni := 0010

		oPrinter:StartPage()

		oPrinter:Box(nLinha,nColIni-5,00100,nColFim)
		oPrinter:Box(00100,nColIni-5,0850,nColFim)		
		nLinha+=0015		
		oPrinter:Say(nLinha,nColIni+250,"STATUS DAS AVALIAÇÕES",oFont10n)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Impressao do LOGO	  	 			    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
		oPrinter:SayBitmap(nLinha,420,cBitmap,0110,0045)

		oPrinter:Say(nLinha,nColIni,"Colaborador: ",oFont10n)
		oPrinter:Say(nLinha,nColIni+100,Capital( Fdesc("RD0",TSQL->RDB_CODADO,"RD0_NOME",50) ),oFont10)

		oPrinter:Say(nLinha+=0010,nColIni,"Cargo: ",oFont10n)
		oPrinter:Say(nLinha,nColIni+100,Capital(_cCargo),oFont10)

		oPrinter:Say(nLinha+=0010,nColIni,"Avaliador:",oFont10n)
		oPrinter:Say(nLinha,nColIni+100,Capital(_cAvaliador),oFont10)

		oPrinter:Say(nLinha+=0010,nColIni,"Descrição:",oFont10n)
		oPrinter:Say(nLinha,nColIni+100,Capital( Fdesc("RD6",TSQL->RD6_CODIGO,"RD6_DESC",50) ),oFont10)

		oPrinter:Say(nLinha+=0010,nColIni,"Modelo da Avaliação:",oFont10n)
		oPrinter:Say(nLinha,nColIni+100,Capital( Fdesc("RD3",TSQL->RD6_CODMOD,"RD3_DESC",50) ),oFont10)

		oPrinter:Say(nLinha+=0010,nColIni,"Período:",oFont10n)
		oPrinter:Say(nLinha,nColIni+100,Capital( Fdesc("RDU",TSQL->RD6_CODPER,"RDU_DESC",50) ),oFont10)

	Else

		clinha := "Colaborador: " + Fdesc("RD0",TSQL->RDB_CODADO,"RD0_NOME",50)+";"
		clinha += ""+";"
		clinha += ""+";"
		clinha += ""+";"
		fWrite(cNomTrb,cLinha+cEol)		

		clinha := "Cargo: " + Capital(_cCargo)+";"
		clinha += ""+";"
		clinha += ""+";"
		clinha += ""+";"
		fWrite(cNomTrb,cLinha+cEol)

		clinha := "Avaliador: " + Capital(_cAvaliador)+";"
		clinha += ""+";"
		clinha += ""+";"
		clinha += ""+";"
		fWrite(cNomTrb,cLinha+cEol)

		clinha := "Descrição: " +  Fdesc("RD6",TSQL->RD6_CODIGO,"RD6_DESC",50)+";"
		clinha += ""+";"
		clinha += ""+";"
		clinha += ""+";"
		fWrite(cNomTrb,cLinha+cEol)

		clinha := "Modelo da Avaliação: " + Capital( Fdesc("RD3",TSQL->RD6_CODMOD,"RD3_DESC",50))+";"
		clinha += ""+";"
		clinha += ""+";"
		clinha += ""+";"
		fWrite(cNomTrb,cLinha+cEol)

		clinha := "Período: " + Capital( Fdesc("RDU",TSQL->RD6_CODPER,"RDU_DESC",50))+";"
		clinha += ""+";"
		clinha += ""+";"
		clinha += ""+";"
		fWrite(cNomTrb,cLinha+cEol)

	Endif

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ QuebrTxt ³ Autor ³ Anderson Messias      ³ Data ³12.07.2016³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Quebra de texto para impressão no relatorio, deve-se passar³±±
±±³          ³ o texto inteiro e o tamanho a ser impresso por linha e a   ³±±
±±³          ³ funcao retorna um arrey com o texto quebrado em linhas     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function QuebrTxt(_cMsg, _nTam)

	Local aRet := {}
	Local cStr := ""
	Local cLin := ""
	Local nPos := 0 

	cLin := _cMsg
	While .T.
		cLin := alltrim(Substr(_cMsg,1,_nTam))
		nPos := RAT("|",cLin) //Pipe informa que é quebra de linha.
		if nPos == 0 //se nao acho o pipe, procuro o ultimo caracter de espaco em branco
			if Len(cLin) >= ((_nTam*80)/100) 
				nPos := RAT(" ",cLin)
			else
				nPos := 0
			endif
		endif
		if nPos > 0
			cStr := Substring(cLin,1,nPos-1)
			aadd(aRet,cStr)
		else
			cStr := cLin
			aadd(aRet,cStr)
			Exit
		endif
		_cMsg := Substring(_cMsg,nPos+1,Len(_cMsg)) //Copio do Espaco em branco para frente.
	EndDo

Return aRet