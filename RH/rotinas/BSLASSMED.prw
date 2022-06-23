#INCLUDE "Protheus.ch"
#INCLUDE "AVPRINT.CH"
#INCLUDE "FONT.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "TOTVS.CH"

/*
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ BSLASSMED บAutor  ณ JORGE SATO        บ Dataณ   22/07/2017 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gera็ใo de Arquivo: MOVIMENTACAO NOTRE DAME 				  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SIGAGPE - BSL - EM EXCEL                                   บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                     A L T E R A C O E S                               บฑฑ
ฑฑฬออออออออออหออออออออออออออออออหอออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบData      บProgramador       บAlteracoes                               บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ 
*/

User Function BSLASSMED()

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Declaracao de Variaveis                                             ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	Private cPerg       := "ASSMEDIBSL"
	Private cbtxt      := Space(10)
	Private cString := ""
	Private bProcesso	:= { |oSelf| f_Proc(oSelf)}            

	cString := "SRA"

	dbSelectArea("SRA")
	dbSetOrder(1)

	f_Perg(cPerg)
	Pergunte(cperg, .F.)

	tNewProcess():New("BSLASSMED", "MOVIMENTACAO NOTRE DAME", bProcesso, "    Esta rotina tem por objetivo gerar planilha Excel referente a MOVIMENTACAO NOTRE DAME conforme parโmetros informados pelo usuแrio.", cperg, , , , , .T., .T.)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณf_Proc    บ Autor ณ JORGE SATO        บ Dataณ   22/07/2017  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao para processamento dos dados                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function f_Proc()

	Local cDemis := ' ' 
	Local n_cont
	Local _Arquivo
	Local cQuery := " " 
	Local cQry := " "
	Local _struct  := {}
	Local _cArq  := ""
	Local nX := 0 
	Local oExcelApp:= Nil 
	Local cPath
	Local cDest := ""
	Local cPer  := SUBSTR(DTOS(MV_PAR08),1,6)          

	cQuery := "SELECT SRA.RA_FILIAL FILIAL, SRA.RA_MAT MATRICULA,'TITULAR' CADASTRO, SRA.RA_NOMECMP NOME_COMPL,  " + CRLF
	cQuery += "SubStrING(SRA.RA_ADMISSA,7,2)+'/'+SubStrING(SRA.RA_ADMISSA,5,2)+'/'+SubStrING(SRA.RA_ADMISSA,1,4) DT_ADMISSA,  " + CRLF
	cQuery += "SubStrING(SRA.RA_DEMISSA,7,2)+'/'+SubStrING(SRA.RA_DEMISSA,5,2)+'/'+SubStrING(SRA.RA_DEMISSA,1,4) DT_DEMISSA,  " + CRLF
	cQuery += "SRA.RA_CODFUNC FUNCAO, SRJ.RJ_DESC DESC_FUNC, RA_MAE NOME_MAE,CASE RA_SEXO WHEN 'F' THEN 'FEMININO' WHEN 'M' THEN 'MASCULINO' END SEXO,  " + CRLF
	cQuery += "CASE SRA.RA_RACACOR WHEN ' ' THEN 'NAO INFORMADO' WHEN '1' THEN 'INDIGENA' WHEN '2' THEN 'BRANCA' WHEN '4' THEN 'NEGRA' WHEN '6' THEN 'AMARELA' WHEN '8' THEN 'PARDA' WHEN '9' THEN 'NAO INFORMADO' END RACA_COR,  " + CRLF
	cQuery += "SubStrING(SRA.RA_NASC,7,2)+'/'+SubStrING(SRA.RA_NASC,5,2)+'/'+SubStrING(SRA.RA_NASC,1,4) DT_NASC,  " + CRLF
	cQuery += "SRA.RA_ESTCIVI EST_CIVIL,RA_BCDEPSA BCO_AG_SAL, RA_CTDEPSA CTA_SALAR, RA_CIC CPF, RA_PIS PIS, RA_RG RG,  " + CRLF
	cQuery += "SubStrING(SRA.RA_DTRGEXP,7,2)+'/'+SubStrING(SRA.RA_DTRGEXP,5,2)+'/'+SubStrING(SRA.RA_DTRGEXP,1,4) DT_EMIS_RG,SRA.RA_RGUF UF_RG,   " + CRLF
	cQuery += "RA_RGORG ORGAO_EMIS, RA_NUMCP CART_PROF, RA_SERCP SERIE_CP, RA_UFCP UF_CP, RA_TITULOE TIT_ELEIT,SRA.RA_ZONASEC ZONA_ELEIT,   " + CRLF 
	cQuery += "SRA.RA_SECAO SECAO_ELEI, RTRIM(SRA.RA_LOGRTP) + '. ' +SRA.RA_LOGRDSC ENDERECO, SRA.RA_LOGRNUM NUM_ENDERE,SRA.RA_COMPLEM COMPL_END,  " + CRLF
	cQuery += "SRA.RA_BAIRRO BAIRRO, SRA.RA_MUNICIP MUNICIPIO, SRA.RA_CEP CX_POSTAL, SRA.RA_DDDCELU DDD_TELEFO, SRA.RA_NUMCELU TELEFONE,  " + CRLF
	cQuery += "CASE RA_RESCRAI WHEN '31' THEN 'TRANSFERIDO' END TRANSFER  " + CRLF
	cQuery += "FROM "+retsqlname("SRA")+" SRA INNER JOIN "+retsqlname("SRJ")+" SRJ ON (SRJ.RJ_FUNCAO = SRA.RA_CODFUNC)  " + CRLF 
	cQuery += "WHERE SRA.D_E_L_E_T_ <> '*' AND SRJ.D_E_L_E_T_ <> '*' AND SRA.RA_PLSAUDE = '1' " + CRLF 
	cQuery += "AND (SRA.RA_FILIAL >= '" + mv_par01 + "' AND SRA.RA_FILIAL <= '" + mv_par02 + "') " + CRLF 
	cQuery += "AND (SRA.RA_MAT >= '" + mv_par03 + "' AND SRA.RA_MAT <= '" + mv_par04 + "') " + CRLF 
	cQuery += "AND (SRA.RA_CC >= '" + mv_par05 + "' AND SRA.RA_CC <= '" + mv_par06 + "') " + CRLF
	cQuery += "AND ((SRA.RA_ADMISSA >= '" + DTOS(mv_par07) + "' AND SRA.RA_ADMISSA <= '" + DTOS(mv_par08) + "') " + CRLF
	cQuery += "OR (SRA.RA_DEMISSA >= '" + DTOS(mv_par07) + "' AND SRA.RA_DEMISSA <= '" + DTOS(mv_par08) + "')) " + CRLF
	cQuery += "UNION ALL " + CRLF
	cQuery += "SELECT RB_FILIAL FILIAL,RB_MAT MATRICULA,'DEPENDENTE' CADASTRO,RB_NOME NOME_COMPL,  " + CRLF 
	cQuery += "SubStrING(RB_DTNASC,7,2)+'/'+SubStrING(RB_DTNASC,5,2)+'/'+SubStrING(RB_DTNASC,1,4) DT_ADMISSA,  " + CRLF 
	cQuery += "'  /  /    ' DT_DEMISSA, ' ' FUNCAO, '  ' DESC_FUNC, RA_NOMECMP NOME_MAE,  " + CRLF  
	cQuery += "CASE RB_SEXO WHEN 'F' THEN 'FEMININO' WHEN 'M' THEN 'MASCULINO' END SEXO, ' ' RACA_COR,  " + CRLF 
	cQuery += "SubStrING(RB_DTNASC,7,2)+'/'+SubStrING(RB_DTNASC,5,2)+'/'+SubStrING(RB_DTNASC,1,4) DT_NASC,  " + CRLF 
	cQuery += "' ' EST_CIVIL,' ' BCO_AG_SAL,' ' CTA_SALAR,RB_CIC CPF,' ' PIS,' ' RG,'  /  /    ' DT_EMIS_RG, ' ' UF_RG,' ' ORGAO_EMIS,  " + CRLF 
	cQuery += "' ' CART_PROF,' ' SERIE_CP,' ' UF_CP,' ' TIT_ELEIT,' ' ZONA_ELEIT,' ' SECAO_ELEI,' ' ENDERECO,' ' NUM_ENDERE,' ' COMPL_END,  " + CRLF 
	cQuery += "' ' BAIRRO,' ' MUNICIPIO,' ' CX_POSTAL,' ' DDD_TELEFO,' ' TELEFONE, ' ' TRANSFER  " + CRLF 
	cQuery += "FROM "+retsqlname("SRB")+" SRB INNER JOIN "+retsqlname("SRA")+" SRA ON (RA_FILIAL = RB_FILIAL AND RA_MAT = RB_MAT AND RB_PLSAUDE = '1')  " + CRLF 
	cQuery += "WHERE SRA.D_E_L_E_T_ <> '*' AND SRB.D_E_L_E_T_ <> '*'  " + CRLF  
	cQuery += "AND (SRB.RB_FILIAL >= '" + mv_par01 + "' AND SRB.RB_FILIAL <= '" + mv_par02 + "') " + CRLF 
	cQuery += "AND (SRB.RB_MAT >= '" + mv_par03 + "' AND SRB.RB_MAT <= '" + mv_par04 + "') " + CRLF 
	cQuery += "AND (SRA.RA_CC >= '" + mv_par05 + "' AND SRA.RA_CC <= '" + mv_par06 + "') " + CRLF
	cQuery += "AND ((SRA.RA_ADMISSA >= '" + DTOS(mv_par07) + "' AND SRA.RA_ADMISSA <= '" + DTOS(mv_par08) + "') " + CRLF
	cQuery += "OR (SRA.RA_DEMISSA >= '" + DTOS(mv_par07) + "' AND SRA.RA_DEMISSA <= '" + DTOS(mv_par08) + "')) " + CRLF

	cQuery += "ORDER BY FILIAL,MATRICULA,CADASTRO DESC  " + CRLF 


	If Select("TRB") > 0
		DbSelectArea("TRB")
		DbCloseArea()
	Endif

	TCQUERY cQuery NEW ALIAS "TRB"   

	aAdd(_struct,{ "FILIAL"      ,"C",05,0} )
	aAdd(_struct,{ "MATRICULA"   ,"C",06,0} )
	aAdd(_struct,{ "CADASTRO"    ,"C",10,0} )
	aAdd(_struct,{ "NOME_COMPL"  ,"C",70,0} )
	aAdd(_struct,{ "DT_ADMISSA"  ,"C",10,0} )
	aAdd(_struct,{ "DT_DEMISSA"  ,"C",10,0} )
	aAdd(_struct,{ "COD_FUNCAO"  ,"C",05,0} )
	aAdd(_struct,{ "DESC_FUNC"   ,"C",20,0} )
	aAdd(_struct,{ "NOME_MAE"    ,"C",50,0} )
	aAdd(_struct,{ "SEXO"        ,"C",10,0} )
	aAdd(_struct,{ "RACA_COR"    ,"C",15,0} )
	aAdd(_struct,{ "DT_NASC"     ,"C",10,0} )
	aAdd(_struct,{ "EST_CIVIL"   ,"C",01,0} )
	aAdd(_struct,{ "BCO_AG_SAL"  ,"C",08,0} )
	aAdd(_struct,{ "CTA_SALAR"   ,"C",12,0} )
	aAdd(_struct,{ "CPF"         ,"C",11,0} )
	aAdd(_struct,{ "PIS"         ,"C",12,0} )
	aAdd(_struct,{ "RG"          ,"C",15,0} )
	aAdd(_struct,{ "DT_EMIS_RG"  ,"C",10,0} )
	aAdd(_struct,{ "UF_RG"       ,"C",02,0} )
	aAdd(_struct,{ "ORGAO_EMIS"  ,"C",06,0} )
	aAdd(_struct,{ "CART_PROF"   ,"C",08,0} )
	aAdd(_struct,{ "SERIE_CP"    ,"C",05,0} )
	aAdd(_struct,{ "UF_CP"       ,"C",02,0} )
	aAdd(_struct,{ "TIT_ELEIT"   ,"C",12,0} )
	aAdd(_struct,{ "ZONA_ELEIT"  ,"C",08,0} )
	aAdd(_struct,{ "SECAO_ELEI"  ,"C",04,0} )
	aAdd(_struct,{ "ENDERECO"    ,"C",85,0} )
	aAdd(_struct,{ "NUM_ENDERE"  ,"C",10,0} )
	aAdd(_struct,{ "COMPL_END"   ,"C",15,0} )
	aAdd(_struct,{ "BAIRRO"      ,"C",15,0} )
	aAdd(_struct,{ "MUNICIPIO"   ,"C",20,0} )
	aAdd(_struct,{ "CX_POSTAL"   ,"C",08,0} )
	aAdd(_struct,{ "DDD_TELEFO"  ,"C",02,0} )
	aAdd(_struct,{ "TELEFONE"    ,"C",10,0} )
	aAdd(_struct,{ "TRANSFER"    ,"C",30,0} )

	/*         
	FILIAL,MATRICULA,CADASTRO,NOME_COMPL,DT_ADMISSA,DT_DEMISSA,FUNCAO,DESC_FUNC,NOME_MAE,SEXO,RACA_COR,DT_NASC,EST_CIVIL,
	BCO_AG_SAL,CTA_SALAR,CPF,PIS,RG,DT_EMIS_RG,UF_RG,ORGAO_EMIS,CART_PROF,SERIE_CP,UF_CP,TIT_ELEIT,ZONA_ELEIT,SECAO_ELEI,
	ENDERECO,NUM_ENDERE,COMPL_END,BAIRRO,MUNICIPIO,CX_POSTAL,DDD_TELEFO,TELEFONE,TRANSFER
	*/
	_cArq:=Criatrab(_struct,.T.)
	DBUSEAREA(.T.,"DBFCDX",_carq,"ASMED")   

	dbSelectArea("TRB")
	Dbgotop() 

	while !eof("TRB") 


		dbSelectArea("ASMED")	
		RECLOCK("ASMED",.T.) 		

		ASMED->FILIAL      := TRB->FILIAL     
		ASMED->MATRICULA   := TRB->MATRICULA  
		ASMED->CADASTRO    := TRB->CADASTRO   
		ASMED->NOME_COMPL  := UPPER(TRB->NOME_COMPL)
		ASMED->DT_ADMISSA  := TRB->DT_ADMISSA 
		ASMED->DT_DEMISSA  := TRB->DT_DEMISSA 
		ASMED->COD_FUNCAO  := TRB->FUNCAO 
		ASMED->DESC_FUNC   := UPPER(TRB->DESC_FUNC) 
		ASMED->NOME_MAE    := UPPER(TRB->NOME_MAE)   
		ASMED->SEXO        := TRB->SEXO       
		ASMED->RACA_COR    := TRB->RACA_COR   
		ASMED->DT_NASC     := TRB->DT_NASC    
		ASMED->EST_CIVIL   := TRB->EST_CIVIL  
		ASMED->BCO_AG_SAL  := TRB->BCO_AG_SAL 
		ASMED->CTA_SALAR   := TRB->CTA_SALAR  
		ASMED->CPF         := TRB->CPF        
		ASMED->PIS         := TRB->PIS        
		ASMED->RG          := TRB->RG         
		ASMED->DT_EMIS_RG  := TRB->DT_EMIS_RG 
		ASMED->UF_RG       := TRB->UF_RG      
		ASMED->ORGAO_EMIS  := TRB->ORGAO_EMIS 
		ASMED->CART_PROF   := TRB->CART_PROF  
		ASMED->SERIE_CP    := TRB->SERIE_CP   
		ASMED->UF_CP       := TRB->UF_CP      
		ASMED->TIT_ELEIT   := TRB->TIT_ELEIT  
		ASMED->ZONA_ELEIT  := TRB->ZONA_ELEIT 
		ASMED->SECAO_ELEI  := TRB->SECAO_ELEI 
		ASMED->ENDERECO    := UPPER(TRB->ENDERECO)   
		ASMED->NUM_ENDERE  := TRB->NUM_ENDERE 
		ASMED->COMPL_END   := UPPER(TRB->COMPL_END)  
		ASMED->BAIRRO      := UPPER(TRB->BAIRRO)     
		ASMED->MUNICIPIO   := UPPER(TRB->MUNICIPIO)  
		ASMED->CX_POSTAL   := TRB->CX_POSTAL  
		ASMED->DDD_TELEFO  := TRB->DDD_TELEFO 
		ASMED->TELEFONE    := TRB->TELEFONE
		cDemis:= SUBSTR(TRB->DT_DEMISSA,7,4) + SUBSTR(TRB->DT_DEMISSA,4,2) + SUBSTR(TRB->DT_DEMISSA,1,2)  
		cDest := SUBSTR(TRB->FILIAL,1,2)

		IF TRB->TRANSFER = "TRANSFERIDO"

			cQry:= "SELECT RE_DATA, RE_EMPD, RE_FILIALD, RE_MATD, RE_CCD, RE_EMPP, RE_FILIALP, RE_MATP, RE_CCP " + CRLF 
			cQry+= "FROM "+retsqlname("SRE")+" SRE " + CRLF 
			cQry+= "WHERE SRE.D_E_L_E_T_ <> '*' AND RE_DATA = '" + cDemis + "' AND RE_EMPD = '" + cDest + "' AND RE_FILIALD = '" + TRB->FILIAL + "' AND RE_MATD = '" + TRB->MATRICULA + "' " + CRLF

			If Select("TRBRE") > 0
				DbSelectArea("TRBRE")
				TRBRE->(DbCloseArea())
			Endif

			TCQUERY cQry NEW ALIAS "TRBRE"  

			dbSelectArea("TRBRE")
			TRBRE->(Dbgotop()) 

			ASMED->TRANSFER := "TRANSFERIDO - " + ALLTRIM(TRBRE->RE_FILIALP) + "-" + ALLTRIM(TRBRE->RE_MATP)

			TRBRE->(DbCloseArea())

		ELSE
			ASMED->TRANSFER := " "  	
		ENDIF	 
		MsUnlock()

		DBSELECTAREA("TRB")
		TRB->(dbskip())
	enddo 

	DBSELECTAREA("ASMED")
	DBGOTOP()

	cPath	  := cGetFile("","Local"                           ,0,""         ,.T.,GETF_RETDIRECTORY+GETF_LOCALHARD+GETF_LOCALFLOPPY)
	cPath   += IIf( Right( AllTrim( cPath ), 1 ) <> '\' , '\', '' )
	_cARQ   := ALLTRIM(cPath) + "NOTREDAME " + cPer +".XLS" 
	_ARQUIVO := "\system\NOTREDAME " +cPer +".XLS" //NOME DO ARQUIVO

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
		oExcelApp:WorkBooks:Open(ALLTRIM(_cARQ))            //Open(ALLTRIM(cPath) + "NOTREDAME.XLS")  
		oExcelApp:SetVisible(.T.)
	Else
		Alert(OemtoAnsi( "Microsoft Excel nao encontrado !" ))
	EndIf


	dbSelectArea("TRB")
	DBCLOSEAREA()

	dbSelectArea("ASMED")
	DBCLOSEAREA()
	FERASE(_carq+".DBF")

Return ()


Static function f_Perg(cperg) 

	Local aregs		:= {}
	Local i, j		:= 0
	Local cArea := getarea()
	Local cPerg	:= "ASSMEDIBSL" 


	//          Grupo/Ordem    /Pergunta//                   /Var	/Tipo/Tam/Dec/Pres/GSC/Valid/ Var01      /Def01    /DefSpa01    /DefIng1      /Cnt01/Var02    /Def02   /DefSpa2     /DefIng2           /Cnt02   /Var03 /Def03   /DefSpa3  /DefIng3  /Cnt03 /Var04   /Def04     /Cnt04    /Var05  /Def05	/Cnt05  /XF3
	aadd(aregs, {cperg, "01", "Filial De				", "ฟDe sucursal ?              ","From Branch ?                 ", "mv_ch1", "C", FWGETTAMFILIAL, 			0, 0, "G", ""						, "mv_par01", "", "", "", "", ""	, ""	, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "XM0"	, "S", "033", ".RHFILDE.", "", ""})
	aadd(aregs, {cperg, "02", "Filial At้           	", "ฟA Sucursal ?         	    ","To Branch ?                   ", "mv_ch2", "C", FWGETTAMFILIAL, 			0, 0, "G", "naovazio()"				, "mv_par02", "", "", "", "", ""	, ""	, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "XM0"	, "S", "033", ".RHFILAT.", "", ""})
	aadd(aregs, {cperg, "03", "Matricula De        		", "ฟDe Matricula ?            	","From Registration ?           ", "mv_ch3", "C", tamsx3("RA_MAT")[1],		0, 0, "G", ""						, "mv_par03", "", "", "", "", ""	, ""	, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SRA"	, "S", ""	, ".RHMATD.", "", ""})
	aadd(aregs, {cperg, "04", "Matricula At้       		", "ฟA Matricula ?             	","To Registration ?             ", "mv_ch4", "C", tamsx3("RA_MAT")[1],		0, 0, "G", "naovazio()"				, "mv_par04", "", "", "", "", ""	, ""	, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SRA"	, "S", ""	, ".RHMATA.", "", ""})
	aadd(aregs, {cperg, "05", "Centro de Custo De   	", "ฟDe Centro de Costo ?       ","From Cost Center ?            ", "mv_ch5", "C", tamsx3("RA_CC")[1], 		0, 0, "G", ""						, "mv_par05", "", "", "", "", ""	, ""	, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "CTT"	, "S", "004", ".RHCCDE.", "", ""})
	aadd(aregs, {cperg, "06", "Centro de Custo At้		", "ฟA Centro de Costo ?        ","To Cost Center ?              ", "mv_ch6", "C", tamsx3("RA_CC")[1], 		0, 0, "G", "naovazio()"				, "mv_par06", "", "", "", "", ""	, ""	, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "CTT"	, "S", "004", ".RHCCAT.", "", ""})
	//aadd(aregs, {cperg, "07", "Categorias	      		", "Categorias	             	","Categorias 			         ", "mv_ch7", "C", 15,                 		0, 0, "G", "fCategoria"		    	, "mv_par07", "", "", "", "", ""	, ""	, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""	, "S", ""	, ".RHCATEG.", "", ""})
	//aadd(aregs, {cperg, "08", "Situa็๕es	      		", "Situa็๕es	             	","Situa็๕es 			         ", "mv_ch8", "C", 5,                 		0, 0, "G", "fSituacao"				, "mv_par08", "", "", "", "", ""	, ""	, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""	, "S", ""	, ".RHSITUA.", "", ""})
	aadd(aregs, {cperg, "07", "Data de Admissao de		", "Data de Admissao de	    	","Data de Admissao de	    	 ", "mv_ch7", "D", 8, 						0, 0, "G", "naovazio()"				, "mv_par07", "", "", "", "", ""	, ""	, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""	, "S", ""	, "", "", ""})
	aadd(aregs, {cperg, "08", "Data de Admissao Ate		", "Data de Admissao Ate	    ","Data de Admissao Ate	    	 ", "mv_ch8", "D", 8, 						0, 0, "G", "naovazio()"				, "mv_par08", "", "", "", "", ""	, ""	, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""	, "S", ""	, "", "", ""})

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

Return