#include 'protheus.ch'
#include 'parmtype.ch'
#include 'totvs.ch'

User Function BSLPRSZ0()

	Local cLinok 	:= "Allwaystrue"
	Local cTudook 	:= "Allwaystrue"
	Local nOpce 	:= 4 	//define modo de alteração para a enchoice
	Local nOpcg 	:= 4 	//define modo de alteração para o grid
	Local cFieldok 	:= "Allwaystrue"
	Local lRet 		:= .T.
	Local cMensagem := ""
	Local lVirtual  := .T. 	//Mostra campos virtuais se houver
	Local nFreeze	:= 0	
	Local nAlturaEnc:= 400	//Altura da Enchoice

	Private cCadastro	:= "Cadastro de Prescrição"	
	Private aCols 		:= {}
	Private aHeader 	:= {}
	Private aCpoEnchoice:= {}
	Private aAltEnchoice:= {"Z0_CODPRC","Z0_STATUS","Z0_DATPRC","Z0_CODPAC","Z0_NOMPAC","Z0_DTNASC","Z0_IDADE","Z0_PESO","Z0_ALTURA","Z0_ALERG","Z0_CODMED","Z0_NOMMED"}
	Private cTitulo
	Private cAlias1 	:= "SZ0"
	Private cAlias2 	:= "SZ1"

	// Verifica se o pedido já está liberado
	//If !Empty(SC5->C5_NOTA).Or.SC5->C5_LIBEROK=='E' .And. Empty(SC5->C5_BLQ)
	//    MsgStop("Este pedido está encerrado!")
	//Else
	RegToMemory("SZ0",.F.)
	RegToMemory("SZ1",.F.)

	DefineCabec()
	DefineaCols(nOpcg)

	lRet:=Modelo3(cCadastro,cAlias1,cAlias2,aCpoEnchoice,cLinok,cTudook,nOpce,nOpcg,cFieldok,lVirtual,,aAltenchoice,nFreeze,,,nAlturaEnc)

	//retornará como true se clicar no botao confirmar
	if lRet
		cMensagem += "Esta rotina tem a finalidade de salvar a Prescrição Médica"+CRLF+CRLF

		if MsgYesNo(cMensagem+"CONFIRMA INCLUSAO DOS DADOS ?", cCadastro)
			Processa({||Gravar()},cCadastro,"Alterando os dados, aguarde...")
			//Gravar()
		endif
		//else
		//RollbackSx8()
	endif

	//Endif

Return


Static Function DefineCabec()
	Local nX		:= 0
	Local aSZ1		:= {"Z1_CODPRC","Z1_ITMPRC","Z1_DIA","Z1_CDMEDIC","Z1_DSCPRC","Z1_CDUNID","Z1_DESCUN","Z1_QTDOSE","Z1_VIA","Z1_UNFREQ","Z1_QTFREQ","Z1_HORA"}
	Local nUsado
	aHeader		:= {}
	aCpoEnchoice:= {}

	nUsado:=0

	//Monta a enchoice
	DbSelectArea("SX3")
	SX3->(DbSetOrder(1))
	dbseek(cAlias1)
	while SX3->(!eof()) .AND. X3_ARQUIVO == cAlias1
		IF X3USO(X3_USADO) .AND. CNIVEL >= X3_NIVEL
			AADD(ACPOENCHOICE,X3_CAMPO)
		endif
		dbskip()
	enddo

	//Monta o aHeader do grid conforme os campos definidos no array aSZ1 (apenas os campos que deseja)
	//Caso contrário, se quiser todos os campos é necessário trocar o "For" por While, para que este faça a leitura de toda a tabela
	DbSelectArea("SX3")
	SX3->(DbSetOrder(2))
	aHeader:={}
	For nX := 1 to Len(aSZ1)
		If SX3->(DbSeek(aSZ1[nX]))
			If X3USO(X3_USADO).And.cNivel>=X3_NIVEL 
				nUsado:=nUsado+1
				Aadd(aHeader, {TRIM(X3_TITULO), X3_CAMPO , X3_PICTURE, X3_TAMANHO, X3_DECIMAL,X3_VALID, X3_USADO  , X3_TIPO   , X3_ARQUIVO, X3_CONTEXT})
			Endif
		Endif
	Next nX


Return

//Insere o conteudo no aCols do grid
Static function DefineaCols(nOpc)
	Local nQtdcpo 	:= 0
	Local i			:= 0
	Local nCols 	:= 0
	nQtdcpo 		:= len(aHeader)
	aCols			:= {}

	dbselectarea(cAlias2)
	dbsetorder(1)
	dbseek(xfilial(cAlias2)+(cAlias1)->Z0_CODPRC)
	while .not. eof() .and. (cAlias2)->Z1_FILIAL == xfilial(cAlias2) .and. (cAlias2)->Z1_CODPRC==(cAlias1)->Z0_CODPRC
		aAdd(aCols,array(nQtdcpo+1))
		nCols++
		for i:= 1 to nQtdcpo
			if aHeader[i,10] <> "V"
				aCols[nCols,i] := Fieldget(Fieldpos(aHeader[i,2]))
			else
				aCols[nCols,i] := Criavar(aHeader[i,2],.T.)
			endif
		next i
		aCols[nCols,nQtdcpo+1] := .F.
		dbselectarea(cAlias2)
		dbskip()
	enddo
Return


//Gravar o conteudo dos campos
Static Function Gravar()

	Local bcampo := { |nfield| field(nfield) }
	Local i:= 0
	Local y:= 0
	Local nitem := 0
	Local nItem 	:= aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z1_ITMPRC"})
	Local nProduto 	:= aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z1_CDMEDIC"})
	Local nPosCpo
	Local nCpo
	Local nI
	Local cCamposSZ0	:= "Z0_CODPRC|Z0_STATUS|Z0_DATPRC|Z0_CODPAC|Z0_NOMPAC|Z0_DTNASC|Z0_IDADE|Z0_PESO|Z0_ALTURA|Z0_ALERG|Z0_CODMED|Z0_NOMMED"
	Local cCamposSZ1	:= "Z1_CODPRC|Z1_ITMPRC|Z1_DIA|Z1_CDMEDIC|Z1_DSCPRC|Z1_CDUNID|Z1_DESCUN|Z1_QTDOSE|Z1_VIA|Z1_UNFREQ|Z1_QTFREQ|Z1_HORA"

	Begin Transaction

		//Gravando dados da enchoice
		dbselectarea(cAlias1)
		Reclock(cAlias1,.F.)	 
		for i:= 1 to fcount()
			incproc()
			if "FILIAL" $ FIELDNAME(i)
				Fieldput(i,xfilial(cAlias1))
			else
				//Grava apenas os campos contidos na variavel cCamposSZ0
				If ( FieldName(i) $ cCamposSZ0 )
					Fieldput(i,M->&(EVAL(bcampo,i)))
				Endif
			endif
		next i		 
		Msunlock()

		//Gravando dados do grid
		dbSelectArea("SZ1")
		SZ1->(dbSetOrder(1))	
		For nI := 1 To Len(aCols)
			If !(aCols[nI, Len(aHeader)+1])
				If SZ1->(dbSeek( xFilial("SZ1")+M->Z0_NUMPRC+aCols[nI,nItem]+aCols[nI,nProduto] ))
					RecLock("SZ1",.F.)
					For nCpo := 1 to fCount()
						//Grava apenas os campos contidos na variavel $cCamposSZ1
						If (FieldName(nCpo)$cCamposSZ1)
							nPosCpo := aScan(aHeader,{|x| AllTrim(x[2]) == AllTrim(FieldName(nCpo))})
							If nPosCpo > 0
								FieldPut(nCpo,aCols[nI,nPosCpo])
							EndIf
						Endif
					Next nCpo
					SZ1->(MsUnLock())
				Endif
			Endif
		Next nI

	End Transaction

Return