#Include 'Protheus.ch'
#INCLUDE "TopConn.ch"
#INCLUDE "TbiConn.ch" 
#include "Fileio.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ XGCT001 บAutor  ณRafael Gama-Oficina1 บ Data ณ  12/02/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPrograma para envio de Workflow para aprovacao do Contrato. บฑฑ
ฑฑบ          ณ Chamado pelo PE (CN100SIT).             					    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BSL																บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function XGCT001()

	Local cAliasSCR 	:= GetNextAlias()
	Local cAliasCNB 	:= GetNextAlias()
	Local cAliasAC9	:= GetNextAlias()
	Local aArea		:= GetArea()
	Local aAreaSCR	:= SCR->(GetArea())
	Local aAreaCNB	:= CNB->(GetArea())
	Local cQuery		:= ""
	Local oProcess	:= Nil
	Local oHtml		:= Nil
	Local cNomeWF 	:= 'APROVACNT'
	Local cStSheetA1 	:= "" 
	Local cStSheetB1 	:= ""
	Local cArqHtml	:= ""
	Local cTipoCnt	:= ""
	Local cCondPag	:= ""
	Local cNumCont	:= ""
	Local cMailAp		:= ""
	Local cNomUser	:= ""
	Local cMailID		:= ""
	Local cDirDocs	:= MsDocPath()
	Local aAnexo		:= {}
	Local nX			:= 0
	Local cSubject	:= ""

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Abertura do Arquivo de Trabalho                        ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If (Select(cAliasSCR) > 0, (cAliasSCR)->(dbCloseArea()),"")
	If (Select(cAliasCNB) > 0, (cAliasCNB)->(dbCloseArea()),"")	
	If (Select(cAliasAC9) > 0, (cAliasAC9)->(dbCloseArea()),"")

	// Verifica se existe banco de conhecimento
	cQuery := " SELECT * FROM "+RetSqlName("AC9")+" AC9 "+CRLF
	cQuery += " INNER JOIN "+RetSqlName("ACB")+" ACB ON ACB_FILIAL = AC9_FILIAL AND ACB_CODOBJ =AC9_CODOBJ AND ACB.D_E_L_E_T_ <> '*'  "+CRLF
	cQuery += " WHERE AC9.D_E_L_E_T_ <> '*' AND AC9_ENTIDA = 'CN9'  "+CRLF
	cQuery += " AND AC9_CODENT = '"+CN9->CN9_NUMERO+"' "+CRLF

	TcQuery cQuery New Alias (cAliasAC9)

	(cAliasAC9)->(dbGoTop())
	//Adiciona os arquivos do banco do conhecimento no array
	While (cAliasAC9)->(!EOF())
		AADD(aAnexo, cDirDocs+"\"+ALLTRIM((cAliasAC9)->ACB_OBJETO) )
		(cAliasAC9)->(dbSkip())
	EndDo

	oProcess:=TWFProcess():New(cNomeWF,"Contrato aguardando Aprovacao.")
	cArqHtml	:= "\workflow\AprovaCNT.htm"
	oProcess:NewTask(cNomeWF,cArqHtml)
	oHtml   := oProcess:oHtml

	IF Len(aAnexo) > 0 // adiciona os arquivos do banco de conhecimento no e-mail
		For nX := 1 To Len(aAnexo)
			oProcess:AttachFile(aAnexo[nX])	
		Next 
	Endif

	oHTML:ValByName('cChaveCNT', CN9->CN9_FILIAL+CN9->CN9_NUMERO+CN9->CN9_REVISA)
	oHTML:ValByName('OBJETO', MSMM( CN9->CN9_CODOBJ, 90 ))

	cTipoCnt := POSICIONE("CN1",1,xFilial("CN1")+CN9->CN9_TPCTO,"CN1_DESCRI")	
	cCondPag := POSICIONE("SE4",1,xFilial("SE4")+CN9->CN9_CONDPG,"E4_DESCRI")	

	cStSheetA1 += '	  <tr> '                                                                      
	cStSheetA1 += '	    <th align=center style="vertical-align: middle;" BGCOLOR=LIGHTGRAY>Unidade<br>' + FWFILIALNAME("01", CN9->CN9_FILIAL, 1) + '<br></th> '	
	cStSheetA1 += '	    <th align=center style="vertical-align: middle;" BGCOLOR=LIGHTGRAY>Contratante<br>' + ALLTRIM(CN9->CN9_XUSRCT) + '<br></th> '
	cStSheetA1 += '	    <th align=center style="vertical-align: middle;" BGCOLOR=LIGHTGRAY>Tipo Contr.<br>' + cTipoCnt + '<br></th> '                                                                                           
	cStSheetA1 += '	    <th align=center style="vertical-align: middle;" BGCOLOR=LIGHTGRAY>Num. Contrato<br>' + CN9->CN9_NUMERO+IF(EMPTY(CN9->CN9_REVISA),"","-"+CN9->CN9_REVISA) + '<br></th> '
	cStSheetA1 += '	    <th align=center style="vertical-align: middle;" BGCOLOR=LIGHTGRAY>Data Inํcio<br>' + DTOC(CN9->CN9_DTINIC) + '<br></th> '	
	cStSheetA1 += '	    <th align=center style="vertical-align: middle;" BGCOLOR=LIGHTGRAY>Dt Assinatura<br>' + DTOC(CN9->CN9_DTASSI) + '<br></th> '
	cStSheetA1 += '	    <th align=center style="vertical-align: middle;" BGCOLOR=LIGHTGRAY>Data Final<br>' + DTOC(CN9->CN9_DTFIM) + '<br></th> '
	cStSheetA1 += '	    <th align=center style="vertical-align: middle;" BGCOLOR=LIGHTGRAY>Vlr. Contrato<br> R$ ' + Transform(CN9->CN9_VLATU,"@E 999,999,999.99") + '<br></th> '
	cStSheetA1 += '	    <th align=center style="vertical-align: middle;" BGCOLOR=LIGHTGRAY>Cond. Pag.<br>' + cCondPag + '<br></th> '

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Query das Planilhas do contrato			             ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cQuery := " SELECT CNB_FILIAL, CNB_NUMERO, CNB_ITEM, CNB_PRODUT, CNB_DESCRI, CNB_QUANT, CNB_VLUNIT, CNB_VLTOT,  "+CRLF
	cQuery += " CNB_CC, CTT_DESC01, CNA_FORNEC, CNA_LJFORN, A2_NREDUZ "+CRLF
	cQuery += " FROM "+RetSqlName("CNB")+" CNB "+CRLF
	cQuery += " INNER JOIN "+RetSqlName("CNA")+" CNA ON CNA_FILIAL = CNB_FILIAL AND CNB_CONTRA = CNA_CONTRA AND CNB_REVISA = CNA_REVISA AND CNB_NUMERO = CNA_NUMERO AND CNA.D_E_L_E_T_ <> '*' "+CRLF
	cQuery += " INNER JOIN "+RetSqlName("SA2")+" SA2 ON A2_FILIAL = '"+xFilial("SA2")+"' AND A2_COD = CNA_FORNEC AND A2_LOJA = CNA_LJFORN AND SA2.D_E_L_E_T_ <> '*' "+CRLF
	cQuery += " INNER JOIN "+RetSqlName("CTT")+" CTT ON CTT_FILIAL = '"+xFilial("CTT")+"' AND CTT_CUSTO = CNB_CC AND CTT.D_E_L_E_T_ <> '*' "+CRLF	
	cQuery += " WHERE CNB.D_E_L_E_T_ <> '*' AND CNB_FILIAL = '"+CN9->CN9_FILIAL+"' "+CRLF
	cQuery += " AND CNB_CONTRA = '"+CN9->CN9_NUMERO+"' AND CNB_REVISA = '"+CN9->CN9_REVISA+"' "+CRLF
	cQuery += " ORDER BY CNB_FILIAL, CNB_NUMERO, CNB_ITEM "+CRLF

	TcQuery cQuery New Alias (cAliasCNB)

	(cAliasCNB)->(dbGoTop())

	If  (cAliasCNB)->(!EOF())

		cStSheetA1 += '	</tr> '
		cStSheetA1 += '    <tr> '
		cStSheetA1 += '    	<th align=center style="vertical-align: middle;">Planilha<br></th> '
		cStSheetA1 += '	 	<th align=center style="vertical-align: middle;">Item<br></th> '
		cStSheetA1 += '	 	<th align=center style="vertical-align: middle;">Produto<br></th> '
		cStSheetA1 += '    	<th align=center style="vertical-align: middle;">Descricao<br></th> '
		cStSheetA1 += '    	<th align=center style="vertical-align: middle;">Quantidade<br></th> '
		cStSheetA1 += '	 	<th align=center style="vertical-align: middle;">Vlr. Unitแrio<br></th> '
		cStSheetA1 += '	  	<th align=center style="vertical-align: middle;">Vlr. Total<br></th> '
		cStSheetA1 += '	 	<th align=center style="vertical-align: middle;">Fornecedor<br></th> '  
		cStSheetA1 += '	 	<th align=center style="vertical-align: middle;">Centro de Custo<br></th> '	
		cStSheetA1 += '    </tr> '		
	Endif

	While (cAliasCNB)->(!EOF())

		cStSheetB1 += '    <tr> '
		cStSheetB1 += '     	<td align=center style="vertical-align: top;">' + (cAliasCNB)->CNB_NUMERO + '<br></td> '
		cStSheetB1 += '	   	<td align=center style="vertical-align: top;">' + (cAliasCNB)->CNB_ITEM + '<br></td> '
		cStSheetB1 += '	   	<td align=center style="vertical-align: top;">' + (cAliasCNB)->CNB_PRODUT + '<br></td> '
		cStSheetB1 += '     	<td align=left   style="vertical-align: top;">' + ALLTRIM((cAliasCNB)->CNB_DESCRI) + '</td> '
		cStSheetB1 += '     	<td align=center style="vertical-align: top;">' + CVALTOCHAR((cAliasCNB)->CNB_QUANT) + '</td> '
		cStSheetB1 += '	   	<td align=center style="vertical-align: top;">R$ ' + Transform((cAliasCNB)->CNB_VLUNIT,"@E 999,999.99") + '</td> '
		cStSheetB1 += '	  	<td align=center style="vertical-align: top;">R$ ' + Transform((cAliasCNB)->CNB_VLTOT,"@E 999,999.99") + '</td> '
		cStSheetB1 += '	  	<td align=left   style="vertical-align: top;">' + ALLTRIM((cAliasCNB)->A2_NREDUZ) + " - " + (cAliasCNB)->CNA_LJFORN + '</td> '                                        
		cStSheetB1 += '	  	<td align=left   style="vertical-align: top;">' + ALLTRIM((cAliasCNB)->CTT_DESC01) + '</td> '
		cStSheetB1 += '    </tr> '	

		(cAliasCNB)->(dbSkip())
	EndDo

	cStSheetB1 += '  </tbody> '
	cStSheetB1 += '</table> '

	oHTML:ValbyName("CodigoStyleSheetA1", cStSheetA1)
	oHTML:ValbyName("CodigoStyleSheetB1", cStSheetB1)	

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Query dos aprovadores do contratos			             ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cQuery := " SELECT CR_FILIAL, CR_USER, CR_APROV, CR_NIVEL, CR_STATUS FROM "+RetSqlName("SCR")+"  "+CRLF	
	cQuery += " WHERE D_E_L_E_T_ <> '*' AND CR_FILIAL = '"+xFilial("SCR")+"' "+CRLF
	cQuery += " AND CR_TIPO IN ('IC','CT','RV') AND CR_STATUS = '02' AND CR_NUM LIKE '"+CN9->CN9_NUMERO+CN9->CN9_REVISA+"%' "+CRLF
	cQuery += " GROUP BY CR_FILIAL, CR_USER, CR_APROV, CR_NIVEL, CR_STATUS "+CRLF

	TcQuery cQuery New Alias (cAliasSCR)

	(cAliasSCR)->(dbGoTop())

	cNumCont	:= CN9->CN9_NUMERO+IF(EMPTY(CN9->CN9_REVISA),"","-"+CN9->CN9_REVISA)
	cSubject	:=	IF( CN9->CN9_SITUACA == "09","BSL Workflow: Revisao do Contrato ","BSL Workflow: Contrato " ) 
	cMailAp	:= UsrRetMail((cAliasSCR)->CR_USER)
	cNomUser	:= UsrRetName((cAliasSCR)->CR_USER)

	//temporario
	//IF Empty(cMailAp)
	//	cMailAp := "rafael.gama@oficinatec.com.br"
	//Endif

	oProcess:ClientName(USRRETNAME(__cUserID))
	oProcess:cTo      := cMailAp
	oProcess:cBCC     := ''
	oProcess:cSubject := cSubject + cNumCont
	oProcess:cBody    := ""
	oProcess:bReturn  := "U_XGCT001R()"     //Define a Funcao de Retorno

	//Uso um endereco invalido, apenas para criar o processo de workflow, mas sem envia-lo
	oProcess:cTo  := "000000" //"000001"
	oProcess:cCC  := NIL
	oProcess:cBCC := NIL

	cMailID    := oProcess:Start()  // Crio o processo e gravo o ID do processo de Workflow

	U_EnvLink(cMailID,cMailAp,"","",oProcess:cSubject, cFilAnt,"APROVAcaO DE CONTRATOS",oProcess,"000000", cNomUser,"5",cNumCont)

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Abertura do Arquivo de Trabalho                        ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If (Select(cAliasSCR) > 0, (cAliasSCR)->(dbCloseArea()),"")
	If (Select(cAliasCNB) > 0, (cAliasCNB)->(dbCloseArea()),"")
	If (Select(cAliasAC9) > 0, (cAliasAC9)->(dbCloseArea()),"")

	RestArea(aArea)
	RestArea(aAreaSCR)
	RestArea(aAreaCNB)

Return

/*
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
++-------------------------------------------------------------------------++
++ Fun็ใo    | ReeMDApr   | Autor  | Filipe Silva      | Data | 12/07/2019 ++
++-------------------------------------------------------------------------++
++ Descri็ใo | Reenvia e-mail de WF MD									   ++
++-------------------------------------------------------------------------++
++ Obs       |  Rotina chamada pelo PE: CNT121BT                           ++
++-------------------------------------------------------------------------++
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
*/

User Function ReeMDApr()

	IF CND->CND_ALCAPR <> "L" .AND. CND->CND_RESID <> "S" 
		U_XGCT001(CND->CND_FILIAL, CND->CND_NUMMED)
		MSGALERT("E-mail enviado com sucesso.")
	Else
		MSGALERT("Status nใo permitido para o reenvio do WF MD!")
	Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ XGCT001RบAutor  ณRafael Gama-Oficina1 บ Data ณ  14/02/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPrograma para o tratamento da resposta do Workflow de       บฑฑ
ฑฑบ          ณ aprovacao do Contrato. Chamado pelo HTML (AprovaCNT.htm).  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BSL													      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function XGCT001R(oProcess)

	Local cAliasSCR := GetNextAlias()
	Local cAliasCNB := GetNextAlias()
	Local cAliasAC9	:= GetNextAlias()
	Local aAreaCN9	:= CN9->(GetArea())
	Local aAreaSCR	:= SCR->(GetArea())
	Local aAreaCNB	:= CNB->(GetArea())
	Local cQuery		:= ""

	Local cChaveCNT	:= oProcess:oHtml:RetByName("cChaveCNT")
	Local _cFilial	:= SubStr(cChaveCNT, 1, LEN(cFilAnt))
	Local cNumCont 	:= SubStr(cChaveCNT, LEN(cFilAnt)+1, TamSX3("CN9_NUMERO")[1]+TamSX3("CN9_REVISA")[1])
	Local cCheckBox1:= AllTrim(oProcess:oHtml:RetByName('AprRej1'))
	Local cMotivo	:= AllTrim(oProcess:oHtml:RetByName('OBSERVAC1'))
	Local oHtml		:= Nil
	Local cNomeWF 	:= 'APROVACNT'
	Local cStSheetA1:= "" 
	Local cStSheetB1:= ""
	Local cArqHtml	:= ""
	Local cTipoCnt	:= ""
	Local cCondPag	:= ""
	Local cMailAp	:= ""
	Local cNomUser	:= ""
	Local cMailID	:= ""
	Local lLiberado	:= .T.
	Local cDirDocs	:= MsDocPath()
	Local aAnexo	:= {}
	Local nX		:= 0
	Local cSubject	:= ""

	oProcess:Finish()
	oProcess:Free()
	oProcess:= Nil

	If cCheckBox1 == "A"  // Opcao Aprovar

		//Abertura do Arquivo de Trabalho
		If (Select(cAliasSCR) > 0, (cAliasSCR)->(dbCloseArea()),"")
		If (Select(cAliasCNB) > 0, (cAliasCNB)->(dbCloseArea()),"")
		If (Select(cAliasAC9) > 0, (cAliasAC9)->(dbCloseArea()),"")

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Query dos aprovadores do contratos			             ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		cQuery := " SELECT * FROM "+RetSqlName("SCR")+"  "+CRLF	
		cQuery += " WHERE D_E_L_E_T_ <> '*' AND CR_FILIAL = '"+_cFilial+"' "+CRLF
		cQuery += " AND CR_TIPO IN ('IC','CT','RV') AND CR_STATUS = '02' AND CR_NUM LIKE '"+cNumCont+"%' "+CRLF

		TcQuery cQuery New Alias (cAliasSCR)

		(cAliasSCR)->(dbGoTop())

		While (cAliasSCR)->(!EOF())
			//Faz  a liberacao do documento
			IF (cAliasSCR)->CR_TIPO == 'IC'
				lRet := MaAlcDoc({(cAliasSCR)->CR_NUM,(cAliasSCR)->CR_TIPO,(cAliasSCR)->CR_TOTAL,(cAliasSCR)->CR_APROV,,(cAliasSCR)->CR_GRUPO,,,,,""},dDataBase,4,,(cAliasSCR)->CR_ITGRP)
			Else
				SCR->(DbGoTo((cAliasSCR)->R_E_C_N_O_))
				lRet := MaAlcDoc({(cAliasSCR)->CR_NUM,(cAliasSCR)->CR_TIPO,(cAliasSCR)->CR_TOTAL,(cAliasSCR)->CR_APROV,,(cAliasSCR)->CR_GRUPO,,,,,""},dDataBase,4)
			Endif

			IF lRet .AND. (cAliasSCR)->CR_TIPO <> 'RV'
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
		cQuery := " SELECT CR_FILIAL, CR_USER, CR_APROV, CR_NIVEL, CR_STATUS FROM "+RetSqlName("SCR")+"  "+CRLF	
		cQuery += " WHERE D_E_L_E_T_ <> '*' AND CR_FILIAL = '"+xFilial("SCR")+"' "+CRLF
		cQuery += " AND CR_TIPO IN ('IC','CT','RV') AND CR_STATUS = '02' AND CR_NUM LIKE '"+cNumCont+"%' "+CRLF
		cQuery += " GROUP BY CR_FILIAL, CR_USER, CR_APROV, CR_NIVEL, CR_STATUS "+CRLF

		TcQuery cQuery New Alias (cAliasSCR)

		(cAliasSCR)->(dbGoTop())		

		IF (cAliasSCR)->(!EOF())
			lLiberado := .f.
		Endif

		IF !lLiberado

			cStSheetA1 := ""
			cStSheetB1 := ""
			CN9->(DbSetorder(1))
			CN9->( DbSeek( cChaveCNT ) )

			// Verifica se existe banco de conhecimento
			cQuery := " SELECT * FROM "+RetSqlName("AC9")+" AC9 "+CRLF
			cQuery += " INNER JOIN "+RetSqlName("ACB")+" ACB ON ACB_FILIAL = AC9_FILIAL AND ACB_CODOBJ =AC9_CODOBJ AND ACB.D_E_L_E_T_ <> '*'  "+CRLF
			cQuery += " WHERE AC9.D_E_L_E_T_ <> '*' AND AC9_ENTIDA = 'CN9'  "+CRLF
			cQuery += " AND AC9_CODENT = '"+CN9->CN9_NUMERO+"' "+CRLF

			TcQuery cQuery New Alias (cAliasAC9)

			(cAliasAC9)->(dbGoTop())
			//Adiciona os arquivos do banco do conhecimento no array
			While (cAliasAC9)->(!EOF())
				AADD(aAnexo, cDirDocs+"\"+ALLTRIM((cAliasAC9)->ACB_OBJETO) )
				(cAliasAC9)->(dbSkip())
			EndDo			

			oProcess:=TWFProcess():New(cNomeWF,"Contrato aguardando Aprovacao.")
			cArqHtml	:= "\workflow\AprovaCNT.htm"
			oProcess:NewTask(cNomeWF,cArqHtml)
			oHtml   := oProcess:oHtml

			IF Len(aAnexo) > 0  // adiciona os arquivos do banco de conhecimento no e-mail
				For nX := 1 To Len(aAnexo)
					oProcess:AttachFile(aAnexo[nX])	
				Next 
			Endif

			oHTML:ValByName('cChaveCNT', CN9->CN9_FILIAL+CN9->CN9_NUMERO+CN9->CN9_REVISA)
			oHTML:ValByName('OBJETO', MSMM( CN9->CN9_CODOBJ, 90 ))

			cTipoCnt := POSICIONE("CN1",1,xFilial("CN1")+CN9->CN9_TPCTO,"CN1_DESCRI")	
			cCondPag := POSICIONE("SE4",1,xFilial("SE4")+CN9->CN9_CONDPG,"E4_DESCRI")	

			cStSheetA1 += '	  <tr> '                                                                      
			cStSheetA1 += '	    <th align=center style="vertical-align: middle;" BGCOLOR=LIGHTGRAY>Unidade<br>' + FWFILIALNAME("01", CN9->CN9_FILIAL, 1) + '<br></th> '	
			cStSheetA1 += '	    <th align=center style="vertical-align: middle;" BGCOLOR=LIGHTGRAY>Contratante<br>' + ALLTRIM(CN9->CN9_XUSRCT) + '<br></th> '
			cStSheetA1 += '	    <th align=center style="vertical-align: middle;" BGCOLOR=LIGHTGRAY>Tipo Contr.<br>' + cTipoCnt + '<br></th> '                                                                                           
			cStSheetA1 += '	    <th align=center style="vertical-align: middle;" BGCOLOR=LIGHTGRAY>Num. Contrato<br>' + CN9->CN9_NUMERO+IF(EMPTY(CN9->CN9_REVISA),"","-"+CN9->CN9_REVISA) + '<br></th> '
			cStSheetA1 += '	    <th align=center style="vertical-align: middle;" BGCOLOR=LIGHTGRAY>Data Inํcio<br>' + DTOC(CN9->CN9_DTINIC) + '<br></th> '	
			cStSheetA1 += '	    <th align=center style="vertical-align: middle;" BGCOLOR=LIGHTGRAY>Dt Assinatura<br>' + DTOC(CN9->CN9_DTASSI) + '<br></th> '
			cStSheetA1 += '	    <th align=center style="vertical-align: middle;" BGCOLOR=LIGHTGRAY>Data Final<br>' + DTOC(CN9->CN9_DTFIM) + '<br></th> '
			cStSheetA1 += '	    <th align=center style="vertical-align: middle;" BGCOLOR=LIGHTGRAY>Vlr. Contrato<br> R$ ' + Transform(CN9->CN9_VLATU,"@E 999,999,999.99") + '<br></th> '
			cStSheetA1 += '	    <th align=center style="vertical-align: middle;" BGCOLOR=LIGHTGRAY>Cond. Pag.<br>' + cCondPag + '<br></th> '


			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Query das Planilhas do contrato			             ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			cQuery := " SELECT CNB_FILIAL, CNB_NUMERO, CNB_ITEM, CNB_PRODUT, CNB_DESCRI, CNB_QUANT, CNB_VLUNIT, CNB_VLTOT,  "+CRLF
			cQuery += " CNB_CC, CTT_DESC01, CNA_FORNEC, CNA_LJFORN, A2_NREDUZ "+CRLF
			cQuery += " FROM "+RetSqlName("CNB")+" CNB "+CRLF
			cQuery += " INNER JOIN "+RetSqlName("CNA")+" CNA ON CNA_FILIAL = CNB_FILIAL AND CNB_CONTRA = CNA_CONTRA AND CNB_REVISA = CNA_REVISA AND CNB_NUMERO = CNA_NUMERO AND CNA.D_E_L_E_T_ <> '*' "+CRLF
			cQuery += " INNER JOIN "+RetSqlName("SA2")+" SA2 ON A2_FILIAL = '"+xFilial("SA2")+"' AND A2_COD = CNA_FORNEC AND A2_LOJA = CNA_LJFORN AND SA2.D_E_L_E_T_ <> '*' "+CRLF
			cQuery += " INNER JOIN "+RetSqlName("CTT")+" CTT ON CTT_FILIAL = '"+xFilial("CTT")+"' AND CTT_CUSTO = CNB_CC AND CTT.D_E_L_E_T_ <> '*' "+CRLF	
			cQuery += " WHERE CNB.D_E_L_E_T_ <> '*' AND CNB_FILIAL = '"+CN9->CN9_FILIAL+"' "+CRLF
			cQuery += " AND CNB_CONTRA = '"+CN9->CN9_NUMERO+"' AND CNB_REVISA = '"+CN9->CN9_REVISA+"' "+CRLF
			cQuery += " ORDER BY CNB_FILIAL, CNB_NUMERO, CNB_ITEM "+CRLF

			TcQuery cQuery New Alias (cAliasCNB)

			(cAliasCNB)->(dbGoTop())

			If (cAliasCNB)->(!EOF())

				cStSheetA1 += '	</tr> '
				cStSheetA1 += '    <tr> '
				cStSheetA1 += '    	<th align=center style="vertical-align: middle;">Planilha<br></th> '
				cStSheetA1 += '	 	<th align=center style="vertical-align: middle;">Item<br></th> '
				cStSheetA1 += '	 	<th align=center style="vertical-align: middle;">Produto<br></th> '
				cStSheetA1 += '    	<th align=center style="vertical-align: middle;">Descricao<br></th> '
				cStSheetA1 += '    	<th align=center style="vertical-align: middle;">Quantidade<br></th> '
				cStSheetA1 += '	 	<th align=center style="vertical-align: middle;">Vlr. Unitแrio<br></th> '
				cStSheetA1 += '	  	<th align=center style="vertical-align: middle;">Vlr. Total<br></th> '
				cStSheetA1 += '	 	<th align=center style="vertical-align: middle;">Fornecedor<br></th> '  
				cStSheetA1 += '	 	<th align=center style="vertical-align: middle;">Centro de Custo<br></th> '	
				cStSheetA1 += '    </tr> '

			Endif

			While (cAliasCNB)->(!EOF())

				cStSheetB1 += '    <tr> '
				cStSheetB1 += '     	<td align=center style="vertical-align: top;">' + (cAliasCNB)->CNB_NUMERO + '<br></td> '
				cStSheetB1 += '	   	<td align=center style="vertical-align: top;">' + (cAliasCNB)->CNB_ITEM + '<br></td> '
				cStSheetB1 += '	   	<td align=center style="vertical-align: top;">' + (cAliasCNB)->CNB_PRODUT + '<br></td> '
				cStSheetB1 += '     	<td align=left   style="vertical-align: top;">' + ALLTRIM((cAliasCNB)->CNB_DESCRI) + '</td> '
				cStSheetB1 += '     	<td align=center style="vertical-align: top;">' + CVALTOCHAR((cAliasCNB)->CNB_QUANT) + '</td> '
				cStSheetB1 += '	   	<td align=center style="vertical-align: top;">R$ ' + Transform((cAliasCNB)->CNB_VLUNIT,"@E 999,999.99") + '</td> '
				cStSheetB1 += '	  	<td align=center style="vertical-align: top;">R$ ' + Transform((cAliasCNB)->CNB_VLTOT,"@E 999,999.99") + '</td> '
				cStSheetB1 += '	  	<td align=left   style="vertical-align: top;">' + ALLTRIM((cAliasCNB)->A2_NREDUZ) + " - " + (cAliasCNB)->CNA_LJFORN + '</td> '                                        
				cStSheetB1 += '	  	<td align=left   style="vertical-align: top;">' + ALLTRIM((cAliasCNB)->CTT_DESC01) + '</td> '
				cStSheetB1 += '    </tr> '	

				(cAliasCNB)->(dbSkip())
			EndDo

			cStSheetB1 += '  </tbody> '
			cStSheetB1 += '</table> '

			oHTML:ValbyName("CodigoStyleSheetA1", cStSheetA1)
			oHTML:ValbyName("CodigoStyleSheetB1", cStSheetB1)

			cNumCont	:= CN9->CN9_NUMERO+IF(EMPTY(CN9->CN9_REVISA),"","-"+CN9->CN9_REVISA)
			cSubject	:=	IF( CN9->CN9_SITUACA == "09","BSL Workflow: Revisao do Contrato ","BSL Workflow: Contrato " )
			cMailAp	:= UsrRetMail((cAliasSCR)->CR_USER)
			cNomUser	:= UsrRetName((cAliasSCR)->CR_USER)

			//temporario
			//IF Empty(cMailAp)
			//	cMailAp := "rafael.gama@oficinatec.com.br"
			//Endif

			oProcess:ClientName(USRRETNAME(__cUserID))
			oProcess:cTo      := cMailAp
			oProcess:cBCC     := ''
			oProcess:cSubject := cSubject + cNumCont
			oProcess:cBody    := ""
			oProcess:bReturn  := "U_XGCT001R()"     //Define a Funcao de Retorno

			//Uso um endereco invalido, apenas para criar o processo de workflow, mas sem envia-lo
			oProcess:cTo  := "000000" //"000001"
			oProcess:cCC  := NIL
			oProcess:cBCC := NIL

			cMailID    := oProcess:Start()  // Crio o processo e gravo o ID do processo de Workflow

			U_EnvLink(cMailID,cMailAp,"","",oProcess:cSubject, cFilAnt,"APROVAcaO DE CONTRATOS",oProcess,"000000", cNomUser,"5",cNumCont)

		Endif

	EndIf

	If cCheckBox1 == "R"  //Opcao Rejeitado

		CN9->(DbSetorder(1))
		CN9->( DbSeek( cChaveCNT ) )

		//Abertura do Arquivo de Trabalho
		If (Select(cAliasSCR) > 0, (cAliasSCR)->(dbCloseArea()),"")

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Query dos aprovadores do contratos			             ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		cQuery := " SELECT * FROM "+RetSqlName("SCR")+"  "+CRLF	
		cQuery += " WHERE D_E_L_E_T_ <> '*' AND CR_FILIAL = '"+_cFilial+"' "+CRLF
		cQuery += " AND CR_TIPO IN ('IC','CT','RV') AND CR_STATUS = '02' AND CR_NUM LIKE '"+cNumCont+"%' "+CRLF
		//cQuery += " GROUP BY CR_FILIAL, CR_USER, CR_APROV, CR_NIVEL, CR_STATUS "+CRLF

		TcQuery cQuery New Alias (cAliasSCR)

		(cAliasSCR)->(dbGoTop())

		While (cAliasSCR)->(!EOF())
			//Faz  a liberacao do documento
			SCR->(DbGoTo( (cAliasSCR)->R_E_C_N_O_ ))
			lRet := CnRejDoc((cAliasSCR)->CR_TIPO)

			IF lRet
				//MaAlcDoc({(cAliasSCR)->CR_NUM,(cAliasSCR)->CR_TIPO,(cAliasSCR)->CR_TOTAL,(cAliasSCR)->CR_APROV,,(cAliasSCR)->CR_GRUPO,,,,dDataBase,cMotivo},dDataBase,7,,(cAliasSCR)->CR_ITGRP,,,,,cChaveCNT)				
				//A097ProcLib((cAliasSCR)->R_E_C_N_O_,7,,,,cMotivo)
				Exit
			Endif
			(cAliasSCR)->(dbSkip())
		EndDo

		// Envia o e-mail para o responsแvel pelo contrato com o motivo da rejeicao.
		oProcess:=TWFProcess():New(cNomeWF,"Contrato com Aprovacao Rejeitada.")
		cArqHtml	:= "\workflow\WFCNTREJEITADO.htm"
		oProcess:NewTask(cNomeWF,cArqHtml)
		oHtml   := oProcess:oHtml

		oHTML:ValByName('cUnidade', FWFILIALNAME("01", CN9->CN9_FILIAL, 1))
		oHTML:ValByName('cNumCont', CN9->CN9_NUMERO+IF(EMPTY(CN9->CN9_REVISA),"","-"+CN9->CN9_REVISA))
		oHTML:ValByName('cMOTIVO', cMotivo)

		//Pega email do dono do Contrato		
		PswOrder(2)
		If PswSeek( CN9->CN9_XUSRCT, .T. )
			cMailAp := UsrRetMail(PswID())
		Endif
		cSubject	:=	IF( CN9->CN9_SITUACA == "09","BSL Workflow: Revisao do Contrato ","BSL Workflow: Contrato " )

		//temporario
		//IF Empty(cMailAp)
		//	cMailAp := "rafael.gama@oficinatec.com.br"
		//Endif

		oProcess:ClientName(CN9->CN9_XUSRCT)
		oProcess:cTo      := cMailAp
		oProcess:cBCC     := ''
		oProcess:cSubject := cSubject + CN9->CN9_NUMERO+IF(EMPTY(CN9->CN9_REVISA),"","-"+CN9->CN9_REVISA) + " rejeitado!" 
		oProcess:cBody    := ""
		oProcess:bReturn  := ""
		cMailID    := oProcess:Start()  // Crio o processo e gravo o ID do processo de Workflow	

	Endif

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Abertura do Arquivo de Trabalho                        ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If (Select(cAliasSCR) > 0, (cAliasSCR)->(dbCloseArea()),"")
	If (Select(cAliasCNB) > 0, (cAliasCNB)->(dbCloseArea()),"")
	If (Select(cAliasAC9) > 0, (cAliasAC9)->(dbCloseArea()),"")

	RestArea(aAreaCN9)
	RestArea(aAreaSCR)
	RestArea(aAreaCNB)


Return