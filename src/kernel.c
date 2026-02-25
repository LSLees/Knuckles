#include "core/idt.h"

volatile char* vga = (volatile char*) 0xb8000;
int cursor = 0;

void outb(unsigned short port, unsigned char val)
{
    asm volatile ("outb %0, %1" : : "a"(val), "Nd"(port));
}

unsigned char inb(unsigned short port)
{
    unsigned char ret;
    asm volatile ("inb %1, %0" : "=a"(ret) : "Nd"(port));
    return ret;
}

void cursor_update()
{
    outb(0x3d4, 14);
    outb(0x3d5, (cursor >> 8));
    outb(0x3d4, 15);
    outb(0x3d5, (cursor & 0xff));
}

void scroll_check()
{
    if (cursor >= 2000)
    {
        for (int i = 0; i < 24 * 80; i++)
        {
            vga[i * 2] = vga[(i + 80) * 2];
        }

        for (int i = 24 * 80; i < 2000; i++)
        {
            vga[i * 2] = ' ';
            vga[i * 2 + 1] = 0x0f;
        }

        cursor = 24 * 80;
    }
}

void print(const char* string)
{
    while(*string != '\0')
    {
        if (*string == '\n')
        {
            cursor = ((cursor / 80) + 1) * 80;
        }
        else
        {
            vga[cursor * 2] = *string;
            vga[cursor * 2 + 1] = 0x0f;
            cursor++;
        }

        scroll_check();
        cursor_update();
        string++;
    }
}

void vga_clear()
{
    for (int i = 0; i < 2000; i++)
    {
        vga[i * 2] = ' ';
        vga[i * 2 + 1] = 0x0f;
    }

    cursor = 0;
    cursor_update();
}

void kmain()
{
    vga_clear();

    const char* string = "setting hardware descriptors...";
    print(string);

    idt_install();

    print("enabled!");

    while(1)
    {
        asm volatile("hlt");
    }
}