.global _start
_start:

b sensor_ok_screen

@ printar
print:
    mov r0, #1
    mov r7, #4
    svc 0

    bx lr

main_screen:
    ldr r1, =status
    mov r2, #19
    bl print

    ldr r1, =measure
    mov r2, #20
    bl print

    b end

status_screen:
    ldr r1, =status
    bl print

measurement_screen:
    ldr r1, =current_measure
    mov r2, #16
    bl print

    ldr r1, =continuous_measure
    mov r2, #20
    bl print

    b end

humidity_screen:
    ldr r1, =humidity
    mov r2, #8
    bl print

    ldr r1, =back_menu
    mov r2, #13
    bl print

    b end

temperature_screen:
    ldr r1, =temperature
    mov r2, #8
    bl print

    ldr r1, =back_menu
    mov r2, #13
    bl print

    b end

sensor_not_ok_screen:
    ldr r1, =sensor_not_ok
    mov r2, #14
    bl print

    ldr r1, =back_menu
    mov r2, #13
    bl print

    b end

sensor_ok_screen:
    ldr r1, =sensor_ok
    mov r2, #10
    bl print

    ldr r1, =back_menu
    mov r2, #13
    bl print

    b end

end: @fechar o processo
    mov r0, #0
    mov r7, #1

    svc 0

.data 
value: .ascii "helloworld\n"
status: .ascii "Status Requisition\n"
measure: .ascii "Measure Requisition\n"
current_measure: .ascii "Current Measure\n"
continuous_measure: .ascii "Continuous Measure\n"
temperature: .ascii "T:21.0C\n"
humidity: .ascii "H:45.0%\n"
back_menu: .ascii "Back to Menu\n"
sensor_ok: .ascii "Sensor OK\n"
sensor_not_ok: .ascii "Sensor not OK\n"

