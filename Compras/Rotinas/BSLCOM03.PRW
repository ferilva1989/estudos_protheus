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
ฑฑบPrograma  ณBSLCOM03บAutor  ณMarcus Ferraz       บ Data ณ15/04/2017     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina automatica para cadastro de pr้-nota.               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BSL                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿  
*/

User function BSLCOM03(aImp)

	Local nX		:= 0
	Local nY		:= 0
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
	Local _cLog 	:= "Processo Finalizado"+CRLF
	Local cItem 	:= "00"
	Local cQuebrAnt := ""
	Local cFornAnt	:= ""
	Local cNFAnt	:= ""
	Local cForPre	:= ""
	Local cLojPre	:= ""
	Local _cPrd		:= ""
	Local dDtEntr	:= dDataBase
	Local cRetStr	:= ""

	PRIVATE lMsErroAuto := .F.


	PREPARE ENVIRONMENT EMPRESA '01' FILIAL '001' TABLES 'SF1,SD1,SA2,SB1' MODULO 'COM'

	/*

	01 - _FILIAL
	02 - _NOTA
	03 - _SERIE
	04 - _PRODUTO
	05 - _QUANT
	06 - _VALOR
	07 - _CCUSTO
	08 - _CNPJ
	09 - _DTEMIS
	10 - _DTENTR
	11 - _QUEBRA

	*/

	//Inicia a Gera็ใo da Pr้-nota
	For nX := 1 to Len(aImp)

		//Valida se serแ gerado a pr้-nota ou se continua montando a linha de Itens.

		If Alltrim(aImp[nX][11]) <> cQuebrAnt .Or.;
				Alltrim(aImp[nX][1]) <> cFilAnt .Or.;
				Alltrim(aImp[nX][2])+Alltrim(aImp[nX][3]) <> cNFAnt .Or.;
				Alltrim(aImp[nX][8]) <> cFornAnt    // Condi็ใo de pular linha

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
							DisarmTransaction()
							cPath := "C:\LOG\ADT\CR\"
							MostraErro(cPath,cCodSAP+".Log")
							cMemo := MemoRead(cPath+cCodSAP+".Log")

							aLog[nQtLog][2] := cNImport

							If Substr(cMemo,1,13) == "HELP: OBRIGAT"
								cErrorLog	:=	AllTrim(Substring(cMemo,Rat(".",cMemo)+3,Len(cMemo)-Rat(".",cMemo))) +" < -- Obrigatorio "
							Else
								nAuxLErro	:= 	AT("<",cMemo)
								nAuxIniErr	:=	nAuxLErro - ( 100 - Rat(Chr(10),Substr(cMemo,nAuxLErro-100,100)))
								nAuxFimErr	:=	At(Chr(10),Substring(cMemo,nAuxLErro,20))
								cErrorLog	:=	Substr(cMemo, nAuxIniErr,(nAuxLErro-nAuxIniErr)+nAuxFimErr)
							EndIf
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
		cQuebrAnt	:= Alltrim(aImp[nX][11])
		cFornAnt	:= Alltrim(aImp[nX][8])
		cNFAnt		:= Alltrim(aImp[nX][2])+Alltrim(aImp[nX][3])
		dDtEntr		:= aImp[nX][10]

		If _lCabec

			cQuery := "SELECT A2_COD, A2_LOJA FROM SA2010 WHERE A2_CGC = '"+Alltrim(aImp[nX][8])+"'"

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
				{'F1_EMISSAO'		,aImp[nX][9]	,NIL},;
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

		aItens :=	{	{'D1_ITEM'	,cItem						,NIL},;
			{'D1_COD'		,aImp[nX][4]				,NIL},;
			{'D1_QUANT'		,aImp[nX][5]				,NIL},;
			{'D1_VUNIT'		,aImp[nX][6]				,NIL},;
			{'D1_TOTAL'		,aImp[nX][5]*aImp[nX][6]	,NIL},;
			{'D1_CC'		,aImp[nX][7]				,NIL}}

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

	RESET ENVIRONMENT

Return(cRetStr)
