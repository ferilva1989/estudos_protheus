#include 'protheus.ch'
#include 'parmtype.ch'
#include "TopConn.ch"
#include "TBICONN.CH"
#include "TbiCode.ch"
#include "rwmake.CH"

#define CMD_OPENWORKBOOK			1
#define CMD_CLOSEWORKBOOK			2
#define CMD_ACTIVEWORKSHEET	   		3
#define CMD_READCELL				4

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBSLFATA01บAutor  ณMarcus Ferraz       บ Data ณ08/08/2016    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina automatica para cadastro de pedido de venda.        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BSL                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿  
*/

User function BSLFATA01()


	Local aSays 		:= {}
	Local aButtons		:= {}
	Local nOpca 		:= 0     
	Local cCadastro		:= "Rotina de Faturamento"
	Local cFileOpen 	:= ""
	Local cHrIni	:= Time()

	Private cTitulo := "Planilha de Pedidos de Venda"

	//Texto da tela principal.
	AADD(aSays, "Este Programa ira gerar os Pedidos de Venda com as informa็๕es "	)
	AADD(aSays, "da Planilha de Faturamento " 	)
	AADD(aSays, ""	)
	AADD(aSays, ""	)
	AADD(aSays, "BSL"	)

	//Insere os bot๕es na tela e adiciona fun็๕es a eles.
	AADD(aButtons, { 1,.T.,{|| nOpca:= 1, FechaBatch() 			}} )
	AADD(aButtons, { 2,.T.,{|| nOpca:= 0, FechaBatch() 			}} )
	aAdd(aButtons, { 5,.T.,{|| nOpca:= 2, SelArqXls(@cFileOpen) }} )

	//Cria a tela com os bot๕es.
	FormBatch( cCadastro, aSays, aButtons )

	If nOpca == 0 .Or. Empty(Alltrim(cFileOpen))
		Return Nil
	ElseIf nOpca == 1 .And. !Empty(Alltrim(cFileOpen))
		Processa( { ||ImpFATXls(cFileOpen,cHrIni) } )
	Else
		Return Nil
	EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณImpFATXls บAutor  ณMarcus Ferraz       บ Data ณ07/06/2016   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo de sele็ใo  da planilha                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BSL                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿  
*/

Static Function SelArqXls(cFileOpen)

	Local cTitulo  	:= "Selecione o arquivo"
	Local cExtens   := ""

	cExtens   += "Planilha do Microsoft Office Excel    | *.xlsx | "
	cExtens   += "Todos os Arquivos   | *.* | "

	//Seleciona o Local do arquivo                 
	cFileOpen := cGetFile(cExtens,cTitulo,0,,.F.,GETF_ONLYSERVER+GETF_LOCALHARD+GETF_NETWORKDRIVE)

	If !File(cFileOpen)
		MsgAlert("Nenhuma Planilha Selecionada!")
		//Return(cFileOpen)		
	Endif

Return(cFileOpen)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณImpFATXls บAutor  ณMarcus Ferraz       บ Data ณ07/06/2016   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo de importa็ใo da planilha                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BSL                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿  
*/

Static Function ImpFATXls(cCam,cHrIni)

	Local nHdl 		  := ExecInDLLOpen('C:\temp\readexcel.dll')
	Local cBuffer	  := ''
	Local cFile		  := cCam
	Local nIni  	  := 6
	Local nCont		  := 1
	Local aColun	  := {} //array com as colunas a serem lidas
	Local aPlanilha	  := {}
	Local cCodCli		:= ""
	Local cLojCli		:= ""
	Local cFilPed		:= ""
	Local cCodPrd		:= ""
	Local nValUni		:= 0
	Local nVlDesc		:= 0
	Local nQtdPrd		:= 0
	Local nValItm		:= 0
	Local nValDsc		:= 0
	Local cMsgPad		:= ""
	Local nPercP1		:= 0
	Local dVencto1		:= CTOD("  /  /   ")
	Local nPercP2		:= 0
	Local dVencto2		:= CTOD("  /  /   ")
	//Local nPercP3		:= 0
	//Local dVencto3		:= CTOD("  /  /   ")
	//Local nPercP4		:= 0
	//Local dVencto4		:= CTOD("  /  /   ")
	Local cTes			:= ""
	Local cMsgNF		:= ""
	Local cObs			:= ""
	Local cNatur		:= ""
	Local cCondPg		:= ""


	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//|FAZ LEITURA DO EXCEL |
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	While nCont < Len(cFile)
		nAt	:=	AT(";", Substr(cFile, nCont, Len(cFile)) )
		If nAt = 0
			nAt := Len(cFile) + 1
		Endif
		aAdd(aPlanilha, Alltrim(cFile))
		nCont:=nAt+1
	EndDo


	//Faz a Leitura do Excel e salva os dados em um Array
	For nCont := 1 To Len(aPlanilha)

		aColun	:= {}

		If ( nHdl >= 0 ) //Valida se existe a DLL readexcel

			// Carrega o Excel e Abre o arquivo
			cBuffer := cFile + Space(512)
			nBytes  := ExeDLLRun2(nHdl, CMD_OPENWORKBOOK, @cBuffer)

			If ( nBytes < 0 )
				// Erro critico na abertura do arquivo sem msg de erro
				MsgStop('Nใo foi possivel abrir o arquivo : ' + cFile)
			ElseIf ( nBytes > 0 )
				// Erro critico na abertura do arquivo com msg de erro
				MsgStop(Subs(cBuffer, 1, nBytes))
			EndIf

			//Seleciona a worksheet (planilha)
			cBuffer := "Faturamento" + Space(512)
			ExeDLLRun2(nHdl, CMD_ACTIVEWORKSHEET, @cBuffer)

			//Tratamento para verificar se o nome da planilha aberta corresponde ao modelo
			If Alltrim(cBuffer) = "unknown error in command "
				Alert("O nome da planilha nใo corresponde ao esperado para importa็ใo. A planilha deve-se chamar (Faturamento).")
				// Fecha o arquivo e remove o excel da memoria
				cBuffer := Space(512)
				ExeDLLRun2(nHdl, CMD_CLOSEWORKBOOK, @cBuffer)
				ExecInDLLClose(nHdl)
				Return
			Endif

			//nTotal := 1
			cCel   := "A"
			nL   := 1  


			ProcRegua (Len(aPlanilha))
			//Formacao da regua de processamento

			nL := 1

			aPlan1 := {}

			Do while .T.

				IncProc("Lendo a planilha - Linha: " + StrZero(nIni,6) +" de "+StrZero(Len(aPlanilha),4))

				//Carrega a celula B6
				//cCodCli+cLojCli
				cCel := "B"+Alltrim(str(nIni))
				cBuffer := cCel + Space(1024)
				nBytes = ExeDLLRun2(nHdl, CMD_READCELL, @cBuffer)

				//Verifica se o conteudo da celula e diferente de vazio
				If (Alltrim( Subs(cBuffer, 1, nBytes) ) <> "")

					cCodCli := UPPER(Alltrim(Substr(cBuffer,1,6)))
					cLojCli := UPPER(Alltrim(Substr(cBuffer,7,2)))
					aPlan2 := {}

					AAdd(aPlan2,cCodCli)
					AAdd(aPlan2,cLojCli)  


					//cFilPed
					cCel := "D"+Alltrim(str(nIni))
					cBuffer := cCel + Space(1024)
					nBytes = ExeDLLRun2(nHdl, CMD_READCELL, @cBuffer)
					cFilPed := UPPER( Alltrim( Substr(cBuffer, 1, 5) ) )
					AAdd(aPlan2,cFilPed)

					//cCodPrd
					cCel := "F"+Alltrim(str(nIni))
					cBuffer := cCel + Space(1024)
					nBytes = ExeDLLRun2(nHdl, CMD_READCELL, @cBuffer)
					cCodPrd := StrTran(UPPER( Alltrim( Substr(cBuffer, 1, 15) ) ),".","")
					cCodPrd := LimpaDado(cCodPrd)
					AAdd(aPlan2,cCodPrd)

					//nValUni
					cCel := "G"+Alltrim(str(nIni))
					cBuffer := cCel + Space(1024)
					nBytes = ExeDLLRun2(nHdl, CMD_READCELL, @cBuffer)
					nValUni := Val(strtran(cBuffer,",",".")) 
					AAdd(aPlan2,nValUni)

					//nQtdPrd
					cCel := "H"+Alltrim(str(nIni))
					cBuffer := cCel + Space(1024)
					nBytes = ExeDLLRun2(nHdl, CMD_READCELL, @cBuffer)
					nQtdPrd := Val(strtran(cBuffer,",",".")) 
					AAdd(aPlan2,nQtdPrd)

					//nVlDesc
					cCel := "J"+Alltrim(str(nIni))
					cBuffer := cCel + Space(1024)
					nBytes = ExeDLLRun2(nHdl, CMD_READCELL, @cBuffer)
					nVlDesc := Val(strtran(cBuffer,",",".")) 
					AAdd(aPlan2,nVlDesc)

					//cMsgPad
					cCel := "K"+Alltrim(str(nIni))
					cBuffer := cCel + Space(1024)
					nBytes = ExeDLLRun2(nHdl, CMD_READCELL, @cBuffer)
					cMsgPad := StrZero(Val(Substr(cBuffer, 1, 3)),3)
					AAdd(aPlan2,cMsgPad)

					//cPercP1
					cCel := "L"+Alltrim(str(nIni))
					cBuffer := cCel + Space(1024)
					nBytes = ExeDLLRun2(nHdl, CMD_READCELL, @cBuffer)
					nPercP1 := Val(strtran(cBuffer,",",".")) 
					AAdd(aPlan2,nPercP1)

					//dVencto1
					cCel := "M"+Alltrim(str(nIni))
					cBuffer := cCel + Space(1024)
					nBytes = ExeDLLRun2(nHdl, CMD_READCELL, @cBuffer)
					dVencto1 := IIF(Alltrim(cBuffer) == "",CTOD("  /  /   "),CTOD(cBuffer)) 
					AAdd(aPlan2,dVencto1)

					//nPercP2
					cCel := "N"+Alltrim(str(nIni))
					cBuffer := cCel + Space(1024)
					nBytes = ExeDLLRun2(nHdl, CMD_READCELL, @cBuffer)
					nPercP2 := Val(strtran(cBuffer,",",".")) 
					AAdd(aPlan2,nPercP2)

					//dVencto2
					cCel := "O"+Alltrim(str(nIni))
					cBuffer := cCel + Space(1024)
					nBytes = ExeDLLRun2(nHdl, CMD_READCELL, @cBuffer)
					dVencto2 := IIF(Alltrim(cBuffer) == "",CTOD("  /  /   "),CTOD(cBuffer)) 
					AAdd(aPlan2,dVencto2)

					//cTes
					cCel := "P"+Alltrim(str(nIni))
					cBuffer := cCel + Space(1024)
					nBytes = ExeDLLRun2(nHdl, CMD_READCELL, @cBuffer)
					cTes := UPPER( Alltrim( Substr(cBuffer, 1, 3) ) )
					AAdd(aPlan2,cTes)

					//cMsgNF
					cCel := "Q"+Alltrim(str(nIni))
					cBuffer := cCel + Space(1024)
					nBytes = ExeDLLRun2(nHdl, CMD_READCELL, @cBuffer)
					cMsgNF := UPPER( Alltrim( Substr(cBuffer, 1, 100) ) )
					AAdd(aPlan2,cMsgNF)

					//cObs
					cCel := "R"+Alltrim(str(nIni))
					cBuffer := cCel + Space(1024)
					nBytes = ExeDLLRun2(nHdl, CMD_READCELL, @cBuffer)
					cObs := UPPER( Alltrim( Substr(cBuffer, 1, 100) ) )
					AAdd(aPlan2,cObs)

					//cNatur
					cCel := "S"+Alltrim(str(nIni))
					cBuffer := cCel + Space(1024)
					nBytes = ExeDLLRun2(nHdl, CMD_READCELL, @cBuffer)
					cNatur := UPPER( Alltrim( Substr(cBuffer, 1, 20) ) )
					AAdd(aPlan2,cNatur)

					//cCondPg
					cCel := "T"+Alltrim(str(nIni))
					cBuffer := cCel + Space(1024)
					nBytes = ExeDLLRun2(nHdl, CMD_READCELL, @cBuffer)
					cCondPg := UPPER( Alltrim( Substr(cBuffer, 1, 3) ) )
					AAdd(aPlan2,cCondPg)

					//cCCusto
					cCel := "U"+Alltrim(str(nIni))
					cBuffer := cCel + Space(1024)
					nBytes = ExeDLLRun2(nHdl, CMD_READCELL, @cBuffer)
					cCCusto := UPPER( Alltrim( Substr(cBuffer, 1, 20) ) )
					cCCusto := LimpaDado(cCCusto)
					AAdd(aPlan2,cCCusto)

					//cIH
					cCel := "V"+Alltrim(str(nIni))
					cBuffer := cCel + Space(1024)
					nBytes = ExeDLLRun2(nHdl, CMD_READCELL, @cBuffer)
					//cIH := UPPER(Alltrim(cBuffer))
					//cIH := LimpaDado(cIH)
					cIH := Alltrim(Str(Val(cBuffer))) 
					AAdd(aPlan2,cIH)

					//Conteudo da Planilha
					AAdd(aPlan1,aPlan2 )

				Else
					Exit
				EndIf
				nIni++
			Enddo
		Else
			MsgInfo("DLL ReadExcel nใo localizada no server")
			Return()
		EndIf
	Next _nCont

	// Fecha o arquivo e remove o excel da memoria
	cBuffer := Space(512)

	ExeDLLRun2(nHdl, CMD_CLOSEWORKBOOK, @cBuffer)
	ExecInDLLClose(nHdl)

	Processa( {|| GeraPedido(aPlan1,cHrIni)}, "Aguarde...","Gerando Pedidos.", .T. )


Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGeraPedidoบAutor  ณMarcus Ferraz       บ Data ณ12/09/2014   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo de importa็ใo da planilha                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BSL                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿  
*/

Static Function GeraPedido(aImp,cHrIni)

	Local nX		:= 0
	Local aAutoSC5	:= {}
	Local aAutoSC6	:= {}
	Local aLinha	:= {}
	Local cCli 		:= ""
	Local cMsgPad 	:= ""
	Local _cIH		:= ""
	Local _lCabec 	:= .T.
	Local _lPrim	:= .T.
	Local _lUlt		:= .F.
	Local nValTot	:= 0
	Local nVlParc1	:= 0
	Local nVlParc2	:= 0
	Local nVlPedOk	:= 0
	Local nVlPedEr	:= 0
	Local cLog 		:= "Processo Finalizado"+CRLF
	Local cItem 	:= "00"
	Local nQtdPed	:= 0

	PRIVATE lMsErroAuto := .F.

	ProcRegua (Len(aImp))
	//Inicia a Gera็ใo dos Pedidos de Venda
	For nX := 1 to Len(aImp)

		//Valida se serแ gerado o pedido ou se continua montando a linha de Itens.
		If Alltrim(cCli) <> Alltrim(aImp[nX][1])+Alltrim(aImp[nX][2]); 
		.Or. Alltrim(cMsgPad) <> Alltrim(aImp[nX][8]);
		.Or. Alltrim(_cIH) <> Alltrim(aImp[nX][19])

			_lCabec := .T.
			//Pula a primeira linha para nใo gerar o pedido sem dados no array
			If !_lPrim


				If nVlParc1+nVlParc2 < nValTot
					_nVlParc1 := Round(nVlParc1+(nValTot-(nVlParc1+nVlParc2)),2)
				ElseIf nVlParc1+nVlParc2 > nValTot
					_nVlParc1 := Round(nVlParc1-((nVlParc1+nVlParc2)-nValTot),2)
				Else
					_nVlParc1 := Round(nVlParc1,2)
				EndIf

				AAdd( aAutoSC5, { "C5_PARC1" 	,_nVlParc1		, nil } )
				AAdd( aAutoSC5, { "C5_PARC2" 	,nVlParc2		, nil } )

				lMsErroAuto := .F.

				aAutoSC5 := ConfArray(aAutoSC5)

				If Len(aLinha) > 0
					MSExecAuto({|x,y,z| MATA410(x,y,z)},aAutoSC5,aLinha,3)
					If !lMsErroAuto
						nVlPedOk += nValTot
						cLog += "Filial : "+cFilAnt+" Cliente: "+cCli+" IH: "+Substr(Alltrim(_cIH)+space(6),6)+" Pedido: "+SC5->C5_NUM+CRLF
						nQtdPed++
					Else
						MostraErro()
						nVlPedEr += nValTot
						cLog += "Filial : "+cFilAnt+" Cliente: "+cCli+" IH: "+Substr(Alltrim(_cIH)+space(6),6)+" Pedido nใo Gerado!"+CRLF					
					EndIf
				Else
					cLog += "Filial : "+cFilAnt+" Cliente: "+cCli+" IH: "+Substr(Alltrim(_cIH)+space(6),6)+" Desconto total no Pedido"+CRLF
				EndIf
				//Zera as variaveis para Iniciar a montagem do array do novo pedido.
				nVlParc1	:= 0
				nVlParc2	:= 0
				_nVlParc1	:= 0
				nValTot		:= 0
				aAutoSC5	:= {}
				aAutoSC6	:= {}
				aLinha		:= {}
				cItem 		:= "00"
			EndIf
			_lPrim := .F.
		EndIf

		If Len(aImp) == nX
			_lUlt := .T.
		EndIf

		cCli 		:= Alltrim(aImp[nX][1]) + Alltrim(aImp[nX][2])
		cMsgPad 	:= Alltrim(aImp[nX][8])
		_cIH 		:= Alltrim(aImp[nX][19])
		nVlParc1	+= Round(aImp[nX][9],2)
		nVlParc2	+= Round(aImp[nX][11],2)		
		nValTot		+= Round((aImp[nX][5]*aImp[nX][6]) - aImp[nX][7],2)

		cFilAnt		:= aImp[nX][3] 

		IncProc("Gerando Pedido de Venda: " + StrZero(nX,6) +" de "+StrZero(Len(aImp),6))

		If _lCabec

			cDoc := NextNumero("SC5",1,"C5_NUM",.T.)

			AAdd( aAutoSC5, { "C5_NUM"  	,cDoc					, nil } )
			AAdd( aAutoSC5, { "C5_TIPO"    	, "N"					, nil } )
			AAdd( aAutoSC5, { "C5_CLIENTE" 	,aImp[nX][1]			, nil } )
			AAdd( aAutoSC5, { "C5_LOJACLI" 	,aImp[nX][2]			, nil } )
			AAdd( aAutoSC5, { "C5_LOJAENT" 	,aImp[nX][2]			, nil } )
			AAdd( aAutoSC5, { "C5_CONDPAG" 	,aImp[nX][17]			, nil } )
			AAdd( aAutoSC5, { "C5_DATA1" 	,aImp[nX][10]			, nil } )
			AAdd( aAutoSC5, { "C5_DATA2" 	,aImp[nX][12]			, nil } )
			AAdd( aAutoSC5, { "C5_MENNOTA" 	,Alltrim(aImp[nX][14])	, nil } )
			AAdd( aAutoSC5, { "C5_MENPAD" 	,aImp[nX][8]			, nil } )
			AAdd( aAutoSC5, { "C5_NATUREZ" 	,aImp[nX][16]			, nil } )

			_lCabec := .F.

			DbSelectArea("SA1")
			SA1->(DbGoTop())
			SA1->(DbSetOrder(1))
			If SA1->(DbSeek(xFilial("SA1") +aImp[nX][1] + aImp[nX][2]  ) ) .and. !Empty(Alltrim(aImp[nX][18]))
				RecLock("SA1",.F.)
				SA1->A1_XCCREC := Alltrim(aImp[nX][18])
				SA1->(MsUnlock())
			EndIf

		EndIf

		//cItem := Soma1(cItem)
		cItem := StrZero(Val(cItem)+1,2)
		aAutoSC6 := {}
		_cProd := Alltrim(aImp[nX][4])

		nValItm	:= Round(aImp[nX][5]*aImp[nX][6],2)
		//nValDsc	:= Round(aImp[nX][7],2)

		If nValItm > 0
			AAdd( aAutoSC6, { "C6_ITEM"    	,cItem					, nil } )
			AAdd( aAutoSC6, { "C6_PRODUTO" 	,_cProd					, nil } )
			AAdd( aAutoSC6, { "C6_QTDVEN"  	,aImp[nX][6]			, nil } )
			AAdd( aAutoSC6, { "C6_PRCVEN"  	,aImp[nX][5]			, nil } )
			AAdd( aAutoSC6, { "C6_PRUNIT"  	,aImp[nX][5]			, nil } )
			AAdd( aAutoSC6, { "C6_VALOR"	,nValItm				, nil } )
			AAdd( aAutoSC6, { "C6_QTDLIB"  	,aImp[nX][6]			, nil } )
			AAdd( aAutoSC6, { "C6_TES"     	,aImp[nX][13]			, nil } )
			//AAdd( aAutoSC6, { "C6_VALDESC"	,nValDsc				, nil } )
			AAdd( aAutoSC6, { "C6_OBS"     	,Alltrim(aImp[nX][15])	, nil } )
			//AAdd( aAutoSC6, { "C6_CCUSTO"  	,Alltrim(aImp[nX][18])	, nil } )

			aAutoSC6 := ConfArray(aAutoSC6)

			AAdd( aLinha  ,aAutoSC6)
		EndIf

		If _lUlt


			If nVlParc1+nVlParc2 < nValTot
				_nVlParc1 := Round(nVlParc1+(nValTot-(nVlParc1+nVlParc2)),2)
			ElseIf nVlParc1+nVlParc2 > nValTot
				_nVlParc1 := Round(nVlParc1-((nVlParc1+nVlParc2)-nValTot),2)
			Else
				_nVlParc1 := Round(nVlParc1,2)
			EndIf

			AAdd( aAutoSC5, { "C5_PARC1" 	,_nVlParc1		, nil } )
			AAdd( aAutoSC5, { "C5_PARC2" 	,nVlParc2		, nil } )

			aAutoSC5 := ConfArray(aAutoSC5)

			lMsErroAuto := .F.

			If Len(aLinha) > 0
				MSExecAuto({|x,y,z| MATA410(x,y,z)},aAutoSC5,aLinha,3)
				If !lMsErroAuto
					nVlPedOk += nValTot
					cLog += "Filial : "+cFilAnt+" Cliente: "+cCli+" IH: "+Substr(Alltrim(_cIH)+space(6),6)+" Pedido: "+SC5->C5_NUM+CRLF
					nQtdPed++
				Else
					MostraErro()
					nVlPedEr += nValTot
					cLog += "Filial : "+cFilAnt+" Cliente: "+cCli+" IH: "+Substr(Alltrim(_cIH)+space(6),6)+" Pedido nใo Gerado!"+CRLF					
				EndIf
			Else
				cLog += "Filial : "+cFilAnt+" Cliente: "+cCli+" IH: "+Substr(Alltrim(_cIH)+space(6),6)+" Desconto total no Pedido"+CRLF
			EndIf
			aAutoSC5	:= {}
			aAutoSC6	:= {}
		EndIf				 

	Next nX

	cLog += "Valor Total Pedidos Ok: "+Str(nVlPedOk)+CRLF
	cLog += "Valor Total Pedidos Erro: "+Str(nVlPedEr)+CRLF
	cLog += "Processado por: "+UsrRetName (RetCodUsr())+CRLF
	cLog += "Inicio do Processo: "+cHrIni+CRLF
	cLog += "Fim do Processo: "+Time()+CRLF


	cTime := Time() // Resultado: 10:37:17
	cHour := SubStr( cTime, 1, 2 ) // Resultado: 10
	cMin  := SubStr( cTime, 4, 2 ) // Resultado: 37
	cSecs := SubStr( cTime, 7, 2 ) // Resultado: 17

	cDirDocs := GetTempPath()//"C:\DLL_EXCEL\"//MsDocPath()
	cArquivo := "log_"+dtos(dDatabase)+"_"+cHour+cMin+cSecs+".txt"
	nHandle := MsfCreate(cDirDocs+cArquivo,0)
	//nHandle := MsfCreate(cDirDocs+"\"+cArquivo,0)

	If nHandle > 0

		fWrite(nHandle, "Log do faturamento! "+CRLF)   
		fWrite(nHandle, ""+CRLF)
		fWrite(nHandle, ""+CRLF)
		fWrite(nHandle, cLog+CRLF)

		fWrite(nHandle, ""+CRLF)
		fClose(nHandle)

		nRet := ShellExecute("open", cArquivo, "", cDirDocs, 1)

		//Se houver algum erro
		If nRet <= 32
			MsgStop("Nใo foi possํvel abrir o arquivo " +cDirDocs+cArquivo+ "!", "Aten็ใo")
		EndIf                                     

	EndIf

	cLog := "Fim de Processamento:"

	Aviso("Rotina de Faturamento",cLog,{"Fechar"},3)

Return()


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ordena array de rotina automแtica e confere os tipos informados dos campos com o dicionแrio de dados
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function ConfArray(_xArray, _xFonte)
	/////////////////////////////////////////
	Local _xOrdem 
	Local _nJ 
	Local _nI
	Local _cCorpo
	//Local _cAssunto
	//Local _cCorpo1
	//Local _cRecebe
	//Local _cAnexo
	//Local _lRet
	Default _xFonte := FunName()

	_cCorpo := ''
	If valtype(_xArray[1,1]) == 'A'
		For _nJ := 1 to len(_xArray)
			For _nI := 1 to len(_xArray[_nJ])
				_xOrdem := Posicione('SX3',2,_xArray[_nJ,_nI,1],'X3_ORDEM')
				If !empty(_xOrdem)
					_xArray[_nJ,_nI,3] := _xOrdem
					If valtype(_xArray[_nJ,_nI,2]) <> SX3->X3_TIPO
						If valtype(_xArray[_nI,2]) == 'C' .and. SX3->X3_TIPO  == 'M'
							_cCorpo := ''
						Else
							_cCorpo += _xArray[_nI,1] + ' -> ' + sx3->x3_campo + ' --- '  + valtype(_xArray[_nI,2])+ ' -> ' + SX3->X3_TIPO + CRLF
						EndIf
					EndIf   
				EndIf
			Next
			_xArray[_nJ] := aSort(_xArray[_nJ],,, { |x, y| x[3] < y[3] })
			SX3->(DbSetOrder(1))
			For _nI := 1 to len(_xArray[_nJ])
				_xArray[_nJ,_nI,3] := Nil
			Next
		Next
	Else
		For _nI := 1 to len(_xArray)
			_xOrdem := Posicione('SX3',2,_xArray[_nI,1],'X3_ORDEM')
			If !empty(_xOrdem)
				_xArray[_nI,3] := _xOrdem
				If valtype(_xArray[_nI,2]) <> SX3->X3_TIPO 
					If valtype(_xArray[_nI,2]) == 'C' .and. SX3->X3_TIPO  == 'M'
						_cCorpo := ''
					Else
						_cCorpo += _xArray[_nI,1] + ' -> ' + sx3->x3_campo + ' --- '  + valtype(_xArray[_nI,2])+ ' -> ' + SX3->X3_TIPO + CRLF
					EndIf
				EndIf     
			Else
				_xArray[_nI,3] := 'zz'
			EndIf
		Next
		_xArray := aSort(_xArray,,, { |x, y| x[3] < y[3] })
		SX3->(DbSetOrder(1))
		For _nI := 1 to len(_xArray)
			_xArray[_nI,3] := Nil
		Next
	EndIf

	//_lRet := .t.

	//Return({_lRet,_xArray})
Return(_xArray)

//Acerta o Dado da planilha tirando caracteres especiais.
Static Function LimpaDado(_cBuffer)

	Local _cDado 	:= ""
	Local nY		:= 0

	For nY := 1 to Len(_cBuffer)

		If asc(substr(_cBuffer,nY,1)) <> 0
			_cDado += substr(_cBuffer,nY,1)
		EndIf

	Next nY

Return(_cDado)
