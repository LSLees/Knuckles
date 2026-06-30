#include "common.h"
#include "text.h"

void kmain()
{
    txt_Colour(0xf, 8);
    txt_Clear();
    txt_Write("Knuckles!");

    while (1) {}
}