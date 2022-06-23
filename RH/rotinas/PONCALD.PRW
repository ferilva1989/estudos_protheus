#INCLUDE "Protheus.Ch"
//#INCLUDE "RWMAKE.CH"  

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Função    ¦ PONCALD ()     ¦ Autor ¦ JORGE SATO    ¦ Data ¦ 23/11/2015 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Este ponto de entrada nao contem nenhum parametro de       ¦¦¦
¦¦¦-----------------------------------------------------------------------¦¦¦
¦¦¦entrada e/ou saida, portanto pode ser utilizado somente para           ¦¦¦
¦¦¦incluir/alterar/excluir registros dos arquivos SPB e SPI.              ¦¦¦
¦¦¦Estes arquivos nao estarao sincronizados com o cadastro de             ¦¦¦
¦¦¦funcionarios(SRA) no momento da chamada.                               ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ BSL                                                        ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Histórico de Alterações	    					                      ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Data      ¦ Analista            		                                  ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦          ¦     					                                      ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Descricao ¦                                                            ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

User Function PONCALD()
	Local cMatr    := " "
	Local _cQuery  := " "
	Local cFlll    := " "
	Local cDessa   := " "
	Local cQuery1  := " "
	Local cQuery2  := " "
	Local cVerbPd  := " "
	Private cPONSIND  := ""
	Private cPONVERB  := ""
	Private cPSINDHE  := ""
	Private cPVERBHE  := ""
	Private cPSINDD   := ""
	Private cPVERBD   := ""

	dbSelectArea("RCC")
	dbSetorder(1)
	if dbSeek(xfilial("RCC")+"U090")

		cQuery1  := " SELECT SUBSTRING(RCC_CONTEU,1,2) AS SIND,SUBSTRING(RCC_CONTEU,3,3) AS VERBANT,SUBSTRING(RCC_CONTEU,6,3) AS VERBPOS "
		cQuery1  += " FROM " + RetSqlName("RCC") + " RCC WHERE RCC_CODIGO ='U090' AND D_E_L_E_T_ <> '*' "
		dbUseArea(.T.,"TOPCOON",TcGenQry(,,cQuery1),"TRBRCC01",.F.,.T.)
		TRBRCC01->( dbGoTop() )
		WHILE !EOF()
			cPONSIND+=TRBRCC01->SIND
			cPONVERB+=TRBRCC01->VERBANT

			TRBRCC01->(DbSkip())

		ENDDO
		TRBRCC01->(DBCLOSEAREA())

		_cQuery  := " SELECT PB_DATA,PB_MAT,PB_FILIAL,PB_PD,RA_NOME,RA_SINDICA, PB_TIPO2 FROM "
		_cQuery  += " " + RetSqlName("SPB") + " SPB inner join " + RetSqlName("SRA") + " SRA "
		_cQuery  += " ON RA_MAT = PB_MAT AND RA_FILIAL = PB_FILIAL "
		_cQuery  += " WHERE RA_DEMISSA = ' ' AND RA_SINDICA IN(" + fSqlIN(cPONSIND, 2) + ") AND SPB.D_E_L_E_T_ <> '*' AND SRA.D_E_L_E_T_ <> '*' "
		_cQuery  += " AND PB_PD IN (" + fSqlIN(cPONVERB, 3) + ") AND PB_DATA BETWEEN '"+DTOS(MV_PAR16)+"' AND '"+DTOS(MV_PAR17)+"' "
		//		_cQuery  += " AND PB_FILIAL IN(" + fSqlIN(GetMV("PONFILLLLL"), 2 )+ ") "

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"TRBPONTO",.F.,.T.)
		TRBPONTO->( dbGoTop() )


		WHILE TRBPONTO->(!EOF())
			cMatr := (TRBPONTO->PB_MAT)
			cDessa := (TRBPONTO->PB_PD)
			_dDe2 := (TRBPONTO->PB_DATA)
			cFlll := (TRBPONTO->PB_FILIAL)
			cSindica := (TRBPONTO->RA_SINDICA)

			cQuery2  := " SELECT SUBSTRING(RCC_CONTEU,1,2) AS SIND,SUBSTRING(RCC_CONTEU,3,3) AS VERBANT,SUBSTRING(RCC_CONTEU,6,3) AS VERBPOS "
			cQuery2  += " FROM " + RetSqlName("RCC") + " RCC WHERE RCC_CODIGO ='U090' "
			cQuery2  += " AND RCC.D_E_L_E_T_ <> '*' AND SUBSTRING(RCC_CONTEU,1,2) = '" + cSindica +"' AND SUBSTRING(RCC_CONTEU,3,3) = '" + cDessa +"' "
			dbUseArea(.T.,"TOPCOON",TcGenQry(,,cQuery2),"TRBRCC02",.F.,.T.)

			TRBRCC02->( dbGoTop() )
			If Select("TRBRCC02") > 0
				cVerbPd := TRBRCC02->VERBPOS
				//Marca a verba CORRETA - para CADA SINDICATO REFERENTE AO ADICIONAL NOTURNO!!!
				TcSqlExec("UPDATE " + RetSqlName("SPB") + " SET PB_PD = '" + cVerbPd +"' WHERE PB_MAT = '" + cMatr +"' AND PB_FILIAL = '" + cFlll +"' AND  PB_DATA = '" +_dDe2+ "' AND PB_PD = '" +cDessa+ "' ")
				TcSqlExec("COMMIT")

				TRBRCC02->(DBCLOSEAREA())
			EndIf	

			TRBPONTO->(DbSkip())

		ENDDO

		TRBPONTO->(dbclosearea())
	ENDIF

	dbSelectArea("RCC")
	dbSetorder(1)
	if dbSeek(xfilial("RCC")+"U091")

		cQuery1  := " SELECT SUBSTRING(RCC_CONTEU,1,2) AS SIND,SUBSTRING(RCC_CONTEU,3,3) AS VERBANT,SUBSTRING(RCC_CONTEU,6,3) AS VERBPOS "
		cQuery1  += " FROM " + RetSqlName("RCC") + " RCC WHERE RCC_CODIGO ='U091' "
		dbUseArea(.T.,"TOPCOON",TcGenQry(,,cQuery1),"TRBRCCU02",.F.,.T.)
		TRBRCCU02->( dbGoTop() )
		WHILE !EOF()
			cPSINDHE+=TRBRCCU02->SIND
			cPVERBHE+=TRBRCCU02->VERBANT

			TRBRCCU02->(DbSkip())

		ENDDO
		TRBRCCU02->(DBCLOSEAREA())

		_cQuery  := " SELECT PB_DATA,PB_MAT,PB_FILIAL,PB_PD,RA_NOME,RA_SINDICA, PB_TIPO2 FROM "
		_cQuery  += " " + RetSqlName("SPB") + " SPB inner join " + RetSqlName("SRA") + " SRA "
		_cQuery  += " ON RA_MAT = PB_MAT AND RA_FILIAL = PB_FILIAL "
		_cQuery  += " WHERE RA_DEMISSA = ' ' AND RA_SINDICA IN(" + fSqlIN(cPSINDHE, 2) + ") AND SPB.D_E_L_E_T_ <> '*' AND SRA.D_E_L_E_T_ <> '*' "
		_cQuery  += " AND PB_PD IN (" + fSqlIN(cPVERBHE, 3) + ") "
		//		_cQuery  += " AND PB_FILIAL IN(" + fSqlIN(GetMV("PONFILLLLL"), 2 )+ ") "

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"TRBPONHE",.F.,.T.)
		TRBPONHE->( dbGoTop() )


		WHILE !EOF()
			cMatrHE := (TRBPONHE->PB_MAT)
			cDessaHE := (TRBPONHE->PB_PD)
			_dDe2HE := (TRBPONHE->PB_DATA)
			cFlllHE := (TRBPONHE->PB_FILIAL)
			cSindHE := (TRBPONHE->RA_SINDICA)

			cQuery2  := " SELECT SUBSTRING(RCC_CONTEU,1,2) AS SIND,SUBSTRING(RCC_CONTEU,3,3) AS VERBANT,SUBSTRING(RCC_CONTEU,6,3) AS VERBPOS "
			cQuery2  += " FROM " + RetSqlName("RCC") + " RCC WHERE RCC_CODIGO ='U091' "
			cQuery2  += " AND RCC.D_E_L_E_T_ <> '*' AND SUBSTRING(RCC_CONTEU,1,2) = '" + cSindHE +"' AND SUBSTRING(RCC_CONTEU,3,3) = '" + cDessaHE +"' "
			dbUseArea(.T.,"TOPCOON",TcGenQry(,,cQuery2),"TRBRCCU03",.F.,.T.)

			TRBRCCU03->( dbGoTop() )
			If Select("TRBRCCU03") > 0
				cVerbHE := TRBRCCU03->VERBPOS
				//Marca a verba CORRETA - para CADA SINDICATO REFERENTE AO HORA EXTRA NORMAL!!!
				TcSqlExec("UPDATE " + RetSqlName("SPB") + " SET PB_PD = '" + cVerbHE +"' WHERE PB_MAT = '" + cMatrHE +"' AND PB_FILIAL = '" + cFlllHE +"' AND  PB_DATA = '" +_dDe2HE+ "' AND PB_PD = '" +cDessaHE+ "' ")
				TcSqlExec("COMMIT")

				TRBRCCU03->(DBCLOSEAREA())
			EndIf	

			TRBPONHE->(DbSkip())

		ENDDO

		TRBPONHE->(dbclosearea())
	ENDIF


	dbSelectArea("RCC")
	dbSetorder(1)
	if dbSeek(xfilial("RCC")+"U092")

		cQuery1  := " SELECT SUBSTRING(RCC_CONTEU,1,2) AS SIND,SUBSTRING(RCC_CONTEU,3,3) AS VERBANT,SUBSTRING(RCC_CONTEU,6,3) AS VERBPOS "
		cQuery1  += " FROM " + RetSqlName("RCC") + " RCC WHERE RCC_CODIGO ='U092' "
		dbUseArea(.T.,"TOPCOON",TcGenQry(,,cQuery1),"TRBRCCU04",.F.,.T.)
		TRBRCCU04->( dbGoTop() )
		WHILE !EOF()
			cPSINDD+=TRBRCCU04->SIND
			cPVERBD+=TRBRCCU04->VERBANT

			TRBRCCU04->(DbSkip())

		ENDDO
		TRBRCCU04->(DBCLOSEAREA())

		_cQuery  := " SELECT PB_DATA,PB_MAT,PB_FILIAL,PB_PD,RA_NOME,RA_SINDICA, PB_TIPO2 FROM "
		_cQuery  += " " + RetSqlName("SPB") + " SPB inner join " + RetSqlName("SRA") + " SRA "
		_cQuery  += " ON RA_MAT = PB_MAT AND RA_FILIAL = PB_FILIAL "
		_cQuery  += " WHERE RA_DEMISSA = ' ' AND RA_SINDICA IN(" + fSqlIN(cPSINDD, 2) + ") AND SPB.D_E_L_E_T_ <> '*' AND SRA.D_E_L_E_T_ <> '*' "
		_cQuery  += " AND PB_PD IN (" + fSqlIN(cPVERBD, 3) + ") "
		//		_cQuery  += " AND PB_FILIAL IN(" + fSqlIN(GetMV("PONFILLLLL"), 2 )+ ") "

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"TRBPONDSR",.F.,.T.)
		TRBPONDSR->( dbGoTop() )


		WHILE !EOF()
			cMatrD  := (TRBPONDSR->PB_MAT)
			cDessaD := (TRBPONDSR->PB_PD)
			_dDe2D  := (TRBPONDSR->PB_DATA)
			cFlllD  := (TRBPONDSR->PB_FILIAL)
			cSindD  := (TRBPONDSR->RA_SINDICA)

			cQuery2  := " SELECT SUBSTRING(RCC_CONTEU,1,2) AS SIND,SUBSTRING(RCC_CONTEU,3,3) AS VERBANT,SUBSTRING(RCC_CONTEU,6,3) AS VERBPOS "
			cQuery2  += " FROM " + RetSqlName("RCC") + " RCC WHERE RCC_CODIGO ='U092' "
			cQuery2  += " AND RCC.D_E_L_E_T_ <> '*' AND SUBSTRING(RCC_CONTEU,1,2) = '" + cSindD +"' AND SUBSTRING(RCC_CONTEU,3,3) = '" + cDessaD +"' "
			dbUseArea(.T.,"TOPCOON",TcGenQry(,,cQuery2),"TRBRCCU05",.F.,.T.)

			TRBRCCU05->( dbGoTop() )
			If Select("TRBRCCU05") > 0
				cVerbD := TRBRCCU05->VERBPOS
				//Marca a verba CORRETA - para CADA SINDICATO REFERENTE AO HORA EXTRA DSR E FERIADO!!!
				TcSqlExec("UPDATE " + RetSqlName("SPB") + " SET PB_PD = '" + cVerbD +"' WHERE PB_MAT = '" + cMatrD +"' AND PB_FILIAL = '" + cFlllD +"' AND  PB_DATA = '" +_dDe2D+ "' AND PB_PD = '" +cDessaD+ "' ")
				TcSqlExec("COMMIT")

				TRBRCCU05->(DBCLOSEAREA())
			EndIf	

			TRBPONDSR->(DbSkip())

		ENDDO

		TRBPONDSR->(dbclosearea())
	ENDIF

RETURN()


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FSQLIN   ºAutor  ³ JORGE SATO        º Data ³  24/11/15    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao para Montar a Selecao da Clausula IN do SQL.        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P12                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function fSqlIN( cTexto, nStep )

	Local cRet := ""
	Local i

	cTexto := Rtrim( cTexto )

	If Len( cTexto ) > 0
		For i := 1 To Len( cTexto ) Step nStep
			cRet += "'" + SubStr( cTexto, i, nStep ) + "'"

			If i + nStep <= Len( cTexto )
				cRet += ","
			EndIf
		Next
	EndIf

Return( cRet )