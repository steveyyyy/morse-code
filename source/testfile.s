@ https://community.arm.com/arm-community-blogs/b/architectures-and-processors-blog/posts/how-to-call-a-function-from-arm-assembler
@ maybe write morse function and use the letter to be morsed as a parameter on the stack?

/*
.include "base.inc"
.include "morse.inc"
.include "timer.inc"
 */

.section .data
@ TODO remove .equ, just here for test purposes
.equ RPI_BASE, 0x20000000 
.equ GPIO_BASE, RPI_BASE + 0x200000 

.equ GPFSEL2,GPIO_BASE + 0x8        @ GPIO select 2
.equ GPSET0, GPIO_BASE + 0x1C       @ pin is on .equ GPCLR0,
.equ GPCLR0, GPIO_BASE + 0x28       @ pin is off


morseString:
.asciz "soS9@"                       @ each letter is 8-bits (= 1 Byte) -> can use byte loader; .asciz := string, which ends with NULL

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
    lsl r1,#21                      @ set pin to output


MainLoop:
    ldr r10, =morseString            @ load string
    mov r9,#0                        @ counter of iterations
    convertToUpperCase:              @ while loop
        add r8, r9, r10
        ldrb r0, [r8]                @ load current letter in r0
        cmp r0, #0                   @ check if value is null -> break
        beq endOfString
        cmp r0,#97                   @ check if < 97; ASCII boundary for lower case letter
        blt checkMorse
        cmp r0, #122                 @ check if > 122; ASCII boundary for lower case letter
        bgt checkMorse

        @ capitalize if lowercase letter
        sub r0,#32                   @ convert to uppercase
        strb r0,[r8]                 @ save back
        b checkMorse
    b convertToUpperCase

loopIncrement:
    add r9, #1               @ increment offset
    b convertToUpperCase

checkMorse:
    cmp r0, #57
    ble morseNumber
    cmp r0, #65
    bge morseLetter
    b loopIncrement


doMorse:
    @ switch statemement oder binary search? irgendwie schade, die info wegzuschmeissen, ob man von letter oder number kommt
    @ https://thinkingeek.com/2013/08/23/arm-assembler-raspberry-pi-chapter-16/

    case_0:
        cmp r0, #48
        bne case_1
        @ TODO code for morse 0
        mov r2, #100  @ TODO remove, just here for testpurposes to see if branching works
        b loopIncrement
    
    case_1:
        cmp r0, #49
        bne case_S
        @ TODO code for morsing 1
        mov r2, #200  @ TODO remove, just here for testpurposes to see if branching works
        b loopIncrement
    case_S:
        cmp r0, #83
        bne default
        @ TODO code for morsing S
        mov r2, #300  @ TODO remove, just here for testpurposes to see if branching works
        b loopIncrement
    default:
        mov r2, #50  @ TODO remove, just here for testpurposes to see if branching works
        b loopIncrement

morseNumber:
    cmp r0, #48
    bge doMorse

morseLetter:
    cmp r0, #90
    ble doMorse

endOfString:
    nop @ infinite Loop
b endOfString
