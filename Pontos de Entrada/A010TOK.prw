#INCLUDE "Protheus.ch"

User Function A010TOK()

	Local lRet     := .T.
	Local cGrupo   := M->B1_GRUPO
	Local cSubGru  := M->B1_XSUBGRU

	IF (Alltrim(cGrupo) $ GetMV("ES_GRUCSEQ"))
		IF(Empty(cSubGru))
			lRet := .F.
			Alert("O Campo SubGrupo é obrigatório")
		EndIF		
	EndIF

Return lRet