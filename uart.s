mapMemoryUart:
    ldr r0, =devMem
    mov r1, #2
    mov r7, #5
    svc 0
    mov r4, r0 @ pega o arquivo que dá acesso à memória física

    ldr r5, uartaddr @ pega o endereço base 0x1C28
    ldr r5, [r5]
    ldr r1, =pagelen @ pega o tamanho da página - 1k (4096)
    ldr r1, [r1]
    mov r2, #3 
    mov r3, #1
    mov r0, #0 @ so escolhe o endereço da memória virtual
    mov r7, #192 @sysmmap2
    svc 0

    mov r9, r0
    add r9, #0xC00 @ offset pra pegar o endereço base da GPIO 0x1C20800

    bx lr

@ -----------------------------------------------------------------------
@                           UART CONFIGURATION
@ -----------------------------------------------------------------------

sendUART:
    @ r0 - valor a ser enviado (8 bits)
    str r0, [r9, #0]

    bx lr

receiveUART:
    @ r1 - valor a ser recebido
    ldr r1, [r9, #0]
    bx lr