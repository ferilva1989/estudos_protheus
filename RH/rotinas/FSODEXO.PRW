#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ FSODEXO บAutor  ณ JORGE SATO          บ Dataณ   04/07/2017 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gera็ใo de Arquivo Sodexo                				  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SIGAGPE - BSL                                              บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                     A L T E R A C O E S                               บฑฑ
ฑฑฬออออออออออหออออออออออออออออออหอออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบData      บProgramador       บAlteracoes                               บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
*/
User Function FSODEXO

	Private bProcesso	:= { |oSelf| f_Proc(oSelf)}
	Private c_perg 		:= padr("FSODEXO", 10)
	Private nHdl    	:= 0
	Private cArqTxt 	:= ""
	Private c_comp 		:= ""

	f_Perg(c_perg)
	Pergunte(c_perg, .F.)	
	tNewProcess():New("FSODEXO", "Sodexo - VT, VR e VA", bProcesso, "    Esta rotina tem por objetivo gerar os arquivos texto referente ao Sodexo conforme parโmetros informados pelo usuแrio.", c_perg, , , , , .T., .T.)

Return

/*
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFun็ใo    ณf_Perg    บAutor  ณ JORGE SATO         บ Dataณ   04/07/2017 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Trata as perguntas da rotina.	          				  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SODEXO                                                     บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                     A L T E R A C O E S                               บฑฑ
ฑฑฬออออออออออหออออออออออออออออออหอออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบData      บProgramador       บAlteracoes                               บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
*/
Static Function f_Perg(cperg)

	Local aregs		:= {}
	Local i, j		:= 0

	//grupo/ordem/pergunta/perg.spa/perg.eng/variavel/tipo/tamanho/decimal/presel/gsc/valid/ var01/def01/def1.spa/def1.eng/cnt01/var02/def02/def1.spa/def1.eng/cnt02/var03/def03/def1.spa/def1.eng/cnt03/var04/def04/def1.spa/def1.eng/cnt04/var05/def05/def1.spa/def1.eng/cnt05/f3/pyme/grpsxg/help/picture/idfil
	aadd(aregs, {cperg, "01", "Filial De				", "ฟDe sucursal ?              ","From Branch ?                 ", "mv_ch1", "C", FWGETTAMFILIAL, 			0, 0, "G", ""						, "mv_par01", "", "", "", "", ""	, ""	, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "XM0"	, "S", "033", ".RHFILDE.", "", ""})
	aadd(aregs, {cperg, "02", "Filial At้           	", "ฟA Sucursal ?         	    ","To Branch ?                   ", "mv_ch2", "C", FWGETTAMFILIAL, 			0, 0, "G", "naovazio()"				, "mv_par02", "", "", "", "", ""	, ""	, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "XM0"	, "S", "033", ".RHFILAT.", "", ""})
	aadd(aregs, {cperg, "03", "Centro de Custo De   	", "ฟDe Centro de Costo ?       ","From Cost Center ?            ", "mv_ch3", "C", tamsx3("RA_CC")[1], 		0, 0, "G", ""						, "mv_par03", "", "", "", "", ""	, ""	, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "CTT"	, "S", "004", ".RHCCDE.", "", ""})
	aadd(aregs, {cperg, "04", "Centro de Custo At้		", "ฟA Centro de Costo ?        ","To Cost Center ?              ", "mv_ch4", "C", tamsx3("RA_CC")[1], 		0, 0, "G", "naovazio()"				, "mv_par04", "", "", "", "", ""	, ""	, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "CTT"	, "S", "004", ".RHCCAT.", "", ""})
	aadd(aregs, {cperg, "05", "Departamento De 			", "ฟDe Depto. ?               	","Department From ?             ", "mv_ch5", "C", tamsx3("RA_DEPTO")[1],	0, 0, "G", ""						, "mv_par05", "", "", "", "", ""	, ""	, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SQB"	, "S", "025", ".RHDPTDE.", "", ""})
	aadd(aregs, {cperg, "06", "Departamento At้			", "ฟA Depto. ?                	","Department To ?               ", "mv_ch6", "C", tamsx3("RA_DEPTO")[1], 	0, 0, "G", "naovazio()"				, "mv_par06", "", "", "", "", ""	, ""	, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SQB"	, "S", "025", ".RHDPTAT.", "", ""})
	aadd(aregs, {cperg, "07", "Matricula De        		", "ฟDe Matricula ?            	","From Registration ?           ", "mv_ch7", "C", tamsx3("RA_MAT")[1],		0, 0, "G", ""						, "mv_par07", "", "", "", "", ""	, ""	, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SRA"	, "S", ""	, ".RHMATD.", "", ""})
	aadd(aregs, {cperg, "08", "Matricula At้       		", "ฟA Matricula ?             	","To Registration ?             ", "mv_ch8", "C", tamsx3("RA_MAT")[1],		0, 0, "G", "naovazio()"				, "mv_par08", "", "", "", "", ""	, ""	, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SRA"	, "S", ""	, ".RHMATA.", "", ""})
	aadd(aregs, {cperg, "09", "Data do Cr้dito			", "Data do Cr้dito		      	","Data do Cr้dito				 ", "mv_ch9", "D", 8, 						0, 0, "G", "naovazio()"				, "mv_par09", "", "", "", "", ""	, ""	, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""	, "S", ""	, "", "", ""})
	aadd(aregs, {cperg, "10", "Diret๓rio de grava็ใo    ", "Diret๓rio de grava็ใo       ","Diret๓rio de grava็ใo         ", "mv_cha", "C", 99,                      0, 0, "G", "U_FGPEM002('FGPEM001')"	, "mv_par10", "", "", "", "", ""	, ""	, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""	, "S", ""	, "", "", ""})
	aadd(aregs, {cperg, "11", "Tipo"				     , "Tipo                        ","Tipo                          ", "mv_chb", "N", 1,                       0, 0, "C",""                        , "mv_par11","Vale Refei็ใo","Vale Refei็ใo","Vale Refei็ใo","","","Vale Aliment.","Vale Aliment.","Vale Aliment.","","","Vale Transporte","Vale Transporte","Vale Transporte","","","","","","","","","","","","","","","","",""})
	aadd(aregs, {cperg, "12", "Categorias	      		", "Categorias	             	","Categorias 			         ", "mv_chc", "C", 15,                 		0, 0, "G", "fCategoria"		    	, "mv_par12", "", "", "", "", ""	, ""	, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""	, "S", ""	, ".RHCATEG.", "", ""})
	aadd(aregs, {cperg, "13", "Situa็๕es	      		", "Situa็๕es	             	","Situa็๕es 			         ", "mv_chd", "C", 5,                 		0, 0, "G", "fSituacao"				, "mv_par13", "", "", "", "", ""	, ""	, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""	, "S", ""	, ".RHSITUA.", "", ""})
	aadd(aregs, {cperg, "14", "Codigo da Empresa - Sodexo", "Codigo da Empresa - Sodexo ","Codigo da Empresa - Sodexo    ", "mv_che", "C", 8,                       0, 0, "G", ""						, "mv_par14", "", "", "", "", ""	, ""	, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""	, "S", ""	, "", "", ""})
	aadd(aregs, {cperg, "15", "Cod. Departamento - Sodexo", "Cod. Departamento - Sodexo ","Cod. Departamento - Sodexo    ", "mv_chf", "C", 18,                      0, 0, "G", ""						, "mv_par15", "", "", "", "", ""	, ""	, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""	, "S", ""	, "", "", ""})
	aadd(aregs, {cperg, "16", "Nome Departamento - Sodexo", "Nome Departamento - Sodexo ","Nome Departamento - Sodexo    ", "mv_chg", "C", 35,                      0, 0, "G", ""						, "mv_par16", "", "", "", "", ""	, ""	, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""	, "S", ""	, "", "", ""})	
	aadd(aregs, {cperg, "17", "Responsavel Depart. - Sodexo", "Responsavel Depart. - Sodexo","Responsavel Depart. - Sodexo", "mv_chh","C", 20,                     0, 0, "G", ""						, "mv_par17", "", "", "", "", ""	, ""	, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""	, "S", ""	, "", "", ""})

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

Return

/*
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFun็ใo    ณf_Proc    บAutor  ณ JORGE SATO         บ Dataณ   04/07/2017 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Processamento.					          				  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SODEXO	                                                  บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                     A L T E R A C O E S                               บฑฑ
ฑฑฬออออออออออหออออออออออออออออออหอออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบData      บProgramador       บAlteracoes                               บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
*/
Static Function f_Proc(oSelf)


	Local n_totreg 	:= 0
	Local c_datag	:= ""
	Local c_diag	:= ""
	Local c_mesg	:= ""
	Local c_anog	:= ""
	Local c_datac	:= ""
	Local c_diac	:= ""
	Local c_mesc	:= ""
	Local c_anoc	:= ""
	Local c_prod	:= ""
	Local c_forma	:= ""
	Local c_reg0	:= ""
	Local c_reg3	:= ""
	Local c_reg4	:= ""
	Local c_reg9	:= ""
	Local l_exper	:= .F.
	Local l_ponto	:= .F.
	Local n_vlalim	:= 0
	Local n_vlref	:= 0
	Local c_tiplog	:= ""	
	Local c_desclog	:= ""
	Local c_numlog	:= "" 
	Local nContador := 0
	Local nContad1  := 0
	Local nSalta	:= 0
	Local cMatAnt	:= ""
	Private nHdl    := 0


	if mv_par11 == 1 .or. mv_par11 == 3 //VR ou VT		
		c_comp := substr(dtos(mv_par09), 5, 2) + substr(dtos(mv_par09), 1, 4)
	else
		if mv_par11 == 2 //VA
			c_comp := substr(dtos(mv_par09), 5, 2) + substr(dtos(mv_par09), 1, 4)
		endif
	endif


	if f_Arq()
		if mv_par11 == 1 .or. mv_par11 == 2 //sodexo VR ou VA
			c_datag	:= dtoc(date())
			c_diag	:= substr(c_datag, 1, 2)
			c_mesg	:= substr(c_datag, 4, 2)
			c_anog	:= substr(c_datag, 7, 4)
			c_datac	:= dtoc(mv_par09)
			c_diac	:= substr(c_datac, 1, 2)
			c_mesc	:= substr(c_datac, 4, 2)
			c_anoc	:= substr(c_datac, 7, 4)
			do case
				case mv_par11 == 1 //VR		
				c_prod 	:= "001"
				c_forma	:= "002"
				case mv_par11 == 2 //VA		
				c_prod 	:= "002"
				c_forma	:= "004" 

			endcase

			//REGISTRO TIPO 0
			c_reg0 := "0"
			c_reg0 += strzero(val(mv_par14), 8)
			c_reg0 += padr(alltrim(FWFilRazSocial()), 40)
			c_reg0 += space(6)
			c_reg0 += c_comp
			c_reg0 += "005"
			c_reg0 += "001"
			c_reg0 += space(1)
			c_reg0 += c_diag + c_mesg + c_anog
			c_reg0 += c_diac + c_mesc + c_anoc
			c_reg0 += c_diac + c_mesc + c_anoc
			c_reg0 += CRLF
			If fWrite(nHdl, c_reg0, Len(c_reg0)) != Len(c_reg0)
				aviso(alltrim(SM0->M0_NOMECOM) + " - GPE","Erro na grava็ใo do arquivo. Processamento abortado.",{"OK"},2,"Problema")
				Return
			Endif
			//FIM

			//REGISTRO TIPO 3
			c_reg3 := "3"
			c_reg3 += space(6)
			c_reg3 += upper(padr(alltrim(mv_par15), 18))
			c_reg3 += space(12)
			c_reg3 += upper(padr(alltrim(mv_par16), 35))
			c_reg3 += space(5)
			c_reg3 += upper(padr(alltrim(mv_par17), 20))
			c_reg3 += space(14)

			dbselectarea("SM0")
			dbsetorder(1)
			if dbseek(cEmpAnt + mv_par01)				
				nContador   := At(" ",SM0->M0_ENDCOB)
				c_tiplog:= padr(alltrim(substr(SM0->M0_ENDCOB, 1, nContador -1)), 6)
				c_tiplog := upper(padr(c_tiplog, 6))
				nContad1 := At(",",SM0->M0_ENDCOB)	
				c_desclog := alltrim(substr(SM0->M0_ENDCOB, nContador +1,(nContad1 - nContador)-1))
				c_desclog := upper(padr(c_desclog, 40))
				c_numlog := alltrim(substr(SM0->M0_ENDCOB, nContad1 +1,8))
				c_numlog := upper(padr(c_numlog, 8))
			endif						
			c_reg3 += c_tiplog + c_desclog + c_numlog
			c_reg3 += upper(padr(alltrim(substr(SM0->M0_COMPCOB, 1, 20)), 20))
			c_reg3 += upper(padr(alltrim(substr(SM0->M0_BAIRCOB, 1, 15)), 15))
			c_reg3 += space(5)
			c_reg3 += upper(padr(alltrim(substr(SM0->M0_CIDCOB, 1, 20)), 20))
			c_reg3 += space(10)
			c_reg3 += upper(padr(alltrim(substr(SM0->M0_ESTCOB, 1, 2)), 2))
			c_reg3 += padr(alltrim(substr(SM0->M0_CEPCOB, 1, 8)), 8)
			c_reg3 += space(384)
			c_reg3 += CRLF
			If fWrite(nHdl, c_reg3, Len(c_reg3)) != Len(c_reg3)
				aviso(alltrim(SM0->M0_NOMECOM) + " - GPE","Erro na grava็ใo do arquivo. Processamento abortado.",{"OK"},2,"Problema")
				Return
			Endif
			//FIM		

			//REGISTRO TIPO 4				
			TCQUERY f_Qry() NEW ALIAS "QRY"

			dbselectarea("QRY")
			Count To n_totreg
			oSelf:SetRegua1(n_totreg)

			QRY->(dbgotop())
			while QRY->(!eof())

				c_reg4 := "4"
				c_reg4 += space(36)
				c_reg4 += strzero(val(QRY->RA_MAT), 10)
				c_reg4 += padr(alltrim(substr(QRY->RA_NOME, 1, 40)), 40)
				c_reg4 += space(1)
				c_reg4 += substr(QRY->RA_NASC, 7, 2) + substr(QRY->RA_NASC, 5, 2) + substr(QRY->RA_NASC, 1, 4) 
				c_reg4 += QRY->RA_CIC
				c_reg4 += QRY->RA_SEXO
				c_reg4 += c_prod
				c_reg4 += c_forma
				c_reg4 += replicate("0", 5)
				c_reg4 += replicate("0", 2)
				c_reg4 += Strzero(QRY->R0_VALCAL*100,12)
				c_reg4 += CRLF
				If fWrite(nHdl, c_reg4, Len(c_reg4)) != Len(c_reg4)
					aviso(alltrim(SM0->M0_NOMECOM) + " - GPE","Erro na grava็ใo do arquivo. Processamento abortado.",{"OK"},2,"Problema")
					Return
				Endif

				QRY->(dbskip())
			enddo
			dbselectarea("QRY")
			dbclosearea()
			//FIM

			//REGISTRO TIPO 9
			c_reg9 := "9"
			c_reg9 += CRLF
			If fWrite(nHdl, c_reg9, Len(c_reg9)) != Len(c_reg9)
				aviso(alltrim(SM0->M0_NOMECOM) + " - GPE","Erro na grava็ใo do arquivo. Processamento abortado.",{"OK"},2,"Problema")
				Return
			Endif
			//FIM
		else
			if mv_par11 == 3 // VT

				c_datag	:= dtoc(date())
				c_diag	:= substr(c_datag, 1, 2)
				c_mesg	:= substr(c_datag, 4, 2)
				c_anog	:= substr(c_datag, 7, 4)
				c_datac	:= dtoc(mv_par09)
				c_diac	:= substr(c_datac, 1, 2)
				c_mesc	:= substr(c_datac, 4, 2)
				c_anoc	:= substr(c_datac, 7, 4)
				c_prod 	:= "007"
				c_forma	:= "002"					


				//REGISTRO TIPO 0
				c_reg0 := "0"
				c_reg0 += strzero(val(mv_par14), 8)
				c_reg0 += padr(alltrim(FWFilRazSocial()), 40)
				c_reg0 += space(6)
				c_reg0 += c_comp
				c_reg0 += "005"
				c_reg0 += "001"
				c_reg0 += space(1)
				c_reg0 += c_diag + c_mesg + c_anog
				c_reg0 += c_diac + c_mesc + c_anoc
				c_reg0 += c_diac + c_mesc + c_anoc
				c_reg0 += CRLF
				If fWrite(nHdl, c_reg0, Len(c_reg0)) != Len(c_reg0)
					aviso(alltrim(SM0->M0_NOMECOM) + " - GPE","Erro na grava็ใo do arquivo. Processamento abortado.",{"OK"},2,"Problema")
					Return
				Endif
				//FIM

				//REGISTRO TIPO 3
				c_reg3 := "3"
				c_reg3 += space(6)
				c_reg3 += upper(padr(alltrim(mv_par15), 18))
				c_reg3 += space(12)
				c_reg3 += upper(padr(alltrim(mv_par16), 35))
				c_reg3 += space(5)
				c_reg3 += upper(padr(alltrim(mv_par17), 20))
				c_reg3 += space(14)

				dbselectarea("SM0")
				dbsetorder(1)
				if dbseek(cEmpAnt + mv_par01)				
					nContador   := At(" ",SM0->M0_ENDCOB)
					c_tiplog:= padr(alltrim(substr(SM0->M0_ENDCOB, 1, nContador -1)), 6)
					c_tiplog := upper(padr(c_tiplog, 6))
					nContad1 := At(",",SM0->M0_ENDCOB)	
					c_desclog := alltrim(substr(SM0->M0_ENDCOB, nContador +1,(nContad1 - nContador)-1))
					c_desclog := upper(padr(c_desclog, 40))
					c_numlog := alltrim(substr(SM0->M0_ENDCOB, nContad1 +1,8))
					c_numlog := upper(padr(c_numlog, 8))
				endif						
				c_reg3 += c_tiplog + c_desclog + c_numlog
				c_reg3 += upper(padr(alltrim(substr(SM0->M0_COMPCOB, 1, 20)), 20))
				c_reg3 += upper(padr(alltrim(substr(SM0->M0_BAIRCOB, 1, 15)), 15))
				c_reg3 += space(5)
				c_reg3 += upper(padr(alltrim(substr(SM0->M0_CIDCOB, 1, 20)), 20))
				c_reg3 += space(10)
				c_reg3 += upper(padr(alltrim(substr(SM0->M0_ESTCOB, 1, 2)), 2))
				c_reg3 += padr(alltrim(substr(SM0->M0_CEPCOB, 1, 8)), 8)
				c_reg3 += space(384)
				c_reg3 += CRLF
				If fWrite(nHdl, c_reg3, Len(c_reg3)) != Len(c_reg3)
					aviso(alltrim(SM0->M0_NOMECOM) + " - GPE","Erro na grava็ใo do arquivo. Processamento abortado.",{"OK"},2,"Problema")
					Return
				Endif
				//FIM		

				//REGISTRO TIPO 4				
				TCQUERY f_Qry() NEW ALIAS "QRY"

				dbselectarea("QRY")
				Count To n_totreg
				oSelf:SetRegua1(n_totreg)

				QRY->(dbgotop())
				while QRY->(!eof())
					cMatAnt:= QRY->RA_MAT
					c_reg4 := "4"
					c_reg4 += space(36)
					c_reg4 += strzero(val(QRY->RA_MAT), 10)
					c_reg4 += padr(alltrim(substr(QRY->RA_NOME, 1, 40)), 40)
					c_reg4 += space(1)
					c_reg4 += substr(QRY->RA_NASC, 7, 2) + substr(QRY->RA_NASC, 5, 2) + substr(QRY->RA_NASC, 1, 4) 
					c_reg4 += QRY->RA_CIC
					c_reg4 += QRY->RA_SEXO
					c_reg4 += c_prod
					c_reg4 += c_forma
					c_reg4 += replicate("0", 5)
					c_reg4 += replicate("0", 2)
					c_reg4 += replicate("0", 12)                          //Strzero(QRY->R0_VALCAL*100,12)
					c_reg4 += replicate("0", 14)
					c_reg4 += space(24)
					c_reg4 += replicate("0", 2)
					c_reg4 += space(68)
					c_reg4 += strzero(val(QRY->RA_RG), 10)
					c_reg4 += space(2)
					c_reg4 += QRY->RA_RGUF  
					c_reg4 += substr(QRY->RA_DTRGEXP, 7, 2) + substr(QRY->RA_DTRGEXP, 5, 2) + substr(QRY->RA_DTRGEXP, 1, 4)
					c_reg4 += QRY->RA_RGEXP
					c_reg4 += space(14)
					c_reg4 += padr(alltrim(substr(QRY->RA_LOGRTP, 1, 6)), 6)
					c_reg4 += padr(alltrim(substr(QRY->RA_LOGRDSC, 1, 40)), 40)
					c_reg4 += strzero(val(QRY->RA_LOGRNUM), 7)   
					c_reg4 += padr(alltrim(substr(QRY->RA_COMPLEM, 1, 15)), 20) 
					c_reg4 += padr(alltrim(substr(QRY->RA_BAIRRO, 1, 15)), 15)
					c_reg4 += space(5) 
					nSalta := At(" ",QRY->RA_MUNICIP)
					c_reg4 += padr(alltrim(substr(QRY->RA_MUNICIP,nSalta + 1, 20)), 20) 
					c_reg4 += space(10)
					c_reg4 += QRY->RA_ESTADO
					c_reg4 += QRY->RA_CEP 
					c_reg4 += padr(alltrim(substr(QRY->RA_MAE, 1, 40)), 40)
					c_reg4 += QRY->RA_ESTCIVI
					c_reg4 += padr(alltrim(substr(QRY->RA_EMAIL, 1, 50)), 50)
					c_reg4 += replicate("0", 4)
					c_reg4 += replicate("0", 8)
					c_reg4 += padr(alltrim(substr(QRY->RJ_DESC, 1, 20)), 40)
					c_reg4 += space(16)
					c_reg4 += space(128)  
					c_reg4 += strzero(QRY->R0_DIASPRO, 3)   
					c_reg4 += QRY->RFP_CDOPSX 
					c_reg4 += QRY->RFP_LINHSX
					c_reg4 += strzero(QRY->R0_QDIAINF,4)
					c_reg4 += replicate("0", 11)//R0_VLRVALE
					c_reg4 += space(16)
					c_reg4 += replicate("0", 4)  //QRY->RFP_CDOPSX 
					c_reg4 += replicate("0", 5) //QRY->RFP_LINHSX
					c_reg4 += replicate("0", 4)  //strzero(QRY->R0_QDIAINF,4)
					c_reg4 += replicate("0", 11)//R0_VLRVALE
					c_reg4 += space(16)
					c_reg4 += replicate("0", 4)  //QRY->RFP_CDOPSX 
					c_reg4 += replicate("0", 5) //QRY->RFP_LINHSX
					c_reg4 += replicate("0", 4)  //strzero(QRY->R0_QDIAINF,4)
					c_reg4 += replicate("0", 11)//R0_VLRVALE
					c_reg4 += space(16)
					c_reg4 += replicate("0", 4)  //QRY->RFP_CDOPSX 
					c_reg4 += replicate("0", 5) //QRY->RFP_LINHSX
					c_reg4 += replicate("0", 4)  //strzero(QRY->R0_QDIAINF,4)
					c_reg4 += replicate("0", 11)//R0_VLRVALE
					c_reg4 += space(16)
					c_reg4 += replicate("0", 4)  //QRY->RFP_CDOPSX 
					c_reg4 += replicate("0", 5) //QRY->RFP_LINHSX
					c_reg4 += replicate("0", 4)  //strzero(QRY->R0_QDIAINF,4)
					c_reg4 += replicate("0", 11)//R0_VLRVALE
					c_reg4 += space(16)
					c_reg4 += space(94)  				
					c_reg4 += CRLF
					If fWrite(nHdl, c_reg4, Len(c_reg4)) != Len(c_reg4)
						aviso(alltrim(SM0->M0_NOMECOM) + " - GPE","Erro na grava็ใo do arquivo. Processamento abortado.",{"OK"},2,"Problema")
						Return
					Endif

					QRY->(dbskip())
				enddo
				dbselectarea("QRY")
				dbclosearea()
				//FIM

				//REGISTRO TIPO 9
				c_reg9 := "9"
				c_reg9 += CRLF
				If fWrite(nHdl, c_reg9, Len(c_reg9)) != Len(c_reg9)
					aviso(alltrim(SM0->M0_NOMECOM) + " - GPE","Erro na grava็ใo do arquivo. Processamento abortado.",{"OK"},2,"Problema")
					Return
				Endif		
			endif
		endif

		aviso(alltrim(SM0->M0_NOMECOM) + " - GPE","Processamento finalizado.",{"OK"},2,"Aviso")
		fClose(nHdl)	
	endif

Return

/*
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFun็ใo    ณf_Arq 	บAutor  ณ JORGE SATO         บ Dataณ   04/07/2017 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Define o nome do arquivo e chama a fun็ใo de cria็ใo.	  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SODEXO                                                     บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                     A L T E R A C O E S                               บฑฑ
ฑฑฬออออออออออหออออออออออออออออออหอออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบData      บProgramador       บAlteracoes                               บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
*/
Static Function f_Arq()

	Local l_ret	:= .F.

	do case
		case mv_par11 == 1 //VR		
		cArqTxt := "SDXV5_" + strzero(val(mv_par14), 8) + "_VR" + c_comp + ".TXT"
		case mv_par11 == 2 //VA		
		cArqTxt := "SDXV5_" + strzero(val(mv_par14), 8) + "_VA" + c_comp + ".TXT"			
		case mv_par11 == 3 //VT		
		cArqTxt := "SDXV5_" + strzero(val(mv_par14), 8) + "_VT" + c_comp + ".TXT"
	endcase

	cArqTxt := alltrim(mv_par10) + cArqTxt
	if file(cArqTxt)
		if aviso(alltrim(SM0->M0_NOMECOM) + " - GPE","Arquivo " + upper(cArqTxt) + " jแ existe. Deseja sobrepor?",{"Sim", "Nใo"},2,"Aviso") == 1
			l_ret := f_CriArq()
		endif
	else
		l_ret := f_CriArq()		
	endif

Return(l_ret)

/*
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFun็ใo    ณf_CriArq  บAutor  ณ JORGE SATO         บ Dataณ   04/07/2017 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Trata a cria็ใo do arquivo.				 				  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SODEXO	                                                  บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                     A L T E R A C O E S                               บฑฑ
ฑฑฬออออออออออหออออออออออออออออออหอออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบData      บProgramador       บAlteracoes                               บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
*/
Static Function f_CriArq()

	Local n_cod	:= 0
	Local c_msg	:= ""
	Local l_ret	:= .F.

	nHdl 	:= fCreate(cArqTxt)
	n_cod	:= fError()
	if nHdl == -1
		c_msg := "Erro na cria็ใo do arquivo. Verifique se hแ espa็o disponํvel e se voc๊ tem acesso de grava็ใo." + CRLF + CRLF
		c_msg += "Detalhes do erro:" + CRLF
		do case
			case n_cod == 2
			c_msg += "Arquivo nใo encontrado."
			case n_cod == 3
			c_msg += "Diret๓rio nใo encontrado."
			case n_cod == 4
			c_msg += "Muitos arquivos foram abertos. Verifique o parโmetro FILES."
			case n_cod == 5
			c_msg += "Impossํvel acessar o arquivo."
			case n_cod == 6
			c_msg += "N๚mero de manipula็ใo de arquivo invแlido.'
			case n_cod == 8
			c_msg += "Mem๓ria insuficiente."
			case n_cod == 15
			c_msg += "Acionador (Drive) de discos invแlido."
			case n_cod == 19
			c_msg += "Tentativa de gravar sobre um disco protegido contra escrita."
			case n_cod == 21
			c_msg += "Acionador (Drive) de discos inoperante."
			case n_cod == 23
			c_msg += "Erro de dados no disco."
			case n_cod == 29
			c_msg += "Erro de grava็ใo no disco."
			case n_cod == 30
			c_msg += "Erro de leitura no disco."
			case n_cod == 32
			c_msg += "Viola็ใo de compartilhamento."
			case n_cod == 33
			c_msg += "Viola็ใo de bloqueio."
		endcase
		aviso(alltrim(SM0->M0_NOMECOM) + " - GPE",c_msg,{"OK"},2,"Problema")
	else
		l_ret := .T. 
	endif

Return(l_ret)

/*
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑบFun็ใo    ณf_Qry             ณ JORGE SATO         บ Dataณ   04/07/2017 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Monta a query principal.                             	  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SODEXO	                                                  บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                     A L T E R A C O E S                               บฑฑ
ฑฑฬออออออออออหออออออออออออออออออหอออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบData      บProgramador       บAlteracoes                               บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
*/
Static Function f_Qry()

	Local c_ret 	:= ""
	Local n_cont	:= 0

	c_ret := "SELECT SRA.RA_FILIAL, SRA.RA_MAT, SRA.RA_NOME, SRA.RA_NASC, SRA.RA_CIC, SRA.RA_SEXO, SRA.RA_ADMISSA," + CRLF 
	IF mv_par11 == 3 
		c_ret += " SRA.RA_RG, SRA.RA_RGUF, SRA.RA_DTRGEXP, SRA.RA_RGEXP, SRA.RA_LOGRTP, SRA.RA_LOGRDSC, SRA.RA_LOGRNUM," + CRLF
		c_ret += " SRA.RA_COMPLEM, SRA.RA_BAIRRO, SRA.RA_MUNICIP, SRA.RA_ESTADO, SRA.RA_CEP, SRA.RA_MAE," + CRLF
		c_ret += " CASE SRA.RA_ESTCIVI, WHEN 'C' THEN 'C' WHEN 'D' THEN 'D' WHEN 'M' THEN 'U' WHEN 'Q' THEN 'E' WHEN 'S' THEN 'S' WHEN 'V' THEN 'V' END SRA.RA_ESTCIVI," + CRLF
		c_ret += " SRA.RA_EMAIL, SRJ.RJ_DESC, SR0.R0_DIASPRO, SR0.R0_QDIAINF," + CRLF 
		c_ret += " RFP.RFP_PRODSX, RFP.RFP_FORMSX, RFP.RFP_CDOPSX, RFP.RFP_LINHSX," + CRLF
	ENDIF	 	     	 
	c_ret += " SR0.R0_TPVALE, SR0.R0_CODIGO, SR0.R0_DIASPRO, SR0.R0_QDIACAL, SR0.R0_VALCAL, SR0.R0_VLRVALE" + CRLF

	c_ret += " FROM " + retsqlname("SRA") + " SRA INNER JOIN " + retsqlname("SR0") + " SR0 ON (SR0.R0_FILIAL = RA_FILIAL AND SR0.R0_MAT = RA_MAT)" + CRLF 
	IF mv_par11 == 3
		c_ret += " INNER JOIN " + retsqlname("RFP") + " RFP ON (RFP_FILIAL = SUBSTRING(R0_FILIAL,1,2) AND RFP_TPVALE = R0_TPVALE AND RFP_CODIGO = R0_CODIGO)" + CRLF
		c_ret += " INNER JOIN " + retsqlname("SRJ") + " SRJ ON (RJ_FUNCAO = RA_CODFUNC)" + CRLF
	ENDIF		
	c_ret += " WHERE SRA.D_E_L_E_T_ <> '*' AND SR0.D_E_L_E_T_ <> '*'" + CRLF        
	IF mv_par11 == 3
		c_ret += " AND SRJ.D_E_L_E_T_ <> '*' AND RFP.D_E_L_E_T_ <> '*'" + CRLF   
	ENDIF
	c_ret += " AND SRA.RA_FILIAL >= '" + mv_par01 + "' AND SRA.RA_FILIAL <= '" + mv_par02 + "' " + CRLF 
	c_ret += " AND SRA.RA_CC >= '" + mv_par03 + "' AND SRA.RA_CC <= '" + mv_par04 + "' " + CRLF 
	c_ret += " AND SRA.RA_DEPTO	>= '" + mv_par05 + "' AND SRA.RA_DEPTO <= '" + mv_par06 + "' " + CRLF 
	c_ret += " AND SRA.RA_MAT >= '" + mv_par07 + "' AND SRA.RA_MAT <= '" + mv_par08 + "' " + CRLF 
	c_ret += " AND SR0.R0_VALCAL > 0" + CRLF
	c_ret += " AND "

	do case
		case mv_par11 == 1 //VR
		c_ret += "SR0.R0_TPVALE = 1" + CRLF
		case mv_par11 == 2 //VA
		c_ret += "SR0.R0_TPVALE = 2" + CRLF
		case mv_par11 == 3 //VT
		c_ret += "SR0.R0_TPVALE = 0" + CRLF
	endcase

	c_ret += " AND SRA.RA_CATFUNC 	IN ("
	for n_cont := 1 to len(mv_par12)
		c_ret += "'" + substr(mv_par12, n_cont, 1) + "', " 
	next
	c_ret := substr(c_ret, 1, len(c_ret) - 2) + ")" + CRLF

	c_ret += " AND SRA.RA_SITFOLH 	IN ("			
	for n_cont := 1 to len(mv_par13)
		c_ret += "'" + substr(mv_par13, n_cont, 1) + "', " 
	next			
	c_ret := substr(c_ret, 1, len(c_ret) - 2) + ")" + CRLF

	c_ret += " ORDER BY SR0.R0_TPVALE, SRA.RA_FILIAL, SRA.RA_MAT"

Return(c_ret)

