#Include "Protheus.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �BSLAvFin  �Autor  � Diego Fernandes    � Data �  08/24/16   ���
�������������������������������������������������������������������������͹��
���Desc.     �  Funcao para apresentar alerta de adiantamentos            ���
���          �  do fornecedor                                             ���
�������������������������������������������������������������������������͹��
���Uso       � BSL                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function BSLAvFin()

	Local cFornece := M->E2_FORNECE	
	Local cLoja    := M->E2_LOJA   
	Local cNomFor  := M->E2_NOMFOR
	Local cQuery   := ""
	Local cTitPas  := ""

	//���������������������������������������������������������������Ŀ
	//�Verifica se existe adiantamentos em aberto para um determinado �
	//�fornecedor                                                     �
	//�����������������������������������������������������������������
	cQuery   := " SELECT E2_PREFIXO, E2_NUM, E2_NOMFOR, E2_PARCELA, E2_VALOR "
	cQuery   += " FROM "+RetSqlName("SE2")+" SE2 "
	cQuery   += " WHERE SE2.D_E_L_E_T_ = '' "
	cQuery   += " AND E2_TIPO = 'PA' "
	cQuery   += " AND E2_BAIXA = '' "     
	cQuery   += " AND E2_FORNECE = '"+cFornece+"' "     	
	cQuery   += " AND E2_LOJA = '"+cLoja+"' "     	
	cQuery   += " AND E2_FILIAL = '"+xFilial("SE2")+"' "

	//��������������������������������������Ŀ
	//�Finaliza area da tabela temporaria    �
	//����������������������������������������            
	If Select("TSQL") > 0
		TSQL->(dbCloseArea())
	EndIf

	dbUseArea(.t., 'TOPCONNECT', TcGenQry(,,cQuery), 'TSQL', .f., .f.)

	dbSelectArea("TSQL")
	TSQL->(dbGotop())

	While TSQL->(!Eof())
		cTitPas +=  TSQL->E2_PREFIXO+TSQL->E2_NUM+TSQL->E2_PARCELA + " - " + Transform(TSQL->E2_VALOR,"@E 999,999,999.99") + CHR(10) + CHR(13)
		TSQL->(dbSkip())
	EndDo

	//��������������������������������������Ŀ
	//�Finaliza area da tabela temporaria    �
	//����������������������������������������
	If Select("TSQL") > 0
		TSQL->(dbCloseArea())
	EndIf

	//�������������������������������������������Ŀ
	//�Mostra mensagem de aviso para o usuario    �
	//���������������������������������������������
	If !Empty(cTitPas)
		Aviso("PA - Pagamento antecipado","Foram encontrado(s) PA em aberto para esse fornecedor: " + cTitPas,{"&OK"},3)
	EndIf

Return( .T. )