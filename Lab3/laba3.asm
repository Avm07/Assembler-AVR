

.include "m8515def.inc"
.def stack = r20
.def temp = r21
.def temp2 = r25
.def Flag = r19
.def Razr2 = r22
.def Razr1 = r23
.def Razr0 = r24
;=====================================
rjmp RESET     ;Reset Handle
rjmp TIMCOPMA1 ;Timer1 compare Interrupt Vector Address

.org	4
;===============Timer1 compare Interrupt==================
TIMCOPMA1:
;********************
in temp,OCR1AL
clr temp
in temp,OCR1AH
dec temp
out OCR1AH,temp
clr temp
out OCR1AL,temp
;************************
ldi temp2,$00
out TCNT1H,temp2
out TCNT1L,temp2
cpi flag,$02
breq case_1
cpi flag,$01
breq case_2
reti
case_1:
rjmp reverse_vpravo
case_2:
rjmp reverse_vlevo
;case_3:
;reti
;****************
reverse_vlevo: ;<что-то делаем, если flag больше или равен 
in temp,PORTB
lsl temp
out PORTB,temp
reti

reverse_vpravo: ;<что-то делаем, если flag меньше
in temp,PORTB
lsr temp
out PORTB,temp
reti

;=====================Ќј„јЋ№Ќјя ”—“ј¬Ќќ¬ ј==========
RESET:
clr temp2
clr stack
clr Flag

ldi stack,low(RAMEND) 
out SPL,stack
ldi stack,high(RAMEND)
out SPH,stack

ldi temp,0xFF 
out DDRB,temp 
ldi temp,0b00010000
out PORTB,temp


;======================ј “»¬ј÷»я “\—1===============
ldi temp,(1<<OCIE1A)
out TIMSK,temp
ldi temp,$60    ;?????? ??????? OCR1A
out OCR1AH,temp
ldi temp,$FF
out OCR1AL,temp
ldi temp,(0<<WGM13 | 0<<WGM12 | 1<< CS11 | 1<<CS10)
out TCCR1B,temp



sei

main:
in temp,PIND

rcall proverka

in temp,PORTB
cpi temp,$00
breq looser
rjmp main

;=======================процедура проверка кнопки=============
proverka:  
;*************
cpi temp,0b11111110
breq cont_1
cpi temp,0b01111111
breq cont_2
ret
cont_1:
ldi flag,$01
ret
cont_2:
ldi flag,$02
ret


;*************

;cpi temp,0b11111110

;brlo else
;ldi flag,$01 ;<что-то делаем, если temp больше или равен 0b11111110
;rjmp proverka ;обратно
;else:
;ldi flag,$00   ;иначе
;ret ;выход из процедуры

;=======================пройгрыш===================
Looser:
cli
ldi temp,(0<<WGM13 | 0<<WGM12 | 0<< CS11 | 0<<CS10)
out TCCR1B,temp
in temp,PortB
ldi Razr2,$06
ldi Razr1,$1A
ldi Razr0,$80
rcall Delay
com temp
out PortB,temp
rjmp Looser

Delay: ;????????? ????????
subi Razr0,1
sbci Razr1,0
sbci Razr2,0
brcc delay
ret ;??????? ?? ?????????
