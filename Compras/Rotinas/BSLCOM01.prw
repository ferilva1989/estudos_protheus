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
ฑฑบPrograma  ณBSLCOM01บAutor  ณMarcus Ferraz       บ Data ณ31/01/2017     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina automatica para cadastro de pedido de venda.        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BSL                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿  
*/

user function BSLCOM01()

	Local aSays 		:= {}
	Local aButtons		:= {}
	Local nOpca 		:= 0
	Local cCadastro		:= "Rotina Importa็ใo de SC"
	Local cFileOpen 	:= ""
	Local cHrIni		:= Time()

	Private cTitulo := "Planilha de Solicita็ใo de Compras"

	//Texto da tela principal.
	AADD(aSays, "Este Programa ira gerar os Solicita็ใo de Compras com as informa็๕es "	)
	AADD(aSays, "da Planilha de SC " 	)
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
		Processa( { ||ImpCOMXls(cFileOpen,cHrIni) } )
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
ฑฑบPrograma  ณImpCOMXls บAutor  ณMarcus Ferraz       บ Data ณ07/06/2016   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo de importa็ใo da planilha                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BSL                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿  
*/

Static Function ImpCOMXls(cCam,cHrIni)

	Local nHdl 		  	:= ExecInDLLOpen('C:\DLL_EXCEL\readexcel.dll')
	Local cBuffer	  	:= ''
	Local cFile		  	:= cCam
	Local nIni  	  	:= 4
	Local nCont		  	:= 1
	Local aColun	  	:= {} //array com as colunas a serem lidas
	Local aPlanilha	  	:= {}
	Local cFilSc 		:= ""
	Local cSolic 		:= ""
	Local cCodPrd 		:= ""
	Local nQuant 		:= 0
	Local nVlConv 		:= 0
	Local nValTot 		:= 0
	Local cCCusto 		:= ""
	Local cObs 			:= ""
	Local cCodFor 		:= ""
	Local cLojFor 		:= ""
	Local cQuebra 		:= ""



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
			cBuffer := "Solicitacao" + Space(512)
			ExeDLLRun2(nHdl, CMD_ACTIVEWORKSHEET, @cBuffer)

			//Tratamento para verificar se o nome da planilha aberta corresponde ao modelo
			If Alltrim(cBuffer) = "unknown error in command "
				Alert("O nome da planilha nใo corresponde ao esperado para importa็ใo. A planilha deve-se chamar (Solicitacao).")
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
				//cFilSc
				cCel := "A"+Alltrim(str(nIni))
				cBuffer := cCel + Space(1024)
				nBytes = ExeDLLRun2(nHdl, CMD_READCELL, @cBuffer)

				//Verifica se o conteudo da celula e diferente de vazio
				If (Alltrim( Subs(cBuffer, 1, nBytes) ) <> "")

					cFilSc := UPPER(Alltrim(Substr(cBuffer,1,5)))
					aPlan2 := {}

					AAdd(aPlan2,cFilSc)

					//cSolic
					cCel := "B"+Alltrim(str(nIni))
					cBuffer := cCel + Space(1024)
					nBytes = ExeDLLRun2(nHdl, CMD_READCELL, @cBuffer)
					cSolic := Alltrim( Substr(cBuffer, 1, 25) )
					cSolic := LimpaDado(cSolic)
					AAdd(aPlan2,cSolic)

					//cCodPrd
					cCel := "E"+Alltrim(str(nIni))
					cBuffer := cCel + Space(1024)
					nBytes = ExeDLLRun2(nHdl, CMD_READCELL, @cBuffer)
					cCodPrd := StrTran(UPPER( Alltrim( Substr(cBuffer, 1, 15) ) ),".","")
					cCodPrd := LimpaDado(cCodPrd)
					AAdd(aPlan2,cCodPrd)

					//nQuant
					cCel := "I"+Alltrim(str(nIni))
					cBuffer := cCel + Space(1024)
					nBytes = ExeDLLRun2(nHdl, CMD_READCELL, @cBuffer)
					nQuant := Val(strtran(cBuffer,",","."))
					AAdd(aPlan2,nQuant)

					//nVlConv
					cCel := "J"+Alltrim(str(nIni))
					cBuffer := cCel + Space(1024)
					nBytes = ExeDLLRun2(nHdl, CMD_READCELL, @cBuffer)
					nVlConv := Val(strtran(cBuffer,",","."))
					AAdd(aPlan2,nVlConv)

					//nValTot
					cCel := "K"+Alltrim(str(nIni))
					cBuffer := cCel + Space(1024)
					nBytes = ExeDLLRun2(nHdl, CMD_READCELL, @cBuffer)
					nValTot := Val(strtran(cBuffer,",","."))
					AAdd(aPlan2,nValTot)

					//cCCusto
					cCel := "M"+Alltrim(str(nIni))
					cBuffer := cCel + Space(1024)
					nBytes = ExeDLLRun2(nHdl, CMD_READCELL, @cBuffer)
					cCCusto := UPPER( Alltrim( Substr(cBuffer, 1, 20) ) )
					cCCusto := LimpaDado(cCCusto)
					AAdd(aPlan2,cCCusto)

					//cObs
					cCel := "N"+Alltrim(str(nIni))
					cBuffer := cCel + Space(1024)
					nBytes = ExeDLLRun2(nHdl, CMD_READCELL, @cBuffer)
					cObs := UPPER( Alltrim( Substr(cBuffer, 1, 100) ) )
					cObs := LimpaDado(cObs)
					AAdd(aPlan2,cObs)

					//cCodFor
					cCel := "P"+Alltrim(str(nIni))
					cBuffer := cCel + Space(1024)
					nBytes = ExeDLLRun2(nHdl, CMD_READCELL, @cBuffer)
					cCodFor := UPPER( Alltrim( Substr(cBuffer, 1, 6) ) )
					AAdd(aPlan2,cCodFor)

					//cLojFor
					cCel := "P"+Alltrim(str(nIni))
					cBuffer := cCel + Space(1024)
					nBytes = ExeDLLRun2(nHdl, CMD_READCELL, @cBuffer)
					cLojFor := UPPER( Alltrim( Substr(cBuffer, 7, 2) ) )
					AAdd(aPlan2,cLojFor)

					//cQuebra
					cCel := "Q"+Alltrim(str(nIni))
					cBuffer := cCel + Space(1024)
					nBytes = ExeDLLRun2(nHdl, CMD_READCELL, @cBuffer)
					cQuebra := UPPER( Alltrim( cBuffer ) )
					cQuebra := LimpaDado(cQuebra)
					AAdd(aPlan2,cQuebra)

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

	Processa( {|| BslGerSol(aPlan1,cHrIni)}, "Aguarde...","Gerando Pedidos.", .T. )


Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBslGerSol บAutor  ณMarcus Ferraz       บ Data ณ12/09/2014   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo de importa็ใo da planilha                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BSL                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿  
*/

Static Function BslGerSol(aImp,cHrIni)

	Local nX		:= 0
	Local aCabec	:= {}
	Local aLinha	:= {}
	Local aItm		:= {}
	Local cFor 		:= ""
	Local cObs	 	:= ""
	Local _lCabec 	:= .T.
	Local _lPrim	:= .T.
	Local _lUlt		:= .F.
	Local nValTot	:= 0
	Local nQtdScOk	:= 0
	Local nQtdScEr	:= 0
	Local cLog 		:= "Processo Finalizado"+CRLF
	Local cItem 	:= "0000"
	Local cQuebrAnt := ""
	Local cFornAnt	:= ""

	PRIVATE lMsErroAuto := .F.

	ProcRegua (Len(aImp))
	//Inicia a Gera็ใo da solicita็ใo
	For nX := 1 to Len(aImp)

		//Valida se serแ gerado a SC ou se continua montando a linha de Itens.
		If Alltrim(aImp[nX][11]) <> cQuebrAnt .Or.;
				Alltrim(aImp[nX][1]) <> cFilAnt .Or.;
				Alltrim(aImp[nX][9])+Alltrim(aImp[nX][10]) <> cFornAnt    // Condi็ใo de pular linha

			_lCabec := .T.
			//Pula a primeira linha para nใo gerar o pedido sem dados no array
			If !_lPrim

				lMsErroAuto := .F.

				//aCabec:= ConfArray(aCabec)

				MSExecAuto({|x,y| mata110(x,y)},aCabec,aItm)

				If !lMsErroAuto

					cLog += "Filial : "+cFilAnt+" Fornecedor: "+cFornAnt+" Solicita็ใo: "+SC1->C1_NUM+" Sequencia: "+cQuebrAnt+CRLF
					nQtdScOk++
				Else
					MostraErro()
					nQtdScEr++
					cLog += "Filial : "+cFilAnt+" Fornecedor: "+cFornAnt+" Solicita็ใo nใo Gerado! Sequencia: "+cQuebrAnt+CRLF
				EndIf
				//Zera as variaveis para Iniciar a montagem do array do novo pedido.

				aCabec	:= {}
				aItm	:= {}
				aLinha	:= {}
				cItem 	:= "0000"
			EndIf
			_lPrim := .F.
			_lCabec	:= .T.
		EndIf

		If Len(aImp) == nX
			_lUlt := .T.
		EndIf

		cFilAnt		:= Alltrim(aImp[nX][1])
		cQuebrAnt	:= Alltrim(aImp[nX][11])
		cFornAnt	:= Alltrim(aImp[nX][9])+Alltrim(aImp[nX][10])

		IncProc("Gerando Solicita็ใo: " + StrZero(nX,6) +" de "+StrZero(Len(aImp),6))

		If _lCabec

			cDoc := NextNumero("SC1",1,"C1_NUM",.T.)

			//cDoc := GetSXENum("SC1","C1_NUM")
			//SC1->(dbSetOrder(1))

			//While SC1->(dbSeek(xFilial("SC1")+cDoc))
			//	ConfirmSX8()
			//	cDoc := GetSXENum("SC1","C1_NUM")
			//EndDo

			aadd(aCabec,{"C1_NUM"    ,cDoc})
			aadd(aCabec,{"C1_SOLICIT",aImp[nX][2]})
			aadd(aCabec,{"C1_EMISSAO",dDataBase})

			//aCabec := ConfArray(aCabec)
			_lCabec := .F.
		EndIf

		//cItem := Soma1(cItem)
		cItem := StrZero(Val(cItem)+1,4)
		//aLinha := {}

		aLinha := {}
		aadd(aLinha,{"C1_ITEM"   	,cItem		 ,Nil})
		aadd(aLinha,{"C1_PRODUTO"	,aImp[nX][3] ,Nil})
		aadd(aLinha,{"C1_QUANT"  	,aImp[nX][4] ,Nil})
		aadd(aLinha,{"C1_VUNIT"  	,aImp[nX][5] ,Nil})
		aadd(aLinha,{"C1_PRECO"  	,aImp[nX][5] ,Nil})
		aadd(aLinha,{"C1_TOTAL"  	,aImp[nX][6] ,Nil})
		aadd(aLinha,{"C1_CC"  	 	,aImp[nX][7] ,Nil})
		aadd(aLinha,{"C1_OBS"  	 	,aImp[nX][8] ,Nil})
		aadd(aLinha,{"C1_DATPRF" 	,dDataBase 	 ,Nil})
		//aadd(aLinha,{"C1_LOJA"   	,aImp[nX][10],Nil})
		aadd(aLinha,{"C1_FORNCE" 	,aImp[nX][9] ,Nil})


		//aLinha := ConfArray(aItm)

		AAdd( aItm  ,aLinha)

		If _lUlt

			//aCabec := ConfArray(aCabec)

			lMsErroAuto := .F.

			MSExecAuto({|x,y| mata110(x,y)},aCabec,aItm)

			If !lMsErroAuto

				cLog += "Filial : "+cFilAnt+" Fornecedor: "+cFor+" Solicita็ใo: "+SC1->C1_NUM+CRLF
				nQtdScOk++
			Else
				MostraErro()
				nQtdScEr++
				cLog += "Filial : "+cFilAnt+" Fornecedor: "+cFor+" Solicita็ใo nใo Gerado!"+CRLF
			EndIf

			aCabec	:= {}
			aItm	:= {}
		EndIf

	Next nX

	cLog += "Total Solcita็ใo Ok: "+Str(nQtdScOk)+CRLF
	cLog += "Total Solicita็ใo Erro: "+Str(nQtdScEr)+CRLF
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

		fWrite(nHandle, "Log! "+CRLF)
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

	Local _cDado	:= ""
	Local _cBuffer
	Local nY 		:= 0

	For nY := 1 to Len(_cBuffer)

		If asc(substr(_cBuffer,nY,1)) <> 0
			_cDado += substr(_cBuffer,nY,1)
		EndIf

	Next nY

Return(_cDado)
