#include "protheus.ch"
#include "Topconn.ch"
#Include "TbiConn.ch"
#Include "TbiCode.ch"
#INCLUDE "rwmake.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³F240Grv    ºAutor  ³ Marcus Ferraz      º Data ³ 08/07/2016 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Salvar totais do sispag                                     ±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BSL                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function Total()

	Local nTotal	:= 0.0

	DO CASE
		CASE SEA->EA_MODELO == "35" .and. SEA->EA_TIPOPAG == "22"
		nTotal		+= (SE2->E2_SALDO-SE2->E2_DECRESC)+SE2->E2_ACRESC-SE2->E2_E_VLENT

		CASE SEA->EA_MODELO == "22" .and. SEA->EA_TIPOPAG == "22" 
		nTotal		+= (SE2->E2_SALDO-SE2->E2_DECRESC)+SE2->E2_ACRESC-SE2->E2_E_VLENT

		CASE SEA->EA_MODELO == "18" .and. SEA->EA_TIPOPAG == "22"    
		nTotal		+= (SE2->E2_SALDO-SE2->E2_DECRESC)+SE2->E2_ACRESC-SE2->E2_E_VLENT

		CASE SEA->EA_MODELO == "17" .and. SEA->EA_TIPOPAG == "22"    
		nTotal		+= (SE2->E2_SALDO-SE2->E2_DECRESC)+SE2->E2_ACRESC-SE2->E2_E_VLENT

		CASE SEA->EA_MODELO == "16" .and. SEA->EA_TIPOPAG == "22"    
		nTotal		+= (SE2->E2_SALDO-SE2->E2_DECRESC)+SE2->E2_ACRESC-SE2->E2_E_VLENT

	ENDCASE

Return(nTotal)

User Function Acresc()

	Local nTotAcr	:= 0.0

	DO CASE
		CASE SEA->EA_MODELO == "35" .and. SEA->EA_TIPOPAG == "22"
		nTotAcr 	+= 0.0

		CASE SEA->EA_MODELO == "22" .and. SEA->EA_TIPOPAG == "22" 
		nTotAcr 	+= SE2->E2_ACRESC

		CASE SEA->EA_MODELO == "18" .and. SEA->EA_TIPOPAG == "22"    
		nTotAcr 	+= SE2->E2_ACRESC

		CASE SEA->EA_MODELO == "17" .and. SEA->EA_TIPOPAG == "22"    
		nTotAcr 	+= SE2->E2_ACRESC

		CASE SEA->EA_MODELO == "16" .and. SEA->EA_TIPOPAG == "22"    
		nTotAcr 	+= SE2->E2_ACRESC

	ENDCASE

Return(nTotAcr)

User Function Entid()

	Local nTotEnt 	:= 0.0

	DO CASE
		CASE SEA->EA_MODELO == "35" .and. SEA->EA_TIPOPAG == "22"
		nTotEnt 	+= SE2->E2_E_VLENT

		CASE SEA->EA_MODELO == "22" .and. SEA->EA_TIPOPAG == "22" 
		nTotEnt 	+= SE2->E2_E_VLENT

		CASE SEA->EA_MODELO == "18" .and. SEA->EA_TIPOPAG == "22"    
		nTotEnt 	+= SE2->E2_E_VLENT

		CASE SEA->EA_MODELO == "17" .and. SEA->EA_TIPOPAG == "22"    
		nTotEnt 	+= SE2->E2_E_VLENT

		CASE SEA->EA_MODELO == "16" .and. SEA->EA_TIPOPAG == "22"    
		nTotEnt 	+= SE2->E2_E_VLENT

	ENDCASE

Return(nTotEnt)

User Function Arrecad()

	Local nTotH		:= 0.0

	DO CASE
		CASE SEA->EA_MODELO == "35" .and. SEA->EA_TIPOPAG == "22"
		nTotH 		+= (SE2->E2_SALDO-SE2->E2_DECRESC)+SE2->E2_ACRESC

		CASE SEA->EA_MODELO == "22" .and. SEA->EA_TIPOPAG == "22" 
		nTotH 		+= (SE2->E2_SALDO-SE2->E2_DECRESC)+SE2->E2_ACRESC

		CASE SEA->EA_MODELO == "18" .and. SEA->EA_TIPOPAG == "22"    
		nTotH	 	+= (SE2->E2_SALDO-SE2->E2_DECRESC)+SE2->E2_ACRESC

		CASE SEA->EA_MODELO == "17" .and. SEA->EA_TIPOPAG == "22"    
		nTotH	 	+= (SE2->E2_SALDO-SE2->E2_DECRESC)+SE2->E2_ACRESC

		CASE SEA->EA_MODELO == "16" .and. SEA->EA_TIPOPAG == "22"    
		nTotH	 	+= (SE2->E2_SALDO-SE2->E2_DECRESC)+SE2->E2_ACRESC

	ENDCASE

Return(nTotH)