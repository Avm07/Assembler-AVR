//Zadanie: Realizovat upravlenie leb cube 5x5x5;
//Snachala begaet ploskost ot kraya do kraya
//potom nadpis "AVTI" po bukvam,potom vzriv iz centra i vse povtoryatsya.



.include "m8515def.inc" //---podkluchaem ATMega8515

.def temp=R16
.def stack =R17
.def counter=R18
.def Razr0=R21
.def Razr1=R22
.def Razr2=R23


;============ Interrupt Descriptor Table============
rjmp RESET ;Reset Handle
reti ;External Interrupt0 Vector Address
reti ;External Interrupt1 Vector Address
reti ;Timer1 capture Interrupt Vector Address
rjmp TimCompA ;Timer1 compare Interrupt Vector Address
reti ;Timer1 Overflow Interrupt Vector Address
reti ;Timer0 Overflow Interrupt Vector Address
reti ;UART Receive Complete Interrupt Vector Address
reti ;UART Data Register Empty Interrupt Vector Address
reti ;UART Transmit Complete Interrupt Vector Address
reti ;Analog Comparator Interrupt Vector Addres

Delay:
subi Razr0,1
sbci Razr1,0
sbci Razr2,0
brcc Delay
ret


TimCompA:
inc counter
cpi counter,1
breq a1
cpi counter,2
breq a2
cpi counter,3
breq a3
cpi counter,4
breq a4
cpi counter,5
breq a5

cpi counter,6
breq v1
cpi counter,7
breq v2
cpi counter,8
breq v3
cpi counter,9
breq v4
cpi counter,10
breq v5

cpi counter,11
breq t1
cpi counter,12
breq t2
cpi counter,13
breq t3
cpi counter,14
breq t4
cpi counter,15
breq t5

cpi counter,16
breq i1
cpi counter,17
breq i2
cpi counter,18
breq i3
cpi counter,19
breq i4
cpi counter,20
breq i5

cpi counter,21
breq fuflo



a1:rjmp Bukva_A1
a2:rjmp Bukva_A2
a3:rjmp Bukva_A3
a4:rjmp Bukva_A4
a5:rjmp Bukva_A5

v1:rjmp Bukva_V1
v2:rjmp Bukva_V2
v3:rjmp Bukva_V3
v4:rjmp Bukva_V4
v5:rjmp Bukva_V5

t1:rjmp Bukva_T1
t2:rjmp Bukva_T2
t3:rjmp Bukva_T3
t4:rjmp Bukva_T4
t5:rjmp Bukva_T5

i1:rjmp Bukva_I1
i2:rjmp Bukva_I2
i3:rjmp Bukva_I3
i4:rjmp Bukva_I4
i5:rjmp Bukva_I5

fuflo:rjmp Vzriv



reti

//********************************Nachalnie ustanovki********************
RESET:
ldi temp,$FF

out DDRA,temp

out DDRB,temp

out DDRD,temp

out DDRC,temp

clr stack
clr counter

ldi stack,low(RAMEND)
out SPL,stack
ldi stack,high(RAMEND)
out SPH,stack



rjmp Ploskost_Vertical



//rjmp Timer_Init

//***Proverka lubogo symbola***
//rjmp Bukva_I5

//************************TIM1_COMPA_INITIALIZATION***********************
Timer_Init:
ldi temp,$00
out PORTA,temp
out PORTB,temp
out PORTD,temp
cbi PORTC,5

clr counter

ldi temp,(1<<OCIE1A)
out TIMSK,temp

ldi temp,$30
out OCR1AH,temp
ldi temp,$D4
out OCR1AL,temp

ldi temp,0b00001011
out TCCR1B,temp

sei 

end:
rjmp end
//***************************Ploskost Vertical*********************************
Ploskost_Vertical:
ldi temp,$FF

out PORTA,temp
out PORTB,temp
out PORTD,temp

//************Sverhu vniz*********************

ldi Razr2,$02
ldi Razr1,$71
ldi Razr0,$00

ldi temp,0b11101111
out PORTC,temp

rcall Delay

cpi counter,2
breq Ploskost_Horizontal

asr temp
out PORTC,temp

ldi Razr2,$02
ldi Razr1,$71
ldi Razr0,$00
rcall Delay

asr temp
out PORTC,temp

ldi Razr2,$02
ldi Razr1,$71
ldi Razr0,$00
rcall Delay

asr temp
out PORTC,temp

ldi Razr2,$02
ldi Razr1,$71
ldi Razr0,$00
rcall Delay

asr temp
out PORTC,temp

ldi Razr2,$02
ldi Razr1,$71
ldi Razr0,$00
rcall Delay

//***********Snizu vverh**********************

lsl temp
inc temp
out PORTC,temp

ldi Razr2,$02
ldi Razr1,$71
ldi Razr0,$00
rcall Delay

lsl temp
inc temp
//ldi temp,0b00111011
out PORTC,temp

ldi Razr2,$02
ldi Razr1,$71
ldi Razr0,$00
rcall Delay

lsl temp
inc temp
//ldi temp,0b00110111
out PORTC,temp

ldi Razr2,$02
ldi Razr1,$71
ldi Razr0,$00
rcall Delay

//lsl temp
//inc temp
//ldi temp,0b00101111
//out PORTC,temp

//ldi Razr2,$02
//ldi Razr1,$71
//ldi Razr0,$00
//rcall Delay

inc counter
//cpi counter,2
//breq Ploskost_Horizontal

rjmp Ploskost_Vertical

//*************************************************************
//***************************Ploskost Horizontal*********************************
Ploskost_Horizontal:
//Sprava na levo
ldi temp,$00
out PORTC,temp
out PORTA,temp
out PORTB,temp
out PORTD,temp
//xoooo
//xoooo
//xoooo
//xoooo
//xoooo

sbi PORTC,5
//ldi temp,0b0010000
sbi PORTA,0
sbi PORTB,6
sbi PORTB,1
sbi PORTD,4


ldi Razr2,$02
ldi Razr1,$71
ldi Razr0,$00
rcall Delay

//oxooo
//oxooo
//oxooo
//oxooo
//oxooo
cbi PORTC,5

in temp,PORTD
lsr temp
out PORTD,temp

in temp,PORTB
lsr temp
out PORTB,temp

in temp,PORTA
lsl temp
out PORTA,temp

sbi PORTA,4

ldi Razr2,$02
ldi Razr1,$71
ldi Razr0,$00
rcall Delay

//ooxoo
//ooxoo
//ooxoo
//ooxoo
//ooxoo

in temp,PORTD
lsr temp
out PORTD,temp

sbi PORTD,7

in temp,PORTB
lsr temp
out PORTB,temp

in temp,PORTA
lsl temp
out PORTA,temp

ldi Razr2,$02
ldi Razr1,$71
ldi Razr0,$00
rcall Delay

//oooxo
//oooxo
//oooxo
//oooxo
//oooxo

in temp,PORTA
lsl temp
out PORTA,temp

in temp,PORTB
lsr temp
out PORTB,temp

in temp,PORTD
lsr temp
out PORTD,temp

ldi Razr2,$02
ldi Razr1,$71
ldi Razr0,$00
rcall Delay

//oooox
//oooox
//oooox
//oooox
//oooox

in temp,PORTA
lsl temp
out PORTA,temp

cbi PORTA,4

in temp,PORTB
lsr temp
out PORTB,temp

sbi PORTB,7

in temp,PORTD
lsr temp
out PORTD,temp

ldi Razr2,$02
ldi Razr1,$71
ldi Razr0,$00
rcall Delay

//Sleva na pravo
//oooxo
//oooxo
//oooxo
//oooxo
//oooxo
in temp,PORTA
lsr temp
out PORTA,temp
sbi PORTA,3
  
cbi PORTB,7
in temp,PORTB
lsl temp
out PORTB,temp

in temp,PORTD
lsl temp
out PORTD,temp

ldi Razr2,$02
ldi Razr1,$71
ldi Razr0,$00
rcall Delay

//ooxoo
//ooxoo
//ooxoo
//ooxoo
//ooxoo
in temp,PORTA
lsr temp
out PORTA,temp

in temp,PORTB
lsl temp
out PORTB,temp

in temp,PORTD
lsl temp
out PORTD,temp

ldi Razr2,$02
ldi Razr1,$71
ldi Razr0,$00
rcall Delay

//oxooo
//oxooo
//oxooo
//oxooo
//oxooo

in temp,PORTA
lsr temp
out PORTA,temp

in temp,PORTB
lsl temp
out PORTB,temp
sbi PORTB,0

in temp,PORTD
lsl temp
out PORTD,temp

ldi Razr2,$02
ldi Razr1,$71
ldi Razr0,$00
rcall Delay

inc counter
ldi temp,4
cpse counter,temp
rjmp Ploskost_Horizontal

//xoooo
//xoooo
//xoooo
//xoooo
//xoooo
cbi PORTA,4
sbi PORTC,5
in temp,PORTA
lsr temp
out PORTA,temp

in temp,PORTB
lsl temp
out PORTB,temp

in temp,PORTD
lsl temp
out PORTD,temp

ldi Razr2,$02
ldi Razr1,$71
ldi Razr0,$00
rcall Delay



//
rjmp Timer_Init
//*****************************************************************************
//****************************************Vzriv********************************

Vzriv:
ldi temp,$00
out PORTD,temp

out PORTA,temp

out PORTB,temp


//ooooo
//ooooo
//ooxoo
//ooooo
//ooooo
ldi temp,0b00011011
out PORTC,temp

ldi temp,0b00010000
out PORTB,temp
ldi Razr2,$02
ldi Razr1,$71
ldi Razr0,$00
rcall Delay
//ooooo
//oxxxo
//oxxxo
//oxxxo
//ooooo
ldi temp,0b00010001
out PORTC,temp

ldi temp,0b11000000
out PORTD,temp

ldi temp,0b00111001
out PORTB,temp

ldi temp,0b00001110
out PORTA,temp
ldi Razr2,$02
ldi Razr1,$71
ldi Razr0,$00
rcall Delay
//xxxxx
//xxxxx
//xxxxx
//xxxxx
//xxxxx
ldi temp,0b00100000
out PORTC,temp

ldi temp,$FF
out PORTA,temp
out PORTB,temp
out PORTD,temp
ldi Razr2,$02
ldi Razr1,$71
ldi Razr0,$00
rcall Delay

inc counter
ldi temp,24
cpse counter,temp
rjmp Vzriv
rjmp RESET
//****************************************************************************




//**********************************"Obrazi bukv*******************************
//**********************************"A1"***************************************
Bukva_A1:
clr temp

out PORTA,temp
out PORTB,temp
out PORTD,temp
//ooxoo
//ooooo
//ooooo
//ooooo
//ooooo
ldi temp,0b00001111
out PORTC,temp

ldi temp,0b00000100
out PORTD,temp
ldi Razr2,$00
ldi Razr1,$00
ldi Razr0,$FF
rcall Delay
//ooooo
//oxoxo
//ooooo
//ooooo
//ooooo
ldi temp,0b00010111
out PORTC,temp

ldi temp,0b00001010
out PORTD,temp
ldi Razr2,$00
ldi Razr1,$00
ldi Razr0,$FF
rcall Delay
//ooooo
//ooooo
//xxxxx
//ooooo
//ooooo
ldi temp,0b00011011
out PORTC,temp

ldi temp,0b00011111
out PORTD,temp
ldi Razr2,$00
ldi Razr1,$00
ldi Razr0,$FF
rcall Delay
//ooooo
//ooooo
//ooooo
//xooox
//xooox

ldi temp,0b00011100
out PORTC,temp

ldi temp,0b00010001
out PORTD,temp
ldi Razr2,$00
ldi Razr1,$00
ldi Razr0,$FF
rcall Delay
sei
rjmp Bukva_A1
//**********************************"V1"***************************************
Bukva_V1:
clr temp

out PORTA,temp
out PORTB,temp
out PORTD,temp
//xooox
//xooox
//xooox
//ooooo
//ooooo
ldi temp,0b00000011
out PORTC,temp

ldi temp,0b00010001
out PORTD,temp
ldi Razr2,$00
ldi Razr1,$00
ldi Razr0,$FF
rcall Delay
//ooooo
//ooooo
//ooooo
//oxoxo
//ooooo
ldi temp,0b00011101
out PORTC,temp

ldi temp, 0b00001010
out PORTD,temp
ldi Razr2,$00
ldi Razr1,$00
ldi Razr0,$FF
rcall Delay
//ooooo
//ooooo
//ooooo
//ooooo
//ooxoo
ldi temp,0b00011110
out PORTC,temp

ldi temp,0b00000100
out PORTD,temp
ldi Razr2,$00
ldi Razr1,$00
ldi Razr0,$FF
rcall Delay
sei
rjmp Bukva_V1
//************************************"T1"***************************************
Bukva_T1:
clr temp

out PORTA,temp
out PORTB,temp
out PORTD,temp
//xxxxx
//ooooo
//ooooo
//ooooo
//ooooo
ldi temp,0b00001111
out PORTC,temp

ldi temp,0b00011111
out PORTD,temp
ldi Razr2,$00
ldi Razr1,$00
ldi Razr0,$FF
rcall Delay
//ooooo
//ooxoo
//ooxoo
//ooxoo
//ooxoo
ldi temp,0b00010000
out PORTC,temp

ldi temp,0b00000100
out PORTD,temp
ldi Razr2,$00
ldi Razr1,$00
ldi Razr0,$FF
rcall Delay
sei
rjmp Bukva_T1
//************************************"I1"********************************************
Bukva_I1:
clr temp

out PORTA,temp
out PORTB,temp
out PORTD,temp
//xxxxx
//ooooo
//ooooo
//ooooo
//xxxxx
ldi temp,0b00001110
out PORTC,temp

ldi temp,0b00001110
out PORTD,temp
ldi Razr2,$00
ldi Razr1,$00
ldi Razr0,$FF
rcall Delay
//ooooo
//ooxoo
//ooxoo
//ooxoo
//ooooo
ldi temp,0b00010001
out PORTC,temp

ldi temp,0b00000100
out PORTD,temp
ldi Razr2,$00
ldi Razr1,$00
ldi Razr0,$FF
rcall Delay
sei
rjmp Bukva_I1


//************************************"A2"***************************
Bukva_A2:
clr temp

out PORTA,temp
out PORTB,temp
out PORTD,temp
//ooxoo
ldi temp,0b00001111
out PORTC,temp

cbi PORTB,1
ldi temp,0b10000000
out PORTD,temp
ldi Razr2,$00
ldi Razr1,$00
ldi Razr0,$FF
rcall Delay
//oxoxo
ldi temp,0b00010111
out PORTC,temp

ldi temp,0b01000000
out PORTD,temp
ldi temp,0b00000001
out PORTB,temp
ldi Razr2,$00
ldi Razr1,$00
ldi Razr0,$FF
rcall Delay
//xxxxx
ldi temp,0b00011011
out PORTC,temp

ldi temp,0b11100000
out PORTD,temp
ldi temp,0b00000011
out PORTB,temp
ldi Razr2,$00
ldi Razr1,$00
ldi Razr0,$FF
rcall Delay
//xooox
//xooox

ldi temp,0b00011100
out PORTC,temp

ldi temp,0b00100000
out PORTD,temp
ldi temp,0b00000010
out PORTB,temp
ldi Razr2,$00
ldi Razr1,$00
ldi Razr0,$FF
rcall Delay
sei
rjmp Bukva_A2
//************************************"V2"***************************
Bukva_V2:
clr temp

out PORTA,temp
out PORTB,temp
out PORTD,temp

//xooox
//xooox
//xooox
//ooooo
//ooooo
ldi temp,0b00000011
out PORTC,temp

sbi PORTB,1
ldi temp,0b00100000
out PORTD,temp
ldi Razr2,$00
ldi Razr1,$00
ldi Razr0,$FF
rcall Delay
//ooooo
//ooooo
//ooooo
//oxoxo
//ooooo
ldi temp,0b00011101
out PORTC,temp

ldi temp, 0b01000000
out PORTD,temp
ldi temp,0b00000001
out PORTB,temp
ldi Razr2,$00
ldi Razr1,$00
ldi Razr0,$FF
rcall Delay
//ooooo
//ooooo
//ooooo
//ooooo
//ooxoo
ldi temp,0b00011110
out PORTC,temp
cbi PORTB,0
ldi temp,0b10000000
out PORTD,temp
ldi Razr2,$00
ldi Razr1,$00
ldi Razr0,$FF
rcall Delay
sei
rjmp Bukva_V2
//************************************"T2"***************************
Bukva_T2:
clr temp

out PORTA,temp
out PORTB,temp
out PORTD,temp
//xxxxx
//ooooo
//ooooo
//ooooo
//ooooo
ldi temp,0b00001111
out PORTC,temp

ldi temp,0b11100000
out PORTD,temp
ldi temp,0b00000011
out PORTB,temp
ldi Razr2,$00
ldi Razr1,$00
ldi Razr0,$FF
rcall Delay
//ooooo
//ooxoo
//ooxoo
//ooxoo
//ooxoo
ldi temp,0b10000000
out PORTC,temp
ldi temp,$00
out PORTB,temp
ldi temp,0b10000000
out PORTD,temp
ldi Razr2,$00
ldi Razr1,$00
ldi Razr0,$FF
rcall Delay
sei
rjmp Bukva_T2
//************************************"I2"***************************
Bukva_I2:
clr temp

out PORTA,temp
out PORTB,temp
out PORTD,temp
//xxxxx
//ooooo
//ooooo
//ooooo
//xxxxx
ldi temp,0b00001110
out PORTC,temp

ldi temp,0b11000000
out PORTD,temp
ldi temp,0b00000001
out PORTB,temp
ldi Razr2,$00
ldi Razr1,$00
ldi Razr0,$FF
rcall Delay
//ooooo
//ooxoo
//ooxoo
//ooxoo
//ooooo
ldi temp,0b00010001
out PORTC,temp

ldi temp,0b10000000
out PORTD,temp
cbi PORTB,1
cbi PORTB,0
ldi Razr2,$00
ldi Razr1,$00
ldi Razr0,$FF
rcall Delay
sei
rjmp Bukva_I2
//************************************"A3"***************************
Bukva_A3:
clr temp

out PORTA,temp
out PORTB,temp
out PORTD,temp

//ooxoo
ldi temp,0b00001111
out PORTC,temp

ldi temp,0b00010000
out PORTB,temp

ldi Razr2,$00
ldi Razr1,$00
ldi Razr0,$FF
rcall Delay
//oxoxo
ldi temp,0b00010111
out PORTC,temp

ldi temp,0b00101000
out PORTB,temp
ldi Razr2,$00
ldi Razr1,$00
ldi Razr0,$FF
rcall Delay
//xxxxx
ldi temp,0b00011011
out PORTC,temp


ldi temp,0b01111100
out PORTB,temp
ldi Razr2,$00
ldi Razr1,$00
ldi Razr0,$FF
rcall Delay
//xooox
//xooox

ldi temp,0b00011100
out PORTC,temp

ldi temp,0b01000100
out PORTB,temp
ldi Razr2,$00
ldi Razr1,$00
ldi Razr0,$FF
rcall Delay
sei
rjmp Bukva_A3
//************************************"V3"***************************
Bukva_V3:
clr temp

out PORTA,temp
out PORTB,temp
out PORTD,temp
//xooox
//xooox
//xooox
//ooooo
//ooooo
ldi temp,0b00000011
out PORTC,temp

ldi temp,0b01000100
out PORTB,temp

ldi Razr2,$00
ldi Razr1,$00
ldi Razr0,$FF
rcall Delay
//ooooo
//ooooo
//ooooo
//oxoxo
//ooooo
ldi temp,0b00011101
out PORTC,temp

ldi temp,0b00101000
out PORTB,temp
ldi Razr2,$00
ldi Razr1,$00
ldi Razr0,$FF
rcall Delay
//ooooo
//ooooo
//ooooo
//ooooo
//ooxoo
ldi temp,0b00011110
out PORTC,temp
ldi temp,0b00010000
out PORTB,temp
ldi Razr2,$00
ldi Razr1,$00
ldi Razr0,$FF
rcall Delay

sei
rjmp Bukva_V3
//************************************"T3"***************************
Bukva_T3:
clr temp

out PORTA,temp
out PORTB,temp
out PORTD,temp
//xxxxx
//ooooo
//ooooo
//ooooo
//ooooo
ldi temp,0b00001111
out PORTC,temp

ldi temp,0b01111100
out PORTB,temp
ldi Razr2,$00
ldi Razr1,$00
ldi Razr0,$FF
rcall Delay
//ooooo
//ooxoo
//ooxoo
//ooxoo
//ooxoo
ldi temp,0b10000000
out PORTC,temp
ldi temp,0b00010000
out PORTB,temp
ldi Razr2,$00
ldi Razr1,$00
ldi Razr0,$FF
rcall Delay
sei
rjmp Bukva_T3
//************************************"I3"***************************
Bukva_I3:
clr temp

out PORTA,temp
out PORTB,temp
out PORTD,temp
//xxxxx
//ooooo
//ooooo
//ooooo
//xxxxx
ldi temp,0b00001110
out PORTC,temp


ldi temp,0b00111000
out PORTB,temp
ldi Razr2,$00
ldi Razr1,$00
ldi Razr0,$FF
rcall Delay
//ooooo
//ooxoo
//ooxoo
//ooxoo
//ooooo
ldi temp,0b00010001
out PORTC,temp

ldi temp,0b00010000
out PORTB,temp

ldi Razr2,$00
ldi Razr1,$00
ldi Razr0,$FF
rcall Delay



sei
rjmp Bukva_I3
//************************************"A4"***************************
Bukva_A4:
clr temp

out PORTA,temp
out PORTB,temp
out PORTD,temp

//ooxoo
ldi temp,0b00001111
out PORTC,temp


ldi temp,0b00000100
out PORTA,temp

ldi Razr2,$00
ldi Razr1,$00
ldi Razr0,$FF
rcall Delay
//oxoxo
ldi temp,0b00010111
out PORTC,temp

ldi temp,0b00001010
out PORTA,temp
ldi Razr2,$00
ldi Razr1,$00
ldi Razr0,$FF
rcall Delay
//xxxxx
ldi temp,0b00011011
out PORTC,temp


ldi temp,0b00001111
out PORTA,temp
ldi temp,0b10000000
out PORTB,temp
ldi Razr2,$00
ldi Razr1,$00
ldi Razr0,$FF
rcall Delay
//xooox
//xooox

ldi temp,0b00011100
out PORTC,temp

ldi temp,0b10000000
out PORTB,temp
ldi temp,0b00000001
out PORTA,temp
ldi Razr2,$00
ldi Razr1,$00
ldi Razr0,$FF
rcall Delay
sei
rjmp Bukva_A4
//************************************"V4"***************************
Bukva_V4:
clr temp

out PORTA,temp
out PORTB,temp
out PORTD,temp
//xooox
//xooox
//xooox
//ooooo
//ooooo
ldi temp,0b00000011
out PORTC,temp

ldi temp,0b00000001
out PORTA,temp

ldi temp,0b10000000
out PORTB,temp

ldi Razr2,$00
ldi Razr1,$00
ldi Razr0,$FF
rcall Delay
//ooooo
//ooooo
//ooooo
//oxoxo
//ooooo
cbi PORTB,7
ldi temp,0b00011101
out PORTC,temp

ldi temp,0b00001010
out PORTA,temp
ldi Razr2,$00
ldi Razr1,$00
ldi Razr0,$FF
rcall Delay
//ooooo
//ooooo
//ooooo
//ooooo
//ooxoo
ldi temp,0b00011110
out PORTC,temp
ldi temp,0b00000100
out PORTA,temp
ldi Razr2,$00
ldi Razr1,$00
ldi Razr0,$FF
rcall Delay
sei
rjmp Bukva_V4
//************************************"T4"***************************
Bukva_T4:
clr temp

out PORTA,temp
out PORTB,temp
out PORTD,temp
//xxxxx
//ooooo
//ooooo
//ooooo
//ooooo
ldi temp,0b00001111
out PORTC,temp

ldi temp,0b10000000
out PORTB,temp
ldi temp,0b00001111
out PORTA,temp
ldi Razr2,$00
ldi Razr1,$00
ldi Razr0,$FF
rcall Delay
//ooooo
//ooxoo
//ooxoo
//ooxoo
//ooxoo
cbi PORTB,7
ldi temp,0b10000000
out PORTC,temp
ldi temp,0b00000100
out PORTA,temp
ldi Razr2,$00
ldi Razr1,$00
ldi Razr0,$FF
rcall Delay
sei
rjmp Bukva_T4
//************************************"I4"***************************
Bukva_I4:
clr temp

out PORTA,temp
out PORTB,temp
out PORTD,temp
//xxxxx
//ooooo
//ooooo
//ooooo
//xxxxx
ldi temp,0b00001110
out PORTC,temp


ldi temp,0b00000000
out PORTB,temp
ldi temp,0b00001110
out PORTA,temp
ldi Razr2,$00
ldi Razr1,$00
ldi Razr0,$FF
rcall Delay
//ooooo
//ooxoo
//ooxoo
//ooxoo
//ooooo
cbi PORTB,7
ldi temp,0b00010001
out PORTC,temp

ldi temp,0b00000100
out PORTA,temp

ldi Razr2,$00
ldi Razr1,$00
ldi Razr0,$FF
rcall Delay

sei
rjmp Bukva_I4
//************************************"A5"***************************
Bukva_A5:
clr temp

out PORTA,temp
out PORTB,temp
out PORTD,temp

//ooxoo
ldi temp,0b00001111
out PORTC,temp


ldi temp,0b00100000
out PORTA,temp


ldi Razr2,$00
ldi Razr1,$00
ldi Razr0,$FF
rcall Delay
//oxoxo
ldi temp,0b00010111
out PORTC,temp

ldi temp,0b01010000
out PORTA,temp
ldi Razr2,$00
ldi Razr1,$00
ldi Razr0,$FF
rcall Delay
//xxxxx
ldi temp,0b00011011
out PORTC,temp


ldi temp,0b11110000
out PORTA,temp
sbi PORTC,5
ldi Razr2,$00
ldi Razr1,$00
ldi Razr0,$FF
rcall Delay
//xooox
//xooox

ldi temp,0b00011100
out PORTC,temp

ldi temp,0b00111100
out PORTC,temp
ldi temp,0b10000000
out PORTA,temp
ldi Razr2,$00
ldi Razr1,$00
ldi Razr0,$FF
rcall Delay
sei
rjmp Bukva_A5
//************************************"V5"***************************
Bukva_V5:
clr temp

out PORTA,temp
out PORTB,temp
out PORTD,temp

//xooox
//xooox
//xooox
//ooooo
//ooooo
ldi temp,0b00000011
out PORTC,temp

sbi PORTC,5
ldi temp,0b10000000
out PORTA,temp
ldi Razr2,$00
ldi Razr1,$00
ldi Razr0,$FF
rcall Delay
//ooooo
//ooooo
//ooooo
//oxoxo
//ooooo
ldi temp,0b00011101
out PORTC,temp

ldi temp,0b01010000
out PORTA,temp

ldi Razr2,$00
ldi Razr1,$00
ldi Razr0,$FF
rcall Delay
//ooooo
//ooooo
//ooooo
//ooooo
//ooxoo
ldi temp,0b00011110
out PORTC,temp

ldi temp,0b00100000
out PORTA,temp
ldi Razr2,$00
ldi Razr1,$00
ldi Razr0,$FF
rcall Delay
sei
rjmp Bukva_V5
//************************************"T5"***************************
Bukva_T5:
clr temp

out PORTA,temp
out PORTB,temp
out PORTD,temp
//xxxxx
//ooooo
//ooooo
//ooooo
//ooooo
ldi temp,0b00001111
out PORTC,temp

sbi PORTC,5
ldi temp,0b11110000
out PORTA,temp
ldi Razr2,$00
ldi Razr1,$00
ldi Razr0,$FF
rcall Delay
//ooooo
//ooxoo
//ooxoo
//ooxoo
//ooxoo
ldi temp,0b00010000
out PORTC,temp
ldi temp,0b00100000
out PORTA,temp
ldi Razr2,$00
ldi Razr1,$00
ldi Razr0,$FF
rcall Delay



sei
rjmp Bukva_T5

//************************************"I5"***************************
Bukva_I5:
clr temp

out PORTA,temp
out PORTB,temp
out PORTD,temp
//xxxxx
//ooooo
//ooooo
//ooooo
//xxxxx
ldi temp,0b00001110
out PORTC,temp


ldi temp,0b01110000
out PORTA,temp
ldi Razr2,$00
ldi Razr1,$00
ldi Razr0,$FF
rcall Delay
//ooooo
//ooxoo
//ooxoo
//ooxoo
//ooooo
ldi temp,0b00010001
out PORTC,temp

ldi temp,0b00100000
out PORTA,temp

ldi Razr2,$00
ldi Razr1,$00
ldi Razr0,$FF
rcall Delay
sei
rjmp Bukva_I5












