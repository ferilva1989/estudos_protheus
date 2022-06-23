#INCLUDE	"RWMAKE.CH"
#INCLUDE	"PROTHEUS.CH"

// ###################################################################################################
// Projeto: BSL
// Modulo : SIGACOM
// Fonte  : MTA121MNU
// ---------+-------------------+---------------------------------------------------------------------
// Data     | Autor             |Descricao
// ---------+-------------------+---------------------------------------------------------------------
// 15/02/19 | Alceu Pereira     |Utilização deste ponto de entrada para criação de opção no menu do 
//			|					|Pedido de Compras - Reenviar Work flow.
//			|					|Chamada para a rotina de Alteração para realizar validação e reenvio.
// ---------+-------------------+----------------------------------------------------------------------

User Function MT121BRW()

	Aadd(aRotina,{'Reenvio WF Aprov.','U_XCOM005' , 0 , 4, 0, NIL})
	Aadd(aRotina,{'Reenvio WF Fornec.','U_ReePCApr' , 0 , 4, 0, NIL})

Return()