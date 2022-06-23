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

#DEFINE CRLF (Chr(13)+Chr(10))
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBSLCOM02บAutor  ณMarcus Ferraz       บ Data ณ15/04/2017     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina automatica para cadastro de pr้-nota.               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BSL                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿  
*/

user function BSLCOM02()

	Local aSays 		:= {}
	Local aButtons		:= {}
	Local nOpca 		:= 0
	Local cCadastro		:= "Rotina Importa็ใo de Pr้-Nota"
	Local cFileOpen 	:= ""
	Local cHrIni		:= Time()

	Private cTitulo := "Planilha de Pr้-Nota"

	//Texto da tela principal.
	AADD(aSays, "Este Programa ira gerar Pr้-notas com informa็๕es "	)
	AADD(aSays, "da Planilha " 	)
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
	Local cFilPre 		:= ""
	Local cNumNF		:= ""
	Local cSerNF		:= ""
	Local cCodPrd 		:= ""
	Local nQuant 		:= 0
	Local nVlConv 		:= 0
	Local nValTot 		:= 0
	Local cCCusto 		:= ""
	Local cObs 			:= ""
	Local cCNPJ 		:= ""
	Local dEmisNf		:= CTOD("  /  /    ")
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
			cBuffer := "Pre-nota" + Space(512)

			ExeDLLRun2(nHdl, CMD_ACTIVEWORKSHEET, @cBuffer)

			//Tratamento para verificar se o nome da planilha aberta corresponde ao modelo
			If Alltrim(cBuffer) = "unknown error in command "
				Alert("O nome da planilha nใo corresponde ao esperado para importa็ใo. A planilha deve-se chamar (Pr้-nota).")
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

				//Carrega a celula A4
				//cFilPre
				cCel := "A"+Alltrim(str(nIni))
				cBuffer := cCel + Space(1024)
				nBytes = ExeDLLRun2(nHdl, CMD_READCELL, @cBuffer)

				//Verifica se o conteudo da celula e diferente de vazio
				If (Alltrim( Subs(cBuffer, 1, nBytes) ) <> "")

					cFilPre := UPPER(Alltrim(Substr(cBuffer,1,5)))
					aPlan2 := {}

					AAdd(aPlan2,cFilPre)

					//cNumNF
					cCel := "B"+Alltrim(str(nIni))
					cBuffer := cCel + Space(1024)
					nBytes = ExeDLLRun2(nHdl, CMD_READCELL, @cBuffer)
					cNumNF := Alltrim( Substr(cBuffer, 1, 9) )
					cNumNF := LimpaDado(cNumNF)
					AAdd(aPlan2,cNumNF)

					//cSerNF
					cCel := "C"+Alltrim(str(nIni))
					cBuffer := cCel + Space(1024)
					nBytes = ExeDLLRun2(nHdl, CMD_READCELL, @cBuffer)
					cSerNF := Alltrim( Substr(cBuffer, 1, 3) )
					cSerNF := LimpaDado(cSerNF)
					AAdd(aPlan2,cSerNF)

					//cCodPrd
					cCel := "F"+Alltrim(str(nIni))
					cBuffer := cCel + Space(1024)
					nBytes = ExeDLLRun2(nHdl, CMD_READCELL, @cBuffer)
					cCodPrd := StrTran(UPPER( Alltrim( Substr(cBuffer, 1, 15) ) ),".","")
					cCodPrd := LimpaDado(cCodPrd)
					AAdd(aPlan2,cCodPrd)

					//nQuant
					cCel := "J"+Alltrim(str(nIni))
					cBuffer := cCel + Space(1024)
					nBytes = ExeDLLRun2(nHdl, CMD_READCELL, @cBuffer)
					nQuant := Val(strtran(cBuffer,",","."))
					AAdd(aPlan2,nQuant)

					//nVlConv
					cCel := "K"+Alltrim(str(nIni))
					cBuffer := cCel + Space(1024)
					nBytes = ExeDLLRun2(nHdl, CMD_READCELL, @cBuffer)
					nVlConv := Val(strtran(cBuffer,",","."))
					AAdd(aPlan2,nVlConv)

					//nValTot
					cCel := "L"+Alltrim(str(nIni))
					cBuffer := cCel + Space(1024)
					nBytes = ExeDLLRun2(nHdl, CMD_READCELL, @cBuffer)
					nValTot := Val(strtran(cBuffer,",","."))
					AAdd(aPlan2,nValTot)

					//cCCusto
					cCel := "N"+Alltrim(str(nIni))
					cBuffer := cCel + Space(1024)
					nBytes = ExeDLLRun2(nHdl, CMD_READCELL, @cBuffer)
					cCCusto := UPPER( Alltrim( Substr(cBuffer, 1, 20) ) )
					cCCusto := LimpaDado(cCCusto)
					AAdd(aPlan2,cCCusto)

					//cObs
					cCel := "O"+Alltrim(str(nIni))
					cBuffer := cCel + Space(1024)
					nBytes = ExeDLLRun2(nHdl, CMD_READCELL, @cBuffer)
					cObs := UPPER( Alltrim( Substr(cBuffer, 1, 100) ) )
					cObs := LimpaDado(cObs)
					AAdd(aPlan2,cObs)

					//cCNPJ
					cCel := "Q"+Alltrim(str(nIni))
					cBuffer := cCel + Space(1024)
					nBytes = ExeDLLRun2(nHdl, CMD_READCELL, @cBuffer)
					cCNPJ := UPPER( Alltrim( Substr(cBuffer, 1, 14) ) )
					cObs := LimpaDado(cCNPJ)
					AAdd(aPlan2,cCNPJ)

					//dEmisNf
					cCel := "R"+Alltrim(str(nIni))
					cBuffer := cCel + Space(1024)
					nBytes = ExeDLLRun2(nHdl, CMD_READCELL, @cBuffer)
					dEmisNf := CtoD(UPPER( Alltrim( Substr(cBuffer,1,10 )) ))
					//dEmisNf := CtoD(cEmisNf)
					AAdd(aPlan2,dEmisNf)

					//cQuebra
					cCel := "S"+Alltrim(str(nIni))
					cBuffer := cCel + Space(1024)
					nBytes = ExeDLLRun2(nHdl, CMD_READCELL, @cBuffer)
					cQuebra := UPPER( Alltrim( cBuffer ) )
					cQuebra := LimpaDado(cQuebra)
					AAdd(aPlan2,cQuebra)

					//dEntrNf
					cCel := "T"+Alltrim(str(nIni))
					cBuffer := cCel + Space(1024)
					nBytes = ExeDLLRun2(nHdl, CMD_READCELL, @cBuffer)
					dEntrNf := CtoD(UPPER( Alltrim( Substr(cBuffer,1,10 )) ))
					//dEmisNf := CtoD(cEmisNf)
					AAdd(aPlan2,dEntrNf)

					//Conteudo da Planilha
					AAdd(aPlan1,aPlan2 )

				Else
					Exit
				EndIf
				nIni++
			Enddo
		Else
			MsgInfo("DDL ReadExcel nใo localizada no server")
			Return()
		EndIf
	Next _nCont

	// Fecha o arquivo e remove o excel da memoria
	cBuffer := Space(512)

	ExeDLLRun2(nHdl, CMD_CLOSEWORKBOOK, @cBuffer)
	ExecInDLLClose(nHdl)

	Processa( {|| BslGerPre(aPlan1,cHrIni)}, "Aguarde...","Gerando Pre-Nota.", .T. )


Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBslGerPre บAutor  ณMarcus Ferraz       บ Data ณ12/09/2014   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo de importa็ใo da planilha                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BSL                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿  
*/

Static Function BslGerPre(aImp,cHrIni)

	Local nY		:= 0
	Local nX		:= 0
	Local aCabec	:= {}
	Local aLinha	:= {}
	Local aItm		:= {}
	Local aPrdAlt	:= {}
	Local cObs	 	:= ""
	Local _lCabec 	:= .T.
	Local _lPrim	:= .T.
	Local _lUlt		:= .F.
	Local lAlt		:= .F.
	Local lAltP		:= .F.
	Local lExec		:= .F.
	Local nValTot	:= 0
	Local nQtdPnOk	:= 0
	Local nQtdPnEr	:= 0
	Local _cLog 		:= "Processo Finalizado"+CRLF
	Local cItem 	:= "00"
	Local cQuebrAnt := ""
	Local cFornAnt	:= ""
	Local cNFAnt	:= ""
	Local cForPre	:= ""
	Local cLojPre	:= ""
	Local _cPrd		:= ""
	Local dDtEntr	:= dDataBase

	PRIVATE lMsErroAuto := .F.

	ProcRegua (Len(aImp))
	//Inicia a Gera็ใo da Pr้-nota
	For nX := 1 to Len(aImp)

		//Valida se serแ gerado a pr้-nota ou se continua montando a linha de Itens.

		If Alltrim(aImp[nX][12]) <> cQuebrAnt .Or.;
				Alltrim(aImp[nX][1]) <> cFilAnt .Or.;
				Alltrim(aImp[nX][2])+Alltrim(aImp[nX][3]) <> cNFAnt .Or.;
				Alltrim(aImp[nX][10]) <> cFornAnt    // Condi็ใo de pular linha

			_lCabec := .T.
			//Pula a primeira linha para nใo gerar a pr้-nota sem dados no array
			If !_lPrim

				lMsErroAuto := .F.

				//aCabec:= ConfArray(aCabec)

				DbSelectArea("SA2")
				SA2->(DbGoTop())
				SA2->(DbSetOrder(1))
				If SA2->(MsSeek( xFilial("SA2")+cForPre+cLojPre ) )
					If SA2->A2_XPER <> "1"
						Reclock("SA2",.F.)
						SA2->A2_XPER := "1"
						lAlt := .T.
						SA2->(MsUnlock())
					EndIf
					_lExec := .T.

				Else
					nQtdPnEr++
					_cLog += "Filial : "+cFilAnt+" CNPJ: "+cFornAnt+" Pr้-Nota:  "+cNFAnt+" nใo Gerado, fornecedor nใo cadastrado no Protheus"+CRLF
					_lExec := .F.
				EndIf

				If _lExec
					DbSelectArea("SF1")
					SF1->(DbGoTop())
					SF1->(DbSetOrder(1)) //F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO
					If SF1->(!MsSeek(cFilAnt+Padr(cNFAnt,12,"")+PadR(cForPre,6,"")+PadR(cLojPre,2,"")+'N' ) )

						dDataBase := dDtEntr
						MSExecAuto({|x,y,z| MATA140(x,y,z)}, aCabec, aItm, 3)

						If !lMsErroAuto
							_cLog += "Filial : "+cFilAnt+" CNPJ: "+cFornAnt+" Pr้-Nota: "+SF1->F1_DOC+SF1->F1_SERIE+CRLF
							nQtdPnOk++
						Else
							MostraErro()
							nQtdPnEr++
							_cLog += "Filial : "+cFilAnt+" CNPJ: "+cFornAnt+" Pr้-Nota: "+cNFAnt+" nใo Gerada Erro!"+CRLF
						EndIf
					Else
						nQtdPnOk++
						_cLog += "Filial : "+cFilAnt+" CNPJ: "+cFornAnt+" Pr้-Nota: "+cNFAnt+" Jแ Cadastrada"+CRLF
					EndIf
				EndIf


				//Zera as variaveis para Iniciar a montagem do array da nova Pr้-nota

				If lAlt
					DbSelectArea("SA2")
					SA2->(DbGoTop())
					SA2->(DbSetOrder(1))
					If SA2->(MsSeek( xFilial("SA2")+cForPre+cLojPre ) )
						Reclock("SA2",.F.)
						SA2->A2_XPER := "2"
						SA2->(MsUnlock())
					EndIf

				EndIf

				aCabec	:= {}
				aItm	:= {}
				aLinha	:= {}
				cItem 	:= "00"
			EndIf
			_lPrim 	:= .F.
			_lCabec	:= .T.
			lAlt	:= .F.
			_lExec	:= .F.
		EndIf

		If Len(aImp) == nX
			_lUlt := .T.
		EndIf

		cFilAnt		:= Alltrim(aImp[nX][1])
		cQuebrAnt	:= Alltrim(aImp[nX][12])
		cFornAnt	:= Alltrim(aImp[nX][10])
		cNFAnt		:= Alltrim(aImp[nX][2])+Alltrim(aImp[nX][3])
		dDtEntr		:= aImp[nX][13]

		IncProc("Gerando Pr้-Nota: " + StrZero(nX,6) +" de "+StrZero(Len(aImp),6))

		If _lCabec

			cQuery := "SELECT A2_COD, A2_LOJA FROM SA2010 WHERE SA2010.D_E_L_E_T_ <> '*' AND A2_CGC = '"+Alltrim(aImp[nX][10])+"'"

			//cQuery := ChangeQuery( cQuery )

			If SELECT("TSA2") <> 0
				TSA2->(dbCloseArea())
			Endif

			TcQuery cQuery new alias "TSA2"
			DbSelectArea("TSA2")
			TSA2->(DbGoTop())

			cForPre := TSA2->A2_COD
			cLojPre := TSA2->A2_LOJA

			aCabec := 	{	{'F1_TIPO'		,'N'			,NIL},;
				{'F1_FORMUL'		,'N'			,NIL},;
				{'F1_DOC'			,aImp[nX][2]	,NIL},;
				{'F1_SERIE'			,aImp[nX][3]	,NIL},;
				{'F1_EMISSAO'		,aImp[nX][11]	,NIL},;
				{'F1_FORNECE'		,cForPre		,NIL},;
				{'F1_LOJA'			,cLojPre		,NIL} }

			//aCabec := ConfArray(aCabec)
			_lCabec := .F.

		EndIf

		//cItem := Soma1(cItem)
		cItem := StrZero(Val(cItem)+1,4)
		//aLinha := {}

		DbSelectArea("SB1")
		SB1->(DbGoTop())
		SB1->(DbSetOrder(1))
		If SB1->(MsSeek( xFilial("SB1")+Padr(aImp[nX][4],15,"") ) )
			If SB1->B1_MSBLQL == '1'
				Reclock("SB1",.F.)
				SB1->B1_MSBLQL := "2"
				SB1->(MsUnlock())
				Aadd(aPrdAlt,Substr(aImp[nX][4],1,15))
			EndIf
		EndIf

		aLinha := {}

		aItens :=	{	{'D1_ITEM'	,cItem			,NIL},;
			{'D1_COD'		,aImp[nX][4]	,NIL},;
			{'D1_QUANT'		,aImp[nX][5]	,NIL},;
			{'D1_VUNIT'		,aImp[nX][6]	,NIL},;
			{'D1_TOTAL'		,aImp[nX][7]	,NIL},;
			{'D1_CC'		,aImp[nX][8]	,NIL}}


		//aLinha := ConfArray(aItm)

		AAdd( aItm  ,aItens)

		If _lUlt

			//aCabec := ConfArray(aCabec)

			lMsErroAuto := .F.

			DbSelectArea("SA2")
			SA2->(DbGoTop())
			SA2->(DbSetOrder(1))
			If SA2->(MsSeek( xFilial("SA2")+cForPre+cLojPre ) )
				If SA2->A2_XPER <> "1"
					Reclock("SA2",.F.)
					SA2->A2_XPER := "1"
					lAlt := .T.
					SA2->(MsUnlock())
				EndIf
				_lExec := .T.

			Else
				nQtdPnEr++
				_cLog += "Filial : "+cFilAnt+" CNPJ: "+cFornAnt+" Pr้-Nota: "+cNFAnt+" nใo Gerado, fornecedor nใo cadastrado no Protheus"+CRLF
				_lExec := .F.
			EndIf

			If _lExec
				DbSelectArea("SF1")
				SF1->(DbGoTop())
				SF1->(DbSetOrder(1)) //F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO
				If SF1->(!MsSeek(cFilAnt+Padr(cNFAnt,12,"")+PadR(cForPre,6,"")+PadR(cLojPre,2,"")+'N' ) )
					dDataBase := dDtEntr
					MSExecAuto({|x,y,z| MATA140(x,y,z)}, aCabec, aItm, 3)

					If !lMsErroAuto
						_cLog += "Filial : "+cFilAnt+" CNPJ: "+cFornAnt+" Pr้-Nota: "+SF1->F1_DOC+SF1->F1_SERIE+CRLF
						nQtdPnOk++
					Else
						MostraErro()
						nQtdPnEr++
						_cLog += "Filial : "+cFilAnt+" CNPJ: "+cFornAnt+" Pr้-Nota: "+cNFAnt+" nใo Gerada Erro!"+CRLF
					EndIf
				Else
					nQtdPnOk++
					_cLog += "Filial : "+cFilAnt+" CNPJ: "+cFornAnt+" Pr้-Nota: "+cNFAnt+" Jแ Cadastrada"+CRLF
				EndIf
			EndIf


			//Zera as variaveis para Iniciar a montagem do array da nova Pr้-nota

			If lAlt
				DbSelectArea("SA2")
				SA2->(DbGoTop())
				SA2->(DbSetOrder(1))
				If SA2->(MsSeek( xFilial("SA2")+cForPre+cLojPre ) )
					Reclock("SA2",.F.)
					SA2->A2_XPER := "2"
					SA2->(MsUnlock())
				EndIf

			EndIf

			aCabec	:= {}
			aItm	:= {}
		EndIf

	Next nX

	If Len(aPrdAlt) > 0
		For nY := 1 to Len(aPrdAlt)
			DbSelectArea("SB1")
			SB1->(DbGoTop())
			SB1->(DbSetOrder(1))
			If SB1->(MsSeek( xFilial("SB1")+PadR(aPrdAlt[nY],15,"") ) )
				Reclock("SB1",.F.)
				SB1->B1_MSBLQL := "1"
				SB1->(MsUnlock())
			EndIf
		Next nY
	EndIf

	_cLog += "Total Pr้-Nota Ok: "+Str(nQtdPnOk)+CRLF
	_cLog += "Total Pr้-Nota Erro: "+Str(nQtdPnEr)+CRLF
	_cLog += "Processado por: "+UsrRetName (RetCodUsr())+CRLF
	_cLog += "Inicio do Processo: "+cHrIni+CRLF
	_cLog += "Fim do Processo: "+Time()+CRLF


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
		fWrite(nHandle, _cLog+CRLF)

		fWrite(nHandle, ""+CRLF)
		fClose(nHandle)

		nRet := ShellExecute("open", cArquivo, "", cDirDocs, 1)

		//Se houver algum erro
		If nRet <= 32
			MsgStop("Nใo foi possํvel abrir o arquivo " +cDirDocs+cArquivo+ "!", "Aten็ใo")
		EndIf

	EndIf

	_cLog := "Fim de Processamento:"

	Aviso("Rotina de Pr้-Nota",_cLog,{"Fechar"},3)

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
Static Function LimpaDado(_cBuffer,nY)

	Local _cDado := ""

	For nY := 1 to Len(_cBuffer)

		If asc(substr(_cBuffer,nY,1)) <> 0
			_cDado += substr(_cBuffer,nY,1)
		EndIf

	Next nY

Return(_cDado)
