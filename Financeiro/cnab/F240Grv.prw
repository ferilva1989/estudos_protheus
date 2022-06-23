#include "protheus.ch"
#include "Topconn.ch"
#Include "TbiConn.ch"
#Include "TbiCode.ch"
#INCLUDE "rwmake.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �F240Grv    �Autor  � Marcus Ferraz      � Data � 08/07/2016 ���
�������������������������������������������������������������������������͹��
���Desc.     � Salvar totais do sispag                                     ��
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � BSL                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function F240Grv()


	//Local aAreaAnt   := GetArea()

	If Type("nXSomaEnt") == "U" 
		public nXSomaEnt := 0
	EndIf

	If Type("nXSomaTotL") == "U" 
		public nXSomaTotL := 0
	EndIf

	If Type("nXSomaTotH") == "U" 
		public nXSomaTotH := 0
	EndIf

	If Type("nXSomaAcr") == "U" 
		public nXSomaAcr := 0
	EndIf 

	DO CASE
		CASE SEA->EA_MODELO == "35" .and. SEA->EA_TIPOPAG == "22"
		nXSomaTotL		+= (SE2->E2_SALDO-SE2->E2_DECRESC)
		nXSomaAcr 		+= SE2->E2_ACRESC
		nXSomaEnt 		+= SE2->E2_E_VLENT
		nXSomaTotH 		+= (SE2->E2_SALDO-SE2->E2_DECRESC)+SE2->E2_ACRESC

		CASE SEA->EA_MODELO == "22" .and. SEA->EA_TIPOPAG == "22" 
		nXSomaTotL	+= (SE2->E2_SALDO-SE2->E2_DECRESC)
		nXSomaAcr 	+= SE2->E2_ACRESC
		nXSomaEnt 	+= SE2->E2_E_VLENT
		nXSomaTotH 	+= (SE2->E2_SALDO-SE2->E2_DECRESC)+SE2->E2_ACRESC

		CASE SEA->EA_MODELO == "18" .and. SEA->EA_TIPOPAG == "22"    
		nXSomaTotL	+= (SE2->E2_SALDO-SE2->E2_DECRESC)
		nXSomaAcr 	+= SE2->E2_ACRESC
		nXSomaEnt 	+= SE2->E2_E_VLENT
		nXSomaTotH 	+= (SE2->E2_SALDO-SE2->E2_DECRESC)+SE2->E2_ACRESC

		CASE SEA->EA_MODELO == "17" .and. SEA->EA_TIPOPAG == "22"    
		nXSomaTotL	+= (SE2->E2_SALDO-SE2->E2_DECRESC-SE2->E2_E_VLENT)
		nXSomaAcr 	+= SE2->E2_ACRESC
		nXSomaEnt 	+= SE2->E2_E_VLENT
		nXSomaTotH 	+= (SE2->E2_SALDO-SE2->E2_DECRESC)+SE2->E2_ACRESC

		CASE SEA->EA_MODELO == "16" .and. SEA->EA_TIPOPAG == "22"    
		nXSomaTotL	+= (SE2->E2_SALDO-SE2->E2_DECRESC)
		nXSomaAcr 	+= SE2->E2_ACRESC
		nXSomaEnt 	+= SE2->E2_E_VLENT
		nXSomaTotH 	+= (SE2->E2_SALDO-SE2->E2_DECRESC)+SE2->E2_ACRESC

	ENDCASE


	//RestArea(aAreaAnt)
Return