#INCLUDE "PROTHEUS.CH"
#INCLUDE "REPORT.CH" 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa     ³ ORGR060  ³ Autor ³ Tania Bronzeri        ³ Data ³04/12/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o    ³ Relacao de Postos x Ocupantes            					 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso          ³ SigaOrg - Arquitetura Organizacional                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador  ³ Data	 ³ BOPS ³  Motivo da Alteracao 					     ³±±  
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±± 
±±³Eduardo Ju   ³21/05/07³126481³Retirada do Ajuste SX1			             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador  ³ Data	 ³ FNC  ³  Motivo da Alteracao 					     ³±±  
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±± 
±±³Allyson M.   ³02/02/10³30752/³Ajuste p/ que o filtro respeite a filial na ³±±
±±³             ³--------³  2009³impressao dos ocupantes.	           		 ³±±
±±³Allyson M.   ³02/02/10³30880/³Ajuste no tamanho da celula RCL_POSTO para  ³±±
±±³             ³--------³  2009³receber o tamanho do campo no SX3.    		 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±± 
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function BSLORGR060()

	Local oReport   
	Local aArea 		:= GetArea()
	Private cAliasQry	:= "RCL"
	Private cAliasRCX	:= "RCX"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica as perguntas selecionadas                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	pergunte("ORG60R",.F.) 

	oReport := ReportDef()
	oReport:PrintDialog()

	RestArea( aArea )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ ReportDef  ³ Autor ³ Tania Bronzeri        ³ Data ³04/12/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Relatorio de Postos x Ocupantes                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ORGR060                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ ORGR060 - Generico                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function ReportDef()
	Local oReport 
	Local oSection1 
	Local oSection2
	Local oSection3
	Local cDesc1	:= "Relatorio de Postos x Ocupantes Ser impresso de acordo com os parametros solicitados pelo usu rio."
	//"Relatorio de Postos x Ocupantes" ### "Ser  impresso de acordo com os parametros solicitados pelo usu rio."
	Private aOrd    := {OemToAnsi("Departamento / Posto")}	
	//"Departamento / Posto"
	Private cTitulo	:= OemToAnsi("Relatorio de Postos x Ocupantes")	//"Relatorio de Postos x Ocupantes"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Criacao dos componentes de impressao                                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DEFINE REPORT oReport NAME "ORGR060" TITLE cTitulo PARAMETER "ORG60R" ACTION {|oReport| ORG60Imp(oReport)} DESCRIPTION OemtoAnsi("Emite relacao de Postos com seus Ocupantes atuais e anteriores.")	//"Emite relacao de Postos com seus Ocupantes atuais e anteriores."

	DEFINE SECTION oSection1 OF oReport TITLE OemToAnsi("Departamento") TABLES "RCL", "SQB" ORDERS aOrd	//"Departamento"

	DEFINE CELL NAME "RCL_FILIAL"  	OF oSection1 ALIAS "RCL"
	DEFINE CELL NAME "RCL_DEPTO"  	OF oSection1 ALIAS "RCL" 
	DEFINE CELL NAME "QB_DESCRIC" 	OF oSection1 ALIAS "SQB" 

	TRPosition():New(oSection1,"SQB",1,{|| RhFilial("SQB",(cAliasQry)->RCL_FILIAL)+(cAliasQry)->RCL_DEPTO})

	oSection1:SetHeaderBreak(.T.)                                                                    
	oSection1:SetLineStyle()          

	DEFINE SECTION oSection2 OF oSection1 TITLE OemToAnsi("Postos") TABLES "RCL", "SQ3", "SRJ" ORDERS aOrd	//"Postos"

	DEFINE CELL NAME "RCL_POSTO"	OF oSection2 ALIAS "RCL" TITLE OemToAnsi("Postos") SIZE TamSx3("RCL_POSTO")[1]+2	//Posto
	DEFINE CELL NAME "RCL_CARGO"	OF oSection2 ALIAS "RCL" TITLE OemToAnsi("Cargo") SIZE 10	//Cargo
	DEFINE CELL NAME "Q3_DESCSUM"	OF oSection2 ALIAS "SQ3"
	DEFINE CELL NAME "RCL_FUNCAO"	OF oSection2 ALIAS "RCL" TITLE OemToAnsi("Funcao") SIZE 10	//Funcao
	DEFINE CELL NAME "RJ_DESC"		OF oSection2 ALIAS "SRJ"
	DEFINE CELL NAME "RCL_SALAR"	OF oSection2 ALIAS "RCL"
	DEFINE CELL NAME "RCL_BENEF"	OF oSection2 ALIAS "RCL"
	DEFINE CELL NAME "RCL_ENCARG"	OF oSection2 ALIAS "RCL"

	If cPaisLoc == "BRA"
		DEFINE CELL NAME "RCL_FGTS"		OF oSection2 ALIAS "RCL"
	EndIf

	TRPosition():New(oSection2,"SQ3",1,{|| RhFilial("SQ3",(cAliasQry)->RCL_FILIAL)+(cAliasQry)->RCL_CARGO})
	TRPosition():New(oSection2,"SRJ",1,{|| RhFilial("SRJ",(cAliasQry)->RCL_FILIAL)+(cAliasQry)->RCL_FUNCAO})


	DEFINE SECTION oSection3 OF oSection2 TITLE OemToAnsi("Historico") TABLES "RCX", "RD0", "SRA" ORDERS aOrd	//"Historico"

	DEFINE CELL NAME "RCX_DTINI"	OF oSection3 ALIAS "RCX" 
	DEFINE CELL NAME "RCX_DTFIM"	OF oSection3 ALIAS "RCX"               
	DEFINE CELL NAME "FILOCU"  		OF oSection3 TITLE OemToAnsi("Fil. Ocupante") ;
	BLOCK{|| IIF((cAliasQry)->RCX_TIPOCU == "1", (cAliasQry)->RCX_FILFUN, (cAliasQry)->RCX_FILOCU) }
	DEFINE CELL NAME "CODOCU"		OF oSection3 TITLE OemToAnsi("Cod. Ocupante") ;
	BLOCK{|| IIF((cAliasQry)->RCX_TIPOCU == "1", (cAliasQry)->RCX_MATFUN, (cAliasQry)->RCX_CODOCU ) }
	DEFINE CELL NAME "NOMEOCU"		OF oSection3 TITLE OemToAnsi("Nome Ocupante") ; 				//Nome Ocupante
	BLOCK{|| IIF((cAliasQry)->RCX_TIPOCU == "1", (cAliasQry)->RA_NOME, (cAliasQry)->RD0_NOME ) }

	TRPosition():New(oSection3,"RD0",1,{|| RhFilial("RD0",(cAliasRCX)->RCX_FILIAL)+(cAliasRCX)->RCX_CODOCU})

	oSection2:SetLeftMargin(05)
	oSection3:SetLeftMargin(10)

	oReport:SetColSpace(4)		

Return(oReport)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ ORG60Imp   ³ Autor ³ Tania Bronzeri        ³ Data ³04/12/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Relatorio de Postos x Ocupantes                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function ORG60Imp(oReport)

	Local oSection1 := oReport:Section(1)				//Departamentos
	Local oSection2 := oReport:Section(1):Section(1)  	//Postos
	Local oSection3	:= oSection2:Section(1)				//Historico
	Local cFiltro 	:= "" 
	Local cStatus	:= ""
	Local nReg		:= 0

	Private cOrdem	:= ""
	Private cSts	:= 	mv_par04						//Status a Imprimir
	Private lAnalit	:= Iif(mv_par05==1,.T.,.F.)		//Analitico / Sintetico

	If lAnalit
		oSection3:Enable()
	Else
		oSection3:Disable()
	EndIf

	#IFDEF TOP
	cAliasQry := GetNextAlias()
	cAliasRCX := cAliasQry

	//-- Modifica variaveis para a Query 
	cStatus := ""
	For nReg:=1 to Len(cSts)
		cStatus += "'"+Subs(cSts,nReg,1)+"'"
		If ( nReg+1 ) <= Len(cSts)
			cStatus += "," 
		Endif
	Next nReg        
	cStatus := "%" + cStatus + "%"

	//Transforma parametros do tipo Range em expressao ADVPL para ser utilizada no filtro
	MakeSqlExpr("ORG60R")

	BEGIN REPORT QUERY oSection1

		cOrdem  := "%RCL.RCL_FILIAL,RCL.RCL_DEPTO,RCL.RCL_POSTO%"

		BEGINSQL ALIAS cAliasQry
			COLUMN RCL_SALAR AS NUMERIC(12,2)
			COLUMN RCL_BENEF AS NUMERIC(12,2)
			COLUMN RCL_ENCARG AS NUMERIC(12,2)
			COLUMN RCX_DTINI AS DATE
			COLUMN RCX_DTFIM AS DATE

			SELECT 	
			RCL.RCL_FILIAL, 
			RCL.RCL_DEPTO,  
			RCL.RCL_POSTO, 
			RCL.RCL_CARGO,  
			RCL.RCL_FUNCAO, 
			RCL.RCL_SALAR, 
			RCL.RCL_BENEF, 	
			RCL.RCL_ENCARG, 
			RCX.RCX_DTINI,	
			RCX.RCX_DTFIM, 
			RCX.RCX_FILOCU,
			RCX.RCX_FILFUN,
			RCX.RCX_CODOCU, 
			RCX.RCX_TIPOCU, 
			RCX.RCX_POSTO, 
			RCX.RCX_FILIAL,						
			RCX.RCX_MATFUN,
			RD0.RD0_NOME,   
			SRA.RA_NOME
			FROM %table:RCL% RCL 
			LEFT JOIN %table:RCX% RCX
			ON  RCL.RCL_POSTO = RCX.RCX_POSTO 
			AND RCL.RCL_FILIAL = RCX.RCX_FILIAL
			AND RCX.%notDel% 
			LEFT JOIN %table:SRA% SRA
			ON	RCX.RCX_MATFUN = SRA.RA_MAT 
			AND RCX.RCX_FILFUN = SRA.RA_FILIAL 
			AND SRA.%notDel% 
			LEFT JOIN %table:RD0% RD0
			ON	RCX.RCX_CODOCU = RD0.RD0_CODIGO 
			AND RCX.RCX_FILOCU = RD0.RD0_FILIAL 			
			AND RD0.%notDel% 
			WHERE 
			RCL.RCL_STATUS IN (%exp:Upper(cStatus)%) 
			AND RCL.%notDel%
			ORDER BY 
			%exp:cOrdem%
		ENDSQL

		/*
		Prepara relatorio para executar a query gerada pelo Embedded SQL passando como 
		parametro a pergunta ou vetor com perguntas do tipo Range que foram alterados 
		pela funcao MakeSqlExpr para serem adicionados a query
		*/
	END REPORT QUERY oSection1 PARAM mv_par01, mv_par02, mv_par03

	oSection2:SetParentQuery(.T.)
	oSection2:SetParentFilter({|cParam|(cAliasQry)->RCL_FILIAL+(cAliasQry)->RCL_DEPTO == cParam },{||(cAliasQry)->RCL_FILIAL+(cAliasQry)->RCL_DEPTO })

	oSection3:SetParentQuery(.T.)
	oSection3:SetParentFilter( { |cParam| (cAliasQry)->RCX_FILIAL+(cAliasQry)->RCX_POSTO == cParam },{ || (cAliasQry)->RCL_FILIAL+(cAliasQry)->RCL_POSTO })

	#ELSE             

	cAliasQry 	:= "RCL"
	cAliasRCX	:= "RCX"

	//Transforma parametros do tipo Range em expressao ADVPL para ser utilizada no filtro
	MakeAdvplExpr("ORG60R")
	dbSelectArea(cAliasQry)

	(cAliasQry)->(dbSetOrder(1))
	oSection1:SetIdxOrder(1)

	(cAliasQry)->( DbGoTop() )

	//-- Adiciona no filtro o parametro tipo Range
	//-- Filial
	If !Empty(mv_par01)
		cFiltro += mv_par01
	EndIf

	//-- Departamento
	If !Empty(mv_par02)
		cFiltro += Iif(!Empty(cFiltro)," .AND. ","")
		cFiltro += mv_par02
	EndIf

	//-- Posto
	If !Empty(mv_par03)
		cFiltro += Iif(!Empty(cFiltro)," .AND. ","")
		cFiltro += mv_par03
	EndIf

	//-- Status
	If !Empty(cSts)
		cFiltro += Iif(!Empty(cFiltro)," .AND. ","")
		cFiltro += '(RCL->RCL_STATUS  $ "' + cSts  + '")'
	EndIf


	oSection1:SetFilter(cFiltro) 
	oSection2:SetFilter(cFiltro)


	(cAliasQry)->( dbGoTop() )

	oSection2:SetRelation({||RhFilial((cAliasQry),(cAliasQry)->RCL_FILIAL)+(cAliasQry)->RCL_DEPTO},cAliasQry,1,.T.)
	oSection2:SetParentFilter({|cParam|(cAliasQry)->RCL_FILIAL+(cAliasQry)->RCL_DEPTO == cParam },{||(cAliasQry)->RCL_FILIAL+(cAliasQry)->RCL_DEPTO })

	oSection3:SetRelation({||RhFilial(cAliasRCX,(cAliasQry)->RCL_FILIAL)+(cAliasQry)->RCL_POSTO},cAliasRCX,1,.T.)
	oSection3:SetParentFilter( { |cParam| (cAliasRCX)->RCX_POSTO == cParam },{ || (cAliasQry)->RCL_POSTO })

	#ENDIF	


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicio da impressao do fluxo do relatório ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport:SetMeter( (cAliasQry)->(LastRec()) )  

	(cAliasQry)->( dbGoTop() )

	oSection1:Print()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³fOrg60Sta ºAutor  ³Tania Bronzeri      º Data ³ 04/12/2006  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Seleciona Status de Postos para impressao.       			  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³SIGAORG                                             	      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fOrg60Sta()

	Local cTitulo	:=	""
	Local MvParDef	:=	""
	Local l1Elem 	:= .F. 
	Local MvPar		:= ""
	Local oWnd
	Local cTipoAu

	Private aResul	:={}

	oWnd := GetWndDefault()
	MvPar	:=	&(Alltrim(ReadVar()))		 // Carrega Nome da Variavel do Get em Questao
	mvRet	:=	Alltrim(ReadVar())			 // Iguala Nome da Variavel ao Nome variavel de Retorno

	cTitulo := "Imprimir Status de Postos" //"Imprimir Status de Postos"
	aResul  := {"Vago","Ocupado","Congelado","Cancelado"} //"Vago" ### "Ocupado" ### "Congelado" ### "Cancelado"

	MvParDef	:=	"1234"

	f_Opcoes(@MvPar,cTitulo,aResul,MvParDef,12,49,l1Elem,,04)		// Chama funcao f_Opcoes
	&MvRet := mvpar 					   	// Devolve Resultado

Return



