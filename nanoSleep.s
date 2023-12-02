nanoSleep:
    @ r0 recebe o tempo em segundos
    @ r1 recebe o tempo em ms
    ldr r0, [r0]
    ldr r1, [r1]
    mov r7, #162
    svc 0

    bx lr