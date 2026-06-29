section .multiboot
align 4
    dd 0x1BADB002
    dd 0x00
    dd -(0x1BADB002)

section .text
global _start
extern kmain

_start:
    mov esp, stack_top
    call kmain
    hlt

section .bss
align 16
stack_bottom:
    resb 16384
stack_top: