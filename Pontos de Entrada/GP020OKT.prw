#INCLUDE "Protheus.CH"

User function GP020OKT()
	Local lRet		:= .T.
	Local aLinhas	:= ParamIXB[1]  
	Local aCampos	:= ParamIXB[2]  
	Local nX

	For nX:= 1 To Len(aLinhas)	
		IF ! (lRet := U_Maior18(aLinhas[nX]) )	    
			Exit    
		Endif

	Next nX    

Return(lRet)  

User Function Maior18(aLinha)

	Local nPosNasc	:= GdFieldPos("RB_DTNASC")
	Local nPosCpf	:= GdFieldPos("RB_CIC")
	Local nIdade	:= 0	
	Local cCPF		:= ""
	Local lRet		:= .T.

	nIdade	:= Year(dDataBase) - Year(aLinha[nPosNasc])
	cCPF	:=  Alltrim(aLinha[nPosCpf])

	nIdade	:= IIF( ( Month( dDataBase )< Month( aLinha[nPosNasc] ) ), nIdade-1,nIdade)

	if nIdade >= 18 .And. Empty(cCPF) 
		lRet:= .F.
		Aviso("Para Dependente maior de 18 anos o CPF é obrigatório")  
	endif

Return (lRet)