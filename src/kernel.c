volatile char* vga = (volatile char*) 0xb8000;
int cursor = 0;

void outb(unsigned short port, unsigned char val)
{
    asm volatile ("outb %0, %1" : : "a"(val), "Nd"(port));
}

void update_cursor()
{
    outb(0x3d4, 14);
    outb(0x3d5, (cursor >> 8));
    outb(0x3d4, 15);
    outb(0x3d5, (cursor & 0xff));
}

void printS(const char* string)
{
    while(*string != '\0')
    {
        vga[cursor * 2] = *string;
        vga[cursor * 2 + 1] = 0x0f;
        cursor++;
        update_cursor();
        string++;
    }
}

void clearVGA()
{
    for (int i = 0; i < 2000; i++)
    {
        printC(' ');
    }
    cursor = 0;
}

void kmain()
{
    clearVGA();
    char string[] = "Loading...";
    printS(string);

    while(1)
    {
    }
}