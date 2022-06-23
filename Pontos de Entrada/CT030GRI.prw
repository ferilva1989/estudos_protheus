/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �CT030GRI  � Autor � Aderson Sousa         � Data � 15.07.15 ���
���          �          �       �                       �                 ���
�������������������������������������������������������������������������Ĵ��
���Descricao �Cria o De-Para para o HIS                                   ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   �CT030GRI()                                                  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � BSL                                                        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function CT030GRI()
	aAreaXXD := XXD->(GetArea())
	cEmp	 := ""
	cFil	 := ""

	// Carrega os dados da Empresa e Filial do HIS
	XXD->(DbSetOrder(2))
	XXD->(DbSetFilter({|| 'HIS' $ XXD_REFER},"'HIS' $ XXD_REFER")) 

	If XXD->(MsSeek(cEmpAnt+cFilAnt))
		cEmp	:= XXD->XXD_COMPA
		cFil	:= XXD->XXD_BRANCH
		// Cria o de-para para o Centro de Custo
		CFGA070Mnt( "HIS", "CTT", "CTT_CUSTO",; 
		AllTrim(cEmp)+"||"+AllTrim(CTT->CTT_CUSTO),;
		cEmpAnt+"|"+AllTrim(CTT->CTT_FILIAL)+"|"+AllTrim(CTT->CTT_CUSTO))
	EndIf

	XXD->(DbClearFilter())
	RestArea(aAreaXXD)

Return