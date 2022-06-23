//Bibliotecas
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

//Vari�veis Est�ticas
Static cTitulo := "Prescri��o"

/*/{Protheus.doc} zMVCMd3
Fun��o para cadastro de Prescri��o (SZ1) e Produtos (SZ2), exemplo de Modelo 3 em MVC
@author Marcus Ferraz
@since 05/07/2016
@version 1.0
@return Nil, Fun��o n�o tem retorno
@example
u_BSLCADPRC()
@obs N�o se pode executar fun��o MVC dentro do f�rmulas
/*/

User Function BSLCADPRC()

	Local oBrowse

	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias('SZ0')
	//oBrowse:SetFilterDefault( "ZZ1_SEQ==�001�" )
	oBrowse:SetDescription( 'Cadastro de Prescri��o' )
	oBrowse:AddLegend( "SZ0->Z0_STATUS == '1'", "GREEN", "Finalizada" )
	oBrowse:AddLegend( "SZ0->Z0_STATUS == '1'", "RED",   "Pendente" )
	oBrowse:Activate()

	/*
	Local aArea   := GetArea()
	Local oBrowse

	//Inst�nciando FWMBrowse - Somente com dicion�rio de dados
	oBrowse := FWMBrowse():New()

	//Setando a tabela de cadastro de Autor/Interprete
	oBrowse:SetAlias("SZ0")

	//Setando a descri��o da rotina
	oBrowse:SetDescription(cTitulo)

	//Legendas
	oBrowse:AddLegend( "SZ0->Z0_STATUS == '1'", "GREEN", "Finalizada" )
	oBrowse:AddLegend( "SZ0->Z0_STATUS == '1'", "RED",   "Pendente" )

	//Ativa a Browse
	oBrowse:Activate()

	RestArea(aArea)*/

Return Nil

/*---------------------------------------------------------------------*
| Func:  MenuDef                                                      |
| Autor: Marcus Ferraz                                                |
| Data:  05/07/2016                                                   |
| Desc:  Cria��o do menu MVC                                          |
| Obs.:  /                                                            |
*---------------------------------------------------------------------*/

Static Function MenuDef()
	Local aRot := {}

	//Adicionando op��es
	ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.CADSZ0' OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE 'Incluir' ACTION 'VIEWDEF.CADSZ0' OPERATION 3 ACCESS 0
	ADD OPTION aRotina TITLE 'Alterar' ACTION 'VIEWDEF.CADSZ0' OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE 'Excluir' ACTION 'VIEWDEF.CADSZ0' OPERATION 5 ACCESS 0
	ADD OPTION aRotina TITLE 'Imprimir' ACTION 'VIEWDEF.CADSZ0' OPERATION 8 ACCESS 0
	//ADD OPTION aRotina TITLE �Copiar� ACTION 'VIEWDEF.CADZZ1' OPERATION 9 ACCESS 0

Return aRot

/*---------------------------------------------------------------------*
| Func:  ModelDef                                                     |
| Autor: Marcus Ferraz                                                |
| Data:  05/07/2016                                                   |
| Desc:  Cria��o do modelo de dados MVC                               |
| Obs.:  /                                                            |
*---------------------------------------------------------------------*/

Static Function ModelDef()
	Local oModel        := Nil
	Local oStPai        := FWFormStruct(1, 'SZ0')
	Local oStFilho  	:= FWFormStruct(1, 'SZ1')
	Local aSZ1Rel       := {}

	//Criando o modelo e os relacionamentos
	oModel := MPFormModel():New('CADSZ0')
	oModel:AddFields('SZ0MASTER',/*cOwner*/,oStPai)
	oModel:AddGrid('SZ1DETAIL','SZ0MASTER',oStFilho,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)  //cOwner � para quem pertence

	//Fazendo o relacionamento entre o Pai e Filho
	aAdd(aSZ1Rel, {'Z1_FILIAL', 'Z0_FILIAL'} )
	aAdd(aSZ1Rel, {'Z1_CODPRC',  'Z0_CODPRC'}) 

	oModel:SetRelation('SZ1DETAIL', aSZ1Rmarel, SZ1->(IndexKey(1))) //IndexKey -> quero a ordena��o e depois filtrado
	oModel:GetModel('SZ1DETAIL'):SetUniqueLine({"Z1_FILIAL","Z1_CODPRC"})  //N�o repetir informa��es ou combina��es {"CAMPO1","CAMPO2","CAMPOX"}
	oModel:SetPrimaryKey({})

	//Setando as descri��es
	oModel:SetDescription("Prescri��o M�dica")
	oModel:GetModel('SZ0MASTER'):SetDescription('Prescri��o')
	oModel:GetModel('SZ1DETAIL'):SetDescription('Item Prescri��o')
Return oModel

/*---------------------------------------------------------------------*
| Func:  ViewDef                                                      |
| Autor: Marcus Ferraz                                                |
| Data:  17/08/2015                                                   |
| Desc:  Cria��o da vis�o MVC                                         |
| Obs.:  /                                                            |
*---------------------------------------------------------------------*/

Static Function ViewDef()
	//Local oView     := Nil
	Local oModel        := FWLoadModel('CADSZ0')
	Local oStPai        := FWFormStruct(2, 'SZ0')
	Local oStFilho  := FWFormStruct(2, 'SZ1')
	Local oView := FWLoadView('CADSZ0')     
	//Criando a View
	//oView := FWFormView():New()
	oView:SetModel(oModel)

	//Adicionando os campos do cabe�alho e o grid dos filhos
	oView:AddField('VIEW_SZ0',oStPai,'SZ0MASTER')
	oView:AddGrid('VIEW_SZ1',oStFilho,'SZ1DETAIL')

	//Setando o dimensionamento de tamanho
	oView:CreateHorizontalBox('CABEC',30)
	oView:CreateHorizontalBox('GRID',70)

	//Amarrando a view com as box
	oView:SetOwnerView('VIEW_SZ0','CABEC')
	oView:SetOwnerView('VIEW_SZ1','GRID')

	//Habilitando t�tulo
	oView:EnableTitleView('VIEW_SZ0','Cabecalho')
	oView:EnableTitleView('VIEW_SZ1','Prescricao')
Return oView

/*/{Protheus.doc} zMVC01Leg
Fun��o para mostrar a legenda das rotinas MVC com grupo de produtos
@author Atilio
@since 17/08/2015
@version 1.0
@example
u_zMVC01Leg()
/*/

User Function zMVC01Leg()
	Local aLegenda := {}

	//Monta as cores
	AADD(aLegenda,{"BR_VERDE",      "Finalizada"  })
	AADD(aLegenda,{"BR_VERMELHO",   "Pendente"})

	BrwLegenda("Prescri��o", "Status", aLegenda)
Return