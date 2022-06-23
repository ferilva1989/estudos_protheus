#include 'protheus.ch'
#include 'parmtype.ch'

User Function EnvLink(cHtmlFile,cOldTo,cOldCC,cOldBCC,cSubject, pcFilial, pcDescProc,oP, cUserWF, cNomUsr,cTipo,_cNumSC )

	Local cServer := SuperGetMV("ZZ_SERVWF", ,"187.94.63.85:4007/") //"187.94.63.85:4007/"  //"localhost:8091/"
	Local cPExt := "http://" + cServer + "messenger/emp" + cEmpAnt + "/" + cUserWF + "/" + cHtmlFile + ".htm"
	Local cLinkWF :="\workflow\wflinksc.htm"

	IF cTipo == "1"
		cLinkWF :="\workflow\wflinksc.htm"
	ElseIF cTipo == "2"
		cLinkWF :="\workflow\wflinkScReprovado.htm"
	ElseIF cTipo == "3"
		cLinkWF :="\workflow\wflinkScPed.htm"
	ElseIF cTipo == "5"
		cLinkWF :="\workflow\wflinkCNT.htm"
	ElseIF cTipo == "6"
		cLinkWF :="\workflow\wflinkMED.htm"
	Else
		cLinkWF :="\workflow\WFLINKPEDIDO.htm"
	EndIf
	cProcExt  := "<p><font color='#0000FF'>Para acessar seu documento, clique aqui: </font></p>"
	oP:NewTask("Link de Processos Workflow", cLinkWF)  // Html com link para envio

	oP:ohtml:ValByName("usuario",cNomUsr)
	oP:ohtml:ValByName("proc_link",cPExt)
	oP:ohtml:ValByName("nr_solicitacao",_cNumSC)
	oP:ohtml:ValByName("Referente","Solicitação de Compras")

	oP:cTo  := cOldTo
	oP:cCC  := cOldCC
	oP:cBCC := cOldBCC
	oP:csubject := cSubject

	_cId :=oP:start()

return
