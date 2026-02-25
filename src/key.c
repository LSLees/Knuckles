#include "key.h"
#include "core/idt.h"

const char scan_ascii[] =
{
    0,  27, '1', '2', '3', '4', '5', '6', '7', '8', '9', '0', '-', '=', '\b',
    '\t', 'q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p', '[', ']', '\n',
    0, // control
    'a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l', ';', '\'', '`',
    0, // left shift
    '\\', 'z', 'x', 'c', 'v', 'b', 'n', 'm', ',', '.', '/', 
    0, // right shift
    '*',
    0,   // alt
    ' ',
};

extern void print(const char* string);

void key_callback(unsigned char code)
{
    if (code & 0x80) return;

    if (code < sizeof(scan_ascii))
    {
        char c = scan_ascii[code];

        if(c != 0)
        {
            char str[2] = {c, '\0'};
            print(str);
        }
    }
}