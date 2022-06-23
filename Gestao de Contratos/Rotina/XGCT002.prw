#Include 'Protheus.ch'
#INCLUDE "TopConn.ch"
#INCLUDE "TbiConn.ch" 
#include "Fileio.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ XGCT002 บAutor  ณRafael Gama-Oficina1 บ Data ณ  19/02/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPrograma para envio de Workflow para aprova็ใo de Medi็๕es  บฑฑ
ฑฑบ          ณ de Contrato. Chamado pelo PE (CNTA121_PE).				    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BSL																บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function XGCT002()

Local cAliasSCR 	:= GetNextAlias()
Local cAliasCNE 	:= GetNextAlias()
Local aArea			:= GetArea()
Local aAreaSCR		:= SCR->(GetArea())
Local aAreaCNE		:= CNE->(GetArea())
Local cQuery		:= ""
Local oProcess		:= Nil
Local oHtml			:= Nil
Local cNomeWF 		:= 'APROVAMED'
Local cStSheetA1	:= "" 
Local cStSheetB1 	:= ""
Local cObsMed 		:= ""
Local cArqHtml		:= ""
Local cMailAp		:= ""
Local cNomUser		:= ""
Local cMailID		:= ""
Local cUserCnt		:= ""
Local cCondPag		:= ""
Local cNumMed		:= ""
	
	//Abertura do Arquivo de Trabalho	
	If (Select(cAliasSCR) > 0, (cAliasSCR)->(dbCloseArea()),"")	
	
	cUserCnt := POSICIONE("CN9",1, CND->CND_FILIAL+CND->CND_CONTRA+CND->CND_REVISA, "CN9_XUSRCT")
	cCondPag := POSICIONE("SE4",1,xFilial("SE4")+CND->CND_CONDPG,"E4_DESCRI")	
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Query dos aprovadores do contratos			             ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cQuery := " SELECT CR_FILIAL, CR_USER, CR_APROV, CR_GRUPO, CR_NIVEL, CR_STATUS FROM "+RetSqlName("SCR")+"  "+CRLF	
	cQuery += " WHERE D_E_L_E_T_ <> '*' AND CR_FILIAL = '"+xFilial("SCR")+"' "+CRLF
	cQuery += " AND CR_TIPO = 'IM' AND CR_STATUS = '02' AND CR_NUM LIKE '"+CND->CND_NUMMED+"%' "+CRLF  //+CND->CND_NUMERO
	cQuery += " GROUP BY CR_FILIAL, CR_USER, CR_APROV, CR_GRUPO, CR_NIVEL, CR_STATUS "+CRLF
	
	TcQuery cQuery New Alias (cAliasSCR)
			
	(cAliasSCR)->(dbGoTop())
	
	While (cAliasSCR)->(!EOF())	
	
		oProcess:=TWFProcess():New(cNomeWF,"Medi็ใo aguardando Aprova็ใo.")
		cArqHtml	:= "\workflow\AprovaMED.htm"
		oProcess:NewTask(cNomeWF,cArqHtml)
		oHtml   := oProcess:oHtml
			
		oHTML:ValByName('cChaveMED', CND->CND_FILIAL+CND->CND_CONTRA+CND->CND_REVISA+CND->CND_NUMERO+CND->CND_NUMMED)	
	
		cStSheetA1 += '	<tr> '                                                                      
		cStSheetA1 += '	    <th align=center style="vertical-align: middle;" BGCOLOR=LIGHTGRAY>Unidade<br>' + FWFILIALNAME("01", CND->CND_FILIAL, 1) + '<br></th> '	
		cStSheetA1 += '	    <th align=center style="vertical-align: middle;" BGCOLOR=LIGHTGRAY>Solicitante<br>' + ALLTRIM(cUserCnt) + '<br></th> '
		cStSheetA1 += '	    <th align=center style="vertical-align: middle;" BGCOLOR=LIGHTGRAY>Num. Contrato<br>' + CND->CND_CONTRA+CND->CND_REVISA + '<br></th> '                                                                                           
		cStSheetA1 += '	    <th align=center style="vertical-align: middle;" BGCOLOR=LIGHTGRAY>Vlr. Contrato<br> R$ <br>' + Transform(CND->CND_VLCONT,"@E 999,999,999.99") + '<br></th> '
		cStSheetA1 += '	    <th align=center style="vertical-align: middle;" BGCOLOR=LIGHTGRAY>Num. Medi็ใo<br>' + CND->CND_NUMMED + '<br></th> '
		cStSheetA1 += '	    <th align=center style="vertical-align: middle;" BGCOLOR=LIGHTGRAY>Compet๊ncia<br>' + CND->CND_COMPET + '<br></th> '			
		cStSheetA1 += '	    <th align=center style="vertical-align: middle;" BGCOLOR=LIGHTGRAY>Data Inclusใo<br>' + DTOC(CND->CND_DTINIC) + '<br></th> '	
		cStSheetA1 += '	    <th align=center style="vertical-align: middle;" BGCOLOR=LIGHTGRAY>Vlr. Medi็ใo<br> R$ ' + Transform(CND->CND_VLTOT,"@E 999,999,999.99") + '<br></th> '
		cStSheetA1 += '	    <th align=center style="vertical-align: middle;" BGCOLOR=LIGHTGRAY>Cond. Pag.<br>' + cCondPag + '<br></th> '
		cStSheetA1 += '	</tr> '
		cStSheetA1 += ' <tr> '
		cStSheetA1 += '    	<th align=center style="vertical-align: middle;">Planilha<br></th> '
		cStSheetA1 += '	 	<th align=center style="vertical-align: middle;">Item<br></th> '
		cStSheetA1 += '	 	<th align=center style="vertical-align: middle;">Produto<br></th> '
		cStSheetA1 += '    	<th align=center style="vertical-align: middle;">Descri็ใo<br></th> '
		cStSheetA1 += '    	<th align=center style="vertical-align: middle;">Quantidade<br></th> '
		cStSheetA1 += '	 	<th align=center style="vertical-align: middle;">Vlr. Unitแrio<br></th> '
		cStSheetA1 += '	  	<th align=center style="vertical-align: middle;">Vlr. Total<br></th> '
		cStSheetA1 += '	 	<th align=center style="vertical-align: middle;">Fornecedor<br></th> '  
		cStSheetA1 += '	 	<th align=center style="vertical-align: middle;">Centro de Custo<br></th> '	
		cStSheetA1 += ' </tr> '
		
		If (Select(cAliasCNE) > 0, (cAliasCNE)->(dbCloseArea()),"")
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Query das Itens Medi็ใo do contrato		             ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		cQuery := " SELECT CNE_FILIAL, CNE_NUMERO, CNE_ITEM, CNE_PRODUT, CNB_DESCRI, CNE_QUANT, CNE_VLUNIT, CNE_VLTOT, CNE_CC, CTT_DESC01, CNA_FORNEC, CNA_LJFORN, A2_NREDUZ,DBM_GRUPO "+CRLF
		cQuery += " FROM "+RetSqlName("CNE")+" CNE "+CRLF
		cQuery += " INNER JOIN "+RetSqlName("CNA")+" CNA ON CNA_FILIAL = CNE_FILIAL AND CNE_CONTRA = CNA_CONTRA AND CNE_REVISA = CNA_REVISA AND CNE_NUMERO = CNA_NUMERO AND CNA.D_E_L_E_T_ <> '*' "+CRLF
		cQuery += " INNER JOIN "+RetSqlName("CNB")+" CNB ON CNB_FILIAL = CNE_FILIAL AND CNE_CONTRA = CNB_CONTRA AND CNE_REVISA = CNB_REVISA  "+CRLF
		cQuery += " 								AND CNE_NUMERO = CNB_NUMERO AND CNE_ITEM = CNB_ITEM AND CNB.D_E_L_E_T_ <> '*' "+CRLF
		cQuery += " INNER JOIN "+RetSqlName("SA2")+" SA2 ON A2_FILIAL = '"+xFilial("SA2")+"' AND A2_COD = CNA_FORNEC AND A2_LOJA = CNA_LJFORN AND SA2.D_E_L_E_T_ <> '*' "+CRLF
		cQuery += " INNER JOIN "+RetSqlName("CTT")+" CTT ON CTT_FILIAL = '"+xFilial("CTT")+"' AND CTT_CUSTO = CNE_CC AND CTT.D_E_L_E_T_ <> '*' "+CRLF	
		cQuery += " INNER JOIN "+RetSqlName("DBM")+" DBM ON DBM_FILIAL = CNE_FILIAL AND DBM_NUM LIKE CNE_NUMMED+CNE_NUMERO+'%' AND DBM_ITEM = CNE_ITEM AND DBM.D_E_L_E_T_ <> '*' "+CRLF	
		cQuery += " WHERE CNE.D_E_L_E_T_ <> '*' AND CNE_FILIAL = '"+CND->CND_FILIAL+"' AND CNE_QUANT > 0 "+CRLF
		cQuery += " AND CNE_CONTRA =  '"+CND->CND_CONTRA+"' AND CNE_REVISA = '"+CND->CND_REVISA+"' "+CRLF
		cQuery += " AND CNE_NUMMED = '"+CND->CND_NUMMED+"' AND DBM_GRUPO = '"+(cAliasSCR)->CR_GRUPO+"' AND DBM_USER = '"+(cAliasSCR)->CR_USER+"' "+CRLF  //AND CNE_NUMERO = '"+CND->CND_NUMERO+"' 
		cQuery += " ORDER BY CNE_FILIAL, CNE_NUMMED, CNE_NUMERO, CNE_ITEM "+CRLF
	
		TcQuery cQuery New Alias (cAliasCNE)
				
		(cAliasCNE)->(dbGoTop())
	
		While (cAliasCNE)->(!EOF())
	
			cStSheetB1 += ' <tr> '
			cStSheetB1 += ' 	<td align=center style="vertical-align: top;">' + (cAliasCNE)->CNE_NUMERO + '<br></td> '
			cStSheetB1 += '	   	<td align=center style="vertical-align: top;">' + (cAliasCNE)->CNE_ITEM + '<br></td> '
			cStSheetB1 += '	   	<td align=center style="vertical-align: top;">' + (cAliasCNE)->CNE_PRODUT + '<br></td> '
			cStSheetB1 += '     <td align=left   style="vertical-align: top;">' + ALLTRIM((cAliasCNE)->CNB_DESCRI) + '</td> '
			cStSheetB1 += '     <td align=center style="vertical-align: top;">' + CVALTOCHAR((cAliasCNE)->CNE_QUANT) + '</td> '
			cStSheetB1 += '	   	<td align=center style="vertical-align: top;">R$ ' + Transform((cAliasCNE)->CNE_VLUNIT,"@E 999,999.99") + '</td> '
			cStSheetB1 += '	  	<td align=center style="vertical-align: top;">R$ ' + Transform((cAliasCNE)->CNE_VLTOT,"@E 999,999.99") + '</td> '
			cStSheetB1 += '	  	<td align=left   style="vertical-align: top;">' + ALLTRIM((cAliasCNE)->A2_NREDUZ) + " - " + (cAliasCNE)->CNA_LJFORN + '</td> '                                        
			cStSheetB1 += '	  	<td align=left   style="vertical-align: top;">' + ALLTRIM((cAliasCNE)->CTT_DESC01) + '</td> '
			cStSheetB1 += ' </tr> '	
	
			(cAliasCNE)->(dbSkip())
		EndDo
	
		cStSheetB1 += '  </tbody> '
		cStSheetB1 += '</table> '
		
		cObsMed += ' <br><br> '
		cObsMed += ' Observa็ใo: '
		cObsMed += ' <br><br> '
		cObsMed += ' 	<textarea name="S2" cols="87" rows="4" class="style9" id="CND_OBS" disabled>' + CND->CND_OBS + '</textarea> '
		cObsMed += ' <br><br> '
	
		oHTML:ValbyName("CodigoStyleSheetA1", cStSheetA1)
		oHTML:ValbyName("CodigoStyleSheetB1", cStSheetB1)
		oHTML:ValbyName("CodigocObsMed"		, cObsMed	)
		oHTML:ValByName('cGrpAprov', (cAliasSCR)->CR_GRUPO )
	
		cNumMed	:= CND->CND_NUMMED
		cMailAp	:= UsrRetMail((cAliasSCR)->CR_USER)
		cNomUser	:= UsrRetName((cAliasSCR)->CR_USER)
		
		//temporario
		//IF Empty(cMailAp)
		//	cMailAp := "rafael.gama@oficinatec.com.br"
		//Endif
			
		oProcess:ClientName(USRRETNAME(__cUserID))
		oProcess:cTo      := cMailAp
		oProcess:cBCC     := ''
		oProcess:cSubject := "BSL Workflow: Medi็ใo " + cNumMed
		oProcess:cBody    := ""
		oProcess:bReturn  := "U_XGCT002R()"     //Define a Fun็ใo de Retorno
	
		//Uso um endereco invalido, apenas para criar o processo de workflow, mas sem envia-lo
		oProcess:cTo  := "000000" //"000001"
		oProcess:cCC  := NIL
		oProcess:cBCC := NIL
	
		cMailID    := oProcess:Start()  // Crio o processo e gravo o ID do processo de Workflow
	
		U_EnvLink(cMailID,cMailAp,"","",oProcess:cSubject, cFilAnt,"APROVAวรO DE MEDIวรO",oProcess,"000000", cNomUser,"6",cNumMed)
						
		cStSheetA1 := ""
		cStSheetB1 := ""	
	
		(cAliasSCR)->(dbSkip())
	EndDo
	
	//Abertura do Arquivo de Trabalho	
	If (Select(cAliasSCR) > 0, (cAliasSCR)->(dbCloseArea()),"")
	If (Select(cAliasCNE) > 0, (cAliasCNE)->(dbCloseArea()),"")	
	
RestArea(aArea)
RestArea(aAreaSCR)
RestArea(aAreaCNE)

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ XGCT002RบAutor  ณRafael Gama-Oficina1 บ Data ณ  20/02/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPrograma para o tratamento da resposta do Workflow de      บฑฑ
ฑฑบ          ณ aprova็ใo de Medi็ใo. Chamado pelo HTML (AprovaMED.htm).  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BSL																บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function XGCT002R(oProcess)

Local cAliasSCR 	:= GetNextAlias()
Local cAliasCNE 	:= GetNextAlias()
Local aAreaCND	:= CND->(GetArea())
Local aAreaSCR	:= SCR->(GetArea())
Local aAreaCNE	:= CNE->(GetArea())
Local cQuery		:= ""

Local cChaveMED	:= oProcess:oHtml:RetByName("cChaveMED")
Local cGrpAprov	:= oProcess:oHtml:RetByName("cGrpAprov")
Local _cFilial	:= SubStr(cChaveMED, 1, LEN(cFilAnt))
//Local cNumCont 	:= SubStr(cChaveMED, LEN(cFilAnt)+1, TamSX3("CN9_NUMERO")[1]+TamSX3("CN9_REVISA")[1])
Local cNumMed		:= RIght(cChaveMED,TamSX3("CND_NUMMED")[1])
Local cCheckBox1	:= AllTrim(oProcess:oHtml:RetByName('AprRej1'))
Local cMotivo		:= AllTrim(oProcess:oHtml:RetByName('OBSERVAC1'))
Local oHtml		:= Nil
Local cNomeWF 	:= 'APROVAMED'
Local cStSheetA1 	:= "" 
Local cStSheetB1 	:= ""
Local cArqHtml	:= ""
Local cCondPag	:= ""
Local cMailAp		:= ""
Local cNomUser	:= ""
Local cMailID		:= ""
Local lLiberado	:= .T.
Local cUserCnt	:= ""
Local lEncAuto	:= SuperGetMV("MV_CNMDEAT",.F.,.F.)

	oProcess:Finish()
	oProcess:Free()
	oProcess:= Nil	
	
	If cCheckBox1 == "A"  // Op็ใo Aprovar	
	
		//Abertura do Arquivo de Trabalho
		If (Select(cAliasSCR) > 0, (cAliasSCR)->(dbCloseArea()),"")
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Query dos aprovadores do contratos			             ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		cQuery := " SELECT * FROM "+RetSqlName("SCR")+"  "+CRLF	
		cQuery += " WHERE D_E_L_E_T_ <> '*' AND CR_FILIAL = '"+_cFilial+"' "+CRLF
		cQuery += " AND CR_TIPO = 'IM' AND CR_STATUS = '02' AND CR_NUM LIKE '"+cNumMed+"%' AND CR_GRUPO = '"+cGrpAprov+"' "+CRLF
				
		TcQuery cQuery New Alias (cAliasSCR)
			
		(cAliasSCR)->(dbGoTop())
		
		While (cAliasSCR)->(!EOF())
			//Faz  a libera็ใo do documento
			SCR->(DbGoTo((cAliasSCR)->R_E_C_N_O_))
			lRet := MaAlcDoc({(cAliasSCR)->CR_NUM,(cAliasSCR)->CR_TIPO,(cAliasSCR)->CR_TOTAL,(cAliasSCR)->CR_APROV,,(cAliasSCR)->CR_GRUPO,,,,,""},dDataBase,4,,(cAliasSCR)->CR_ITGRP)
			IF lRet
				A097ProcLib((cAliasSCR)->R_E_C_N_O_,2,,,,,dDataBase)
			Endif
			(cAliasSCR)->(dbSkip())
		EndDo
	
	
		//Abertura do Arquivo de Trabalho
		If (Select(cAliasSCR) > 0, (cAliasSCR)->(dbCloseArea()),"")
	
		//Verifica se exite documentos para serem liberado ainda
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Query dos aprovadores do contratos			             ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		cQuery := " SELECT CR_FILIAL, CR_USER, CR_APROV, CR_GRUPO, CR_NIVEL, CR_STATUS FROM "+RetSqlName("SCR")+"  "+CRLF	
		cQuery += " WHERE D_E_L_E_T_ <> '*' AND CR_FILIAL = '"+xFilial("SCR")+"' "+CRLF
		cQuery += " AND CR_TIPO = 'IM' AND CR_STATUS = '02' AND CR_NUM LIKE '"+cNumMed+"%' AND CR_GRUPO = '"+cGrpAprov+"' "+CRLF
		cQuery += " GROUP BY CR_FILIAL, CR_USER, CR_APROV, CR_GRUPO, CR_NIVEL, CR_STATUS "+CRLF
		
		TcQuery cQuery New Alias (cAliasSCR)
				
		(cAliasSCR)->(dbGoTop())		
		
		IF (cAliasSCR)->(!EOF())
			lLiberado := .f.
		Endif
	
		IF !lLiberado
		
			cStSheetA1 := ""
			cStSheetB1 := ""
			CND->(DbSetorder(1))
			CND->( DbSeek( cChaveMED ) )
			
			oProcess:=TWFProcess():New(cNomeWF,"Medi็ใo aguardando Aprova็ใo.")
			cArqHtml	:= "\workflow\AprovaMED.htm"
			oProcess:NewTask(cNomeWF,cArqHtml)
			oHtml   := oProcess:oHtml
				
			oHTML:ValByName('cChaveMED', CND->CND_FILIAL+CND->CND_CONTRA+CND->CND_REVISA+CND->CND_NUMERO+CND->CND_NUMMED)
			
			cUserCnt := POSICIONE("CN9",1, CND->CND_FILIAL+CND->CND_CONTRA+CND->CND_REVISA, "CN9_XUSRCT")
			cCondPag := POSICIONE("SE4",1,xFilial("SE4")+CND->CND_CONDPG,"E4_DESCRI")			
			
			cStSheetA1 += '	  <tr> '                                                                      
			cStSheetA1 += '	    <th align=center style="vertical-align: middle;" BGCOLOR=LIGHTGRAY>Unidade<br>' + FWFILIALNAME("01", CND->CND_FILIAL, 1) + '<br></th> '	
			cStSheetA1 += '	    <th align=center style="vertical-align: middle;" BGCOLOR=LIGHTGRAY>Solicitante<br>' + ALLTRIM(cUserCnt) + '<br></th> '
			cStSheetA1 += '	    <th align=center style="vertical-align: middle;" BGCOLOR=LIGHTGRAY>Num. Contrato<br>' + CND->CND_CONTRA+CND->CND_REVISA + '<br></th> '                                                                                           
			cStSheetA1 += '	    <th align=center style="vertical-align: middle;" BGCOLOR=LIGHTGRAY>Vlr. Contrato<br> R$ <br>' + Transform(CND->CND_VLCONT,"@E 999,999,999.99") + '<br></th> '
			cStSheetA1 += '	    <th align=center style="vertical-align: middle;" BGCOLOR=LIGHTGRAY>Num. Medi็ใo<br>' + CND->CND_NUMMED + '<br></th> '
			cStSheetA1 += '	    <th align=center style="vertical-align: middle;" BGCOLOR=LIGHTGRAY>Compet๊ncia<br>' + CND->CND_COMPET + '<br></th> '			
			cStSheetA1 += '	    <th align=center style="vertical-align: middle;" BGCOLOR=LIGHTGRAY>Data Inclusใo<br>' + DTOC(CND->CND_DTINIC) + '<br></th> '	
			cStSheetA1 += '	    <th align=center style="vertical-align: middle;" BGCOLOR=LIGHTGRAY>Vlr. Medi็ใo<br> R$ ' + Transform(CND->CND_VLTOT,"@E 999,999,999.99") + '<br></th> '
			cStSheetA1 += '	    <th align=center style="vertical-align: middle;" BGCOLOR=LIGHTGRAY>Cond. Pag.<br>' + cCondPag + '<br></th> '
			
			cStSheetA1 += '	</tr> '
			cStSheetA1 += '    <tr> '
			cStSheetA1 += '    	<th align=center style="vertical-align: middle;">Planilha<br></th> '
			cStSheetA1 += '	 	<th align=center style="vertical-align: middle;">Item<br></th> '
			cStSheetA1 += '	 	<th align=center style="vertical-align: middle;">Produto<br></th> '
			cStSheetA1 += '    	<th align=center style="vertical-align: middle;">Descri็ใo<br></th> '
			cStSheetA1 += '    	<th align=center style="vertical-align: middle;">Quantidade<br></th> '
			cStSheetA1 += '	 	<th align=center style="vertical-align: middle;">Vlr. Unitแrio<br></th> '
			cStSheetA1 += '	  	<th align=center style="vertical-align: middle;">Vlr. Total<br></th> '
			cStSheetA1 += '	 	<th align=center style="vertical-align: middle;">Fornecedor<br></th> '  
			cStSheetA1 += '	 	<th align=center style="vertical-align: middle;">Centro de Custo<br></th> '	
			cStSheetA1 += '    </tr> '
			
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Query das Itens Medi็ใo do contrato		             ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			cQuery := " SELECT CNE_FILIAL, CNE_NUMERO, CNE_ITEM, CNE_PRODUT, CNB_DESCRI, CNE_QUANT, CNE_VLUNIT, CNE_VLTOT, CNE_CC, CTT_DESC01, CNA_FORNEC, CNA_LJFORN, A2_NREDUZ "+CRLF
			cQuery += " FROM "+RetSqlName("CNE")+" CNE "+CRLF
			cQuery += " INNER JOIN "+RetSqlName("CNA")+" CNA ON CNA_FILIAL = CNE_FILIAL AND CNE_CONTRA = CNA_CONTRA AND CNE_REVISA = CNA_REVISA AND CNE_NUMERO = CNA_NUMERO AND CNA.D_E_L_E_T_ <> '*' "+CRLF
			cQuery += " INNER JOIN "+RetSqlName("CNB")+" CNB ON CNB_FILIAL = CNE_FILIAL AND CNE_CONTRA = CNB_CONTRA AND CNE_REVISA = CNB_REVISA  "+CRLF
			cQuery += " 								AND CNE_NUMERO = CNB_NUMERO AND CNE_ITEM = CNB_ITEM AND CNB.D_E_L_E_T_ <> '*' "+CRLF
			cQuery += " INNER JOIN "+RetSqlName("SA2")+" SA2 ON A2_FILIAL = '"+xFilial("SA2")+"' AND A2_COD = CNA_FORNEC AND A2_LOJA = CNA_LJFORN AND SA2.D_E_L_E_T_ <> '*' "+CRLF
			cQuery += " INNER JOIN "+RetSqlName("CTT")+" CTT ON CTT_FILIAL = '"+xFilial("CTT")+"' AND CTT_CUSTO = CNE_CC AND CTT.D_E_L_E_T_ <> '*' "+CRLF
			cQuery += " INNER JOIN "+RetSqlName("DBM")+" DBM ON DBM_FILIAL = CNE_FILIAL AND DBM_NUM LIKE CNE_NUMMED+CNE_NUMERO+'%' AND DBM_ITEM = CNE_ITEM AND DBM.D_E_L_E_T_ <> '*' "+CRLF
			cQuery += " WHERE CNE.D_E_L_E_T_ <> '*' AND CNE_FILIAL = '"+CND->CND_FILIAL+"' AND CNE_QUANT > 0 "+CRLF
			cQuery += " AND CNE_CONTRA =  '"+CND->CND_CONTRA+"' AND CNE_REVISA = '"+CND->CND_REVISA+"' "+CRLF
			cQuery += " AND CNE_NUMMED = '"+CND->CND_NUMMED+"' AND DBM_GRUPO = '"+(cAliasSCR)->CR_GRUPO+"' AND DBM_USER = '"+(cAliasSCR)->CR_USER+"' "+CRLF  //AND CNE_NUMERO = '"+CND->CND_NUMERO+"' 
			cQuery += " ORDER BY CNE_FILIAL, CNE_NUMMED, CNE_NUMERO, CNE_ITEM "+CRLF
		
			TcQuery cQuery New Alias (cAliasCNE)
					
			(cAliasCNE)->(dbGoTop())
		
			While (cAliasCNE)->(!EOF())
		
				cStSheetB1 += '    <tr> '
				cStSheetB1 += '     	<td align=center style="vertical-align: top;">' + (cAliasCNE)->CNE_NUMERO + '<br></td> '
				cStSheetB1 += '	   	<td align=center style="vertical-align: top;">' + (cAliasCNE)->CNE_ITEM + '<br></td> '
				cStSheetB1 += '	   	<td align=center style="vertical-align: top;">' + (cAliasCNE)->CNE_PRODUT + '<br></td> '
				cStSheetB1 += '     	<td align=left   style="vertical-align: top;">' + ALLTRIM((cAliasCNE)->CNB_DESCRI) + '</td> '
				cStSheetB1 += '     	<td align=center style="vertical-align: top;">' + CVALTOCHAR((cAliasCNE)->CNE_QUANT) + '</td> '
				cStSheetB1 += '	   	<td align=center style="vertical-align: top;">R$ ' + Transform((cAliasCNE)->CNE_VLUNIT,"@E 999,999.99") + '</td> '
				cStSheetB1 += '	  	<td align=center style="vertical-align: top;">R$ ' + Transform((cAliasCNE)->CNE_VLTOT,"@E 999,999.99") + '</td> '
				cStSheetB1 += '	  	<td align=left   style="vertical-align: top;">' + ALLTRIM((cAliasCNE)->A2_NREDUZ) + " - " + (cAliasCNE)->CNA_LJFORN + '</td> '                                        
				cStSheetB1 += '	  	<td align=left   style="vertical-align: top;">' + ALLTRIM((cAliasCNE)->CTT_DESC01) + '</td> '
				cStSheetB1 += '    </tr> '	
		
				(cAliasCNE)->(dbSkip())
			EndDo
			
			cStSheetB1 += '  </tbody> '
			cStSheetB1 += '</table> '
		
			oHTML:ValbyName("CodigoStyleSheetA1", cStSheetA1)
			oHTML:ValbyName("CodigoStyleSheetB1", cStSheetB1)
			oHTML:ValByName('cGrpAprov', (cAliasSCR)->CR_GRUPO )
						
			cNumMed	:= CND->CND_NUMMED
			cMailAp	:= UsrRetMail((cAliasSCR)->CR_USER)
			cNomUser	:= UsrRetName((cAliasSCR)->CR_USER)
			
			//temporario
			//IF Empty(cMailAp)
			//	cMailAp := "rafael.gama@oficinatec.com.br"
			//Endif
				
			oProcess:ClientName(USRRETNAME(__cUserID))
			oProcess:cTo      := cMailAp
			oProcess:cBCC     := ''
			oProcess:cSubject := "BSL Workflow: Medi็ใo " + cNumMed
			oProcess:cBody    := ""
			oProcess:bReturn  := "U_XGCT002R()"     //Define a Fun็ใo de Retorno
		
			//Uso um endereco invalido, apenas para criar o processo de workflow, mas sem envia-lo
			oProcess:cTo  := "000000" //"000001"
			oProcess:cCC  := NIL
			oProcess:cBCC := NIL
		
			cMailID    := oProcess:Start()  // Crio o processo e gravo o ID do processo de Workflow
		
			U_EnvLink(cMailID,cMailAp,"","",oProcess:cSubject, cFilAnt,"APROVAวรO DE MEDIวรO",oProcess,"000000", cNomUser,"6",cNumMed)
		
		ElseIF lEncAuto .AND. lLiberado
				
			//##################################
			//Verifica se nao existe nenhum grupo pendente 
			//##################################?
			//Abertura do Arquivo de Trabalho
			If (Select(cAliasSCR) > 0, (cAliasSCR)->(dbCloseArea()),"")
		
			//Verifica se exite documentos para serem liberado ainda
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Query dos aprovadores do contratos			             ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			cQuery := " SELECT CR_FILIAL, CR_USER, CR_APROV, CR_GRUPO, CR_NIVEL, CR_STATUS FROM "+RetSqlName("SCR")+"  "+CRLF	
			cQuery += " WHERE D_E_L_E_T_ <> '*' AND CR_FILIAL = '"+xFilial("SCR")+"' "+CRLF
			cQuery += " AND CR_TIPO = 'IM' AND CR_STATUS = '02' AND CR_NUM LIKE '"+cNumMed+"%' "+CRLF
			cQuery += " GROUP BY CR_FILIAL, CR_USER, CR_APROV, CR_GRUPO, CR_NIVEL, CR_STATUS "+CRLF
			
			TcQuery cQuery New Alias (cAliasSCR)
					
			(cAliasSCR)->(dbGoTop())		
			
			IF (cAliasSCR)->(!EOF())
				lLiberado := .f.
			Else
			
				IF Type("INCLUI") == "U"
					INCLUI := .F.
					ALTERA := .T.
				Endif
			
				CN121Encerr(.T.)
			Endif
		Endif

	EndIf	
	
	If cCheckBox1 == "R"  //Op็ใo Rejeitado
		
		CND->(DbSetorder(1))
		CND->( DbSeek( cChaveMED ) )
		
		cUserCnt := POSICIONE("CN9",1, CND->CND_FILIAL+CND->CND_CONTRA+CND->CND_REVISA, "CN9_XUSRCT")
		
		//Abertura do Arquivo de Trabalho
		If (Select(cAliasSCR) > 0, (cAliasSCR)->(dbCloseArea()),"")
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Query dos aprovadores do contratos			             ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		cQuery := " SELECT * FROM "+RetSqlName("SCR")+"  "+CRLF	
		cQuery += " WHERE D_E_L_E_T_ <> '*' AND CR_FILIAL = '"+_cFilial+"' "+CRLF
		cQuery += " AND CR_TIPO = 'IM' AND CR_STATUS = '02' AND CR_NUM LIKE '"+cNumMed+"%' "+CRLF
				
		TcQuery cQuery New Alias (cAliasSCR)
			
		(cAliasSCR)->(dbGoTop())
		
		While (cAliasSCR)->(!EOF())
			//Faz  a libera็ใo do documento
			SCR->(DbGoTo( (cAliasSCR)->R_E_C_N_O_ ))
			lRet := CnRejDoc((cAliasSCR)->CR_TIPO)
			
			IF lRet
				Exit
			Endif
			(cAliasSCR)->(dbSkip())
		EndDo
	
		// Envia o e-mail para o responsแvel pelo contrato com o motivo da rejei็ใo.
		oProcess:=TWFProcess():New(cNomeWF,"Medi็ใo com Aprova็ใo Rejeitada.")
		cArqHtml	:= "\workflow\WFMEDREJEITADO.htm"
		oProcess:NewTask(cNomeWF,cArqHtml)
		oHtml   := oProcess:oHtml
	
		oHTML:ValByName('cUnidade', FWFILIALNAME("01", CND->CND_FILIAL, 1))
		oHTML:ValByName('cNumMed', cNumMed)
		oHTML:ValByName('cMOTIVO', cMotivo)
	
		//Pega email do dono do Contrato		
		PswOrder(2)
		If PswSeek( cUserCnt, .T. )
			cMailAp := UsrRetMail(PswID())
		Endif
	
		//temporario
		//IF Empty(cMailAp)
		//	cMailAp := "rafael.gama@oficinatec.com.br"
		//Endif
		
		oProcess:ClientName(cUserCnt)
		oProcess:cTo      := cMailAp
		oProcess:cBCC     := ''
		oProcess:cSubject := "BSL Workflow: Medi็ใo " + cNumMed + " rejeitada!" 
		oProcess:cBody    := ""
		oProcess:bReturn  := ""
		cMailID    := oProcess:Start()  // Crio o processo e gravo o ID do processo de Workflow	
	
	Endif
			
	//Abertura do Arquivo de Trabalho	
	If (Select(cAliasSCR) > 0, (cAliasSCR)->(dbCloseArea()),"")
	If (Select(cAliasCNE) > 0, (cAliasCNE)->(dbCloseArea()),"")		
			
RestArea(aAreaCND)
RestArea(aAreaSCR)
RestArea(aAreaCNE)

Return