.equ RPI_BASE, 0x20000000 
.equ GPIO_BASE, RPI_BASE + 0x200000 

.equ GPFSEL2,GPIO_BASE + 0x8        @ GPIO select 2
.equ GPSET0, GPIO_BASE + 0x1C       @ pin is on .equ GPCLR0,
.equ GPCLR0, GPIO_BASE + 0x28       @ pin is off