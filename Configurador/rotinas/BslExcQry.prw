#INCLUDE "TOTVS.CH"
#include 'protheus.ch'
#include 'parmtype.ch'
#include "TopConn.ch"
#include "TBICONN.CH"
#include "TbiCode.ch"
#include "rwmake.CH"

User Function BslExcQry()

	Local cQuery := ""

	PREPARE ENVIRONMENT EMPRESA "01" FILIAL "04001" MODULO "GPE"

	cQuery := " UPDATE SRA010 SET "
	cQuery += " RA_RECMAIL = 'S' "
	cQuery += " WHERE D_E_L_E_T_ = '' AND RA_RECMAIL <> 'S'"

	If !TCIsConnected()
		MsgAlert( "Sem conexão com o banco de dados", 'BSL' )
		Return( Nil )
	Endif  

	If !"MSSQL" $ TCGetDB()
		MsgStop( TCGetDB() + " - Nao tratado!", 'BSL' )
		Return( Nil )
	EndIf

	If TCSQLExec(cQuery) < 0
		MsgStop( "TCSQLError() " + TCSQLError(), 'BSL' )
		Return( Nil )
	Else
		MsgInfo( "Executado com Sucesso!!!", 'BSL' )
	Endif

Return