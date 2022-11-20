.section .data
morseString:
.asciz "sos"

.section .init  @ nicht sicher ob notwendig, CPUlator wollte das so
.globl _start
_start:

b main

.section .text

main:
    mov r1,#1                       @ 000 000 001
    lsl r1,#3                       @ -> 000 001 000
    ldr r0,=GPFSEL2
    str r1,[r0]
    mov r1,#1
    lsl r1,#21

MainLoop:
    ldr r10, =morseString
    mov r9,#0                        @ counter of iterations
    morseLetterLoop:                 @ while loop
        add r8, r9, r10
        ldrb r0, [r8]                @ load current letter in r0
        cmp r0, #0                   @ check if value is zero -> break
        beq endOfString
        sub r0,#32                   @ morse here; for test convert to uppercase
        strb r0,[r8]                 @ save back

        add r9, #1                   @ increment offset
    b morseLetterLoop

endOfString:
    nop @ infinite Loop
b endOfString
