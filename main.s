.include "gpio.s"
.include "sleep.s"
.include "lcd.s"
.include "uart.s"
.include "split.s"

.global _start

_start:
    MemoryMap
	setPinIn BTN1 @ botão do meio
	setPinIn BTN2 @ botão mais a direita antes do espaço
	setPinIn BTN3 @ botão alongado (placa 104)
	setPinsOut
	initializeDisplay
	.ltorg
    twoLine 

    page00: 
		resetCounter:
			mov r12, #0

        showText:
			clearDisplay

            bl getDecimal
            WriteCharNumber r11
            bl getUnity
            WriteCharNumber r11

		waitPage00:
			cmp r12, #32
			bgt resetCounter

			getPinState BTN2 @proxima opcao
			CMP R1, #0 @ botão apertado
			mov r5, r1
			beq incrSensor

			getPinState BTN1 @selecionar
			CMP R1, #0 @ botão apertado
			mov r5, r1
			beq selectSensor

			b waitPage00
	
    	@ Página referente à opção de HUMIDADE ATUAL
    pageReturnSensorSelec: 
		ldr r12, =return_sensor_selec
        mov r11, #14
        bl showFirstLine
		ldr r12, =first_options
        bl showSecondLine


		waitPageReturnSelect:
			getPinState BTN2
			CMP R1, #0 @ botão apertado
			beq page0a

			getPinState BTN1
			CMP R1, #0 @ botão apertado
			beq resetCounter

			b waitPageReturnSelect

    @ botões são contadores, quando clica muda de indice/página
    @ cada "página" contém uma palavra que define a tela do display atual

	@ ////////////////////////////////////////////////
	@ // 	            Camada 1 (a)                //
	@ ////////////////////////////////////////////////

	@ Página referente à opção de HUMIDADE ATUAL
    page0a: 
		ldr r12, =curr_humi
        mov r11, #13
        bl showFirstLine
		ldr r12, =options
        bl showSecondLine


		waitPage0a:
            getPinState BTN3
			CMP R1, #0 @ botão apertado
			beq pageReturnSensorSelec

			getPinState BTN2
			CMP R1, #0 @ botão apertado
			beq page1a

			getPinState BTN1
			CMP R1, #0 @ botão apertado
			beq page0b

			b waitPage0a


	@ Página referente à opção de HUMIDADE CONTÍNUA
    page1a: 
		ldr r12, =cont_humi
        mov r11, #16
		bl showFirstLine
        ldr r12, =options
		bl showSecondLine

		waitPage1a:
			getPinState BTN3
			CMP R1, #0 @ botão apertado
			beq page0a

			getPinState BTN1
			CMP R1, #0 @ botão apertado
			beq page1b

			getPinState BTN2
			CMP R1, #0 @ botão apertado
			beq page2a

			b waitPage1a


	@ Página referente à opção de TEMPERATURA ATUAL
	page2a: 
		ldr r12, =curr_temp
        mov r11, #11
		bl showFirstLine
        ldr r12, =options
        bl showSecondLine

		waitPage2a:
			getPinState BTN3
			CMP R1, #0 @ botão apertado
			beq page1a

			getPinState BTN1
			CMP R1, #0 @ botão apertado
			beq page2b

			getPinState BTN2
			CMP R1, #0 @ botão apertado
			beq page3a

			b waitPage2a
	
	@ Página referente à opção de TEMPERATURA CONTÍNUA
	page3a: 
		ldr r12, =cont_temp
        mov r11, #15
		bl showFirstLine
        ldr r12, =options
        bl showSecondLine

		waitPage3a:
			getPinState BTN3
			CMP R1, #0 @ botão apertado
			beq page2a

			getPinState BTN1
			CMP R1, #0 @ botão apertado
			beq page3b
			
			getPinState BTN2
			CMP R1, #0 @ botão apertado
			beq page4a

			b waitPage3a

	@ Página referente à opção de STATUS DO SENSOR
	page4a: 
		ldr r12, =status_req
		bl showFirstLine
        ldr r12, =last_options
		bl showSecondLine


		waitPage4a:
			getPinState BTN3
			CMP R1, #0 @ botão apertado
			beq page3a

			getPinState BTN1
			CMP R1, #0 @ botão apertado
			beq page0c

			b waitPage4a

	@ ////////////////////////////////////////////////
	@ // 	            Camada 2 (b)                //
	@ ////////////////////////////////////////////////

	@ Página referente ao valor da HUMIDADE ATUAL
    page0b: 
        mov r11, #0x00
        bl getResponse
        cmp r1, #0x07
        bne selectedSensorError

		ldr r12, =cont_humi_value
        mov r11, #9
		bl showFirstLine

        mov r11, #0x02
		bl getResponse

		bl getDecimal
        .ltorg
        WriteCharNumber r11
		bl getUnity
        WriteCharNumber r11

        ldr r12, =back_menu
		bl showSecondLine

		waitPage0b:
			getPinState BTN1
			CMP R1, #0 @ botão apertado
			beq page0a

			b waitPage0b

	@ Página referente ao valor da HUMIDADE CONTÍNUA
	page1b: 
        @ verifica se o sensor é válido
        mov r11, #0x00
        bl getResponse
        cmp r1, #0x07
        bne selectedSensorError

		ldr r12, =cont_humi_value
        mov r11, #9
		bl showFirstLine
		
        mov r11, #0x04
		bl getResponse

		bl getDecimal
        .ltorg
        WriteCharNumber r11
		bl getUnity
        WriteCharNumber r11

        ldr r12, =stop_cont
		bl showSecondLine

		mov r10, #1
		waitPage1b:		
			nanoSleep t0s, t1ms
			
			add r10, #1

			getPinState BTN1
			CMP R1, #0 @ botão apertado
			beq stopHumiCont

			cmp r10, #300 @ 2 segundos
			beq humiCont
			b waitPage1b

			humiCont:
				clearDisplay

                @ verifica se o sensor é válido

				ldr r12, =cont_humi_value
                mov r11, #9
				bl showFirstLine
				bl ReceiveDataUART
                
                cmp r12, #31
                beq selectedSensorContHumiError

                .ltorg
				bl getDecimal
				WriteCharNumber r11
				bl getUnity
				WriteCharNumber r11

                ldr r12, =stop_cont
                bl showSecondLine

				mov r10, #0

			b waitPage1b

	@ Página referente ao valor da TEMPERATURA ATUAL
	page2b: 
        @ verifica se o sensor é válido
        mov r11, #0x00
        bl getResponse
        cmp r1, #0x07
        bne selectedSensorError

		ldr r12, =cont_temp_value
        mov r11, #13
		bl showFirstLine

        mov r11, #0x01
		bl getResponse

		bl getDecimal
        WriteCharNumber r11
		bl getUnity
        WriteCharNumber r11
        
        ldr r12, =back_menu
		bl showSecondLine

		waitPage2b:	
			getPinState BTN1
			CMP R1, #0 @ botão apertado
			beq page0a

			b waitPage2b

	@ Página referente ao valor da TEMPERATURA CONTÍNUA
	page3b: 
        @ verifica se o sensor é válido
        mov r11, #0x00
        bl getResponse
        cmp r1, #0x07
        bne selectedSensorError

		ldr r12, =cont_temp_value
        mov r11, #13
		bl showFirstLine
		
        mov r11, #0x03
		bl getResponse

		bl getDecimal
        .ltorg
        WriteCharNumber r11
		bl getUnity
        WriteCharNumber r11

		ldr r12, =stop_cont
		bl showSecondLine

		mov r10, #1
		waitPage3b:	
			nanoSleep t0s, t1ms
						
			add r10, #1

			getPinState BTN1
			CMP R1, #0 @ botão apertado pressed
			beq stopTempCont

			cmp r10, #300 @ 2 segundos
			beq tempCont
			b waitPage3b

			tempCont:
				clearDisplay

				ldr r12, =cont_temp_value
                mov r11, #13
				bl showFirstLine
				bl ReceiveDataUART
				.ltorg

                cmp r12, #31
                beq selectedSensorContTempError

				bl getDecimal
				WriteCharNumber r11
				bl getUnity
				WriteCharNumber r11
				.ltorg
                ldr r12, =stop_cont
				bl showSecondLine

				mov r10, #0


			b waitPage3b

	@ ////////////////////////////////////////////////
	@ // 	            Camada 3 (c)                //
	@ ////////////////////////////////////////////////

	@ Página intermediária que verifica qual o TIPO DE RETORNO DE STATUS DO SENSOR
	page0c: 
        mov r11, #0x00
		bl getResponse

		cmp r12, #0x07
		beq statusOk

		cmp r12, #0x2F
		beq noneSensor
		
		cmp r12, #0x3F
		beq noneReq

		cmp r12, #0x1F
		beq sensorIssue

	@ sensor ok
	statusOk: 
		ldr r12, =sensor_ok
        mov r11, #12
        bl showFirstLine
		ldr r12, =back_menu
        bl showSecondLine

		waitStatusOk:	
			getPinState BTN1
			CMP R1, #0 @ botão apertado
			beq page0a

			b waitStatusOk

	@ requisição inválida
	noneReq: @ sensor status answer
		ldr r12, =none_req
        mov r11, #15
        bl showFirstLine
		ldr r12, =back_menu
        bl showSecondLine
		
		waitNoneReq:	
			getPinState BTN1
			CMP R1, #0 @ botão apertado
			beq page0a

			b waitNoneReq

	@ sensor inválido
	noneSensor: @ sensor status answer
		ldr r12, =none_sensor
        mov r11, #15
        bl showFirstLine
		ldr r12, =back_menu
        bl showSecondLine
		
		waitNoneSensor:	
			getPinState BTN1
			CMP R1, #0 @ botão apertado
			beq page0a

			b waitNoneSensor

	@ sensor com problema
	sensorIssue: @ sensor status answer
		ldr r12, =issue_sensor
        mov r11, #16
        bl showFirstLine
		ldr r12, =back_menu
        bl showSecondLine
		
		waitSensorIssue:	
			getPinState BTN1
			CMP R1, #0 @ botão apertado
			beq page0a

			b waitSensorIssue

	@ Escreve caractere a caractere de uma palavra no LCD
	writeLine:
	    sub sp, sp, #4
    	str lr, [sp]
		
		@ percorre a palavra letra por letra
		ldr r9, [r12, r10]
		WriteChar r9 @ escreve a letra no local certo e aumenta o ponteiro +1

		add r10, r10, #1 @ incrementa o r10
		
		@ verifica se ja atingiu o tamanho da palavra
		cmp r10, r11

		ldr lr, [sp]
    	add sp, sp, #4
		
		blt writeLine
		bx lr

	@ Exibe uma palavra na primeira linha do LCD
	showFirstLine:
		sub sp, sp, #4
		str lr, [sp]

		clearDisplay
		
		mov r10, #0
		bl writeLine

		ldr lr, [sp]
		add sp, sp, #4

		bx lr

	@ Exibe uma palavra na segunda linha linha do LCD
	showSecondLine:
		sub sp, sp, #4
		str lr, [sp]

		secondLine @ habilita a segunda linha
		
		mov r11, #17
		mov r10, #0
		bl writeLine

		ldr lr, [sp]
		add sp, sp, #4

		bx lr

	@ ///////////////////////////////////////////////////////////////////////////////////////
	@ // 	            Funções de solicitação e retorno de dados pela UART                //
	@ ///////////////////////////////////////////////////////////////////////////////////////
	@ enviam, coletam e printam informações (no LCD)

	getResponse:
		sub sp, sp, #4
		str lr, [sp]

		bl mapMemoryUART
		bl configUART
		bl setPinToUART

		mov r0, r11
		bl sendUART

		ldr r12, =current_sensor
		ldr r12, [r12]
		mov r0, r12
		bl sendUART

		bl receiveUART

		mov r12, r1

		ldr lr, [sp]
		add sp, sp, #4

		bx lr

    getStatus:
		sub sp, sp, #4
		str lr, [sp]

		bl mapMemoryUART
		bl configUART
		bl setPinToUART

		mov r0, #0x00
		bl sendUART

		ldr r12, =current_sensor
		ldr r12, [r12]

		mov r0, r12
		bl sendUART

		bl receiveUART

		ldr lr, [sp]
		add sp, sp, #4

		bx lr

	ReceiveDataUART:
		sub sp, sp, #4
		str lr, [sp]

		bl mapMemoryUART
        bl configUART
        bl setPinToUART

        bl receiveUART

        mov r12, r1

		ldr lr, [sp]
		add sp, sp, #4

		bx lr

	stopTempCont:
		clearDisplay
		ldr r12, =parando_cont
        mov r11, #13
		bl showFirstLine

        mov r11, #0x05
		bl getResponse

		b page0a

		
	stopHumiCont:
		clearDisplay
		ldr r12, =parando_cont
        mov r11, #13
		bl showFirstLine

        mov r11, #0x06
		bl getResponse

		b page0a

incrSensor:
	nanoSleep t0s, t500ms
	add r12, #1
	
	debounceLoop:
		nanoSleep t0s, t500ms
		getPinState BTN2
		cmp r1, r5
		bne returnBx
		b debounceLoop

	returnBx:
		b showText

selectSensor:
	ldr r1, =current_sensor
	str r12, [r1]
    bl getStatus

    cmp r1, #0x07
    beq page0a

    cmp r1, #0x2F
    beq selectedSensorError
    
    cmp r1, #0x1F
    beq selectedSensorError

    b page0a

selectedSensorError:
    ldr r12, =none_sensor
    mov r11, #16
    bl showFirstLine

    nanoSleep t1s, t0s
    b resetCounter

selectedSensorContHumiError:
	mov r11, #0x06
	bl getResponse

    ldr r12, =none_sensor
    mov r11, #16
    bl showFirstLine

    nanoSleep t1s, t0s
    b resetCounter

selectedSensorContTempError:
	mov r11, #0x05
	bl getResponse

    ldr r12, =none_sensor
    mov r11, #16
    bl showFirstLine

    nanoSleep t1s, t0s
    b resetCounter

.data
    sensor_choose: .ascii "Sensor number: \n" 
    status_req: .ascii "Status Do Sensor.\n" 
    options: .ascii "Vol. Selec. Prx.\n"  
    first_options: .ascii "---- Selec. Prx."  
    last_options: .ascii "Vol. Selec. ----.\n" 
	back_menu: .ascii " Voltar ao Menu     .\n" 
    curr_humi: .ascii "Umidade Atual \n" 
    cont_humi: .ascii "Umidade Continua\n" 
    cont_humi_value: .ascii "Umidade:    \n" 
	curr_temp: .ascii "Temp. Atual\n" 
    cont_temp: .ascii "Temp. Continua \n"
    cont_temp_value: .ascii "Temperatura:    \n"
	stop_cont: .ascii " Parar Continuo   \n"
	sensor_ok: .ascii "   Sensor Ok \n"
	none_sensor: .ascii "Sensor Invalido    \n"
	issue_sensor: .ascii "Sensor com Prob.\n"
	none_req: .ascii "  Req. Invalida\n"
	parando_cont: .ascii "   Parando...  \n"
	return_sensor_selec: .ascii "Alterar Sensor\n"

	current_sensor: .word 0x0F

    menu_req: .ascii "Voltar ao Menu\n" 
    devMem: .asciz "/dev/mem" @ caminho do arquivo que representa a memoria RAM
    gpioaddr: .word 0x1C20 @ endereco base GPIO / 4096
    pagelen: .word 0x1000 @ tamanho da pagina
	uartaddr: .word 0x1C28 @ endereço base UART

	t1ms: .word 1000000 @ 1ms
	t1s: .word 1 @ 1ms
	t0s: .word 0 @ zero
	t5ms: .word 5000000 @ 5 ms
	t500ms: .word 500000000 @ 5 ms
	t150us: .word 150000 @ 150us
	
	@ ///////////////////////////////////////////////////////////
    @ //                Pinos referentes à UART                //
    @ ///////////////////////////////////////////////////////////
    PA13: @ UART3_TX
        .word 0x4
        .word 0x14
        .word 0x10
        .word 0xD

    PA14: @ UART3_RX
        .word 0x4
        .word 0x18
        .word 0x10
        .word 0xE

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
        .word 0xDC @ offset do registrador de configuração
        .word 0x0 @ offset >> no << registrador de configuração
        .word 0xE8 @ offset do registrador de dados
        .word 0x8 @ offset >> no << registrador de dados

    D5: @PG9 
        .word 0xDC @ offset do registrador de configuração
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

	BTN3: @BTN3
		.word 0x0
		.word 0x1C
		.word 0x10
        .word 0x7
        