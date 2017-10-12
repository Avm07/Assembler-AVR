//Pomenyat mestami stroki i stolbci v matrice 5x5, predvaritelno zapisanoy v EEPROM po strokam,
//Promegutochnie operacii sdelat v SRAM i zapisat result v EEPROM


.include "m8515def.inc" //---podkluchaem ATMega8515
ldi ZH,$00 ; Adresa EEPROM
ldi ZL,$00

ldi r29,$00 ; Adresa SRAM
ldi r28,$60

clr r25
ldi r24,0

//Chtenie EEPROM



ReadEEP: 
sbic EECR,EEWE ;???????? ??????? ????? ??????
rjmp ReadEEP
out EEARH,ZH ;??????? ??????
out EEARL,ZL ;??????? ??????
sbi EECR,EERE ;??? ??????
in R25,EEDR ;??????
st Y+,R25 
subi ZL,-5
inc r24
cpi r24,5
breq main
rjmp ReadEEP  




main:
clr r24
ldi r24,0
subi ZL,24
cpi r28,$79
breq main2
rjmp ReadEEP

main2:

clr r25
clr r30
ldi r30,$00
clr r28
ldi r28,$60

WriteEEP: 
sbic EECR,EEWE 
rjmp WriteEEP 
out EEARH,ZH 
out EEARL,ZL 
ld  R25,Y+
out EEDR,R25 
sbi EECR,EEMWE 
sbi EECR,EEWE 

inc ZL
cpi r25,25
breq end
rjmp WriteEEP 



end:
rjmp end
