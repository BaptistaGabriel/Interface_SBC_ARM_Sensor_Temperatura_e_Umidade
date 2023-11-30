mapMemory

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
    orr r2, r0

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
    @ |1|000 -> 000|1| e depois substitui isso no r2 (registrador de dados)
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