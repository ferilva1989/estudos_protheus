#INCLUDE "Protheus.ch"
#INCLUDE "AVPRINT.CH"
#INCLUDE "FONT.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "TOTVS.CH"

/*
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ BSLSEGVID บAutor  ณ JORGE SATO        บ Dataณ   08/08/2017 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gera็ใo de Arquivo: SEGURO DE VIDA       				  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SIGAGPE - BSL - EM EXCEL                                   บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                     A L T E R A C O E S                               บฑฑ
ฑฑฬออออออออออหออออออออออออออออออหอออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบData      บProgramador       บAlteracoes                               บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ 
*/

User Function BSLSEGVID()


	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Declaracao de Variaveis                                             ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู


	Private cPerg       := "BSLSEGVIDA"
	Private cString := ""
	Private bProcesso	:= { |oSelf| f_Proc(oSelf)}            

	cString := "SRA"


	dbSelectArea("SRA")
	dbSetOrder(1)


	f_Perg(cPerg)
	Pergunte(cperg, .F.)

	tNewProcess():New("BSLSEGVIDA", "SEGURO DE VIDA", bProcesso, "    Esta rotina tem por objetivo gerar planilha Excel referente a SEGURO DE VIDA conforme parโmetros informados pelo usuแrio.", cperg, , , , , .T., .T.)


Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณf_Proc    บ Autor ณ JORGE SATO        บ Dataณ   08/08/2017  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao para processamento dos dados                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function f_Proc()

	Local _Arquivo
	Local cQuery
	Local _cArq  := ""
	Local oExcelApp:= Nil 
	Local cPath  
	Local _struct := {}
	Local cFilNome := ""                                                 

	cQuery := "SELECT FILIAL, MATRICULA, NOME_COMPL, CPF, DT_NASC, CONVERT(NUMERIC (2,0),IDADE) IDADE, CONVERT(NUMERIC (12,2),(REPLACE(VLR_CAPIT, ',', '.'))) VLR_CAPIT, " + CRLF 
	cQuery += "INCLUSAO, CONVERT(NUMERIC (8,2),(REPLACE(SALARIO, ',', '.'))) SALARIO, CONVERT(NUMERIC (2,0),CAPSEG_MUL) CAPSEG_MUL FROM(  " + CRLF
	cQuery += "SELECT SRA.RA_FILIAL FILIAL, SRA.RA_MAT MATRICULA, SRA.RA_NOMECMP NOME_COMPL, SRA.RA_CIC CPF, " + CRLF
	cQuery += "SubStrING(SRA.RA_NASC,7,2)+'/'+SubStrING(SRA.RA_NASC,5,2)+'/'+SubStrING(SRA.RA_NASC,1,4) DT_NASC, " + CRLF             
	cQuery += "FLOOR(DATEDIFF(DAY, SRA.RA_NASC, GETDATE()) / 365.25) IDADE, " + CRLF  
	cQuery += "str((SRA.RA_SALARIO*SRA.RA_FMULSAL),15,2) VLR_CAPIT, SubStrING(SRA.RA_ADMISSA,7,2)+'/'+SubStrING(SRA.RA_ADMISSA,5,2)+'/'+SubStrING(SRA.RA_ADMISSA,1,4) INCLUSAO, " + CRLF 
	cQuery += "str(RA_SALARIO,10,2) SALARIO, RA_FMULSAL CAPSEG_MUL " + CRLF
	cQuery += "FROM "+retsqlname("SRA")+" SRA " + CRLF 
	cQuery += "WHERE SRA.D_E_L_E_T_ <> '*' " + CRLF 
	cQuery += "AND SRA.RA_FILIAL >= '" + mv_par01 + "' AND SRA.RA_FILIAL <= '" + mv_par02 + "' " + CRLF 
	cQuery += "AND SRA.RA_MAT >= '" + mv_par03 + "' AND SRA.RA_MAT <= '" + mv_par04 + "' " + CRLF 
	cQuery += "AND SRA.RA_CC >= '" + mv_par05 + "' AND SRA.RA_CC <= '" + mv_par06 + "' " + CRLF  
	cQuery += "AND (SRA.RA_DEMISSA = ' ' OR SRA.RA_DEMISSA >= '" + DTOS(mv_par07) + "') AND SRA.RA_FMULSAL > 1) A " + CRLF 
	cQuery += "ORDER BY A.FILIAL, A.NOME_COMPL " + CRLF 

	If Select("TRBSV") > 0                                      
		DbSelectArea("TRBSV")
		DbCloseArea()
	Endif

	TCQUERY cQuery NEW ALIAS "TRBSV"   

	TcSetField("TRBSV","IDADE","N",02,0)
	TcSetField("TRBSV","CAPSEG_MUL","N",02,0)
	TcSetField("TRBSV","VLR_CAPIT","N",12,2)
	TcSetField("TRBSV","SALARIO","N",08,2)


	aAdd(_struct,{ "FILIAL"      ,"C",41,0} )
	aAdd(_struct,{ "MATRICULA"   ,"C",06,0} )
	aAdd(_struct,{ "NOME_COMPL"  ,"C",70,0} )
	aAdd(_struct,{ "CPF"         ,"C",11,0} )
	aAdd(_struct,{ "DT_NASC"     ,"C",10,0} )
	aAdd(_struct,{ "IDADE"       ,"N",02,0} )
	aAdd(_struct,{ "VLR_CAPIT"   ,"N",12,2} )               
	aAdd(_struct,{ "INCLUSAO"    ,"C",10,0} )
	aAdd(_struct,{ "SALARIO"     ,"N",08,2} )
	aAdd(_struct,{ "CAPSEG_MUL"  ,"N",03,0} )
	//FILIAL, MATRICULA, NOME_COMPL, CPF, DT_NASC, IDADE, VLR_CAPIT, INCLUSAO,  SALARIO, CAPSEG_MUL
	_cArq:=Criatrab(_struct,.T.)
	DBUSEAREA(.T.,"DBF",_carq,"TRSV2") 

	dbselectarea("TRBSV")
	dbgotop()


	while !eof() 

		dbSelectArea("TRSV2")	
		RECLOCK("TRSV2",.T.) 

		dbselectarea("SM0")
		dbsetorder(1)
		if dbseek(cEmpAnt + TRBSV->FILIAL)				
			cFilNome := SM0->M0_FILIAL
		endif								

		TRSV2->FILIAL		:= ALLTRIM(cFilNome)
		TRSV2->MATRICULA	:= TRBSV->MATRICULA
		TRSV2->NOME_COMPL	:= TRBSV->NOME_COMPL
		TRSV2->CPF	        := TRBSV->CPF
		TRSV2->DT_NASC  	:= TRBSV->DT_NASC
		TRSV2->IDADE		:= TRBSV->IDADE
		TRSV2->VLR_CAPIT	:= TRBSV->VLR_CAPIT 
		TRSV2->INCLUSAO 	:= TRBSV->INCLUSAO
		TRSV2->SALARIO  	:= TRBSV->SALARIO                                       
		TRSV2->CAPSEG_MUL	:= TRBSV->CAPSEG_MUL

		MsUnlock()


		DBSELECTAREA("TRBSV")
		dbskip()
	enddo 

	DBSELECTAREA("TRSV2")
	DBGOTOP()

	cPath	  := cGetFile("","Local"                           ,0,""         ,.T.,GETF_RETDIRECTORY+GETF_LOCALHARD+GETF_LOCALFLOPPY)
	cPath   += IIf( Right( AllTrim( cPath ), 1 ) <> '\' , '\', '' )
	_cARQ   := ALLTRIM(cPath) + "SEGURO DE VIDA.XLS" 
	_ARQUIVO := "\system\SEGURO DE VIDA.XLS" //NOME DO ARQUIVO

	IF FILE(_ARQUIVO)
		DELETE FILE(_ARQUIVO)
	ENDIF
	COPY TO &_ARQUIVO VIA "DBFCDXADS"
	//direciona o arquivo para o local indicado no local cPath 
	IF FILE(_ARQUIVO)
		COPY FILE &_ARQUIVO TO &_cARQ 
	ENDIF
	//carrega o excel com o arquivo gerado, para isso, colocar o excel no path.

	apmsginfo("Arquivo " + _cARQ + " gerado corretamente")

	If ApOleClient("MsExcel")
		oExcelApp:= MsExcel():New()
		oExcelApp:WorkBooks:Open(ALLTRIM(cPath) + "SEGURO DE VIDA.XLS")  
		oExcelApp:SetVisible(.T.)
	Else
		Alert(OemtoAnsi( "Microsoft Excel nao encontrado !" ))
	EndIf


	dbSelectArea("TRBSV")
	DBCLOSEAREA()
	FERASE(_carq+".DBF")

Return ()


Static function f_Perg(cperg) 

	Local aregs		:= {}
	Local i, j		:= 0
	Local cArea := getarea()
	Local cPerg	:= "BSLSEGVIDA" 


	//          Grupo/Ordem    /Pergunta//                   /Var	/Tipo/Tam/Dec/Pres/GSC/Valid/ Var01      /Def01    /DefSpa01    /DefIng1      /Cnt01/Var02    /Def02   /DefSpa2     /DefIng2           /Cnt02   /Var03 /Def03   /DefSpa3  /DefIng3  /Cnt03 /Var04   /Def04     /Cnt04    /Var05  /Def05	/Cnt05  /XF3
	aadd(aregs, {cperg, "01", "Filial De?				  ", "ฟDe sucursal ?              ","From Branch ?                 ", "mv_ch1", "C", FWGETTAMFILIAL, 			0, 0, "G", ""						, "mv_par01", "", "", "", "", ""	, ""	, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "XM0"	, "S", "033", ".RHFILDE.", "", ""})
	aadd(aregs, {cperg, "02", "Filial At้?           	  ", "ฟA Sucursal ?         	  ","To Branch ?                   ", "mv_ch2", "C", FWGETTAMFILIAL, 			0, 0, "G", "naovazio()"				, "mv_par02", "", "", "", "", ""	, ""	, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "XM0"	, "S", "033", ".RHFILAT.", "", ""})
	aadd(aregs, {cperg, "03", "Matricula De?        	  ", "ฟDe Matricula ?             ","From Registration ?           ", "mv_ch3", "C", tamsx3("RA_MAT")[1],		0, 0, "G", ""						, "mv_par03", "", "", "", "", ""	, ""	, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SRA"	, "S", ""	, ".RHMATD." , "", ""})
	aadd(aregs, {cperg, "04", "Matricula At้?       	  ", "ฟA Matricula ?              ","To Registration ?             ", "mv_ch4", "C", tamsx3("RA_MAT")[1],		0, 0, "G", "naovazio()"				, "mv_par04", "", "", "", "", ""	, ""	, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SRA"	, "S", ""	, ".RHMATA." , "", ""})
	aadd(aregs, {cperg, "05", "Centro de Custo De?        ", "ฟDe Centro de Costo ?       ","From Cost Center ?            ", "mv_ch5", "C", tamsx3("RA_CC")[1], 		0, 0, "G", ""						, "mv_par05", "", "", "", "", ""	, ""	, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "CTT"	, "S", "004", ".RHCCDE." , "", ""})
	aadd(aregs, {cperg, "06", "Centro de Custo At้?	      ", "ฟA Centro de Costo ?        ","To Cost Center ?              ", "mv_ch6", "C", tamsx3("RA_CC")[1], 		0, 0, "G", "naovazio()"				, "mv_par06", "", "", "", "", ""	, ""	, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "CTT"	, "S", "004", ".RHCCAT." , "", ""})
	aadd(aregs, {cperg, "07", "Data Demissao Maior = de?  ", "Data Demissao Maior = de?	  ","Data Demissao Maior = de?	   ", "mv_ch7", "D", 8, 						0, 0, "G", "naovazio()"				, "mv_par07", "", "", "", "", ""	, ""	, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""	, "S", ""	, ""         , "", ""})

	dbselectarea("sx1")
	sx1->( dbsetorder(1))

	if !sx1->(dbseek(cperg))
		for i := 1 to len(aregs)
			if	!sx1->(dbseek(cperg + aregs[i, 2]))
				reclock("sx1", .t.)
				for j := 1 to fcount()
					fieldput(j, aregs[i, j])
				next
				msunlock("sx1")
			endif
		next
	endif

	restarea(cArea)
return
