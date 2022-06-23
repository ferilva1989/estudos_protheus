#INCLUDE "Protheus.ch"

User Function CodProd()

	Local cRet     := ""
	Local aAreaSB1 := SB1 -> ( GetArea() )
	Local cGrupo   := M -> B1_GRUPO
	Local cSubGru  := M -> B1_XSUBGRU
	Local cNewSubG := ""
	Local cNewGru  := ""
	Local cUltProd := ""
	Local cSeq     := ""

	IF ( Alltrim( cGrupo ) $ GetMV( "ES_GRUCSEQ" ) ) //Grupo para os códigos sequenciais

		DbSelectArea( "SZX" )
		SZX -> ( DbSetOrder( 1 ) )
		SZX -> ( DbSeek( xFilial( "SZX" ) + cGrupo + cSubGru ) )
		SZX -> ( DbSkip( +1 ) )
		cNewGru  := SZX -> ZX_CODGRUP
		cNewSubG := SZX -> ZX_CODSGRU

		DbSelectArea("SB1")
		SB1->(DbGoTop())
		SB1->(DbOrderNickName("GRUPO"))
		SB1->(DbSeek(xFilial("SB1") + cNewGru + cNewSubG ),.T.)
		SB1->(DbSkip(-1))

		cUltProd := SB1->B1_COD

		IF SUBSTR(cUltProd,1,5) <> Alltrim(cGrupo) + cSubGru .Or. Empty(cUltProd)
			cRet := Alltrim(cGrupo) + cSubGru + "00001"
		Else
			cSeq := Soma1(SUBSTR(cUltProd,6,5))
			cRet := Alltrim(cGrupo) + cSubGru + cSeq
		EndIf
	ENDIF
	RestArea(aAreaSB1)

Return cRet