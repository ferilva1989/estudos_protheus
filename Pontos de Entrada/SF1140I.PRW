#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ SF1140I  ºAutor  ³FONTANELLI          º Data ³ 28/06/2018  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BSL                                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User function SF1140I()

	Local _aArea  := GetArea()
	Local _cChave := SF1->(F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)
	Local _dEMISSAO := SF1->F1_EMISSAO

	PswOrder(1)
	PswSeek(__CUSERID,.T.)
	aRetUser := PswRet()
	cNomeUsuario := aRetUser[1,2] 
	RecLock("SF1",.F.)
	if EMPTY(Alltrim(cNomeUsuario))
		SF1->F1_X_USPRE := "IW-INTEGRAÇÃO"
	else
		SF1->F1_X_USPRE := upper(cNomeUsuario)
	endif
	MsUnLock()

	dbSelectArea("SD1")
	dbSetOrder(1)
	dbSeek(xFilial()+_cChave)
	While !Eof() .and. xFilial("SD1")+_cChave == SD1->(D1_FILIAL + D1_DOC+ D1_SERIE + D1_FORNECE + D1_LOJA)

		if !Empty(SD1->D1_PEDIDO)
			DbSelectArea("SC7")
			DbSetOrder(1)
			if DbSeek(xFilial("SC7")+SD1->D1_PEDIDO)
				nTotal := 1000
				aDiaPag := Condicao(nTotal,SC7->C7_COND,0,_dEMISSAO)
				RecLock("SF1",.F.)
				SF1->F1_X_PVENC := aDiaPag[1,1]
				MsUnLock()
				Exit
			endif
		endif

		dbSelectArea("SD1")
		SD1->(dbSkip())
	End

	RestArea(_aArea)

Return
