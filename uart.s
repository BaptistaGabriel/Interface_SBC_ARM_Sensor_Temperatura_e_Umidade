.equ UART3_RST, 0x2D8
.equ UART3_RST_OFFSET, 0x13

.equ PLL_ENABLE, 0x28
.equ PLL_ENABLE_OFFSET, 0x1F

.equ PLL_CLK_SEL, 0x6C
.equ PLL_CLK_SEL_OFFSET, 0x13

.equ PLL_APB2, 0x58
.equ PLL_APB2_OFFSET, 0x18

@ /////////////////////////////////////////////////////////////////////////////////////////////
@ //                                 Mapeia a memória do CCU                                 //
@ /////////////////////////////////////////////////////////////////////////////////////////////
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

    mov r10, r0 

    bx lr

@ /////////////////////////////////////////////////////////////////////////////////////////////
@ //                   Configurações dos registradores referentes ao clock                   //
@ /////////////////////////////////////////////////////////////////////////////////////////////
configClock:
    sub sp, sp, #4
    str lr, [sp]

    bl mapMemoryCCU

    @ setando a saída do pll_periph0 pra 624MHz
    ldr r0, [r10, #PLL_ENABLE]
    mov r1, #1
    lsl r1, #PLL_ENABLE_OFFSET @31
    orr r0, r1
    str r0, [r10, #PLL_ENABLE]

    @ setando o src do APB2 como pll_periph0
    ldr r0, [r10, #PLL_APB2]
    mov r1, #0b11
    lsl r1, #PLL_APB2_OFFSET @24
    orr r0, r1
    str r0, [r10, #PLL_APB2]

    @ direcionando o clock pra a uart
    ldr r0, [r10, #PLL_CLK_SEL]
    mov r1, #1
    lsl r1, #PLL_CLK_SEL_OFFSET @19
    orr r0, r1
    str r0, [r10, #PLL_CLK_SEL]

    @ ligando o rst da uart
    ldr r0, [r10, #UART3_RST]
    mov r1, #1
    lsl r1, #UART3_RST_OFFSET @19
    bic r0, r1
    str r0, [r10, #UART3_RST]

    @ desligando o rst da uart
    ldr r0, [r10, #UART3_RST]
    mov r1, #1
    lsl r1, #UART3_RST_OFFSET @19
    orr r0, r1
    str r0, [r10, #UART3_RST]
    ldr lr, [sp]

    add sp, sp, #4
    bx lr

@ /////////////////////////////////////////////////////////////////////////////////////////////
@ //                                 Mapeia a memória da UART                                //
@ /////////////////////////////////////////////////////////////////////////////////////////////
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

    mov r10, r0
    add r10, #0xC00 

    ldr lr, [sp]
    add sp, sp, #4

    bx lr

@ /////////////////////////////////////////////////////////////////////////////////////////////
@ //                  Seta um pino específico pra o modo UART (TX ou RX)                     //
@ /////////////////////////////////////////////////////////////////////////////////////////////
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

@ /////////////////////////////////////////////////////////////////////////////////////////////
@ //            Configuração da UART (baud rate, enables, qtd de bits, FIFOS)                //
@ /////////////////////////////////////////////////////////////////////////////////////////////

configUART: 
    sub sp, sp, #4
    str lr, [sp]

    @ seta a quantidade de bits pra 8 (DLS)
    ldr r1, [r10, #0xC]

    mov r2, #0b11
    orr r1, r2

    @ ativa o DLL
    mov r2, #1
    lsl r2, #7
    orr r1, r2
    str r1, [r10, #0xC]

    @ 1/ 9600 por byte
    @ setando o divisor (4069) no DLH e DLL
    @ DLH
    ldr r1, [r10, #4]
    mov r2, #0b11111111
    bic r1, r2
    mov r2, #0b00001111
    orr r1, r2
    str r1, [r10, #4]

    @DLL
    ldr r1, [r10]
    mov r2, #0b11111111
    bic r1, r2
    mov r2, #0b11100101
    orr r1, r2
    str r1, [r10]

    @ desativa o DLL/volta pra RBR
    ldr r1, [r10, #0xC]
    mov r2, #1
    lsl r2, #7
    bic r1, r2
    str r1, [r10, #0xC]

    @ habilitando o FIFO
    ldr r1, [r10, #0x8]
    mov r2, #1
    bic r1, r2
    orr r1, r2
    str r1, [r10, #0x8]

    ldr lr, [sp]
    add sp, sp, #4

    bx lr

@ /////////////////////////////////////////////////////////////////////////////////////////////
@ //                                        Envia os dados                                   //
@ /////////////////////////////////////////////////////////////////////////////////////////////
sendUART:
    @ ro - valor a ser enviado
    str r0, [r10, #0]
    bx lr
    

@ /////////////////////////////////////////////////////////////////////////////////////////////
@ //                                       Recebe os dados                                   //
@ /////////////////////////////////////////////////////////////////////////////////////////////
receiveUART:
    @ verifica se o FIFO não está vazio
    @ enquanto estiver, permanece em loop
    ldr r1, [r10, #0x7C]
    mov r2, #1
    lsr r1, #3
    and r1, r2

    cmp r1, #0
    beq receiveUART

    ldr r1, [r10, #0]

    bx lr
