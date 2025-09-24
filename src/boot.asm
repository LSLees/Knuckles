[BITS 16]
[ORG 0x7c00]


start:
   cli ; clear interrupts
   mov ax, 0x00
   mov ds, ax
   mov es, ax
   mov es, ax
   mov ss, ax
   mov sp, 0x7c00
   sti ; enable interrupts
   mov si, msg


print:
   lodsb ; loads byte at ds:su to al reg and increments si
   cmp al, 0
   je done
   mov ah, 0x0e
   int 0x10
   jmp print


done:
   cli
   hlt


msg: db 'hello world!' , 0


times 510 - ($ - $$) db 0


dw 0xaa55