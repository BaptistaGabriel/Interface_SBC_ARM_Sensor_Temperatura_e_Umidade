@ /////////////////////////////////////////////////////////////////////////////////////////////
@ //                               Espera um determinado tempo                               //
@ /////////////////////////////////////////////////////////////////////////////////////////////
.macro nanoSleep seconds nano_seconds
	ldr r0, =\seconds 
	ldr r1, =\nano_seconds 
	mov r7, #162 
	svc 0 
.endm
