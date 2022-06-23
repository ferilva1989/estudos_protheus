#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
#INCLUDE "RWMAKE.CH"
#Include 'Protheus.ch'
#Include 'FWEditPanel.ch'
#Include 'MATA094.ch'

// #########################################################################################
// Projeto: BSL
// Modulo : SIGACOM
// Fonte  : XCOMA001
// ---------+-------------------+-----------------------------------------------------------
// Data     | Autor             | Descricao
// ---------+-------------------+-----------------------------------------------------------
// 21/08/18 | Edie Carlos       | Valida aprovação .
// ---------+-------------------+-----------------------------------------------------------
user function XCOMA001(_npoc)

	local aButtons := {{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},;
		{.F.,Nil},{.T.,'Confirmar'},{.T.,'Cancelar'},{.F.,Nil},;
		{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil}}
	Private TP_OP := _npoc

	//VERIFICA SE O DOCUMENTO ESTA DISPONIVEL PARA LIBERAÇÃO
	If SCR->CR_STATUS='01'
		Help(" ",1,"A097BLQ") // Esta operação não poderá ser realizada pois este registro se encontra bloqueado pelo sistema
		Return(.F.)
	EndIf

	If SCR->CR_STATUS='03'
		Help(" ",1,"A097BLQ") // Esta operação não poderá ser realizada pois este registro se encontra bloqueado pelo sistema
		Return(.F.)
	EndIf

	If SCR->CR_TIPO <> 'C2'
		Help(" ",1,"Somente documentos do tipo C2")
		Return(.F.)
	EndIf

	If SCR->CR_STATUS='05'
		Help(" ",1,"Documento foi rejeitado pelo nivel anterior!")
		Return(.F.)
	EndIf

Return(FWExecView("","XCOMA001",3,,{|| .T.},,,aButtons,,TP_OP))

Static Function ModelDef(_npoc)
	Local oModel
	Local oStr1 := FWFormStruct(1,'SCR',{|cCampo| AllTrim(cCampo) $ "CR_FILIAL|CR_TIPO|CR_NUM|CR_TOTAL|CR_EMISSAO|CR_DATALIB|CR_OBS|CR_GRUPO|CR_ITGRP|CR_APROV|CR_STATUS"})
	Local oStr2 := FWFormStruct(1,'DBL',{|cCampo| !AllTrim(cCampo) $ "DBL_GRUPO|DBL_ITEM"})
	Local oStr3 := FWFormStruct(1,'SAK',{|cCampo| AllTrim(cCampo) $ "AK_NOME|AK_LIMMIN|AK_LIMMAX|AK_LIMITE|AK_TIPO"})
	Local oStr4 := FWFormStruct(1,'SC1',{|cCampo| AllTrim(cCampo) $ "C1_ITEM|C1_PRODUTO|C1_DESCRI|C1_UM|C1_SEGUM|C1_QUANT|C1_VUNIT|C1_QTSEGUM"})


	//-- Total solicitação
	oStr1:AddField("Total Solicitacao"								,;	// 	[01]  C   Titulo do campo
	"Total Solicitacao"												,;	// 	[02]  C   ToolTip do campo
	"TOTSOL"														,;	// 	[03]  C   Id do Field
	"N"																,;	// 	[04]  C   Tipo do campo
	TAMSX3("C7_TOTAL")[1]											,;	// 	[05]  N   Tamanho do campo
	0																,;	// 	[06]  N   Decimal do campo
	NIL																,;	// 	[07]  B   Code-block de validação do campo
	NIL																,;	// 	[08]  B   Code-block de validação When do campo
	NIL																,;	//	[09]  A   Lista de valores permitido do campo
	.F.																,;	//	[10]  L   Indica se o campo tem preenchimento obrigatório
	NIL																,;	//	[11]  B   Code-block de inicializacao do campo
	NIL																,;	//	[12]  L   Indica se trata-se de um campo chave
	NIL																,;	//	[13]  L   Indica se o campo pode receber valor em uma operação de update.
	.F.																)	// 	[14]  L   Indica se o campo é virtual



	//-- Campo Saldo na Data
	oStr3:AddField(STR0017											,;	// 	[01]  C   Titulo do campo
	STR0017															,;	// 	[02]  C   ToolTip do campo
	"AK_SLDDATE"													,;	// 	[03]  C   Id do Field
	"N"																,;	// 	[04]  C   Tipo do campo
	TAMSX3("AK_LIMITE")[1]											,;	// 	[05]  N   Tamanho do campo
	0																,;	// 	[06]  N   Decimal do campo
	NIL																,;	// 	[07]  B   Code-block de validação do campo
	NIL																,;	// 	[08]  B   Code-block de validação When do campo
	NIL																,;	//	[09]  A   Lista de valores permitido do campo
	.F.																,;	//	[10]  L   Indica se o campo tem preenchimento obrigatório
	NIL																,;	//	[11]  B   Code-block de inicializacao do campo
	NIL																,;	//	[12]  L   Indica se trata-se de um campo chave
	NIL																,;	//	[13]  L   Indica se o campo pode receber valor em uma operação de update.
	.F.																)	// 	[14]  L   Indica se o campo é virtual

	//-- Campo Saldo Após a Liberação
	oStr3:AddField(STR0018											,;	// 	[01]  C   Titulo do campo
	STR0018															,;	// 	[02]  C   ToolTip do campo
	"AK_SLDCALC"													,;	// 	[03]  C   Id do Field
	"N"																,;	// 	[04]  C   Tipo do campo
	TAMSX3("AK_LIMITE")[1]											,;	// 	[05]  N   Tamanho do campo
	0																,;	// 	[06]  N   Decimal do campo
	NIL																,;	// 	[07]  B   Code-block de validação do campo
	NIL																,;	// 	[08]  B   Code-block de validação When do campo
	NIL																,;	//	[09]  A   Lista de valores permitido do campo
	.F.																,;	//	[10]  L   Indica se o campo tem preenchimento obrigatório
	NIL																,;	//	[11]  B   Code-block de inicializacao do campo
	NIL																,;	//	[12]  L   Indica se trata-se de um campo chave
	NIL																,;	//	[13]  L   Indica se o campo pode receber valor em uma operação de update.
	.F.																)	// 	[14]  L   Indica se o campo é virtual


	oStr3:AddField(  RetTitle("DHL_LIMMIN")								,;	// 	[01]  C   Titulo do campo
	RetTitle("DHL_LIMMIN")												,;	// 	[02]  C   ToolTip do campo
	"DHL_LIMMIN"														,;	// 	[03]  C   Id do Field
	TAMSX3("DHL_LIMMIN")[3]												,;	// 	[04]  C   Tipo do campo
	TAMSX3("DHL_LIMMIN")[1]												,;	// 	[05]  N   Tamanho do campo
	TAMSX3("DHL_LIMMIN")[2]												,;	// 	[06]  N   Decimal do campo
	NIL																	,;	// 	[07]  B   Code-block de validação do campo
	NIL																	,;	// 	[08]  B   Code-block de validação When do campo
	NIL																	,;	//	[09]  A   Lista de valores permitido do campo
	.F.																	,;	//	[10]  L   Indica se o campo tem preenchimento obrigatório
	{||Posicione("DHL",1,xFilial("DHL") + SAL->AL_PERFIL,"DHL_LIMMIN")}	,;	//	[11]  B   Code-block de inicializacao do campo
	NIL																	,;	//	[12]  L   Indica se trata-se de um campo chave
	.T.																	,;	//	[13]  L   Indica se o campo pode receber valor em uma operação de update.
	.T.																	)	// 	[14]  L   Indica se o campo é virtual

	oStr3:AddField(  RetTitle("DHL_LIMMAX")								,;	// 	[01]  C   Titulo do campo
	RetTitle("DHL_LIMMAX")												,;	// 	[02]  C   ToolTip do campo
	"DHL_LIMMAX"														,;	// 	[03]  C   Id do Field
	TAMSX3("DHL_LIMMAX")[3]												,;	// 	[04]  C   Tipo do campo
	TAMSX3("DHL_LIMMAX")[1]												,;	// 	[05]  N   Tamanho do campo
	TAMSX3("DHL_LIMMAX")[2]												,;	// 	[06]  N   Decimal do campo
	NIL																	,;	// 	[07]  B   Code-block de validação do campo
	NIL																	,;	// 	[08]  B   Code-block de validação When do campo
	NIL																	,;	//	[09]  A   Lista de valores permitido do campo
	.F.																	,;	//	[10]  L   Indica se o campo tem preenchimento obrigatório
	{||Posicione("DHL",1,xFilial("DHL") + SAL->AL_PERFIL,"DHL_LIMMAX")}	,;	//	[11]  B   Code-block de inicializacao do campo
	NIL																	,;	//	[12]  L   Indica se trata-se de um campo chave
	.T.																	,;	//	[13]  L   Indica se o campo pode receber valor em uma operação de update.
	.T.																	)	// 	[14]  L   Indica se o campo é virtual

	oStr3:AddField(  RetTitle("DHL_COD")								,;	// 	[01]  C   Titulo do campo
	RetTitle("DHL_COD")													,;	// 	[02]  C   ToolTip do campo
	"DHL_COD"															,;	// 	[03]  C   Id do Field
	TAMSX3("DHL_COD")[3]												,;	// 	[04]  C   Tipo do campo
	TAMSX3("DHL_COD")[1]												,;	// 	[05]  N   Tamanho do campo
	TAMSX3("DHL_COD")[2]												,;	// 	[06]  N   Decimal do campo
	NIL																	,;	// 	[07]  B   Code-block de validação do campo
	NIL																	,;	// 	[08]  B   Code-block de validação When do campo
	NIL																	,;	//	[09]  A   Lista de valores permitido do campo
	.F.																	,;	//	[10]  L   Indica se o campo tem preenchimento obrigatório
	{||Posicione("DHL", 1 , xFilial("DHL") + SAL->AL_PERFIL,"DHL_COD" )},;	//	[11]  B   Code-block de inicializacao do campo
	NIL																	,;	//	[12]  L   Indica se trata-se de um campo chave
	.T.																	,;	//	[13]  L   Indica se o campo pode receber valor em uma operação de update.
	.T.																	)	// 	[14]  L   Indica se o campo é virtual

	oStr3:AddField(  RetTitle("DHL_DESCRI")									,;	// 	[01]  C   Titulo do campo
	RetTitle("DHL_DESCRI")													,;	// 	[02]  C   ToolTip do campo
	"DHL_DESCRI"															,;	// 	[03]  C   Id do Field
	TAMSX3("DHL_DESCRI")[3]													,;	// 	[04]  C   Tipo do campo
	TAMSX3("DHL_DESCRI")[1]													,;	// 	[05]  N   Tamanho do campo
	TAMSX3("DHL_DESCRI")[2]													,;	// 	[06]  N   Decimal do campo
	NIL																		,;	// 	[07]  B   Code-block de validação do campo
	NIL																		,;	// 	[08]  B   Code-block de validação When do campo
	NIL																		,;	//	[09]  A   Lista de valores permitido do campo
	.F.																		,;	//	[10]  L   Indica se o campo tem preenchimento obrigatório
	{||Posicione("DHL", 1 , xFilial("DHL") + SAL->AL_PERFIL,"DHL_DESCRI" )}	,;	//	[11]  B   Code-block de inicializacao do campo
	NIL																		,;	//	[12]  L   Indica se trata-se de um campo chave
	.T.																		,;	//	[13]  L   Indica se o campo pode receber valor em uma operação de update.
	.T.																		)	// 	[14]  L   Indica se o campo é virtual

	//-- Total PEDIDO
	oStr4:AddField("Vl Unit Ped"		    						,;	// 	[01]  C   Titulo do campo
	"Vl Unit Ped"													,;	// 	[02]  C   ToolTip do campo
	"TOTPED"														,;	// 	[03]  C   Id do Field
	"N"																,;	// 	[04]  C   Tipo do campo
	TAMSX3("C7_TOTAL")[1]					        				,;	// 	[05]  N   Tamanho do campo
	0																,;	// 	[06]  N   Decimal do campo
	NIL																,;	// 	[07]  B   Code-block de validação do campo
	NIL																,;	// 	[08]  B   Code-block de validação When do campo
	NIL																,;	//	[09]  A   Lista de valores permitido do campo
	.F.																,;	//	[10]  L   Indica se o campo tem preenchimento obrigatório
	NIL																,;	//	[11]  B   Code-block de inicializacao do campo
	NIL																,;	//	[12]  L   Indica se trata-se de um campo chave
	NIL																,;	//	[13]  L   Indica se o campo pode receber valor em uma operação de update.
	.F.																)	// 	[14]  L   Indica se o campo é virtual


	oModel := MPFormModel():New('XCOM001',/*PreModel*/, /*{|oModel| A094TudoOk(oModel)}*/, { |oModel| SCRCommit( oModel,_npoc ) },/*Cancel*/)
	oModel:SetDescription(STR0006)

	oModel:addFields('FieldSCR',,oStr1)
	oModel:addFields('FieldSAK','FieldSCR',oStr3)

	oModel:addFields('FieldDBL','FieldSCR',oStr2)
	oModel:addGrid('GridDoc','FieldSCR',oStr4)
	oModel:SetRelation("FieldDBL",{{"DBL_FILIAL",'xFilial("DBL")'},{"DBL_GRUPO","CR_GRUPO"},{"DBL_ITEM","CR_ITGRP"}},DBL->(IndexKey(1)))
	oModel:getModel('GridDoc'):SetOnlyQuery(.T.)
	oModel:getModel('FieldDBL'):SetOnlyQuery(.T.)
	oModel:getModel('FieldDBL'):SetDescription(STR0019)
	oModel:getModel('GridDoc'):SetDescription(STR0020)

	oModel:SetPrimaryKey( {} ) //Obrigatorio setar a chave primaria (mesmo que vazia)

	oModel:getModel('FieldSAK'):SetOnlyQuery(.T.)
	oModel:getModel('FieldSCR'):SetDescription(STR0021)

	If  TP_OP == "5"
		oStr1:SetProperty( 'CR_OBS' , MODEL_FIELD_OBRIGAT,.T.)
	EndIf
	//--------------------------------------
	//		Realiza carga dos grids antes da exibicao
	//--------------------------------------
	oModel:SetActivate( { |oModel| A094FilPrd( oModel ) } )


Return oModel

//-------------------------------------------------------------------
/*/{Protheus.doc} ViewDef
Definição do interface

@author leonardo.quintania

@since 27/08/2013
@version 1.0
/*/
//-------------------------------------------------------------------
Static Function ViewDef()
	Local oView
	Local oModel := FWLoadModel("XCOMA001")
	Local oStr1  := FWFormStruct(2,'SCR',{|cCampo| AllTrim(cCampo) $ "CR_NUM|CR_TOTAL|CR_EMISSAO|CR_DATALIB|CR_OBS"})
	Local oStr2  := FWFormStruct(2,'DBL',{|cCampo| !AllTrim(cCampo) $ "DBL_GRUPO|DBL_ITEM"})
	Local oStr3  := FWFormStruct(2,'SAK',{|cCampo| AllTrim(cCampo) $ "AK_NOME|AK_LIMMIN|AK_LIMMAX|AK_LIMITE|AK_TIPO"})
	Loca oStr4   := FWFormStruct(2,'SC1',{|cCampo| AllTrim(cCampo) $ "C1_ITEM|C1_PRODUTO|C1_DESCRI|C1_UM|C1_SEGUM|C1_QUANT|C1_VUNIT|C1_QTSEGUM"})
	Local lAlcSolCtb := SuperGetMv("MV_APRSCEC",.F.,.F.)



	//-- Total do solicitação
	oStr1:AddField("TOTSOL"										,;	// [01]  C   Nome do Campo
	"11"															,;	// [02]  C   Ordem
	"Total Solicitacao"															,;	// [03]  C   Titulo do campo
	"Total Solicitacao"															,;	// [04]  C   Descricao do campo
	NIL																	,;	// [05]  A   Array com Help
	"N"																	,;	// [06]  C   Tipo do campo
	PesqPict("SC7","C7_TOTAL")										,;	// [07]  C   Picture
	NIL																	,;	// [08]  B   Bloco de Picture Var
	NIL																	,;	// [09]  C   Consulta F3
	.T.																	,;	// [10]  L   Indica se o campo é alteravel
	NIL																	,;	// [11]  C   Pasta do campo
	NIL																	,;	// [12]  C   Agrupamento do campo
	NIL																	,;	// [13]  A   Lista de valores permitido do campo (Combo)
	NIL																	,;	// [14]  N   Tamanho maximo da maior opção do combo
	NIL																	,;	// [15]  C   Inicializador de Browse
	.F.																	,;	// [16]  L   Indica se o campo é virtual
	NIL																	,;	// [17]  C   Picture Variavel
	NIL																	)	// [18]  L   Indica pulo de linha após o campo

	//-- Campo Saldo na Data
	oStr3:AddField("AK_SLDDATE"														,;	// [01]  C   Nome do Campo
	"11"																,;	// [02]  C   Ordem
	STR0017															,;	// [03]  C   Titulo do campo
	STR0017															,;	// [04]  C   Descricao do campo
	NIL																	,;	// [05]  A   Array com Help
	"N"																	,;	// [06]  C   Tipo do campo
	PesqPict("SAK","AK_LIMITE")										,;	// [07]  C   Picture
	NIL																	,;	// [08]  B   Bloco de Picture Var
	NIL																	,;	// [09]  C   Consulta F3
	.T.																	,;	// [10]  L   Indica se o campo é alteravel
	NIL																	,;	// [11]  C   Pasta do campo
	NIL																	,;	// [12]  C   Agrupamento do campo
	NIL																	,;	// [13]  A   Lista de valores permitido do campo (Combo)
	NIL																	,;	// [14]  N   Tamanho maximo da maior opção do combo
	NIL																	,;	// [15]  C   Inicializador de Browse
	.F.																	,;	// [16]  L   Indica se o campo é virtual
	NIL																	,;	// [17]  C   Picture Variavel
	NIL																	)	// [18]  L   Indica pulo de linha após o campo

	//-- Campo Saldo Após a Liberação
	oStr3:AddField("AK_SLDCALC"														,;	// [01]  C   Nome do Campo
	"12"																,;	// [02]  C   Ordem
	STR0018															,;	// [03]  C   Titulo do campo
	STR0018															,;	// [04]  C   Descricao do campo
	NIL																	,;	// [05]  A   Array com Help
	"N"																	,;	// [06]  C   Tipo do campo
	PesqPict("SAK","AK_LIMITE")										,;	// [07]  C   Picture
	NIL																	,;	// [08]  B   Bloco de Picture Var
	NIL																	,;	// [09]  C   Consulta F3
	.T.																	,;	// [10]  L   Indica se o campo é alteravel
	NIL																	,;	// [11]  C   Pasta do campo
	NIL																	,;	// [12]  C   Agrupamento do campo
	NIL																	,;	// [13]  A   Lista de valores permitido do campo (Combo)
	NIL																	,;	// [14]  N   Tamanho maximo da maior opção do combo
	NIL																	,;	// [15]  C   Inicializador de Browse
	.F.																	,;	// [16]  L   Indica se o campo é virtual
	NIL																	,;	// [17]  C   Picture Variavel
	NIL																	)	// [18]  L   Indica pulo de linha após o campo

	oStr3:AddField("DHL_LIMMIN"														,;	// [01]  C   Nome do Campo
	"13"																,;	// [02]  C   Ordem
	RetTitle("DHL_LIMMIN")															,;	// [03]  C   Titulo do campo
	RetTitle("DHL_LIMMIN")															,;	// [04]  C   Descricao do campo
	NIL																	,;	// [05]  A   Array com Help
	TAMSX3("DHL_LIMMIN")[3]																	,;	// [06]  C   Tipo do campo
	PesqPict("DHL","DHL_LIMMAX")										,;	// [07]  C   Picture
	NIL																	,;	// [08]  B   Bloco de Picture Var
	NIL																	,;	// [09]  C   Consulta F3
	.T.																	,;	// [10]  L   Indica se o campo é alteravel
	NIL																	,;	// [11]  C   Pasta do campo
	NIL																	,;	// [12]  C   Agrupamento do campo
	NIL																	,;	// [13]  A   Lista de valores permitido do campo (Combo)
	NIL																	,;	// [14]  N   Tamanho maximo da maior opção do combo
	NIL																	,;	// [15]  C   Inicializador de Browse
	.T.																	,;	// [16]  L   Indica se o campo é virtual
	NIL																	,;	// [17]  C   Picture Variavel
	NIL																	)	// [18]  L   Indica pulo de linha após o campo

	oStr3:AddField("DHL_LIMMAX"														,;	// [01]  C   Nome do Campo
	"14"																,;	// [02]  C   Ordem
	RetTitle("DHL_LIMMAX")															,;	// [03]  C   Titulo do campo
	RetTitle("DHL_LIMMAX")															,;	// [04]  C   Descricao do campo
	NIL																	,;	// [05]  A   Array com Help
	TAMSX3("DHL_LIMMAX")[3]																	,;	// [06]  C   Tipo do campo
	PesqPict("DHL","DHL_LIMMAX")										,;	// [07]  C   Picture
	NIL																	,;	// [08]  B   Bloco de Picture Var
	NIL																	,;	// [09]  C   Consulta F3
	.T.																	,;	// [10]  L   Indica se o campo é alteravel
	NIL																	,;	// [11]  C   Pasta do campo
	NIL																	,;	// [12]  C   Agrupamento do campo
	NIL																	,;	// [13]  A   Lista de valores permitido do campo (Combo)
	NIL																	,;	// [14]  N   Tamanho maximo da maior opção do combo
	NIL																	,;	// [15]  C   Inicializador de Browse
	.T.																	,;	// [16]  L   Indica se o campo é virtual
	NIL																	,;	// [17]  C   Picture Variavel
	NIL																	)	// [18]  L   Indica pulo de linha após o campo

	oStr3:AddField("DHL_COD"														,;	// [01]  C   Nome do Campo
	"15"																,;	// [02]  C   Ordem
	RetTitle("DHL_COD")															,;	// [03]  C   Titulo do campo
	RetTitle("DHL_COD")															,;	// [04]  C   Descricao do campo
	NIL																	,;	// [05]  A   Array com Help
	TAMSX3("DHL_COD")[3]																	,;	// [06]  C   Tipo do campo
	PesqPict("DHL","DHL_COD")										,;	// [07]  C   Picture
	NIL																	,;	// [08]  B   Bloco de Picture Var
	NIL																	,;	// [09]  C   Consulta F3
	.T.																	,;	// [10]  L   Indica se o campo é alteravel
	NIL																	,;	// [11]  C   Pasta do campo
	NIL																	,;	// [12]  C   Agrupamento do campo
	NIL																	,;	// [13]  A   Lista de valores permitido do campo (Combo)
	NIL																	,;	// [14]  N   Tamanho maximo da maior opção do combo
	NIL																	,;	// [15]  C   Inicializador de Browse
	.T.																	,;	// [16]  L   Indica se o campo é virtual
	NIL																	,;	// [17]  C   Picture Variavel
	NIL																	)	// [18]  L   Indica pulo de linha após o campo

	oStr3:AddField("DHL_DESCRI"														,;	// [01]  C   Nome do Campo
	"16"																,;	// [02]  C   Ordem
	RetTitle("DHL_DESCRI")															,;	// [03]  C   Titulo do campo
	RetTitle("DHL_DESCRI")															,;	// [04]  C   Descricao do campo
	NIL																	,;	// [05]  A   Array com Help
	TAMSX3("DHL_DESCRI")[3]																	,;	// [06]  C   Tipo do campo
	PesqPict("DHL","DHL_DESCRI")										,;	// [07]  C   Picture
	NIL																	,;	// [08]  B   Bloco de Picture Var
	NIL																	,;	// [09]  C   Consulta F3
	.T.																	,;	// [10]  L   Indica se o campo é alteravel
	NIL																	,;	// [11]  C   Pasta do campo
	NIL																	,;	// [12]  C   Agrupamento do campo
	NIL																	,;	// [13]  A   Lista de valores permitido do campo (Combo)
	NIL																	,;	// [14]  N   Tamanho maximo da maior opção do combo
	NIL																	,;	// [15]  C   Inicializador de Browse
	.T.																	,;	// [16]  L   Indica se o campo é virtual
	NIL																	,;	// [17]  C   Picture Variavel
	NIL																	)	// [18]  L   Indica pulo de linha após o campo


	//-- Total do pedido de veda
	oStr4:AddField("TOTPED"										,;	// [01]  C   Nome do Campo
	"17"															,;	// [02]  C   Ordem
	"Vl Unit Ped"															,;	// [03]  C   Titulo do campo
	"Vl Unit Ped"															,;	// [04]  C   Descricao do campo
	NIL																	,;	// [05]  A   Array com Help
	"N"																	,;	// [06]  C   Tipo do campo
	PesqPict("SC7","C7_TOTAL")										,;	// [07]  C   Picture
	NIL																	,;	// [08]  B   Bloco de Picture Var
	NIL																	,;	// [09]  C   Consulta F3
	.T.																	,;	// [10]  L   Indica se o campo é alteravel
	NIL																	,;	// [11]  C   Pasta do campo
	NIL																	,;	// [12]  C   Agrupamento do campo
	NIL																	,;	// [13]  A   Lista de valores permitido do campo (Combo)
	NIL																	,;	// [14]  N   Tamanho maximo da maior opção do combo
	NIL																	,;	// [15]  C   Inicializador de Browse
	.F.																	,;	// [16]  L   Indica se o campo é virtual
	NIL																	,;	// [17]  C   Picture Variavel
	NIL																	)	// [18]  L   Indica pulo de linha após o campo



	oView := FWFormView():New()

	oView:SetModel(oModel)
	oView:AddField('SCRField' , oStr1,'FieldSCR' )
	oView:AddField('SAKField' , oStr3,'FieldSAK' )


	oView:AddField('DBLField' , oStr2,'FieldDBL' )
	oView:AddGrid('GridDoc'   , oStr4,'GridDoc')



	oView:CreateHorizontalBox( 'CimaSCR' , 30)
	oView:CreateHorizontalBox( 'MeioDBL' , 25)
	oView:CreateHorizontalBox( 'MeioSAK' , 20)
	oView:CreateHorizontalBox( 'BaixoDOC', 25)


	oView:SetOwnerView('SCRField','CimaSCR')
	oView:EnableTitleView('SCRField' , STR0022 )//"Dados do Documento"
	//oView:SetViewProperty('SCRField' , 'ONLYVIEW' )

	oView:SetOwnerView('SAKField','MeioSAK')
	oView:EnableTitleView('SAKField' , STR0023 ) //"Dados do Aprovador"
	oView:SetViewProperty('SAKField' , 'ONLYVIEW' )


	oView:SetOwnerView('DBLField','MeioDBL')
	oView:EnableTitleView('DBLField' , STR0019 ) //"Dados das Entidades Contábeis"
	oView:SetViewProperty('DBLField' , 'ONLYVIEW' )
	oView:SetOwnerView('GridDoc','BaixoDOC')


	oView:SetCloseOnOK({||.T.})



Return oView


	//--------------------------------------------------------------------
	/*/{Protheus.doc} A094FilPrd()
	Realiza filtro para carregar os documentos com alcadas
	@author Leonardo Quintania
	@since 28/01/2013
	@version 1.0
	@return .T.
	/*/
//--------------------------------------------------------------------
Static Function A094FilPrd(oModel)
	Local oView 		:= FWViewActive()
	Local oFieldSCR 	:= oModel:GetModel("FieldSCR")
	Local oFieldSAK 	:= oModel:GetModel("FieldSAK")
	Local oFieldDBL 	:= oModel:GetModel("FieldDBL")
	Local oModelGrid 	:= oModel:GetModel("GridDoc")
	Local cAprovS		:= ""
	Local cMed		:= ""
	Local nLinha		:= 1
	Local aSaldo		:= {}
	Local cDocBkp		:= ""
	Local lSeek     := .F.
	Local cContra		:= ""
	Local cRev			:= ""
	Local cNum			:= ""
	Local cPlan		:= ""
	Local cItem		:= ""
	Local cItemRa		:= ""
	Local cForn		:= ""
	Local lAlcSolCtb := SuperGetMv("MV_APRSCEC",.F.,.F.)
	Local lQtd		:= .F.
	Local lVlr		:= .F.
	Local aTolerancia:={}
	Local nTolVlr
	Local nTolQtd
	Local lTolerNeg := GetNewPar("MV_TOLENEG",.F.)
	Local nTotalPed
	Local nTotalDes
	Local lDescTol:= SuperGetMv("MV_DESCTOL",.F.,.F.)
	Local nTotalSC  := 0
	Local cCusto    := ""

	SAK->(dbSetOrder(1))
	SAK->(MsSeek(xFilial("SAK")+SCR->CR_APROV))

	dbSelectArea("SC1")
	SC1->(dbSetOrder(1))

	dbSelectArea("SC7")
	SC7->(dbSetOrder(1))

	oFieldSCR:LoadValue("CR_DATALIB"  , dDataBase   ) //Gatilha Data de liberação
	oFieldSCR:LoadValue("CR_NUM"      , SCR->CR_NUM   ) //Gatilha Data de liberação
	oFieldSCR:LoadValue("CR_EMISSAO"  , SCR->CR_EMISSAO   ) //Emissao do bloqueio
	oFieldSCR:LoadValue("CR_TOTAL"    , SCR->CR_TOTAL   ) //Total documento

	aSaldo:= MaSalAlc(SCR->CR_APROV,MaAlcDtRef(SCR->CR_APROV,oFieldSCR:GetValue("CR_DATALIB"))) //Calcula saldo na data
	oView:EnableTitleView('SAKField' , STR0023 ) //Dados do Aprovador


	oFieldSAK:LoadValue("AK_NOME"		, SAK->AK_NOME   )
	oFieldSAK:LoadValue("AK_LIMMIN"		, SAK->AK_LIMMIN )
	oFieldSAK:LoadValue("AK_LIMMAX"		, SAK->AK_LIMMAX )
	oFieldSAK:LoadValue("AK_LIMITE"		, SAK->AK_LIMITE )
	oFieldSAK:LoadValue("AK_TIPO"		, SAK->AK_TIPO   )
	oFieldSAK:LoadValue("AK_SLDDATE"  	, aSaldo[1] ) //Calcula saldo na data com os dados do aprovador
	oFieldSAK:LoadValue("AK_SLDCALC"  	, oFieldSAK:GetValue("AK_SLDDATE") - SCR->CR_TOTAL ) //Realiza calculo do saldo atual, subtraindo a quantidade do documento


	//--------------------------------------
	//		Configura modelo
	//--------------------------------------
	oModelGrid:SetNoInsertLine( .F. )
	oModelGrid:SetNoDeleteLine( .F. )

	//--------------------------------------
	//		Procura na tabela de Itens(DBM)
	//--------------------------------------
	BeginSQL Alias "DBMTMP"
		SELECT DBM.DBM_NUM, DBM.DBM_ITEM,DBM.DBM_ITEMRA
		FROM %Table:DBM% DBM
		WHERE DBM.DBM_FILIAL=%xFilial:DBM% AND	DBM.DBM_NUM = %Exp:SCR->CR_NUM% AND ;
		DBM.DBM_ITGRP = %Exp:SCR->CR_ITGRP% AND ;
		DBM.DBM_GRUPO = %Exp:SCR->CR_GRUPO% AND ;
		DBM.DBM_USER = %Exp:SCR->CR_USER% AND ;
		DBM.DBM_USAPRO = %Exp:SCR->CR_APROV% AND ;
		DBM.DBM_TIPO ='C2' AND ;
		DBM.%NotDel%
	EndSQL


	While !DBMTMP->(EOF())
		cNum	 := AllTrim(DBMTMP-> DBM_NUM)
		cItem	 := AllTrim(DBMTMP-> DBM_ITEM)
		cItemRa  := AllTrim(DBMTMP-> DBM_ITEMRA)


		If SC1->(dbSeek(xFilial("SC1")+ cNum + cItem ) )

			nTotalSC += SC1->C1_VUNIT * SC1->C1_QUANT
			cCusto   := SC1->C1_CC

			If cDocBkp <> cNum + cItem
				If nLinha # 1
					oModelGrid:AddLine()
				EndIf
				oModelGrid:GoLine( nLinha )
				oModelGrid:LoadValue("C1_ITEM"		, SC1->C1_ITEM    )
				oModelGrid:LoadValue("C1_PRODUTO" 	, SC1->C1_PRODUTO )
				oModelGrid:LoadValue("C1_DESCRI"	, SC1->C1_DESCRI  )
				oModelGrid:LoadValue("C1_UM"		, SC1->C1_UM      )
				oModelGrid:LoadValue("C1_VUNIT"		, SC1->C1_VUNIT   )
				oModelGrid:LoadValue("TOTPED"		, Posicione("SC7", 1 , xFilial("SC7") + SC1->C1_PEDIDO+SC1->C1_ITEMPED,"C7_PRECO" )   )


				SCX->(dbSetOrder(1))
				If SCX->(dbSeek(xFilial("SCX")+ cNum + cItem + cItemRa ) )
					oModelGrid:LoadValue("C1_QUANT"		, SC1->C1_QUANT	* (SCX->CX_PERC/100) )
					oModelGrid:LoadValue("C1_QTSEGUM"	, SC1->C1_QTSEGUM	* (SCX->CX_PERC/100) )
					cDocBkp:= cNum+cItem
				Else
					oModelGrid:LoadValue("C1_QUANT"		, SC1->C1_QUANT	)
					oModelGrid:LoadValue("C1_QTSEGUM"	, SC1->C1_QTSEGUM	)
					cDocBkp:= cNum+cItem
				EndIf
				nLinha++
			Else
				SCX->(dbSetOrder(1))
				If SCX->(dbSeek(xFilial("SCX")+ cNum + cItem + cItemRa ) )
					oModelGrid:LoadValue("C1_QUANT"		, oModelGrid:GetValue("C1_QUANT") 	 + ( SC1->C1_QUANT	*(SCX->CX_PERC/100) ) )
					oModelGrid:LoadValue("C1_QTSEGUM"	, oModelGrid:GetValue("C1_QTSEGUM") + ( SC1->C1_QTSEGUM	*(SCX->CX_PERC/100) ) )
					cDocBkp:= cNum+cItem
				EndIf
			EndIf
		EndIf
		DBMTMP->(dbSkip())
	EndDo

	DBMTMP->(dbCloseArea())

	oFieldSCR:LoadValue("TOTSOL"    ,nTotalSC ) //Total Solicitação
	oFieldDBL:LoadValue("DBL_CC"    ,cCusto) //Total Solicitação


	//--------------------------------------
	//		Configura permissao dos modelos
	//--------------------------------------
	oModelGrid:GoLine( 1 )
	oModelGrid:SetNoInsertLine( .T. )
	oModelGrid:SetNoDeleteLine( .T. )

	SAL->(dbSetOrder(3))
	SAL->(MsSeek(xFilial("SAL")+SCR->(CR_GRUPO+CR_APROV)))

Return .T.


Static Function SCRCommit(oModel)
	Local oView 	:= FWViewActive()
	Local oMdlTd  	:= FwModelActive()
	Local nTotal 	:= SCR->CR_TOTAL
	Local cCodLiber := SCR->CR_APROV
	Local cGrupo  	:= SCR->CR_GRUPO
	Local cObs 		:= ""
	Local dRefer 	:= dDatabase
	Local nRec      := 0


	IF TP_OP <> "5"// CASO SEJA APROVAÇÃO
		MaAlcDoc({SCR->CR_NUM,SCR->CR_TIPO,nTotal,cCodLiber,,cGrupo,,,,,FwFldGet("CR_OBS")},dRefer,4)
		//VERIFICA SE TEM USUARIOS PARA APROVAÇÃO
		U_XCOMA003(SCR->CR_NUM,TP_OP)
	ELSE
		MaAlcDoc({SCR->CR_NUM,SCR->CR_TIPO,,SCR->CR_APROV,,SCR->CR_GRUPO,,,,dDataBase,FwFldGet("CR_OBS")}, dDataBase ,7)
		U_XCOMA003(SCR->CR_NUM,TP_OP)
	ENDIF

Return(.T.)
