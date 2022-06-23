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
ฑฑบPrograma  ณajusDescบAutor  ณMarcus Ferraz       บ Data ณ21/05/2017     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina para atualizar a descri็ใo dos produtos assistcare  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BSL                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿  
*/

user function ajusDesc()

	Local aSays 		:= {}
	Local aButtons		:= {}
	Local nOpca 		:= 0
	Local cCadastro		:= "Ajusta Descri็ใo"
	Local cFileOpen 	:= ""
	Local cHrIni		:= Time()

	Private cTitulo := "Planilha de Produtos"

	//Texto da tela principal.
	AADD(aSays, "Programa para corre็ใo da Descri็ใo dos produtos"	)
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
		Processa( { ||ImpPlnXls(cFileOpen,cHrIni) } )
	Else
		Return Nil
	EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSelArqXls บAutor  ณMarcus Ferraz       บ Data ณ07/06/2016   บฑฑ
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
ฑฑบPrograma  ณImpPlnXls บAutor  ณMarcus Ferraz       บ Data ณ07/06/2016   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo de importa็ใo da planilha                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BSL                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿  
*/

Static Function ImpPlnXls(cCam,cHrIni)

	Local nHdl 		  	:= ExecInDLLOpen('C:\DLL_EXCEL\readexcel.dll')
	Local cBuffer	  	:= ''
	Local cFile		  	:= cCam
	Local nIni  	  	:= 2
	Local nCont		  	:= 1
	Local aColun	  	:= {} //array com as colunas a serem lidas
	Local aPlanilha	  	:= {}
	Local cCodPrd 		:= ""
	Local cDscPrd 		:= ""
	Local cMsBlql 		:= ""


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
			cBuffer := "SB1" + Space(512)
			ExeDLLRun2(nHdl, CMD_ACTIVEWORKSHEET, @cBuffer)

			//Tratamento para verificar se o nome da planilha aberta corresponde ao modelo
			If Alltrim(cBuffer) = "unknown error in command "
				Alert("O nome da planilha nใo corresponde ao esperado para importa็ใo. A planilha deve-se chamar (SB1).")
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

				//Carrega a celula B1
				//cCodPrd
				cCel := "A"+Alltrim(str(nIni))
				cBuffer := cCel + Space(1024)
				nBytes = ExeDLLRun2(nHdl, CMD_READCELL, @cBuffer)

				//Verifica se o conteudo da celula e diferente de vazio
				If (Alltrim( Subs(cBuffer, 1, nBytes) ) <> "")

					cCodPrd := UPPER(Alltrim(Substr(cBuffer,1,15)))
					aPlan2 := {}

					AAdd(aPlan2,cCodPrd)

					//cDscPrd
					cCel := "B"+Alltrim(str(nIni))
					cBuffer := cCel + Space(1024)
					nBytes = ExeDLLRun2(nHdl, CMD_READCELL, @cBuffer)
					cDscPrd := Alltrim( Substr(cBuffer, 1, 250) )
					cDscPrd := LimpaDado(cDscPrd)
					AAdd(aPlan2,cDscPrd)

					//cMsBlql
					cCel := "C"+Alltrim(str(nIni))
					cBuffer := cCel + Space(1024)
					nBytes = ExeDLLRun2(nHdl, CMD_READCELL, @cBuffer)
					cMsBlql := StrTran(UPPER( Alltrim( Substr(cBuffer, 1, 1) ) ),".","")
					AAdd(aPlan2,cMsBlql)

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

	Processa( {|| AtuDesc(aPlan1,cHrIni)}, "Aguarde...","Atualizando Descri็ใo.", .T. )


Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAtuDesc บAutor  ณMarcus Ferraz       บ Data ณ12/09/2014   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo de importa็ใo da planilha                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BSL                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿  
*/

Static Function AtuDesc(aImp,cHrIni)

	Local nX		:= 0
	Local cLog 		:= "Processo Finalizado"+CRLF


	ProcRegua (Len(aImp))
	//Inicia a Gera็ใo da solicita็ใo
	For nX := 1 to Len(aImp)

		DbSelectArea("SB1")
		SB1->(DbGoTop())
		SB1->(DbSetOrder(1))
		If SB1->(DbSeek(xFilial("SB1")+aImp[nX][1]))
			RecLock("SB1",.F.)
			SB1->B1_DESC := aImp[nX][2]
			SB1->B1_MSBLQL := aImp[nX][3]
			SB1->(MsUnlock())
		EndIf


	Next nX

	cLog += "Processado por: "+UsrRetName(RetCodUsr())+CRLF
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

	Aviso("Produto Atualizado",cLog,{"Fechar"},3)

Return()

//Acerta o Dado da planilha tirando caracteres especiais.
Static Function LimpaDado(_cBuffer)

	Local _cDado := ""
	Local nY

	For nY := 1 to Len(_cBuffer)

		If asc(substr(_cBuffer,nY,1)) <> 0
			_cDado += substr(_cBuffer,nY,1)
		EndIf

	Next nY

Return(_cDado)