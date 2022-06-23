#include "rwmake.ch"
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ECTBA04   ºAutor  ³SILAS SOUZA         º Data ³  01/24/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  rotina de busca do PCC quando da baixa por bordero        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ QGER                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function ECTBA04(IMPOSTO)

	//Guarda area original
	Local _aArea := Getarea()

	Local _nRetImp := 0
	Local _aPCC		:= {}
	Local _cQryPCC	:= ""

	If !Empty(SE2->E2_NUMBOR) .and. Alltrim(FunName()) != "FINA241" .and. SE5->E5_MOTBX == "DEB" //CONFIRMA SE É BAIXA POR BORDERO 532

		/*                                                                                                                               d

		//traz os dados do PCC a partir do registro gerado na inclusão do bordero
		_cQryPCC += "SELECT E5.E5_VRETPIS, E5.E5_VRETCOF, E5.E5_VRETCSL "
		_cQryPCC += "FROM " + RetSqlName("SE5") + " E5 "
		_cQryPCC += "WHERE E5.E5_FILIAL = '" + SE5->E5_FILIAL + "' "
		_cQryPCC += "AND E5.E5_PREFIXO = '" + SE5->E5_PREFIXO + "' "
		_cQryPCC += "AND E5.E5_NUMERO = '" + SE5->E5_NUMERO + "' "
		_cQryPCC += "AND E5.E5_PARCELA = '" + SE5->E5_PARCELA + "' "
		_cQryPCC += "AND E5.E5_MOTBX = 'PCC' "
		_cQryPCC += "AND E5.E5_CLIFOR = '" + SE5->E5_CLIFOR + "' "
		_cQryPCC += "AND E5.E5_LOJA = '" + SE5->E5_LOJA + "' "  
		_cQryPCC += "AND E5.E5_DOCUMEN = '" + SE5->E5_DOCUMEN + "' "  
		_cQryPCC += "AND E5.D_E_L_E_T_ <> '*'"  

		*/

		//traz os dados do PCC a partir do registro gerado na inclusão do bordero
		_cQryPCC += "SELECT E5.E5_VRETPIS, E5.E5_VRETCOF, E5.E5_VRETCSL "
		_cQryPCC += "FROM " + RetSqlName("SE5") + " E5 "
		_cQryPCC += "WHERE E5.E5_FILIAL = '" + SE2->E2_FILIAL + "' "
		_cQryPCC += "AND E5.E5_PREFIXO = '" + SE2->E2_PREFIXO + "' "
		_cQryPCC += "AND E5.E5_NUMERO = '" + SE2->E2_NUM + "' "
		_cQryPCC += "AND E5.E5_PARCELA = '" + SE2->E2_PARCELA + "' "
		_cQryPCC += "AND E5.E5_MOTBX = 'PCC' "
		_cQryPCC += "AND E5.E5_CLIFOR = '" + SE2->E2_FORNECE + "' "
		_cQryPCC += "AND E5.E5_LOJA = '" + SE2->E2_LOJA + "' "  
		_cQryPCC += "AND E5.E5_DOCUMEN = '" + SE2->E2_NUMBOR + "' "  
		_cQryPCC += "AND E5.D_E_L_E_T_ <> '*'"  

		_aPCC := U_QryArr(_cQryPCC)

		If !Empty(_aPCC)  //se encontrou

			Do case 
				case IMPOSTO == "PIS"
				_nRetImp := _aPCC[1,1] 
				case IMPOSTO == "COFINS"
				_nRetImp := _aPCC[1,2]
				case IMPOSTO == "CSLL"
				_nRetImp := _aPCC[1,3]
			Endcase

		Endif

	Endif

	If Valtype(_nRetImp) <> "N"
		_nRetImp := 0
	Endif


	RestArea(_aArea)

Return(_nRetImp)