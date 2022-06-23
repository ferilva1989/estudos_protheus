#Include 'Protheus.ch'
#INCLUDE 'TOPConn.ch'

//declaração das variáveis que serão impressas no relatório
Static  cFuncNom
Static __cNome
Static __cMat
Static __dAdmissao
Static __cCargo
Static __cCusto
Static __cCCDesc
Static __nSalHora
Static __nQtdHorasTrab
Static __nQtdFolgRenum
Static __nQtdHExtra
Static __nQtdAddNot
Static __nSalario
Static __nTotSal
Static __ValExtra
Static __nAddInsalub
Static __nAddNoturno
Static __nSalFamilia
Static __nAuxCreche
Static __nCompraVR
Static __nDescVR
Static __nValorCompraVA
Static __nValorTotalCompraVT
Static __nDescontoVT
Static __nCustoAssMedica
Static __nFGTS
Static __nINSS
Static __nProvFerias
Static __nPAdicFerias
Static __n13PrvFeria
Static __nPrINSSFer
Static __nPrFGTSFer
Static __nProvAcumulada
Static __nProv13
Static __nAdicional13
Static __nProvINSS13
Static __nProvFGTS13
Static __nAcumulada13Prov

Static DatDe
Static DatAte
Static cAnoMesI
Static cAnoMesF

/*/{Protheus.doc} RelCusFolha
Relatório de Custo da Folha
@type function
@author Fernando Carvalho
@since 11/12/2017
@version 1.0  //	U_RelCusFolha()
/*/

User Function RelCusFol()

	Local oReport
	Local oSection

	If Pergunte("FSWRELCUST",.t.)

		oReport:= TReport():New("FSWRELCUST","Relatorio Custo Folha","FSWRELCUST" , {|oReport| PrintReport(oReport)},"Relatorio Custo Folha")

		oSection := TRSection():New(oReport	,"Custo Folha",{"SRA"},/*Ordem*/)
		TRCell():New(oSection,"RA_FILIAL"				,"SRA" ,"Filial"	/*Titulo*/	,/*Picture*/		,TAMSX3("RA_FILIAL")[1] ,			,{||cRAFilial})
		TRCell():New(oSection,"RA_MAT"					,"SRA" ,"Matricula"/*Titulo*/	,/*Picture*/		,TAMSX3("RA_MAT")[1]	,			,{||__cMat})
		TRCell():New(oSection,"RA_NOME"					,"SRA" ,"Nome"/*Titulo*/		,/*Picture*/		,TAMSX3("RA_NOME")[1]	,			,{||__cNome})
		TRCell():New(oSection,"RA_ADMISSA"				,"SRA" ,"Admissao"/*Titulo*/	,/*Picture*/		,TAMSX3("RA_ADMISSA")[1],			,{||__dAdmissao})
		TRCell():New(oSection,"RJ_DESC"					,"SRJ" ,"Cargo"/*Titulo*/		,/*Picture*/		,TAMSX3("RJ_DESC")[1]	,			,{||__cCargo})
		TRCell():New(oSection,"CTT_CUSTO"				,"CTT" ,"Centro Custo"/*Titulo*/,/*Picture*/		,TAMSX3("CTT_CUSTO")[1]	,			,{||__cCusto})
		TRCell():New(oSection,"CTT_DESC01"				,"CTT" ,"Descricao CC"/*Titulo*/,/*Picture*/		,TAMSX3("CTT_DESC01")[1],			,{||__cCCDesc})
		TRCell():New(oSection,"Sal/Hora"				,""    ,"Salar/hora"			,'@E 99,999.9999'	,14						,/*lPixel*/,{|| __nSalHora })
		TRCell():New(oSection,"Hora Trabal"				,""    ,"Horas Trabalhada"		,'@E 99,999.9999'	,14						,/*lPixel*/,{|| __nQtdHorasTrab })
		TRCell():New(oSection,"Folga Renum"				,""    ,"Folga Renumerada"		,'@E 99,999.9999'	,14						,/*lPixel*/,{|| __nQtdFolgRenum })
		TRCell():New(oSection,"Hora Extra"				,""    ,"Hora Extra"			,'@E 99,999.9999'	,14						,/*lPixel*/,{|| __nQtdHExtra })
		TRCell():New(oSection,"Adic Noturn"				,""    ,"Adic Noturno"			,'@E 99,999.9999'	,14						,/*lPixel*/,{|| __nQtdAddNot })
		TRCell():New(oSection,"Salario"					,""    ,"Salario"				,'@E 99,999.9999'	,14						,/*lPixel*/,{|| __nSalario })
		TRCell():New(oSection,"Val Extra"				,""    ,"Valor H. Extra"		,'@E 99,999.9999'	,14						,/*lPixel*/,{|| __ValExtra })
		TRCell():New(oSection,"Adic Salubridade"		,""    ,"Adic Salubridade"		,'@E 99,999.9999'	,14						,/*lPixel*/,{|| __nAddInsalub })
		TRCell():New(oSection,"Vlr Adic Noturno"		,""    ,"Vlr Adic Noturno"		,'@E 99,999.9999'	,14						,/*lPixel*/,{|| __nAddNoturno })
		TRCell():New(oSection,"Salario Famila"			,""    ,"Salario Famila"		,'@E 99,999.9999'	,14						,/*lPixel*/,{|| __nSalFamilia })
		TRCell():New(oSection,"Aux Creche"				,""    ,"Aux Creche"			,'@E 99,999.9999'	,14						,/*lPixel*/,{|| __nAuxCreche })
		TRCell():New(oSection,"Compra VR"				,""    ,"Compra VR"				,'@E 99,999.9999'	,14						,/*lPixel*/,{|| __nCompraVR })
		TRCell():New(oSection,"Desconto VR"				,""    ,"Desconto VR"			,'@E 99,999.9999'	,14						,/*lPixel*/,{|| __nDescVR })
		TRCell():New(oSection,"Valor Compra VR"			,""    ,"Valor Compra VA"		,'@E 99,999.9999'	,14						,/*lPixel*/,{|| __nValorCompraVA })
		TRCell():New(oSection,"Valor Total VR"			,""    ,"Valor Total VT"		,'@E 99,999.9999'	,14						,/*lPixel*/,{|| __nValorTotalCompraVT })
		TRCell():New(oSection,"Desconto VT"				,""    ,"Desconto VT"			,'@E 99,999.9999'	,14						,/*lPixel*/,{|| __nDescontoVT })
		TRCell():New(oSection,"Custo Ass Medica"		,""    ,"Custo Ass Medica"		,'@E 99,999.9999'	,14						,/*lPixel*/,{|| __nCustoAssMedica })
		TRCell():New(oSection,"FGTS"					,""    ,"FGTS"					,'@E 99,999.9999'	,14						,/*lPixel*/,{|| __nFGTS })
		TRCell():New(oSection,"INSS"					,""    ,"INSS"					,'@E 99,999.9999'	,14						,/*lPixel*/,{|| __nINSS })
		TRCell():New(oSection,"Prov Ferias"				,""    ,"Prov Ferias"			,'@E 99,999.9999'	,14						,/*lPixel*/,{|| __nProvFerias })
		TRCell():New(oSection,"Prov Adic Ferias"		,""    ,"Prov Adic Ferias"		,'@E 99,999.9999'	,14						,/*lPixel*/,{|| __nPAdicFerias })
		TRCell():New(oSection,"Prov 1/3 ferias"			,""    ,"Prov 1/3 ferias"		,'@E 99,999.9999'	,14						,/*lPixel*/,{|| __n13PrvFeria })
		TRCell():New(oSection,"Prov INSS Ferias"		,""    ,"Prov INSS Ferias"		,'@E 99,999.9999'	,14						,/*lPixel*/,{|| __nPrINSSFer })
		TRCell():New(oSection,"Prov FGTS Ferias"		,""    ,"Prov FGTS Ferias"		,'@E 99,999.9999'	,14						,/*lPixel*/,{|| __nPrFGTSFer })
		TRCell():New(oSection,"Prov Ferias Acumulada"	,""    ,"Prov Ferias Acumulada"	,'@E 99,999.9999'	,14						,/*lPixel*/,{|| __nProvAcumulada })
		TRCell():New(oSection,"Prov 13º"				,""    ,"Prov 13º"				,'@E 99,999.9999'	,14						,/*lPixel*/,{|| __nProv13 })
		TRCell():New(oSection,"Prov Adic 13º"			,""    ,"Prov Adic 13º"			,'@E 99,999.9999'	,14						,/*lPixel*/,{|| __nAdicional13 })
		TRCell():New(oSection,"Prov INSS 13º"			,""    ,"Prov INSS 13º"			,'@E 99,999.9999'	,14						,/*lPixel*/,{|| __nProvINSS13 })
		TRCell():New(oSection,"Prov FGTS 13º"			,""    ,"Prov FGTS 13º"			,'@E 99,999.9999'	,14						,/*lPixel*/,{|| __nProvFGTS13 })
		TRCell():New(oSection,"Prov 13º Acumulado"		,""    ,"Prov 13º Acumulado"	,'@E 99,999.9999'	,14						,/*lPixel*/,{|| __nAcumulada13Prov })
		TRCell():New(oSection,"RA_NOME"					,"SRA" ,"Nome"/*Titulo*/		,/*Picture*/		,TAMSX3("RA_NOME")[1]	,			,{||cFuncNom})

		oReport:PrintDialog()
	EndIf
Return

Static Function PrintReport(oReport)
	Local cWhere := "%"

	DatDe    		:= MV_PAR07					//Data De             ?
	DatAte   		:= MV_PAR08					//Data Ate            ?
	cAnoMesI 		:= SubStr(DTOS(DatDe),1,4) + SubStr(DTOS(DatDe),5,2)
	cAnoMesF 		:= SubStr(DTOS(DatAte),1,4) + SubStr(DTOS(DatAte),5,2)

	#IFDEF TOP
	cAliasDiv := GetNextAlias()
	MakeSqlExp("REPORT")

	BEGIN REPORT QUERY oReport:Section(1)

		BeginSql alias cAliasDiv//cAliasDiv
			column DS_EMISSA as Date
			SELECT
			RA.RA_FILIAL,RA.RA_MAT,RA.RA_NOME,RA.RA_ADMISSA,RA.RA_CARGO,RA.RA_CODFUNC,RA.RA_CC,RA.RA_CATFUNC,RA.RA_CATEG,RA.RA_SALARIO,RA.RA_HRSMES,RA.RA_SITFOLH
			,RJ.RJ_FUNCAO,RJ.RJ_DESC
			,CTT.CTT_CUSTO,CTT.CTT_DESC01
			,RD.RD_FILIAL, RD.RD_PD,RD.RD_HORAS,RD.RD_VALOR,RD.RD_DATARQ
			,RV.RV_COD
			,RCN.RCN_CODIGO
			FROM %table:SRA% RA
			INNER JOIN %table:SRJ% RJ ON  RJ.RJ_FUNCAO=RA.RA_CODFUNC
			INNER JOIN %table:CTT% CTT ON CTT.D_E_L_E_T_=' ' AND CTT.CTT_FILIAL=' ' AND CTT.CTT_CUSTO=RA.RA_CC
			INNER JOIN %table:SRD% RD ON RD.D_E_L_E_T_=' ' AND RD.RD_FILIAL=RA.RA_FILIAL AND RD.RD_MAT=RA.RA_MAT AND RD.RD_DATARQ >= %Exp:cAnoMesI% AND RD.RD_DATARQ <= %Exp:cAnoMesF%
			INNER JOIN %table:SRV% RV ON RV.D_E_L_E_T_=' ' AND SUBSTRING(RV.RV_FILIAL,1,2)=SUBSTRING(RA.RA_FILIAL,1,2) AND RV.RV_COD=RD.RD_PD 
			LEFT JOIN %table:RCN% RCN ON RCN.D_E_L_E_T_=' ' AND RCN.RCN_FILIAL=' ' AND RCN.RCN_CODIGO=RV.RV_CODFOL
			WHERE RA.D_E_L_E_T_=' ' 
			AND (RA.RA_FILIAL >= %Exp:mv_par01% AND RA.RA_FILIAL<=%Exp:mv_par02%) 
			AND (RA.RA_MAT >= %Exp:mv_par03% AND RA.RA_MAT <= %Exp:mv_par04%)
			AND (RA.RA_CC >= %Exp:mv_par05% AND RA.RA_CC <= %Exp:mv_par06%)
			AND (RD.RD_DATARQ >= %Exp:cAnoMesI% AND RD.RD_DATARQ <= %Exp:cAnoMesF%)
			AND (RA.RA_CATFUNC='M' OR RA.RA_CATFUNC='H')
			ORDER BY RD.RD_DATARQ,RD.RD_FILIAL,RA.RA_NOME

		EndSql
		//oReport:Section(1):SetLineCondition({|oReport| ImprimeLinha(oReport,cAliasDiv)})
	END REPORT QUERY oReport:Section(1)

	oReport:Section(1):Init()	

	(cAliasDiv)->(dbGoTop())
	While ((cAliasDiv)->(!eof()))
		cRAFilial				:= (cAliasDiv)->(RA_FILIAL)
		cMatric					:= (cAliasDiv)->(RA_MAT)
		cPeriodo				:= (cAliasDiv)->(RD_DATARQ)
		cWhile					:= (cAliasDiv)->(RA_FILIAL + RA_MAT + RD_DATARQ)
		lExistSRC				:= .F.
		__cNome					:= (cAliasDiv)->RA_NOME
		__cMat					:= (cAliasDiv)->RA_MAT 
		__dAdmissao				:= (cAliasDiv)->RA_ADMISSA
		__cCargo				:= (cAliasDiv)->RJ_DESC
		__cCusto				:= (cAliasDiv)->CTT_CUSTO
		__cCCDesc				:= (cAliasDiv)->CTT_DESC01
		__nQtdHorasTrab 		:= 0
		__nSalHora 				:= 0
		__nQtdFolgRenum			:= 0
		__nQtdHExtra			:= 0
		__nQtdAddNot			:= 0
		__nSalario				:= 0
		__nTotSal				:= 0
		__ValExtra				:= 0
		__nAddInsalub			:= 0
		__nAddNoturno			:= 0
		__nSalFamilia			:= 0
		__nAuxCreche			:= 0
		__nCompraVR				:= 0
		__nDescVR			:= 0
		__nValorCompraVA		:= 0
		__nValorTotalCompraVT	:= 0
		__nDescontoVT			:= 0
		__nCustoAssMedica		:= 0
		__nFGTS					:= 0
		__nINSS					:= 0
		__nProvFerias			:= 0
		__nPAdicFerias			:= 0
		__n13PrvFeria			:= 0
		__nPrINSSFer		:= 0
		__nPrFGTSFer		:= 0
		__nProvAcumulada		:= 0
		__n13Ferias				:= 0
		__nAdicional13		:= 0
		__nProvINSS13			:= 0
		__nProvFGTS13			:= 0
		__nAcumulada13Prov		:= 0



		//Preenche todas as variaveis
		While ((cAliasDiv)->(!eof()) .AND. cWhile == (cAliasDiv)->(RA_FILIAL + RA_MAT + RD_DATARQ) )
			//verifica se existe SRC
			lExistSRC := GetSRC(cAliasDiv)
			If lExistSRC
				nHoras		:= SRC->RC_HORAS
				nValor		:= SRC->RC_VALOR
			Else
				nHoras		:= (cAliasDiv)->RD_HORAS
				nValor		:= (cAliasDiv)->RD_VALOR
			Endif	
			//Colaborador(a) mensalista com pagamento proporcional aos dias efetivamente trabalhados
			If (((cAliasDiv)->RA_CATFUNC == "M") .AND. (!(cAliasDiv)->RA_CATEG == "07") .AND.  ((cAliasDiv)->RCN_CODIGO == '0031'))		

				nPorDia			:= nValor/nHoras
				nHorasRef		:= (cAliasDiv)->RA_HRSMES/30
				__nSalHora 		:= nPorDia/nHorasRef
				__nQtdHorasTrab := nHoras*nHorasRef
				cFuncNom	:= 	(cAliasDiv)->RA_NOME

				//Colaborador(a) horista com pagamento integral efetivamente trabalhado	
			ElseIf  (((cAliasDiv)->RA_CATFUNC == "H") .AND. (!(cAliasDiv)->RA_CATEG == "07") .AND.  ((cAliasDiv)->RCN_CODIGO == '0032'))

				nPorDia			:= nValor/nHoras
				__nSalHora 		:= nPorDia
				nHorasRef		:= (cAliasDiv)->RA_HRSMES/30
				__nQtdHorasTrab := nHoras
				cFuncNom	:= 	(cAliasDiv)->RA_NOME
				//Colaborador menor aprendiz
			Elseif  (((cAliasDiv)->RA_CATFUNC == "M") .AND. ((cAliasDiv)->RA_CATEG == "07") .AND.  ((cAliasDiv)->RCN_CODIGO == '0031'))

				nPorDia			:= nValor/nHoras
				nHorasRef		:= (cAliasDiv)->RA_HRSMES/30
				__nSalHora 		:= nPorDia/nHorasRef
				nHorasRef		:= (cAliasDiv)->RA_HRSMES/30
				__nQtdHorasTrab := nHoras*nHorasRef
				cFuncNom	:= 	(cAliasDiv)->RA_NOME				
			Elseif (cAliasDiv)->RCN_CODIGO == "0033"
				__nQtdFolgRenum 	:= 	nHoras		
				cFuncNom	:= 	(cAliasDiv)->RA_NOME
			Endif	
			//SALARIO ADICIONAIS
			//If 	(cAliasDiv)->(RD_PD) $ "020,021,022"
			//__nSalario += nHoras
			__nTotSal :=	(__nQtdHorasTrab + __nQtdFolgRenum)
			__nSalario :=	(__nTotSal * __nSalHora)
			//Endif

			//QTDE HORAS EXTRAS	
			If 	(cAliasDiv)->(RD_PD) $ "'028','029','030','031','032','033','036','038','039','063','064','085','086','087','092','097','111','112','113','114','115','116','353','354','355','364'"
				__nQtdHExtra += nHoras
			Endif

			//QTDE ADICIONAL NOTURNO
			If 	(cAliasDiv)->(RD_PD) $ "'034','035','037','059','074','075','077','078','090','091','109'"
				__nQtdAddNot += nHoras
			Endif 

			//H.E.
			If (cAliasDiv)->(RD_PD) $ "'028','029','030','031','032','033','036','038','039','063','064','085','086','087','092','097','111','112','113','114','115','116','353','354','355','364'"
				__ValExtra += nValor
			Endif

			//ADIC INSALUBR                           l
			If (cAliasDiv)->(RD_PD) $ "070,071,072,076"
				__nAddInsalub := nValor
			Endif

			//ADIC NOTURNO
			If (cAliasDiv)->(RD_PD) $ "034,035,037,059,074,075,077,078,090,091,109"
				__nAddNoturno += nValor
			Endif

			//SAL FAMÍLIA
			If (cAliasDiv)->RCN_CODIGO == "0034"
				__nSalFamilia += nValor
			Endif

			//AUX CRECHE
			If (cAliasDiv)->RCN_CODIGO == "0721"
				__nAuxCreche += nValor
			Endif


			//Valor da Compra VA
			if (cAliasDiv)->RCN_CODIGO == "0212"
				__nValorCompraVA	+= nValor
			Endif

			//Desconto de VR
			if (cAliasDiv)->(RD_PD) == "613"
				__nDescVR	+= nValor
			Endif


			//Valor Total  da Compra VR
			if (cAliasDiv)->RCN_CODIGO == "0211"
				__nCompraVR	+= nValor
			Endif

			//Valor Total da Compra VT
			if (cAliasDiv)->RCN_CODIGO == "0210"
				__nValorTotalCompraVT	+= nValor
			Endif

			//Desconto VT
			if (cAliasDiv)->RCN_CODIGO == "0051"
				__nDescontoVT	+= nValor
			Endif

			//CUSTO ASS MED.
			if (cAliasDiv)->RCN_CODIGO == "0725"
				__nCustoAssMedica	+= nValor
			Endif

			//FGTS
			if (cAliasDiv)->RCN_CODIGO $  "0018,0109,0117,0119,0120,0214,0297"
				__nFGTS	+= nValor
			Endif


			//INSS
			if (cAliasDiv)->RCN_CODIGO $  "0064,0065,0070,0148,0149,0150"
				__nINSS	+= nValor
			Endif


			(cAliasDiv)->(dbSkip())	
		EndDo

		//Provisão Férias Mês
		cVerbas	:= "'830'"
		__nProvFerias := GetSRT(cRAFilial, cMatric, cPeriodo, cVerbas)

		//Prov Adicional Férias
		cVerbas	:= "'832'"
		__nPAdicFerias := GetSRT(cRAFilial, cMatric, cPeriodo, cVerbas)		

		//Prov 1/3 Férias
		cVerbas	:= "'831'"
		__n13PrvFeria := GetSRT(cRAFilial, cMatric, cPeriodo, cVerbas)	

		//Prov INSS Férias
		cVerbas	:= "'833'"
		__nPrINSSFer := GetSRT(cRAFilial, cMatric, cPeriodo, cVerbas)

		//Prov FGTS Férias
		cVerbas	:= "'834'"
		__nPrFGTSFer := GetSRT(cRAFilial, cMatric, cPeriodo, cVerbas)

		//Prov Férias Acumulada
		cVerbas := "'830','831','832','833','834'"
		__nProvAcumulada := GetSRT(cRAFilial, cMatric, cPeriodo, cVerbas, .F.)

		//Prov 13o
		//		cVerbas	:= "'845'"
		cVerbas	:= "'895'"
		__nProv13 := GetSRT(cRAFilial, cMatric, cPeriodo, cVerbas)

		//Prov. Adicional 13o
		//		cVerbas	:= "'846'"
		cVerbas	:= "'896'"
		__nAdicional13 := GetSRT(cRAFilial, cMatric, cPeriodo, cVerbas)		

		//Prov INSS 13o
		//		cVerbas	:= "'847'"
		cVerbas	:= "'898'"
		__nProvINSS13 := GetSRT(cRAFilial, cMatric, cPeriodo, cVerbas)	

		//Prov FGTS 13o
		//		cVerbas	:= "'848'"
		cVerbas	:= "'899'"
		__nProvFGTS13 := GetSRT(cRAFilial, cMatric, cPeriodo, cVerbas)

		//Provisão 13o Acumulada
		//		cVerbas	:= "'845','846','847','848'"
		cVerbas	:= "'290','300'"
		__nAcumulada13Prov := GetSRT(cRAFilial, cMatric, cPeriodo, cVerbas,.F.)


		oReport:Section(1):PrintLine(.F.)
	EndDo
	oReport:Section(1):Finish()
	#ENDIF
Return


Static Function GetSRC(cAliasDiv)
	Local lRet	:= .F.

	dbSelectArea('SRC')
	SRC->(DbSetOrder())
	If cAnoMesI == AllTrim(Str(Year(dDatabase))) + AllTrim(Str(Month(dDatabase)))
		If SRC->(DbSeek((cAliasDiv)->RD_FILIAL + (cAliasDiv)->RA_MAT + (cAliasDiv)->RD_PD + (cAliasDiv)->RA_CC))
			If SRC->RC_PERIDO == cAnoMesI
				lRet := .T.
			Endif
		Endif
	Endif
Return lRet


Static Function GetSRT(cRAFilial, cMatric, cPeriodo, cVerbas,lAnterior)
	Local aArea	:= Getarea()
	Local nVal 		:= 0
	Local cQuery 	:= ''
	Local cQuery2 	:= ''
	Local cAno		:= SubStr(cPeriodo,0,4)
	Local cMes		:= SubStr(cPeriodo,5,2)

	Default	lAnterior	:= .T.

	cQuery += " SELECT SUM(RT_VALOR) VALOR_ATUAL "
	cQuery += " FROM " + RetSqlName("SRT")
	cQuery += " WHERE RT_FILIAL ='" + cRAFilial + "'"
	cQuery += " AND RT_MAT ='" + cMatric + "'" 
	cQuery += " AND RT_DATACAL >= '" + cPeriodo + "'+'01' AND RT_DATACAL <= '" + cPeriodo + "'+'31'"
	cQuery += " AND RT_VERBA IN (" + cVerbas + ")"
	cQuery += " AND D_E_L_E_T_ = ''"

	cQuery := ChangeQuery(cQuery)

	If Select("TMP1") > 0
		DbselectArea("TMP1")
		TMP1->(dbCloseArea())
	EndIf

	TcQuery cQuery NEW ALIAS "TMP1"

	DbselectArea("TMP1")
	TMP1->(dbGoTop())
	nVal := TMP1->(VALOR_ATUAL) 

	If lAnterior 	
		//trata para o periodo anterior
		If cMes == "01"
			cMes := "12"
			cAno := AllTrim(StrZero(Val(cAno)-1,4))
		Else
			cMes := AllTrim(StrZero(Val(cMes)-1,2))		
		Endif

		cPeriodo := cAno + cMes

		cQuery2 += " SELECT SUM(RT_VALOR) VALOR_ANTERIOR "
		cQuery2 += " FROM " + RetSqlName("SRT")
		cQuery2 += " WHERE RT_FILIAL ='" + cRAFilial + "'"
		cQuery2 += " AND RT_MAT ='" + cMatric + "'" 
		cQuery2 += " AND RT_DATACAL >= '" + cPeriodo + "'+'01' AND RT_DATACAL <= '" + cPeriodo + "'+'31'"
		cQuery2 += " AND RT_VERBA IN (" + cVerbas + ")"
		cQuery2 += " AND D_E_L_E_T_ = ''"
		cQuery2 := ChangeQuery(cQuery2)

		If Select("TMP2") > 0
			DbselectArea("TMP1")
			TMP2->(dbCloseArea())
		EndIf

		TcQuery cQuery2 NEW ALIAS "TMP2"
		dbSelectArea("TMP2")		
		TMP2->(dbGoTop())

		nVal := TMP1->(VALOR_ATUAL) - TMP2->(VALOR_ANTERIOR)

		TMP2->(dbCloseArea())
		RestArea(aArea)
	Endif

	TMP1->(dbCloseArea())
	RestArea(aArea)

Return nVal