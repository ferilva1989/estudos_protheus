// Programa:		ATUMOEDAS
// Autor:		Todos que contribuiram com a ideia.
// Data:		27/10/2006
// Objeto:		Atualiza e Projeta Moedas/Cambio
// Uso:			Modulos Contabilidade Gerencial e Financeiro
//			Protheus 8

// Colocar as linhas abaixo no AP8SRV.INI
// [ONSTART]
// jobs=Moedas
// ;Tempo em Segundos 86400=24 horas
// RefreshRate=86400  
//
// [Moedas]
// main=u_AtuMoedas
// Environment=Environment


#include 'protheus.ch'

User Function AtuMoedas()

	Private lAuto		:= .F.
	Private dDataRef, dData
	Private nValDolar, nValYen, nValEuro
	Private nValReal	:= 1.000000
	Private nValUfir	:= 1.064100
	Private nN		:= 0
	Private nS1, nS2, nS3
	Private nI1, nI2, nI3
	Private oDlg
	Private nDiasPro	:= 999
	Private nDiasreg	:= 999

	//Testa se esta sendo rodado do menu
	If	Select('SX2') == 0						
		RPCSetType( 3 )						//N�o consome licensa de uso
		RpcSetEnv('01','01',,,,GetEnvServer(),{ "SM2" })
		sleep( 5000 )						//Aguarda 5 segundos para que as jobs IPC subam.
		ConOut('Atualizando Moedas... '+Dtoc(DATE())+' - '+Time())
		lAuto := .T.
	EndIf

	If	( ! lAuto )
		LjMsgRun(OemToAnsi('Atualiza��o On-line BCB'),,{|| xExecMoeda()} )
	Else
		xExecMoeda()
	EndIf

	If	( lAuto )
		RpcClearEnv()		   				//Libera o Environment
		ConOut('Moedas Atualizadas. '+Dtoc(DATE())+' - '+Time())
	EndIf
Return


Static Function xExecMoeda()
	Local nPass, cFile, cTexto, nLinhas, cLinha, cdata, cCompra, cVenda, J, K, L

	For nPass := 5 to 0 step -1					//Refaz os ultimos 6 dias. O BCB n�o disponibiliza periodo maior de uma semana
		dDataRef := dDataBase - nPass

		//Feriados Banc�rio Fixo
		If ( Dtos(dDataRef) == STR(Year(Date()),4)+'0101' )	//Dia Mundial da Paz
			cFile := Dtos(dDataRef - 1)+'.csv'
		ElseIf	Dtos(dDataRef) == STR(Year(Date()),4)+'0421'	//Dia de Tiradentes
			cFile := Dtos(dDataRef - 1)+'.csv'
		ElseIf	Dtos(dDataRef) == STR(Year(Date()),4)+'0501'	//Dia do Trabalho
			cFile := Dtos(dDataRef - 1)+'.csv'
		ElseIf	Dtos(dDataRef) == STR(Year(Date()),4)+'0907'	//Dia da Independencia
			cFile := Dtos(dDataRef - 1)+'.csv'
		ElseIf	Dtos(dDataRef) == STR(Year(Date()),4)+'1012'	//Dia da N. Sra. Aparecida
			cFile := Dtos(dDataRef - 1)+'.csv'
		ElseIf	Dtos(dDataRef) == STR(Year(Date()),4)+'1102'	//Dia de Finados
			cFile := Dtos(dDataRef - 1)+'.csv'
		ElseIf	Dtos(dDataRef) == STR(Year(Date()),4)+'1115'	//Dia da Proclama��o da Republica
			cFile := Dtos(dDataRef - 1)+'.csv'
		ElseIf	Dtos(dDataRef) == STR(Year(Date()),4)+'1225'	//Natal
			cFile := Dtos(dDataRef - 1)+'.csv'
		ElseIf	Dtos(dDataRef) == STR(Year(Date()),4)+'1231'	//Dia sem Expediente Banc�rio
			cFile := Dtos(dDataRef - 1)+'.csv'		
			//Feriado Banc�rio Vari�vel 2007. Rever Anualmente
		ElseIf	Dtos(dDataRef) == STR(Year(Date()),4)+'0219'	//Segunda de Carnaval
			cFile := Dtos(dDataRef - 1)+'.csv'		
		ElseIf	Dtos(dDataRef) == STR(Year(Date()),4)+'0220'	//Ter�a de Carnaval
			cFile := Dtos(dDataRef - 1)+'.csv'		
		ElseIf	Dtos(dDataRef) == STR(Year(Date()),4)+'0406'	//Sexta-Feira da Paix�o
			cFile := Dtos(dDataRef - 1)+'.csv'		
		ElseIf	Dtos(dDataRef) == STR(Year(Date()),4)+'0607'	//Corpus Christi
			cFile := Dtos(dDataRef - 1)+'.csv'		
			//Finais de Semana
		ElseIf	Dow(dDataRef) == 1				//Se for domingo
			cFile := Dtos(dDataRef - 2)+'.csv'
		ElseIf	Dow(dDataRef) == 7  				//Se for sabado
			cFile := Dtos(dDataRef - 1)+'.csv'
			//Dias Normais
		Else							//Se for dia normal
			cFile := Dtos(dDataRef)+'.csv'	
		EndIf

		cTexto  := HttpGet('https://www4.bcb.gov.br/Download/fechamento/'+cFile)
		If	( lAuto )
			ConOut('DownLoading from BCB '+cFile+' In '+Dtoc(DATE()))
		EndIf

		If ! Empty(cTexto)
			nLinhas := MLCount(cTexto, 81)
			For J	:= 1 to nLinhas
				cLinha	:= Memoline(cTexto,81,j)
				cData  	:= Substr(cLinha,1,10)
				cCompra := StrTran(Substr(cLinha,22,14),',','.')//Caso a empresa use o Valor de Compra nas linhas abaixo substitua por esta vari�vel
				cVenda  := StrTran(Substr(cLinha,37,14),',','.')//Para convers�o interna nas empresas normalmente usa-se Valor de Venda

				If	( Substr(cLinha,12,3)=='220' )	//Seleciona o Valor do Dolar
					dData		:= Ctod(cData)
					nValDolar	:= Val(cVenda)
				EndIf

				If	( Substr(cLinha,12,3)=='470' )	//Seleciona o Valor do Yen
					nValYen		:= Val(cVenda)
				EndIf

				If	( Substr(cLinha,12,3)=='978' )	//Seleciona o Valor do Euro
					nValEuro	:= Val(cVenda)
				EndIf
			Next
		Endif     
		GravaDados()                            		//Grava Dados do Per�odo selecionado em "J"
	Next

	If	( Dow(dData) == 6 )					//Se for sexta
		For K := 1 to 2
			dData ++
			GravaDados()	      				//Grava os Valores de Sabado e Domingo, Para calculo da Regress�o
		Next                                                                                              
	EndIf	

	Regressao()							//Executa a Proje��o das Moedas

	For L := 1 to nDiasPro						//Projeta para 10 dias seguintes em JOB. Per�odos muito grande numa economia est�vel causa distor��es
		nN++
		dData ++    
		nValDolar := (nN * nS1) + nI1				//Valor projetado do Dolar
		nValEuro  := (nN * nS2) + nI2				//Valor projetado do Euro
		nValYen	  := (nN * nS3) + nI3				//Valor Projetado do Yen 
		Gravadados()
	Next
Return


Static Function GravaDados()

	DbSelectArea("SM2")						//Grava Moedas
	SM2->(DbSetorder(1))

	If SM2->(DbSeek(Dtos(dData)))
		Reclock('SM2',.F.)
	Else
		Reclock('SM2',.T.)
		SM2->M2_DATA	:= dData
	EndIf
	SM2->M2_MOEDA1	:= nValReal				//Real
	SM2->M2_MOEDA2	:= nValDolar				//Dolar
	SM2->M2_MOEDA3	:= nValUfir				//Ufir
	SM2->M2_MOEDA4	:= nValEuro				//Euro
	SM2->M2_MOEDA5	:= nValYen				//Yen
	SM2->M2_INFORM	:= "S"
	MsUnlock('SM2')

	DbSelectArea('CTP')						//Grava Cambio	
	CTP->(DbSetorder(1))

	If CTP->(DbSeek(xfilial('CTP')+Dtos(dData)+'01'))	//Real
		RecLock('CTP',.F.)		
	Else
		RecLock('CTP',.T.)
		CTP->CTP_DATA	:= dData
	EndIf
	CTP->CTP_MOEDA	:= '01'
	CTP->CTP_TAXA	:= nValReal
	CTP->CTP_BLOQ	:= '2'
	MsUnlock('CTP')

	If CTP->(DbSeek(xfilial('CTP')+Dtos(dData)+'02'))	//Dolar
		RecLock('CTP',.F.)
	Else
		RecLock('CTP',.T.)
		CTP->CTP_DATA	:= dData
	EndIf
	CTP->CTP_MOEDA	:= '02'
	CTP->CTP_TAXA	:= nValDolar
	CTP->CTP_BLOQ	:= '2'
	MsUnlock('CTP')

	If CTP->(DbSeek(xfilial('CTP')+Dtos(dData)+'03'))	//Ufir
		RecLock('CTP',.F.)
	Else
		RecLock('CTP',.T.)
		CTP->CTP_DATA	:= dData
	EndIf
	CTP->CTP_MOEDA	:= '03'
	CTP->CTP_TAXA	:= nValUfir
	CTP->CTP_BLOQ	:= '2'
	MsUnlock('CTP')

	If CTP->(DbSeek(xfilial('CTP')+Dtos(dData)+'04'))	//Euro
		RecLock('CTP',.F.)
	Else
		RecLock('CTP',.T.)
		CTP->CTP_DATA	:= dData
	EndIf
	CTP->CTP_MOEDA	:= '04'
	CTP->CTP_TAXA	:= nValEuro
	CTP->CTP_BLOQ	:= '2'
	MsUnlock('CTP')

	If CTP->(DbSeek(xfilial('CTP')+Dtos(dData)+'05'))	//Yen
		RecLock('CTP',.F.)
	Else
		RecLock('CTP',.T.)
		CTP->CTP_DATA	:= dData
	EndIf
	CTP->CTP_MOEDA	:= '05'
	CTP->CTP_TAXA	:= nValYen
	CTP->CTP_BLOQ	:= '2'
	MsUnlock('CTP')

Return


Static Function Regressao()

	Local nSX       	:= 0
	Local nSY1      	:= 0
	Local nSY2			:= 0
	Local nSY3      	:= 0
	local nSXY1	 		:= 0
	Local nSXY2     	:= 0
	Local nSXY3     	:= 0
	Local nSXX      	:= 0
	Local mPass, nMedx, nMedY1, nMedY2, nMedY3

	If	( ! lAuto )						//Tela de pergunta Dias Proje��o e Dias Regress�o			
		DEFINE MSDIALOG oDlg TITLE "Regress�o Linear" From 415,420 To 500,690 OF oMainWnd PIXEL
		@ 005,012 Say OemToAnsi("Dias Proje��o") SIZE 75,10 OF oDlg PIXEL
		oGet01	:= TGet():New(005,100,bSetGet(nDiasPro),oDlg,25,10,"@E 999",,,,,,,.T.)	
		@ 020,012 Say OemToAnsi("Dias Regressao") SIZE 75,10 OF oDlg PIXEL
		oGet02	:= TGet():New(020,100,bSetGet(nDiasReg),oDlg,25,10,"@E 999",,,,,,,.T.)	
		oButton	:= tButton():New(035,100,"Calcular",oDlg,{||oDlg:End()},24,7,,,,.T.)
		ACTIVATE MSDIALOG oDlg CENTERED
	Else
		nDiasPro	:= 010
		nDiasReg	:= 014
	EndIf

	For mPass := nDiasReg to 0 step -1				//Seleciona os Ultimos 15 Dias em JOB. Per�odos muito grande numa economia est�vel causa distor��es
		dDataRef	:= dData - mPass
		DbSelectArea("SM2")
		SM2->(DbSetorder(1))
		If SM2->(DbSeek(Dtos(dDataRef)))	 	 	//Pesquisa
			nN		:= nN	 + 1			//Quantidade de Vari�veis
			nSX		:= nSX   + nN			//Somatoria de X
			nSY1	:= nSY1  + SM2->M2_MOEDA2		//Somatoria de Y Dolar
			nSY2	:= nSY2  + SM2->M2_MOEDA4		//Somatoria de Y Euro
			nSY3	:= nSY3  + SM2->M2_MOEDA5		//Somatoria de Y Yen
			nSXY1	:= nSXY1 + (nN*SM2->M2_MOEDA2)		//Somatoria de X * Y Dolar
			nSXY2	:= nSXY2 + (nN*SM2->M2_MOEDA4)		//Somatoria de X * Y Euro
			nSXY3	:= nSXY3 + (nN*SM2->M2_MOEDA5)		//Somatoria de X * Y Yen
			nSXX	:= nSXX  + (nN*nN)			//Somatoria de X Quadrado
		EndIf
	Next

	nMedX	:= nSX 	/ nN						//Media de X
	nMedY1	:= nSY1 / nN						//Media de Y Dolar
	nMedY2	:= nSY2 / nN						//Media de Y Euro
	nMedY3	:= nSY3 / nN						//Media de Y yen

	// DOLAR
	nS1	:= (nN*nSXY1 - (nSX*nSY1)) / (nN*nSXX-(nSX*nSX))	//Coeficiente de X Na Equa��o
	nI1	:= nMedY1 - (nS1*nMedX)					//Ponto que a reta toca Eixo X

	// EURO
	nS2	:= (nN*nSXY2 - (nSX*nSY2)) / (nN*nSXX-(nSX*nSX))	//Coeficiente de X Na Equa��o
	nI2	:= nMedY2 - (nS2*nMedX)					//Ponto que a reta toca Eixo X

	// YEN
	nS3	:= (nN*nSXY3 - (nSX*nSY3)) / (nN*nSXX-(nSX*nSX))	//Coeficiente de X Na Equa��o
	nI3	:= nMedY3 - (nS3*nMedX)					//Ponto que a reta toca Eixo X

Return