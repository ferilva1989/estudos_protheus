#Include 'Protheus.ch'

USER FUNCTION BSLCADSZ0()

	LOCAL cFiltro   := ""
	LOCAL aCores  := {{ 'SZ0->SZ0_STATUS=="1"' , 'ENABLE'  },;    // Ativo
	{ 'SZ0->SZ0_STATUS=="0"' , 'DISABLE' }}    // Inativo

	PRIVATE cAlias   := 'SZ0'
	PRIVATE _cCpo  := "Z0_CODPRC/Z0_STATUS/Z0_DATPRC/Z0_CODPAC/Z0_NOMPAC/Z0_DTNASC/Z0_IDADE/Z0_PESO/Z0_ALTURA/Z0_ALERG/Z0_CODMED/Z0_NOMMED"

	PRIVATE cCadastro := "Tabela de Umidade"
	PRIVATE aRotina     := {{"Pesquisar" , "AxPesqui"         , 0, 1 },;
	{"Visualizar" , "U_BSLPRSZ0"   , 0, 2 },;
	{"Incluir"       , "U_BSLPRSZ0"   , 0, 3 },;
	{"Alterar"      , "U_BSLPRSZ0"   , 0, 4 },;
	{"Excluir"      , "U_BSLPRSZ0"   , 0, 5 },;
	{"Consultar" , "U_BSLPRSZ0"   , 0, 6 },;
	{"Legenda"   , "U_BSLPRSZ0", 0, 7, 0, .F. }}       //"Legenda"

	dbSelectArea("SZ0")
	dbSetOrder(1)

	mBrowse( ,,,,"SZ0",,,,,,aCores,,,,,,,,cFiltro)

RETURN NIL