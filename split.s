
@ ////////////////////////////////////////////////////////////////////////
@ //                    Pega a dezena de um número                      //
@ ////////////////////////////////////////////////////////////////////////
getDecimal: @ divisão pra achar os digitos
    @ r12 - valor a ser dividido
    mov r9, #10
    sdiv r11, r12, r9

    bx lr
    

@ ////////////////////////////////////////////////////////////////////////
@ //                    Pega a unidade de um número                      //
@ ////////////////////////////////////////////////////////////////////////
getUnity: @ divisão pra achar os digitos
    @ r12 - valor a ser dividido
    mov r9, #10
    sdiv r11, r12, r9

    @ pega o segundo digito
    mul r9, r11, r9
    sub r11, r12, r9

    bx lr
    