#include "text.h"

static U16* buffer = (U16*)0xb8000;
static U32 row = 0;
static U32 col = 0;
static U8 cul = 0x8f;

static void updateCursor()
{
    __asm__ volatile ("outb %0, %1" : : "a"((U8)0x0F), "Nd"(0x3D4));
    __asm__ volatile ("outb %0, %1" : : "a"((U8)((row * COLS + col) & 0xFF)), "Nd"(0x3D5));
    __asm__ volatile ("outb %0, %1" : : "a"((U8)0x0E), "Nd"(0x3D4));
    __asm__ volatile ("outb %0, %1" : : "a"((U8)(((row * COLS + col) >> 8) & 0xFF)), "Nd"(0x3D5));
}

void txt_Write(const char* text)
{
    for (int i = 0; text[i]; i++)
    {
        if (text[i] == '\n')
        {
            col = 0;
            row++;
            continue;
        }

        buffer[row * COLS + col] = (U16)text[i] | ((U16)cul << 8);
        col++;

        if (col >= COLS)
        {
            col = 0;
            row = row + 1 > 24 ? 0 : row + 1;
        }
    }

    updateCursor();
}

void txt_Clear()
{
    for (U32 r = 0; r < ROWS; r++)
    {
        for (U32 c = 0; c < COLS; c++)
        {
            buffer[r * COLS + c] = (U16)' ' | ((U16)cul << 8);
        }
    }

    row = 0;
    col = 0;
    updateCursor();
}

void txt_Colour(U8 text, U8 bg)
{
    cul = text | (bg << 4);
}