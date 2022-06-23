#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"

#DEFINE  CRLF  Chr(13)+Chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma ณ ESTRUTURA QUE JA EXISTE บ Autor ณ Rafael Beluzzo บ Data ณ06/16บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function XVISAO()

	Local aSays:={}, aButtons:= {},aRegs := {} //<== arrays locais de preferencia

	SetPrvt("cCadastro,cPerg,nOpca,nX_,nPos")
	SetPrvt("lContinua,cNomeArq,cLin,lEnd,nAviso,cCab1,cCab2,cCab3,nReg")

	//Iniciar Variaveis
	cCadastro	:= OemToAnsi("Geracao Estrutura da Visao")
	cPerg		:= "VISAO001_"
	nReg    	:= 1
	nIdEnd      := 0
	lContinua	:= .T.
	lEnd		:= .T.
	aInfoE		:= {}
	aSet		:= {}

	fChkPerg()
	Pergunte(cPerg,.F.)

	AADD(aSays,OemToAnsi("Este programa Cria a Estrutura da Visao a partir do Departamento ") )

	AADD(aButtons, { 5,.T.,{|| Pergunte(cPerg,.T. ) } } )
	AADD(aButtons, { 1,.T.,{|o| nOpca := 1,Iif(GpconfOK(),FechaBatch(),nOpca:=0) }} )
	AADD(aButtons, { 2,.T.,{|o| FechaBatch() }} )

	FormBatch( cCadastro, aSays, aButtons )

	If nOpca == 1
		Processa({|lEnd| fVBProc(),"Gerando Visใo"})
	Endif


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
	cChave 		:= ''
	cTree 		:= ''

	//Fechamento das Tabelas Temporarias
	If Select("R0NW") > 0
		DbSelectArea("R0NW")
		DbCloseArea("R0NW")
	EndIf

	//Monta Query de Filtro
	cQuery := ""
	cQuery += "Select *  "
	cQuery += " FROM " + RETSQLNAME("RD4")
	cQuery += " where D_E_L_E_T_ = '' "
	cQuery += " and RD4_CODIGO like '" + cVisao + "'"

	cQuery := ChangeQuery(cQuery)

	dbUseArea( .T., 'TOPCONN', TcGenQry( ,, cQuery ), 'R0NW', .T., .F. )
	R0NW->(DbGotop())

	While R0NW->(!Eof())

		DbSelectArea("SQB")
		DbSetOrder(1)
		DbGoTop()
		DbSeek("        "+R0NW->RD4_CODIDE)

		DbSelectArea("RD4")
		DbSetOrder(5)
		DbGoTop()
		DbSeek("        "+R0NW->RD4_CODIGO+SQB->QB_DEPSUP)
		If alltrim(RD4->RD4_ITEM) = ""
			cTree 	:= "000000"
		else
			cTree 	:= RD4->RD4_ITEM
		EndIf
		cChave 	:= alltrim(alltrim(RD4->RD4_CHAVE) + "001")

		cExit := .F.
		nCont := 1
		while cExit = .F. 

			//select para saber se exista na tabela RD4 a chave
			cQuery := ""
			cQuery += "Select count(*) as Totvs  "
			cQuery += " FROM " + RETSQLNAME("RD4")
			cQuery += " where D_E_L_E_T_ = '' "
			cQuery += " and RD4_CHAVE like '" + cChave + "'"
			cQuery += " and RD4_CODIGO like '" + R0NW->RD4_CODIGO + "'"

			cQuery := ChangeQuery(cQuery)

			dbUseArea( .T., 'TOPCONN', TcGenQry( ,, cQuery ), 'xR0NW', .T., .F. )  

			xR0NW->(DbGotop())

			If xR0NW->Totvs > 0
				nCont := nCont + 1
				cChave := alltrim(alltrim(RD4->RD4_CHAVE) + STRZERO(nCont,3)) 
			Else
				cExit := .T.
			EndIf

			DbCloseArea("xR0NW") 

		EndDo

		DbSelectArea("RD4")
		DbSetOrder(1)
		DbGoTop()
		DbSeek("        "+R0NW->RD4_CODIGO+R0NW->RD4_ITEM) 

		RD4->(Reclock("RD4",.F.)) 
		RD4->RD4_TREE 	:= cTree
		RD4->RD4_CHAVE 	:= cChave
		RD4->( msUnlock() )

		R0NW->(DbSkip())

		IncProc('Gerando o Arquivo... ')

	EndDo

	DbCloseArea("R0NW")

	Alert("Finalizado a duplica็ใo da Visใo!")

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ fChkPerg บ Autor ณRJB 				   บ Data ณ  06/2016  บฑฑ
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

	ValidPerg(aRegs,cPerg)

Return
