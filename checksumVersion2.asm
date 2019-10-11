%include "io.inc"

section .data

    IpHeader db 45h,00h,00h,28h,00h,00h,40h,00h,40h,06h,0b9h,11h,0c0h,0a8h,00h,01h,0c0h,0a8h,00h,06dh
    tamano db $-IpHeader
    DescartarPaquete db 0

section .text
global CMAIN
CMAIN:
    mov ebp, esp; for correct debugging
   
   xor eax,eax
   xor ebx,ebx
   xor ecx,ecx
   
   ; Encontrar tamaño
   
   mov al,[IpHeader]
   mov bl,[IpHeader]
   
   and al,00001111b
   and bl,11110000b
   ror bl,4h
   imul ax,bx
   mov cx,ax ;Tamaño del checksum
   shr ecx,1 ;Para desplazar el 20 en binario a la derecha y me quede en 10 1010 -> 0101
   mov esi,0
   mov ebx,0
   
L1:mov ax,[IpHeader+esi]  
   xchg al,ah
   add bx,ax
   adc bx,0
   add esi,2
   
   loop L1
   
   Not bx
   cmp bx,0
   jnz L2
   
   mov BYTE [DescartarPaquete],"F"
   jmp L3
L2:mov BYTE [DescartarPaquete],"T"   
   
   
L3:xor eax,eax
   ret