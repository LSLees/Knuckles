[org 0x7e00]
bits 16

start:
    mov ah, 0x0e
    mov al, 'p'
    int 0x10
    
hang:
    jmp hang