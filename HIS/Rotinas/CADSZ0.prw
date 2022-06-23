#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'

//Teste Cadastro
User Function CADSZ0()
	Local oBrowse

	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias('SZ0')
	//oBrowse:SetFilterDefault( "SZ0_SEQ=='001'" )
	oBrowse:SetDescription( 'Cadastro de Prescrição' )
	oBrowse:AddLegend( "SZ0->Z0_STATUS == '1'", "GREEN", "Finalizada" )
	oBrowse:AddLegend( "SZ0->Z0_STATUS == '1'", "RED",   "Pendente" )
	oBrowse:Activate()

Return NIL

//
Static Function MenuDef()
	Local aRotina := {}

	ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.CADSZ0_MVC' OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE 'Incluir' ACTION 'VIEWDEF.CADSZ0_MVC' OPERATION 3 ACCESS 0
	ADD OPTION aRotina TITLE 'Alterar' ACTION 'VIEWDEF.CADSZ0_MVC' OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE 'Excluir' ACTION 'VIEWDEF.CADSZ0_MVC' OPERATION 5 ACCESS 0
	ADD OPTION aRotina TITLE 'Imprimir' ACTION 'VIEWDEF.CADSZ0_MVC' OPERATION 8 ACCESS 0
	//ADD OPTION aRotina TITLE 'Copiar' ACTION 'VIEWDEF.CADSZ0' OPERATION 9 ACCESS 0

Return aRotina

//
Static Function ModelDef()

	// Cria as estruturas a serem usadas no Modelo de Dados
	Local oStruSZ0 := FWFormStruct( 1, 'SZ0' )
	Local oStruSZ1 := FWFormStruct( 1, 'SZ1' )
	Local oModel // Modelo de dados construído
	// Cria o objeto do Modelo de Dados
	oModel := MPFormModel():New( 'CADSZ0_MVC' )
	// Adiciona ao modelo um componente de formulário
	oModel:AddFields( 'SZ1MASTER', /*cOwner*/, oStruSZ0 )

	oModel:SetDescription( 'Modelo de Cadastro de Prescrição' )

	oModel:GetModel( 'SZ0MASTER' ):SetDescription( 'Dados da Prescrição' )

	// Adiciona ao modelo uma componente de grid            /
	oModel:AddGrid( 'SZ1DETAIL', 'SZ0MASTER', oStruSZ1 )
	// Faz relacionamento entre os componentes do model
	oModel:SetRelation( 'SZ1DETAIL', { { 'Z1_FILIAL', 'xFilial( "SZ1" )' }, {'Z1_CODPRC', 'Z0_CODPRC' } }, SZ1->( IndexKey( 1 ) ) )
	// Adiciona a descrição do Modelo de Dados
	oModel:SetDescription( 'Cadastro Prescrição' )
	// Adiciona a descrição dos Componentes do Modelo de Dados
	oModel:GetModel( 'SZ0MASTER' ):SetDescription( 'Cabeçalho Prescrição' )
	oModel:GetModel( 'SZ1DETAIL' ):SetDescription( 'Item Prescrição' )
	// Retorna o Modelo de dados

Return oModel

//
Static Function ViewDef()
	// Cria um objeto de Modelo de dados baseado no ModelDef do fonte informado
	Local oModel := FWLoadModel( 'CADSZ0_MVC' )
	// Cria as estruturas a serem usadas na View
	Local oStruSZ0 := FWFormStruct( 2, 'SZ0' )
	Local oStruSZ1 := FWFormStruct( 2, 'SZ1' )

	// Interface de visualização construída
	Local oView
	// Cria o objeto de View
	oView := FWFormView():New()
	// Define qual Modelo de dados será utilizado
	oView:SetModel( oModel )
	// Adiciona no nosso View um controle do tipo formulário (antiga Enchoice)
	oView:AddField( 'VIEW_SZ0', oStruSZ0, 'SZ0MASTER' )
	//Adiciona no nosso View um controle do tipo Grid (antiga Getdados)
	oView:AddGrid( 'VIEW_SZ1', oStruSZ1, 'SZ1DETAIL' )
	// Cria um "box" horizontal para receber cada elemento da view
	oView:CreateHorizontalBox( 'SUPERIOR', 15 )
	oView:CreateHorizontalBox( 'INFERIOR', 85 )
	// Relaciona o identificador (ID) da View com o "box" para exibição
	oView:SetOwnerView( 'VIEW_SZ0', 'SUPERIOR' )
	oView:SetOwnerView( 'VIEW_SZ1', 'INFERIOR' )
	// Retorna o objeto de View criado

Return oView