#include "idt.h"

struct idt_entry idt[256];
struct idt_ptr idtp;

extern void idt_load(unsigned int);
extern void irq1_handle();

void idt_set_gate(unsigned char num, unsigned int base, unsigned short sel, unsigned char flags)
{
    idt[num].base_low = base & 0xffff;
    idt[num].base_high = (base >> 16) & 0xffff;
    idt[num].sel = sel;
    idt[num].always0 = 0;
    idt[num].flags = flags;
}

void idt_install()
{
    idtp.limit = (sizeof(struct idt_entry) * 256) - 1;
    idtp.base = (unsigned int)&idt;

    for (int i = 0; i < 256; i++)
    {
        idt_set_gate(i, 0, 0, 0);
    }

    outb(0x20, 0x11); // pic1 init
    outb(0xa0, 0x11); // pic2 init
    outb(0x21, 0x20); // pic1 offset 32
    outb(0xA1, 0x28); // pic2 offset 40
    outb(0x21, 0x04); // pic2 at irq2
    outb(0xA1, 0x02); // pic2 cascade
    outb(0x21, 0x01); // pic1 8086
    outb(0xA1, 0x01); // pic2 8086
    outb(0x21, 0x00); // enable pic1 irqs
    outb(0xA1, 0x00); // enable pic2 irqs

    idt_set_gate(33, (unsigned int)irq1_handle, 0x08, 0x8e);

    idt_load((unsigned int)&idtp);
}

void key_handle()
{
    unsigned char code = inb(0x60);
    outb(0x20, 0x20);
    key_callback(code);
}