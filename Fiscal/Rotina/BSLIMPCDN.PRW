#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"
#INCLUDE "TBICONN.CH"
#Include "TbiCode.ch"
#INCLUDE "rwmake.CH"

#define CMD_OPENWORKBOOK			1
#define CMD_CLOSEWORKBOOK			2
#define CMD_ACTIVEWORKSHEET	   		3
#define CMD_READCELL				4

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBSLIMPCDN บAutor  ณMarcus Ferraz       บ Data ณ12/12/2014   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina automatica para cadastro da tabela CDN.             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BSL                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿  
*/

User Function BSLIMPCDN()


	Local cFileOpen := ""
	Local cTitulo  	:= "Selecione o arquivo"
	Local cExtens   := "Planilha do Microsoft Excel 97 - 2003 | *.xls | "

	cExtens   += "Planilha do Microsoft Office Excel    | *.xlsx | "
	cExtens   += "Todos os Arquivos   | *.* | "

	//Seleciona o Local do arquivo                  
	cFileOpen := cGetFile(cExtens,cTitulo,0,,.F.,GETF_ONLYSERVER+GETF_LOCALHARD+GETF_LOCALFLOPPY+GETF_NETWORKDRIVE+GETF_OVERWRITEPROMPT)

	If !File(cFileOpen)
		MsgAlert("Nenhuma Planilha Selecionada!")
		Return		
	Else
		Processa( {|| ImpCDNXls(cFileOpen) } )
	Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณImpCDNXls บAutor  ณMarcus Ferraz       บ Data ณ07/06/2016   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo de importa็ใo da planilha                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BSL                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿  
*/

Static Function ImpCDNXls(cCam)

	Local nHdl 		  := ExecInDLLOpen('C:\DLL_EXCEL\readexcel.dll')
	Local cBuffer	  := ''
	Local cFile		  := cCam
	Local nIni  	  := 2
	Local nCont		  := 1
	Local aColun	  := {} //array com as colunas a serem lidas
	Local aPlanilha	  := {}

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
			cBuffer := "CDN_V2" + Space(512)
			ExeDLLRun2(nHdl, CMD_ACTIVEWORKSHEET, @cBuffer)

			//Tratamento para verificar se o nome da planilha aberta corresponde ao modelo
			If Alltrim(cBuffer) = "unknown error in command "
				Alert("O nome da planilha nใo corresponde ao esperado para importa็ใo. A planilha deve-se chamar (CDN_V2).")
				// Fecha o arquivo e remove o excel da memoria
				cBuffer := Space(512)
				ExeDLLRun2(nHdl, CMD_CLOSEWORKBOOK, @cBuffer)
				ExecInDLLClose(nHdl)
				Return
			Endif

			nTotal := 1
			cCel   := "A"
			nL   := 1  


			ProcRegua (Len(aPlanilha))
			//Formacao da regua de processamento

			nL := 1

			aPlan1 := {}

			Do while .T.

				IncProc("Lendo a planilha - Linha: " + StrZero(nIni,6) +" de "+StrZero(Len(aPlanilha),4))

				//Carrega a celula A2, anda verticalmente linha a linha
				cCel := "A"+Alltrim(str(nIni))
				cBuffer := cCel + Space(1024)
				nBytes = ExeDLLRun2(nHdl, CMD_READCELL, @cBuffer)

				//Verifica se o conteudo da celula e diferente de vazio

				If (Alltrim( Subs(cBuffer, 1, nBytes) ) <> "")
					//CDN_DESCR
					_cDecr := UPPER(Alltrim(Substr(cBuffer,1,60)))

					aPlan2 := {}

					//Descricao
					AAdd(aPlan2,_cDecr)

					//CDN_PROD
					cCel := "B"+Alltrim(str(nIni))
					cBuffer := cCel + Space(1024)
					nBytes = ExeDLLRun2(nHdl, CMD_READCELL, @cBuffer)
					_cProd := UPPER( Alltrim( Substr(cBuffer, 1, 15) ) )
					AAdd(aPlan2,Substr(_cProd,1,15))

					//CDN_CODISS
					cCel := "D"+Alltrim(str(nIni))
					cBuffer := cCel + Space(1024)
					nBytes = ExeDLLRun2(nHdl, CMD_READCELL, @cBuffer)
					_cCodIss	:= UPPER( Alltrim( Substr(cBuffer, 1, 8) ) )
					AAdd(aPlan2,Substr(_cCodIss,1,8))

					//CDN_CODLST
					cCel := "E"+Alltrim(str(nIni))
					cBuffer := cCel + Space(1024)
					nBytes = ExeDLLRun2(nHdl, CMD_READCELL, @cBuffer)
					_cCodLST	:= UPPER( Alltrim( Substr(cBuffer,1, 4) ) )

					AAdd(aPlan2,Substr(_cCodLST,1,4))

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

	CadCDN(aPlan1)

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCadCDN    บAutor  ณMarcus Ferraz       บ Data ณ12/09/2014   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo de importa็ใo da planilha                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BSL                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿  
*/

Static Function CadCDN(aImp)


	/*=========================================
	Array aImp

	[1] -- Descri็ใo
	[2] -- Cod. Produto
	[3] -- Cod. ISS
	[4] -- Cod. LST

	============================================*/

	Local cDescr	:= ""
	Local cCodPrd	:= ""
	Local cCodIss	:= ""
	Local cCodLst	:= ""
	Local nX		:= 0

	ProcRegua (Len(aImp))

	For nX := 1 to Len(aImp)

		IncProc("Cadastrando CDN: " + StrZero(nX,6) +" de "+StrZero(Len(aImp),6))

		//DbSelectArea("CDN") 
		//CDN->(DbSetOrder(1))//CDN_FILIAL+CDN_CODISS+CDN_PROD
		//CDN->(DbGoTop())
		//If !CDN->(MsSeek(xFilial("CDN")+aImp[nX][3]+aImp[nX][2]),.F.)
		RecLock("CDN",.T.)
		CDN->CDN_FILIAL := "01"
		CDN->CDN_DESCR	:= aImp[nX][1]
		CDN->CDN_PROD	:= aImp[nX][2]
		CDN->CDN_CODISS	:= aImp[nX][3]
		CDN->CDN_CODLST	:= aImp[nX][4]
		CDN->(mSunlock())		
		//Else
		//	RecLock("CDN",.F.)
		//	CDN->CDN_DESCR	:= aImp[nX][1]
		//	CDN->CDN_PROD	:= aImp[nX][2]
		//	CDN->CDN_CODISS	:= aImp[nX][3]
		//	CDN->CDN_CODLST	:= aImp[nX][4]
		//	CDN->(mSunlock())			
		//Endif	

	Next nX

Return()