#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �REMESSA   � Autor � Ana Claudia Barizon� Data �  01/08/15   ���
�������������������������������������������������������������������������͹��
���Descricao � Programa para buscar a finalidade do arquivo conforme      ���
���          � tipo de pagamento Ita�                                     ���
�������������������������������������������������������������������������͹��
���Uso       � SISPAG ITAU-SIGAGPE (Cliente BSL                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function FINALID()


	//���������������������������������������������������������������������Ŀ
	//� Declaracao de Variaveis                                             �
	//�����������������������������������������������������������������������

	Local _cAmbiente := GetArea()
	Local _cTipoC    := "   "


	IF LEFT(MV_PAR01,3) == "FOL"
		_cTipoC := "01"
	ElseIF LEFT(MV_PAR01,3) == "ADI"
		_cTipoC := "02"
	ElseIF LEFT(MV_PAR01,3) == "131" 
		_cTipoC := "04"
	Elseif LEFT(MV_PAR01,3) == "132"
		_cTipoC := "04"
	ElseIF LEFT(MV_PAR01,3) == "PLR"
		_cTipoC := "05"
	ElseIF LEFT(MV_PAR01,3) == "FER"
		_cTipoC := "07"
	ElseIF LEFT(MV_PAR01,3) == "RES"
		_cTipoC := "08"
	Else	
		_cTipoC := "01"	
	Endif

	RestArea(_cAmbiente)

Return(_cTipoC)