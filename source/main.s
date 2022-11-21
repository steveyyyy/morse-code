.include "base.inc"
.include "morse.inc"
.include "timer.inc"


.section .data
stringToBeMorsed: 
.asciz "SOS"                     @ each letter is 8-bits (= 1 Byte) -> can use byte loader; .asciz := string, which ends with NULL

.globl _start
_start:

b main

.section .text

main:
   mov r1,#1                     @ 000 000 001
   lsl r1,#3                     @ -> 000 001 000
   ldr r0,=GPFSEL2
   str r1,[r0]
   mov r1,#1
   lsl r1,#21  @ on, output pin

MainLoop:
   ldr r0,=GPCLR0
   str r1,[r0]

   mov r2,#0x3F0000              @ set pause
   bl reinitialise

   mov r8,#0
   bl executeMorse_S

   mov r2,#0x3F0000
   bl pause_between_letters

   mov r8,#0
   bl executeMorse_O

   mov r2,#0x3F0000
   bl pause_between_letters

   mov r8,#0
   bl executeMorse_S

   mov r2,#0x3F0000
   bl pause_between_letters
   
   mov r2,#0x7F0000
   bl reinitialise

   b MainLoop   

reinitialise:  
   ldr r0,=GPCLR0
   str r1,[r0]
   sub r2,#1
   cmp r2,#0   
   bne reinitialise
   bx lr

pause_between_letters:
   ldr r0,=GPCLR0
   str r1,[r0]
   sub r2,#2
   cmp r2,#0
   bne pause_between_letters
   bx lr
