#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOPCONN.CH' 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRVEND04   บAutor  Leandro Godoy        บ Data ณ  28/10/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ    Relatorio de or็amentos,em abertos ou nAo.              บฑฑ
ฑฑบ          ณ     Emitidos em uma data ou ranGE especifico				  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Marfinite                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function RVEND04()
	Local cPerg := "RVEND04"          //Nome do Pergunte
	Local aRegs := {} 
	Local cDirDocs  	:= MsDocPath()
	Local cPath	    	:= AllTrim(GetTempPath())
	Local cBuffer   	:= ""
	Local oExcelApp 	:= Nil
	Local nHandle   	:= 0
	Local cArquivo  	:= CriaTrab(,.F.)
	Local cBarra 		:= If(issrvunix(), "/", "\")

	aAdd(aRegs,{cPerg,"01", "Pedido de ?"   		,"","","mv_ch1" , "C" ,09,0,0,"G","","mv_par01" ,"","","","","","","","","","","","","","","","","","","","","","","","","SCJ","","","",""}) 
	aAdd(aRegs,{cPerg,"02", "Pedido ate ?'"	  		,"","","mv_ch2" , "C" ,09,0,0,"G","","mv_par02" ,"","","","","","","","","","","","","","","","","","","","","","","","","SCJ","","","",""})
	aAdd(aRegs,{cPerg,"03", "Cliente de ?'" 	  	,"","","mv_ch3" , "C" ,03,0,0,"G","","mv_par03" ,"","","","","","","","","","","","","","","","","","","","","","","","","SA1","","","",""})
	aAdd(aRegs,{cPerg,"04", "Cliente ate ?'"   		,"","","mv_ch4" , "C" ,03,0,0,"G","","mv_par04" ,"","","","","","","","","","","","","","","","","","","","","","","","","SA1","","","",""})
	aAdd(aRegs,{cPerg,"05", "Emissao de ?"   		,"","","mv_ch5" , "D" ,08,0,0,"G","","mv_par05" ,"","","","","","","","","","","","","","","","","","","","","","","","","","","","",""}) 
	aAdd(aRegs,{cPerg,"06", "Emissao ate ?'" 		,"","","mv_ch6" , "D" ,08,0,0,"G","","mv_par06" ,"","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})


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

	cBuffer := "Relatorio de Entrada de pedidos por periodo"
	FWrite(nHandle, cBuffer+Chr(13)+Chr(10))  



	cBuffer := "ENTRADA;CLIENTE;LOJA;NOME;PEDIDO;VALOR_PEDIDO;VENDEDOR;SUPERVISOR;GERENTE;USUARIO"  

	FWrite(nHandle, cBuffer+Chr(13)+Chr(10))

	QRY->( dbGoTop() )

	While !(QRY->( EOF() ))
		cBuffer := DtoC(StoD(QRY->CJ_EMISSAO)) +";"
		cBuffer += "'"+QRY->CJ_CLIENTE +";"
		cBuffer += "'"+QRY->CJ_LOJA +";"
		cBuffer += QRY->NOME +";"
		cBuffer += "'"+QRY->PEDIDO +";"
		cBuffer += Alltrim(Transform(QRY->VALOR_PEDIDO,"@E 999,999,999.99"))+";"
		cBuffer += QRY->CJ_VEND1 +";"
		cBuffer += QRY->CJ_VEND3 +";"
		cBuffer += QRY->CJ_VEND4 +";"	
		cBuffer += FWLeUserlg("QRY->CJ_USERLGI")+";"    


		FWrite(nHandle, cBuffer+Chr(13)+Chr(10)) 
		QRY->( dbSkip() )
	Enddo



	//FWrite(nHandle, cBuffer+Chr(20))
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

	cQuery +=  "SELECT CJ_EMISSAO, CJ_CLIENTE, CJ_LOJA, A1_NOME NOME , CK_NUM PEDIDO, SUM(CK_VALOR) VALOR_PEDIDO, CJ_VEND1, CJ_VEND3, CJ_VEND4, CJ_USERLGI "+Chr(13)+Chr(10)
	cQuery +=  "FROM "+RetSqlName("SCK")+" SCK, "+RetSqlName("SCJ")+" SCJ, "+RetSqlName("SA1")+" SA1, "+RetSqlName("SF4")+" SF4 "+Chr(13)+Chr(10)
	cQuery +=  "WHERE CJ_FILIAL IN ('01','02','03')"+Chr(13)+Chr(10)
	cQuery +=  "AND SCJ.D_E_L_E_T_ <> '*'"+Chr(13)+Chr(10)
	cQuery +=  "AND SCK.D_E_L_E_T_ <> '*'"+Chr(13)+Chr(10)
	cQuery +=  "AND SA1.D_E_L_E_T_ <> '*'"+Chr(13)+Chr(10)
	cQuery +=  "AND SF4.D_E_L_E_T_ <> '*'"+Chr(13)+Chr(10)

	cQuery +=  "AND CJ_NUM BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'"+Chr(13)+Chr(10)
	cQuery +=  "AND CJ_CLIENTE BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"'"+Chr(13)+Chr(10)
	cQuery +=  "AND CJ_EMISSAO BETWEEN '"+DtoS(MV_PAR05)+"' AND '"+DtoS(MV_PAR06)+"'"+Chr(13)+Chr(10)

	cQuery +=  "AND CK_TES = F4_CODIGO"+Chr(13)+Chr(10)
	cQuery +=  "AND CK_FILIAL = CJ_FILIAL"+Chr(13)+Chr(10)
	cQuery +=  "AND CK_NUM = CJ_NUM"+Chr(13)+Chr(10) 
	cQuery +=  "AND CK_CLIENTE = CJ_CLIENTE"+Chr(13)+Chr(10) 
	cQuery +=  "AND CK_LOJA = CJ_LOJA"+Chr(13)+Chr(10) 


	cQuery +=  "AND A1_FILIAL = CJ_FILIAL"+Chr(13)+Chr(10)
	cQuery +=  "AND A1_COD = CJ_CLIENTE"+Chr(13)+Chr(10)
	cQuery +=  "AND A1_LOJA = CJ_LOJA"+Chr(13)+Chr(10)


	cQuery +=  "GROUP BY CJ_EMISSAO, CJ_CLIENTE, CJ_LOJA, CK_NUM, A1_NOME, CJ_VEND1, CJ_VEND3, CJ_VEND4,CJ_USERLGI"+Chr(13)+Chr(10)
	cQuery +=  "ORDER BY CJ_EMISSAO, CJ_CLIENTE, CJ_LOJA, CK_NUM, A1_NOME, CJ_VEND1, CJ_VEND3, CJ_VEND4,CJ_USERLGI"+Chr(13)+Chr(10)




	If Select("QRY") > 0
		dbSelectArea("QRY")
		dbCloseArea()
	EndIf

	TcQuery cQuery New Alias 'QRY'
	MemoWrite("RVEND04.QRY",cQuery)

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