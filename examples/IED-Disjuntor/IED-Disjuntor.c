/******************************************************************************
IED-Disjuntor - Este exemplo, simula um IED disjuntor na rede IEC61850 
                utilizando o protocolo mms.        

Autor: Eng. Fabrício Ribeiro
Data: 08/11/2026            
******************************************************************************/

#include "iec61850_simple_server_api.h"
#include "thread.h"
#include <signal.h>
#include <stdlib.h>
#include <stdio.h>
#include <stdbool.h>

static int running = 1;

void sigint_handler(int signalId) {
    running = 0;
}

int main(int argc, char** argv) {
    printf("[IED01] Inicializando simulador de disjuntor na API FLR...\n");

    /* 
       Na arquitetura simplificada de exemplos desse repositório, o servidor 
       pode ser criado passando NULL se o modelo estático já estiver vinculado 
       e compilado em conjunto no binário, ou utilizando a variável global direta.
       Tentaremos a inicialização direta conforme o core da biblioteca gerencia.
    */
    IedServer server = IedServer_create(NULL);

    if (server == NULL) {
        printf("[ERROR] Falha ao criar o IED Server.\n");
        return 1;
    }

    // Inicializa o servidor MMS 
    IedServer_start(server);

    if (!IedServer_isRunning(server)) {
        printf("[ERROR] Falha ao iniciar o servidor (Porta TCP ocupada?).\n");
        IedServer_destroy(server);
        return 1;
    }

    printf("[IED01] Servidor rodando com sucesso! Aguardando conexões MMS do SCADA...\n");
    signal(SIGINT, sigint_handler);

    // Loop estável padrão para manter o serviço respondendo chamadas de rede externas
    while (running) {
        Thread_sleep(100);
    }

    // Encerramento limpo e liberação da porta TCP 102 do Linux
    IedServer_stop(server);
    IedServer_destroy(server);
    
    printf("[IED01] Servidor finalizado.\n");
    return 0;
}
