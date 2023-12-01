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