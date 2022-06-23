#Include "PROTHEUS.CH"   
#include "PTMenu.ch"

USER FUNCTION SE5LIMP()

	If MSGYESNO("Deseja realmente limpar as tabelas FKs ?","Aviso")

		CQUERY:=''
		CQUERY:=" UPDATE "+RETSQLNAME("SE5")+" SET E5_MOVFKS=' ',E5_IDORIG=' ',E5_TABORI=' '"
		TCSQLEXEC(CQUERY)
		TCSQLEXEC('COMMIT')

		CQUERY:=" DELETE "+RETSQLNAME("FK1")
		TCSQLEXEC(CQUERY)
		TCSQLEXEC('COMMIT')

		CQUERY:=" DELETE "+RETSQLNAME("FK2")
		TCSQLEXEC(CQUERY)
		TCSQLEXEC('COMMIT')

		CQUERY:=" DELETE "+RETSQLNAME("FK3")
		TCSQLEXEC(CQUERY)
		TCSQLEXEC('COMMIT')

		CQUERY:=" DELETE "+RETSQLNAME("FK4")
		TCSQLEXEC(CQUERY)
		TCSQLEXEC('COMMIT')

		CQUERY:=" DELETE "+RETSQLNAME("FK5")
		TCSQLEXEC(CQUERY)
		TCSQLEXEC('COMMIT')

		CQUERY:=" DELETE "+RETSQLNAME("FK6")
		TCSQLEXEC(CQUERY)
		TCSQLEXEC('COMMIT')

		CQUERY:=" DELETE "+RETSQLNAME("FK7")
		TCSQLEXEC(CQUERY)
		TCSQLEXEC('COMMIT')

		CQUERY:=" DELETE "+RETSQLNAME("FK8")
		TCSQLEXEC(CQUERY)
		TCSQLEXEC('COMMIT')

		CQUERY:=" DELETE "+RETSQLNAME("FK9")
		TCSQLEXEC(CQUERY)
		TCSQLEXEC('COMMIT')

		CQUERY:=" DELETE "+RETSQLNAME("FKA")
		TCSQLEXEC(CQUERY)
		TCSQLEXEC('COMMIT')

		Alert("Limpeza conclu�da!")
	EndIf

RETURN