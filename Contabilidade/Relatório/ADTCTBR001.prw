#include 'protheus.ch'
#include 'parmtype.ch'
#include "topconn.ch"

/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : CTBRADT1				| 	Março de 2018								  			|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Eduardo Augusto Donato		     											|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Programa para geração de Relatório de Conciliação Contabil x Financeira			|
|-----------------------------------------------------------------------------------------------|	
*/


user function CTBRADT1()

	private cPerg 	:= 'CTBR001'

	AjustSX1()

	if ! Pergunte(cPerg)
		return
	endif

	MakeDir("C:\RELATO\")
	processa({||procRelato()}, "Aguarde Processamento...")					   
return



static function procRelato()

	local _cQry 	:= ''
	local _cQuery 	:= ''
	local _cHtml 	:= ''
	local _cArqTmp 	:= 'C:\RELATO\CTBR001_'+dtos(ddatabase)+"_"+strtran(time(),":","")+'.XLS'
	local _nRecnoSE := 0   

	local _nTotE1Con := 0 
	local _nTotE1nCon := 0 

	local _nTotE2Con := 0 
	local _nTotE2nCon := 0 

	local _nTotE5RCon := 0 
	local _nTotE5PCon := 0 

	nHandle := MsfCreate(_cArqTmp,0)

	_cQuery := "SELECT E5_FILIAL "
	_cQuery += "	,E5_DTDISPO "
	_cQuery += "	,E5_HISTOR "
	_cQuery += "	,E5_NUMCHEQ "
	_cQuery += "	,E5_DOCUMEN "
	_cQuery += "	,E5_PREFIXO "
	_cQuery += "	,E5_NUMERO "
	_cQuery += "	,E5_PARCELA "
	_cQuery += "	,E5_TIPODOC "
	_cQuery += "	,E5_FILORIG "
	_cQuery += "	,E5_RECPAG "
	_cQuery += "	,E5_VALOR "
	_cQuery += "	,E5_MOTBX "
	_cQuery += "	,E5_MOEDA "
	_cQuery += "	,E5_VLMOED2 "
	_cQuery += "	,E5_CLIFOR "
	_cQuery += "	,E5_LOJA "
	_cQuery += "	,E5_RECONC "
	_cQuery += "	,E5_TIPO "
	_cQuery += "	,E5_SEQ "
	_cQuery += "	,E5_KEY "
	_cQuery += "	,E5_DATA "
	_cQuery += "	,SE5.R_E_C_N_O_ REGSE5 "
	_cQuery += "	,E5_BANCO "
	_cQuery += "	,E5_AGENCIA "
	_cQuery += "	,E5_CONTA "
	_cQuery += "	,A6_FILIAL "
	_cQuery += "	,A6_COD "
	_cQuery += "	,A6_NREDUZ "
	_cQuery += "	,A6_AGENCIA "
	_cQuery += "	,A6_NUMCON "
	_cQuery += "	,A6_LIMCRED "
	_cQuery += "	,E5_TXMOEDA "
	_cQuery += " from " + retSqlName("SE5") + " SE5 WITH (NOLOCK) "
	_cQuery += " LEFT JOIN " + retSqlName("SA6") + " SA6 WITH (NOLOCK) ON ( "
	_cQuery += "		E5_BANCO = A6_COD "
	_cQuery += "		AND E5_AGENCIA = A6_AGENCIA "
	_cQuery += "		AND E5_CONTA = A6_NUMCON "
	_cQuery += "		) "
	_cQuery += "WHERE E5_DTDISPO BETWEEN '"+dtos(mv_par07)+"' "
	_cQuery += "	AND '"+dtos(mv_par08)+"' "

	//	_cQuery += "	AND A6_FILIAL = '  ' "
	_cQuery += "	AND E5_BANCO BETWEEN '"+mv_par01+"' AND  '"+mv_par02+"' "
	_cQuery += "	AND E5_AGENCIA  BETWEEN '"+mv_par03+"' AND  '"+mv_par04+"' "
	_cQuery += "	AND E5_CONTA  BETWEEN '"+mv_par05+"' AND  '"+mv_par06+"' "
	_cQuery += "	AND E5_NUMERO  BETWEEN '"+mv_par09+"' AND  '"+mv_par10+"' "
	_cQuery += "	AND E5_TIPODOC NOT IN ( 'DC' "
	_cQuery += "		,'JR' "
	_cQuery += "		,'MT' "
	_cQuery += "		,'CM' "
	_cQuery += "		,'D2' "
	_cQuery += "		,'J2' "
	_cQuery += "		,'M2' "
	_cQuery += "		,'V2' "
	_cQuery += "		,'C2' "
	_cQuery += "		,'CP' "
	_cQuery += "		,'TL' "
	_cQuery += "		,'BA' "
	_cQuery += "		,'I2' "
	_cQuery += "		,'EI' "
	_cQuery += "		) "
	_cQuery += "	AND NOT ( "
	_cQuery += "		E5_MOEDA IN ( "
	_cQuery += "			'C1' "
	_cQuery += "			,'C2' "
	_cQuery += "			,'C3' "
	_cQuery += "			,'C4' "
	_cQuery += "			,'C5' "
	_cQuery += "			,'CH' "
	_cQuery += "			) "
	_cQuery += "		AND E5_NUMCHEQ = '               ' "
	_cQuery += "		AND ( "
	_cQuery += "			E5_TIPODOC NOT IN ( "
	_cQuery += "				'TR' "
	_cQuery += "				,'TE' "
	_cQuery += "				) "
	_cQuery += "			) "
	_cQuery += "		) "
	_cQuery += "	AND NOT ( "
	_cQuery += "		E5_TIPODOC IN ( "
	_cQuery += "			'TR' "
	_cQuery += "			,'TE' "
	_cQuery += "			) "
	_cQuery += "		AND ( "
	_cQuery += "			( "
	_cQuery += "				E5_NUMCHEQ BETWEEN '*                ' "
	_cQuery += "					AND '*ZZZZZZZZZZZZZZ' "
	_cQuery += "				) "
	_cQuery += "			OR ( "
	_cQuery += "				E5_DOCUMEN BETWEEN '*                ' "
	_cQuery += "					AND '*ZZZZZZZZZZZZZZZZ' "
	_cQuery += "				) "
	_cQuery += "			) "
	_cQuery += "		) "
	_cQuery += "	AND NOT ( "
	_cQuery += "		E5_TIPODOC IN ( "
	_cQuery += "			'TR' "
	_cQuery += "			,'TE' "
	_cQuery += "			) "
	_cQuery += "		AND E5_NUMERO = '      ' "
	_cQuery += "		AND E5_MOEDA NOT IN ( "
	_cQuery += "			'CC' "
	_cQuery += "			,'CD' "
	_cQuery += "			,'CH' "
	_cQuery += "			,'CO' "
	_cQuery += "			,'DOC' "
	_cQuery += "			,'EST' "
	_cQuery += "			,'FI' "
	_cQuery += "			,'R$' "
	_cQuery += "			,'TB' "
	_cQuery += "			,'TC' "
	_cQuery += "			,'VL' "
	_cQuery += "			,'DO' "
	_cQuery += "			) "
	_cQuery += "		) "
	_cQuery += "	AND E5_SITUACA <> 'C' "
	_cQuery += "	AND E5_VALOR <> 0 "
	_cQuery += "	AND NOT ( "
	_cQuery += "		E5_NUMCHEQ BETWEEN '*           ' "
	_cQuery += "			AND '*ZZZZZZZZZZZZZZ' "
	_cQuery += "		) "
	_cQuery += "	AND ( "
	_cQuery += "		E5_VENCTO <= '20181231' "
	_cQuery += "		OR E5_VENCTO <= E5_DATA "
	_cQuery += "		) "
	_cQuery += "	AND SE5.D_E_L_E_T_ = ' ' "
	_cQuery += "	AND SA6.D_E_L_E_T_ = ' ' "
	_cQuery += "	AND NOT EXISTS (SELECT * FROM " + retSqlName("CV3") + " CV3 WITH (NOLOCK) WHERE CV3.CV3_FILIAL = '' AND CV3.CV3_TABORI = 'SE5' AND CV3.CV3_RECORI = SE5.R_E_C_N_O_ AND CV3.D_E_L_E_T_ = '') "

	_cQuery += " ORDER BY E5_DTDISPO ,E5_BANCO ,E5_AGENCIA ,E5_CONTA ,E5_NUMCHEQ ,E5_DOCUMEN ,SE5.R_E_C_N_O_	,E5_PREFIXO	,E5_NUMERO "

	tcQuery _cQuery new alias "SE5TMP"
	tcSetField("SE5TMP","E5_DTDISPO"  ,"D")      
	tcSetField("SE5TMP","E5_DATA"  ,"D")      

	_cHtml := "<table border='1'> "
	_cHtml += "	<tr><td bgcolor='lightyellow' colspan='10' align='center'><b> Financeiro x Contabilidade </td></tr>"
	_cHtml += "	<tr><td bgcolor='lightyellow' colspan='10' align='center'><b> Periodo de "+(dtos(mv_par07))+" a "+(dtos(mv_par08))+" </td></tr>"
	_cHtml += "	<tr>"      

	_cHtml += " 	<td bgcolor='lightblue' align='center'><font face='Arial' size=2><b> Numero </td> "
	_cHtml += " 	<td bgcolor='lightblue' align='center'><font face='Arial' size=2><b> Banco </td> "
	_cHtml += " 	<td bgcolor='lightblue' align='center'><font face='Arial' size=2><b> Agencia </td> "
	_cHtml += " 	<td bgcolor='lightblue' align='center'><font face='Arial' size=2><b> Conta </td> "
	_cHtml += " 	<td bgcolor='lightblue' align='center'><font face='Arial' size=2><b> Motivo Bx. </td> "

	_cHtml += " 	<td bgcolor='lightblue' align='center'><font face='Arial' size=2><b> Historico </td> "
	_cHtml += " 	<td bgcolor='lightblue' align='center'><font face='Arial' size=2><b> Data Disponibilidade </td> "
	_cHtml += " 	<td bgcolor='lightblue' align='center'><font face='Arial' size=2><b> Prefixo </td> "
	_cHtml += " 	<td bgcolor='lightblue' align='center'><font face='Arial' size=2><b> Data Emissão </td> "
	_cHtml += " 	<td bgcolor='lightblue' align='center'><font face='Arial' size=2><b> Valor </td> "
	_cHtml += " 	<td bgcolor='lightblue' align='center'><font face='Arial' size=2><b> Parcela </td> "
	_cHtml += " 	<td bgcolor='lightblue' align='center'><font face='Arial' size=2><b> Fornecedor </td> "
	_cHtml += " 	<td bgcolor='lightblue' align='center'><font face='Arial' size=2><b> Motivo </td> "
	_cHtml += "	</tr>"

	fWrite(nHandle, _cHtml) 

	_nRecs := 0
	do while ! SE5TMP->(eof())
		_nRecs ++
		SE5TMP->(dbSkip())
	enddo

	SE5TMP->(dbGoTop())
	ProcRegua(_nRecs)

	do while ! SE5TMP->(eof())

		IncProc("Processando Data..." + DTOC(SE5TMP->E5_DTDISPO))

		//Se Tiver registros na query que não encontrou no CV3 busco eles na tabela Original,
		// se é receber ou pagar
		_nRecnoSE := 0

		If SE5TMP->E5_RECPAG == 'R' .and. !Empty(SE5TMP->E5_NUMERO) // SE1
			_cQry := "SELECT SE1.R_E_C_N_O_ SERECNO FROM " + retSqlName("SE1") + " SE1 WITH (NOLOCK) WHERE E1_FILIAL = '"+SE5TMP->E5_FILIAL+"' AND E1_CLIENTE = '"+SE5TMP->E5_CLIFOR+"' AND E1_NUM = '"+SE5TMP->E5_NUMERO+"' AND E1_PARCELA = '"+SE5TMP->E5_PARCELA+"' AND SE1.D_E_L_E_T_ = '' "
			tcQuery _cQry new alias "SETMP"

			dbSelectArea("SETMP")
			SETMP->(dbGoTop())

			If SETMP->(!EOF())
				_nRecnoSE := SETMP->SERECNO
			EndIf

			dbSelectArea("SETMP")
			SETMP->(dbCloseArea()) 

		ElseIf SE5TMP->E5_RECPAG == 'P' .and. !Empty(SE5TMP->E5_NUMERO) // SE2
			_cQry := "SELECT SE2.R_E_C_N_O_ SERECNO FROM " + retSqlName("SE2") + " SE2 WITH (NOLOCK) WHERE E2_FILIAL = '"+SE5TMP->E5_FILIAL+"' AND E2_FORNECE = '"+SE5TMP->E5_CLIFOR+"' AND E2_NUM = '"+SE5TMP->E5_NUMERO+"' AND E2_PARCELA = '"+SE5TMP->E5_PARCELA+"' AND SE2.D_E_L_E_T_ = '' "
			tcQuery _cQry new alias "SETMP"
			dbSelectArea("SETMP")
			SETMP->(dbGoTop())

			If SETMP->(!EOF())
				_nRecnoSE := SETMP->SERECNO
			EndIf

			dbSelectArea("SETMP")
			SETMP->(dbCloseArea()) 
		EndIf

		If _nRecnoSE > 0
			_cQry := " SELECT CV3_RECORI, CV3_SEQUEN, CV3_CCC, CV3_CCD, CV3_CREDIT, CV3_DEBITO, CV3_VLR01, COUNT(*) TOT FROM " + retSqlName("CV3") + " CV3 WITH (NOLOCK) WHERE CV3.CV3_FILIAL = '' AND CV3.CV3_TABORI = '" + iif(SE5TMP->E5_RECPAG == 'R','SE1','SE2') + "' AND CV3.CV3_RECORI = "+Alltrim(Str(_nRecnoSE))+ " AND CV3.D_E_L_E_T_ = '' " 
			_cQry += " group by CV3_RECORI, CV3_SEQUEN, CV3_CCC, CV3_CCD, CV3_CREDIT, CV3_DEBITO, CV3_VLR01 "
			//_cQry += "HAVING COUNT(*) > 1 "
			tcQuery _cQry new alias "SETMP"
			SETMP->(dbGoTop())

			If SETMP->(eof())

				_cHtml := "	<tr>"
				_cHtml += " 	<td><font face='Arial' size=1>" + SE5TMP->E5_NUMERO + "</td> "

				_cHtml += " 	<td><font face='Arial' size=1>" + SE5TMP->E5_BANCO + "</td> "
				_cHtml += " 	<td><font face='Arial' size=1>" + SE5TMP->E5_AGENCIA + "</td> "
				_cHtml += " 	<td><font face='Arial' size=1>" + SE5TMP->E5_CONTA + "</td> "
				_cHtml += " 	<td><font face='Arial' size=1>" + SE5TMP->E5_MOTBX + "</td> "

				_cHtml += " 	<td><font face='Arial' size=1>" + SE5TMP->E5_HISTOR + "</td> "
				_cHtml += " 	<td><font face='Arial' size=1>" + dtoc(SE5TMP->E5_DTDISPO) + "</td> "
				_cHtml += " 	<td><font face='Arial' size=1>" + SE5TMP->E5_PREFIXO + "</td> "
				_cHtml += " 	<td><font face='Arial' size=1>" + dtoc(SE5TMP->E5_DATA) + "</td> "
				_cHtml += "		<td><font face='Arial' size=1>" + transform(SE5TMP->E5_VALOR, "@E 99,999,999.99") + "</td> "
				_cHtml += "		<td><font face='Arial' size=1>" + SE5TMP->E5_PARCELA + "</td> "
				_cHtml += " 	<td><font face='Arial' size=1>" + SE5TMP->E5_CLIFOR + "</td> "
				_cHtml += " 	<td><font face='Arial' size=1>NÃO CONTABILIZADO (a)</td> "
				_cHtml += "	</tr>"

				fWrite(nHandle, _cHtml) 

			EndIf

			While SETMP->(!eof()) .and. SETMP->TOT > 1
				_cHtml := "	<tr>"
				_cHtml += " 	<td><font face='Arial' size=1>" + SE5TMP->E5_NUMERO + "</td> "   

				_cHtml += " 	<td><font face='Arial' size=1>" + SE5TMP->E5_BANCO + "</td> "
				_cHtml += " 	<td><font face='Arial' size=1>" + SE5TMP->E5_AGENCIA + "</td> "
				_cHtml += " 	<td><font face='Arial' size=1>" + SE5TMP->E5_CONTA + "</td> "
				_cHtml += " 	<td><font face='Arial' size=1>" + SE5TMP->E5_MOTBX + "</td> "

				_cHtml += " 	<td><font face='Arial' size=1>" + SE5TMP->E5_HISTOR + "</td> "
				_cHtml += " 	<td><font face='Arial' size=1>" + dtoc(SE5TMP->E5_DTDISPO) + "</td> "
				_cHtml += " 	<td><font face='Arial' size=1>" + SE5TMP->E5_PREFIXO + "</td> "
				_cHtml += " 	<td><font face='Arial' size=1>" + dtoc(SE5TMP->E5_DATA) + "</td> "
				_cHtml += "		<td><font face='Arial' size=1>" + transform(SE5TMP->E5_VALOR, "@E 99,999,999.99") + "</td> "
				_cHtml += "		<td><font face='Arial' size=1>" + SE5TMP->E5_PARCELA + "</td> "
				_cHtml += " 	<td><font face='Arial' size=1>" + SE5TMP->E5_CLIFOR + "</td> "
				_cHtml += " 	<td><font face='Arial' size=1>DUPLICADO</td> "
				_cHtml += "	</tr>"

				fWrite(nHandle, _cHtml) 

				SETMP->(dbSkip())
			EndDo

			dbSelectArea("SETMP")
			SETMP->(dbCloseArea()) 

		Else
			_cHtml := "	<tr>"
			_cHtml += " 	<td><font face='Arial' size=1>" + SE5TMP->E5_NUMERO + "</td> "     

			_cHtml += " 	<td><font face='Arial' size=1>" + SE5TMP->E5_BANCO + "</td> "
			_cHtml += " 	<td><font face='Arial' size=1>" + SE5TMP->E5_AGENCIA + "</td> "
			_cHtml += " 	<td><font face='Arial' size=1>" + SE5TMP->E5_CONTA + "</td> "
			_cHtml += " 	<td><font face='Arial' size=1>" + SE5TMP->E5_MOTBX + "</td> "

			_cHtml += " 	<td><font face='Arial' size=1>" + SE5TMP->E5_HISTOR + "</td> "
			_cHtml += " 	<td><font face='Arial' size=1>" + dtoc(SE5TMP->E5_DTDISPO) + "</td> "
			_cHtml += " 	<td><font face='Arial' size=1>" + SE5TMP->E5_PREFIXO + "</td> "
			_cHtml += " 	<td><font face='Arial' size=1>" + dtoc(SE5TMP->E5_DATA) + "</td> "
			_cHtml += "		<td><font face='Arial' size=1>" + transform(SE5TMP->E5_VALOR, "@E 99,999,999.99") + "</td> "
			_cHtml += "		<td><font face='Arial' size=1>" + SE5TMP->E5_PARCELA + "</td> "
			_cHtml += " 	<td><font face='Arial' size=1>" + SE5TMP->E5_CLIFOR + "</td> "
			_cHtml += " 	<td><font face='Arial' size=1>NÃO CONTABILIZADO (b)</td> "
			_cHtml += "	</tr>"

			fWrite(nHandle, _cHtml) 

		EndIf

		SE5TMP->(dbSkip())

	enddo

	_cHtml := "	</table>"

	fWrite(nHandle, _cHtml) 

	SE5TMP->(dbCloseArea())

	fClose(nHandle)

	msgAlert ("Arquivo Gerado em " + _cArqTmp)

	If !ApOleClient( 'MsExcel' )
		MsgAlert( "Ms Excel não Instalado" )
	Else
		oExcelApp:= MsExcel():New()
		oExcelApp:WorkBooks:Open(_cArqTmp)
		oExcelApp:SetVisible(.T.)
	EndIf

return

Static Function AjustSX1()
	local aArea := GetArea()
	local aRegs := {}
	local i

	cPerg := PADR(cPerg,10)

	AAdd(aRegs,{"01","Banco de....?","mv_ch1","C",tamSX3("A6_COD")[1],0,0,"G","mv_par01","" ,"", "SA6" ,""})
	AAdd(aRegs,{"02","Banco até...?","mv_ch2","C",tamSX3("A6_COD")[1],0,0,"G","mv_par02","" ,"", "SA6" ,""})

	AAdd(aRegs,{"03","Agencia de....?","mv_ch3","C",tamSX3("E5_AGENCIA")[1],0,0,"G","mv_par03","" ,"", "" ,""})
	AAdd(aRegs,{"04","Agencia até...?","mv_ch4","C",tamSX3("E5_AGENCIA")[1],0,0,"G","mv_par04","" ,"", "" ,""})

	AAdd(aRegs,{"05","Conta de....?","mv_ch5","C",tamSX3("E5_CONTA")[1],0,0,"G","mv_par05","" ,"", "" ,""})
	AAdd(aRegs,{"06","Conta até...?","mv_ch6","C",tamSX3("E5_CONTA")[1],0,0,"G","mv_par06","" ,"", "" ,""})

	AAdd(aRegs,{"07","Período de.......?","mv_ch3","D",8,0,0,"G","mv_par07","" ,"", "" ,""})
	AAdd(aRegs,{"08","Período até......?","mv_ch4","D",8,0,0,"G","mv_par08","" ,"", "" ,""})

	AAdd(aRegs,{"09","Titulo de....?","mv_ch9","C",tamSX3("E5_NUMERO")[1],0,0,"G","mv_par09","" ,"", "" ,""})
	AAdd(aRegs,{"10","Titulo até...?","mv_cha","C",tamSX3("E5_NUMERO")[1],0,0,"G","mv_par10","" ,"", "" ,""})

	dbSelectArea("SX1")
	dbSetOrder(1)
	For i:=1 to Len(aRegs)
		dbSeek(cPerg+aRegs[i][1])
		If !Found() .or. aRegs[i][2]<>X1_PERGUNT
			RecLock("SX1",!Found())
			SX1->X1_GRUPO := cPerg
			SX1->X1_ORDEM := aRegs[i][01]
			SX1->X1_PERGUNT := aRegs[i][02]
			SX1->X1_VARIAVL := aRegs[i][03]
			SX1->X1_TIPO := aRegs[i][04]
			SX1->X1_TAMANHO := aRegs[i][05]
			SX1->X1_DECIMAL := aRegs[i][06]
			SX1->X1_PRESEL := aRegs[i][07]
			SX1->X1_GSC := aRegs[i][08]
			SX1->X1_VAR01 := aRegs[i][09]
			SX1->X1_DEF01 := aRegs[i][10]
			SX1->X1_DEF02 := aRegs[i][11]
			SX1->X1_F3 := aRegs[i][12]
			SX1->X1_VALID := aRegs[i][13]
			MsUnlock()
		Endif
	Next

	RestArea(aArea)
Return