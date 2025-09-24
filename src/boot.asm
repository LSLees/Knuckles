[BITS 16]
[ORG 0x7c00]

CODE_OFFSET equ 0x8
DATA_OFFSET equ 0x10

start:
   cli
   mov ax, 0x00
   mov ds, ax ; data segment
   mov es, ax ; extra segment
   mov ss, ax ; stack segment
   mov sp, 0x7c00
   sti ; enable interrupts

load_PM:
	cli
	lgdt [gdt_descriptor]
	mov eax, cr0
	or al, 1
	mov cr0, eax
	jmp CODE_OFFSET:PModeMain


; global descriptor table

gdt_start:
   dd 0x0
   dd 0x0

   ; code segment
   dw 0xffff ; limit
   dw 0x0000 ; base
   db 0x00 ; base
	db 10011010b ; access
	db 11001111b ; flags
	db 0x00 ; base

	; data segment
   dw 0xffff ; limit
   dw 0x0000 ; base
   db 0x00 ; base
	db 10010010b ; access
	db 11001111b ; flags
	db 0x00 ; base

gdt_end:

gdt_descriptor:
	dw gdt_end - gdt_start - 1
	dd gdt_start

PModeMain:
	mov ax, DATA_OFFSET
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov ss, ax
	mov gs, ax
	mov ebp, 0x9c00
	mov esp, ebp

	in al, 0x92
	or al, 2
	out 0x92, al

	jmp $

times 510 - ($ - $$) db 0 ; fill upto 0x510