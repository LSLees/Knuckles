[BITS 16]
[ORG 0x7c00]

start:
    mov bp, 0x9000
    mov sp, bp

    mov ah, 0x02 ; bios read sector
    ; mov dl, 0 ; drive number
    mov dh, 0 ; head
    mov ch, 0 ; cylinder
    mov al, 1 ; sector count
    mov cl, 2 ; sector
    mov bx, 0x7e00
    int 0x13

    jmp enable_prot

times 510-($-$$) db 0
dw 0xaa55

; sector 2

enable_prot:
    cli
    mov ax, gdt1 - gdt0 - 1
    sub esp, 6
    mov [esp], ax
    mov eax, gdt0
    mov [esp+2], eax
    lgdt [esp]
    mov eax, cr0
    or eax, 1
    mov cr0, eax
    jmp 0x08:init_pm

gdt0:
    dd 0x0
    dd 0x0
    dw 0xffff
    dw 0x0
    db 0x0
    db 10011010b
    db 11001111b
    db 0x0
    dw 0xffff
    dw 0x0
    db 0x0
    db 10010010b
    db 11001111b
    db 0x0
gdt1:

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

    mov eax, 0
    jmp BEGIN_PM

BEGIN_PM:
    mov ebx, 0xb8000
    mov byte [ebx+eax], ' '
    add eax, 1
    mov byte [ebx+eax], 0x0f
    add eax, 1
    cmp eax, 10000
    je knuckles
    jmp BEGIN_PM

knuckles:
    mov ebx, 0xb8526
    mov byte [ebx], 'K'
    mov byte [ebx+1], 0x0f
    mov byte [ebx+2], 'n'
    mov byte [ebx+3], 0x0f
    mov byte [ebx+4], 'u'
    mov byte [ebx+5], 0x0f
    mov byte [ebx+6], 'c'
    mov byte [ebx+7], 0x0f
    mov byte [ebx+8], 'k'
    mov byte [ebx+9], 0x0f
    mov byte [ebx+10], 'l'
    mov byte [ebx+11], 0x0f
    mov byte [ebx+12], 'e'
    mov byte [ebx+13], 0x0f
    mov byte [ebx+14], 's'
    mov byte [ebx+15], 0x0f

    jmp $

times 1024-($-$$) db 0