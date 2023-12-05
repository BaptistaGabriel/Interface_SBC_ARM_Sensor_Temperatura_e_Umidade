.global _start

_start:


.data
    devMem: .asciz "/dev/mem" 
    gpioaddr: .word 0x1C20 
    pagelen: .word 0x1000 

    t0s: .word 0
    t1s: .word 1
    t1ms: .word 1000000
    t5ms: .word 5000000
    t150us: .word 150000


    @ ///////////////////////////////////////////////////////////
    @ // Pinos referentes aos LEDS azul e vermelho da orangepi //
    @ //                                                       //
    @ //                      Remover depois                   //
    @ ///////////////////////////////////////////////////////////

    PA9: @ LED Azul
        .word 0x4
        .word 0x4
        .word 0x10
        .word 0x9

    PA8: @ LED Vermelho
        .word 0x4
        .word 0
        .word 0x10
        .word 0x8

    @ ///////////////////////////////////////////////////////////
    @ // Pinos referentes a d7, d6, d5, d4, RS e Enable do LCD //
    @ ///////////////////////////////////////////////////////////

    D6: @PG6 
        .word 0xD8 @ offset do registrador de configuração
        .word 0x18 @ offset >> no << registrador de configuração
        .word 0xE8 @ offset do registrador de dados
        .word 0x6 @ offset >> no << registrador de dados

    D7: @PG7 
        .word 0xD8 @ offset do registrador de configuração
        .word 0x1C @ offset >> no << registrador de configuração
        .word 0xE8 @ offset do registrador de dados
        .word 0x7 @ offset >> no << registrador de dados

    D4: @PG8 
        .word 0xD8 @ offset do registrador de configuração
        .word 0x0 @ offset >> no << registrador de configuração
        .word 0xE8 @ offset do registrador de dados
        .word 0x8 @ offset >> no << registrador de dados

    D5: @PG9 
        .word 0xD8 @ offset do registrador de configuração
        .word 0x4 @ offset >> no << registrador de configuração
        .word 0xE8 @ offset do registrador de dados
        .word 0x9 @ offset >> no << registrador de dados

    E: @PA18 ENABLE
        .word 0x8 @ offset do registrador de configuração
        .word 0x8 @ offset >> no << registrador de configuração
        .word 0x10 @ offset do registrador de dados
        .word 0x12 @ offset >> no << registrador de dados

    RS: @PA18 
        .word 0x0 @ offset do registrador de configuração
        .word 0x8 @ offset >> no << registrador de configuração
        .word 0x10 @ offset do registrador de dados
        .word 0x2 @ offset >> no << registrador de dados


    @ ///////////////////////////////////////////////////////////
    @ //              Pinos referentes aos botões              //
    @ ///////////////////////////////////////////////////////////

	BTN1: @PA10
		.word 0x4
		.word 0x8
		.word 0x10
        .word 0xA

	BTN2: @PA20
		.word 0x8
		.word 0x10
		.word 0x10
        .word 0x14

	BTN3: @PA7
		.word 0x0
		.word 0x1C
		.word 0x10
        .word 0x7
        