#Include 'Protheus.ch'
#Include "TopConn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MTALCDOC ºAutor  ³Rafael Gama-Oficina1 º Data ³  03/04/19  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³PE no final da criação da SCR por Item.				      º±±
±±º          ³                                      					  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BSL     					                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MTALCDOC()  //MTALCFIM  //MTALCDOC

Local aParam		:= PARAMIXB[1] //Documento
Local nOper 		:= PARAMIXB[3] //Operação
Local cQuery		:= ""
Local cAliasTot	:= GetNextAlias()
Local nTotReg		:= 1

	// Aprovação de Revisão de contratos 
	IF FUNNAME() == "CNTA300" 
		IF CN9->CN9_SITUACA == "09"
			IF nOper == 1 .AND.  aParam[2] == "RV" .AND. aParam[3] > 0 .AND. !EMPTY(aParam[6])
				// Chama a rotina que fara o envio dos e-mails para aprovação do contratos.
				U_XGCT001()
			Endif
		Endif
	Endif
	
	// Aprovação de medição de contratos por entidades.
	IF IsInCallStack('CN121Inc') .OR. IsInCallStack('CN121Alt') 
		IF nOper == 1 .AND.  aParam[2] == "IM" .AND. aParam[3] > 0 
		
			//Abertura do Arquivo de Trabalho	
			If (Select(cAliasTot) > 0, (cAliasTot)->(dbCloseArea()),"")	
	
			cQuery := " SELECT SUM(CNE)-SUM(SCR) TOTREG FROM ( "+CRLF
			cQuery += " 	SELECT CNE_CC, 1 CNE, 0 SCR FROM "+RetSqlName("CNE")+" "+CRLF
			cQuery += " 	WHERE D_E_L_E_T_ <> '*' AND CNE_FILIAL = '"+CND->CND_FILIAL+"' "+CRLF
			cQuery += " 	AND CNE_NUMMED = '"+CND->CND_NUMMED+"' AND CNE_QUANT > 0 "+CRLF
			cQuery += "		GROUP BY CNE_CC "+CRLF
			cQuery += " 	UNION ALL "+CRLF
			cQuery += " 	SELECT  '' CNE_CC, 0 CNE, COUNT(*) SCR  FROM "+RetSqlName("SCR")+" "+CRLF 
			cQuery += " 	WHERE D_E_L_E_T_ <> '*' AND CR_FILIAL = '"+CND->CND_FILIAL+"'  "+CRLF
			cQuery += " 	AND CR_NUM LIKE '"+CND->CND_NUMMED+"%'  "+CRLF
			cQuery += " 	AND CR_TIPO = 'IM' AND CR_STATUS = '02' "+CRLF
			cQuery += " ) AS TOT "+CRLF
		
			TcQuery cQuery New Alias (cAliasTot)
			
			(cAliasTot)->(dbGoTop())
			
			IF (cAliasTot)->(!EOF())
				nTotReg := (cAliasTot)->TOTREG
			Endif
		
			IF nTotReg == 0				
				// Chama a rotina que fara o envio dos e-mails para aprovação das Medições.
				U_XGCT002()
				
			Endif
		
			//Abertura do Arquivo de Trabalho	
			If (Select(cAliasTot) > 0, (cAliasTot)->(dbCloseArea()),"")	
		
		Endif
	Endif

Return