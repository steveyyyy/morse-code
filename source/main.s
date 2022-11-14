

.equ RPI_BASE, 0x20000000
.equ GPIO_BASE, RPI_BASE + 0x200000
.equ GPFSEL2, GPIO_BASE + 0x8
.equ GPSET0, GPIO_BASE + 0x1C // pin is on
.equ GPCLR0, GPIO_BASE + 0x28 // pin is off


.globl _start
_start:

b main

main:
   mov r1,#1
   lsl r1,#3  /* -> 000 001 000 */
   ldr r0,=GPFSEL2
   str r1,[r0]
   mov r1,#1
   lsl r1,#21

MainLoop:
   ldr r0,=GPCLR0
   str r1,[r0]

   mov r2,#0x3F0000
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

/*
Letter 'S'
 */
initialise_sOn:
   mov r2,#0x2F0000
   ldr r0,=GPSET0
   str r1,[r0]

execute_s_on:
   sub r2,#1
   cmp r2,#0   
   bne execute_s_on

initialise_sOff:
   ldr r0,=GPCLR0
   str r1,[r0]
   mov r2,#0x2F0000
   
execute_s_off:
   sub r2,#1
   cmp r2,#0
   bne execute_s_off
   

executeMorse_S:
   add r8,#1
   cmp r8,#4
   bne initialise_sOn
   bx lr


// Morse the letter 'O'

initialise_oOn:
   mov r2,#0x6F0000
   ldr r0,=GPSET0
   str r1,[r0]   

execute_o_on:
   sub r2,#1
   cmp r2,#0   
   bne execute_o_on   

initialise_oOff:
   ldr r0,=GPCLR0
   str r1,[r0]
   mov r2,#0x6F0000

execute_o_off:
   sub r2,#1
   cmp r2,#0
   bne execute_o_off

executeMorse_O:
   add r8,#1
   cmp r8,#4
   bne initialise_oOn
   bx lr