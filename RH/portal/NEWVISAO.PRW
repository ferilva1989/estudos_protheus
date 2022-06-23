#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"

#DEFINE  CRLF  Chr(13)+Chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma ณ Previdencia Privada บ Autor ณ Rafael Beluzzo บ Data ณ06/2011บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function NEWVISAO()

	Local aSays:={}, aButtons:= {},aRegs := {} //<== arrays locais de preferencia

	SetPrvt("cCadastro,cPerg,nOpca,nX_,nPos")
	SetPrvt("lContinua,cNomeArq,cLin,lEnd,nAviso,cCab1,cCab2,cCab3,nReg")


	//Iniciar Variaveis
	cCadastro	:= OemToAnsi("Geracao Arquivo Duplica Visao")
	cPerg		:= "VISAO001_"
	nReg    	:= 1
	nIdEnd      := 0
	lContinua	:= .T.
	lEnd		:= .T.
	aInfoE		:= {}
	aSet		:= {}

	fChkPerg()
	Pergunte(cPerg,.F.)

	AADD(aSays,OemToAnsi("Este programa Duplica Visao ") )

	AADD(aButtons, { 5,.T.,{|| Pergunte(cPerg,.T. ) } } )
	AADD(aButtons, { 1,.T.,{|o| nOpca := 1,Iif(GpconfOK(),FechaBatch(),nOpca:=0) }} )
	AADD(aButtons, { 2,.T.,{|o| FechaBatch() }} )

	FormBatch( cCadastro, aSays, aButtons )

	If nOpca == 1
		Processa({|lEnd| fVBProc(),"Gerando Visใo"})
	Endif

	//Fechamento das Tabelas Temporarias
	If Select("R0NW") > 0
		DbSelectArea("R0NW")
		DbCloseArea("R0NW")
	EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบDescrio ณ Processamento                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function fVBProc()

	//Variaveis das Perguntas
	Pergunte(cPerg,.F.)

	//Carrega as Variaveis das Perguntas
	cVisao		:= mv_par01	//Avalicao
	cNovaVisao	:= mv_par01	//Qual nova Avaliacao

	IF val(cNovaVisao) > 0

		//Monta Query de Filtro
		cQuery := ""
		cQuery += "Select *
		cQuery += " FROM " + RETSQLNAME("RD4") //RDK
		cQuery += " Where RD4_CODIGO like '" + cVisao + "'"
		cQuery += " ORDER BY RD4_FILIAL, RD4_CODIGO, RD4_ITEM"

		cQuery := ChangeQuery(cQuery)

		//Verifica se Tabela Aberta
		If Select("R0NW") > 0
			DbSelectArea("R0NW")
			DbCloseArea("R0NW")
		EndIf

		//Abre Tabela
		dbUseArea( .T., 'TOPCONN', TcGenQry( ,, cQuery ), 'R0NW', .T., .F. )

		R0NW->(DbGotop())

		While R0NW->(!Eof())



			RDB->(Reclock("RDB",.T.))

			RDB->RDB_FILIAL 		:= R0NW->RDB_FILIAL
			RDB->RDB_CODAVA 		:= R0NW->RDB_CODAVA
			RDB->RDB_CODADO 		:= R0NW->RDB_CODADO
			RDB->RDB_CODDOR 		:= cSuperior
			RDB->RDB_CODCOM 		:= R0NW->RDB_CODCOM
			RDB->RDB_ITECOM  		:= R0NW->RDB_ITECOM
			RDB->RDB_CODNET 		:= cNetSuper
			RDB->RDB_TIPOAV	   		:= '1'
			RDB->RDB_CODQUE 		:= R0NW->RDB_CODQUE
			RDB->RDB_CODALT 		:= R0NW->RDB_CODALT
			RDB->RDB_RESOBT	  		:= R0NW->RDB_RESOBT
			RDB->RDB_DTIAVA 		:= STOD(R0NW->RDB_DTIAVA)
			RDB->RDB_DTFAVA	  		:= STOD(R0NW->RDB_DTFAVA)
			RDB->RDB_CODMOD 		:= R0NW->RDB_CODMOD
			RDB->RDB_CODTIP	  		:= R0NW->RDB_CODTIP
			RDB->RDB_ESCALA 		:= R0NW->RDB_ESCALA
			RDB->RDB_ID 			:= _IDApro
			RDB->RDB_CODPRO 		:= R0NW->RDB_CODPRO
			RDB->RDB_ITEESC 		:= R0NW->RDB_ITEESC
			//RDB->RDB_CODMEM	   		:= R0NW->RDB_CODMEM

			RDB->( msUnlock() )


			R0NW->(DbSkip())

			IncProc('Gerando o Arquivo... ')

		EndDo

	Else

		alert("Novo n๚mero da avalia็ใo precisa ser Informado!")

	EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ fChkPerg บ Autor ณJose Carlos Gouveia บ Data ณ  25/10/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Cria Perguntas                                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function fChkPerg()

	Local aRegs	:= {}

	aAdd(aRegs,{cPerg,'01','Visao                   ?','','','mv_ch1','C',06,0,0,'G','           ','mv_par01','               ','','','','','             ','','','','','             ','','','','','              ','','','','','               ','','','','RDK','','',''})
	aAdd(aRegs,{cPerg,'04','Numero da Nova Visao    ?','','','mv_ch2','C',06,0,0,'G','           ','mv_par02','               ','','','','','             ','','','','','             ','','','','','              ','','','','','               ','','','','   ','','',''})


	ValidPerg(aRegs,cPerg)

Return
