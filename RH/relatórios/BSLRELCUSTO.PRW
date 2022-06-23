#INCLUDE "Protheus.ch"
#INCLUDE "AVPRINT.CH"
#INCLUDE "FONT.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "TOTVS.CH"

/*
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RELCUSTO  ºAutor  ³ JORGE SATO        º Data³   24/08/2017 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Geração de Arquivo: RELATORIO DE CUSTO      				  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGAGPE - BSL - EM EXCEL                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º                     A L T E R A C O E S                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºData      ºProgramador       ºAlteracoes                               º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±± 
*/

User Function RELCUSTO()


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Declaracao de Variaveis                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


	Private cPerg       := "RELCUSTO  "
	Private cString := ""
	Private bProcesso	:= { |oSelf| f_Proc(oSelf)}            

	cString := "SRA"


	dbSelectArea("SRA")
	dbSetOrder(1)


	f_Perg(cPerg)
	Pergunte(cperg, .F.)

	tNewProcess():New("RELCUSTO", "RELATORIO DE CUSTO  - " , bProcesso, "           ESTA ROTINA GERA EM PLANILHA EXCEL O RELATORIO DE CUSTO, AGUARDE ALGUNS MINUTOS.....", cperg, , , , , .T., .T.)


Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³f_Proc    º Autor ³ JORGE SATO        º Data³   24/08/2017  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao para processamento dos dados                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function f_Proc()

	Local _Arquivo := ""
	Local cQuery
	Local cQry
	Local _cArq  := ""
	Local oExcelApp:= Nil 
	Local cPath  
	Local _struct := {}
	Local nProvent := 0
	Local nDescont := 0
	Local nCusTotal:= 0
	Local nProvFer := 0
	Local nProv13S := 0 
	Local nFer := 0
	Local n13S := 0                                       

	cQuery := "SELECT A.UNIDADE,A.MATRICULA,A.NOME,A.CPF,A.COD_FUNCAO,A.DES_FUNCAO,A.COD_CCUSTO,A.CENTRCUSTO, A.ADMISSAO, A.DEMISSAO, A.SALARIO_BS, " + CRLF
	cQuery += "Sum(VERBA_999) LIQ_FOLHA, Sum(VERBA_450) LIQ_ADIANT, (Sum(VERBA_034)+Sum(VERBA_074)+Sum(VERBA_198)) AD_NOTURNO, Sum(VERBA_054) SALFAMILIA, " + CRLF      
	cQuery += "(Sum(VERBA_055)+Sum(VERBA_069)) AUX_CRECHE,Sum(VERBA_070) AD_INSALUB, Sum(VERBA_073) AD_PERICUL, Sum(VERBA_111) SOBREAVISO, (Sum(VERBA_028)+Sum(VERBA_029)) COMISSAO, " + CRLF
	cQuery += "(Sum(VERBA_364)+Sum(VERBA_030)+Sum(VERBA_031)+Sum(VERBA_032)+Sum(VERBA_033)+Sum(VERBA_036)+Sum(VERBA_038)+Sum(VERBA_063)+Sum(VERBA_064)+Sum(VERBA_085)+Sum(VERBA_086)+Sum(VERBA_087)+Sum(VERBA_092)+Sum(VERBA_097)+Sum(VERBA_112)+Sum(VERBA_113)+Sum(VERBA_353)+Sum(VERBA_354)+Sum(VERBA_355)) HORA_EXTRA, " + CRLF         
	cQuery += "(Sum(VERBA_796)+Sum(VERBA_365)) VALE_TRANS, (Sum(VERBA_797)+Sum(VERBA_125)) VALE_ALIM, (Sum(VERBA_798)+Sum(VERBA_366)) VALE_REFEI, " + CRLF       
	cQuery += "Sum(VERBA_799) ASS_MEDICA, Sum(VERBA_801) ASS_MED_DP, Sum(VERBA_800) ODONTO, (Sum(VERBA_815)+Sum(VERBA_816)+Sum(VERBA_817)) INSS, " + CRLF       
	cQuery += "Sum(VERBA_541) COPARTICIP, Sum(VERBA_562) DESCO_ALIM, Sum(VERBA_578) DESCO_AMDP, Sum(VERBA_579) DESCO_AODP, " + CRLF
	cQuery += "(Sum(VERBA_618)+Sum(VERBA_561)) DESCO_VT, (Sum(VERBA_619)+Sum(VERBA_560)) DESCO_VR, (Sum(VERBA_755)+Sum(VERBA_756)) FGTS " + CRLF        
	cQuery += "FROM ( " + CRLF
	cQuery += "SELECT RD_FILIAL UNIDADE, " + CRLF
	cQuery += "RD_MAT MATRICULA, " + CRLF
	cQuery += "RA_NOMECMP NOME, " + CRLF
	cQuery += "RA_CIC CPF, " + CRLF
	cQuery += "RA_CODFUNC COD_FUNCAO, " + CRLF
	cQuery += "UPPER(RJ_DESC) DES_FUNCAO, " + CRLF
	cQuery += "RD_CC COD_CCUSTO, " + CRLF
	cQuery += "CTT_DESC01 CENTRCUSTO, " + CRLF
	cQuery += "SubStrING(RA_ADMISSA,7,2)+'/'+SubStrING(RA_ADMISSA,5,2)+'/'+SubStrING(RA_ADMISSA,1,4) ADMISSAO, " + CRLF
	cQuery += "SubStrING(RA_DEMISSA,7,2)+'/'+SubStrING(RA_DEMISSA,5,2)+'/'+SubStrING(RA_DEMISSA,1,4) DEMISSAO, " + CRLF
	cQuery += "RA_SALARIO SALARIO_BS, " + CRLF
	cQuery += "CASE RD_PD WHEN '028' THEN RD_VALOR ELSE 0 END VERBA_028, " + CRLF 
	cQuery += "CASE RD_PD WHEN '029' THEN RD_VALOR ELSE 0 END VERBA_029, " + CRLF 
	cQuery += "CASE RD_PD WHEN '030' THEN RD_VALOR ELSE 0 END VERBA_030, " + CRLF  
	cQuery += "CASE RD_PD WHEN '031' THEN RD_VALOR ELSE 0 END VERBA_031, " + CRLF
	cQuery += "CASE RD_PD WHEN '032' THEN RD_VALOR ELSE 0 END VERBA_032, " + CRLF
	cQuery += "CASE RD_PD WHEN '033' THEN RD_VALOR ELSE 0 END VERBA_033, " + CRLF
	cQuery += "CASE RD_PD WHEN '034' THEN RD_VALOR ELSE 0 END VERBA_034, " + CRLF
	cQuery += "CASE RD_PD WHEN '036' THEN RD_VALOR ELSE 0 END VERBA_036, " + CRLF
	cQuery += "CASE RD_PD WHEN '038' THEN RD_VALOR ELSE 0 END VERBA_038, " + CRLF
	cQuery += "CASE RD_PD WHEN '054' THEN RD_VALOR ELSE 0 END VERBA_054, " + CRLF       
	cQuery += "CASE RD_PD WHEN '055' THEN RD_VALOR ELSE 0 END VERBA_055, " + CRLF
	cQuery += "CASE RD_PD WHEN '063' THEN RD_VALOR ELSE 0 END VERBA_063, " + CRLF
	cQuery += "CASE RD_PD WHEN '064' THEN RD_VALOR ELSE 0 END VERBA_064, " + CRLF       
	cQuery += "CASE RD_PD WHEN '069' THEN RD_VALOR ELSE 0 END VERBA_069, " + CRLF       
	cQuery += "CASE RD_PD WHEN '070' THEN RD_VALOR ELSE 0 END VERBA_070, " + CRLF
	cQuery += "CASE RD_PD WHEN '073' THEN RD_VALOR ELSE 0 END VERBA_073, " + CRLF        
	cQuery += "CASE RD_PD WHEN '074' THEN RD_VALOR ELSE 0 END VERBA_074, " + CRLF
	cQuery += "CASE RD_PD WHEN '085' THEN RD_VALOR ELSE 0 END VERBA_085, " + CRLF
	cQuery += "CASE RD_PD WHEN '086' THEN RD_VALOR ELSE 0 END VERBA_086, " + CRLF
	cQuery += "CASE RD_PD WHEN '087' THEN RD_VALOR ELSE 0 END VERBA_087, " + CRLF
	cQuery += "CASE RD_PD WHEN '092' THEN RD_VALOR ELSE 0 END VERBA_092, " + CRLF
	cQuery += "CASE RD_PD WHEN '097' THEN RD_VALOR ELSE 0 END VERBA_097, " + CRLF
	cQuery += "CASE RD_PD WHEN '111' THEN RD_VALOR ELSE 0 END VERBA_111, " + CRLF        
	cQuery += "CASE RD_PD WHEN '112' THEN RD_VALOR ELSE 0 END VERBA_112, " + CRLF
	cQuery += "CASE RD_PD WHEN '113' THEN RD_VALOR ELSE 0 END VERBA_113, " + CRLF       
	cQuery += "CASE RD_PD WHEN '125' THEN RD_VALOR ELSE 0 END VERBA_125, " + CRLF       
	cQuery += "CASE RD_PD WHEN '198' THEN RD_VALOR ELSE 0 END VERBA_198, " + CRLF
	cQuery += "CASE RD_PD WHEN '353' THEN RD_VALOR ELSE 0 END VERBA_353, " + CRLF
	cQuery += "CASE RD_PD WHEN '354' THEN RD_VALOR ELSE 0 END VERBA_354, " + CRLF
	cQuery += "CASE RD_PD WHEN '355' THEN RD_VALOR ELSE 0 END VERBA_355, " + CRLF       
	cQuery += "CASE RD_PD WHEN '364' THEN RD_VALOR ELSE 0 END VERBA_364, " + CRLF       
	cQuery += "CASE RD_PD WHEN '365' THEN RD_VALOR ELSE 0 END VERBA_365, " + CRLF       
	cQuery += "CASE RD_PD WHEN '366' THEN RD_VALOR ELSE 0 END VERBA_366, " + CRLF       
	cQuery += "CASE RD_PD WHEN '401' THEN RD_VALOR ELSE 0 END VERBA_401, " + CRLF 
	cQuery += "CASE RD_PD WHEN '450' THEN RD_VALOR ELSE 0 END VERBA_450, " + CRLF      
	cQuery += "CASE RD_PD WHEN '541' THEN RD_VALOR ELSE 0 END VERBA_541, " + CRLF       
	cQuery += "CASE RD_PD WHEN '560' THEN RD_VALOR ELSE 0 END VERBA_560, " + CRLF       
	cQuery += "CASE RD_PD WHEN '561' THEN RD_VALOR ELSE 0 END VERBA_561, " + CRLF       
	cQuery += "CASE RD_PD WHEN '562' THEN RD_VALOR ELSE 0 END VERBA_562, " + CRLF       
	cQuery += "CASE RD_PD WHEN '578' THEN RD_VALOR ELSE 0 END VERBA_578, " + CRLF
	cQuery += "CASE RD_PD WHEN '579' THEN RD_VALOR ELSE 0 END VERBA_579, " + CRLF       
	cQuery += "CASE RD_PD WHEN '618' THEN RD_VALOR ELSE 0 END VERBA_618, " + CRLF       
	cQuery += "CASE RD_PD WHEN '619' THEN RD_VALOR ELSE 0 END VERBA_619, " + CRLF       
	cQuery += "CASE RD_PD WHEN '755' THEN RD_VALOR ELSE 0 END VERBA_755, " + CRLF
	cQuery += "CASE RD_PD WHEN '756' THEN RD_VALOR ELSE 0 END VERBA_756, " + CRLF       
	cQuery += "CASE RD_PD WHEN '796' THEN RD_VALOR ELSE 0 END VERBA_796, " + CRLF       
	cQuery += "CASE RD_PD WHEN '797' THEN RD_VALOR ELSE 0 END VERBA_797, " + CRLF       
	cQuery += "CASE RD_PD WHEN '798' THEN RD_VALOR ELSE 0 END VERBA_798, " + CRLF       
	cQuery += "CASE RD_PD WHEN '799' THEN RD_VALOR ELSE 0 END VERBA_799, " + CRLF       
	cQuery += "CASE RD_PD WHEN '800' THEN RD_VALOR ELSE 0 END VERBA_800, " + CRLF       
	cQuery += "CASE RD_PD WHEN '801' THEN RD_VALOR ELSE 0 END VERBA_801, " + CRLF
	cQuery += "CASE RD_PD WHEN '815' THEN RD_VALOR ELSE 0 END VERBA_815, " + CRLF
	cQuery += "CASE RD_PD WHEN '816' THEN RD_VALOR ELSE 0 END VERBA_816, " + CRLF
	cQuery += "CASE RD_PD WHEN '817' THEN RD_VALOR ELSE 0 END VERBA_817, " + CRLF       
	cQuery += "CASE RD_PD WHEN '870' THEN RD_VALOR ELSE 0 END VERBA_870, " + CRLF       
	cQuery += "CASE RD_PD WHEN '871' THEN RD_VALOR ELSE 0 END VERBA_871, " + CRLF       
	cQuery += "CASE RD_PD WHEN '999' THEN RD_VALOR ELSE 0 END VERBA_999 " + CRLF       
	cQuery += "FROM "+retsqlname("SRD")+" SRD " + CRLF
	cQuery += "INNER JOIN "+retsqlname("SRA")+" SRA ON (RA_FILIAL = RD_FILIAL AND RA_MAT = RD_MAT) " + CRLF
	cQuery += "INNER JOIN "+retsqlname("SRJ")+" SRJ ON (RA_CODFUNC = RJ_FUNCAO AND RD_EMPRESA =' ') " + CRLF
	cQuery += "INNER JOIN "+retsqlname("CTT")+" CTT ON (RD_CC = CTT_CUSTO) " + CRLF
	cQuery += "WHERE SRD.D_E_L_E_T_ = ' ' AND SRA.D_E_L_E_T_ = ' ' AND SRJ.D_E_L_E_T_ = ' ' AND CTT.D_E_L_E_T_ = ' '
	cQuery += "AND RD_FILIAL BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "' " + CRLF 
	cQuery += "AND RD_MAT BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "' " + CRLF 
	cQuery += "AND RD_CC BETWEEN '" + mv_par05 + "' AND '" + mv_par06 + "' " + CRLF 
	cQuery += "AND RD_PD IN ('028','029','030','034','054','055','069','070','073','074','125','198','364','365','366','450','541','560','561','562','578','618','619','755','756','796','797','798','799','800','801','815','816','817','999','031','032','033','036','038','063','064','085','086','087','092','097','111','112','113','353','354','355','579') " + CRLF
	cQuery += "AND RD_PERIODO BETWEEN '" + mv_par07 + "'  AND '" + mv_par07 + "' ) A " + CRLF
	cQuery += "GROUP BY  UNIDADE, " + CRLF
	cQuery += "MATRICULA, " + CRLF
	cQuery += "NOME, " + CRLF  
	cQuery += "CPF, " + CRLF
	cQuery += "COD_FUNCAO, " + CRLF
	cQuery += "DES_FUNCAO, " + CRLF
	cQuery += "COD_CCUSTO, " + CRLF
	cQuery += "CENTRCUSTO, " + CRLF
	cQuery += "SALARIO_BS, " + CRLF
	cQuery += "ADMISSAO, " + CRLF
	cQuery += "DEMISSAO " + CRLF
	cQuery += "ORDER BY UNIDADE,NOME " + CRLF        



	If Select("TRBRC") > 0                                      
		DbSelectArea("TRBRC")
		DbCloseArea()
	Endif

	TCQUERY cQuery NEW ALIAS "TRBRC"   

	aAdd(_struct,{ "UNIDADE"     ,"C",05,0} )
	aAdd(_struct,{ "MATRICULA"   ,"C",06,0} )
	aAdd(_struct,{ "NOME_COMPL"  ,"C",70,0} )
	aAdd(_struct,{ "CPF"         ,"C",11,0} )
	aAdd(_struct,{ "COD_FUNCAO"  ,"C",05,0} )
	aAdd(_struct,{ "FUNCAO_DES"  ,"C",20,0} )
	aAdd(_struct,{ "COD_CCUSTO"  ,"C",20,0} )
	aAdd(_struct,{ "CCUSTO_DES"  ,"C",50,0} )
	aAdd(_struct,{ "ADMISSAO"    ,"C",10,0} )
	aAdd(_struct,{ "DEMISSAO"    ,"C",10,0} )
	aAdd(_struct,{ "SALARIO_BS"  ,"N",12,2} )
	aAdd(_struct,{ "SAL_LIQUID"  ,"N",12,2} )
	aAdd(_struct,{ "LIQ_ADIANT"  ,"N",12,2} )
	aAdd(_struct,{ "AD_NOTURNO"  ,"N",12,2} )
	aAdd(_struct,{ "AD_INSALUB"  ,"N",12,2} )
	aAdd(_struct,{ "AD_PERICUL"  ,"N",12,2} )
	aAdd(_struct,{ "SALFAMILIA"  ,"N",12,2} )
	aAdd(_struct,{ "AUX_CRECHE"  ,"N",12,2} )
	aAdd(_struct,{ "SOBREAVISO"  ,"N",12,2} )
	aAdd(_struct,{ "COMISSAO"    ,"N",12,2} )
	aAdd(_struct,{ "HORA_EXTRA"  ,"N",12,2} )
	aAdd(_struct,{ "VALE_TRANS"  ,"N",12,2} )
	aAdd(_struct,{ "VALE_REFEI"  ,"N",12,2} )
	aAdd(_struct,{ "VALE_ALIM"   ,"N",12,2} )
	aAdd(_struct,{ "ASS_MEDICA"  ,"N",12,2} )
	aAdd(_struct,{ "ASS_MED_DP"  ,"N",12,2} )
	aAdd(_struct,{ "ODONTOLOG"   ,"N",12,2} )
	aAdd(_struct,{ "INSS_TOTAL"  ,"N",12,2} )
	aAdd(_struct,{ "FGTS_TOTAL"  ,"N",12,2} )
	aAdd(_struct,{ "TOTAL_PROV"  ,"N",18,2} )
	aAdd(_struct,{ "COPARTICIP"  ,"N",12,2} )
	aAdd(_struct,{ "DESCO_AMDP"  ,"N",12,2} )
	aAdd(_struct,{ "DESCO_AODP"  ,"N",12,2} )
	aAdd(_struct,{ "DESCO_ALIM"  ,"N",12,2} )
	aAdd(_struct,{ "DESCO_TRAN"  ,"N",12,2} )
	aAdd(_struct,{ "DESCO_REFE"  ,"N",12,2} )
	aAdd(_struct,{ "TOTAL_DESC"  ,"N",12,2} )
	aAdd(_struct,{ "PROVFERIAS"  ,"N",15,2} )
	aAdd(_struct,{ "PROV_13SAL"  ,"N",15,2} )
	aAdd(_struct,{ "TOT_CUSTOS"  ,"N",18,2} )
	// UNIDADE,MATRICULA,NOME,COD_FUNCAO,DESC_FUNCAO,COD_CCUSTO,CENTRCUSTO, ADMISSAO, DEMISSAO, SALARIO_BS, 
	// LIQ_FOLHA,LIQ_ADIANT,AD_NOTURNO,SALFAMILIA,AUX_CRECHE, AD_INSALUB,AD_PERICUL,SOBREAVISO, COMISSAO,HORA_EXTRA, VALE_TRANS, VALE_ALIM, VALE_REFEI,       
	// ASS_MEDICA, ASS_MED_DP, ODONTO, INSS, COPARTICIP, DESCO_AMDP, DESCO_AODP, DESCO_ALIM, DESC_VT, DESCO_VR, FGTS


	_cArq:=Criatrab(_struct,.T.)
	DBUSEAREA(.T.,"DBFCDX",_carq,"TRRC2") 

	cQry := "SELECT A.RT_FILIAL, A.RT_MAT, A.RT_DATACAL,  SUM(A.PROV_FERIAS) PROV_FERIAS, SUM(A.PROV_13SAL) PROV_13SAL " + CRLF
	cQry += "FROM ( " + CRLF
	cQry += "SELECT SRT.RT_FILIAL, SRT.RT_MAT, SRT.RT_DATACAL, SUM(SRT.RT_VALOR) PROV_FERIAS, ' ' PROV_13SAL " + CRLF 
	cQry += "FROM "+retsqlname("SRT")+" SRT WHERE SUBSTRING(SRT.RT_DATACAL,1,6) = '" + mv_par07 + "' AND SRT.RT_TIPPROV IN ('1','2') " + CRLF
	cQry += "GROUP BY SRT.RT_FILIAL, SRT.RT_MAT, SRT.RT_DATACAL " + CRLF
	cQry += "UNION ALL " + CRLF
	cQry += "SELECT SRT1.RT_FILIAL, SRT1.RT_MAT, SRT1.RT_DATACAL, ' ' PROV_FERIAS, SUM(SRT1.RT_VALOR) PROV_13SAL " + CRLF 
	cQry += "FROM "+retsqlname("SRT")+" SRT1 WHERE SUBSTRING(SRT1.RT_DATACAL,1,6) = '" + mv_par07 + "' AND SRT1.RT_TIPPROV = '3' " + CRLF
	cQry += "GROUP BY SRT1.RT_FILIAL, SRT1.RT_MAT, SRT1.RT_DATACAL) A " + CRLF
	cQry += "GROUP BY A.RT_FILIAL, A.RT_MAT, A.RT_DATACAL " + CRLF

	If Select("TRBTR") > 0                                      
		DbSelectArea("TRBTR")
		DbCloseArea()
	Endif

	TCQUERY cQry NEW ALIAS "TRBTR" 


	dbselectarea("TRBRC") 
	dbgotop()

	while !eof("TRBRC") 


		dbSelectArea("TRRC2")	
		RECLOCK("TRRC2",.T.) 								

		TRRC2->UNIDADE       := TRBRC->UNIDADE
		TRRC2->MATRICULA     := TRBRC->MATRICULA
		TRRC2->NOME_COMPL    := TRBRC->NOME
		TRRC2->CPF           := TRBRC->CPF		
		TRRC2->COD_FUNCAO    := TRBRC->COD_FUNCAO
		TRRC2->FUNCAO_DES    := TRBRC->DES_FUNCAO
		TRRC2->COD_CCUSTO    := TRBRC->COD_CCUSTO
		TRRC2->CCUSTO_DES    := TRBRC->CENTRCUSTO
		TRRC2->ADMISSAO      := TRBRC->ADMISSAO
		TRRC2->DEMISSAO      := TRBRC->DEMISSAO
		TRRC2->SALARIO_BS    := TRBRC->SALARIO_BS
		TRRC2->SAL_LIQUID    := TRBRC->LIQ_FOLHA
		nProvent += TRBRC->LIQ_FOLHA 
		TRRC2->LIQ_ADIANT    := TRBRC->LIQ_ADIANT
		nProvent += TRBRC->LIQ_ADIANT 		
		TRRC2->AD_NOTURNO    := TRBRC->AD_NOTURNO 
		nProvent += TRBRC->AD_NOTURNO
		TRRC2->AD_INSALUB    := TRBRC->AD_INSALUB 
		nProvent += TRBRC->AD_INSALUBR 		
		TRRC2->AD_PERICUL    := TRBRC->AD_PERICUL 
		nProvent += TRBRC->AD_PERICUL		
		TRRC2->SALFAMILIA    := TRBRC->SALFAMILIA 
		nProvent += TRBRC->SALFAMILIA		
		TRRC2->AUX_CRECHE    := TRBRC->AUX_CRECHE
		nProvent += TRBRC->AUX_CRECHE		
		TRRC2->SOBREAVISO    := TRBRC->SOBREAVISO
		nProvent += TRBRC->SOBREAVISO		
		TRRC2->COMISSAO      := TRBRC->COMISSAO 
		nProvent += TRBRC->COMISSAO		
		TRRC2->HORA_EXTRA    := TRBRC->HORA_EXTRA
		nProvent += TRBRC->HORA_EXTRA		
		TRRC2->VALE_TRANS    := TRBRC->VALE_TRANS
		nProvent += TRBRC->VALE_TRANS 		
		TRRC2->VALE_REFEI    := TRBRC->VALE_REFEI
		nProvent += TRBRC->VALE_REFEI		
		TRRC2->VALE_ALIM     := TRBRC->VALE_ALIM
		nProvent += TRBRC->VALE_ALIM		
		TRRC2->ASS_MEDICA    := TRBRC->ASS_MEDICA
		nProvent += TRBRC->ASS_MEDICA		
		TRRC2->ASS_MED_DP    := TRBRC->ASS_MED_DP
		nProvent += TRBRC->ASS_MED_DP		
		TRRC2->ODONTOLOG     := TRBRC->ODONTO
		nProvent += TRBRC->ODONTO		
		TRRC2->INSS_TOTAL    := TRBRC->INSS
		nProvent += TRBRC->INSS		
		TRRC2->FGTS_TOTAL    := TRBRC->FGTS
		nProvent += TRBRC->FGTS		
		TRRC2->TOTAL_PROV    := nProvent 
		TRRC2->COPARTICIP    := TRBRC->COPARTICIP
		nDescont += TRBRC->COPARTICIP
		TRRC2->DESCO_AMDP    := TRBRC->DESCO_AMDP 
		nDescont += TRBRC->DESCO_AMDP		
		TRRC2->DESCO_AODP    := TRBRC->DESCO_AODP
		nDescont += TRBRC->DESCO_AODP		
		TRRC2->DESCO_ALIM    := TRBRC->DESCO_ALIM
		nDescont +=	TRBRC->DESCO_ALIM	
		TRRC2->DESCO_TRAN    := TRBRC->DESCO_VT 
		nDescont += TRBRC->DESCO_VT		
		TRRC2->DESCO_REFE    := TRBRC->DESCO_VR
		nDescont += TRBRC->DESCO_VR		
		TRRC2->TOTAL_DESC    := nDescont 
		dbselectarea("TRBTR")
		TRBTR->(dbgotop())

		while !TRBTR->(eof())
			IF (TRBTR->RT_FILIAL = TRBRC->UNIDADE .AND. TRBTR->RT_MAT = TRBRC->MATRICULA)
				nProvFer   := TRBTR->PROV_FERIAS
				nProv13S   := TRBTR->PROV_13SAL 

			ENDIF						
			TRBTR->(dbskip())
		enddo						
		TRRC2->PROVFERIAS    := nProvFer
		TRRC2->PROV_13SAL    := nProv13S
		TRRC2->TOT_CUSTOS   := ((nProvent - nDescont)+(nProvFer + nProv13S))
		nProvent := 0
		nDescont := 0
		nCusTotal:= 0
		nProvFer := 0
		nProv13S := 0

		MsUnlock()

		DBSELECTAREA("TRBRC")
		TRBRC->(dbskip())
	enddo 

	DBSELECTAREA("TRRC2")
	DBGOTOP()

	cPath	  := cGetFile("","Local"                           ,0,""         ,.T.,GETF_RETDIRECTORY+GETF_LOCALHARD+GETF_LOCALFLOPPY)
	cPath   += IIf( Right( AllTrim( cPath ), 1 ) <> '\' , '\', '' )
	_cARQ   := ALLTRIM(cPath) + "RELATORIO DE CUSTOS " + MV_PAR07 +".XLS" 
	_ARQUIVO := "\system\RELATORIO DE CUSTOS" + MV_PAR07 +".XLS" //NOME DO ARQUIVO

	IF FILE(_ARQUIVO)
		DELETE FILE(_ARQUIVO)
	ENDIF
	COPY TO &_ARQUIVO VIA "DBFCDXADS"
	//direciona o arquivo para o local indicado no local cPath 
	IF FILE(_ARQUIVO)
		COPY FILE &_ARQUIVO TO &_cARQ 
	ENDIF
	//carrega o excel com o arquivo gerado, para isso, colocar o excel no path.

	apmsginfo("ARQUIVO " + _cARQ + " GERADO CORRETAMENTE!!!!")

	If ApOleClient("MsExcel")
		oExcelApp:= MsExcel():New()
		oExcelApp:WorkBooks:Open(ALLTRIM(_cARQ))                        //(ALLTRIM(cPath) + "RELATORIO DE CUSTOS.XLS")  
		oExcelApp:SetVisible(.T.)
	Else
		Alert(OemtoAnsi( "Microsoft Excel nao encontrado !" ))
	EndIf


	dbSelectArea("TRBRC")
	DBCLOSEAREA()
	dbSelectArea("TRRC2")
	DBCLOSEAREA()
	dbSelectArea("TRBTR")
	DBCLOSEAREA() 
	FERASE(_carq+".DBF")

Return ()


Static function f_Perg(cperg) 

	Local aregs		:= {}
	Local i, j		:= 0
	Local cArea := getarea()
	Local cPerg	:= "RELCUSTO  " 


	//          Grupo/Ordem    /Pergunta//                   /Var	/Tipo/Tam/Dec/Pres/GSC/Valid/ Var01      /Def01    /DefSpa01    /DefIng1      /Cnt01/Var02    /Def02   /DefSpa2     /DefIng2           /Cnt02   /Var03 /Def03   /DefSpa3  /DefIng3  /Cnt03 /Var04   /Def04     /Cnt04    /Var05  /Def05	/Cnt05  /XF3
	aadd(aregs, {cperg, "01", "Filial De?				  ", "¿De sucursal ?              ","From Branch ?                 ", "mv_ch1", "C", FWGETTAMFILIAL, 			0, 0, "G", ""						, "mv_par01", "", "", "", "", ""	, ""	, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "XM0"	, "S", "033", ".RHFILDE.", "", ""})
	aadd(aregs, {cperg, "02", "Filial Até?           	  ", "¿A Sucursal ?         	  ","To Branch ?                   ", "mv_ch2", "C", FWGETTAMFILIAL, 			0, 0, "G", "naovazio()"				, "mv_par02", "", "", "", "", ""	, ""	, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "XM0"	, "S", "033", ".RHFILAT.", "", ""})
	aadd(aregs, {cperg, "03", "Matricula De?        	  ", "¿De Matricula ?             ","From Registration ?           ", "mv_ch3", "C", tamsx3("RA_MAT")[1],		0, 0, "G", ""						, "mv_par03", "", "", "", "", ""	, ""	, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SRA"	, "S", ""	, ".RHMATD." , "", ""})
	aadd(aregs, {cperg, "04", "Matricula Até?       	  ", "¿A Matricula ?              ","To Registration ?             ", "mv_ch4", "C", tamsx3("RA_MAT")[1],		0, 0, "G", "naovazio()"				, "mv_par04", "", "", "", "", ""	, ""	, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SRA"	, "S", ""	, ".RHMATA." , "", ""})
	aadd(aregs, {cperg, "05", "Centro de Custo De?        ", "¿De Centro de Costo ?       ","From Cost Center ?            ", "mv_ch5", "C", tamsx3("RA_CC")[1], 		0, 0, "G", ""						, "mv_par05", "", "", "", "", ""	, ""	, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "CTT"	, "S", "004", ".RHCCDE." , "", ""})
	aadd(aregs, {cperg, "06", "Centro de Custo Até?	      ", "¿A Centro de Costo ?        ","To Cost Center ?              ", "mv_ch6", "C", tamsx3("RA_CC")[1], 		0, 0, "G", "naovazio()"				, "mv_par06", "", "", "", "", ""	, ""	, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "CTT"	, "S", "004", ".RHCCAT." , "", ""})
	aadd(aregs, {cperg, "07", "Periodo de?                ", "Periodo de?                 ","Periodo de?                   ", "mv_ch7", "C", 6, 						0, 0, "G", "naovazio()"				, "mv_par07", "", "", "", "", ""	, ""	, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""	, "S", ""	, ""         , "", ""})

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
