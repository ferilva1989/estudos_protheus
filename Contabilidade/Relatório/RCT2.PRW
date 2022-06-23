#INCLUDE "rwmake.ch"                                     
#INCLUDE "protheus.ch"
#INCLUDE "totvs.ch"
#INCLUDE "Topconn.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"
#include "APWEBSRV.CH"   
#include "APWEBEX.CH" 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRVEND03L  บAutor  Leandro Godoy        บ Data ณ  18/12/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ    Relatorio de Itens Vendidos, em abertos ou nAo.         บฑฑ
ฑฑบ          ณ     com filtro de pedidos carteira                         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Brasil Senior Living                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function RVEND03L()
	Local cPerg := "RVEND01"          //Nome do Pergunte
	Local aRegs := {} 
	Local cDirDocs  	:= MsDocPath()
	Local cPath	    	:= AllTrim(GetTempPath())
	Local cBuffer   	:= ""
	Local oExcelApp 	:= Nil
	Local nHandle   	:= 0
	Local cArquivo  	:= CriaTrab(,.F.)
	Local cBarra 		:= If(issrvunix(), "/", "\")
	Local cNull			:= ''

	/*
	aAdd(aRegs,{cPerg,"01", "Pedido de ?"   		,"","","mv_ch1" , "C" ,09,0,0,"G","","mv_par01" ,"","","","","","","","","","","","","","","","","","","","","","","","","SC5","","","",""}) 
	aAdd(aRegs,{cPerg,"02", "Pedido ate ?'"	  		,"","","mv_ch2" , "C" ,09,0,0,"G","","mv_par02" ,"","","","","","","","","","","","","","","","","","","","","","","","","SC5","","","",""})
	aAdd(aRegs,{cPerg,"03", "Serie de ?'" 		  	,"","","mv_ch3" , "C" ,03,0,0,"G","","mv_par03" ,"","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"04", "Serie ate ?'"   		,"","","mv_ch4" , "C" ,03,0,0,"G","","mv_par04" ,"","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"05", "Data de ?"   		,"","","mv_ch5" , "D" ,08,0,0,"G","","mv_par05" ,"","","","","","","","","","","","","","","","","","","","","","","","","","","","",""}) 
	aAdd(aRegs,{cPerg,"06", "Data ate ?'" 		,"","","mv_ch6" , "D" ,08,0,0,"G","","mv_par06" ,"","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"07", "Somente Faturado ?'"	,"","","mv_ch7" , "N" ,01,0,0,"C","","mv_par07" ,"SIM","","","NAO","","","","","","","","","","","","","","","","","","","","","","","","",""})
	*/

	aAdd(aRegs,{cPerg,"01", "Lote de ?"   		,"","","mv_ch1" , "C" ,09,0,0,"G","","mv_par01" ,"","","","","","","","","","","","","","","","","","","","","","","","","","","","",""}) 
	aAdd(aRegs,{cPerg,"02", "Lote ate ?'"	  	,"","","mv_ch2" , "C" ,09,0,0,"G","","mv_par02" ,"","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"03", "LP de ?'" 		  	,"","","mv_ch3" , "C" ,03,0,0,"G","","mv_par03" ,"","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"04", "LP ate ?'"   		,"","","mv_ch4" , "C" ,03,0,0,"G","","mv_par04" ,"","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"05", "Data de ?"   		,"","","mv_ch5" , "D" ,08,0,0,"G","","mv_par05" ,"","","","","","","","","","","","","","","","","","","","","","","","","","","","",""}) 
	aAdd(aRegs,{cPerg,"06", "Data ate ?'" 		,"","","mv_ch6" , "D" ,08,0,0,"G","","mv_par06" ,"","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

	CriaSx1(aRegs)

	If Pergunte(cPerg) == .F.
		Return
	EndIf     

	GERAQRY()

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Verifica a existencia do msExcel na maquina do usuarioณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If !ApOleClient("MsExcel")
		Aviso(	cCadastro,"Microsoft Excel nใo instalado ou nใo configurado para o Protheus."+Chr(13)+Chr(10)+;
		"Verifique com o Administrador do sistema, "+Chr(13)+Chr(10),{"&Continua"},,"Falta Programa" )
		Return Nil
	EndIf			

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Gera o arquivo em formato .CSV                        ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cArquivo := CriaTrab(,.F.)+".csv" //.csv

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Gera o arquivo em formato .CSV                        ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	nHandle := FCreate(cDirDocs + cBarra + cArquivo)

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Verifica se o arquivo foi gerado corretamente         ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If nHandle == -1
		MsgStop("Nใo foi possํvel criar o arquivo CSV para ser utilizado com o Excel. Verifique as permiss๕es.")
		Return Nil
	EndIf

	cBuffer := "Relatorio CT2 EXCEL por periodo"
	FWrite(nHandle, cBuffer+Chr(13)+Chr(10))  

	cBuffer := "CT2_FILIAL; CT2_DATA; CT2_LOTE; CT2_SBLOTE; CT2_DOC; CT2_LINHA; CT2_MOEDLC; CT2_DC; CT2_DEBITO; CT2_CREDIT; CT2_VALOR; CT2_HIST; CT2_CCD; CT2_CCC; CT2_ITEMD; CT2_ITEMC; CT2_CLVLDB; CT2_CLVLCR; CT2_EMPORI; CT2_FILORI; CT2_TPSALD; CT2_SEQUEN; CT2_MANUAL; CT2_ORIGEM; CT2_ROTINA; CT2_AGLUT; CT2_LP; CT2_SEQHIS; CT2_SEQLAN; CT2_DTLP; CT2_KEY; CT2_DTCV3; CT2_DTCONF; CT2_MLTSLD"
	FWrite(nHandle, cBuffer+Chr(13)+Chr(10))

	QRY->( dbGoTop() )

	While !(QRY->( EOF() ))
		/*
		cBuffer := DtoC(StoD(QRY->C5_EMISSAO)) +";"
		cBuffer += QRY->C5_NUM +";"
		cBuffer += QRY->C5_CLIENTE +";"
		//	cBuffer += QRY->A1_CGC +";"
		cBuffer += Alltrim(Transform(QRY->A1_CGC ,"@E")) +";"
		cBuffer += QRY->A1_NOME +";"
		cBuffer += QRY->A1_EST +";"
		cBuffer += QRY->A1_MUN +";"
		cBuffer += QRY->C5_VEND1 +";"
		cBuffer += QRY->VENDEDOR1 +";" 
		cBuffer += QRY->A1_REGIAO +";"
		cBuffer += QRY->C5_VEND2 +";"
		cBuffer += QRY->VENDEDOR2 +";"
		cBuffer += QRY->C5_VEND3 +";"
		cBuffer += QRY->VENDEDOR3 +";"	
		cBuffer += QRY->C6_ITEM +";"
		//	cBuffer += QRY->C6_PRODUTO +";"
		cBuffer += Alltrim(QRY->C6_PRODUTO) +";"
		cBuffer += QRY->C6_DESCRI +";"
		cBuffer += Alltrim(Transform(QRY->C6_QTDVEN ,"@E 99999999.99")) +";"
		cBuffer += Alltrim(Transform(QRY->C6_PRCVEN ,"@E 999,999,999.99")) +";"
		cBuffer += Alltrim(Transform(QRY->C6_VALOR  ,"@E 999,999,999.99")) +";"
		cBuffer += Alltrim(Transform(QRY->B1_PRV1   ,"@E 999,999,999.99")) +";"
		cBuffer += Alltrim(Transform(QRY->B2_CM1    ,"@E 999,999,999.99")) +";"
		cBuffer += Alltrim(Transform(QRY->B1_PESO   ,"@E 99999999.99")) +";"
		cBuffer += QRY->F4_IPI +";
		cBuffer += Alltrim(Transform(QRY->C6_TOTIPI ,"@E 999,999,999.99")) +";"
		cBuffer += QRY->F4_CODIGO +";
		cBuffer += QRY->F4_X_DESCR +";
		cBuffer += QRY->F4_TEXTO +";
		cBuffer += Alltrim(Transform(QRY->C5_DESC1  ,"@E 999.99")) +";"
		cBuffer += Alltrim(Transform(QRY->C5_DESC2  ,"@E 999.99")) +";"
		cBuffer += Alltrim(Transform(QRY->C5_DESC3  ,"@E 999.99")) +";"
		cBuffer += Alltrim(Transform(QRY->C5_DESC4  ,"@E 999.99")) +";"
		cBuffer += Alltrim(Transform(QRY->C6_DESCONT,"@E 999.99")) +";"
		cBuffer += Alltrim(Transform(QRY->C5_FRETE  ,"@E 999,999,999.99")) +";"
		cBuffer += Alltrim(Transform(QRY->C5_COMIS1 ,"@E 999.99")) +";"
		cBuffer += Alltrim(Transform(QRY->C5_COMIS2 ,"@E 999.99")) +";"
		cBuffer += Alltrim(Transform(QRY->C5_COMIS3 ,"@E 999.99")) +";"
		cBuffer += QRY->C5_CONDPAG +";"  
		cBuffer += QRY->E4_DESCRI +";"  	
		cBuffer += QRY->F4_DUPLIC +";"
		cBuffer += QRY->C5_TPFRETE +";"
		cBuffer += QRY->C5_X_MENPA +";"
		cBuffer += DtoC(StoD(QRY->C6_ENTREG)) +";"		
		cBuffer += QRY->C6_NOTA +";"
		cBuffer += QRY->C6_SERIE +";"
		cBuffer += DtoC(StoD(QRY->C6_DATFAT)) +";"
		cBuffer += Alltrim(Transform(QRY->ATRASO    ,"@E 99999999"))+";"
		cBuffer += QRY->MES_FAT +";"
		If M0_CODIGO <> '24'
		cBuffer += QRY->CANAL +";"
		cBuffer += QRY->GRP_CLI +";"
		cBuffer += QRY->B1_X_CONJU +";"
		cBuffer += QRY->B1_X_MODEL +";"
		ENDIF	
		cBuffer += Alltrim(Transform(QRY->VAL_IPI   ,"@E 999,999,999.99")) +";		
		cBuffer += Alltrim(Transform(QRY->B1_IPI    ,"@E 999,999,999.99")) +";
		cBuffer += Alltrim(Transform(QRY->PESO_TOTAL,"@E 99999999.99")) +";"       	    
		*/

		cBuffer := "CT2_FILIAL; CT2_DATA; CT2_LOTE; CT2_SBLOTE; CT2_DOC; CT2_LINHA; CT2_MOEDLC; CT2_DC; CT2_DEBITO; CT2_CREDIT; CT2_VALOR; CT2_HIST; CT2_CCD; CT2_CCC; CT2_ITEMD; CT2_ITEMC; CT2_CLVLDB; CT2_CLVLCR; CT2_EMPORI; CT2_FILORI; CT2_TPSALD; CT2_SEQUEN; CT2_MANUAL; CT2_ORIGEM; CT2_ROTINA; CT2_AGLUT; CT2_LP; CT2_SEQHIS; CT2_SEQLAN; CT2_DTLP; CT2_KEY; CT2_DTCV3; CT2_DTCONF; CT2_MLTSLD"

		cBuffer := QRY->CT2_FILIAL +";"
		cBuffer += DtoC(StoD(QRY->CT2_DATA)) +";"    
		cBuffer += QRY->CT2_LOTE +";"
		cBuffer += QRY->CT2_SBLOTE +";"
		cBuffer += QRY->CT2_DOC +";"
		cBuffer += QRY->CT2_LINHA +";"
		cBuffer += QRY->CT2_MOEDLC +";"
		cBuffer += QRY->CT2_DC +";"
		cBuffer += QRY->CT2_DEBITO +";"
		cBuffer += QRY->CT2_CREDIT +";"
		cBuffer += Alltrim(Transform(QRY->CT2_VALOR  ,"@E 999,999,999.99")) +";"
		cBuffer += QRY->CT2_HIST +";"
		cBuffer += QRY->CT2_CCD +";"
		cBuffer += QRY->CT2_CCC +";"
		cBuffer += QRY->CT2_ITEMD +";"
		cBuffer += QRY->CT2_ITEMC +";"
		cBuffer += QRY->CT2_EMPORI +";"
		cBuffer += QRY->CT2_FILORI +";"
		cBuffer += QRY->CT2_TPSALD +";"
		cBuffer += QRY->CT2_SEQUEN +";"
		cBuffer += QRY->CT2_MANUAL +";"
		cBuffer += QRY->CT2_ORIGEM +";"
		cBuffer += QRY->CT2_ROTINA +";"
		cBuffer += QRY->CT2_AGLUT +";"    
		cBuffer += QRY->CT2_LP +";"   
		cBuffer += QRY->CT2_SEQLAN +";" 
		cBuffer += QRY->CT2_DTLP +";"
		cBuffer += QRY->CT2_KEY +";"
		cBuffer += QRY->CT2_DTCV3 +";"
		cBuffer += QRY->CT2_DTCONF +";"
		cBuffer += QRY->CT2_MLTSLD +";"

		FWrite(nHandle, cBuffer+Chr(13)+Chr(10)) 
		QRY->( dbSkip() )
	Enddo
	FWrite(nHandle, cBuffer+Chr(20))
	FClose(nHandle)

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Copia o arquivo do servidor para o remote                    ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	CpyS2T(cDirDocs + cBarra + cArquivo, cPath, .T.)

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Ennvio para o Excel                                          ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	oExcelApp := MsExcel():New()
	oExcelApp:WorkBooks:Open(cPath + cArquivo)
	oExcelApp:SetVisible(.T.)
	oExcelApp:Destroy()	

Return

//--------------------------------------------------
Static Function GERAQRY()
	Local cQuery := ""

	cQuery +=  "SELECT CT2_FILIAL, CT2_DATA, CT2_LOTE, CT2_SBLOTE, CT2_DOC, CT2_LINHA, CT2_MOEDLC, CT2_DC, CT2_DEBITO, CT2_CREDIT, CT2_VALOR, CT2_HIST, CT2_CCD, CT2_CCC, CT2_ITEMD, CT2_ITEMC, CT2_CLVLDB, CT2_CLVLCR, CT2_EMPORI, CT2_FILORI, CT2_TPSALD, CT2_SEQUEN, CT2_MANUAL, CT2_ORIGEM, CT2_ROTINA, CT2_AGLUT, CT2_LP, CT2_SEQHIS, CT2_SEQLAN, CT2_DTLP, CT2_KEY, CT2_DTCV3, CT2_DTCONF, CT2_MLTSLD"+Chr(13)+Chr(10)
	cQuery +=  "FROM "+RetSqlName("CT2")+" CT2 "+Chr(13)+Chr(10)
	cQuery +=  "WHERE CT2_FILIAL = '"+xFilial("CT2")+"'"+Chr(13)+Chr(10)
	cQuery +=  "AND CT2_LOTE BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'"+Chr(13)+Chr(10)
	cQuery +=  "AND CT2_LP BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"'"+Chr(13)+Chr(10)
	cQuery +=  "AND CT2_DATA BETWEEN '"+DtoS(MV_PAR05)+"' AND '"+DtoS(MV_PAR06)+"'"+Chr(13)+Chr(10)
	cQuery +=  "AND CT2.D_E_L_E_T_ <> '*'"+Chr(13)+Chr(10)
	cQuery +=  "ORDER BY 1,2,3,4,5,27"+Chr(13)+Chr(10)

	//////                              
	If Select("QRY") > 0
		dbSelectArea("QRY")
		dbCloseArea()
	EndIf

	TcQuery cQuery New Alias 'QRY'
	MemoWrite("RVEND03.QRY",cQuery)

Return                                                 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออออออัออออออออออัออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออปฑฑ
ฑฑบ Programa    ณ CriaSx1  ณ Verifica e cria um novo grupo de perguntas com base nos      บฑฑ
ฑฑบ             ณ          ณ parโmetros fornecidos                                        บฑฑ
ฑฑฬอออออออออออออุออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Solicitante ณ 23.05.05 ณ Modelagem de Dados                                           บฑฑ
ฑฑฬอออออออออออออุออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Autor       ณ 28.04.04 ณ TI0607 - Almir Bandina                                       บฑฑ
ฑฑฬอออออออออออออุออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Produ็ใo    ณ 99.99.99 ณ Ignorado                                                     บฑฑ
ฑฑฬอออออออออออออุออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Parโmetros  ณ ExpA1 = array com o conte๚do do grupo de perguntas (SX1)                บฑฑ
ฑฑฬอออออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Retorno     ณ Nil                                                                     บฑฑ
ฑฑฬอออออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Observa็๕es ณ                                                                         บฑฑ
ฑฑบ             ณ                                                                         บฑฑ
ฑฑฬอออออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Altera็๕es  ณ 99/99/99 - Consultor - Descricao da altera็ใo                           บฑฑ
ฑฑบ             ณ                                                                         บฑฑ
ฑฑศอออออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CriaSx1(aRegs)

	Local aAreaAtu	:= GetArea()
	Local aAreaSX1	:= SX1->(GetArea())
	Local nJ		:= 0
	Local nY		:= 0

	dbSelectArea("SX1")
	dbSetOrder(1)

	For nY := 1 To Len(aRegs)
		If !MsSeek(Padr(aRegs[nY,1],Len(SX1->X1_GRUPO))+aRegs[nY,2])
			RecLock("SX1",.T.)
			For nJ := 1 To FCount()
				If nJ <= Len(aRegs[nY])
					FieldPut(nJ,aRegs[nY,nJ])
				EndIf
			Next nJ
			MsUnlock()
		EndIf
	Next nY

	RestArea(aAreaSX1)
	RestArea(aAreaAtu)

Return(Nil)