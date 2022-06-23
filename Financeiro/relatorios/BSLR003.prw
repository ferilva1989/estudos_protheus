#Include 'PROTHEUS.CH'
#Include 'PARMTYPE.CH'
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "REPORT.CH"

User Function BSLR003()

	//������������������������������������������Ŀ
	//�Declaracao de variaveis                   �
	//��������������������������������������������
	Private oReport  := Nil
	Private oSecCab	 := Nil
	Private cPerg 	 := PadR ("BSLR003", Len (SX1->X1_GRUPO))
	//������������������������������������������Ŀ
	//�Criacao e apresentacao das perguntas      �
	//��������������������������������������������

	//Filial de/ at�;
	u_zPutSX1(cPerg, "01", "Filial de?"			,   "MV_PAR01", "MV_CH1", "C", TamSX3('E2_FILIAL')[01]	, 0, "G","","","","","","","","","Informe a filial inicial")
	u_zPutSX1(cPerg, "02", "Filial at�?"		,   "MV_PAR02", "MV_CH2", "C", TamSX3('E2_FILIAL')[01]	, 0, "G","","","","","","","","","Informe a filial final")

	//Dt emiss�o de/at�;
	u_zPutSX1(cPerg, "03", "Data Emiss�o de?"	,  "MV_PAR03", "MV_CH3", "D",08							, 0, "G","","","","","","","","","Informe a data inicial")
	u_zPutSX1(cPerg, "04", "Data Emiss�o at�?"	,  "MV_PAR04", "MV_CH4", "D",08							, 0, "G","","","","","","","","","Informe a data final")

	//Numero do t�tulo de/ at�;
	u_zPutSX1(cPerg, "05", "N�mero de?"			,  "MV_PAR05", "MV_CH5", "C", TamSX3('E2_NUM')[01]		, 0, "G","","","","","","","","","Informe o in�cio do numero do t�tulo")
	u_zPutSX1(cPerg, "06", "N�mero at�?"		,  "MV_PAR06", "MV_CH6", "C", TamSX3('E2_NUM')[01]		, 0, "G","","","","","","","","","Informe o fim do numero do t�tulo")

	//Numero da parcela de/ at�;
	u_zPutSX1(cPerg, "07", "Parcela de?"		,  "MV_PAR07", "MV_CH7", "C", TamSX3('E2_PARCELA')[01]	, 0, "G","","","","","","","","","Informe o numero inicial da parcela do t�tulo")
	u_zPutSX1(cPerg, "08", "Parcela at�?"		,  "MV_PAR08", "MV_CH8", "C", TamSX3('E2_PARCELA')[01]	, 0, "G","","","","","","","","","Informe o numero final da parcela do t�tulo")

	//C�digo do fornecedor de/ at�;
	u_zPutSX1(cPerg, "09", "Fornecedor de?"		,  "MV_PAR09", "MV_CH9", "C", TamSX3('E2_FORNECE')[01]	, 0, "G","","","","","","","","","Informe o c�digo inicial de fornecedor")
	u_zPutSX1(cPerg, "10", "Fornecedor at�?"	,  "MV_PAR10", "MV_CHA", "C", TamSX3('E2_FORNECE')[01]	, 0, "G","","","","","","","","","Informe o c�digo final de fornecedor")

	//C�digo da loja do fornecedor de/ at�;
	u_zPutSX1(cPerg, "11", "Loja de?"			,  "MV_PAR11", "MV_CHB", "C", TamSX3('E2_LOJA')[01]		, 0, "G","","","","","","","","","Informe o numero inicial da loja do fornecedor")
	u_zPutSX1(cPerg, "12", "Loja at�?"			,  "MV_PAR12", "MV_CHC", "C", TamSX3('E2_LOJA')[01]		, 0, "G","","","","","","","","","Informe o numero final da loja do fornecedor")

	//Dt vencimento real de/at�;
	u_zPutSX1(cPerg, "13", "Vencto. Real de?"	,  "MV_PAR13", "MV_CHD", "D",08							, 0, "G","","","","","","","","","Informe a data inicial")
	u_zPutSX1(cPerg, "14", "Vencto. Real at�?"	,  "MV_PAR14", "MV_CHE", "D",08							, 0, "G","","","","","","","","","Informe a data final")

	//Status de Libera��o (Pendente/Aguardando n�vel/Liberado/Bloqueado/Lib. Outro Usu.)
	u_zPutSX1(cPerg, "15", "Status de Libera��o",  "MV_PAR15", "MV_CHF", "C", TamSX3('E2_STATLIB')[01] 	, 0, "C","","","","01-Pendente","02-Aguardando n�vel","03-Liberado","04-Bloqueado","05-Lib. Outro Usu.","Informe o status da libera��o")

	//Dt de libera��o de/at�;
	u_zPutSX1(cPerg, "16", "Data de Lib. de?"	,  "MV_PAR16", "MV_CHG", "D",08							, 0, "G","","","","","","","","","Informe a data inicial da libera��o")
	u_zPutSX1(cPerg, "17", "Data de Lib. at�?"	,  "MV_PAR17", "MV_CHH", "D",08							, 0, "G","","","","","","","","","Informe a data final da libera��o")

	//������������������������������������������Ŀ
	//�Definicoes/preparacao para impressao      �
	//��������������������������������������������

	ReportDef()
	oReport	:PrintDialog()

Return Nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �BSLR003  �Autor  � Filipe Silva     � Data � 03/06/2019   ���
�������������������������������������������������������������������������͹��
���Desc.     � Defini��o da estrutura do relat�rio.                       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function REPORTDEF()

	oReport := TReport():New("BSLRFIN02","Rela��o de t�tulos com pend�ncia de aprova��o.",cPerg,{|oReport| PrintReport(oReport)},"Rela��o de t�tulos com pend�ncia de aprova��o.")
	oReport:SetTotalInLine(.F.)
	oReport:lParamPage := .F.
	oReport:oPage:SetPaperSize(9) //Folha A4
	oReport:SetLandScape() // Aqui que define Retrato ou Paisagem

	oSecCab := TRSection():New( oReport , "T�tulos com pend�ncia de aprova��o.", {"QRY"} ) 
	TRCell():New( oSecCab, "E2_FILIAL"	, "QRY", "Filial"				,,5,,,,,,,,,,,)
	TRCell():New( oSecCab, "E2_EMISSAO"	, "QRY", "Dt Emiss�o"			,PesqPict("SE2","E2_EMISSAO"), 8,,{|| STOD(QRY->E2_EMISSAO)},,,,,,,,,)
	TRCell():New( oSecCab, "E2_NUM"		, "QRY", "Nro T�tulo"			,,9,,,,,,,,,,,)
	TRCell():New( oSecCab, "E2_PARCELA"	, "QRY", "Parcela"				,,3,,,,,,,,,,,)
	TRCell():New( oSecCab, "E2_TIPO"	, "QRY", "Tp"					,,3,,,,,,,,,,,)
	TRCell():New( oSecCab, "E2_FORNECE"	, "QRY", "Cd Fornecedor"		,,6,,,,,,,,,,,)
	TRCell():New( oSecCab, "E2_LOJA"	, "QRY", "Loja Fornecedor"		,,2,,,,,,,,,,,)
	TRCell():New( oSecCab, "E2_NOMFOR"	, "QRY", "Nome Fornecedor"		,,40,,,,,,,,,,,)
	TRCell():New( oSecCab, "E2_VENCREA"	, "QRY", "Dt Vcto Real"			,PesqPict("SE2","E2_VENCREA"), 8,,{|| STOD(QRY->E2_VENCREA)},,,,,,,,,)
	TRCell():New( oSecCab, "E2_VALOR"	, "QRY", "Valor"				,,16,,,,,,,,,,,)
	TRCell():New( oSecCab, "E2_STATLIB"	, "QRY", "Cod Status"			,,2,,,,,,,,,,,)
	TRCell():New( oSecCab, "STATLIB"	, "QRY", "Desc Status"			,,60,,,,,,,,,,,)
	TRCell():New( oSecCab, "E2_DATALIB"	, "QRY", "Dt Aprova��o"		,PesqPict("SE2","E2_DATALIB"), 8,,{|| STOD(QRY->E2_DATALIB)},,,,,,,,,)
	TRCell():New( oSecCab, "E2_USUALIB"	, "QRY", "Usu�rio Lib"			,,25,,,,,,,,,,,)

	TRFunction():New(oSecCab:Cell("E2_NUM"),,"COUNT",,,,,.F.,.T.,.F.,oSecCab)

Return Nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �BSLR003  �Autor  � Filipe Silva     � Data � 03/07/2019   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function PrintReport(oReport)

	Local cQuery     := ""

	Pergunte(cPerg,.F.)

	//query para trazer as solicita��es de compra

	cQuery += " SELECT DISTINCT														" + CRLF
	cQuery += " 	   E2_FILIAL,													" + CRLF
	cQuery += " 	   E2_EMISSAO,													" + CRLF
	cQuery += " 	   E2_NUM,														" + CRLF
	cQuery += " 	   E2_PARCELA,													" + CRLF
	cQuery += " 	   E2_TIPO,														" + CRLF
	cQuery += " 	   E2_FORNECE,													" + CRLF
	cQuery += " 	   E2_LOJA,														" + CRLF
	cQuery += " 	   E2_NOMFOR,													" + CRLF
	cQuery += " 	   E2_VENCREA,													" + CRLF
	cQuery += " 	   E2_VALOR,													" + CRLF
	cQuery += " 	   E2_STATLIB,													" + CRLF
	cQuery += " 	   CASE E2_STATLIB												" + CRLF
	cQuery += " 			WHEN '01' THEN 'Esperando aprova��o do usu�rio'			" + CRLF
	cQuery += " 			WHEN '02' THEN 'Bloqueado (esperando outros n�veis)'	" + CRLF
	cQuery += " 			WHEN '03' THEN 'Movimento liberado pelo usu�rio'		" + CRLF
	cQuery += " 			WHEN '04' THEN 'Movimento bloqueado pelo usu�rio'		" + CRLF
	cQuery += " 			WHEN '05' THEN 'Movimento liberado por outro usu�rio'	" + CRLF
	cQuery += " 			ELSE 'Sem bloqueio para aprova��o'						" + CRLF
	cQuery += " 		END STATLIB,												" + CRLF
	cQuery += " 	   E2_DATALIB,													" + CRLF
	cQuery += " 	   E2_USUALIB													" + CRLF

	cQuery += " FROM  " + RetSqlName("SE2") + CRLF

	cQuery += " WHERE " + CRLF 
	cQuery += " 	E2_FILIAL BETWEEN '	"	+ MV_PAR01		 + "' AND '" + MV_PAR02 	  + "' AND"	+ CRLF 
	cQuery += " 	E2_EMISSAO BETWEEN '"	+ DTOS(MV_PAR03) + "' AND '" + DTOS(MV_PAR04) + "' AND"	+ CRLF
	cQuery += " 	E2_NUM BETWEEN '	"	+ MV_PAR05 		 + "' AND '" + MV_PAR06 	  + "' AND"	+ CRLF
	cQuery += " 	E2_PARCELA BETWEEN '"	+ MV_PAR07 		 + "' AND '" + MV_PAR08 	  + "' AND"	+ CRLF
	cQuery += " 	E2_FORNECE BETWEEN '"	+ MV_PAR09 		 + "' AND '" + MV_PAR10 	  + "' AND"	+ CRLF
	cQuery += " 	E2_LOJA BETWEEN '	"	+ MV_PAR11 		 + "' AND '" + MV_PAR12 	  + "' AND"	+ CRLF
	cQuery += " 	E2_VENCREA BETWEEN '"	+ DTOS(MV_PAR13) + "' AND '" + DTOS(MV_PAR14) + "' AND"	+ CRLF

	If MV_PAR15 == 1
		cQuery += " E2_STATLIB   =       '01' AND " + CRLF
	ElseIf MV_PAR15 == 2
		cQuery += " E2_STATLIB   =       '02' AND " + CRLF
	ElseIf MV_PAR15 == 3
		cQuery += " E2_STATLIB   =       '03' AND " + CRLF
	ElseIf MV_PAR15 == 4
		cQuery += " E2_STATLIB   =       '04' AND " + CRLF
	Else
		cQuery += " E2_STATLIB   =       '05' AND " + CRLF   
	EndIf

	cQuery += " 	E2_DATALIB BETWEEN '"	+ DTOS(MV_PAR16) + "' AND '" + DTOS(MV_PAR17) + "'" + CRLF

	cQuery := ChangeQuery(cQuery)

	If Select("QRY") > 0
		Dbselectarea("QRY")
		QRY->(DbClosearea())
	EndIf

	TcQuery cQuery New Alias "QRY"

	oSecCab:Print()

Return Nil

/*---------------------------------------------------*
| Fun��o: fPutHelp                                  |
| Desc:   Fun��o que insere o Help do Parametro     |
*---------------------------------------------------*/

Static Function fPutHelp(cKey, cHelp, lUpdate)
	Local cFilePor  := "SIGAHLP.HLP"
	Local cFileEng  := "SIGAHLE.HLE"
	Local cFileSpa  := "SIGAHLS.HLS"
	Local nRet      := 0
	Default cKey    := ""
	Default cHelp   := ""
	Default lUpdate := .F.

	//Se a Chave ou o Help estiverem em branco
	If Empty(cKey) .Or. Empty(cHelp)
		Return
	EndIf

	//**************************** Portugu�s
	nRet := SPF_SEEK(cFilePor, cKey, 1)

	//Se n�o encontrar, ser� inclus�o
	If nRet < 0
		SPF_INSERT(cFilePor, cKey, , , cHelp)

		//Sen�o, ser� atualiza��o
	Else
		If lUpdate
			SPF_UPDATE(cFilePor, nRet, cKey, , , cHelp)
		EndIf
	EndIf



	//**************************** Ingl�s
	nRet := SPF_SEEK(cFileEng, cKey, 1)

	//Se n�o encontrar, ser� inclus�o
	If nRet < 0
		SPF_INSERT(cFileEng, cKey, , , cHelp)

		//Sen�o, ser� atualiza��o
	Else
		If lUpdate
			SPF_UPDATE(cFileEng, nRet, cKey, , , cHelp)
		EndIf
	EndIf

	//**************************** Espanhol
	nRet := SPF_SEEK(cFileSpa, cKey, 1)

	//Se n�o encontrar, ser� inclus�o
	If nRet < 0
		SPF_INSERT(cFileSpa, cKey, , , cHelp)

		//Sen�o, ser� atualiza��o
	Else
		If lUpdate
			SPF_UPDATE(cFileSpa, nRet, cKey, , , cHelp)
		EndIf
	EndIf

Return