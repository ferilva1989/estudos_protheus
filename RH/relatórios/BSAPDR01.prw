#include "PROTHEUS.ch"
#include "rwmake.ch"
#include "TOPCONN.CH"      
#include "REPORT.CH"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � BSAPDR01 � Autor � Diego Fernandes       � Data � 21/07/09 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Relatorio para avaliacao de desempenho por                 ���
���          � colaborador                                                ���
�������������������������������������������������������������������������Ĵ��
���Uso       � BSL					                                      ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function BSAPDR01()

	Local _lPdf		  := .T.
	Local cArqPDF    := "BSAPDR01_"+DTOS(dDataBase)+"_"+StrTran(Time(),":","")
	Local _cLocal    := ""

	Private cPerg    := "BSAPDR01"
	Private oPrinter := Nil
	Private oExcelApp:= Nil
	Private cTitle   := "Avalia��o por colaborador"
	Private cPasta   := "avalia��o por colaborador"
	Private aCols    := ""
	Private cEol     := ""

	//���������������������Ŀ
	//�CRIA PERGUNTAS       �
	//�����������������������
	ValPerg(cPerg)
	If !Pergunte(cPerg,.T.)
		Return
	EndIf
	//���������������������Ŀ
	//�IMPRESSAO EM PDF     �
	//�����������������������
	If _lPdf .And. MV_PAR07 == 1	
		lPreview 	:= .F.
		oPrinter	:= FWMSPrinter():New(cArqPDF,6,.F.,,.F.,,,,,,,.T.)
		oPrinter:SetPortrait()
		oPrinter:SetPaperSize(9)
		oPrinter:SetMargin(60,60,60,60)
	Else
		//�����������������������������������������Ŀ
		//�Cria arquivo excel para gerar relatorio  �
		//�������������������������������������������
		_cLocal     := AllTrim(cGetFile("", "Selecione a pasta ",0,"", .F., GETF_RETDIRECTORY+ GETF_LOCALHARD ))
		cArqTxt  	:= _cLocal + CriaTrab(, .F.) + ".CSV"
		cEol		:= CHR(13)+CHR(10)
		cNomTrb		:= FCreate(cArqTxt,0)			
	EndIf

	//��������������������������������Ŀ
	//�FILTRA DADOS PARA IMPRESS�O     �
	//����������������������������������
	MsgRun("Filtrando dados, aguarde...",,{|| fSelDados() })
	//��������������������������������Ŀ
	//�FAZ A IMPRESS�O DOS DADOS       �
	//����������������������������������	
	MsgRun("Imprimindo relat�rio, aguarde...",,{|| PrintReport() })

Return
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PrintRepo �Autor  �Diego Fernandes     � Data �  06/21/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � Impress�o dos dados 						                  ���
�������������������������������������������������������������������������͹��
���Uso       � Promaquina                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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

		//�����������������������������������������Ŀ
		//�Posicione no cadastro de funcionarios    �
		//�������������������������������������������
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
		//�������������������������������������������Ŀ
		//�Posiciona no itens avaliados x avaliadores �
		//���������������������������������������������
		/*dbSelectArea("RDA")
		dbSetOrder(1)
		If MsSeek(xFilial("RDA")+TSQL->RD6_CODIGO+TSQL->RD9_CODADO+TSQL->RD9_CODPRO)
		_cAvaliador := Fdesc("RD0",RDA->RDA_CODDOR,"RD0_NOME",30)
		EndIf*/
		_cAvaliador := Fdesc("RD0",TSQL->RDB_CODDOR,"RD0_NOME",30)

		//�����������������������������������������Ŀ
		//�Monta cabecalho do relatorio			    �
		//�������������������������������������������	
		Cabec()					

		//�����������������������������Ŀ
		//�Filtra os itens (Perguntas)  �
		//�������������������������������
		cFilDet := " SELECT RD8_CODMOD, RD8_CODCOM, RD8_ITECOM, RD8_HABIL, RD8_CODQUE, RD8_ORDEM "
		cFilDet += " FROM "+RetSqlName("RD8")+" "
		cFilDet += " WHERE RD8_CODMOD = '"+TSQL->RD6_CODMOD+"' "
		cFilDet += " AND D_E_L_E_T_ = '' "
		cFilDet += " AND RD8_FILIAL = '"+xFilial("RD8")+"' "
		cFilDet += " ORDER BY RD8_ITECOM, RD8_ORDEM "

		//��������������������������Ŀ
		//�Se o alias existir fecha  �
		//����������������������������
		If Select("TRD8") > 0
			dbSelectArea("TRD8")
			TRD8->(dbCloseArea())
		EndIf
		//������������Ŀ
		//�Cria alias  �
		//��������������
		dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cFilDet),"TRD8",.F.,.T.)

		cItCom := ""

		While TRD8->(!Eof())

			If cItCom <> TRD8->RD8_ITECOM
				//���������������������������������������Ŀ
				//� faz a impress�o da justificativa      �
				//�����������������������������������������			
				If !Empty(_cJustifica)
					_aMsg := QuebrTxt(_cJustifica, _nQtdCarac)
					For _nX := 1 To Len(_aMsg)

						//�������������������������������������������Ŀ
						//�Quebra de pagina para o mesmo colaborador  �
						//���������������������������������������������	
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
						//�������������������������������������������Ŀ
						//�Quebra de pagina para o mesmo colaborador  �
						//���������������������������������������������	
						If nLinha > nLinQubra
							Cabec()
							nLinha+=5
						EndIf 

						//oPrinter:Box(nLinha+=003,nColIni-5,nLinha,nColFim)
						oPrinter:FillRect( {nLinha+5, nColIni-4, nLinha+33, nColFim-1}, oBrush )
						oPrinter:Say(nLinha+=0020,nColIni,RD2->RD2_DESC,oFont10n)


						//Auto avalia��o 
						oPrinter:Say(nLinha,nColIni+0380,"Auto",oFont10n)
						oPrinter:Say(nLinha+0010,nColIni+0380,"Avalia��o",oFont10n)

						//Avaliacao Gestor
						oPrinter:Say(nLinha,nColIni+0435,"Avalia��o",oFont10n)
						oPrinter:Say(nLinha+0010,nColIni+0435,"Gestor",oFont10n)

						//Avaliacao Consenso
						oPrinter:Say(nLinha,nColIni+0490,"Avalia��o",oFont10n)
						oPrinter:Say(nLinha+0010,nColIni+0490,"Consenso",oFont10n)

					Else

						clinha := ""+";"
						clinha += ""+";"
						clinha += ""+";"
						clinha += ""+";"
						fWrite(cNomTrb,cLinha+cEol)

						clinha := Alltrim(RD2->RD2_DESC) +";"
						clinha += "Auto Avalia��o"+";"
						clinha += "Avalia��o Gestor"+";"
						clinha += "Avalia��o Consenso"+";"
						fWrite(cNomTrb,cLinha+cEol)				

					EndIf	

				EndIf

				cItCom := TRD8->RD8_ITECOM

				nLinha+=0015			
			EndIf

			dbSelectArea("RBG")
			dbSetOrder(1)

			If MsSeek(xFilial("RBG")+TRD8->RD8_HABIL)

				//���������������������������������������Ŀ
				//�Posiciona no cadastro de habilidades   �
				//�����������������������������������������
				_cDescri := Alltrim(StrTran(RBG->RBG_XDETHA,CHR(13)+CHR(10),""))

				//���������������������������������������Ŀ
				//�Retorna o resultado da pesquisa        �
				//�����������������������������������������
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

				//���������������������������������������Ŀ
				//�Realiza a impress�o em PDF ou EXCEL    �
				//�����������������������������������������												
				If MV_PAR07 == 1				

					//�������������������������������������������Ŀ
					//�Quebra de pagina para o mesmo colaborador  �
					//���������������������������������������������	
					If nLinha > nLinQubra
						Cabec()
						nLinha+=5
					EndIf

					oPrinter:Say(nLinha+008,nColIni+0380,_cAutoAval,oFont08) //auto avaliacao
					oPrinter:Say(nLinha+008,nColIni+0435,_cAvalGest,oFont08) //avaliacao gestor
					oPrinter:Say(nLinha+008,nColIni+0490,_cConsenso,oFont08) //consenso				
					//���������������������������������������Ŀ
					//� Trata mesagem do campo MEMO		      �
					//�����������������������������������������
					_aMsg := QuebrTxt(_cDescri, _nQtdCarac)

					For _nX := 1 To Len(_aMsg)

						//�������������������������������������������Ŀ
						//�Quebra de pagina para o mesmo colaborador  �
						//���������������������������������������������	
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
			//���������������������������������������Ŀ
			//� faz a impress�o da justificativa      �
			//�����������������������������������������			
			If !Empty(_cJustifica)
				_aMsg := QuebrTxt(_cJustifica, _nQtdCarac)
				For _nX := 1 To Len(_aMsg)

					//�������������������������������������������Ŀ
					//�Quebra de pagina para o mesmo colaborador  �
					//���������������������������������������������	
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fSelDados �Autor  �Diego Fernandes     � Data �  06/21/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � Seleciona os dados a serem impressos                       ���
�������������������������������������������������������������������������͹��
���Uso       � Promaquina                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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

	//��������������������������Ŀ
	//�Se o alias existir fecha  �
	//����������������������������
	If Select("TSQL") > 0
		dbSelectArea("TSQL")
		TSQL->(dbCloseArea())
	EndIf
	//������������Ŀ
	//�Cria alias  �
	//��������������
	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TSQL",.F.,.T.)     

Return
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � ValPerg  �Autor  �Diego Fernandes     � Data �  06/21/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � Cria as perguntas 					                      ���
�������������������������������������������������������������������������͹��
���Uso       � Promaquina                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ValPerg(cPerg)

	PutSx1(cPerg,'01', 'Avalia��o de			 ?','' ,'' , 'mv_ch1', 'C', 6, 0, 0, 'G', '', 'RD6', '', ''   , 'mv_par01',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'02', 'Avalia��o ate 	 		 ?','' ,'' , 'mv_ch2', 'C', 6, 0, 0, 'G', '', 'RD6', '', ''   , 'mv_par02',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'03', 'Modelo de Avalia��o de   ?','' ,'' , 'mv_ch3', 'C', 6, 0, 0, 'G', '', 'RD3', '', ''   , 'mv_par03',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'04', 'Modelo de Avalia��o ate  ?','' ,'' , 'mv_ch4', 'C', 6, 0, 0, 'G', '', 'RD3', '', ''   , 'mv_par04',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'05', 'Colaborador de			 ?','' ,'' , 'mv_ch5', 'C', 6, 0, 0, 'G', '', 'RD0', '', ''   , 'mv_par05',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'06', 'Colaborador ate  		 ?','' ,'' , 'mv_ch6', 'C', 6, 0, 0, 'G', '', 'RD0', '', ''   , 'mv_par06',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,"07"  ,"Imprimir? 			     ?","" ,"" ,  "mv_ch7","C" ,1,0,0,"C","","","","","mv_par07","PDF"  ,""      ,""      ,""    ,"Excel" ,""     ,""      ,""    ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")

return
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � GetResult�Autor  �Diego Fernandes     � Data �  06/21/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao para retornar o resulta da pesquisa                 ���
�������������������������������������������������������������������������͹��
���Uso       � Promaquina                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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

	//��������������������������Ŀ
	//�Se o alias existir fecha  �
	//����������������������������
	If Select("TRES") > 0
		dbSelectArea("TRES")
		TRES->(dbCloseArea())
	EndIf
	//������������Ŀ
	//�Cria alias  �
	//��������������
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � Cabec    �Autor  �Diego Fernandes     � Data �  06/21/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � Faz a impress�o do cabecalho do relatorio                  ���
�������������������������������������������������������������������������͹��
���Uso       � Promaquina                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Cabec()

	If MV_PAR07 == 1

		nLinha  := 0030
		nColIni := 0010

		oPrinter:StartPage()

		oPrinter:Box(nLinha,nColIni-5,00100,nColFim)
		oPrinter:Box(00100,nColIni-5,0850,nColFim)		
		nLinha+=0015		
		oPrinter:Say(nLinha,nColIni+250,"STATUS DAS AVALIA��ES",oFont10n)
		//�����������������������������������������Ŀ
		//� Impressao do LOGO	  	 			    �
		//�������������������������������������������	
		oPrinter:SayBitmap(nLinha,420,cBitmap,0110,0045)

		oPrinter:Say(nLinha,nColIni,"Colaborador: ",oFont10n)
		oPrinter:Say(nLinha,nColIni+100,Capital( Fdesc("RD0",TSQL->RDB_CODADO,"RD0_NOME",50) ),oFont10)

		oPrinter:Say(nLinha+=0010,nColIni,"Cargo: ",oFont10n)
		oPrinter:Say(nLinha,nColIni+100,Capital(_cCargo),oFont10)

		oPrinter:Say(nLinha+=0010,nColIni,"Avaliador:",oFont10n)
		oPrinter:Say(nLinha,nColIni+100,Capital(_cAvaliador),oFont10)

		oPrinter:Say(nLinha+=0010,nColIni,"Descri��o:",oFont10n)
		oPrinter:Say(nLinha,nColIni+100,Capital( Fdesc("RD6",TSQL->RD6_CODIGO,"RD6_DESC",50) ),oFont10)

		oPrinter:Say(nLinha+=0010,nColIni,"Modelo da Avalia��o:",oFont10n)
		oPrinter:Say(nLinha,nColIni+100,Capital( Fdesc("RD3",TSQL->RD6_CODMOD,"RD3_DESC",50) ),oFont10)

		oPrinter:Say(nLinha+=0010,nColIni,"Per�odo:",oFont10n)
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

		clinha := "Descri��o: " +  Fdesc("RD6",TSQL->RD6_CODIGO,"RD6_DESC",50)+";"
		clinha += ""+";"
		clinha += ""+";"
		clinha += ""+";"
		fWrite(cNomTrb,cLinha+cEol)

		clinha := "Modelo da Avalia��o: " + Capital( Fdesc("RD3",TSQL->RD6_CODMOD,"RD3_DESC",50))+";"
		clinha += ""+";"
		clinha += ""+";"
		clinha += ""+";"
		fWrite(cNomTrb,cLinha+cEol)

		clinha := "Per�odo: " + Capital( Fdesc("RDU",TSQL->RD6_CODPER,"RDU_DESC",50))+";"
		clinha += ""+";"
		clinha += ""+";"
		clinha += ""+";"
		fWrite(cNomTrb,cLinha+cEol)

	Endif

Return
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � QuebrTxt � Autor � Anderson Messias      � Data �12.07.2016���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Quebra de texto para impress�o no relatorio, deve-se passar���
���          � o texto inteiro e o tamanho a ser impresso por linha e a   ���
���          � funcao retorna um arrey com o texto quebrado em linhas     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function QuebrTxt(_cMsg, _nTam)

	Local aRet := {}
	Local cStr := ""
	Local cLin := ""
	Local nPos := 0 

	cLin := _cMsg
	While .T.
		cLin := alltrim(Substr(_cMsg,1,_nTam))
		nPos := RAT("|",cLin) //Pipe informa que � quebra de linha.
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