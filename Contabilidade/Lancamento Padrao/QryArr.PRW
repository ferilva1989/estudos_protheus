#INCLUDE "TOPCONN.CH"
//#INCLUDE "PROTHESP.CH"
#INCLUDE "RWMAKE.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณ QryArr   บAutor  ณ Silvio Cazela      บ Data ณ 21/06/2001  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Funcao para rodar uma Query e retornar como Array          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ cQuery - Query SQL a ser executado                         บฑฑ
ฑฑบ          ณ cTipo  - A=Array (Default) / V=Variavel (Par.N.Obrigat.)   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ aTrb   - Array com o conteudo da Query                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP5                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function QryArr(cQuery,cTipo)

	Local aEstou := GetArea()

	//ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
	//บ Gravacao do Ambiente Atual e Variaveis para Utilizacao                   บ
	//ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออSilvio Cazelaอผ
	Local aRet    := {}
	Local aRet1   := {}
	Local nRegAtu := 0
	Local x       := 0
	cTipo := iif(cTipo==NIL,"A","V")

	//ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
	//บ Ajustes e Execucao da Query                                              บ
	//ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออSilvio Cazelaอผ
	//cQuery := ChangeQuery(cQuery)
	TCQUERY cQuery NEW ALIAS "_TRB"

	//ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
	//บ Montagem do Array para Retorno                                           บ
	//ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออSilvio Cazelaอผ
	DbSelectArea("_TRB")
	aRet1   := Array(fcount())
	nRegAtu := 1  
	dbgotop()
	While ! _TRB->(eof())
		For x:=1 to fcount()
			aRet1[x] := FieldGet(x)
		Next
		AADD(aRet,aclone(aRet1))
		DbSkip()
		nRegAtu += 1
	Enddo

	//ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
	//บ Verifica e Ajusta o Tipo de Retorno                                      บ
	//ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออSilvio Cazelaอผ
	If cTipo=="V" .and. len(aRet)>0
		aRet := aRet[1,1]
	Elseif cTipo=="V"
		aRet := NIL
	Endif

	//ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
	//บ Encerra Query e Retorna Ambiente                                         บ
	//ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออSilvio Cazelaอผ
	DbSelectArea("_TRB")
	_TRB->(DbCloseArea())

	RestArea(aEstou)

Return(aRet)