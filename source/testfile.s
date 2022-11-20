.section .data
morseString:
.asciz "sos"                       @ each letter is 8-bits (= 1 Byte) -> can use byte loader; .asciz := string, which ends with NULL

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
    convertToUpperCase:              @ while loop
        add r8, r9, r10
        ldrb r0, [r8]                @ load current letter in r0
        cmp r0, #0                   @ check if value is null -> break
        beq endOfString
        cmp r0,#97                   @ check if < 97; ASCII boundary for lower case letter
        blt loopIncrement
        cmp r0, #122                 @ check if > 122; ASCII boundary for lower case letter
        bgt loopIncrement

        @ capitalize if lowercase letter
        sub r0,#32                   @ convert to uppercase
        strb r0,[r8]                 @ save back

        @ TODO should we do the morse stuff here or in a separate loop after the conversion?

        loopIncrement:
            add r9, #1               @ increment offset
    b convertToUpperCase

endOfString:
    nop @ infinite Loop
b endOfString
