mapMemoryCCU:
    ldr r0, =devMem
    mov r1, #2
    mov r7, #5
    svc 0
    mov r4, r0 @ pega o arquivo que dá acesso à memória física

    ldr r5, =gpioaddr @ pega o endereço base 0x1C28
    ldr r5, [r5]
    ldr r1, =pagelen @ pega o tamanho da página - 1k (4096)
    ldr r1, [r1]
    mov r2, #3 
    mov r3, #1
    mov r0, #0 @ so escolhe o endereço da memória virtual
    mov r7, #192 @sysmmap2
    svc 0

    mov r9, r0 

    bx lr

configClock:
    sub sp, sp, #4
    str lr, [sp]

    bl mapMemoryCCU

    @ setando a saída do pll_periph0 pra 24MHZ


    @ setando o src do APB2 como pll_periph0


    @ direcionando o clock pra a uart


    @ desligando o rst da uart


    ldr lr, [sp]
    add sp, sp, #4

    bx lr

mapMemoryUART:
    ldr r0, =devMem
    mov r1, #2
    mov r7, #5
    svc 0
    mov r4, r0 @ pega o arquivo que dá acesso à memória física

    ldr r5, =uartaddr @ pega o endereço base 0x1C28
    ldr r5, [r5]
    ldr r1, =pagelen @ pega o tamanho da página - 1k (4096)
    ldr r1, [r1]
    mov r2, #3 
    mov r3, #1
    mov r0, #0 @ so escolhe o endereço da memória virtual
    mov r7, #192 @sysmmap2
    svc 0

    mov r9, r0
    add r9, #0xC00 

    bx lr

setPinToUART:
    @ r0 - pino
    @ deve ser usado no PA13 e no PA14

    ldr r1, [r0]
    ldr r3, [r0, #4]
    ldr r2, [r8, r1]

    mov r4, #0b111
    lsl r4, r3
    bic r2, r4
    mov r4, #0b011
    lsl r4, r3
    orr r2, r4

    str r2, [r8, r1]

    bx lr

@ -----------------------------------------------------------------------
@                           UART CONFIGURATION
@ -----------------------------------------------------------------------

configUART: 
    
    bx lr

sendUART:
    @ r0 - valor a ser enviado (8 bits)
    str r0, [r9, #0]
    bx lr

receiveUART:
    @ r1 - valor a ser recebido
    ldr r1, [r9, #0]
    bx lr