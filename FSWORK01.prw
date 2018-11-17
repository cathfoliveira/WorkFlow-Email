#include "protheus.ch"
#include "rwmake.ch"
#include "topconn.ch"      
#include "ap5mail.ch"     
#include "apwizard.ch"   


/*
+----------+-----------+----------+-------------------------+------+-----------+
|Programa  | FSWORK01  | Autor    |Catharina Oliveira       |Data  |15.12.2015 |
+----------+-----------+----------+-------------------------+------+-----------+
|Descricao | Função de envio/ desparo de e-mail.                               |
+----------+-------------------------------------------------------------------+
| USO      | Notificar usuário/ clientes de ocorrências desejadas.             |
+----------+-------------------------------------------------------------------+
|           ALTERACOES FEITAS DESDE A CRIACAO                                  |
+----------+-----------+-------------------------------------------------------+
|Autor     | Data      | Descricao                                             |
+----------+-----------+-------------------------------------------------------+
|          |           |                                                       |
+----------+-----------+-------------------------------------------------------+
*/


User Function EmailPad(cEmail,cAssunto, cMsg,cPathAnx,cNomAnx,lPernalonga)
********************************************************************************
* Dispara e-mail para usuários especificados - campo From=email padrão Protheus
*
*****
	
	Local nC		:= 0
	Local cAnexo	:= cPathAnx+cNomAnx
	Local aUsuarios	:= {}
	Local aMsg	   	:= {}
	Local aPara 	:= {}  
	Local cUsrMat	:= "SIGA"+cModulo
	Local cPath		:= AllTrim(GETMV("MV_QPATHW"))   /*	 \relatorios\	*/     
	Local aAreaPr 	:= GetArea()
	  													
	Private cMailConta  := AllTrim(GETMV("MV_RELACNT"))    
	Private cMailServer := AllTrim(GETMV("MV_RELSERV"))
	Private cMailSenha  := AllTrim(GETMV("MV_RELPSW"))
		 	 
	If(AllTrim(cAnexo)=="")
		cAnexo:=""
	Else
		CpyT2S(cAnexo,cPath, .T. ) 	
		cAnexo := cPath+cNomAnx           
	EndIf
	
	cAssunto:=cAssunto+" "+DTOC(Date())+"-"+SubStr(TIME(),1,5)	
	aPara := StrTokArr(cEmail,";")		
	aMsg:={{cAssunto, cMsg, cAnexo} }
	
	// Adiciona Email para Envolvidos - Se lPernalonga=.T. apenas o nome dos envolvidos foi passado.
	If lPernalonga
		For nx:=1 To Len(aPara)
			aAdd(aUsuarios,{ aPara[nx], aPara[nx]+"@pernalonga.com.br",aMsg} ) 
		Next   
	Else
		For nx:=1 To Len(aPara)
			nC := AT("@", aPara[nx] )
			aAdd(aUsuarios,{ Substr(aPara[nx],1,nC-1), aPara[nx],aMsg} ) 
		Next
	EndIf
			
	QAEnvMail(aUsuarios,cMailConta,cMailServer,cMailSenha,cUsrMat)
	RestArea(aAreaPr)
Return    



User Function EmailFrom(cEmail,cAssunto, cMsg,cPathAnx,cNomAnx,lPernalonga,cFrom,cCC)   
********************************************************************************
* Dispara e-mail para usuários, especificando remetente (From) para  
* representar o e-mail enviado e/ou e-mail de cópia.
*
*****
	Local lOk   
	Local nX		:= 0
	Local cAnexo	:= cPathAnx+cNomAnx
	Local cMail		:= ""
	Local aPara 	:= {} 
	Local aAnexo	:= {} 
	Local cPath		:= AllTrim(GETMV("MV_QPATHW"))                  
	Local aAreaPr 	:= GetArea()
	
	Private cMailConta  := AllTrim(GETMV("MV_RELACNT"))    
	Private cMailServer := AllTrim(GETMV("MV_RELSERV"))
	Private cMailSenha  := AllTrim(GETMV("MV_RELPSW"))
	  
  	cAssunto:=cAssunto+" "+DTOC(Date())+"-"+SubStr(TIME(),1,5)	
  	 
  	If(AllTrim(cAnexo)=="")
  		cAnexo	:= ""
  	ElseIf (":\" $ UPPER(cPathAnx))     
		CpyT2S(cAnexo,cPath, .T. ) 
		cAnexo := cPath+cNomAnx
	EndIf
  	
  	// Adiciona Email para Envolvidos - Se lPernalonga=.T. apenas o nome dos envolvidos foi passado. 
	If lPernalonga   
   		aPara := StrTokArr(cEmail,";")	  		
		For nX:=1 To Len(aPara)
			cMail+= aPara[nX]+"@pernalonga.com.br;" 
		Next nX
	Else 
		cMail:=cEmail
	EndIf    
  	
  	// Conecta com o Servidor SMTP
  	CONNECT SMTP SERVER cMailServer ACCOUNT cMailConta PASSWORD cMailSenha RESULT lOk  
  	
  	MailAuth(cMailConta,cMailSenha)

	If lOk
	  	//MsgStop( "Conexão OK" )
		SEND MAIL FROM cFrom TO cMail CC cCC SUBJECT cAssunto BODY cMsg ATTACHMENT cAnexo RESULT lOk    	            	            
	            	            
		If lOk
		  //MsgBox("E-mail enviado com sucesso!","E-mail enviado","INFO")
		Else
		  GET MAIL ERROR cSmtpError
		  MsgSTop( "Erro de envio : " + cSmtpError)
		EndIf
	  
	  	// Desconecta do Servidor
		DISCONNECT SMTP SERVER
	Else
		GET MAIL ERROR cSmtpError
	  	MsgStop( "Erro de conexão : " + cSmtpError)
	EndIf
	RestArea(aAreaPr)
Return(lOk)    