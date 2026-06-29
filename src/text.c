#include "text.h"

U16* buffer = (U16*)0xb8000;
static U32 row = 0;
static U32 col = 0;
static U8 cul = 0x8f;

void txt_Write(const char* text)
{
    for (int i = 0; text[i]; i++)
    {
        if (text[i] == '\n')
        {
            col = 0;
            return;
        }

        buffer[col] = (U16)text[i] | ((U16)cul << 8);
        col++;
    }
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
}

void txt_Colour(U8 text, U8 bg)
{
    cul = text | (bg << 4);
}