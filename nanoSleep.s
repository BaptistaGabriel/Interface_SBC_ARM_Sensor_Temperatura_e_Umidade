nanoSleep:
    @ r0 recebe o tempo em segundos
    @ r1 recebe o tempo em ms
    mov r7, #162
    svc 0

    bx lr