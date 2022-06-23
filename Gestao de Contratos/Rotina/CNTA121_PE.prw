#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
#INCLUDE "FWBROWSE.CH"
#INCLUDE "TopConn.ch"
#INCLUDE "TbiConn.ch" 
#include "Fileio.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CNTA121 บAutor  ณRafael Gama-Oficina1 บ Data ณ  12/02/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPE em MVC para a rotina de nova medi็ใo de contratos	        บฑฑ
ฑฑบ          ณ (CNTA121) - Nova medi็ใo de contrato.   					    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BSL     					                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function CNTA121()

	Local aParam		:= PARAMIXB
	Local xRet       	:= .T.
	Local cIdPonto   	:= ''
	Local cIdModel   	:= ''
	Local lIsGrid		:= .F.
	Local cNumCont	:= ''
	Local cNumRev		:= ''
	Local cNumPla		:= ''
	Local cItem		:= ''
	Local cQuery		:= ""
	Local cAliasSC7	:= ""
	Private oObj		:= ''	

	If aParam <> NIL

		oObj       := aParam[1]
		cIdPonto   := aParam[2]
		cIdModel   := aParam[3]
		lIsGrid    := ( Len( aParam ) > 3 )	

		If cIdPonto == 'FORMLINEPRE'	

			IF cIdModel == 'CNEDETAIL' .AND. lIsGrid

				IF aParam[5] == "SETVALUE"  .AND.  aParam[6] == "CNE_CC" 

					//Tratamento para trazer a descri็ใo da planilha (CNB) para o campo CNE-DESCRI

					CNB->(DbSetOrder(1))  //CNB_FILIAL+CNB_CONTRA+CNB_REVISA+CNB_NUMERO+CNB_ITEM

					cNumCont := oObj:GetValue('CNE_CONTRA')
					cNumRev  := oObj:GetValue('CNE_REVISA')
					cNumPla  := oObj:GetValue('CNE_NUMERO')
					cItem    := oObj:GetValue('CNE_ITEM')

					IF CNB->(DbSeek( xFilial("CNE")+cNumCont+cNumRev+cNumPla+cItem ))		
						oObj:LoadValue('CNE_DESCRI',CNB->CNB_DESCRI)				
					Endif
				Endif			

			Endif

		ElseIf cIdPonto == 'MODELCOMMITNTTS' //Ap๓s a grava็ใo total do modelo e fora da transa็ใo.

			IF IsInCallStack('CN121Encerr')

				cAliasSC7 := GetNextAlias()

				//Abertura do Arquivo de Trabalho
				If (Select(cAliasSC7) > 0, (cAliasSC7)->(dbCloseArea()),"")
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณ Query dos aprovadores do contratos			             ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				cQuery := " SELECT C7_FILIAL, C7_NUM FROM "+RetSqlName("SC7")+"  "+CRLF	
				cQuery += " WHERE C7_FILIAL = '"+CND->CND_FILIAL+"' AND C7_CONTRA = '"+CND->CND_CONTRA+"'  "+CRLF
				cQuery += " AND C7_REVISAO = '"+CND->CND_REVISA+"'  AND C7_MEDICAO = '"+CND->CND_NUMMED+"'  AND D_E_L_E_T_ <> '*' "+CRLF
				cQuery += " GROUP BY C7_FILIAL, C7_NUM "+CRLF

				TcQuery cQuery New Alias (cAliasSC7)

				(cAliasSC7)->(dbGoTop())			

				While (cAliasSC7)->(!EOF())						
					// Envia email comprador
					U_EnvPCApr((cAliasSC7)->C7_FILIAL,(cAliasSC7)->C7_NUM)
					(cAliasSC7)->(dbSkip())
				EndDo

			Endif

		Endif

	Endif //aParam <> NIL

Return xRet
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ C121VCPO บAutor  ณRafael Gama-Oficina1 บ Data ณ  06/03/19  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPE antes de carregar o View em MVC para altera็ใo de campos บฑฑ
ฑฑบ          ณ (CNTA121) - Nova medi็ใo de contrato.   					    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BSL     					                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿

User Function C121VCPO()

Local oStruCND := PARAMIXB[1]
//Local oStruCXN := PARAMIXB[2]
//Local oStruCNE := PARAMIXB[3]
IF INCLUI .OR. ALTERA
//Valida็๕es do usuแrio
oStruCND:AddField("CND_CONDPG"	,;	// [01]  C   Nome do Campo
"24"				,;	// [02]  C   Ordem
"Cond. Pagto"		,;	// [03]  C   Titulo do campo
"Condicao de pagto"	,;	// [04]  C   Descricao do campo
NIL				,;	// [05]  A   Array com Help
"GET"			,;	// [06]  C   Tipo do campo
"@!"			,;	// [07]  C   Picture
NIL				,;	// [08]  B   Bloco de Picture Var
"SE4"			,;	// [09]  C   Consulta F3
.T.				,;	// [10]  L   Indica se o campo ้ alteravel
"1"				,;	// [11]  C   Pasta do campo
NIL				,;	// [12]  C   Agrupamento do campo
NIL				,;	// [13]  A   Lista de valores permitido do campo (Combo)
NIL				,;	// [14]  N   Tamanho maximo da maior op็ใo do combo
NIL				,;	// [15]  C   Inicializador de Browse
.F.				,;	// [16]  L   Indica se o campo ้ virtual
NIL				,;	// [17]  C   Picture Variavel
NIL				)	// [18]  L   Indica pulo de linha ap๓s o campo
Endif

Return 
*/

