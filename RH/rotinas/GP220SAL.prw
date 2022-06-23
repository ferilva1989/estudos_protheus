//Ponto de Entrada para alterar Base de Cálculo do Desconto do Vale transporte - Empresa BSL - Proporcional ao dias trabalhados

User Function GP220SAL() 

	If  SRA->RA_CATFUNC <> "E" 
		nCustFun := ( ((SRA->RA_SALARIO/30)*DIASTRAB) * nPercentual ) / 100                              
	Endif

Return(nCustFun) 