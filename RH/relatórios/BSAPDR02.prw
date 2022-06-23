#include 'protheus.ch'
#include "rwmake.ch"
#include "TOPCONN.CH"      
#include "REPORT.CH"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � BSAPDR02 � Autor � Diego Fernandes       � Data � 21/07/09 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Relatorio para avaliacao de desempenho por                 ���
���          � colaborador                                                ���
�������������������������������������������������������������������������Ĵ��
���Uso       � BSL					                                      ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function BSAPDR02()

	Local _lPdf		  := .T.
	Local cArqPDF    := "BSAPDR02_"+DTOS(dDataBase)+"_"+StrTran(Time(),":","")
	Local _cLocal    := ""

	Private cPerg    := PADR("BSAPDR0002",10)
	Private oPrinter := Nil

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
	If _lPdf .And. MV_PAR02 == 1
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
	Local oExcel   := FWMSEXCEL():New()
	Local cTitle 	:= "Avalia��o por colaborador - " + Time() + " - " + DTOC(dDataBase)
	Local cPasta   := "avalia��o por colaborador"
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


	//�����������������������������������������Ŀ
	//�Monta cabecalho do relatorio			    �
	//�������������������������������������������
	Cabec()

	dbSelectarea("TSQL")
	TSQL->(dbGotop())

	While TSQL->(!Eof())

		//���������������������������������������Ŀ
		//�Retorna o resultado da pesquisa        �
		//�����������������������������������������
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fSelDados �Autor  �Diego Fernandes     � Data �  06/21/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � Seleciona os dados a serem impressos                       ���
�������������������������������������������������������������������������͹��
���Uso       � BSL			                                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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

	Local aHelp	:= {}
	PutSx1(cPerg,'01', 'Avalia��o?','' ,'' , 'mv_ch1', 'C', 6, 0, 0, 'G', '', '', '', ''   , 'mv_par01',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,"02"  ,"Imprimir?","" ,"" ,  "mv_ch2","C" ,1,0,0,"C","","","","","mv_par02","PDF"  ,""      ,""      ,""    ,"Excel" ,""     ,""      ,""    ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")             
return

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

	If MV_PAR02 == 1

		nLinha  := 0030
		nColIni := 0010

		oPrinter:StartPage()

		oPrinter:Box(nLinha,nColIni-5,0080,nColFim)
		oPrinter:Box(0080,nColIni-5,0850,nColFim)		
		nLinha+=0015		
		//oPrinter:Say(nLinha,nColIni+250,"STATUS DAS AVALIA��ES",oFont10n)

		//�����������������������������������������Ŀ
		//� Impressao do LOGO	  	 			    �
		//�������������������������������������������	
		oPrinter:SayBitmap(nLinha-10,420,cBitmap,0090,0035)

		oPrinter:Say(nLinha,nColIni,"Avalia��o: ",oFont10n)
		oPrinter:Say(nLinha,nColIni+100,Capital(TSQL->RD6_DESC),oFont10)

		oPrinter:Say(nLinha+=0010,nColIni,"Modelo de avalia��o: ",oFont10n)
		oPrinter:Say(nLinha,nColIni+100,Capital( Fdesc("RD3",TSQL->RD6_CODMOD,"RD3_DESC",50) ),oFont10)

		oPrinter:Say(nLinha+=0010,nColIni,"Per�odo",oFont10n)
		oPrinter:Say(nLinha,nColIni+100,Capital( Fdesc("RDU",TSQL->RD6_CODPER,"RDU_DESC",50) ),oFont10)

		nLinha+= 20

		oPrinter:Say(nLinha+=0020,nColIni+0020,"Participantes",oFont10n)
		//Auto avalia��o 
		oPrinter:Say(nLinha,nColIni+0360,"Auto",oFont10n)
		oPrinter:Say(nLinha+0010,nColIni+0360,"Avalia��o",oFont10n)

		//Avaliacao Gestor
		oPrinter:Say(nLinha,nColIni+0415,"Avalia��o",oFont10n)
		oPrinter:Say(nLinha+0010,nColIni+0415,"Gestor",oFont10n)

		//Avaliacao Consenso
		oPrinter:Say(nLinha,nColIni+0470,"Avalia��o",oFont10n)
		oPrinter:Say(nLinha+0010,nColIni+0470,"Consenso",oFont10n)

		//Avaliacao Consenso
		oPrinter:Say(nLinha,nColIni+0525,"Colaborador",oFont10n)
		oPrinter:Say(nLinha+0010,nColIni+0525,"Avalia Gestor",oFont10n)

		nLinha+=0015	

	Else

		clinha := "Avalia�ao: " + TSQL->RD6_DESC+";"
		clinha += ""+";"
		clinha += ""+";"
		clinha += ""+";"
		fWrite(cNomTrb,cLinha+cEol)		

		clinha := "Modelo de avalia��o: " + Capital(Fdesc("RD3",TSQL->RD6_CODMOD,"RD3_DESC",50))+";"
		clinha += ""+";"
		clinha += ""+";"
		clinha += ""+";"
		fWrite(cNomTrb,cLinha+cEol)

		clinha := "Per�odo: " + Capital(Fdesc("RDU",TSQL->RD6_CODPER,"RDU_DESC",50))+";"
		clinha += ""+";"
		clinha += ""+";"
		clinha += ""+";"
		fWrite(cNomTrb,cLinha+cEol)

		clinha := "Participantes"+";"
		clinha += "Auto avalia��o"+";"
		clinha += "Avalia��o Gestor"+";"
		clinha += "Avalia��o Consenso"+";"	
		fWrite(cNomTrb,cLinha+cEol)

	Endif

Return
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

		If TRES->RDB_TIPOAV == "1"
			aRetorno[1] := "Conclu�do"  //"Avaliador"		
		ElseIf TRES->RDB_TIPOAV == "2"
			aRetorno[2]	:= 	"Conclu�do"//"Auto-Avaliacao"				
		ElseIf TRES->RDB_TIPOAV == "3"
			aRetorno[3]	:= 	"Conclu�do"//"Consenso"		
		EndIf

		TRES->(dbSkip())
	EndDo

Return(aRetorno)