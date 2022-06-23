#include 'protheus.ch'
#include 'parmtype.ch'
#include "TOTVS.CH"
#include "FINA200.CH"
#include "fileio.ch"
#Include "FWMVCDEF.CH"
#Include "TbiConn.ch"

Static __nExeProc := 0
Static lFWCodFil  := .T.
Static nTamNat	  := 0
Static lVerifNat  := .F.

user function BSLBXAT()

	Local aArea     	:= GetArea()
	Local cFileLoc      := ""
	Local aFileRet		:= ""
	Local nNext			:= 0
	Local nNext1		:= 0
	Local nTipo         := 0
	Local cXEmpresa		:= ""
	Local cCnbFilial	:= ""
	Local aCnab			:= {}
	Local cBanco 		:= ""
	Local cAgencia 		:= ""
	Local cConta 		:= ""
	Local cSubConta 	:= ""
	Local cFile  		:= ""
	Local cQuery		:= ""
	Local nRecnoSee     := 0
	Local cTitulo       := ""
	Local aAFI200		:= {}
	Local cFileNew      := ""
	Local cXFilial  	:= ""
	Local cXPrefixo 	:= ""
	Local cXTipo    	:= ""
	Local cXParcela 	:= ""
	Local cXDescr 		:= ""
	Local cXProcessado 	:= ""
	Local cXNum         := ""
	Local cXOcorr       := ""
	Local dXDataBx      := ""
	Local cXObs 		:= ""
	Local cXIdCnab      := ""
	Local cFileCfg      := ""
	Local lFlag         := .F.
	Local nIdRecno		:= 0
	Private lExecJob 	:= .T.
	Private aMsgSch  	:= {}
	Private ALTERA      := .F.
	Private aFA205R     := {}
	Private cArqCfg     := ""

	PREPARE ENVIRONMENT EMPRESA '01' FILIAL '01001'

	For nTipo := 1 to 2

		If nTipo == 1 	// Cnab 400 posições
			cFileLoc := AllTrim(GetMv("ZZ_LOC001")) // Local do arquivo de Recebimento Cnab 400 Posições.
			cFileCfg := GetMv("ZZ_FIL001")
		Else			// Sispag Itau
			cFileLoc := AllTrim(GetMv("ZZ_LOC008")) // Local do arquivo de Recebimento Sispag.
			cFileCfg := GetMv("ZZ_FIL008")
		EndIf

		aFileRet := Directory(cFileLoc + "*.*") // Nome dos Arquivos que serão processados.

		For nNext := 1 to Len(aFileRet)

			// Leitura do Arquivo.
			aCnab := {}
			FT_FUSE(Upper(AllTrim(cFileLoc + aFileRet[nNext,1])))
			FT_FGOTOP()
			While !FT_FEOF()
				cLinha := FT_FREADLN()
				AADD(aCnab,cLinha)
				FT_FSKIP()
			EndDo
			FT_FUSE()

			cCnbFilial := ""
			lFlag      := .F.

			If nTipo == 1 // Cnab 400 Posições
				For nNext1 := 1 to Len(aCnab)

					If SubStr(aCnab[nNext1], 001, 001) == "0" // Header do Cnab
						lFlag     := .T.
						cBanco    := SubStr(aCnab[nNext1], 077, 003)				// Codigo do Banco ?
						cAgencia  := SubStr(aCnab[nNext1], 027, 004) + Space(01)	// Codigo da Agencia ?
						cConta    := SubStr(aCnab[nNext1], 033, 005) + Space(05)	// Codigo da Conta ?

						dDataBase := SubStr(aCnab[nNext1], 114, 006)                // Muda a data do sistema de Acordo com a data do Arquivo.
						dDataBase := Ctod(SubStr(dDataBase,1,2) + "/" + SubStr(dDataBase,3,2) + "/" + SubStr(dDataBase,5,2))

						// Localiza a SubConta no Arquivo SEE
						cQuery := " SELECT              					"
						cQuery += "        SEE.EE_SUBCTA,      				"
						cQuery += "        SEE.EE_FILIAL,      				"
						cQuery += "        SEE.R_E_C_N_O_					"
						cQuery += " FROM "      + RetSqlName("SEE") + " SEE "
						cQuery += " WHERE 									"
						cQuery += "     SEE.EE_CONTA   = '" + cConta   +  "'"
						cQuery += " AND SEE.EE_AGENCIA = '" + cAgencia +  "'"
						cQuery += " AND SEE.EE_CODIGO  = '" + cBanco   +  "'"
						cQuery += " AND SEE.D_E_L_E_T_ <> '*'               "

						cQuery := ChangeQuery(cQuery)
						cFile  := GetNextAlias()
						dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cFile,.F.,.T.)

						If (cFile)->(!Eof())
							cSubConta  :=          (cFile)->EE_SUBCTA
							nRecnoSee  :=          (cFile)->R_E_C_N_O_
							cXEmpresa  := AllTrim( (cFile)->EE_FILIAL  )
						EndIf
						(cFile)->(DbCloseArea())

						// Posiciona a tabela, será utilizada no FINA200
						SEE->( Dbsetorder(1))
						SEE->( Dbgoto( nRecnoSee ) )

					EndIf

					If SubStr(aCnab[nNext1], 001, 001) == "1" .And. cCnbFilial == "" // Detalhe do Arquivo
						cTitulo  := AllTrim(SubStr(aCnab[nNext1], 041, 020)) // Numero do Título

						// Localiza a SubConta no Arquivo SEE
						cQuery := " SELECT              				"
						cQuery += "        SE1.E1_FILIAL  				"
						cQuery += " FROM " + RetSqlName("SE1") +  " SE1 "
						cQuery += " WHERE 							 	"
						cQuery += "     SE1.E1_NUM = '" + cTitulo  +  "'"

						cQuery := ChangeQuery(cQuery)
						cFile  := GetNextAlias()
						dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cFile,.F.,.T.)

						If (cFile)->(!Eof())
							cCnbFilial := (cFile)->E1_FILIAL
						EndIf
						(cFile)->(DbCloseArea())
					EndIf
				Next

			Else  // Sispag Itau

				For nNext1 := 1 to Len(aCnab)

					If SubStr(aCnab[nNext1], 008, 001) == "0" // Header do Cnab
						lFlag     := .T.
						cBanco    := SubStr(aCnab[nNext1], 001, 003)				// Codigo do Banco ?
						cAgencia  := SubStr(aCnab[nNext1], 054, 004) + Space(01)	// Codigo da Agencia ?
						cConta    := SubStr(aCnab[nNext1], 066, 005) + Space(05)	// Codigo da Conta ?

						dDataBase := SubStr(aCnab[nNext1], 144, 008)                // Muda a data do sistema de Acordo com a data do Arquivo.
						dDataBase := Ctod(SubStr(dDataBase,1,2) + "/" + SubStr(dDataBase,3,2) + "/" + SubStr(dDataBase,5,4))

						// Localiza a SubConta no Arquivo SEE
						cQuery := " SELECT              					"
						cQuery += "        SEE.EE_SUBCTA,      				"
						cQuery += "        SEE.EE_FILIAL,      				"
						cQuery += "        SEE.R_E_C_N_O_					"
						cQuery += " FROM "      + RetSqlName("SEE") + " SEE "
						cQuery += " WHERE 									"
						cQuery += "     SEE.EE_CONTA   = '" + cConta   +  "'"
						cQuery += " AND SEE.EE_AGENCIA = '" + cAgencia +  "'"
						cQuery += " AND SEE.EE_CODIGO  = '" + cBanco   +  "'"
						cQuery += " AND SEE.D_E_L_E_T_ <> '*'               "

						cQuery := ChangeQuery(cQuery)
						cFile  := GetNextAlias()
						dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cFile,.F.,.T.)

						If (cFile)->(!Eof())
							cSubConta  :=          (cFile)->EE_SUBCTA
							nRecnoSee  :=          (cFile)->R_E_C_N_O_
							cXEmpresa  := AllTrim( (cFile)->EE_FILIAL  )
						EndIf
						(cFile)->(DbCloseArea())

						// Posiciona a tabela, será utilizada no FINA200
						SEE->( Dbsetorder(1))
						SEE->( Dbgoto( nRecnoSee ) )
					EndIf

					If SubStr(aCnab[nNext1], 008, 001) == "3" .And. SubStr(aCnab[nNext1], 014, 001) $ "A.J.N.O" .And. cCnbFilial == "" // Detalhe do Arquivo
						Do Case
							Case SubStr(aCnab[nNext1], 014, 001) == "A"; cTitulo := SubStr(aCnab[nNext1], 074, 10)
							Case SubStr(aCnab[nNext1], 014, 001) == "J"; cTitulo := SubStr(aCnab[nNext1], 183, 10)
							Case SubStr(aCnab[nNext1], 014, 001) == "N"; cTitulo := SubStr(aCnab[nNext1], 196, 10)
							Case SubStr(aCnab[nNext1], 014, 001) == "O"; cTitulo := SubStr(aCnab[nNext1], 175, 10)
						EndCase

						// Localiza a SubConta no Arquivo SEE
						cQuery := " SELECT              				"
						cQuery += "        SE2.E2_FILIAL  				"
						cQuery += " FROM " + RetSqlName("SE2") +  " SE2 "
						cQuery += " WHERE 							 	"
						cQuery += "     SE2.E2_IDCNAB = '" + cTitulo  +  "'"

						cQuery := ChangeQuery(cQuery)
						cFile  := GetNextAlias()
						dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cFile,.F.,.T.)

						If (cFile)->(!Eof())
							cCnbFilial := (cFile)->E2_FILIAL
						EndIf
						(cFile)->(DbCloseArea())
					EndIf

				Next

			EndIf

			// Se não for um Arquivo de Cnab ou SisPag, Pula arquivo.
			If !lFlag
				Loop
			EndIf

			// Muda a filial manualmente no sistema
			If !Empty(cCnbFilial)
				cFilAnt := cCnbFilial
				cNumEmp := cEmpAnt + cFilAnt
			EndIf

			// Definição dos Parametros de Entrada
			MV_PAR01 := 2                                           	// Mostra Lanc Contab ?
			MV_PAR02 := 2 												// Aglut Lancamentos ?
			MV_PAR03 := 3 												// Atualiza Moedas por ?
			MV_PAR04 := Upper(AllTrim(cFileLoc + aFileRet[nNext,1])) 	// Arquivo de Entrada ?
			MV_PAR05 := AllTrim(cFileCfg)			 					// Arquivo de Config ?
			MV_PAR06 := cBanco											// Codigo do Banco ?
			MV_PAR07 := cAgencia 										// Codigo da Agencia ?
			MV_PAR08 := cConta 											// Codigo da Conta ?
			MV_PAR09 := cSubConta										// Codigo da Sub-Conta ?
			MV_PAR10 := 2   											// Abate Desc Comissao ?
			MV_PAR11 := 1   											// Contabiliza On Line ?
			MV_PAR12 := 1   											// Configuracao CNAB ?
			MV_PAR13 := 1    											// Processa Filial?  -- de acordo com a filiar do arquivo...
			MV_PAR14 := 2    											// Contabiliza Transferencia ?
			MV_PAR15 := 2   											// Considera Dias de Retencao ?
			MV_PAR16 := 2    											// Considera Juros Comissão ?

			// Nome do Novo Arquivo
			cFileNew := AllTrim(cCnbFilial) +"_"+ AllTrim(aFileRet[nNext,1])

			If nTipo == 1 // Cnab 400 posições.
				// controle de mensagens de erro
				aMsgSch := {}
				// controle de titulos baixados
				aFA205R := {}
				// Chama rotina automática
				BSLBXAT1(3)

			Else  // Sispag Itau

				U_BSLBXAT2()

			EndIf

			MakeDir(AllTrim(cFileLoc)+StrZero(Year(Date()),4))
			MakeDir(AllTrim(cFileLoc)+StrZero(Year(Date()),4)+"\"+StrZero(Month(Date()),2))

			// copia o arquivo para o diretorio de backup
			__CopyFile(AllTrim(cFileLoc) + aFileRet[nNext, 01],  cFileLoc+StrZero(Year(Date()),4)+"\"+StrZero(Month(Date()),2) + "\" + cFileNew)

			If File(cFileLoc+StrZero(Year(Date()),4)+"\"+StrZero(Month(Date()),2) + "\" + cFileNew)
				Ferase(cFileLoc + aFileRet[nNext, 01])
			EndIf

			// Log de Processamento do Arquivo.
			For nNext1 := 1 to Len(aCnab)

				cTitulo   := ""
				cXIdCnab  := ""
				cXOcorr   := ""
				cXFilial  := ""
				cXPrefixo := ""
				cXTipo    := ""
				cXParcela := ""
				dXDataBx  := ""
				cXNum     := ""
				cCliFor   := ""

				If nTipo == 1 // Cnab 400
					If SubStr(aCnab[nNext1], 001, 001) $ "1"

						cTitulo := SubStr(aCnab[nNext1], 041, 020) // Numero do Título
						cXOcorr := SubStr(aCnab[nNext1], 393, 002) // Código da ocorrencia

						// Localiza o Registro de Contas a Receber
						cQuery := "SELECT SE1.E1_FILIAL, SE1.E1_PREFIXO, SE1.E1_TIPO, SE1.E1_PARCELA, SE1.E1_BAIXA, SA1.A1_COD + '-' + SA1.A1_NOME CLIFOR FROM " + RetSqlName("SE1") 
						cQuery += " SE1 LEFT JOIN " + RetSqlName("SA1") + " SA1 ON SE1.E1_CLIENTE = SA1.A1_COD AND SE1.E1_LOJA = SA1.A1_LOJA "
						cQuery += " WHERE SE1.E1_NUM = '" + cTitulo  +  "'"

						cQuery := ChangeQuery(cQuery)
						cFile  := GetNextAlias()
						dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cFile,.F.,.T.)

						If (cFile)->(!Eof())
							cXFilial  := (cFile)->E1_FILIAL
							cXPrefixo := (cFile)->E1_PREFIXO
							cXTipo    := (cFile)->E1_TIPO
							cXParcela := (cFile)->E1_PARCELA
							dXDataBx  := (cFile)->E1_BAIXA
							cCliFor   := (cFile)->CLIFOR
						EndIf
						(cFile)->(DbCloseArea())

						// Localiza o Registro de Pagamento do Contas a Receber
						cQuery := "SELECT SE5.E5_NUMERO FROM " + RetSqlName("SE5") + " SE5 WHERE SE5.E5_NUMERO = '" + cTitulo  +  "' AND SE5.E5_FILIAL = '" + cXFilial + "'  AND SE5.E5_TIPO = '" + cXTipo + "'"
						cQuery := ChangeQuery(cQuery)
						cFile  := GetNextAlias()
						dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cFile,.F.,.T.)

						If (cFile)->(!Eof())
							cXProcessado := "S"
						Else
							cXProcessado := "N"
							//cXOcorr      := "  "
						EndIf
						(cFile)->(DbCloseArea())

					EndIf

				Else // Sispag

					If SubStr(aCnab[nNext1], 008, 001) == "3" .And. SubStr(aCnab[nNext1], 014, 001) $ "A.J.N.O" // Detalhe do Arquivo
						Do Case
							Case SubStr(aCnab[nNext1], 014, 001) == "A"; cTitulo := SubStr(aCnab[nNext1], 074, 10)
							Case SubStr(aCnab[nNext1], 014, 001) == "J"; cTitulo := SubStr(aCnab[nNext1], 183, 10)
							Case SubStr(aCnab[nNext1], 014, 001) == "N"; cTitulo := SubStr(aCnab[nNext1], 196, 10)
							Case SubStr(aCnab[nNext1], 014, 001) == "O"; cTitulo := SubStr(aCnab[nNext1], 175, 10)
						EndCase
						cXOcorr := SubStr(aCnab[nNext1], 231, 002) // Código da ocorrencia

						// Localiza o Registro de Contas a Receber
						cQuery := "SELECT SE2.E2_FILIAL, SE2.E2_PREFIXO, SE2.E2_TIPO, SE2.E2_PARCELA, SE2.E2_BAIXA, SE2.E2_NUM, SA2.A2_COD + '-' + SA2.A2_NOME CLIFOR FROM " + RetSqlName("SE2")
						cQuery += " SE2 LEFT JOIN " + RetSqlName("SA2") + " SA2 ON SE2.E2_FORNECE = SA2.A2_COD AND SE2.E2_LOJA = SA2.A2_LOJA "
						cQuery += " WHERE SE2.E2_IDCNAB = '" + cTitulo  +  "'"

						cQuery := ChangeQuery(cQuery)
						cFile  := GetNextAlias()
						dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cFile,.F.,.T.)

						If (cFile)->(!Eof()) .And. !Empty(cTitulo)
							cXFilial  := (cFile)->E2_FILIAL
							cXPrefixo := (cFile)->E2_PREFIXO
							cXTipo    := (cFile)->E2_TIPO
							cXParcela := (cFile)->E2_PARCELA
							dXDataBx  := (cFile)->E2_BAIXA
							cXNum     := (cFile)->E2_NUM
							cCliFor   := (cFile)->CLIFOR
							//cTitulo += "-" + cXNum
							cXIdCnab  := cTitulo
							cTitulo   := cXNum
						EndIf
						(cFile)->(DbCloseArea())

						// Localiza o Registro de Pagamento do Contas a Pagar
						cQuery := "SELECT SE5.E5_NUMERO FROM " + RetSqlName("SE5") +  " SE5 WHERE SE5.E5_NUMERO = '" + cXNum  +  "' AND SE5.E5_FILIAL = '" + cXFilial + "'  AND SE5.E5_TIPO = '" + cXTipo + "' AND SE5.E5_MOTBX NOT IN ('PCC') "
						cQuery := ChangeQuery(cQuery)
						cFile  := GetNextAlias()
						dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cFile,.F.,.T.)

						If (cFile)->(!Eof())
							cXProcessado := "S"
						Else
							cXProcessado := "N"
							//cXOcorr      := "  "
						EndIf
						(cFile)->(DbCloseArea())

					EndIf

				EndIf

				// Localiza o Registro de Ocorrencias Bancárias
				cQuery := "SELECT SEB.EB_DESCRI FROM " + RetSqlName("SEB") + " SEB WHERE SEB.EB_BANCO = '" + cBanco + "' AND SEB.EB_REFBAN = '" + cXOcorr + "' AND SEB.EB_TIPO = 'R'"
				cQuery := ChangeQuery(cQuery)
				cFile  := GetNextAlias()
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cFile,.F.,.T.)

				cXDescr := ""
				If (cFile)->(!Eof())
					cXDescr := (cFile)->EB_DESCRI
				EndIf
				(cFile)->(DbCloseArea())

				cQuery := "SELECT ZZ3.Z3_DATA, ZZ3.Z3_ARQ, ZZ3.Z3_HORA FROM " + RetSqlName("ZZ3") + " ZZ3 WHERE ZZ3.Z3_ARQ = '" + aFileRet[nNext, 1] + "' AND ZZ3.Z3_NUM = '" + cTitulo + "'"
				cQuery := ChangeQuery(cQuery)
				cFile  := GetNextAlias()
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cFile,.F.,.T.)

				cXObs := ""
				If (cFile)->(!Eof())
					cXObs := "O TITULO JÁ FOI PROCESSADO NO DIA " + SubStr((cFile)->Z3_DATA, 07, 02) + "/" + SubStr((cFile)->Z3_DATA, 05, 02) + "/" + SubStr((cFile)->Z3_DATA, 01, 04) + " AS " + (cFile)->Z3_HORA + " ATRAVÉS DO ARQUIVO " + AllTrim((cFile)->Z3_ARQ) + "."
				EndIf
				(cFile)->(DbCloseArea())

				If Empty(cXFilial)
					cXObs := "TITULO NÃO LOCALIZADO NO SISTEMA."
				EndIf

				DBSelectArea("ZZ3")

				If nTipo == 2 .And. Empty(cXIdCnab)
					cXObs := "SISPAG - ID CNAB DO ARQUIVO ESTÁ EM BRANCO."
				EndIf

				If (SubStr(aCnab[nNext1], 008, 001) == "3" .And. SubStr(aCnab[nNext1], 014, 001) $ "A.J.N.O") .Or.;
				SubStr(aCnab[nNext1], 001, 001) $ "1"
					RecLock("ZZ3", .T.)
					ZZ3->Z3_FILIAL  := cXFilial 			// Filial do Titulo
					ZZ3->Z3_ARQ     := aFileRet[nNext,1] 	// Nome do Arquivo Processado
					ZZ3->Z3_DATA	:= date() 				// Data de Processamento do Arquivo
					ZZ3->Z3_HORA	:= Time() 				// Hora de processamento do Arquivo
					ZZ3->Z3_ORIGEM	:= AllTrim(Str(nTipo))	// 1- Contas a Receber / 2 - Contas a Pagar
					ZZ3->Z3_PREFIXO	:= cXPrefixo 			// Numero do Prefixo
					ZZ3->Z3_NUM		:= cTitulo 				// Numero do Título
					ZZ3->Z3_PARCELA	:= cXParcela 			// Numero da Parcela
					ZZ3->Z3_TIPO	:= cXTipo 				// Tipo de Título
					ZZ3->Z3_PROCESS	:= cXProcessado 		// Registro Processado ?
					ZZ3->Z3_CODERR	:= cXOcorr				// Código do Erro
					ZZ3->Z3_DESCERR	:= cXDescr 				// Descrição do Erro
					ZZ3->Z3_DATABX  := Stod(dXDataBx)		// Data da Baixa
					ZZ3->Z3_IDCNAB  := cXIdCnab             // IdCnab
					ZZ3->Z3_OBS     := cXObs				// Observação de Processamento
					ZZ3->Z3_CLIFOR  := cCliFor  		    // Cliente Fornecedor
					ZZ3->(DBUnLock() )
				EndIf

			Next

		Next

	Next
	RestArea(aArea)
Return

/*
* Função.....: BSLBXAT1()
* Objetivo...: Baixa Automática dos Cnabs 400 posições
*/

Static Function BSLBXAT1(nPosArotina)

	Local lPanelFin     := IsPanelFin()
	Local lPergunte     := .F.
	Private cStProc     := ""
	Private lExecJob    := .T.
	Private cPerg	    := "AFI200"
	PRIVATE cLotefin 	:= Space(TamSX3("EE_LOTE")[1]),nTotAbat := 0,cConta := " "
	PRIVATE nHdlBco		:= 0,nHdlConf := 0,nSeq := 0 ,cMotBx := "NOR"
	PRIVATE nValEstrang := 0
	PRIVATE cMarca 		:= GetMark()
	PRIVATE aRotina 	:= xMnDef()
	PRIVATE VALOR  		:= 0
	PRIVATE nHdlPrv 	:= 0
	PRIVATE nOtrGa		:= 0
	PRIVATE nTotAGer	:= 0
	PRIVATE ABATIMENTO 	:= 0
	PRIVATE lOracle		:= "ORACLE"$Upper(TCGetDB())
	PRIVATE lMvCnabImp  := .F.
	PRIVATE cCadastro   := OemToAnsi(STR0006)

	__nExeProc  := 0
	lPergunte   := .T.

	DEFAULT nPosArotina := 0

	If nTamNat == 0
		F200VerNat()
	Endif

	dbSelectArea('SE1')
	bBlock := &( "{ |a,b,c,d,e| " + aRotina[ nPosArotina,2 ] + "(a,b,c,d,e) }" )
	Eval( bBlock, Alias(), (Alias())->(Recno()),nPosArotina,lExecJob) // Retorno Automatico via Job - parametro que controla execucao via Job

	FCLOSE(nHdlBco)
	FCLOSE(nHdlConf)
Return

/*
* Função.......: BSLBXAT2()
* Objetivo.....: Fazer as Baixas do Sispag.
*
*/

User Function BSLBXAT2()

	LOCAL nOpca       := 0
	LOCAL aButtons    := {}
	PRIVATE nCorrecao := 0

	nOpca := 0

	AADD(aButtons, { 1,.T.,{|o| nOpca:= 1,o:oWnd:End()}} )
	AADD(aButtons, { 2,.T.,{|o| o:oWnd:End() }} )
	AADD(aButtons, { 5,.T.,{|| .T. } } )

	lDigita			:= IIF(mv_par01 == 1,.T.,.F.)
	lAglut 		 	:= IIF(mv_par02 == 1,.T.,.F.)
	lContabiliza 	:= Iif(mv_par11 == 1,.T.,.F.)

	Processa({|lEnd| Fa300Processa()})
Return

/*
* Função......: xMnDef()
* Objetivo....: Definição do Menu, utilizado na baixa dos Cnabs..
*
*/

Static Function xMnDef()
	Local aRotina:= { {OemToAnsi(STR0001) ,"fA200Par" , 0 , 1},;  // "Parametros"
	{OemToAnsi(STR0002) ,"AxVisual" , 0 , 2},;  // "Visualizar"
	{OemToAnsi(STR0003) ,"fA200Gera", 0 , 3} }  // "Receber Arquivo"
Return(aRotina)

