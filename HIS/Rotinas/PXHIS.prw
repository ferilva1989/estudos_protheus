/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³PXHIS		³ Autor ³ Aderson Sousa         ³ Data ³ 15.07.15 ³±±
±±³          ³          ³       ³                       ³                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Retorna se integra com HIS                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³PXHIS(cAlias)                                               ³±±
±±³          ³ cAlias = Alias de validação se integra com HIS             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ BSL                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function PXHIS(cAlias)
	Local lRet := .T.
	Local aArea := {}

	XXF->(DbSetOrder(1))

	If cAlias == "SA1"
		// Erro chamado TSWGY0
		DbSelectArea("SA1")
		lRet := .F.
	ElseIf cAlias == "SA2"
		DbSelectArea("SA2")
		lRet := Empty(CFGA070EXT('HIS',cAlias,'A2_COD',cEmpAnt+'|'+SA2->(AllTrim(A2_FILIAL)+'|'+AllTrim(A2_COD)+'|'+AllTrim(A2_LOJA)+'|F')))
	ElseIf cAlias == "SAH"
		DbSelectArea('SAH')
		lRet := .T.
	ElseIf cAlias == "SB1"
		DbSelectArea("SB1")
		lRet := Empty(CFGA070EXT('HIS',cAlias,'B1_COD',cEmpAnt+'|'+SB1->(AllTrim(B1_FILIAL)+'|'+AllTrim(B1_COD))))
	ElseIf cAlias == "SBM"
		DbSelectArea("SBM")
		lRet := Empty(CFGA070EXT('HIS',cAlias,'BM_GRUPO',cEmpAnt+'|'+SBM->(AllTrim(BM_FILIAL)+'|'+AllTrim(BM_GRUPO))))
	ElseIf cAlias == "SD1"
		aArea := SD1->(GetArea())
		DbSelectArea("SD1")
		DbSetOrder(1)
		DbSeek(SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA))
		While !EOF() .And. SD1->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA) == SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA) .And. lRet
			lRet := (!Empty(CFGA070EXT('HIS','SB1','B1_COD',cEmpAnt+'|'+SB1->(AllTrim(B1_FILIAL)+'|'+AllTrim(B1_COD)))))
			SD1->(DbSkip())
		EndDo
		RestArea(aArea)
	ElseIf cAlias == "SD3"
		DbSelectArea("SD3")
		lRet := (Empty(CFGA070EXT('HIS','SB1','B1_COD',cEmpAnt+'|'+SB1->(AllTrim(B1_FILIAL)+'|'+AllTrim(B1_COD)))) .And.;
		Empty(CFGA070EXT('HIS','SBM','BM_GRUPO',cEmpAnt+'|'+SBM->(AllTrim(BM_FILIAL)+'|'+AllTrim(BM_GRUPO)))) .And.;
		Empty(CFGA070EXT('HIS','NNR','NNR_CODIGO',cEmpAnt+'|'+NNR->(AllTrim(NNR_FILIAL)+'|'+AllTrim(NNR_CODIGO))))) 
	ElseIf cAlias == "NNR"
		DbSelectArea("NNR")
		lRet := Empty(CFGA070EXT('HIS',cAlias,'NNR_CODIGO',cEmpAnt+'|'+NNR->(AllTrim(NNR_FILIAL)+'|'+AllTrim(NNR_CODIGO)))) 
	EndIf

Return(lRet)