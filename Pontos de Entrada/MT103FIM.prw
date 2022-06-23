#INCLUDE "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT100TOK  ºAutor  ³Marcus Ferraz       º Data ³ 27/04/2016  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Inserir a data de entraga do do documento                   º±±  
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BSL                                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT103FIM()

	Local nOpcao := PARAMIXB[1]       // 1 Pesq, 2 Vis, 3 Inc, 4 Alt, 5 Exc
	Local nConfirma := PARAMIXB[2]    // 1 - Confirma; 0 - Cancela
	Local _oDlg                                       
	Local _oDtDoc
	Local _dDtDoc := CTOD("  /  /  ")

	if nConfirma == 1

		PswOrder(1)
		PswSeek(__CUSERID,.T.)
		aRetUser := PswRet()
		cNomeUsuario := aRetUser[1,2] 
		RecLock("SF1",.F.)
		SF1->F1_X_USCLA := upper(cNomeUsuario)
		MsUnLock()                                                                                   

		xDOC     := SF1->F1_DOC 
		xSERIE   := SF1->F1_SERIE
		xFORNECE := SF1->F1_FORNECE
		xLOJA    := SF1->F1_LOJA
		SD1->(DbSetOrder(1)) // D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM
		if SD1->(DbSeek(xFilial('SD1') + xDOC + xSERIE + xFORNECE + xLOJA))  
			xPEDIDO	   := SD1->D1_PEDIDO
			xITEMPED   := SD1->D1_ITEMPC
			if !Empty(xPEDIDO)
				DbSelectArea("SC7")
				DbSetOrder(1) // C7_FILIAL+C7_NUM+C7_ITEM+C7_SEQUEN
				if SC7->(DbSeek(xFilial("SC7")+ xPEDIDO + xITEMPED))
					xCAPEX := SC7->C7_X_TPPEX
					DbSelectArea("SE2")
					DbSetOrder(6) // E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO
					DbSeek(xFilial("SE2")+ xFORNECE + xLOJA + xSERIE + xDOC)
					While !Eof() .And. SE2->E2_FILIAL+SE2->E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM == xFilial("SE2")+xFORNECE+xLOJA+xSERIE+xDOC
						RecLock("SE2",.F.)
						SE2->E2_X_TPPEX:= xCAPEX
						MsUnLock()
						DbSkip()
					EndDo
				endif
			endif	
		endif	

	endif	

	If (nOpcao == 3  .or. nOpcao == 4)   .And. nConfirma == 1


		Do While Empty(Alltrim(DtoS(_dDtDoc)))

			DEFINE MSDIALOG _oDlg FROM  69,33 TO 140,260 TITLE "Data Recbto Documento" PIXEL OF oMainWnd

			@ 011,007 SAY "Data : " SIZE 18, 07 OF _oDlg PIXEL 
			@ 010,027 MSGET _oDtDoc  VAR _dDtDoc PICTURE "99/99/99" SIZE 55, 10 PIXEL OF _oDlg

			DEFINE SBUTTON FROM 011, 087 TYPE 1 ENABLE OF _oDlg ACTION ( nOpc1 := 1,_oDlg:End() )
			//DEFINE SBUTTON FROM 20, 110 TYPE 2 ENABLE OF _oDlg ACTION ( nOpc1 := 0,_oDlg:End() )

			ACTIVATE MSDIALOG _oDlg CENTERED

			RecLock("SF1",.F.)
			SF1->F1_XDTRBTO := _dDtDoc
			SF1->(MsUnlock())

		EndDo

	EndIf


Return()
