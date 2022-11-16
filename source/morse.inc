
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