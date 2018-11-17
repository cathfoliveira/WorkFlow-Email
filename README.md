# WorkFlow-Email
Configuração de disparo de e-mail e desenvolvimento de rotina padrão - Protheus

Existem rotinas que são feitas manualmente e podem ser substituídas por um simples envio de emails.

 -Gostaria de lembrar aos seus clientes depois de n dias de vencimento de suas faturas que eles possuem fatura em aberto?
 
 -Gerar e enviar boletos automaticamente para seus clientes, sem que este processo seja manual?
 
 -Efetuar integração com a CDL Brasil para negativar clientes inadimplentes (integração com SPC/CDL é por envio e recebimento de emails)?
 
 -Encaminhar relatório de performance aos colaboradores?
 
 -Emitir avisos aos colaboradores para acompanhamento dos seus pedidos de compras?
 
 -Disparar relatórios de vendas/compras?
 
 O código abaixo deverá ser incluído nos "appserver.ini" da empresa. E os parâmetros deverão ser configurados com o auxílio do fonte
 "FsEnvMail 4.7.1 - tttp110" (desenvolvido pelo Ernani Forastieri - https://www.ernaniforastieri.com/products/fsenvmail1/).
 
 [MAIL]
 
Protocol=POP3

AuthLOGIN=1

AuthNTLM=1

AuthPLAIN=1

ExtendSMTP=0
