#INCLUDE "rwmake.ch"

#DEFINE  CRLF        Chr(13)+Chr(10)

//Definicao dos elementos do array aTotVal
#DEFINE	TOTHEA	 1 //Total de Header
#DEFINE TOTDET	 2 //Total de Detalhe
#DEFINE TOTTRA	 3 //Total de Trailer
#DEFINE TOTUEN	 4 //Total de Unidade de Entrega
#DEFINE TOTDEP	 5 //Total de Departamento
#DEFINE TOTFUT	 6 //Total de Funcionarios de VT
#DEFINE TOTITT	 7 //Total de Itens de VT
#DEFINE TOTPAS	 8 //Total de Passagens
#DEFINE TOTQVR	 9 //Total de Vale Refeicao
#DEFINE TOTVVR	10 //Total de Valor de VR
#DEFINE TOTFUE	11 //Total de Funcionarios VR Eletronico
#DEFINE TOTFUA  12 //Total de Funcionarios VA Eletronico
#DEFINE TOTTVR  13 //Valor Total VR Eletronico
#DEFINE TOTTVA  14 //Valor Total VA Eletronico

/*/    
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ GERTKTUN º Autor ³ JOSE CARLOS GOUVEIAº Data ³  10/11/2004 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Geracao de Arquivo Texto para Aquisicao do Kit Beneficios  º±±
±±º          ³ da Empresa Accor.                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP7 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºAlteracao ³  Data    ³ Analista  ³               Motivo                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±º          ³          ³           ³                                     º±±
±±º          ³          ³           ³                                     º±±
±±º          ³          ³           ³                                     º±±
±±º          ³          ³           ³                                     º±±
±±º          ³          ³           ³                                     º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function GerTktUn()

	//Declaracao de Variaveis
	SetPrvt("lEnd,lContinua,lAbortPrint,lDetVT,lDetVR,lDetVRE,lDetVAE,nHdl,nDafas,cPerg,cNomeArq,cArq,cArqInd,nPos")
	SetPrvt("aTotVal,lFlag,lTran,lAlim,lRef,cFilSRO,cFilSRN,cTexto,cValAnt,nTVlrServ,nSeq,nDtrab,nRef,aInfoE,nEnt,cFilEnt")

	//Carrega Variaveis
	lEnd        := .F.
	lContinua   := .T.
	lAbortPrint := .F.
	lDetVT		:= .F.
	lDetVR		:= .F.
	lDetVRE		:= .F.
	lDetVAE		:= .F.
	nHdl		:= 0
	nDafas		:= 0
	nPos		:= 0
	cPerg		:= "TKTUNI"
	cNomeArq	:= ""
	cArq		:= ""
	cArqInd		:= ""

	fChkPerg()
	pergunte(cPerg,.F.)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Montagem da tela de processamento.                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	@ 200,001 TO 410,480 DIALOG oDlg TITLE OemToAnsi( "Gera‡„o do Kit Beneficios" )
	@ 02,10 TO 095,230
	@ 10,018 Say " Este programa ira gerar um arquivo texto, conforme os parame- "
	@ 18,018 Say " tros definidos  pelo usuario,  com os registros do arquivo de "
	@ 26,018 Say " Geracao de Arquivo Texto para Aquisicao do Kit Beneficios.    "

	@ 70,128 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)
	@ 70,158 BMPBUTTON TYPE 02 ACTION Close(oDlg)
	@ 70,188 BMPBUTTON TYPE 01 ACTION OkGeraTxt()

	Activate Dialog oDlg Centered

	If nHdl > 0
		If fClose(nHdl)
			If (lDetVT .Or. lDetVR .Or. lDetVRE	.Or. lDetVAE) .And. lContinua //Flag de Detalhe de Funcionario com VT ou VR
				Aviso('AVISO','Gerado o arquivo ' + AllTrim(cNomeArq) + '...',{'OK'})	
			Else
				If fErase(cNomeArq) == 0
					If lContinua
						Aviso('AVISO','N„o existem registros a serem gravados. A gera‡„o do arquivo ' + AllTrim(cNomeArq) + ' foi abortada ...',{'OK'})
					EndIf	
				Else

					MsgAlert('Ocorreram problemas na tentativa de dele‡„o do arquivo '+AllTrim(cNomeArq)+'.')

				EndIf	
			EndIf	
		Else

			MsgAlert('Ocorreram problemas no fechamento do arquivo '+AllTrim(cNomeArq)+'.')

		EndIf

	EndIf  

	//Fechamento do Arquivo Temporario
	If File(cArq + ".DBF")

		//Seleciona Area
		dbSelectArea('TMPT')
		//dbCloseArea('TMPT')
		TMPT->(dbCloseArea())
		Ferase(cArq + ".DBF")
		Ferase (cArqInd+OrdBagExt())

	Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ OKGERATXTº Autor ³Jose Carlos Gouveia º Data ³  10/11/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao chamada pelo botao OK na tela inicial de processamenº±±
±±º          ³ to. Executa a geracao do arquivo texto.                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß */
Static Function OkGeraTxt()

	Close(oDlg)

	Processa({|| fRunTKT() },"Processando...")

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fRunTkt   ºAutor  ³Jose Carlos Gouveia º Data ³  10/11/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Processamento do Sistema                                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP7                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß */
Static Function fRunTkt()

	//Carrega Variaveis
	aTotVal		:= {0,0,0,0,0,0,0,0,0,0,0,0,0,0} //Informacoes definidas no #DEFINE
	lFlag		:= .F.
	lTran		:= .F.
	lAlim		:= .F.
	lRef		:= .F.
	cFilSRO		:= ""
	cFilSRN		:= ""
	cTexto		:= ""
	cValAnt		:= ""
	cFilEnt		:= ""
	nTVlrServ	:= 0
	nSeq		:= 1
	nDtrab 		:= 0
	nRef		:= 0 
	nEnt		:= 0
	aInfoE		:= {}

	//Variaveis das Perguntas
	Pergunte(cPerg,.F.)

	//Data de Referencia  		mv_par01
	//Refeicao          		mv_par02
	//Transporte           		mv_par03
	//Alimentacao Eletronico    mv_par04
	//Filial De            		mv_par05
	//Filial Ate         		mv_par06
	//Matricula De            	mv_par07
	//Matricula Ate          	mv_par08
	//Centro de Custo De      	mv_par09
	//Centro de Custo Ate   	mv_par10
	//Situacoes a Imprimir  	mv_par11
	//Categorias a Imprimir 	mv_par12
	//VT - Utilizacao De     	mv_par13
	//VT - Utilizacao Ate    	mv_par14
	//VT - Dt Entrega Minima 	mv_par15
	//VT - Dt Entrega Maxima	mv_par16
	//VR - Data Entrega      	mv_par17
	//VR - Data Entrega      	mv_par18
	//Perc do Kit            	mv_par19
	//Valor Ponto de Entrega 	mv_par20
	//Codigo do Cliente         mv_par21
	//Cod. Cliente Eletronico   mv_par22
	//Usuário do Sistema     	mv_par23
	//Nome do Arquivo           mv_par24
	//Entregar					mv_par25 
	//Filial de Entrega			mv_par26

	dDataRef	:= If(!Empty(mv_par01),mv_par01,dDataBase) // Periodo de Referencia
	nRef		:= mv_par02
	lTran		:= If(mv_par03==1,.T.,.F.)
	lAlim		:= If(mv_par04==1,.T.,.F.)
	cFilDe      := mv_par05
	cFilAte     := mv_par06
	cMatDe      := mv_par07
	cMatAte     := mv_par08
	cCcDe       := mv_par09
	cCcAte      := mv_par10
	cSit        := mv_par11
	cCat        := mv_par12
	dUtilDe     := mv_par13
	dUtilAte    := mv_par14
	dEntrMin    := mv_par15
	dEntrMax    := mv_par16
	dVrEntr     := mv_par17
	dVrEntr     := mv_par18
	nPercKit    := mv_par19
	nVlPonto    := mv_par20
	cCodcli		:= mv_par21
	cCodclie	:= mv_par22
	cUser		:= mv_par23	
	cNomeArq	:= mv_par24
	nEnt		:= mv_par25
	cFilEnt		:= If(!Empty(mv_par26),mv_par26,cFilAnt)
	cAnoMes     := Str(Year(dDataRef),4) + StrZero(Month(dDataRef),2)

	//Cria DBF
	fCriaDBF()

	//Cria o arquivo texto
	While .T.
		If File(cNomeArq)
			If (nAviso := Aviso('AVISO','Deseja substituir o ' + AllTrim(cNomeArq) + ' existente ?', {'Sim','N„o','Cancela'})) == 1
				If fErase(cNomeArq) == 0
					Exit
				Else
					MsgAlert('Ocorreram problemas na tentativa de dele‡„o do arquivo '+AllTrim(cNomeArq)+'.')
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
		MsgAlert('O arquivo '+AllTrim(cNomeArq)+' n„o p“de ser criado! Verifique os parƒmetros.','Aten‡„o!')
		Return
	Endif

	//Posiciona Tabelas
	dbSelectArea( "SRA" )
	dbSetOrder(2)
	dbGotop()
	ProcRegua(SRA->(RecCount())) 

	// Processamento
	While !SRA->(Eof()) .And. SRA->RA_FILIAL + SRA->RA_CC + SRA->RA_MAT <= cFilAte + cCcAte + cMatAte .And. lContinua

		nDtrab  	:= 30

		If lAbortPrint .Or. lEnd
			If Aviso('ATEN€AO','Deseja abandonar a Gera‡„o do arquivo ' + AllTrim(AllTrim(cNomeArq)) + ' ?',{'Sim','N„o'}) == 1
				lContinua := .F.
				Exit
			EndIf	
		Endif

		// Verifica Filtro Conforme Parametros
		If SRA->RA_FILIAL < cFilDe .Or. SRA->RA_FILIAL > cFilAte .Or. SRA->RA_CC < cCcDe .Or. SRA->RA_CC > cCcAte .Or.;
		SRA->RA_MAT < cMatDe .Or. SRA->RA_MAT > cMatAte .Or.!(SRA->RA_SITFOLH $ cSit) .Or. !(SRA->RA_CATFUNC $ cCat)

			SRA->(dbSkip())	
			Loop

		EndIf	

		// Verifica Dias de Afastamento
		//fDiasAfast(@nDafas,@nDtrab,dDataRef)

		//Gera Vale Transporte  
		If lTran

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Informa‡”es de Vale Transporte (SR0 e SRN)                          ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cFilSR0 := If(Empty(xFilial('SR0')),xFilial('SR0'),SRA->RA_FILIAL)
			cFilSRN := If(Empty(xFilial('SRN')),xFilial('SRN'),SRA->RA_FILIAL)
			// Adicionado Ana_090815-->	RG2_FILIAL+RG2_MAT+RG2_ANOMES+RG2_TPVALE+RG2_TPBEN+RG2_CODIGO
			cFilRG2 := If(Empty(xFilial('RG2')),xFilial('RG2'),SRA->RA_FILIAL)




			If SR0->(dbSeek(cFilSR0 + SRA->RA_MAT,.F.))

				//Pesquisa e Grava Unidade de Entrega
				If nEnt == 1 //Unica Filial de Entrega
					If !TMPT->(dbSeek("TTUN " + cFilEnt),Found())
						fLocalInfo(1,cFilEnt)
						fGerTTUN()
					Endif
				ElseIf nEnt == 2 //Filial de Entrega
					If !TMPT->(dbSeek("TTUN " + SRA->RA_FILIAL),Found())
						fLocalInfo(2,SRA->RA_FILIAL)
						fGerTTUN()
					Endif
				Else //Entrega por Centro de Custo
					If !TMPT->(dbSeek("TTUN " + SRA->RA_CC),Found())
						fLocalInfo(3,SRA->RA_CC)
						fGerTTUN()
					Endif
				Endif

				//Pesquisa e Grava Departamento
				If !TMPT->(dbSeek("TTDE " + SRA->RA_CC),Found())
					fGerTTDE()
				Endif

				//Grava Funcionario
				fGerTTFU()
				nSeqFu_	:= 0
				lDetVT	:= .T.  //Flag de Detalhe de Funcionario com VT


				While !SR0->(Eof()) .And. cFilSR0 + SR0->R0_MAT == SRA->RA_FILIAL + SRA->RA_MAT .And. lContinua

					If SR0->R0_QDIACAL <= 0 .Or. SR0->R0_TPVALE == "0" //.Or. !SRN->(dbSeek(cFilSRN + SR0->R0_MEIO, .F.))
						SR0->(dbSkip())
						Loop
					Endif

					If Empty(SRN->RN_ITEMPED)
						SR0->(dbSkip())
						Loop
					EndIf	

					cCodVT  := AllTrim(SRN->RN_ITEMPED)
					cOper	:= AllTrim(SRN->RN_BNFFOR)
					nVUnit  := SRN->RN_VUNIATU
					nSeqFu_	+= 1

					//Gera Itens de VT				
					fGerTTIT()

					SR0->(dbSkip())
				EndDo
			EndIf
		EndIf

		//ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Vale Alimentacao(1), Vale Refeicao(2)							³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		cFilSR0 := If(Empty(xFilial('SR0')),xFilial('SR0'),SRA->RA_FILIAL)

		//Posiciona Indices
		dbSelectArea('SR0')
		dbSetOrder(3)

		If nRef != 3 // 1 e 2 Gera Vale Refeicao 3 Nao Gera Vale Refeicao 
			//Verifica se Funcionario Vale Refeicao
			If SR0->(dbSeek(cFilSR0 + SRA->RA_MAT + "2",.F.))  //VALE REFEIÇÃO
				lFlag := .T.
			End	
			//	Else
			//		If RG2->(dbSeek(cFilRG2 + SRA->RA_MAT + cShAnomes + "1" + "03",.F.)) //VALE ALIMENTACAO
			//			lFlag := .T.
			//		Else
			//			lImpLis:= .F.
			//		Endif	
		Endif

		If lFlag 

			//Quantidade, Valor)
			nQtdRef := SR0->R0_QDIACAL
			nValRef := SR0->R0_VALCAL

			//	nDtrab	:= RG2->RG2_DIACAL
			//	nValBen	:= RG2->RG2_VALCAL

			//nValVA := Val(Subs(SRX->RX_TXT, 21, 12)) //Valor Facial
			//nQtdVA := Val(Subs(SRX->RX_TXT, 33, 3))  //Quantidade 
			//nValVR := Val(Subs(SRX->RX_TXT, 21, 12))
			//nQtdVR := Val(Subs(SRX->RX_TXT, 33, 3))

			//nValBe := nQtdVA * nValVA
			nQtdBen := Round(nQtdRef/30 * nDtrab,2)
			//nValBe := nDtrab * nValBen


			//Valor Total do Beneficio
			nTotBen := Round(nQtdBen * nValRef,2)		


			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Acumula as variaveis para posterior gravacao do registro tipo 9     ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	        nTotIt   := nTotIt + nQtdVA
			//nTotVl   := nTotVl + nValBe

			lFlag := .F.



			//If cValAnt != SR0->R0_VALEREF
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Informacoes de Vales-Refei‡„o (SRA e SRX)                           ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			//	If !Empty(SRA->RA_VALEREF) .And. SRX->(dbSeek(xFilial('SRX') + '26' + SRA->RA_FILIAL + SRA->RA_VALEREF, .F.))
			//		lFlag := .T.
			//	Else
			//		If !Empty(SRA->RA_VALEREF) .And. SRX->(dbSeek(xFilial('SRX') + '26  ' + SRA->RA_VALEREF, .F.))
			//						lFlag := .T.
			//		End
			//	End   
			//	cValAnt := SRA->RA_VALEREF
			//Else
			//				lFlag := .T.
			//	Endif

			//	If lFlag 

			//Quantidade, Valor)
			//	nQtdRef := Val(Subst(SRX->RX_TXT,33,3))
			//	nValRef := Val(Subst(SRX->RX_TXT,21,12))

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Gera Vale Refeicao para Ferias e Afastados                   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			//   If ( SRA->RA_SITFOLH == "F" .And. GetMv("MV_CALREFE") == "S" ) .Or.;
			//     ( SRA->RA_SITFOLH == "A" .And. GetMv("MV_CALREAF") == "S" ) .Or.;
			//		   ( SRA->RA_SITFOLH == " " )
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Calc. dias proporc.Dt Admissao ou Calc.Prop.p/ Afastados     ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			//		If ( SRA->RA_SITFOLH == "F" .And. GetMv("MV_CALREFE") == "S" .And.;
			//			 GetMv("MV_CALREPR") == "S" ) .Or.;
			//			( SRA->RA_SITFOLH == "A" .And. GetMv("MV_CALREAF") == "S" .And.;
			//			 GetMv("MV_CALREPR") == "S" ) .Or.;
			//			( SRA->RA_SITFOLH == " " .And. GetMv("MV_CALREAD") == "S" )

			//			nQtdBen := Round(nQtdRef/30 * nDtrab,2)

			//		Else                   

			//         	nQtdBen := nQtdRef

			//		Endif

			//Valor Total do Beneficio
			//		nTotBen := Round(nQtdBen * nValRef,2)		

			//	Else
			//		nTotBen := 0
			//	Endif

			//	lFlag := .F.

			If nRef == 1 .And. nTotBen > 0 //Vale Refeicao Papel

				//Pesquisa e Grava Unidade de Entrega
				If nEnt == 1 //Unica Filial de Entrega
					If !TMPT->(dbSeek("TR012" + cFilEnt),Found())
						fLocalInfo(1,cFilEnt)
						fGerTR012()
					Endif
				ElseIf nEnt == 2 //Filial de Entrega
					If !TMPT->(dbSeek("TR012" + SRA->RA_FILIAL),Found())
						fLocalInfo(2,SRA->RA_FILIAL)
						fGerTR012()
					Endif
				Else //Entrega por Centro de Custo
					If !TMPT->(dbSeek("TR012" + SRA->RA_CC),Found())
						fLocalInfo(3,SRA->RA_CC)
						fGerTR012()
					Endif
				Endif

				//Pesquisa Entrega
				If nEnt == 1
					TMPT->(dbSeek("TR012" + cFilEnt),Found())
				ElseIf nEnt == 2
					TMPT->(dbSeek("TR012" + SRA->RA_FILIAL),Found())
				Else 
					TMPT->(dbSeek("TR012" + SRA->RA_CC),Found())
				Endif 

				//Gera Item Funcionario
				fGerTR013()
				lDetVR := .T. //Flag de Detalhe de Funcionario com VR

			ElseIf nRef == 2 .And. nTotBen > 0 //Vale Refeicao Eletronico

				//Pesquisa e Grava Unidade de Entrega
				If nEnt == 1 //Unica Filial de Entrega
					If !TMPT->(dbSeek("TRE  " + cFilEnt),Found())
						fLocalInfo(1,cFilEnt)
						fGerTRE()
					Endif
				ElseIf nEnt == 2 //Filial de Entrega
					If !TMPT->(dbSeek("TRE  " + SRA->RA_FILIAL),Found())
						fLocalInfo(2,SRA->RA_FILIAL)
						fGerTRE()
					Endif
				Else //Entrega por Centro de Custo
					If !TMPT->(dbSeek("TRE  " + SRA->RA_CC),Found())
						fLocalInfo(3,SRA->RA_CC)
						fGerTRE()
					Endif
				Endif

				//Gera Item Funcionario
				fGerTRF()
				lDetVRE := .T. //Flag de Detalhe de Funcionario com VR Eletronico

			Endif		

		Endif	

		//	Endif

		//ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Vale Alimentacao(1),                     							³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lAlim


			cFilSR0 := If(Empty(xFilial('SR0')),xFilial('SR0'),SRA->RA_FILIAL)

			//Posiciona Indices
			dbSelectArea('SR0')
			dbSetOrder(3)

			//Verifica se Funcionario Vale Alimentação
			If SR0->(dbSeek(cFilSR0 + SRA->RA_MAT + "1",.F.))  //VALE ALIMENTAÇÃO
				lFlag := .T.
			Endif	


			If 	lFlag 

				nValRef := SR0->R0_VALCAL
				nTotBen := nValRef



				If nTotBen > 0

					//Pesquisa e Grava Unidade de Entrega
					If nEnt == 1 //Unica Filial de Entrega
						If !TMPT->(dbSeek("TAE  " + cFilEnt),Found())
							fLocalInfo(1,cFilEnt)
							fGerTAE()
						Endif
					ElseIf nEnt == 2 //Filial de Entrega
						If !TMPT->(dbSeek("TAE  " + SRA->RA_FILIAL),Found())
							fLocalInfo(2,SRA->RA_FILIAL)
							fGerTAE()
						Endif
					Else //Entrega por Centro de Custo
						If !TMPT->(dbSeek("TAE  " + SRA->RA_CC),Found())
							fLocalInfo(3,SRA->RA_CC)
							fGerTAE()
						Endif
					Endif

					//Gera Item Funcionario
					fGerTAF()
					lDetVAE := .T. //Flag de Detalhe de Funcionario com VA Eletronico

				Endif
			Endif
		Endif

		SRA->(dbSkip())


		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Incrementa a regua                                                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		IncProc('Gerando o Arquivo... ')
	Enddo

	//Grava Arquivo
	If (lDetVT .Or. lDetVR .Or. lDetVRE .Or. lDetVAE) //Flag de Detalhe de Funcionario com VT,VR (Papel e Eletronico) ou VA Eletronico

		//Header do Arquivo
		fGerLSUP5()

		If lDetVT //Funcionario com Detalhe de VT  

			//Header do Arquivo de VT
			fGerT()

			//Calculo do Valor do Servico
			nTVlrServ := (nPercKit * aTotVal[TOTPAS]) + (aTotVal[TOTUEN] * nVlPonto)

			//Registro de Pedido
			fGerTTPE()

			//Unidade de Entrega	
			If TMPT->(dbSeek("TTUN"),Found())
				While TMPT->TIPREG = "TTUN"
					fGravaReg(AllTrim(TMPT->TEXTO))
					TMPT->(dbSkip())
				Enddo
			Endif

			//Departamento			
			If TMPT->(dbSeek("TTDE"),Found())
				While TMPT->TIPREG = "TTDE"
					fGravaReg(AllTrim(TMPT->TEXTO))
					TMPT->(dbSkip())
				Enddo
			Endif

			//Funcionarios
			If TMPT->(dbSeek("TTFU"),Found())
				While TMPT->TIPREG = "TTFU"
					fGravaReg(AllTrim(TMPT->TEXTO))
					TMPT->(dbSkip())
				Enddo
			Endif

			//Item de Vale Transporte
			If TMPT->(dbSeek("TTIT"),Found())
				While TMPT->TIPREG = "TTIT"
					fGravaReg(AllTrim(TMPT->TEXTO))
					TMPT->(dbSkip())
				Enddo
			Endif

			//Trailler de VT
			fGerTT99()

		Endif

		If lDetVR //Funcionario com Detalhe de VR 

			//Header do Vale Refeicao
			fGerTR010()

			//Unidades de entrega de VR
			If TMPT->(dbSeek("TR012"),Found())
				While TMPT->TIPREG = "TR012"       
					cTexto	:= AllTrim(TMPT->TEXTO)
					cTexto 	+= StrZero(nSeq,5) + CRLF
					fGravaReg(cTexto)
					TMPT->(dbSkip())
					nSeq	+= 1
				Enddo
			Endif

			//Item de Vale Refeicao
			If TMPT->(dbSeek("TR013"),Found())
				While TMPT->TIPREG = "TR013"
					cTexto	:= AllTrim(TMPT->TEXTO)
					cTexto 	+= StrZero(nSeq,5) + CRLF
					fGravaReg(cTexto)
					TMPT->(dbSkip())
					nSeq	+= 1
				Enddo
			Endif

			//Trailler de VR
			fGerTR019()
		Endif

		If lDetVRE //Funcionario com Detalhe de VR Eletronico

			//Inicia Sequencia
			nSeq	:= 1

			//Header do Vale Refeicao
			fGerHTRE()

			//Unidades de entrega de VR
			If TMPT->(dbSeek("TRE"),Found())
				While TMPT->TIPREG = "TRE"       
					cTexto	:= AllTrim(TMPT->TEXTO)
					cTexto 	+= StrZero(nSeq,5) + CRLF
					fGravaReg(cTexto)
					TMPT->(dbSkip())
					nSeq	+= 1
				Enddo
			Endif

			//Item de Vale Refeicao
			If TMPT->(dbSeek("TRF"),Found())
				While TMPT->TIPREG = "TRF"
					cTexto	:= AllTrim(TMPT->TEXTO)
					cTexto 	+= StrZero(nSeq,5) + CRLF
					fGravaReg(cTexto)
					TMPT->(dbSkip())
					nSeq	+= 1
				Enddo
			Endif

			//Trailler de VR
			fGerTTRE()

		Endif

		If lDetVAE //Funcionario com Detalhe de VA Eletronico

			//Inicia Sequencia
			nSeq	:= 1

			//Header do Vale Alimentacao
			fGerHTAE()

			//Unidades de entrega de VA
			If TMPT->(dbSeek("TAE"),Found())
				While TMPT->TIPREG = "TAE"       
					cTexto	:= AllTrim(TMPT->TEXTO)
					cTexto 	+= StrZero(nSeq,5) + CRLF
					fGravaReg(cTexto)
					TMPT->(dbSkip())
					nSeq	+= 1
				Enddo
			Endif

			//Item de Vale Alimentacao
			If TMPT->(dbSeek("TAF"),Found())
				While TMPT->TIPREG = "TAF"
					cTexto	:= AllTrim(TMPT->TEXTO)
					cTexto 	+= StrZero(nSeq,5) + CRLF
					fGravaReg(cTexto)
					TMPT->(dbSkip())
					nSeq	+= 1
				Enddo
			Endif

			//Trailler de VA
			fGerTTAE()

		Endif


		//Trailler do Arquivo
		fGerLSUP9()

	Endif

Return	    		

//Fim da Rotina

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fGerT     ºAutor  ³Jose Carlos Gouveia º Data ³  10/11/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera Header T                                              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP7                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß */
Static Function fGerT()

	cTexto := fGerStr(4,"T")                // 001 - 004 -> Tipo do Pacote
	cTexto += "C"                           // 005 - 005 -> Ordem do Kit
	cTexto += GravaData(dDataBase,.F.,8)    // 006 - 013 -> Data da Geracao
	cTexto += "V4.0"                        // 014 - 017 -> Ordem do Kit
	cTexto += Space(60)                     // 018 - 077 -> Brancos
	cTexto += CRLF

	aTotVal[TOTHEA] += 1

	fGravaReg(AllTrim(cTexto))

Return

//Fim da Rotina

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fGerTTPE  ºAutor  ³Jose Carlos Gouveia º Data ³  10/11/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera Registro TTPE                                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP7                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß */
Static Function fGerTTPE()

	cTexto := "TTPE"                                          // 001 - 004 -> Tipo do Produto
	cTexto += Transform(SM0->M0_CGC,'@R 99.999.999/9999-99' ) // 005 - 022 -> Cnpj Principal
	cTexto += "K."+GravaData(dDataRef,.F.,1)                  // 023 - 032 -> Numero do Pedido
	cTexto += StrZero(aTotVal[TOTUEN],4)                      // 033 - 036 -> Qde Unidades Pedido
	cTexto += StrZero(aTotVal[TOTDEP],4)                      // 037 - 040 -> Qde Deptos Pedido
	cTexto += StrZero(aTotVal[TOTFUT],5)                      // 041 - 045 -> Qde Funcionario Pedido
	cTexto += StrZero(aTotVal[TOTITT],6)                      // 046 - 051 -> Qde Itens Pedido
	cTexto += Transform(nTVlrServ,'9999999999999.99')         // 052 - 067 -> Valor Servicos Pedido
	cTexto += Transform(aTotVal[TOTPAS],'9999999999999.99')   // 068 - 083 -> Valor Bilhetes Pedido
	cTexto += GravaData(dDataBase,.F.,8)                      // 084 - 091 -> Data de Geracao
	cTexto += " "                                             // 092 - 092 -> Espacos
	cTexto += GravaData(dUtilDe,.F.,8)                        // 093 - 100 -> Periodo Utilizacao De
	cTexto += GravaData(dUtilAte,.F.,8)                       // 101 - 108 -> Periodo Utilizacao Ate
	cTexto += Transform(nPercKit,'999999999.99')              // 109 - 120 -> Preco de 01 Kit
	cTexto += Transform(nVlPonto,'999999999.99')              // 121 - 132 -> Preco por Ponto Entrega
	cTexto += "N"                                             // 133 - 133 -> Tipo do Pedido
	cTexto += StrZero(aTotVal[TOTUEN],4)                      // 134 - 137 -> Qde Unidades Pagas
	cTexto += "C"                                             // 138 - 138 -> Ordem do Pedido TT
	cTexto += "P"                                             // 139 - 139 -> Tipo Rateio Entregas
	cTexto += "%  "                                           // 140 - 142 -> Moeda do Kit
	cTexto += "R$ "                                           // 143 - 145 -> Moeda da Entrega 
	cTexto += CRLF

	aTotVal[TOTDET] += 1

	fGravaReg(AllTrim(cTexto))

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fGerTTUN  ºAutor  ³Jose Carlos Gouveia º Data ³  10/11/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera Registro TTUN                                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP7                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß */

Static Function fGerTTUN()

	cTexto := "TTUN"                                                			// 001 - 004 -> Tipo de Registro
	cTexto += Transform(aInfoE[3],'@R 99.999.999/9999-99' )	        			// 005 - 022 -> CNPJ
	cTexto += "K."+GravaData(dDataRef,.F.,1) 	// 023 - 032 -> Numero do Pedido
	cTexto += fGerZero(6,aInfoE[11])	                            			// 033 - 038 -> Codigo Un. Entrega
	cTexto += fGerStr(26,aInfoE[12])                                			// 039 - 064 -> Nome Uni.Entrega
	cTexto += fGerStr(4,"R")                                        			// 065 - 068 -> Tipo Logradouro
	cTexto += fGerStr(30,aInfoE[4])												// 069 - 098 -> Nome do Logradouro
	cTexto += fGerZero(6,"0")		                                			// 099 - 104 -> Numero do Logradouro
	cTexto += Space(10)                                             			// 105 - 114 -> Complemento do Logradouro
	cTexto += fGerStr(15,aInfoE[6])												// 115 - 129 -> Bairro
	cTexto += fGerStr(25,aInfoE[7])												// 130 - 154 -> Municipio
	cTexto += Subst(aInfoE[9],1,5)         										//     CEP
	cTexto += "-" + Subst(aInfoE[9],5,3) 										// 155 - 163 -> CEP
	cTexto += aInfoE[8]     													// 164 - 165 -> Estado
	cTexto += GravaData(dEntrMin,.F.,8)                             			// 166 - 173 -> Data Minima Entrega
	cTexto += GravaData(dEntrMax,.F.,8)                             			// 174 - 181 -> Data Maxima Entrega
	cTexto += fGerStr(20," ")				                           			// 182 - 201 -> Responsavel Recebimento
	cTexto += fGerZero(11,aInfoE[10])	                             			// 202 - 212 -> Fone Contato
	cTexto += fGerZero(4,"0")                                       			// 213 - 216 -> Ramal
	cTexto += "S"                                                   			// 217 - 217 -> Lista de Assinatura
	cTexto += Space(40)                                             			// 218 - 257 -> Reservado
	cTexto += "N"                                                   			// 258 - 258 -> Separacao por Departamento
	cTexto += CRLF

	If RecLock("TMPT",.T.)
		TMPT->TIPREG	:=	"TTUN"
		TMPT->CODIGO	:= aInfoE[11]
		TMPT->TEXTO		:= cTexto
		MSunLock()			
		aTotVal[TOTUEN] += 1
		aTotVal[TOTDET] += 1
	Endif  

Return

//Fim da Rotina

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fGerTTDE  ºAutor  ³Jose Carlos Gouveia º Data ³  10/11/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera Registro TTDE                                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP7                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß */

Static Function fGerTTDE()

	//Pesquisa Centro de Custos
	CTT->(dbSeek(xFilial("CTT") + SRA->RA_CC))

	//Departamento
	cTexto := "TTDE"                                             // 001 - 004 -> Tipo de Produto
	cTexto += Transform(aInfoE[3],'@R 99.999.999/9999-99' )      // 005 - 022 -> CNPJ
	cTexto += "K."+GravaData(dDataRef,.F.,1)                     // 023 - 032 -> Numero do Pedido
	cTexto += fGerZero(6,aInfoE[11])	                         // 033 - 038 -> Codigo Un. Entrega
	cTexto += fGerZero(6,SRA->RA_CC)	                         // 039 - 044 -> Codigo Departamento
	cTexto += fGerStr(26,CTT->CTT_DESC01)                        // 045 - 070 -> Nome Departamento
	cTexto += Space(20)                                          // 071 - 090 -> Reservado
	cTexto += Transform(aInfoE[3],'@R 99.999.999/9999-99' )	     // 091 - 108 -> CNPJ de Faturamento
	cTexto += CRLF

	If RecLock("TMPT",.T.)
		TMPT->TIPREG	:=	"TTDE"
		TMPT->CODIGO	:= SRA->RA_CC
		TMPT->TEXTO		:= cTexto
		MSunLock()			
		aTotVal[TOTDEP]	+= 1
		aTotVal[TOTDET]	+= 1
	Endif

Return

//Fim da Rotina

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fGerTTFU  ºAutor  ³Jose Carlos Gouveia º Data ³  10/11/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera Registro TTFU                                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP7                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß */

Static Function fGerTTFU()

	cTexto := "TTFU"                                          // 001 - 004 -> Tipo do Produto
	cTexto += Transform(aInfoE[3],'@R 99.999.999/9999-99' )   // 005 - 022 -> Cnpj Principal
	cTexto += "K."+GravaData(dDataRef,.F.,1)                  // 023 - 032 -> Numero do Pedido
	cTexto += fGerZero(6,SRA->RA_CC)	                      // 033 - 038 -> Codigo da Unidade
	cTexto += fGerZero(6,SRA->RA_CC)	                      // 039 - 044 -> Codigo do Depto  
	cTexto += fGerZero(12,SRA->RA_FILIAL + SRA->RA_MAT)       // 045 - 052 -> Codigo do Funcionario
	cTexto += fGerStr(30,SRA->RA_NOME)                        // 057 - 086 -> Nome do Funcionario
	cTexto += fGerStr(10,STRTRAN(SRA->RA_RG,".",""),1,10)     // 087 - 096 -> Nro RG do funcionário 
	cTexto += fGerZero(11,SRA->RA_CIC)                        // 097 - 107 -> Nro CPF do funcionário  
	cTexto += Space(4)							              // 108 - 111 -> Reservado
	cTexto += GravaData(SRA->RA_NASC,.F.,8)           		  // 112 - 119 -> Data Nascimento aaaammdd
	cTexto += SRA->RA_RGUF                        			  // 120 - 121 -> Estado de Emissao do RG
	cTexto += SRA->RA_SEXO                        			  // 122 - 122 -> Sexo do funcionário     
	cTexto += fGerStr(30,SRA->RA_MAE)                         // 123 - 152 -> Nome da Mãe do funcionário 
	cTexto += fGerStr(5,"R")                       			  // 153 - 157 -> Tipo do Logradouro fixamos "RUA"          
	cTexto += fGerStr(40,SRA->RA_ENDEREC)                     // 158 - 197 -> Descricao do Logradouro     
	cTexto += fGerZero(6,"0")                                 // 198 - 203 -> Nro. do Logradouro fixamos "000000"          
	cTexto += fGerStr(15,SRA->RA_COMPLEM)                     // 204 - 218 -> Complemento do Endereco        
	cTexto += fGerStr(40,SRA->RA_MUNICIP)               	  // 219 - 258 -> Municipio do Endereco         
	cTexto += fGerStr(30,SRA->RA_BAIRRO)               		  // 259 - 288 -> Bairro
	cTexto += fGerZero(8,SRA->RA_CEP)             			  // 289 - 296 -> Cep do Endereco            
	cTexto += SRA->RA_ESTADO  								  // 297 - 298 -> Estado do Endereco
	cTexto += "000201"										  // 299 - 304 -> Fixo
	cTexto += Space(6)										  // 305 - 310 -> Fixo
	cTexto += CRLF

	If RecLock("TMPT",.T.)
		TMPT->TIPREG	:=	"TTFU"
		TMPT->CODIGO	:= SRA->RA_FILIAL + SRA->RA_MAT
		TMPT->TEXTO		:= cTexto
		MSunLock()			
		aTotVal[TOTFUT]	+= 1   
		aTotVal[TOTDET]	+= 1

	Endif

Return

//Fim da Rotina

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fGerTTIT  ºAutor  ³Jose Carlos Gouveia º Data ³  10/11/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera Registro TTIT                                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP7                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß */

Static Function fGerTTIT()

	cTexto := "TTIT"                                             // 001 - 004 -> Tipo do Produto
	cTexto += Transform(aInfoE[3],'@R 99.999.999/9999-99' )      // 005 - 022 -> Cnpj Principal
	cTexto += "K."+GravaData(dDataRef,.F.,1) 	                 // 023 - 032 -> Numero do Pedido
	cTexto += fGerZero(6,SRA->RA_CC)	                         // 033 - 038 -> Codigo da Unidade
	cTexto += fGerZero(6,SRA->RA_CC)	                         // 039 - 044 -> Codigo do Depto  
	cTexto += fGerZero(12,SRA->RA_FILIAL + SRA->RA_MAT)          // 045 - 056 -> Codigo do Funcionario
	cTexto += StrZero(nSeqFu_,3)                          		 // 057 - 059 -> Seq Itens Funcionario
	cTexto += StrZero(SR0->R0_QDIACAL,8)						 // 060 - 067 -> Qde Bilhetes/Viagens
	cTexto += fGerZero(9,Transform(SRN->RN_VUNIATU,'999999.99')) // 068 - 076 -> Valor Tarifa do Item
	cTexto += fGerStr(6,SRN->RN_BNFFOR)                          // 077 - 082 -> Codigo Operadora Transp
	cTexto += fGerStr(12,SRN->RN_ITEMPED)                        // 083 - 094 -> Codigo Bilhete Operadora
	//Verificar-->campo especifico
	cTexto += fGerStr(4,SRN->RN_XTPBILH)                         // 095 - 098 -> Tipo Bilhete
	cTexto += "N"                                           	 // 099 - 099 -> Flag Tipo Pedido
	cTexto += CRLF

	If RecLock("TMPT",.T.)
		TMPT->TIPREG	:=	"TTIT"
		TMPT->CODIGO	:= Space(8)
		TMPT->TEXTO		:= cTexto
		MSunLock()			
		aTotVal[TOTITT]	+= 1
		aTotVal[TOTPAS]	+= SR0->R0_QDIACAL
		aTotVal[TOTDET]	+= 1
	Endif

Return

//Fim da Rotina

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fGerTT99  ºAutor  ³Jose Carlos Gouveia º Data ³  10/11/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera Registro TT99                                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP7                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß */

Static Function fGerTT99() 

	cTexto := "9999"                               // 001 - 004 -> Fixo "9999"
	cTexto += StrZero(aTotVal[TOTITT],8)           // 005 - 012 -> Total Linhas
	cTexto += Space(152)                           // 013 - 164 -> Brancos
	cTexto += CRLF

	aTotVal[TOTTRA]	+= 1

	fGravaReg(AllTrim(cTexto))

Return

//Fim da Rotina

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fGerTR010 ºAutor  ³Jose Carlos Gouveia º Data ³  10/11/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera Registro TR010                                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP7                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß */

Static Function fGerTR010()

	cTexto := "TR01"                                   // 001 - 004 -> Tipo do Produto
	cTexto += "0"                                      // 005 - 005 -> Tipo Registro
	cTexto += "R"                                      // 006 - 006 -> Refeicao
	cTexto += cCodCli				                    // 007 - 016 -> Codigo Cliente Ticket
	cTexto += fGerStr(30,SM0->M0_NOMECOM)              // 017 - 046 -> Nome da Empresa
	cTexto += GravaData(dDataBase,.F.,8)               // 047 - 054 -> Data de Geracao
	cTexto += GravaData(dVrEntr,.F.,8)                 // 055 - 062 -> Data de Entrega
	cTexto += "A"                                      // 063 - 063 -> Tipo do Pedido
	cTexto += " "                                      // 064 - 064 -> Brancos
	cTexto += "S"                                      // 065 - 065 -> Relatorio Assinaturas
	cTexto += "1"                                      // 066 - 066 -> 1a Linha Pers Ticket
	cTexto += "2"                                      // 067 - 067 -> 2a Linha Pers Ticket
	cTexto += "4"                                      // 068 - 068 -> 1a Linha Pers Rotulo
	cTexto += "5"                                      // 069 - 069 -> 2a Linha Pers Rotulo
	cTexto += "N"                                      // 070 - 070 -> Recibo Encarte
	cTexto += "N"                                      // 071 - 071 -> Relatorio Gerencial
	cTexto += "N"                                      // 072 - 072 -> Resumo Unidades
	cTexto += Space(7)                                 // 073 - 079 -> Brancos
	cTexto += StrZero(Month(dDataRef),2)               // 080 - 081 -> Mes Utilizacao
	cTexto += Space(19)                                // 082 - 100 -> Brancos
	cTexto += "04"                                     // 101 - 102 -> Tipo de Lay-Out
	cTexto += Space(56)								// 103 - 158 -> Reservado
	cTexto += StrZero(nSeq,6)                          // 159 - 164 -> Controle Sequencia
	cTexto += CRLF

	nSeq	+= 1
	aTotVal[TOTHEA] += 1

	fGravaReg(AllTrim(cTexto))

	aTotVal[TOTDET]	+= 1


Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fGerTR012 ºAutor  ³Jose Carlos Gouveia º Data ³  10/11/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera Registro TR012                                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP7                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß */

Static Function fGerTR012()

	cTexto := "TR01" 															// 001 - 004 -> Tipo do Produto
	cTexto += "2"																// 005 - 005 -> Tipo Registro
	cTexto += fGerZero(6,aInfoE[11])											// 006 - 011 -> Codigo do Depto 
	cTexto += fGerStr(20,aInfoE[12])											// 012 - 031 -> Nome do Depto
	cTexto += fGerStr(4,"R")                        							// 032 - 035 -> Tipo de Logradouro
	cTexto += fGerStr(30,aInfoE[4])												// 036 - 065 -> Nome do Logradouro
	cTexto += fGerZero(6,"000000")								                // 066 - 071 -> Numero do Logradouro
	cTexto += fGerStr(10,aInfoE[5])                    							// 072 - 081 -> Complemento do Logradouro
	cTexto += fGerStr(25,aInfoE[7])												// 082 - 106 -> Municipio
	cTexto += fGerStr(15,aInfoE[6])  											// 107 - 121 -> Bairro
	cTexto += Subst(aInfoE[9],1,5)												// 122 - 126 -> CEP
	cTexto += aInfoE[8]															// 127 - 128 -> Estado
	cTexto += fGerStr(20,cUser)										            // 129 - 148 -> Responsavel
	cTexto += Subst(aInfoE[9],5,3)         										// 149 - 151 -> Complemento CEP
	cTexto += Space(7)                              							// 152 - 158 -> Reservado
	cTexto += "0"                                   							// 159 - 164 -> Sequencial

	If RecLock("TMPT",.T.)
		TMPT->TIPREG	:=	"TR012"
		TMPT->CODIGO	:= aInfoE[11]
		TMPT->TEXTO		:= cTexto
		MSunLock()
		aTotVal[TOTDET]	+= 1
	Endif  


Return

//Fim da Rotina

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fGerTR012 ºAutor  ³Jose Carlos Gouveia º Data ³  10/11/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera Registro TR013                                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP7                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß */

Static Function fGerTR013()

	//Pesquisa Setor
	CTT->(dbSeek(xFilial("CTT") + SRA->RA_CC))

	cTexto := "TR01"                            	        // 001 - 004 -> Tipo do Produto
	cTexto += "3"                                   	    // 005 - 005 -> Tipo Registro
	cTexto += fGerZero(6,SRA->RA_CC)   		            	// 006 - 011 -> Codigo do Depto 
	cTexto += fGerStr(20,CTT->CTT_DESC01)                 	// 012 - 031 -> Nome do Depto
	cTexto += fGerZero(12,SRA->RA_FILIAL + SRA->RA_MAT) 	// 032 - 043 -> Codigo do Funcionario
	cTexto += Space(26)                                 	// 044 - 069 -> Personalizacao By Cliente
	cTexto += fGerZero(6,Subst(TMPT->TEXTO,6,6))  	 		// 070 - 075 -> Codigo da Unidade 
	cTexto += fGerStr(20,Subst(TMPT->TEXTO,12,20))     		// 076 - 095 -> Descricao da Unidade
	cTexto += StrZero(nQtdBen,3)                        	// 096 - 098 -> Total Tickets Func
	cTexto += StrZero(nQtdBen,2)                        	// 099 - 100 -> Tickets Por Talao
	cTexto += StrZero(Int(nValRef*100),9)               	// 101 - 109 -> Valor Facial Ticket
	cTexto += "R"                                       	// 110 - 110 -> Refeicao
	cTexto += "C"                                       	// 111 - 111 -> Carne
	cTexto += fGerStr(30,SRA->RA_NOME)                  	// 112 - 141 -> Nome do Funcionario
	cTexto += Space(17)                                 	// 142 - 158 -> Brancos
	cTexto += "0"                                       	// 159 - 164 -> Controle Sequencia

	If RecLock("TMPT",.T.)
		TMPT->TIPREG	:=	"TR013"
		TMPT->CODIGO	:= Space(8)
		TMPT->TEXTO		:= cTexto
		MSunLock()			
		aTotVal[TOTQVR]	+= nQtdBen
		aTotVal[TOTVVR]	+= (nValRef * nQtdBen)
		aTotVal[TOTDET]	+= 1	
	Endif  

//Fim da Rotina 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fGerTR019 ºAutor  ³Jose Carlos Gouveia º Data ³  10/11/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera Registro TR019                                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP7                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß */

Static Function fGerTR019() 

	cTexto := "TR01"                                // 001 - 004 -> Tipo do Produto
	cTexto += "9"                                   // 005 - 005 -> Tipo Registro
	cTexto += StrZero(aTotVal[TOTQVR],8)            // 006 - 013 -> Total Tickets
	cTexto += StrZero(aTotVal[TOTVVR] * 100,14)     // 014 - 027 -> Total Pedidos
	cTexto += Space(131)                            // 028 - 158 -> Brancos
	cTexto += StrZero(nSeq,6)                       // 159 - 164 -> Controle Sequencia
	cTexto += CRLF

	aTotVal[TOTTRA]	+= 1
	nSeq			+= 1

	fGravaReg(AllTrim(cTexto))

Return

//Fim da Rotina

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fGerLSUP  ºAutor  ³Jose Carlos Gouveia º Data ³  10/11/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera Registro LSUP5                                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP7                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß */

Static Function fGerLSUP5() 

	cTexto := "LSUP5"                      // 001 - 005 -> Tipo do Registro 
	cTexto += fGerStr(8,cUser)             // 006 - 013 -> Nome do Usuario que gerou o arquivo 
	cTexto += Space(11)                    // 014 - 024 -> Brancos 
	cTexto += GravaData(dDataBase,.F.,8 )  // 025 - 032 -> Data da Geracao
	cTexto += Time()	   				   // 033 - 040 -> Hora da Gravação HH.MM.SS
	cTexto += "LAYOUT-24/12/2007"          // 041 - 057 -> Fixo 
	cTexto += Space(107)                   // 058 - 107 -> Brancos 
	cTexto += CRLF

	fGravaReg(AllTrim(cTexto))

Return

//Fim da Rotina

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ fGerHTRE ºAutor  ³Jose Carlos Gouveia º Data ³  04/02/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera Registro Header Vale Refeicao Eletronico              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP7                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß */

Static Function fGerHTRE()

	cTexto := "T"         	                            // 001 - 001 -> Fixo T
	cTexto += "R"                                       // 002 - 002 -> Refeicao
	cTexto += "02"										// 003 - 004 -> Fixo 02
	cTexto += "0"										// 005 - 005 -> 0
	cTexto += "R"										// 006 - 006 -> Refeicao
	cTexto += cCodClie				                   	// 007 - 016 -> Codigo Cliente Ticket
	cTexto += fGerStr(30,aInfoE[2])		              	// 017 - 046 -> Nome da Empresa
	cTexto += GravaData(dDataBase,.F.,8)               	// 047 - 054 -> Data de Geracao
	cTexto += GravaData(dVrEntr,.F.,8)                 	// 055 - 062 -> Data de Entrega
	cTexto += "C"                                      	// 063 - 063 -> C
	cTexto += Space(16)                                	// 064 - 079 -> Brancos
	cTexto += StrZero(Month(dDataBase),2)              	// 080 - 081 -> Mes de Referencia
	cTexto += Space(19)                                	// 082 - 100 -> Brancos
	cTexto += "04"		                                // 101 - 102 -> 04
	cTexto += "34"		          		                // 103 - 104 -> Tipo de Cartao - (TRE
	cTexto += Space(48)									// 105 - 152 -> Brancos
	cTexto += fGerStr(06,"SUP")							// 153 - 158 -> Preencher com "SUP"
	cTexto += StrZero(nSeq,6)                           // 159 - 164 -> Controle Sequencia
	cTexto += CRLF

	fGravaReg(AllTrim(cTexto))

	nSeq += 1
	aTotVal[TOTHEA] += 1 

Return

//Fim de Arquivo

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ fGerTRE  ºAutor  ³Jose Carlos Gouveia º Data ³  04/02/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera Registro Unidade de Entrega Vale Refeicao Eletronico  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP7                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß */

Static Function fGerTRE()

	cTexto := "T" 																// 001 - 001 -> Tipo do Produto
	cTexto += "R"																// 005 - 005 -> ProdutoTipo Registro
	cTexto += "02"																// 003 - 004 -> Fixo 02
	cTexto += "2"																// 005 - 005 -> 2
	cTexto += fGerStr(26,aInfoE[12])											// 006 - 031 -> Nome do Depto
	cTexto += fGerStr(4,"R")                        							// 032 - 035 -> Tipo de Logradouro
	cTexto += fGerStr(30,aInfoE[4])												// 036 - 065 -> Nome do Logradouro
	cTexto += fGerZero(6,"0")                									// 066 - 071 -> Numero do Logradouro
	cTexto += Space(10)                             							// 072 - 081 -> Complemento do Logradouro
	cTexto += fGerStr(25,aInfoE[7])    											// 082 - 106 -> Municipio
	cTexto += fGerStr(15,aInfoE[6])  											// 107 - 121 -> Bairro
	cTexto += Subst(aInfoE[9],1,5)         										// 122 - 126 -> CEP
	cTexto += aInfoE[8]															// 127 - 128 -> Estado
	cTexto += fGerStr(20,cUser)           										// 129 - 148 -> Responsavel
	cTexto += Subst(aInfoE[9],5,3)         										// 149 - 151 -> Complemento CEP
	cTexto += Space(7)                              							// 152 - 158 -> Reservado
	cTexto += "0"                                   							// 159 - 164 -> Sequencial

	If RecLock("TMPT",.T.)
		TMPT->TIPREG	:=	"TRE"
		TMPT->CODIGO	:= aInfoE[11]
		TMPT->TEXTO		:= cTexto
		MSunLock()
	Endif  

	aTotVal[TOTDET] += 1

Return

//Fim da Rotina

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³  fGerTRF ºAutor  ³Jose Carlos Gouveia º Data ³  04/02/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera Registro de Funcionarios do Vale Refeicao Eletronico  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP7                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß */

Static Function fGerTRF()

	//Pesquisa Setor
	CTT->(dbSeek(xFilial("CTT") + SRA->RA_CC))

	cTexto := "T"	                          	        			// 001 - 001 -> Fixo T         
	cTexto += "R"                                      			// 002 - 002 -> R Refeicao    
	cTexto += "02"                                   				// 003 - 004 -> Fixo 02
	cTexto += "3"  				                    			// 005 - 005 -> Fixo 3
	cTexto += fGerStr(26,SRA->RA_CC)		              			// 006 - 031 -> Codigo do Departamento
	cTexto += fGerZero(12,SRA->RA_FILIAL + SRA->RA_MAT)			// 032 - 043 -> Codigo do Funcionario
	cTexto += GravaData(SRA->RA_NASC,.F.,5)            			// 044 - 051 -> Data de Nascimento
	cTexto += Space(18)					            			// 052 - 069 -> Branco
	cTexto += fGerStr(26,aInfoE[12])								// 070 - 095 -> Nome da Unidade
	cTexto += "00101"                                  			// 096 - 100 -> Preencher 00101
	cTexto += StrZero(Round(nTotBen * 100,2),9)        			// 101 - 109 -> Valor Total do Beneficio
	cTexto += "R"                                      			// 110 - 110 -> Produto
	cTexto += "E"   	                                			// 111 - 111 -> Eletronico
	cTexto += fGerStr(30,SRA->RA_NOME)                 			// 112 - 141 -> Nome do Funcionario
	cTexto += Space(17)                                			// 142 - 158 -> Brancos
	cTexto += "0"                                      			// 159 - 164 -> Sequencial

	If RecLock("TMPT",.T.)
		TMPT->TIPREG	:=	"TRF"
		TMPT->TEXTO		:= cTexto
		MSunLock()
	Endif  

	aTotVal[TOTFUE] += 1
	aTotVal[TOTTVR] += nTotBen                    
	aTotVal[TOTDET] += 1
Return

//Fim da Rotina

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ fGerTTRE ºAutor  ³Jose Carlos Gouveia º Data ³  04/02/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera Registro Trailes do Vale Refeicao Eletronico          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP7                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß */

Static Function fGerTTRE() 

	cTexto := "T"                     	   				// 001 - 001 -> Tipo do Registro 
	cTexto += "R"										// 002 - 002 -> Refeicao
	cTexto += "02"										// 003 - 003 -> 02 
	cTexto += "9"										// 005 - 005 -> Tipo de Registro
	cTexto += StrZero(aTotVal[TOTFUE],8)       			// 006 - 013 -> Total de Funcionarios
	cTexto += StrZero(Round(aTotVal[TOTTVR] * 100,2),14)// 014 - 027 -> Valor Total
	cTexto += Space(131)                   				// 028 - 158 -> Brancos 
	cTexto += StrZero(nSeq,6)                   		// 159 - 164 -> Controle Sequencia
	cTexto += CRLF

	fGravaReg(AllTrim(cTexto))
	aTotVal[TOTTRA]	+= 1

Return

//Fim da Rotina

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ fGerHTAE ºAutor  ³Jose Carlos Gouveia º Data ³  04/02/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera Registro Header Vale Alimentacao Eletronico           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP7                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß */

Static Function fGerHTAE()

	cTexto := "T"         	                            // 001 - 001 -> Fixo T
	cTexto += "A"                                       // 002 - 002 -> Alimentacao
	cTexto += "02"										// 003 - 004 -> Fixo 02
	cTexto += "0"										// 005 - 005 -> 0
	cTexto += "A"										// 006 - 006 -> Alimentaçao
	cTexto += cCodClie				                   	// 007 - 016 -> Codigo Cliente Ticket
	cTexto += fGerStr(30,SM0->M0_NOMECOM)             	// 017 - 046 -> Nome da Empresa
	cTexto += GravaData(dDataBase,.F.,8)               	// 047 - 054 -> Data de Geracao
	cTexto += GravaData(dVrEntr,.F.,8)                 	// 055 - 062 -> Data de Entrega
	cTexto += "C"                                      	// 063 - 063 -> C
	cTexto += Space(16)                                	// 064 - 079 -> Brancos
	cTexto += StrZero(Month(dDataBase),2)              	// 080 - 081 -> Mes de Referencia
	cTexto += Space(19)                                	// 082 - 100 -> Brancos
	cTexto += "04"		                                // 101 - 102 -> 04
	cTexto += "33"		          		                // 103 - 104 -> Tipo de Cartao - (TRE
	cTexto += Space(48)									// 105 - 152 -> Brancos
	cTexto += fGerStr(06,"SUP")							// 153 - 158 -> Preencher com "SUP"
	cTexto += StrZero(nSeq,6)                           // 159 - 164 -> Controle Sequencia
	cTexto += CRLF

	fGravaReg(AllTrim(cTexto))

	nSeq += 1
	aTotVal[TOTHEA] += 1

Return

//Fim de Arquivo

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ fGerTAE  ºAutor  ³Jose Carlos Gouveia º Data ³  04/02/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera Registro Unidade Entrega Vale Alimentacao Eletronico  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP7                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß */

Static Function fGerTAE()

	cTexto := "T" 																// 001 - 001 -> Tipo do Produto
	cTexto += "A"																// 005 - 005 -> Produto Alimentacao
	cTexto += "02"																// 003 - 004 -> Fixo 02
	cTexto += "2"																// 005 - 005 -> 2
	cTexto += fGerStr(26,aInfoE[12])											// 006 - 031 -> Nome do Depto
	cTexto += fGerStr(4,"R")                        							// 032 - 035 -> Tipo de Logradouro
	cTexto += fGerStr(30,aInfoE[4])												// 036 - 065 -> Nome do Logradouro
	cTexto += fGerZero(6,"0")                									// 066 - 071 -> Numero do Logradouro
	cTexto += Space(10)                             							// 072 - 081 -> Complemento do Logradouro
	cTexto += fGerStr(25,aInfoE[7])												// 082 - 106 -> Municipio
	cTexto += fGerStr(15,aInfoE[6])  											// 107 - 121 -> Bairro
	cTexto += Subst(aInfoE[9],1,5)         										// 122 - 126 -> CEP
	cTexto += aInfoE[8]															// 127 - 128 -> Estado
	cTexto += fGerStr(20," ")           										// 129 - 148 -> Responsavel
	cTexto += Subst(aInfoE[9],5,3)         										// 149 - 151 -> Complemento CEP
	cTexto += Space(7)                              							// 152 - 158 -> Reservado
	cTexto += "0"                                   							// 159 - 164 -> Sequencial

	If RecLock("TMPT",.T.)
		TMPT->TIPREG	:=	"TAE"
		TMPT->CODIGO	:= aInfoE[11]
		TMPT->TEXTO		:= cTexto
		MSunLock()
	Endif  

	aTotVal[TOTDET] += 1

Return



//Fim da Rotina

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³  fGerTAF ºAutor  ³Jose Carlos Gouveia º Data ³  04/02/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera Registro de Funcionarios Vale Alimentacao Eletronico  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP7                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß */

Static Function fGerTAF()

	//Pesquisa Setor
	CTT->(dbSeek(xFilial("CTT") + SRA->RA_CC))

	cTexto := "T"	                          	        	// 001 - 001 -> Fixo T         
	cTexto += "A"                                      	// 002 - 002 -> A Alimentacao    
	cTexto += "02"                                     	// 003 - 004 -> Fixo 02
	cTexto += "3"  				                    	// 005 - 005 -> Fixo 3
	cTexto += fGerStr(26,SRA->RA_CC)              			// 006 - 031 -> Codigo do Departamento
	cTexto += fGerZero(12,SRA->RA_FILIAL + SRA->RA_MAT)	// 032 - 043 -> Codigo do Funcionario
	cTexto += GravaData(SRA->RA_NASC,.F.,5)            	// 044 - 051 -> Data de Nascimento
	cTexto += Space(18)					            	// 052 - 069 -> Branco
	cTexto += fGerStr(26,CTT->CTT_DESC01)					// 070 - 095 -> Nome do Depto
	cTexto += "00101"                                  	// 096 - 100 -> Preencher 00101
	cTexto += StrZero(Round(nTotBen * 100,2),9)        	// 101 - 109 -> Valor Total do Beneficio
	cTexto += "A"                                      	// 110 - 110 -> Produto
	cTexto += "E"   	                                	// 111 - 111 -> Eletronico
	cTexto += fGerStr(30,SRA->RA_NOME)                 	// 112 - 141 -> Nome do Funcionario
	cTexto += Space(17)                                	// 142 - 158 -> Brancos
	cTexto += "0"                                      	// 159 - 164 -> Sequencial

	If RecLock("TMPT",.T.)
		TMPT->TIPREG	:=	"TAF"
		TMPT->TEXTO		:= cTexto
		MSunLock()
	Endif  

	aTotVal[TOTFUA] += 1
	aTotVal[TOTTVA] += nTotBen                    
	aTotVal[TOTDET] += 1

Return

//Fim da Rotina

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ fGerTTAE ºAutor  ³Jose Carlos Gouveia º Data ³  04/02/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera Registro Trailes do Vale Alimentacao Eletronico       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP7                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß */

Static Function fGerTTAE() 

	cTexto := "T"                     	   		// 001 - 001 -> Tipo do Registro 
	cTexto += "A"								// 002 - 002 -> Alimentacao
	cTexto += "02"								// 003 - 003 -> 02 
	cTexto += "9"								// 005 - 005 -> Tipo de Registro
	cTexto += StrZero(aTotVal[TOTFUA],8)    	// 006 - 013 -> Total de Funcionarios
	cTexto += StrZero(aTotVal[TOTTVA] * 100,14) // 014 - 027 -> Valor Total dos Funcionarios
	cTexto += Space(131)                   		// 028 - 158 -> Brancos 
	cTexto += StrZero(nSeq,6)                   // 159 - 164 -> Controle Sequencia
	cTexto += CRLF

	fGravaReg(AllTrim(cTexto))
	aTotVal[TOTTRA]	+= 1

Return

//Fim da Rotina

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fGerLSUP9 ºAutor  ³Jose Carlos Gouveia º Data ³  10/11/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera Registro LSUP9                                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP7                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß */

Static Function fGerLSUP9() 

	cTexto := "LSUP9"                     // 001 - 005 -> Tipo do Registro 
	cTexto += StrZero(aTotVal[TOTHEA],8)  // 006 - 013 -> Total Header´s
	cTexto += StrZero(aTotVal[TOTTRA],8)  // 014 - 021 -> Total Trailler´s
	cTexto += StrZero(aTotVal[TOTDET],8)  // 022 - 029 -> Total Registros
	cTexto += Space(277)                  // 030 - 306 -> Brancos 
	cTexto += CRLF

	fGravaReg(AllTrim(cTexto))

Return

//Fim da Rotina

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³  fGerStr ºAutor  ³Jose Carlos Gouveia º Data ³  10/11/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Acrescenta espacos a direita                               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP7                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß */

Static Function fGerStr(nNum,cVaria)

	Local cVar

	cVar := AllTrim(cVaria) + Space(nNum)

	cVar := Subst(cVar,1,nNum)

Return(cVar)	

//Fim da Rotina

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fGerZero  ºAutor  ³Jose Carlos Gouveia º Data ³  10/11/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Acrescenta zeros a Esquerda                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP7                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß */

Static Function fGerZero(nNum,cVaria)

	Local cVar

	cVar := Replic("0",nNum) + AllTrim(cVaria) 

	cVar := Right(cVar,nNum)

Return(cVar)	

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fCriaDBF  ºAutor  ³Jose Carlos Gouveia º Data ³  10/11/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Cria DBF                                                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP7                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß */

Static Function fCriaDBF()

	Local aCamp 	:= {}
	Local cInd		:= ""

	//Vale Transporte
	//Arquivo Unidade de Entrega/Departamento VT
	aadd(aCamp,{'TIPREG','C',5,0})
	aadd(aCamp,{'CODIGO','C',8,0})
	aadd(aCamp,{'TEXTO','C',310,0})

	//Nome e Criacao do Arquivo
	cArq := Criatrab(aCamp,.t.)

	//Abertura do Arquivo
	dbUseArea(.t.,,cArq,'TMPT')
	dbSelectArea('TMPT')

	//Cria Indice Temporario
	//Nome do Indice
	cArqInd := CriaTrab(Nil,.F.)

	cInd := "TIPREG + CODIGO"
	//Criacao do Indice
	IndRegua("TMPT",cArqInd,cInd,,,"Selecionando Registros")

Return

//Fim da Rotina

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ fGravaReg    ³ Autor ³Jose Carlos Gouveia³ Data ³ 06.11.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Grava Registros no Arquivo Texto                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ fGravaReg()                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ GeraKit                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function fGravaReg(cLin)

	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		If !MsgYesNo('Ocorreu um erro na grava‡„o do arquivo '+AllTrim(cNomeArq)+'.   Continua?','Aten‡„o!')
			lContinua := .F.
			Return
		Endif
	Endif            

Return

//Fim da Rotina

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ FGETPATH ³ Autor ³ Kleber Dias Gomes     ³ Data ³ 26/06/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Permite que o usuario decida onde sera criado o arquivo    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ CONVERTE													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
//Static Function fGetPath()
//Local cRet  :=Alltrim(ReadVar())
//Local cPath  := cNomeArq

//oWnd := GetWndDefault()

//While .T.
//	If Empty(cPath)
//		cPath := cGetFile( "Arquivos Texto | *.TXT ",OemToAnsi("Selecione Arquivo"))
//	EndIf

//	If Empty(cPath)
//		Return .F.
//	EndIf
//	&cRet := cPath
//	Exit
//EndDo

//If oWnd != Nil
//	GetdRefresh()
//EndIf

//Return .T. 
//Fim da Rotina 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ fLocalInfo   ³ Autor ³ Fernando Joly     ³ Data ³ 15.06.98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Inicializa o Array aInfo com informacoes do Local          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ fCallFunc()                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ GeraKit                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function fLocalInfo(nDef,cLocal)

	aInfoE := {}

	If nEnt == 1 .Or. nEnt == 2
		// Armazena Registro Atual
		nSM0Recno := SM0->(Recno())
		SM0->(dbSeek(cEmpAnt + cLocal,.T.))

		Aadd(aInfoE,SM0->M0_NOME)
		Aadd(aInfoE,SM0->M0_NOMECOM)
		Aadd(aInfoE,SM0->M0_CGC)
		Aadd(aInfoE,SM0->M0_ENDENT)
		Aadd(aInfoE,SM0->M0_COMPENT)
		Aadd(aInfoE,SM0->M0_BAIRENT)
		Aadd(aInfoE,SM0->M0_CIDENT)
		Aadd(aInfoE,SM0->M0_ESTENT)
		Aadd(aInfoE,SM0->M0_CEPENT)
		Aadd(aInfoE,SM0->M0_TEL)
		Aadd(aInfoE,SM0->M0_CODFIL)
		Aadd(aInfoE,SM0->M0_FILIAL)

		// Retorna ao Registro
		SM0->(dbGoto(nSM0Recno))
	Else
		//Pesquisa Setor
		CTT->(dbSeek(xFilial("CTT") + cLocal))

		// Armazena Registro Atual
		nSM0Recno := SM0->(Recno())
		SM0->(dbSeek(cEmpAnt + cFilAnt,.T.))

		Aadd(aInfoE,CTT->CTT_DESC01)
		Aadd(aInfoE," ")
		Aadd(aInfoE,SM0->M0_CGC)
		Aadd(aInfoE,CTT->CTT_ENDER)
		Aadd(aInfoE," ")
		Aadd(aInfoE,CTT->CTT_BAIRRO)
		Aadd(aInfoE,CTT->CTT_MUNIC)
		Aadd(aInfoE,CTT->CTT_ESTADO)
		Aadd(aInfoE,CTT->CTT_CEP)
		Aadd(aInfoE,SM0->M0_TEL)
		Aadd(aInfoE,CTT->CTT_CUSTO)
		Aadd(aInfoE,CTT->CTT_DESC01)

		// Retorna ao Registro
		SM0->(dbGoto(nSM0Recno))

	Endif

Return

// Fim da Rotina

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fChkPerg  ºAutor  ³Jose Carlos Gouveia º Data ³  10/11/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Perguntas do Sistema.                                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP7                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß */
Static Function fChkPerg()

	Local aRegs := {}

	aAdd(aRegs,{cPerg,'01','Data de Referencia      ?','Data de Referencia      ?','Data de Referencia      ?','mv_ch1','D',08,0,0,'G','NaoVazio   ','mv_par01','               ','','','','','             ','','','','','             ','','','','','              ','','','','','               ','','','','   ','','',''})
	aAdd(aRegs,{cPerg,'02','Refeicao                ?','Refeicao                ?','Refeicao                ?','mv_ch2','N',01,0,0,'C','           ','mv_par02','Papel          ','','','','','Eletronico   ','','','','','Nenhum       ','','','','','              ','','','','','               ','','','','   ','','',''})
	aAdd(aRegs,{cPerg,'03','Transporte              ?','Transporte              ?','Transporte              ?','mv_ch3','N',01,0,0,'C','           ','mv_par03','Sim            ','','','','','Nao          ','','','','','             ','','','','','              ','','','','','               ','','','','   ','','',''})
	aAdd(aRegs,{cPerg,'04','Alimentacao Eletronico  ?','Alimentacao Eletronico  ?','Alimentacao Eletronico  ?','mv_ch4','N',01,0,0,'C','           ','mv_par04','Sim            ','','','','','Nao          ','','','','','             ','','','','','              ','','','','','               ','','','','   ','','',''})
	aAdd(aRegs,{cPerg,'05','Filial De               ?','Filial De               ?','Filial De               ?','mv_ch5','C',02,0,0,'G','           ','mv_par05','               ','','','','','             ','','','','','             ','','','','','              ','','','','','               ','','','','SM0','','',''})
	aAdd(aRegs,{cPerg,'06','Filial Ate              ?','Filial Ate              ?','Filial Ate              ?','mv_ch6','C',02,0,0,'G','NaoVazio   ','mv_par06','               ','','','','','             ','','','','','             ','','','','','              ','','','','','               ','','','','SM0','','',''})
	aAdd(aRegs,{cPerg,'07','Matricula De            ?','Matricula De            ?','Matricula De            ?','mv_ch7','C',06,0,0,'G','           ','mv_par07','               ','','','','','             ','','','','','             ','','','','','              ','','','','','               ','','','','SRA','','',''})
	aAdd(aRegs,{cPerg,'08','Matricula Ate           ?','Matricula Ate           ?','Matricula Ate           ?','mv_ch8','C',06,0,0,'G','NaoVazio   ','mv_par08','               ','','','','','             ','','','','','             ','','','','','              ','','','','','               ','','','','SRA','','',''})
	aAdd(aRegs,{cPerg,'09','Centro de Custo De      ?','Centro de Custo De      ?','Centro de Custo De      ?','mv_ch9','C',20,0,0,'G','           ','mv_par09','               ','','','','','             ','','','','','             ','','','','','              ','','','','','               ','','','','SI3','','',''})
	aAdd(aRegs,{cPerg,'10','Centro de Custo Ate     ?','Centro de Custo Ate     ?','Centro de Custo Ate     ?','mv_cha','C',20,0,0,'G','NaoVazio   ','mv_par10','               ','','','','','             ','','','','','             ','','','','','              ','','','','','               ','','','','SI3','','',''})
	aAdd(aRegs,{cPerg,'11','Situacoes a Gerar       ?','Situacoes a Gerar       ?','Situacoes a Gerar       ?','mv_chb','C',05,0,0,'G','fSituacao  ','mv_par11','               ','','','','','             ','','','','','             ','','','','','              ','','','','','               ','','','','   ','','',''})
	aAdd(aRegs,{cPerg,'12','Categorias a Gerar      ?','Categorias a Gerar      ?','Categorias a Gerar      ?','mv_chc','C',12,0,0,'G','fCategoria ','mv_par12','               ','','','','','             ','','','','','             ','','','','','              ','','','','','               ','','','','   ','','',''})
	aAdd(aRegs,{cPerg,'13','VT - Utilizacao De      ?','VT - Utilizacao De      ?','VT - Utilizacao De      ?','mv_chd','D',08,0,0,'G','NaoVazio   ','mv_par13','               ','','','','','             ','','','','','             ','','','','','              ','','','','','               ','','','','   ','','',''})
	aAdd(aRegs,{cPerg,'14','VT - Utilizacao Ate     ?','VT - Utilizacao Ate     ?','VT - Utilizacao Ate     ?','mv_che','D',08,0,0,'G','NaoVazio   ','mv_par14','               ','','','','','             ','','','','','             ','','','','','              ','','','','','               ','','','','   ','','',''})
	aAdd(aRegs,{cPerg,'15','VT - Dt Entrega Minima  ?','VT - Dt Entrega Minima  ?','VT - Dt Entrega Minima  ?','mv_chf','D',08,0,0,'G','NaoVazio   ','mv_par15','               ','','','','','             ','','','','','             ','','','','','              ','','','','','               ','','','','   ','','',''})
	aAdd(aRegs,{cPerg,'16','VT - Dt Entrega Maxima  ?','VT - Dt Entrega Maxima  ?','VT - Dt Entrega Maxima  ?','mv_chg','D',08,0,0,'G','NaoVazio   ','mv_par16','               ','','','','','             ','','','','','             ','','','','','              ','','','','','               ','','','','   ','','',''})
	aAdd(aRegs,{cPerg,'17','VR - Data Entrega       ?','VR - Data Entrega       ?','VR - Data Entrega       ?','mv_chh','D',08,0,0,'G','NaoVazio   ','mv_par17','               ','','','','','             ','','','','','             ','','','','','              ','','','','','               ','','','','   ','','',''})
	aAdd(aRegs,{cPerg,'18','VA - Data Entrega       ?','VA - Data Entrega       ?','VA - Data Entrega       ?','mv_chi','D',08,0,0,'G','NaoVazio   ','mv_par18','               ','','','','','             ','','','','','             ','','','','','              ','','','','','               ','','','','   ','','',''})
	aAdd(aRegs,{cPerg,'19','Perc do Kit             ?','Perc do Kit             ?','Perc do Kit             ?','mv_chj','N',06,2,0,'G','NaoVazio   ','mv_par19','               ','','','','','             ','','','','','             ','','','','','              ','','','','','               ','','','','   ','','',''})
	aAdd(aRegs,{cPerg,'20','Valor Ponto de Entrega  ?','Valor Ponto de Entrega  ?','Valor Ponto de Entrega  ?','mv_chk','N',12,2,0,'G','NaoVazio   ','mv_par20','               ','','','','','             ','','','','','             ','','','','','              ','','','','','               ','','','','   ','','',''})
	aAdd(aRegs,{cPerg,'21','Codigo de Cliente       ?','Codigo de Cliente       ?','Codigo de Cliente       ?','mv_chl','C',10,0,0,'G','NaoVazio   ','mv_par21','               ','','','','','             ','','','','','             ','','','','','              ','','','','','               ','','','','   ','','',''})
	aAdd(aRegs,{cPerg,'22','Cod. Cliente Eletronico ?','Cod. Cliente Eletronico ?','Cod. Cliente Eletronico ?','mv_chm','C',10,0,0,'G','NaoVazio   ','mv_par22','               ','','','','','             ','','','','','             ','','','','','              ','','','','','               ','','','','   ','','',''})
	aAdd(aRegs,{cPerg,'23','Usuário do Sistema      ?','Usuário do Sistema      ?','Usuário do Sistema      ?','mv_chn','C',08,0,0,'G','NaoVazio   ','mv_par23','               ','','','','','             ','','','','','             ','','','','','              ','','','','','               ','','','','   ','','',''}) 
	aAdd(aRegs,{cPerg,'24','Nome do Arquivo         ?','Nome do Arquivo         ?','Nome do Arquivo         ?','mv_cho','C',25,0,0,'G','NaoVazio   ','mv_par24','               ','','','','','             ','','','','','             ','','','','','              ','','','','','               ','','','','   ','','',''})
	aAdd(aRegs,{cPerg,'25','Entregar                ?','Entregar                ?','Entregar                ?','mv_chp','N',01,0,0,'C','           ','mv_par25','Unica Filial   ','','','','','Na Filial    ','','','','','Centro Custo ','','','','','              ','','','','','               ','','','','   ','','',''})
	aAdd(aRegs,{cPerg,'26','Filial de Entrega       ?','Filial de Entrega       ?','Filial de Entrega       ?','mv_chq','C',02,0,0,'G','           ','mv_par26','               ','','','','','             ','','','','','             ','','','','','              ','','','','','               ','','','','SM0','','',''})

	ValidPerg(aRegs,cPerg,.F.)

Return