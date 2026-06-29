#pragma once
#include "common.h"

#define COLS 80
#define ROWS 25

void txt_Write(const char* text);
void txt_Colour(U8 text, U8 bg);
void txt_Clear();