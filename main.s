.global _start

_start


.data
    @ ///////////////////////////////////////////////////////////
    @ // Pinos referentes a d7, d6, d5, d4, RS e Enable do LCD //
    @ ///////////////////////////////////////////////////////////

    PG6: @ d6
        .word 0xD8 @ offset do registrador de configuração
        .word 0x18 @ offset >> no << registrador de configuração
        .word 0xE8 @ offset do registrador de dados
        .word 0x6 @ offset >> no << registrador de dados

    PG7: @ d7
        .word 0xD8 @ offset do registrador de configuração
        .word 0x1C @ offset >> no << registrador de configuração
        .word 0xE8 @ offset do registrador de dados
        .word 0x7 @ offset >> no << registrador de dados

    PG8: @ d4
        .word 0xD8 @ offset do registrador de configuração
        .word 0x0 @ offset >> no << registrador de configuração
        .word 0xE8 @ offset do registrador de dados
        .word 0x8 @ offset >> no << registrador de dados

    PG9: @ d5
        .word 0xD8 @ offset do registrador de configuração
        .word 0x4 @ offset >> no << registrador de configuração
        .word 0xE8 @ offset do registrador de dados
        .word 0x9 @ offset >> no << registrador de dados

    PA18: @ ENABLE
        .word 0x8 @ offset do registrador de configuração
        .word 0x8 @ offset >> no << registrador de configuração
        .word 0x10 @ offset do registrador de dados
        .word 0x12 @ offset >> no << registrador de dados

    PA18: @ RS
        .word 0x0 @ offset do registrador de configuração
        .word 0x8 @ offset >> no << registrador de configuração
        .word 0x10 @ offset do registrador de dados
        .word 0x2 @ offset >> no << registrador de dados
