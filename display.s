.include "gpio.s"

setPinsLow:
    sub sp, sp, #4
    str lr, [sp]

    mov r0, =RS
    bl setPinLow

    mov r0, =D4
    bl setPinLow

    mov r0, =D5
    bl setPinLow

    mov r0, =D6
    bl setPinLow

    mov r0, =D7
    bl setPinLow

    ldr lr, [sp]
    add sp, sp, #4

    bx lr


initializeDisplay:
    sub sp, sp, #4
    str lr, [sp]

    mov r0, =RS
    bl setPinLow

    @ /////////////// function set - 8 bits ///////////////
    mov r0, =D4
    bl setPinHigh

    mov r0, =D5
    bl setPinHigh

    mov r0, =D6
    bl setPinLow

    mov r0, =D7
    bl setPinLow
    @////////////////////////////////////////////


    @ enable
    @ delay

    @ /////////////// function set - 8 bits ///////////////
    mov r0, =D4
    bl setPinHigh

    mov r0, =D5
    bl setPinHigh

    mov r0, =D6
    bl setPinLow

    mov r0, =D7
    bl setPinLow
    @////////////////////////////////////////////

    
    @ enable
    @ delay


    @ /////////////// function set - 8 bits ///////////////
    mov r0, =D4
    bl setPinHigh

    mov r0, =D5
    bl setPinHigh

    mov r0, =D6
    bl setPinLow

    mov r0, =D7
    bl setPinLow
    @////////////////////////////////////////////



    @ /////////////// function set - 4 bits ///////////////
    mov r0, =D4
    bl setPinLow

    mov r0, =D5
    bl setPinHigh

    mov r0, =D6
    bl setPinLow

    mov r0, =D7
    bl setPinLow
    @////////////////////////////////////////////


    @////////////////////////////////////////////
    mov r0, =D4
    bl setPinLow

    mov r0, =D5
    bl setPinLow

    mov r0, =D6
    bl setPinLow

    mov r0, =D7
    bl setPinHigh
    @////////////////////////////////////////////


    @////////////////////////////////////////////
    mov r0, =D4
    bl setPinLow

    mov r0, =D5
    bl setPinLow

    mov r0, =D6
    bl setPinLow

    mov r0, =D7
    bl setPinLow
    @////////////////////////////////////////////

    
    @////////////////////////////////////////////
    mov r0, =D4
    bl setPinLow

    mov r0, =D5
    bl setPinLow

    mov r0, =D6
    bl setPinLow

    mov r0, =D7
    bl setPinHigh
    @////////////////////////////////////////////


    @////////////////////////////////////////////
    mov r0, =D4
    bl setPinLow

    mov r0, =D5
    bl setPinLow

    mov r0, =D6
    bl setPinLow

    mov r0, =D7
    bl setPinLow
    @////////////////////////////////////////////

    
    @////////////////////////////////////////////
    mov r0, =D4
    bl setPinHigh

    mov r0, =D5
    bl setPinLow

    mov r0, =D6
    bl setPinLow

    mov r0, =D7
    bl setPinLow
    @////////////////////////////////////////////

    
    @////////////////////////////////////////////
    mov r0, =D4
    bl setPinLow

    mov r0, =D5
    bl setPinLow

    mov r0, =D6
    bl setPinLow

    mov r0, =D7
    bl setPinLow
    @////////////////////////////////////////////

    
    @////////////////////////////////////////////
    mov r0, =D4
    bl setPinHigh

    mov r0, =D5
    bl setPinHigh

    mov r0, =D6
    bl setPinHigh

    mov r0, =D7
    bl setPinLow
    @////////////////////////////////////////////

    @ enable
    @ delay

    ldr lr, [sp]
    add sp, sp, #4

    bx lr


clearDisplay:
    sub sp, sp, #4
    str lr, [sp]

    mov r0, =RS
    bl setPinLow

    mov r0, =D4
    bl setPinLow

    mov r0, =D5
    bl setPinLow

    mov r0, =D6
    bl setPinLow

    mov r0, =D7
    bl setPinLow

    @ enable

    mov r0, =D4
    bl setPinHigh

    @ enable

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
    mov r5, =D7
    bl setCondPinState

    mov r2, #6
    mov r5, =D6
    bl setCondPinState

    mov r2, #5
    mov r5, =D5
    bl setCondPinState

    mov r2, #4
    mov r5, =D4
    bl setCondPinState

    @ enable

    mov r2, #3
    mov r5, =D7
    bl setCondPinState

    mov r2, #2
    mov r5, =D6
    bl setCondPinState

    mov r2, #1
    mov r5, =D5
    bl setCondPinState

    mov r2, #0
    mov r5, =D4
    bl setCondPinState

    @enable

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
        mov r9, [r0, r12]
        bl writeChar

        cmp r12, r11
        beq endWrite

        add r12, r12, #1
        b loopWrite

    endWrite:
        ldr lr, [sp]
        add sp, sp, #4
        
        bx lr