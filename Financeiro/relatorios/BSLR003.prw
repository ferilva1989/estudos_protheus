#Include 'PROTHEUS.CH'
#Include 'PARMTYPE.CH'
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "REPORT.CH"

User Function BSLR003()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Declaracao de variaveis                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Private oReport  := Nil
	Private oSecCab	 := Nil
	Private cPerg 	 := PadR ("BSLR003", Len (SX1->X1_GRUPO))
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Criacao e apresentacao das perguntas      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	//Filial de/ até;
	u_zPutSX1(cPerg, "01", "Filial de?"			,   "MV_PAR01", "MV_CH1", "C", TamSX3('E2_FILIAL')[01]	, 0, "G","","","","","","","","","Informe a filial inicial")
	u_zPutSX1(cPerg, "02", "Filial até?"		,   "MV_PAR02", "MV_CH2", "C", TamSX3('E2_FILIAL')[01]	, 0, "G","","","","","","","","","Informe a filial final")

	//Dt emissão de/até;
	u_zPutSX1(cPerg, "03", "Data Emissão de?"	,  "MV_PAR03", "MV_CH3", "D",08							, 0, "G","","","","","","","","","Informe a data inicial")
	u_zPutSX1(cPerg, "04", "Data Emissão até?"	,  "MV_PAR04", "MV_CH4", "D",08							, 0, "G","","","","","","","","","Informe a data final")

	//Numero do título de/ até;
	u_zPutSX1(cPerg, "05", "Número de?"			,  "MV_PAR05", "MV_CH5", "C", TamSX3('E2_NUM')[01]		, 0, "G","","","","","","","","","Informe o início do numero do título")
	u_zPutSX1(cPerg, "06", "Número até?"		,  "MV_PAR06", "MV_CH6", "C", TamSX3('E2_NUM')[01]		, 0, "G","","","","","","","","","Informe o fim do numero do título")

	//Numero da parcela de/ até;
	u_zPutSX1(cPerg, "07", "Parcela de?"		,  "MV_PAR07", "MV_CH7", "C", TamSX3('E2_PARCELA')[01]	, 0, "G","","","","","","","","","Informe o numero inicial da parcela do título")
	u_zPutSX1(cPerg, "08", "Parcela até?"		,  "MV_PAR08", "MV_CH8", "C", TamSX3('E2_PARCELA')[01]	, 0, "G","","","","","","","","","Informe o numero final da parcela do título")

	//Código do fornecedor de/ até;
	u_zPutSX1(cPerg, "09", "Fornecedor de?"		,  "MV_PAR09", "MV_CH9", "C", TamSX3('E2_FORNECE')[01]	, 0, "G","","","","","","","","","Informe o código inicial de fornecedor")
	u_zPutSX1(cPerg, "10", "Fornecedor até?"	,  "MV_PAR10", "MV_CHA", "C", TamSX3('E2_FORNECE')[01]	, 0, "G","","","","","","","","","Informe o código final de fornecedor")

	//Código da loja do fornecedor de/ até;
	u_zPutSX1(cPerg, "11", "Loja de?"			,  "MV_PAR11", "MV_CHB", "C", TamSX3('E2_LOJA')[01]		, 0, "G","","","","","","","","","Informe o numero inicial da loja do fornecedor")
	u_zPutSX1(cPerg, "12", "Loja até?"			,  "MV_PAR12", "MV_CHC", "C", TamSX3('E2_LOJA')[01]		, 0, "G","","","","","","","","","Informe o numero final da loja do fornecedor")

	//Dt vencimento real de/até;
	u_zPutSX1(cPerg, "13", "Vencto. Real de?"	,  "MV_PAR13", "MV_CHD", "D",08							, 0, "G","","","","","","","","","Informe a data inicial")
	u_zPutSX1(cPerg, "14", "Vencto. Real até?"	,  "MV_PAR14", "MV_CHE", "D",08							, 0, "G","","","","","","","","","Informe a data final")

	//Status de Liberação (Pendente/Aguardando nível/Liberado/Bloqueado/Lib. Outro Usu.)
	u_zPutSX1(cPerg, "15", "Status de Liberação",  "MV_PAR15", "MV_CHF", "C", TamSX3('E2_STATLIB')[01] 	, 0, "C","","","","01-Pendente","02-Aguardando nível","03-Liberado","04-Bloqueado","05-Lib. Outro Usu.","Informe o status da liberação")

	//Dt de liberação de/até;
	u_zPutSX1(cPerg, "16", "Data de Lib. de?"	,  "MV_PAR16", "MV_CHG", "D",08							, 0, "G","","","","","","","","","Informe a data inicial da liberação")
	u_zPutSX1(cPerg, "17", "Data de Lib. até?"	,  "MV_PAR17", "MV_CHH", "D",08							, 0, "G","","","","","","","","","Informe a data final da liberação")

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Definicoes/preparacao para impressao      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	ReportDef()
	oReport	:PrintDialog()

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³BSLR003  ºAutor  ³ Filipe Silva     º Data ³ 03/06/2019   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Definição da estrutura do relatório.                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function REPORTDEF()

	oReport := TReport():New("BSLRFIN02","Relação de títulos com pendência de aprovação.",cPerg,{|oReport| PrintReport(oReport)},"Relação de títulos com pendência de aprovação.")
	oReport:SetTotalInLine(.F.)
	oReport:lParamPage := .F.
	oReport:oPage:SetPaperSize(9) //Folha A4
	oReport:SetLandScape() // Aqui que define Retrato ou Paisagem

	oSecCab := TRSection():New( oReport , "Títulos com pendência de aprovação.", {"QRY"} ) 
	TRCell():New( oSecCab, "E2_FILIAL"	, "QRY", "Filial"				,,5,,,,,,,,,,,)
	TRCell():New( oSecCab, "E2_EMISSAO"	, "QRY", "Dt Emissão"			,PesqPict("SE2","E2_EMISSAO"), 8,,{|| STOD(QRY->E2_EMISSAO)},,,,,,,,,)
	TRCell():New( oSecCab, "E2_NUM"		, "QRY", "Nro Título"			,,9,,,,,,,,,,,)
	TRCell():New( oSecCab, "E2_PARCELA"	, "QRY", "Parcela"				,,3,,,,,,,,,,,)
	TRCell():New( oSecCab, "E2_TIPO"	, "QRY", "Tp"					,,3,,,,,,,,,,,)
	TRCell():New( oSecCab, "E2_FORNECE"	, "QRY", "Cd Fornecedor"		,,6,,,,,,,,,,,)
	TRCell():New( oSecCab, "E2_LOJA"	, "QRY", "Loja Fornecedor"		,,2,,,,,,,,,,,)
	TRCell():New( oSecCab, "E2_NOMFOR"	, "QRY", "Nome Fornecedor"		,,40,,,,,,,,,,,)
	TRCell():New( oSecCab, "E2_VENCREA"	, "QRY", "Dt Vcto Real"			,PesqPict("SE2","E2_VENCREA"), 8,,{|| STOD(QRY->E2_VENCREA)},,,,,,,,,)
	TRCell():New( oSecCab, "E2_VALOR"	, "QRY", "Valor"				,,16,,,,,,,,,,,)
	TRCell():New( oSecCab, "E2_STATLIB"	, "QRY", "Cod Status"			,,2,,,,,,,,,,,)
	TRCell():New( oSecCab, "STATLIB"	, "QRY", "Desc Status"			,,60,,,,,,,,,,,)
	TRCell():New( oSecCab, "E2_DATALIB"	, "QRY", "Dt Aprovação"		,PesqPict("SE2","E2_DATALIB"), 8,,{|| STOD(QRY->E2_DATALIB)},,,,,,,,,)
	TRCell():New( oSecCab, "E2_USUALIB"	, "QRY", "Usuário Lib"			,,25,,,,,,,,,,,)

	TRFunction():New(oSecCab:Cell("E2_NUM"),,"COUNT",,,,,.F.,.T.,.F.,oSecCab)

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³BSLR003  ºAutor  ³ Filipe Silva     º Data ³ 03/07/2019   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function PrintReport(oReport)

	Local cQuery     := ""

	Pergunte(cPerg,.F.)

	//query para trazer as solicitações de compra

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
	cQuery += " 			WHEN '01' THEN 'Esperando aprovação do usuário'			" + CRLF
	cQuery += " 			WHEN '02' THEN 'Bloqueado (esperando outros níveis)'	" + CRLF
	cQuery += " 			WHEN '03' THEN 'Movimento liberado pelo usuário'		" + CRLF
	cQuery += " 			WHEN '04' THEN 'Movimento bloqueado pelo usuário'		" + CRLF
	cQuery += " 			WHEN '05' THEN 'Movimento liberado por outro usuário'	" + CRLF
	cQuery += " 			ELSE 'Sem bloqueio para aprovação'						" + CRLF
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
| Função: fPutHelp                                  |
| Desc:   Função que insere o Help do Parametro     |
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

	//**************************** Português
	nRet := SPF_SEEK(cFilePor, cKey, 1)

	//Se não encontrar, será inclusão
	If nRet < 0
		SPF_INSERT(cFilePor, cKey, , , cHelp)

		//Senão, será atualização
	Else
		If lUpdate
			SPF_UPDATE(cFilePor, nRet, cKey, , , cHelp)
		EndIf
	EndIf



	//**************************** Inglês
	nRet := SPF_SEEK(cFileEng, cKey, 1)

	//Se não encontrar, será inclusão
	If nRet < 0
		SPF_INSERT(cFileEng, cKey, , , cHelp)

		//Senão, será atualização
	Else
		If lUpdate
			SPF_UPDATE(cFileEng, nRet, cKey, , , cHelp)
		EndIf
	EndIf

	//**************************** Espanhol
	nRet := SPF_SEEK(cFileSpa, cKey, 1)

	//Se não encontrar, será inclusão
	If nRet < 0
		SPF_INSERT(cFileSpa, cKey, , , cHelp)

		//Senão, será atualização
	Else
		If lUpdate
			SPF_UPDATE(cFileSpa, nRet, cKey, , , cHelp)
		EndIf
	EndIf

Return