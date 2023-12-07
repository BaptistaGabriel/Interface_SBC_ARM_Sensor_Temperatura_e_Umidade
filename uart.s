.equ UART3_RST, 0x2D8
.equ UART3_RST_OFFSET, 0x13

.equ PLL_ENABLE, 0x28
.equ PLL_ENABLE_OFFSET, 0x1F

.equ PLL_CLK_SEL, 0x6C
.equ PLL_CLK_SEL_OFFSET, 0x13

.equ PLL_PLL_SELECT, 0x58
.equ PLL_PLL_SELECT_OFFSET, 0x18

mapMemoryCCU:
    sub sp, sp, #4
    str lr, [sp]

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

    ldr lr, [sp]
    add sp, sp, #4

    bx lr

configClock:
    sub sp, sp, #4
    str lr, [sp]

    bl mapMemoryCCU

    @ setando a saída do pll_periph0 pra 24MHZ
    ldr r0, [r9, #PLL_ENABLE]
    mov r1, #1
    lsl r1, #PLL_ENABLE_OFFSET @31
    orr r0, r1
    str r0, [r9, #PLL_ENABLE]

    @ setando o src do APB2 como pll_periph0
    ldr r0, [r9, #PLL_PLL_SELECT]
    mov r1, #0b11
    lsl r1, #PLL_PLL_SELECT_OFFSET @24
    orr r0, r1
    str r0, [r9, #PLL_PLL_SELECT]

    @ direcionando o clock pra a uart
    ldr r0, [r9, #PLL_CLK_SEL]
    mov r1, #1
    lsl r1, #PLL_CLK_SEL_OFFSET @19
    orr r0, r1
    str r0, [r9, #PLL_CLK_SEL]

    @ desligando o rst da uart
    ldr r0, [r9, #UART3_RST]
    mov r1, #1
    lsl r1, #UART3_RST_OFFSET @19
    orr r0, r1
    str r0, [r9, #UART3_RST]

    ldr lr, [sp]
    add sp, sp, #4

    bx lr

mapMemoryUART:
    sub sp, sp, #4
    str lr, [sp]

    bl configClock @ mapeia a ccu e configura os registradores 

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

    ldr lr, [sp]
    add sp, sp, #4

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
    sub sp, sp, #4
    str lr, [sp]

    @ remove o bit de paridade

    @ seta a quantidade de bits pra 8 (DLS)
    ldr r1, [r9, #0xC]
    mov r2, #0b11
    orr r1, r2

    @ ativa o DLL
    mov r2, #1
    lsl r2, #7
    orr r1, r2
    str r1, [r9, #0xC]

    @ setando o baud rate (24MHz - 4069) no DLH e DLL
    @ DLH
    ldr r1, [r9, #4]
    mov r2, #0b11111111
    bic r1, r2
    mov r2, #0b00001111
    orr r1, r2
    str r1, [r9, #4]

    @DLL
    ldr r1, [r9]
    mov r2, #0b11111111
    bic r1, r2
    mov r2, #0b11100101
    orr r1, r2
    str r1, [r9]

    @ desativa o DLL/volta pra RBR
    ldr r1, [r9, #0xC]
    mov r2, #1
    lsl r2, #7
    bic r1, r2
    str r1, [r9, #0xC]

    @ habilitando o FIFO
    ldr r1, [r9, #0x4]
    mov r2, #1
    orr r1, r2
    str r1, [r9, #0x4]

    ldr lr, [sp]
    add sp, sp, #4

    bx lr

sendUART:
    @ r0 - valor a ser enviado (8 bits)
    str r0, [r9, #0]
    bx lr

receiveUART:
    @ r1 - valor a ser recebido
    ldr r1, [r9, #0]
    bx lr
