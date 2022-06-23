#include "rwmake.ch"
#include "TopConn.ch"
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Gpe_contabil     ºAutor ³Ana C Barizon º Data ³  19/06/2015 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Programa para gerar a contabilização da Folha de Pagamento º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BSL                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

***********
* Debito  *
***********

User function deb_rh_contabil()

	cConta:= space(20)
	cTpCC := space(20)
	cTpCC := fdesc("CTT",SRZ->RZ_CC,"CTT_CUSTO")

	//Custo      
	If 	Left(cTpCC,1) == "1" 
		cConta := FDESC("SRV",SRZ->RZ_PD,"RV_DEBCUS ") 
		//Despesa        
	Else
		cConta := FDESC("SRV",SRZ->RZ_PD,"RV_DEBDESP") 
	Endif

	//	If trim(cConta) = " "
	//	 	msgalert("Conta nao encontrada para a Verba - " + SRZ->RZ_PD)	
	//	Endif  	

	return(cConta)    

	***********
	* Credito *
	***********
user function cre_rh_contabil()

	cConta:= space(20)
	cTpCC := space(20)
	cTpCC := fdesc("CTT",SRZ->RZ_CC,"CTT_CUSTO")

	// Custo

	If 	Left(cTpCC,1) == "1" 
		cConta := FDESC("SRV",SRZ->RZ_PD,"RV_CRECUS ") 	
		// Despesa       
	Else
		cConta := FDESC("SRV",SRZ->RZ_PD,"RV_CREDESP") 
	Endif

	//	If trim(cConta) = ""
	//	 	msgalert("Conta nao encontrada para a Verba - " + SRZ->RZ_PD)	
	//	Endif  	


	return(cConta)  


	***************************
	* Centro de Custo Debito  *
	***************************
user function cc_deb_rh_contabil()

	cCC := space(11)
	crecebCC := space(11)
	cTpCC := space(11)
	cTpCC := fdesc("CTT",SRZ->RZ_CC,"CTT_CUSTO")

	// Custo      
	If 	Left(cTpCC,1) == "1" 
		cConta := FDESC("SRV",SRZ->RZ_PD,"RV_DEBCUS ")  
		cCC:= SRZ->RZ_CC
		//Despesa        
	Else
		cConta := FDESC("SRV",SRZ->RZ_PD,"RV_DEBDESP")  
		cCC:= SRZ->RZ_CC
	Endif

	return(cCC)    

	*****************************
	* * Centro de Custo Credito *
	*****************************
user function cc_cre_rh_contabil()

	cCC := space(10)
	crecebCC := space(10)

	cTpCC := space(11)
	cTpCC := fdesc("CTT",SRZ->RZ_CC,"CTT_CUSTO")

	// Custo
	If 	Left(cTpCC,1) == "1" 
		cConta := FDESC("SRV",SRZ->RZ_PD,"RV_CRECUS ") 	
		cCC:= SRZ->RZ_CC
		// Despesa       
	Else
		cConta := FDESC("SRV",SRZ->RZ_PD,"RV_CREDESP") 
		cCC:= SRZ->RZ_CC
	Endif


return(cCC)

//**************************
//* HISTORICO DO LP 
//*************************

USER FUNCTION xHISTPD

	Local aOld := GETAREA()
	Local nSrvOrd := SRV->(IndexOrd())
	Local nSrvRec := SRV->(Recno())
	Local xHist

	dbSelectArea( "SRV" )
	dbSetOrder(1)
	dbSeek( xFilial("SRV")+SRZ->RZ_PD )

	xHIST := "*" + srz->rz_pd +" "+ srv->rv_desc +" REF. " + MESEXTENSO(DDATABASE) + "/" + STRZERO(YEAR(DDATABASE),4)
	xHIST := xHIST + "*"

	SRV->(dbSetOrder( nSrvOrd ))
	SRV->(dbGoTo( nSrvRec ))
	RESTAREA( aOld )    

RETURN(xHIST)

