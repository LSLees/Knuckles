[bits 32]
[global idt_load]
[global irq1_handle]
[extern key_handle]

idt_load:
    mov eax, [esp + 4]
    lidt [eax]
    sti
    ret

irq1_handle:
    pusha
    call key_handle
    popa
    iret