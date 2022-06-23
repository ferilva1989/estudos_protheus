#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"
#INCLUDE "TOPCONN.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �BSLFATR1  � Autor � Diego Fernandes       � Data � 01/11/11 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Relatorio para conferencia dos adiatamentos                ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Uso       � BSL   		                                              ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function BSLFATR1()

	Local oReport

	Private cPerg    := PADR("BSLFATR1",10)
	Private aAdiant  := {}

	oReport := ReportDef()
	oReport:SetTotalInLine(.F.)
	oReport:PrintDialog()

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � REPORTDEF� Autor � Diego Fernandes       � Data � 21/07/09 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Funcao Principal de Impressao                               ��
���          �                                                             ��
�������������������������������������������������������������������������Ĵ��
���Uso       � Promaquina			                                      ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function ReportDef()

	Local oReport
	Local oSection

	//���������������������Ŀ
	//�CRIA PERGUNTAS       �
	//�����������������������
	ValPerg(cPerg)
	Pergunte(cPerg,.T.)

	//���������������������������������������Ŀ
	//�Selecao dos dados a Serem Impressos    �
	//�����������������������������������������
	MsAguarde({|| fSelDados()},"Selecionando Itens")
	MsAguarde({|| fSelAdian(@aAdiant)},"Seleciona adiantamentos")

	oReport := TReport():New("BSLFATR1","Faturamento",cPerg,{|oReport| PrintReport(oReport)},"Este relatorio ira imprimir a confer�ncia dos adiantamentos!")

	oSection1 := TRSection():New(oReport,OemToAnsi("Faturamento"))

	//�����������������������������Ŀ
	//�Define a estrutura dos campos�
	//�������������������������������       
	TRCell():New(oSection1,"D2_FILIAL","TSQL","Filial","@!",TamSx3("D2_FILIAL")[1])
	TRCell():New(oSection1,"D2_DOC","TSQL","Nota","@!",TamSx3("D2_DOC")[1])
	TRCell():New(oSection1,"D2_SERIE","TSQL","Serie","@!",TamSx3("D2_SERIE")[1]) 
	TRCell():New(oSection1,"E1_VALOR","TSQL","Vlr.Faturado","@E 999,999,999.99",14) 
	TRCell():New(oSection1,"cCliente",,"Cliente","@!",TamSx3("E1_NOMCLI")[1])      
	TRCell():New(oSection1,"",,"ADIANTAMENTOS >>> ","@!",20)
	TRCell():New(oSection1,"cTitulo",,"Titulo","@!",TamSx3("E1_PREFIXO")[1]+TamSx3("E1_NUM")[1]+TamSx3("E1_PARCELA")[1])
	TRCell():New(oSection1,"cTipo",,"Tipo","@!",TamSx3("E1_TIPO")[1])
	TRCell():New(oSection1,"cValor",,"Valor","@!",TamSx3("E1_VALOR")[1])
	TRCell():New(oSection1,"cVencto",,"Vencimento","",TamSx3("E1_VENCREA")[1])
	TRCell():New(oSection1,"cBaixa",,"Baixa","",TamSx3("E1_BAIXA")[1])
	TRCell():New(oSection1,"cHist",,"Historico","@!",TamSx3("E1_HIST")[1])

Return oReport
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PrintRepo �Autor  �Diego Fernandes     � Data �  26/08/16   ���
�������������������������������������������������������������������������͹��
���Desc.     � Impress�o dos dados 						                  ���
�������������������������������������������������������������������������͹��
���Uso       � BSLS		                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function PrintReport(oReport)

	Local oSection1 := oReport:Section(1)
	Local _nPos     := 0

	oSection1:SetTotalInLine(.F.)
	oReport:OnPageBreak(,.T.)

	//���������������������������������������Ŀ
	//� Impressao da Primeira secao	          �
	//�����������������������������������������
	dbSelectArea("TSQL")
	TSQL->(dbGoTop())

	oReport:SetMeter(RecCount())

	While TSQL->(!Eof())	    	

		_nPos	:= aScan(aAdiant, {|x| x[1]+x[2]+x[3] == TSQL->D2_FILIAL + TSQL->D2_CLIENTE + TSQL->D2_LOJA })

		If _nPos > 0

			oSection1:Cell("cCliente"):SetBlock( { || aAdiant[_nPos][8] })
			oSection1:Cell("cTitulo"):SetBlock( { || aAdiant[_nPos][4]+aAdiant[_nPos][5]+aAdiant[_nPos][6] })
			oSection1:Cell("cTipo"):SetBlock( { || aAdiant[_nPos][7] })
			oSection1:Cell("cValor"):SetBlock( { || aAdiant[_nPos][9] })
			oSection1:Cell("cVencto"):SetBlock( { || aAdiant[_nPos][10] })
			oSection1:Cell("cBaixa"):SetBlock( { || aAdiant[_nPos][11] })
			oSection1:Cell("cHist"):SetBlock( { || aAdiant[_nPos][12] })

			oSection1:Init()	

			If oReport:Cancel()
				Exit
			EndIf	                

			oReport:IncMeter()
			oSection1:PrintLine()		                

		EndIf

		TSQL->(dbSkip())		
	EndDo

	oSection1:Finish()

	//���������������������������������������Ŀ
	//� Finaliza area                         �
	//�����������������������������������������
	If Select("TSQL") <> 0
		TSQL->(DbCloseArea())
	Endif

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
Static Function fSelDados(cTipo)

	Local cQuery   := ""             
	//����������������������������Ŀ
	//�Filtra dados da nota fiscal �
	//������������������������������
	cQuery := " SELECT DISTINCT D2_FILIAL, D2_DOC, D2_SERIE, D2_CLIENTE, D2_LOJA, E1_VALOR "
	cQuery += " FROM "+RetSqlName("SD2")+" SD2 "
	cQuery += " LEFT JOIN "+RetSqlName("SE1")+" SE1 ON (E1_FILIAL = D2_FILIAL AND E1_NUM = D2_DOC AND E1_PREFIXO = D2_SERIE AND SE1.D_E_L_E_T_ = '' ) "
	cQuery += " LEFT JOIN "+RetSqlName("SF4")+" SF4 ON (F4_CODIGO = D2_TES AND SF4.D_E_L_E_T_ = '' ) "
	cQuery += " WHERE SD2.D_E_L_E_T_ = '' "
	cQuery += " AND D2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
	cQuery += " AND D2_PEDIDO BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"'	"
	cQuery += " AND D2_DOC BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "
	cQuery += " AND D2_CLIENTE BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"' "
	cQuery += " AND F4_DUPLIC = 'S' "
	cQuery += " ORDER BY D2_CLIENTE "

	If Select("TSQL") > 0
		dbSelectArea("TSQL")
		DbCloseArea()
	EndIf

	//�������������������������������Ŀ
	//� Cria a Query e da Um Apelido  �
	//���������������������������������
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
���Uso       � BSL		                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ValPerg(cPerg)

	Local aHelp	:= {}

	PutSx1(cPerg, '01', 'Emissao de              ?','' ,'' , 'mv_ch1', 'D', 8, 0, 0, 'G', '', '', '', ''   , 'mv_par01',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg, '02', 'Emissao Ate             ?','' ,'' , 'mv_ch2', 'D', 8, 0, 0, 'G', '', '', '', ''   , 'mv_par02',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg, '03', 'Pedido de               ?','' ,'' , 'mv_ch3', 'C', 6, 0, 0, 'G', '', 'SC5', '', ''   , 'mv_par03',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg, '04', 'Pedido ate              ?','' ,'' , 'mv_ch4', 'C', 6, 0, 0, 'G', '', 'SC5', '', ''   , 'mv_par04',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg, '05', 'Nota fiscal de          ?','' ,'' , 'mv_ch5', 'C', 9, 0, 0, 'G', '', 'SF2', '', ''   , 'mv_par05',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg, '06', 'Nota Fiscal ate         ?','' ,'' , 'mv_ch6', 'C', 9, 0, 0, 'G', '', 'SF2', '', ''   , 'mv_par06',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg, '07', 'Cliente de		         ?','' ,'' , 'mv_ch7', 'C', 6, 0, 0, 'G', '', 'SF2', '', ''   , 'mv_par07',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg, '08', 'Cliente ate             ?','' ,'' , 'mv_ch8', 'C', 6, 0, 0, 'G', '', 'SF2', '', ''   , 'mv_par08',,,'','','','','','','','','','','','','','')

Return     
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fSelAdian �Autor  �Diego Fernandes     � Data �  06/21/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao que retorna os adiantamentos realizados em 60 dias  ���
�������������������������������������������������������������������������͹��
���Uso       � BSL		                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function fSelAdian(aAdiant)

	Local cQuery   := ""             
	Local dDataIni := MV_PAR01 - GetNewPar("MV__DIADNT",60)
	//����������������������������Ŀ
	//�Filtra dados da nota fiscal �
	//������������������������������
	cQuery := " SELECT  "
	cQuery += "     E1_FILIAL,  "
	cQuery += "     E1_CLIENTE,  "
	cQuery += "		E1_LOJA,  "
	cQuery += "		E1_NUM,  "
	cQuery += "		E1_PREFIXO, " 
	cQuery += "		E1_PARCELA, "
	cQuery += "		E1_TIPO, "
	cQuery += "		E1_NOMCLI, "
	cQuery += "		E1_VALOR, "
	cQuery += "		E1_VENCREA, "
	cQuery += "		E1_BAIXA, "
	cQuery += "		E1_HIST "
	cQuery += "FROM "+RetSqlName("SE1")+" SE1 "
	cQuery += "WHERE E1_TIPO IN ('BOL','RA') "
	cQuery += "AND E1_EMISSAO >= '"+DTOS(dDataIni)+"' "
	cQuery += "AND D_E_L_E_T_ = '' "
	cQuery += "ORDER BY E1_CLIENTE "

	If Select("TSE1") > 0
		dbSelectArea("TSE1")
		DbCloseArea()
	EndIf

	//�������������������������������Ŀ
	//� Cria a Query e da Um Apelido  �
	//���������������������������������
	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TSE1",.F.,.T.)      

	TCSetFIELD("TSE1","E1_BAIXA","D")
	TCSetFIELD("TSE1","E1_VENCREA","D")
	TCSetFIELD("TSE1","E1_VALOR","N",14,2)

	dbSelectArea("TSE1")
	TSE1->(dbGotop())


	While TSE1->(!Eof())
		AADD( aAdiant, { TSE1->E1_FILIAL,;
		TSE1->E1_CLIENTE,;
		TSE1->E1_LOJA,;
		TSE1->E1_NUM,;  
		TSE1->E1_PREFIXO,;  
		TSE1->E1_PARCELA,; 
		TSE1->E1_TIPO,; 
		TSE1->E1_NOMCLI,;
		TSE1->E1_VALOR,;
		TSE1->E1_VENCREA,; 
		TSE1->E1_BAIXA,; 
		TSE1->E1_HIST } )	     
		TSE1->(dbSkip())
	EndDo

Return
