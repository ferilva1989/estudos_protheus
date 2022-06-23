#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"

#DEFINE  CRLF  Chr(13)+Chr(10)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa � Previdencia Privada � Autor � Rafael Beluzzo � Data �06/2011���
�������������������������������������������������������������������������͹��
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function Montagem()

	Local aSays:={}, aButtons:= {},aRegs := {} //<== arrays locais de preferencia

	SetPrvt("cCadastro,cPerg,nOpca,cNome,cSexo,cData_Aniv,cEmail,cArquivo,cEmissao,cDDD,cTelefone")
	SetPrvt("lContinua,cNomeArq,cLin,lEnd,nAviso,cCab1,cCab2,cCab3,nReg,nQtdEmp,nQtdEnd,nQtdFun,nQtdBnf,nQtdVtr")
	SetPrvt("nX_,nPos,cMatDe,cMatAte,cTurDe,cTurAte,cSit,cCat")

	//Iniciar Variaveis
	cCadastro	:= OemToAnsi("")
	cPerg		:= "AMON002_"
	cNomeArq	:= ''
	cLin		:= ''
	cCab1 		:= ''
	cCab2 		:= ''
	cCab3 		:= ''
	nReg    	:= 1
	nIdEnd      := 0
	nQtdEmp 	:= 0
	nQtdEnd 	:= 0
	nQtdFun 	:= 0
	nQtdBnf 	:= 0
	nQtdVtr 	:= 0
	nOpca	    := 0
	nHdl		:= 0
	nAviso		:= 0
	nX_			:= 0
	nPos		:= 0
	lContinua	:= .T.
	lEnd		:= .T.
	aInfoE		:= {}
	aSet		:= {}
	Private cFunc 		:= ''
	Private cAvaliador 	:= ''
	//Private cId_ 		:= ''
	Private cDiv		:= ''
	Private cAvaliacao	:= ''
	Private cCCFunc 	:= ''
	Private cCCAval 	:= ''
	Private cCCApro 	:= ''

	fChkPerg()
	Pergunte(cPerg,.F.)

	AADD(aSays,OemToAnsi("Este programa gera Montagem ") )

	AADD(aButtons, { 5,.T.,{|| Pergunte(cPerg,.T. ) } } )
	AADD(aButtons, { 1,.T.,{|o| nOpca := 1,Iif(GpconfOK(),FechaBatch(),nOpca:=0) }} )
	AADD(aButtons, { 2,.T.,{|o| FechaBatch() }} )

	FormBatch( cCadastro, aSays, aButtons )

	If nOpca == 1
		Processa({|lEnd| fVBProc(),"Gerando Arquivo"})
	Endif

	If nHdl > 0
		If fClose(nHdl)
			If lContinua
				Aviso('AVISO','Gerado o arquivo ' + AllTrim(cNomeArq) + '...',{'OK'})
			Else
				If fErase(cNomeArq) == 0
					If lContinua
						Aviso('AVISO','Nao existem registros a serem gravados. A geracao do arquivo ' + AllTrim(cNomeArq) + ' foi abortada ...',{'OK'})
					EndIf
				Else

					MsgAlert('Ocorreram problemas na tentativa de delecao do arquivo '+AllTrim(cNomeArq)+'.')

				EndIf
			EndIf
		Else

			MsgAlert('Ocorreram problemas no fechamento do arquivo '+AllTrim(cNomeArq)+'.')

		EndIf

	EndIf

	//Fechamento das Tabelas Temporarias
	If Select("R0NW") > 0
		DbSelectArea("R0NW")
		DbCloseArea("R0NW")
	EndIf

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Descri��o � Processamento                                              ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
����������������������������������������������������������������������������� */
Static Function fVBProc()

	//Variaveis das Perguntas
	Pergunte(cPerg,.F.)

	//Carrega as Variaveis das Perguntas
	cVisao		:= mv_par01	//Avalicao
	cNomeArq	:= mv_par02	//Nome do Arquivo
	cDivOcu		:= mv_par03	//Qual Divis�o Ocupacional
	cAvaliacao	:= mv_par04	//Qual Divis�o Ocupacional

	//Cria o arquivo texto
	While .T.
		If File(cNomeArq)
			If (nAviso := Aviso('AVISO','Deseja substituir o ' + AllTrim(cNomeArq) + ' existente ?', {'Sim','Nao','Cancela'})) == 1
				If fErase(cNomeArq) == 0
					Exit
				Else
					MsgAlert('Ocorreram problemas na tentativa de dele��o do arquivo '+AllTrim(cNomeArq)+'.')
				EndIf
			ElseIf nAviso == 2
				Pergunte(cPerg,.T.)
				Loop
			Else
				Return
			EndIf
		Else
			Exit
		EndIf
	EndDo

	nHdl := fCreate(cNomeArq)

	If nHdl == -1
		MsgAlert('O arquivo '+AllTrim(cNomeArq)+' nao pode ser criado! Verifique os parametros.','Atencao!')
		Return
	Endif


	//Monta Query de Filtro
	cQuery := ""

	cQuery += "Select RD0_CODIGO, RD0_CC
	cQuery += " FROM " + RETSQLNAME("RD0")

	cQuery += " Where RD0_MSBLQL = 2 and D_E_L_E_T_ <> '*' "
	//cQuery += " and RD0_CC <> '' "
	cQuery += " and RD0_DIVOCU like '" + cDivOcu + "'"
	cQuery += " and RD0_TIPO = '1'"
	cQuery += " and RD0_CODIGO in (select RDE_CODPAR "
	cQuery += " FROM " + RETSQLNAME("RDE")
	cQuery += " where RDE_CODVIS = '" + cVisao +"' "
	cQuery += " and RDE_STATUS = '1' "
	cQuery += " and D_E_L_E_T_ <> '*')"
	cQuery += " and D_E_L_E_T_ <> '*' "

	cQuery += " ORDER BY 2"

	cQuery := ChangeQuery(cQuery)

	//Verifica se Tabela Aberta
	If Select("R0NW") > 0
		DbSelectArea("R0NW")
		DbCloseArea("R0NW")
	EndIf

	//Abre Tabela
	dbUseArea( .T., 'TOPCONN', TcGenQry( ,, cQuery ), 'R0NW', .T., .F. )

	R0NW->(DbGotop())


	//Informa��es da Empresa

	fGera1()

	//fGera9()

	While R0NW->(!Eof())

		cFunc := R0NW->RD0_CODIGO
		//alert(cFunc)

		cQuery := ""
		cQuery := " Select RD4_CHAVE from " + RetSqlName("RD4")
		cQuery += " where "
		cQuery += " RD4_ITEM in (Select RDE_ITEVIS from " + RetSqlName("RDE")
		cQuery += " where RDE_CODPAR = '" + cFunc +"'"
		cQuery += " AND RDE_STATUS = 1 "
		cQuery += " AND RDE_CODVIS = '" + cVisao +"' "
		cQuery += " AND D_E_L_E_T_ <> '*') "
		cQuery += " AND D_E_L_E_T_ <> '*' "
		cQuery += " AND RD4_CODIGO = '" + cVisao +"' "

		cQuery := ChangeQuery(cQuery)

		If Select("AR0N") > 0
			DbSelectArea("AR0N")
			DbCloseArea("AR0N")
		EndIf

		dbUseArea( .T., 'TOPCONN', TcGenQry( ,, cQuery ), 'AR0N', .T., .F. )

		AR0N->(DbGotop())

		cChave := AR0N->RD4_CHAVE
		//alert(cChave)

		DbCloseArea("AR0N")

		cTamanho := Len(Alltrim(cChave))
		//	cTamanho := cTamanho - 3

		cQuery := ""
		cQuery := " select RDE_CODPAR "
		cQuery += " from " + RetSqlName("RDE") + " , " + RetSqlName("RD4")
		cQuery += " where RDE010.D_E_L_E_T_ <> '*' "
		cQuery += " and RD4010.D_E_L_E_T_ <> '*' "
		cQuery += " and RDE_STATUS = 1 "
		cQuery += " and RDE_CODVIS = RD4_CODIGO "
		cQuery += " and RD4_ITEM = RDE_ITEVIS "
		cQuery += " and RD4_DESC like '%SUP%' "
		cQuery += " and RD4_CHAVE = '" + Substr(cChave,1,cTamanho) + "' "
		cQuery += " and RDE_CODVIS = '" + cVisao +"'"
		cQuery += " and RD4_CODIGO = '" + cVisao +"'"

		cQuery := ChangeQuery(cQuery)

		If Select("AR0N") > 0
			DbSelectArea("AR0N")
			DbCloseArea("AR0N")
		EndIf

		dbUseArea( .T., 'TOPCONN', TcGenQry( ,, cQuery ), 'AR0N', .T., .F. )

		AR0N->(DbGotop())

		cAvaliador := AR0N->RDE_CODPAR

		DbCloseArea("AR0N")


		cTamanho := Len(Alltrim(cChave))
		cTamanho := cTamanho - 3
		//cTamanho := cTamanho - 6

		cQuery := ""
		cQuery := " select RDE_CODPAR "
		cQuery += " from " + RetSqlName("RDE") + " , " + RetSqlName("RD4")
		cQuery += " where RDE010.D_E_L_E_T_ <> '*' "
		cQuery += " and RD4010.D_E_L_E_T_ <> '*' "
		cQuery += " and RDE_STATUS = 1 "
		cQuery += " and RDE_CODVIS = RD4_CODIGO "
		cQuery += " and RD4_ITEM = RDE_ITEVIS "
		cQuery += " and RD4_DESC like '%SUP%' "
		cQuery += " and RD4_CHAVE = '" + Substr(cChave,1,cTamanho) + "' "
		cQuery += " and RDE_CODVIS = '" + cVisao +"'"
		cQuery += " and RD4_CODIGO = '" + cVisao +"'"

		cQuery := ChangeQuery(cQuery)

		If Select("AR0N") > 0
			DbSelectArea("AR0N")
			DbCloseArea("AR0N")
		EndIf

		dbUseArea( .T., 'TOPCONN', TcGenQry( ,, cQuery ), 'AR0N', .T., .F. )

		AR0N->(DbGotop())

		cAprovador := AR0N->RDE_CODPAR

		DbCloseArea("AR0N")


		If cAvaliador = cFunc .or. val(cAvaliador) = 0

			cAvaliador :=  cAprovador

			cTamanho := Len(Alltrim(cChave))
			cTamanho := cTamanho - 6

			cQuery := ""
			cQuery := " select RDE_CODPAR "
			cQuery += " from " + RetSqlName("RDE") + " , " + RetSqlName("RD4")
			cQuery += " where RDE010.D_E_L_E_T_ <> '*' "
			cQuery += " and RD4010.D_E_L_E_T_ <> '*' "
			cQuery += " and RDE_STATUS = 1 "
			cQuery += " and RDE_CODVIS = RD4_CODIGO "
			cQuery += " and RD4_ITEM = RDE_ITEVIS "
			cQuery += " and RD4_DESC like '%SUP%' "
			cQuery += " and RD4_CHAVE = '" + Substr(cChave,1,cTamanho) + "' "
			cQuery += " and RDE_CODVIS = '" + cVisao +"'"
			cQuery += " and RD4_CODIGO = '" + cVisao +"'"

			cQuery := ChangeQuery(cQuery)

			If Select("AR0N") > 0
				DbSelectArea("AR0N")
				DbCloseArea("AR0N")
			EndIf

			dbUseArea( .T., 'TOPCONN', TcGenQry( ,, cQuery ), 'AR0N', .T., .F. )

			AR0N->(DbGotop())

			cAprovador := AR0N->RDE_CODPAR

			DbCloseArea("AR0N")

		EndIf


		If val(cAprovador) > 0 .and.  val(cAvaliador) = 0

			cAvaliador :=  cAprovador

			cTamanho := Len(Alltrim(cChave))
			cTamanho := cTamanho - 6

			cQuery := ""
			cQuery := " select RDE_CODPAR "
			cQuery += " from " + RetSqlName("RDE") + " , " + RetSqlName("RD4")
			cQuery += " where RDE010.D_E_L_E_T_ <> '*' "
			cQuery += " and RD4010.D_E_L_E_T_ <> '*' "
			cQuery += " and RDE_STATUS = 1 "
			cQuery += " and RDE_CODVIS = RD4_CODIGO "
			cQuery += " and RD4_ITEM = RDE_ITEVIS "
			cQuery += " and RD4_DESC like '%SUP%' "
			cQuery += " and RD4_CHAVE = '" + Substr(cChave,1,cTamanho) + "' "
			cQuery += " and RDE_CODVIS = '" + cVisao +"'"
			cQuery += " and RD4_CODIGO = '" + cVisao +"'"

			cQuery := ChangeQuery(cQuery)

			If Select("AR0N") > 0
				DbSelectArea("AR0N")
				DbCloseArea("AR0N")
			EndIf

			dbUseArea( .T., 'TOPCONN', TcGenQry( ,, cQuery ), 'AR0N', .T., .F. )

			AR0N->(DbGotop())

			cAprovador := AR0N->RDE_CODPAR

			DbCloseArea("AR0N")

		EndIf

		If cAvaliador = cAprovador

			cAprovador := ''

		Endif

		If val(cAprovador) = 0

			cTamanho := Len(Alltrim(cChave))
			cTamanho := cTamanho - 9

			cQuery := ""
			cQuery := " select RDE_CODPAR "
			cQuery += " from " + RetSqlName("RDE") + " , " + RetSqlName("RD4")
			cQuery += " where RDE010.D_E_L_E_T_ <> '*' "
			cQuery += " and RD4010.D_E_L_E_T_ <> '*' "
			cQuery += " and RDE_STATUS = 1 "
			cQuery += " and RDE_CODVIS = RD4_CODIGO "
			cQuery += " and RD4_ITEM = RDE_ITEVIS "
			cQuery += " and RD4_DESC like '%SUP%' "
			cQuery += " and RD4_CHAVE = '" + Substr(cChave,1,cTamanho) + "' "
			cQuery += " and RDE_CODVIS = '" + cVisao +"'"
			cQuery += " and RD4_CODIGO = '" + cVisao +"'"

			cQuery := ChangeQuery(cQuery)

			If Select("AR0N") > 0
				DbSelectArea("AR0N")
				DbCloseArea("AR0N")
			EndIf

			dbUseArea( .T., 'TOPCONN', TcGenQry( ,, cQuery ), 'AR0N', .T., .F. )

			AR0N->(DbGotop())

			cAprovador := AR0N->RDE_CODPAR

			DbCloseArea("AR0N")

		EndIf 

		/*
		cQuery := ""
		cQuery := " select RD0_MATR, RD0_DIVOCU "
		cQuery += " from " + RetSqlName("RD0")
		cQuery += " where D_E_L_E_T_ <> '*' "
		cQuery += " and RD0_CODIGO = '" + cFunc  + "' "

		cQuery := ChangeQuery(cQuery)

		If Select("AR0N") > 0
		DbSelectArea("AR0N")
		DbCloseArea("AR0N")
		EndIf

		dbUseArea( .T., 'TOPCONN', TcGenQry( ,, cQuery ), 'AR0N', .T., .F. )

		AR0N->(DbGotop())

		cFunc  := AR0N->RD0_MATR
		cDiv := AR0N->RD0_DIVOCU

		DbCloseArea("AR0N")


		cQuery := ""
		cQuery := " select RD0_MATR "
		cQuery += " from " + RetSqlName("RD0")
		cQuery += " where D_E_L_E_T_ <> '*' "
		cQuery += " and RD0_CODIGO = '" + cAvaliador + "' "

		cQuery := ChangeQuery(cQuery)

		If Select("AR0N") > 0
		DbSelectArea("AR0N")
		DbCloseArea("AR0N")
		EndIf

		dbUseArea( .T., 'TOPCONN', TcGenQry( ,, cQuery ), 'AR0N', .T., .F. )

		AR0N->(DbGotop())

		cAvaliador := AR0N->RD0_MATR

		DbCloseArea("AR0N")


		cQuery := ""
		cQuery := " select RD0_MATR "
		cQuery += " from " + RetSqlName("RD0")
		cQuery += " where D_E_L_E_T_ <> '*' "
		cQuery += " and RD0_CODIGO = '" + cAprovador + "' "

		cQuery := ChangeQuery(cQuery)

		If Select("AR0N") > 0
		DbSelectArea("AR0N")
		DbCloseArea("AR0N")
		EndIf

		dbUseArea( .T., 'TOPCONN', TcGenQry( ,, cQuery ), 'AR0N', .T., .F. )

		AR0N->(DbGotop())

		cAprovador := AR0N->RD0_MATR

		DbCloseArea("AR0N")


		cQuery := ""
		cQuery := "	select RD4_DESC from " + RetSqlName("RD4")
		cQuery += " where "
		cQuery += " RD4_CODIGO = '" + cVisao +"'"
		cQuery += " and D_E_L_E_T_ = '' "
		cQuery += " and RD4_ITEM in (select RDE_ITEVIS from " + RetSqlName("RDE")
		cQuery += " where RDE_CODPAR = '" + cFunc + "' " //cFun,cAvaliador,cAprovador
		cQuery += " and RDE_CODVIS = '" + cVisao +"'"
		cQuery += " and D_E_L_E_T_ = '') "

		cQuery := ChangeQuery(cQuery)

		If Select("AR0N") > 0
		DbSelectArea("AR0N")
		DbCloseArea("AR0N")
		EndIf

		dbUseArea( .T., 'TOPCONN', TcGenQry( ,, cQuery ), 'AR0N', .T., .F. )

		AR0N->(DbGotop())

		cCCFunc := Substr(AR0N->RD4_DESC,1,4)

		DbCloseArea("AR0N")


		cQuery := ""
		cQuery := "	select RD4_DESC from " + RetSqlName("RD4")
		cQuery += " where "
		cQuery += " RD4_CODIGO = '" + cVisao +"'"
		cQuery += " and D_E_L_E_T_ = '' "
		cQuery += " and RD4_ITEM in (select RDE_ITEVIS from " + RetSqlName("RDE")
		cQuery += " where RDE_CODPAR = '" + cFunc + "' " //cFun,cAvaliador,cAprovador
		cQuery += " and RDE_CODVIS = '" + cAvaliador +"'"
		cQuery += " and D_E_L_E_T_ = '') "

		cQuery := ChangeQuery(cQuery)

		If Select("AR0N") > 0
		DbSelectArea("AR0N")
		DbCloseArea("AR0N")
		EndIf

		dbUseArea( .T., 'TOPCONN', TcGenQry( ,, cQuery ), 'AR0N', .T., .F. )

		AR0N->(DbGotop())

		cCCAval := Substr(AR0N->RD4_DESC,1,4)

		DbCloseArea("AR0N")


		cQuery := ""
		cQuery := "	select RD4_DESC from " + RetSqlName("RD4")
		cQuery += " where "
		cQuery += " RD4_CODIGO = '" + cVisao +"'"
		cQuery += " and D_E_L_E_T_ = '' "
		cQuery += " and RD4_ITEM in (select RDE_ITEVIS from " + RetSqlName("RDE")
		cQuery += " where RDE_CODPAR = '" + cFunc + "' " //cFun,cAvaliador,cAprovador
		cQuery += " and RDE_CODVIS = '" + cAprovador +"'"
		cQuery += " and D_E_L_E_T_ = '') "

		cQuery := ChangeQuery(cQuery)

		If Select("AR0N") > 0
		DbSelectArea("AR0N")
		DbCloseArea("AR0N")
		EndIf

		dbUseArea( .T., 'TOPCONN', TcGenQry( ,, cQuery ), 'AR0N', .T., .F. )

		AR0N->(DbGotop())

		cCCApro := Substr(AR0N->RD4_DESC,1,4)

		DbCloseArea("AR0N")

		fGeraR()
		*/

		////// Auto Avalia��o
		fGeraAuto()

		If val(cAvaliador) > 0
			fGeraAval()
		EndIf

		If val(cAprovador) > 0 .and. cAvaliador <> cAprovador
			fGeraApro()
		EndIf


		R0NW->(DbSkip())

		IncProc('Gerando o Arquivo... ')

	EndDo

Return

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
����������������������������������������������������������������������������� */
Static Function fGeraAuto()

	nIdEnd  += 1
	nX_		+= 1

	cLin	:= ""
	cLin	+= " ;"
	cLin	+= cAvaliacao + ";" //avalia��o
	cLin	+= cFunc + " ;" //avaliado
	cLin	+= cFunc + " ;" //avaliador
	cLin	+= "000003;" //rede
	cLin	+= "1;" //nivel
	cLin	+= ";" //codpro
	cLin	+= " ; ;" //dt inicio e dt fim
	cLin	+= "2;" //Tp.Avaliador
	cLin	+= "000003;" //Cod.Tip.Ava.
	cLin 	+= CRLF 										//Fim da Linha

	//Grava Registro
	fGravaReg(cLin)

	//Atualiza Sequencia
	nReg    += 1

Return

//Fim da Rotina


/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
����������������������������������������������������������������������������� */
Static Function fGeraAval()

	nIdEnd  += 1
	nX_		+= 1

	/*cLin	:= ""
	cLin	+= " ;"
	cLin	+= "XXXXX;" //avalia��o
	cLin	+= cFunc + " ;" //avaliado
	cLin	+= cAvaliador + " ;" //avaliador
	cLin	+= "000002;" //rede
	cLin	+= "1;" //nivel
	cLin	+= " ; ;" //dt envio e data do retorno
	cLin	+= "1;" //ativo
	cLin	+= " ;" //Cod.Proj.Ava
	cLin	+= "1;" //Tp.Avaliador
	cLin	+= " ;" //Inic.Avaliac
	cLin	+= " ;" //Final Avalia
	cLin	+= "000003;" //Cod.Tip.Ava.
	cLin	+= " ;" //Data Lim Rsp
	cLin	+= "1;" //Enviado
	cLin	+= "1;" //Tipo Transac
	cLin	+= " ;" //Identific.
	cLin	+= "0;" //Qtd.Cobran.
	cLin	+= " ;" //Email Env.
	cLin	+= " ;" //Cod.Usr.Siga
	cLin	+= " ;" //Nome Usr.Sig
	cLin	+= STR(cId_) + ";" //Id
	cLin	+= ".F.;" //Item Enviado
	*/
	cLin	:= ""
	cLin	+= " ;"
	cLin	+= cAvaliacao + ";" //avalia��o
	cLin	+= cFunc + " ;" //avaliado
	cLin	+= cAvaliador + " ;" //avaliador
	cLin	+= "000002;" //rede
	cLin	+= "2;" //nivel
	cLin	+= ";" //codpro
	cLin	+= " ; ;" //dt inicio e dt fim
	cLin	+= "1;" //Tp.Avaliador
	cLin	+= "000003;" //Cod.Tip.Ava.
	cLin 	+= CRLF 										//Fim da Linha

	//Grava Registro
	fGravaReg(cLin)

	//Atualiza Sequencia
	nReg    += 1
	nIdEnd  += 1
	nX_		+= 1
	//cId 	:= Val(cId) + 1

	cLin	:= ""
	cLin	+= " ;"
	cLin	+= cAvaliacao + ";" //avalia��o
	cLin	+= cFunc + " ;" //avaliado
	cLin	+= cAvaliador + " ;" //avaliador
	cLin	+= "000002;" //rede
	cLin	+= "2;" //nivel
	cLin	+= ";" //codpro
	cLin	+= " ; ;" //dt inicio e dt fim
	cLin	+= "3;" //Tp.Avaliador
	cLin	+= "000003;" //Cod.Tip.Ava.
	cLin 	+= CRLF 										//Fim da Linha

	//Grava Registro
	fGravaReg(cLin)

	//Atualiza Sequencia
	nReg    += 1

Return

//Fim da Rotina

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
����������������������������������������������������������������������������� */
Static Function fGeraApro()

	nIdEnd  += 1
	nX_		+= 1

	cLin	:= ""
	cLin	+= " ;"
	cLin	+= cAvaliacao + ";" //avalia��o
	cLin	+= cFunc + " ;" //avaliado
	cLin	+= cAprovador + " ;" //avaliador
	cLin	+= "000001;" //rede
	cLin	+= "2;" //nivel
	cLin	+= ";" //codpro
	cLin	+= " ; ;" //dt inicio e dt fim
	cLin	+= "1;" //Tp.Avaliador
	cLin	+= "000003;" //Cod.Tip.Ava.
	cLin 	+= CRLF 										//Fim da Linha

	//Grava Registro
	fGravaReg(cLin)

	//Atualiza Sequencia
	nReg    += 1
	nIdEnd  += 1
	nX_		+= 1
	//cId 	:= Val(cId) + 1

	cLin	:= ""
	cLin	+= " ;"
	cLin	+= cAvaliacao + ";" //avalia��o
	cLin	+= cFunc + " ;" //avaliado
	cLin	+= cAprovador + " ;" //avaliador
	cLin	+= "000001;" //rede
	cLin	+= "2;" //nivel
	cLin	+= ";" //codpro
	cLin	+= " ; ;" //dt inicio e dt fim
	cLin	+= "3;" //Tp.Avaliador
	cLin	+= "000003;" //Cod.Tip.Ava.
	cLin 	+= CRLF 										//Fim da Linha

	//Grava Registro
	fGravaReg(cLin)

	//Atualiza Sequencia
	nReg    += 1

Return

//Fim da Rotina



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
����������������������������������������������������������������������������� */
Static Function fGera1()

	nIdEnd  += 1
	nX_		+= 1

	cLin	:= ""
	//cLin	+= "Filial;Avaliacao;Avaliado;Avaliador;Rede;Nivel Rede;Data envio;Data Retorno;"
	//cLin	+= "Ativo;Cod.Proj.Ava;Tp.Avaliador;Inic.Avaliac;Final Avalia;Cod.Tip.Ava.;Data Lim Rsp;Enviado;"
	//cLin	+= "Tipo Transac;Identific.;Qtd.Cobran.;Email Env.;Cod.Usr.Siga;Nome Usr.Sig;Id;Item Enviado;"

	cLin	+= "Filial;Avaliacao;Avaliado;Avaliador;Rede;Nivel Rede;Cod Prod;Data Abertura;Data Fim;"
	cLin	+= "Tp.Avaliador;Cod.Tip.Ava.;"

	cLin 	+= CRLF 										//Fim da Linha

	//Grava Registro
	fGravaReg(cLin)

	//Atualiza Sequencia
	nReg    += 1

Return

//Fim da Rotina

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � fGravaReg    � Autor �Jose Carlos Gouveia� Data � 06.11.00 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Grava Registros no Arquivo Texto                           ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � fGravaReg()                                                ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �                                                            ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function fGravaReg(cLin)

	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		If !MsgYesNo('Ocorreu um erro na grava��o do arquivo '+AllTrim(cNomeArq)+'.   Continua?','Atencao!')
			lContinua := .F.
			Return
		Endif
	Endif

Return

//Fim da Rotina

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 � FGETPATH � Autor � Kleber Dias Gomes     � Data � 26/06/00 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Permite que o usuario decida onde sera criado o arquivo    ���
�������������������������������������������������������������������������Ĵ��
���Uso       �             												  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function fGetPath()

	Local cRet	:= Alltrim(ReadVar())
	Local cPath	:= cNomeArq

	oWnd := GetWndDefault()

	While .T.
		If Empty(cPath)
			cPath := cGetFile( "Arquivos Texto de Importacao | *.TXT ",OemToAnsi("Selecione Arquivo"))
		EndIf

		If Empty(cPath)
			Return .F.
		EndIf
		&cRet := cPath
		Exit
	EndDo

	If oWnd != Nil
		GetdRefresh()
	EndIf

Return .T.
//Fim da Rotina

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
����������������������������������������������������������������������������� */
Static Function fGeraR()

	nIdEnd  += 1
	nX_		+= 1

	cLin	:= ""
	cLin	:= cDiv + ";" //avalia��o
	cLin	+= cFunc + " ;" //avaliado
	cLin	+= cAvaliador + " ;" //avaliador
	cLin	+= cAprovador + " ;" //avaliador
	cLin	+= cCCFunc + " ;" //Centro de Custo avaliado
	cLin	+= cCCAval + " ;" //Centro de Custo avaliador
	cLin	+= cCCApro + " ;" //Centro de Custo avaliador

	cLin 	+= CRLF 										//Fim da Linha

	//Grava Registro
	fGravaReg(cLin)

	//Atualiza Sequencia
	nReg    += 1

Return

//Fim da Rotina


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
����������������������������������������������������������������������������� */
Static Function fGera9()

	nIdEnd  += 1
	nX_		+= 1

	cLin	:= ""
	//cLin	+= "Filial;Avaliacao;Avaliado;Avaliador;Rede;Nivel Rede;Data envio;Data Retorno;"
	//cLin	+= "Ativo;Cod.Proj.Ava;Tp.Avaliador;Inic.Avaliac;Final Avalia;Cod.Tip.Ava.;Data Lim Rsp;Enviado;"
	//cLin	+= "Tipo Transac;Identific.;Qtd.Cobran.;Email Env.;Cod.Usr.Siga;Nome Usr.Sig;Id;Item Enviado;"

	cLin	+= "Divisao;Avaliado;Avaliador;Aprovador;CC - Avaliado; CC - Avaliador; CC - Aprovador;"


	cLin 	+= CRLF 										//Fim da Linha

	//Grava Registro
	fGravaReg(cLin)

	//Atualiza Sequencia
	nReg    += 1

Return

//Fim da Rotina



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � fChkPerg � Autor �Jose Carlos Gouveia � Data �  25/10/05   ���
�������������������������������������������������������������������������͹��
���Descri��o � Cria Perguntas                                             ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
����������������������������������������������������������������������������� */
Static Function fChkPerg()

	Local aRegs	:= {}

	aAdd(aRegs,{cPerg,'01','Visao                   ?','','','mv_ch1','C',06,0,0,'G','           ','mv_par01','               ','','','','','             ','','','','','             ','','','','','              ','','','','','               ','','','','RDK','','',''})
	aAdd(aRegs,{cPerg,'02','Nome do Arquivo         ?','','','mv_ch2','C',25,0,0,'G','fGetPath() ','mv_par02','               ','','','','','             ','','','','','             ','','','','','              ','','','','','               ','','','','   ','','',''})
	aAdd(aRegs,{cPerg,'03','Divis�o Ocupacional     ?','','','mv_ch3','C',03,0,0,'G','           ','mv_par03','               ','','','','','             ','','','','','             ','','','','','              ','','','','','               ','','','','   ','','',''})
	aAdd(aRegs,{cPerg,'04','Numero da Avaliacao     ?','','','mv_ch4','C',06,0,0,'G','           ','mv_par04','               ','','','','','             ','','','','','             ','','','','','              ','','','','','               ','','','','   ','','',''})


	ValidPerg(aRegs,cPerg)

Return
