enable:
    sub sp, sp, #4
    str lr, [sp]

    ldr r0, =E
    bl setPinLow

    r0, =t0s
    r1, =t1ms
    bl nanoSleep

    ldr r0, =E
    bl setPinHigh

    r0, =t0s
    r1, =t1ms
    bl nanoSleep

    ldr r0, =E
    bl setPinLow

    ldr lr, [sp]
    add sp, sp, #4

    bx lr

setPinsLow:
    sub sp, sp, #4
    str lr, [sp]

    ldr r0, =RS
    bl setPinLow

    ldr r0, =D4
    bl setPinLow

    ldr r0, =D5
    bl setPinLow

    ldr r0, =D6
    bl setPinLow

    ldr r0, =D7
    bl setPinLow

    ldr lr, [sp]
    add sp, sp, #4

    bx lr


initializeDisplay:
    sub sp, sp, #4
    str lr, [sp]

    ldr r0, =RS
    bl setPinLow

    @ /////////////// function set - 8 bits ///////////////
    ldr r0, =D4
    bl setPinHigh

    ldr r0, =D5
    bl setPinHigh

    ldr r0, =D6
    bl setPinLow

    ldr r0, =D7
    bl setPinLow
    @////////////////////////////////////////////


    bl enable

    r0, =t0s
    r1, =t5ms
    bl nanoSleep

    @ /////////////// function set - 8 bits ///////////////
    ldr r0, =D4
    bl setPinHigh

    ldr r0, =D5
    bl setPinHigh

    ldr r0, =D6
    bl setPinLow

    ldr r0, =D7
    bl setPinLow
    @////////////////////////////////////////////

    
    bl enable

    r0, =t0s
    r1, =t5ms
    bl nanoSleep


    @ /////////////// function set - 8 bits ///////////////
    ldr r0, =D4
    bl setPinHigh

    ldr r0, =D5
    bl setPinHigh

    ldr r0, =D6
    bl setPinLow

    ldr r0, =D7
    bl setPinLow
    @////////////////////////////////////////////



    @ /////////////// function set - 4 bits ///////////////
    ldr r0, =D4
    bl setPinLow

    ldr r0, =D5
    bl setPinHigh

    ldr r0, =D6
    bl setPinLow

    ldr r0, =D7
    bl setPinLow
    @////////////////////////////////////////////


    @////////////////////////////////////////////
    ldr r0, =D4
    bl setPinLow

    ldr r0, =D5
    bl setPinLow

    ldr r0, =D6
    bl setPinLow

    ldr r0, =D7
    bl setPinHigh
    @////////////////////////////////////////////


    @////////////////////////////////////////////
    ldr r0, =D4
    bl setPinLow

    ldr r0, =D5
    bl setPinLow

    ldr r0, =D6
    bl setPinLow

    ldr r0, =D7
    bl setPinLow
    @////////////////////////////////////////////

    
    @////////////////////////////////////////////
    ldr r0, =D4
    bl setPinLow

    ldr r0, =D5
    bl setPinLow

    ldr r0, =D6
    bl setPinLow

    ldr r0, =D7
    bl setPinHigh
    @////////////////////////////////////////////


    @////////////////////////////////////////////
    ldr r0, =D4
    bl setPinLow

    ldr r0, =D5
    bl setPinLow

    ldr r0, =D6
    bl setPinLow

    ldr r0, =D7
    bl setPinLow
    @////////////////////////////////////////////

    
    @////////////////////////////////////////////
    ldr r0, =D4
    bl setPinHigh

    ldr r0, =D5
    bl setPinLow

    ldr r0, =D6
    bl setPinLow

    ldr r0, =D7
    bl setPinLow
    @////////////////////////////////////////////

    
    @////////////////////////////////////////////
    ldr r0, =D4
    bl setPinLow

    ldr r0, =D5
    bl setPinLow

    ldr r0, =D6
    bl setPinLow

    ldr r0, =D7
    bl setPinLow
    @////////////////////////////////////////////

    
    @////////////////////////////////////////////
    ldr r0, =D4
    bl setPinHigh

    ldr r0, =D5
    bl setPinHigh

    ldr r0, =D6
    bl setPinHigh

    ldr r0, =D7
    bl setPinLow
    @////////////////////////////////////////////

    bl enable
    @ delay

    ldr lr, [sp]
    add sp, sp, #4

    bx lr


clearDisplay:
    sub sp, sp, #4
    str lr, [sp]

    ldr r0, =RS
    bl setPinLow

    ldr r0, =D4
    bl setPinLow

    ldr r0, =D5
    bl setPinLow

    ldr r0, =D6
    bl setPinLow

    ldr r0, =D7
    bl setPinLow

    bl enable

    ldr r0, =D4
    bl setPinHigh

    bl enable

    ldr lr, [sp]
    add sp, sp, #4

    bx lr

writeChar:
    sub sp, sp, #4
    str lr, [sp]

    ldr r9, [r9]

    ldr r0, =RS
    bl setPinHigh

    mov r2, #7
    ldr r5, =D7
    bl setCondPinState

    mov r2, #6
    ldr r5, =D6
    bl setCondPinState

    mov r2, #5
    ldr r5, =D5
    bl setCondPinState

    mov r2, #4
    ldr r5, =D4
    bl setCondPinState

    bl enable

    mov r2, #3
    ldr r5, =D7
    bl setCondPinState

    mov r2, #2
    ldr r5, =D6
    bl setCondPinState

    mov r2, #1
    ldr r5, =D5
    bl setCondPinState

    mov r2, #0
    ldr r5, =D4
    bl setCondPinState

    bl enable

    ldr lr, [sp]
    add sp, sp, #4

    bx lr

writeWord:
    @ r0 - palavra
    @ r11 - tamanho da palavra 
    @ exemplo: ldr r0, =palavra 

    sub sp, sp, #4
    str lr, [sp]

    mov r12, #0
    loopWrite:
        ldr r9, [r0, r12]
        bl writeChar

        cmp r12, r11
        beq endWrite

        add r12, r12, #1
        b loopWrite

    endWrite:
        ldr lr, [sp]
        add sp, sp, #4

        bx lr