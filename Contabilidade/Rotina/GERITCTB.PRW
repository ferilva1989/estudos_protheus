#Include "protheus.ch"
#Include "tbiconn.ch"
#Include "rwmake.ch"
#Include "tbiconn.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MA020TDOK  ºAutor  ³LUCIANO OLIVEIRA    º Data ³  26/11/17  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ P.E Cadastro de Fornecedor - Efetuar cadastro de           º±±
±±º          ³ Item Contabil Automatico.                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BSL                                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º             ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Programador ³ Data       ³ Motivo                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAlceu Pereira³ 15/02/2019 ³ Alterado para considerar sempre como sendo º±±
±±º             ³            ³ Inclusao, pois a rotina ira limpar os      º±±
±±º             ³            ³ registros e incluir novamente  #1          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function MA020TDOK()     // FORNECEDOR

	Local aArea 	:= GetArea()
	Local lRet 		:= .T. 
	Local aAutoCTD 	:= {}
	Local aFilCTD   := {}
	Local nX		:= 0
//	Private Inclui
	/*                            
	if ALTERA
	// FONTANELLI
	cQuery  := " UPDATE " + RetSqlName("SE2")
	cQuery  += "   SET E2_FORMPAG = '"+ M->A2_FORMPAG +"'"
	cQuery	+= " WHERE E2_FORNECE = '"+ M->A2_COD +"'"
	cQuery	+= "   AND E2_LOJA = '"+M->A2_LOJA+"'"
	cQuery	+= "   AND E2_SALDO > 0 " 
	cQuery	+= "   AND D_E_L_E_T_  = '' "
	TcSqlExec(cQuery)

	INCLUI := .T. //#1 

	endif
	*/	
	IF Inclui 

		_cChave := "F"+M->(A2_COD+A2_LOJA)
		_cNome  := Alltrim(M->A2_NOME)

		lExclSA2 := !Empty(xFilial("SA2")) 
		lExclCTD := !Empty(xFilial("CTD"))

		If lExclSA2
			AADD(aFilCTD,{xFilial("CTD")})
		Else
			If lExclCTD        
				Do While !SM0->(Eof())
					If aScan(aFilCTD,{|x| x[1] == LEFT(SM0->M0_CODFIL,2)}) == 0
						AADD(aFilCTD,{LEFT(SM0->M0_CODFIL,2)})	
					Endif
					SM0->(dbSkip())
				EndDo   
			Else          
				AADD(aFilCTD,{xFilial("CTD")})
			Endif		
		Endif

		For nX := 1 to Len(aFilCTD) 
			DbSelectArea("CTD")
			DbSetOrder(1)                      
			//If !DbSeek(aFilCTD[nX][1]+_cChave,.F.)  //#1  
			aAutoCTD := {}
			/*
			aAutoCTD := {	{"CTD_FILIAL"		,aFilCTD[nX][1]		, NIL},;
			{"CTD_ITEM"			,_cChave			, NIL},;
			{"CTD_CLASSE"		,"2"				, NIL},;
			{"CTD_DESC01"		,_cNome				, NIL},;
			{"CTD_DTEXIS"		,CTOD("01/01/80")	, NIL},;
			{"CTD_CLOBRG"		,"2"				, NIL},;
			{"CTD_ACCLVL"		,"1"				, NIL}}
			*/                                                                                  
			AADD(aAutoCTD,{aFilCTD[nX][1],_cChave,"2",_cNome,CTOD("01/01/80"),"2","1"})

			_lGrvCTD := u_ITCTB001(aAutoCTD)

			If _lGrvCTD .and. M->A2_ITCTB <> _cChave  
				M->A2_ITCTB := _cChave		
			Endif

			//Endif //#1  
		Next nX	             

	EndIF

	RestArea(aArea)

Return lRet    


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MA030TOK   ºAutor  ³LUCIANO OLIVEIRA    º Data ³  26/11/17  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ P.E Cadastro de Cliente - Efetuar cadastro de              º±±
±±º          ³ Item Contabil Automatico.                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BSL                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/


User Function MA030TOK()  // CLIENTE

	Local aArea 	:= GetArea()
	Local lRet 		:= .T. 
	Local aAutoCTD 	:= {}
	Local aFilCTD	:= {}
	Local nX		:= 0


	//IF INCLUI  //#1

	_cChave := "C"+M->(A1_COD+A1_LOJA)
	_cNome  := Alltrim(M->A1_NOME)

	lExclSA1 := !Empty(xFilial("SA1")) 
	lExclCTD := !Empty(xFilial("CTD"))

	If lExclSA1
		AADD(aFilCTD,{xFilial("CTD")})
	Else
		If lExclCTD        
			Do While !SM0->(Eof())
				If aScan(aFilCTD,{|x| x[1] == LEFT(SM0->M0_CODFIL,2)}) == 0
					AADD(aFilCTD,{LEFT(SM0->M0_CODFIL,2)})	
				Endif
				SM0->(dbSkip())
			EndDo
		Else          
			AADD(aFilCTD,{xFilial("CTD")})
		Endif		
	Endif  

	For nX := 1 to Len(aFilCTD) 
		DbSelectArea("CTD")
		DbSetOrder(1)
		//If !DbSeek(aFilCTD[nX][1]+_cChave,.F.) //#1 
		aAutoCTD := {}
		/*
		aAutoCTD := {	{"CTD_FILIAL"		,aFilCTD[nX][1]		, NIL},;
		{"CTD_ITEM"			,_cChave			, NIL},;
		{"CTD_CLASSE"		,"2"				, NIL},;
		{"CTD_DESC01"		,_cNome				, NIL},;
		{"CTD_DTEXIS"		,CTOD("01/01/80")	, NIL},;
		{"CTD_CLOBRG"		,"2"				, NIL},;
		{"CTD_ACCLVL"		,"1"				, NIL}}
		*/                                                                                  
		AADD(aAutoCTD,{aFilCTD[nX][1],_cChave,"2",_cNome,CTOD("01/01/80"),"2","1"})
		_lGrvCTD := u_ITCTB001(aAutoCTD)

		If _lGrvCTD .and. M->A1_ITCTB <> _cChave
			M->A1_ITCTB := _cChave		
		Endif

		//Endif  //#1 
	Next nX
	//EndIF //#1 

	RestArea(aArea)

return lRet

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GERITCTB  ºAutor  ³LUCIANO OLIVEIRA    º Data ³  26/11/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Cadastro de Item Contabil Automatico.                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BSL                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function GERITCTB()

	// Gera Itens contabeis de acordo com cadastro de cliente e Fornecedor
	If ! MsgYesno("Confirma Geracao Item Contabil ? ","Item Contabil")
		Return
	Endif

	MsAguarde({|| GeraArq()},OemtoAnsi("Gerando Item Contabil.. Aguarde"))

Return

Static Function GeraArq(nX)

	Local aAutoCTD := {}
	Local aFilCTD  := {}

	DbSelectArea("SA1")
	DbGoTop()
	While ! Eof()

		_cChave := "C"+SA1->(A1_COD+A1_LOJA)
		_cNome  := Alltrim(SA1->A1_NOME)

		MsProcTxt("Cliente "+_cChave)

		aFilCTD	:= {}

		lExclSA1 := !Empty(xFilial("SA1")) 
		lExclCTD := !Empty(xFilial("CTD"))

		If lExclSA1
			AADD(aFilCTD,{xFilial("CTD")})
		Else
			If lExclCTD        
				Do While !SM0->(Eof())
					If aScan(aFilCTD,{|x| x[1] == LEFT(SM0->M0_CODFIL,2)}) == 0
						AADD(aFilCTD,{LEFT(SM0->M0_CODFIL,2)})	
					Endif
					SM0->(dbSkip())
				EndDo
			Else          
				AADD(aFilCTD,{xFilial("CTD")})
			Endif		
		Endif

		For nX := 1 to Len(aFilCTD)
			DbSelectArea("CTD")
			DbSetOrder(1)
			//If !DbSeek(aFilCTD[nX][1]+_cChave,.F.) //#1 
			aAutoCTD := {}
			/*
			aAutoCTD := {	{"CTD_FILIAL"		,aFilCTD[nX][1]		, NIL},;
			{"CTD_ITEM"			,_cChave			, NIL},;
			{"CTD_CLASSE"		,"2"				, NIL},;
			{"CTD_DESC01"		,_cNome				, NIL},;
			{"CTD_DTEXIS"		,CTOD("01/01/80")	, NIL},;
			{"CTD_CLOBRG"		,"2"				, NIL},;
			{"CTD_ACCLVL"		,"1"				, NIL}}
			*/                                                                                  
			AADD(aAutoCTD,{aFilCTD[nX][1],_cChave,"2",_cNome,CTOD("01/01/80"),"2","1"})
			_lGrvCTD := u_ITCTB001(aAutoCTD)

			If _lGrvCTD .and. SA1->A1_ITCTB <> _cChave
				Reclock("SA1",.F.)
				SA1->A1_ITCTB := _cChave
				MSUnlock()		
			Endif

			//Endif //#1 
		Next nX
		DbSelectArea("SA1")
		DbSkip()
	Enddo

	DbSelectArea("SA2")
	DbGoTop()
	While ! Eof()
		_cChave := "F"+SA2->(A2_COD+A2_LOJA)
		_cNome  := Alltrim(SA2->A2_NOME)

		MsProcTxt("Fornecedor "+_cChave)

		aFilCTD	:= {}

		lExclSA2 := !Empty(xFilial("SA2")) 
		lExclCTD := !Empty(xFilial("CTD"))

		If lExclSA2
			AADD(aFilCTD,{xFilial("CTD")})
		Else
			If lExclCTD        
				Do While !SM0->(Eof())
					If aScan(aFilCTD,{|x| x[1] == LEFT(SM0->M0_CODFIL,2)}) == 0
						AADD(aFilCTD,{LEFT(SM0->M0_CODFIL,2)})	
					Endif
					SM0->(dbSkip())
				EndDo   

			Else          
				AADD(aFilCTD,{xFilial("CTD")})
			Endif		
		Endif

		For nX := 1 to Len(aFilCTD) 
			DbSelectArea("CTD")
			DbSetOrder(1)
			//If !DbSeek(aFilCTD[nX][1]+_cChave,.F.) //#1 
			aAutoCTD := {}
			/*
			aAutoCTD := {	{"CTD_FILIAL"		,aFilCTD[nX][1]		, NIL},;
			{"CTD_ITEM"			,_cChave			, NIL},;
			{"CTD_CLASSE"		,"2"				, NIL},;
			{"CTD_DESC01"		,_cNome				, NIL},;
			{"CTD_DTEXIS"		,CTOD("01/01/80")	, NIL},;
			{"CTD_CLOBRG"		,"2"				, NIL},;
			{"CTD_ACCLVL"		,"1"				, NIL}}
			*/                                                                                  
			AADD(aAutoCTD,{aFilCTD[nX][1],_cChave,"2",_cNome,CTOD("01/01/80"),"2","1"})
			_lGrvCTD := u_ITCTB001(aAutoCTD)		

			If _lGrvCTD .and. SA2->A2_ITCTB <> _cChave
				Reclock("SA2",.F.)
				SA2->A2_ITCTB := _cChave
				MSUnlock()				
			Endif

			//Endif //#1 
		Next nX
		DbSelectArea("SA2")
		DbSkip()
	Enddo

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GERITCTB  ºAutor  ³LUCIANO OLIVEIRA    º Data ³  27/11/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Cadastro de Item Contabil Automatico.                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BSL                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function ITCTB001(aDados)

	Local _lGrvCTD := .T. 
	Local cQuery   := ""
	Local _cFil    := aDados[1][1]
	Local _cItem   := aDados[1][2]
	Local _cClass  := aDados[1][3]
	Local _cDesc   := aDados[1][4] 
	Local _dDtEx   := '19800101''
	Local _cClObr  := aDados[1][6]
	Local _cClVl   := aDados[1][7]
	Local _cBlo    := "2"

	//#1  
	cQuery  := " DELETE FROM " + RetSqlName("CTD")+" "     
	cQuery  += " WHERE " 
	cQuery	+= " CTD_FILIAL	= '"+_cFil+"'"
	cQuery	+= " AND CTD_ITEM 	= '"+_cItem+"'"
	cQuery	+= " AND CTD_CLASSE = '"+_cClass+"'"
	cQuery	+= " AND CTD_DESC01 = '"+_cDesc+"'"
	cQuery	+= " AND CTD_DTEXIS = '"+_dDtEx+"'"
	cQuery	+= " AND CTD_CLOBRG = '"+_cCLObr+"'"
	cQuery	+= " AND CTD_ACCLVL	= '"+_cClVl+"'"
	cQuery	+= " AND CTD_BLOQ   = '"+_cBlo+"'"
	TcSqlExec(cQuery)  ////#1 

	DbSelectArea("CTD")
	DbSetOrder(1)
	If !DbSeek(aDados[1][1]+aDados[1][2],.T.)
		RecLock("CTD",.T.)        
		CTD->CTD_FILIAL	:= aDados[1][1]
		CTD->CTD_ITEM 	:= aDados[1][2]
		CTD->CTD_CLASSE	:= aDados[1][3]
		CTD->CTD_DESC01 := aDados[1][4]
		CTD->CTD_DTEXIS := aDados[1][5]
		CTD->CTD_CLOBRG := aDados[1][6]
		CTD->CTD_ACCLVL	:= aDados[1][7]
		CTD->CTD_BLOQ   := "2"
		MsUnlock()
	endif

Return _lGrvCTD