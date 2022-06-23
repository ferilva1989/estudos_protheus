#include "protheus.ch"
#include "Topconn.ch"
#Include "TbiConn.ch"
#Include "TbiCode.ch"
#INCLUDE "rwmake.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBSLJOB01   บAutor  ณ Marcus Ferraz      บ Data ณ 08/07/2016 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina que gera Planilha para envio de E-mail com a planilhaฑฑ
ฑฑบ          ณ de fornecedores.                                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BSL                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function BSLJOB01(_xEmpresa, _xFilial)

	Default _xEmpresa := '01'
	Default _xFilial  := '01001'

	IF FindFunction('WFPREPENV')
		WfPrepEnv(_xEmpresa, _xFilial)
		Conout("Preparar ambiente: Empresa - "  + _xEmpresa + " Filial: " +_xFilial)
		U_BSLEXCFOR()
	Else
		Prepare Environment Empresa _xEmpresa Filial _xFilial
		U_BSLEXCFOR()
	EndIF


	//ChkFile("SM0")
	Reset Environment

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBSLEXCFOR  บAutor  ณ Marcus Ferraz      บ Data ณ 08/07/2016 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina que gera Planilha para envio de E-mail com a planilhaฑฑ
ฑฑบ          ณ de fornecedores.                                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BSL                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function BSLEXCFOR()

	Local cArquivo 	:= "FORNEC_BSL"//CriaTrab(,.F.)
	Local cPath 	:= AllTrim(GetTempPath())
	Local oExcelApp
	Local nHandle
	Local cDirDocs 	:= ''//MsDocPath()
	Local cCrLf    	:= Chr(13) + Chr(10)
	Local cQuery	:= ""
	Local cHTML	   	:= ""
	Local cArqCsv	:= ""
	Local cFrom		:= ""
	Local aFrom		:= {}

	If Select("SX6") == 0
		RPCSetType(3) // Nao utilizar licenca
		PREPARE environment EMPRESA ( "01" ) FILIAL ( "01001" ) MODULO "COM"
	EndIf

	cDirDocs 	:= 'dirdoc\co01\shared'//MsDocPath()

	cQuery := " SELECT A2_NOME, A2_NREDUZ, A2_CGC, A2_BANCO FROM "+RetSqlName("SA2")+" WHERE D_E_L_E_T_ = '' AND A2_TIPO = 'J' "

	If SELECT("TSA2") <> 0
		TSA2->(dbCloseArea())
	Endif

	TcQuery cQuery new alias "TSA2"
	DbSelectArea("TSA2")
	TSA2->(DbGoTop())

	nHandle := MsfCreate(cDirDocs+"\"+cArquivo+".CSV",0)

	If nHandle > 0

		fWrite(nHandle, "Rela็ใo de Fornecedores "+cCrLf)
		fWrite(nHandle, ""+cCrLf)
		fWrite(nHandle, ""+cCrLf)
		fWrite(nHandle, "RAZรO SOCIAL;NOME FANTASIA;CNPJ;BANCO"+cCrLf)

		Do While TSA2->(!Eof())
			fWrite(nHandle, TSA2->A2_NOME+";"+TSA2->A2_NREDUZ+";'"+TSA2->A2_CGC+";'"+TSA2->A2_BANCO+cCrLf)
			TSA2->(DbSkip())
		Enddo

		TSA2->(DbCloseArea())

		fWrite(nHandle, ""+cCrLf)
		fClose(nHandle)

		//CpyS2T( cDirDocs+"\"+cArquivo+".CSV" , cPath, .T. )

		cArqCsv := cDirDocs+"\"+cArquivo+".CSV"
		cHTML := GeraHtml();


		cQuery := " SELECT A2_XMAILC FROM "+RetSqlName("SA2")+" WHERE D_E_L_E_T_ = '' AND A2_XENVMAI = '1' "

		If SELECT("TSA2B") <> 0
			TSA2B->(dbCloseArea())
		Endif

		TcQuery cQuery new alias "TSA2B"
		DbSelectArea("TSA2B")
		TSA2B->(DbGoTop())

		Do While TSA2B->(!Eof())
			cFrom += Alltrim(TSA2B->A2_XMAILC)+";"
			TSA2B->(DbSkip())
		Enddo

		If substr(cFrom,len(cFrom),1) == ";"
			cFrom := substr(cFrom,1,len(cFrom)-1)
		EndIf

		//U_BSENVMAIL("BSL",cFrom,"FORCENEDORES BSL",cHTML,cArqCsv,.T.,cFrom)
		//U_BSENVMAIL("BSL","marcus.ferraz@brasilseniorliving.com.br","FORCENEDORES BSL",cHTML,cArqCsv,.T.,cFrom)


		Ferase(cDirDocs+"\"+cArquivo+".CSV" )

		RESET ENVIRONMENT

	EndIf

Return

/*Gera HTML com o Corpo do e-mail*/
Static Function GeraHtml()

	Local _cHTML := ""

	_cHTML:='<HTML><HEAD><TITLE></TITLE>'
	_cHTML+='<META http-equiv=Content-Type content="text/html; charset=windows-1252">'
	_cHTML+='<META content="MSHTML 6.00.6000.16735" name=GENERATOR></HEAD>'
	_cHTML+='<BODY>'
	_cHTML+='<H1><FONT color=#6C7B8B>Rela็ใo de Fornecedores BSL</FONT></H1>'
	_cHTML+='<P>&nbsp;</P>'
	_cHTML+='</BODY></HTML>'

Return(_cHTML)
