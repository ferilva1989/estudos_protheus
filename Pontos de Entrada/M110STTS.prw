      
#include "TbiConn.ch"
#include "TbiCode.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "topconn.ch"
#DEFINE ENTER CHR(13) + CHR(10)

// #########################################################################################
// Projeto: BSL
// Modulo : SIGACOM
// Fonte  : M110STTS
// ---------+-------------------+-----------------------------------------------------------
// Data     | Autor             | Descricao
// ---------+-------------------+-----------------------------------------------------------
// 21/08/18 | Edie Carlos       | Ponto de entrada na gravação da solicitação de compra.
// ---------+-------------------+-----------------------------------------------------------



User Function M110STTS()

	Local cNumSol		:= ParamIXB[1]
	Local nOpt			:= ParamIXB[2]	// 1=Inclusão, 2=Alteração, 3=Exclusão
	Local lNivel        := .F.
	Local lPerfil       := .F.
	Local lAjust        := .F. 
	Local lAtuSCR       := .F.
		
	//Verficar como controle de alçada 
	
	dbSelectArea("SAL")
	SAL->(dbSetOrder(3))
	
	dbSelectArea("DHL")
	DHL->(dbSetOrder(1))
	
	dbSelectArea("SAK")
	SAK->(dbSetOrder())
	
	dbSelectArea("SCR")
	SCR->(dbSetOrder(1))
	
	dbSelectArea("DBM")
	DBM->(DbOrderNickName("APROVSC"))
	
	IF SCR->(dbSeek(xFilial("SCR")+"SC"+SC1->C1_NUM))
		//Verifica o grupo de aprovação se esta para aprovaor por nivel
		IF SAL->(dbSeek(xFilial("SAL")+SCR->CR_GRUPO))
			//VERIFICA SE É NIVEL
			IF SAL->AL_TPLIBER == "N"
				lNivel := .T. 
			ENDIF
			//VERIFICA SE EXITE PERFIL
			IF !Empty(SAL->AL_PERFIL) 
				lPerfil := .T. 
			ENDIF
		 ENDIF
	ENDIF
	
	//verifica se foi gerado correta
	
	IF lNivel
		//Faz um loop no SCR para verificar e ajustar o perfil dos aprovadores
		While SCR->(!EOF()) .AND. SCR->CR_FILIAL == xFilial("SCR") .AND. Alltrim(SCR->CR_NUM) == Alltrim(SC1->C1_NUM) .AND. Alltrim(SCR->CR_TIPO) =="SC"
		//verifica o aporvador esta no perfil 
			IF SAL->(dbSeek(xFilial("SAL")+SCR->CR_GRUPO+SCR->CR_APROV))
			//VERIFICA O VALOR DO PERFIL PARA APROVAÇÃO 
				IF lPerfil
					  IF DHL->(dbSeek(xFilial("DHL")+SAL->AL_PERFIL))
						   IF !MaAlcLim(SAL->AL_APROV,SCR->CR_TOTAL,DHL->DHL_MOEDA,0,SCR->CR_GRUPO)//SCR->CR_TOTAL < DHL->DHL_LIMMIN .AND. SCR->CR_TOTAL > DHL->DHL_LIMMAX
							   lAjust:= .T.	
							   lAtuSCR:= .T.		   
						   ENDIF
					  ENDIF
			    ELSE
			    	IF SAK->(dbSeek(xFilial("SAK")+SAL->AL_APROV))
				    	IF !MaAlcLim(SAL->AL_APROV,SCR->CR_TOTAL,SAK->AK_MOEDA,0,SCR->CR_GRUPO)//SCR->CR_TOTAL < SAK->AK_LIMMIN .AND. SCR->CR_TOTAL > SAK->AK_LIMMAX
				    		lAjust:= .T. 
				    		lAtuSCR:= .T.		   
						ENDIF		    	
			    	ENDIF
			    ENDIF
			ENDIF
			
			//Ajusta tabela SCR e DBM
			IF lAjust
				//Apaga SCR
				RecLock("SCR", .F.)
				SCR->(dbDelete())
				SCR->(MsUnLock())
				
				//Apaga DBM
				IF DBM->(dbSeek(xFilial("DBM")+SCR->CR_TIPO+SCR->CR_NUM+SCR->CR_GRUPO+SCR->CR_APROV))
					While DBM->(!EOF()) .AND. DBM->DBM_FILIAL == xFilial("DBM") .AND. DBM->DBM_TIPO == SCR->CR_TIPO ;
					 					.AND. DBM->DBM_NUM == SCR->CR_NUM .AND. DBM->DBM_GRUPO == SCR->CR_GRUPO .AND. DBM->DBM_USAPRO == SCR->CR_APROV
					 
						 //Apaga DBM
						 RecLock("DBM", .F.)
						 DBM->(dbDelete())
						 DBM->(MsUnLock())
					DBM->(dbSkip())
					EndDo
				ENDIF
				lAjust:=.F.
			ENDIF
		
		SCR->(dbSkip())
		EndDO		
	ENDIF
	
	//Caso tenha realido o ajuste SCR atualiza o campo Status
	IF lAtuSCR
		SCR->(dbSeek(xFilial("SCR")+"SC"+SC1->C1_NUM))
		RecLock("SCR", .F.)
		SCR->CR_STATUS  := "02"
		SCR->(MsUnLock())						
	ENDIF
	
	//Chama rotina para envio do WorkFlow
	U_XCOM004()
	
	Return()
	