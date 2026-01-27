[bits 32]
[global start]
[extern _kmain]

start:
    call _kmain
    jmp $