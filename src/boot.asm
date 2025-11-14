[org 0x7c00]
bits 16

start:
    mov ah, 0x0e ; teletype
    mov si, msg
    jmp pmsg

msg: db "loading kernel...", 0

pmsg:
    mov al, [si]
    cmp al, 0
    je loadk
    int 0x10
    inc si
    jmp pmsg

loadk:
    mov ax, 0
    mov es, ax
    mov bx, 0x7e00

    mov ah, 0x02 ; read sector
    mov al, 1 ; num sectors
    mov ch, 0 ; cylinder
    mov dh, 0 ; head
    mov cl, 2 ; sector

    int 0x13
    jc hang
    jmp 0x0000:0x7e00

hang:
    jmp hang

times 510-($-$$) db 0
dw 0xaa55