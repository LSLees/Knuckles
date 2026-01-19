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
    jmp 0x08:entry

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

entry:
    mov ax, 0x10
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    mov ebp, 0x90000
    mov esp, ebp
    mov eax, 0

    call clear_vga
    mov ebx, msg_boot
    mov eax, 0xb80a4
    call print32
    mov ebx, msg_entry
    mov eax, 0xb81e4
    call print32
    mov bx, 274
    call set_caret
    call poll_key
    call clear_vga
    jmp $

clear_vga:
    pusha
    mov ax, 0x0f20
    mov ecx, 2000
    mov edi, 0xb8000
    rep stosw
    popa
    ret

print32:
    pusha
    mov edx, eax
    mov ah, 0x0f

.loop:
    mov al, [ebx]
    cmp al, 0
    je .done
    mov [edx], ax
    add ebx, 1
    add edx, 2
    jmp .loop

.done:
    popa
    ret

poll_key:
    in al, 0x64
    test al, 1
    jz poll_key
    in al, 0x60
    ret

set_caret:
pusha
    mov dx, 0x3d4
    mov al, 0x0e    
    out dx, al

    mov dx, 0x3d5
    mov al, bh
    out dx, al

    mov dx, 0x3d4
    mov al, 0x0f
    out dx, al

    mov dx, 0x3d5
    mov al, bl
    out dx, al

    popa
    ret

msg_boot: db "Knuckles", 0
msg_entry: db "Select an entry point to boot...", 0

times 1024-($-$$) db 0