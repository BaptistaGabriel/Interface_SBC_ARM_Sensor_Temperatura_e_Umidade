@ /////////////////////////////////////////////////////////////////////////////////////////////
@ //                         Seta (todos) os pinos do LCD pra saída                          //
@ /////////////////////////////////////////////////////////////////////////////////////////////
.macro setPinsOut @ok
	setPinOut E
	setPinOut RS
	setPinOut D7
	setPinOut D6
	setPinOut D5
	setPinOut D4
.endm


@ /////////////////////////////////////////////////////////////////////////////////////////////
@ //                                 Pulso >1ms no E (enable)                                //
@ /////////////////////////////////////////////////////////////////////////////////////////////
.macro enable
    setPinLow E
    nanoSleep t0s, t1ms

    setPinHigh E
    nanoSleep t0s, t1ms

    setPinLow E
.endm


@ /////////////////////////////////////////////////////////////////////////////////////////////
@ //                                   inicializa o display                                  //
@ /////////////////////////////////////////////////////////////////////////////////////////////
.macro initializeDisplay @ok
    setPinLow RS

    @ inicio da inicialização
    
    setPinLow D7
    setPinLow D6
    setPinHigh D5
    setPinHigh D4
    enable
    nanoSleep t0s, t5ms

    setPinLow D7
    setPinLow D6
    setPinHigh D5
    setPinHigh D4
    enable    
    nanoSleep t0s, t150us

    setPinLow D7
    setPinLow D6
    setPinHigh D5
    setPinHigh D4
    enable

    setPinLow D7
    setPinLow D6
    setPinHigh D5
    setPinLow D4
    enable

    setPinLow D7
    setPinLow D6
    setPinHigh D5
    setPinLow D4
    enable

    setPinLow D7
    setPinLow D6
    setPinLow D5
    setPinLow D4
    enable

    setPinLow D7
    setPinLow D6
    setPinLow D5
    setPinLow D4
    enable

    setPinHigh D7
    setPinLow D6
    setPinLow D5
    setPinLow D4
    enable
    .ltorg


    setPinLow D7
    setPinLow D6
    setPinLow D5
    setPinLow D4
    enable

    setPinLow D7
    setPinLow D6
    setPinLow D5
    setPinHigh D4
    enable
    
    setPinLow D7
    setPinLow D6
    setPinLow D5
    setPinLow D4
    enable

    setPinLow D7
    setPinHigh D6
    setPinHigh D5
    setPinLow D4
    enable
    @ até aqui é a inicialização (pg. 46 datasheet)

    @ instruções para poder escrever no LCD

    @ display on
    setPinLow D7
    setPinLow D6
    setPinLow D5
    setPinLow D4
    enable

    setPinHigh D7
    setPinHigh D6
    setPinHigh D5
    setPinLow D4
    enable

    @ entry mode set
    setPinLow D7
    setPinLow D6
    setPinLow D5
    setPinLow D4
    enable

    setPinLow D7
    setPinHigh D6
    setPinHigh D5
    setPinLow D4
    enable
.endm

@ /////////////////////////////////////////////////////////////////////////////////////////////
@ //                Limpa o display e move o cursor para o primeiro endereço                 //
@ /////////////////////////////////////////////////////////////////////////////////////////////
.macro clearDisplay @ok
	setPinLow RS

	setPinLow D7
	setPinLow D6
	setPinLow D5
	setPinLow D4
	enable
	
    setPinLow D7
	setPinLow D6
	setPinLow D5
	setPinHigh D4
	enable
.endm

@ /////////////////////////////////////////////////////////////////////////////////////////////
@ //                            Habilita a segunda linha do LCD                              //
@ /////////////////////////////////////////////////////////////////////////////////////////////
.macro twoLine @ok
    setPinLow D7
    setPinLow D6
    setPinHigh D5
    setPinLow D4
    enable

    setPinHigh D7
    setPinLow D6
    setPinHigh D5
    setPinLow D4
    enable
.endm

@ /////////////////////////////////////////////////////////////////////////////////////////////
@ //                      Liga o display - TALVEZ N PRECISE DESSA MACRO                      //
@ /////////////////////////////////////////////////////////////////////////////////////////////
.macro displayOn @ok
	setPinLow RS
	
	setPinLow D7
    setPinLow D6	
	setPinLow D5		
	setPinLow D4
	enable

	setPinHigh D7
	setPinHigh D6
	setPinHigh D5
	setPinHigh D4
	enable
.endm


@ /////////////////////////////////////////////////////////////////////////////////////////////
@ //                           Move o cursor para a primeira linha                           //
@ /////////////////////////////////////////////////////////////////////////////////////////////
.macro firstLine 
	setPinLow RS
	
	setPinHigh D7	
	setPinLow D5	
	setPinLow D6	
	setPinLow D4
	enable

	setPinLow D7
    setPinLow D6
    setPinLow D5		
	setPinLow D4	
	enable
.endm

@ /////////////////////////////////////////////////////////////////////////////////////////////
@ //                           Move o cursor para a segunda linha                            //
@ /////////////////////////////////////////////////////////////////////////////////////////////
.macro secondLine 
	setPinLow RS
	
	setPinHigh D7	
    setPinHigh D6
	setPinLow D5	
	setPinLow D4
	enable

	setPinLow D7	
	setPinLow D6
	setPinLow D5
	setPinLow D4	
	enable
.endm


.macro writeChar value
    mov r9, \value
    setPinHigh RS

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

    enable

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

    enable
.endm

.macro writeCharNumber value
    mov r9, \value
    setPinHigh RS

    setPinLow D7 @0

    setPinLow D6 @0

    setPinHigh D5 @1
    
    setPinHigh D4 @0

    enable

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

    enable
.endm
