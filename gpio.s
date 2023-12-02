mapMemory
    ldr r0, =devMem
    mov r1, #2
    mov r7, #5
    svc 0
    mov r4, r0 @ pega o arquivo que dá acesso à memória física

    ldr r5, =gpioaddr @ pega o endereço base 0x1C20
    ldr r5, [r5]
    ldr r1, =pagelen @ pega o tamanho da página - 1k (4096)
    ldr r1, [r1]
    mov r2, #3 
    mov r3, #1
    mov r0, #0 @ so escolhe o endereço da memória virtual
    mov r7, #192 @sysmmap2
    svc 0
    mov r8, r0
    add r8, #0x800 @ offset pra pegar o endereço base da GPIO 0x1C20800

    bx lr


pinInput:
    @ r0 deve receber o endereço base dos offsets dos pinos
    @ exemplo: ldr r0, =pg7

    ldr r1, [r0] @ carrega o offset do registrador de configuração do pino
    ldr r3, [r0, #4] @ carrega o offset >> no << registrador de configuração do pino
    ldr r2, [r8, r1] @ carrega o registrador de configuração do pino
    
    @ criando a máscara e substituindo o registrador de dados
    @ |000|000 -> 000|000| e depois substitui isso no r2 (registrador de config)
    mov r0, #0xb111
    lsl r0, r3
    bic r2, r0

    @ guardando novamente na memória
    str r2, [r8, r1]
    bx lr


pinOutput:
    @ r0 deve receber o endereço base dos offsets dos pinos
    @ exemplo: ldr r0, =pg7

    ldr r1, [r0] @ carrega o offset do registrador de configuração do pino
    ldr r3, [r0, #4] @ carrega o offset >> no << registrador de configuração do pino
    ldr r2, [r8, r1] @ carrega o registrador de configuração do pino
    
    @ criando a máscara e substituindo o registrador de dados
    @ |001|000 -> 000|001| e depois substitui isso no r2 (registrador de config)

    mov r0, #0xb111
    lsl r0, r3
    bic r2, r0
    mov r4, #1
    lsl r4, r3
    orr r2, r4

    @ guardando novamente na memória
    str r2, [r8, r1]
    
    bx lr


setPinHigh:
    @ r0 deve receber o endereço base dos offsets dos pinos
    @ exemplo: ldr r0, =pg7

    ldr r1, [r0, #8] @ carrega o offset do registrador de dados do pino
    ldr r3, [r0, #12] @ carrega o offset >> no << registrador de dados do pino
    ldr r2, [r8, r1] @ carrega o registrador de dados do pino
    
    @ criando a máscara e substituindo o registrador de dados
    @ |1|000 -> 000|1| e depois substitui isso no r2 (registrador de dados)
    mov r0, #1
    lsl r0, r3
    orr r2, r2, r0

    @ guardando novamente na memória
    str r2, [r8, r1]

    bx lr


setPinLow:
    @ r0 deve receber o endereço base dos offsets dos pinos
    @ exemplo: ldr r0, =pg7

    ldr r1, [r0, #8] @ carrega o offset do registrador de dados do pino
    ldr r3, [r0, #12] @ carrega o offset >> no << registrador de dados do pino
    ldr r2, [r8, r1] @ carrega o registrador de dados do pino
    
    @ criando a máscara e substituindo o registrador de dados
    @ |0|000 -> 000|0| e depois substitui isso no r2 (registrador de dados)
    mov r0, #1
    lsl r0, r3
    bic r2, r0

    @ guardando novamente na memória
    str r2, [r8, r1]

    bx lr

getPinState:
    @ r0 deve receber o endereço base dos offsets dos pinos
    @ exemplo: ldr r0, =pg7

    ldr r1, [r0, #8] @ carrega o offset do registrador de dados do pino
    ldr r3, [r0, #12] @ carrega o offset >> no << registrador de dados do pino
    ldr r2, [r8, r1] @ carrega o registrador de dados do pino
    
    @ move o valor do estado pra o bit menos significativo e zera o resto
    @ 000|1| -> |1|000 ou 000|0| -> |0|000
    mov r0, #1
    lsr r2, r3
    and r1, r2, r0

    bx lr


@ /////////////////////////////////////////////////////////////////////////////////////////////
@ //          Verifica se um bit é 0 ou 1 e adiciona esse estado a d7, d6, d5 ou d4          //
@ /////////////////////////////////////////////////////////////////////////////////////////////
setCondPinState:
    @ pegando o estado do pino
    mov r4, #1
    mov r3, r9
    lsr r3, r2 @ move o bit (na posição em r2) pra o LSB
    and r1, r4, r3 @ atribui 0 ou 1 para r1 (a depender do estado do bit)

    @ pegando o registrador de dados
    ldr r3, [r5, #8]
    ldr r2, [r5, #12]
    ldr r6, [r8, r2] @ coloca o registrador de dados em r6

    @ cria máscara ...0000|1| -> ...00|1|00 (r2 vezes)
    mov r4, #1
    lsl r4, r2

    @ verificando se o estado do bit é 0 ou 1
    cmp r1, #0
    beq lowState 

    @ highState
    orr r6, r4
    str r6, [r8, r3]
    bx lr

    lowState:
        bic r6, r4
        str r6, [r8, r3]
        bx lr
    
