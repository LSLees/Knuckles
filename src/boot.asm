[BITS 16]
[ORG 0x7c00]

start:
    mov bp, 0x9000
    mov sp, bp

    mov ah, 0x2 ; bios read
    ; mov dl, 0 ; drive
    mov dh, 0x0 ; head
    mov ch, 0x0 ; cylinder
    mov al, 0x1 ; num sectors
    mov cl, 0x2 ; sector
    mov bx, 0x7e00
    int 0x13

    jmp enter_protected_mode

times 510-($-$$) db 0

dw 0xaa55

; sector 2

enter_protected_mode:
    jmp $
    cli
    lgdt [gdt_descriptor]
    mov eax, cr0
    or eax, 1
    mov cr0, eax
    jmp 0x08:init_pm

[BITS 32]
init_pm:
    mov ax, 0x10
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    mov ebp, 0x90000
    mov esp, ebp

    jmp BEGIN_PM

BEGIN_PM:
    mov ebx, 0xb8000
    mov byte [ebx], 'P'
    mov byte [ebx+1], 0x0f
    mov byte [ebx+2], 'M'
    mov byte [ebx+3], 0x0f

    jmp $

gdt_start:

gdt_null:
    dd 0x0
    dd 0x0

gdt_main:
    dw 0xffff ; limit (0-15)
    dw 0x0 ; base (0-15)
    dw 0x0 ; base (16-23)
    db 10011010b ; type flags
    db 11001111b ; limit flags (16-19)
    db 0x0 ; base (24-31)

gdt_data:
    dw 0xffff ; limit (0-15)
    dw 0x0 ; base (0-15)
    dw 0x0 ; base (16-23)
    db 10010010b ; type flags
    db 11001111b ; limit flags (16-19)
    db 0x0 ; base (24-31)

gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1 ; sizeof gdt
    dd gdt_start

times 1024-($-$$) db 0