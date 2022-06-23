#Include 'Protheus.ch'
#Include "TopConn.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � CN100SIT�Autor  �Rafael Gama-Oficina1 � Data �  12/02/19   ���
�������������������������������������������������������������������������͹��
���Desc.     �PE na mudan�a de situa��o do contrato.					      ���
���          �                                      					  ���
�������������������������������������������������������������������������͹��
���Uso       � BSL     					                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function CN100SIT()

	Local cSitAtu  	:= ParamIxb[1]
	Local cSitPro  	:= ParamIxb[2]

	IF cSitPro $ "04/05" .AND. CN9->CN9_SITUACA == "04"

		// Chama a rotina que fara o envio dos e-mails para aprova��o do contratos.
		U_XGCT001()

	Endif


Return