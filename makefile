CC      = i686-elf-gcc
AS      = nasm
LD      = i686-elf-gcc
QEMU    = qemu-system-i386

CFLAGS  = -ffreestanding -O2 -Wall -Wextra -std=gnu99 -Isrc
ASFLAGS = -f elf32
LDFLAGS = -ffreestanding -O2 -nostdlib -lgcc

TARGET  = bin/kernel.elf
OBJS    = bin/boot.o bin/kernel.o bin/text.o

.PHONY: all run clean

all: bin $(TARGET)

bin:
	mkdir -p bin

$(TARGET): $(OBJS) linker.ld
	$(LD) -T linker.ld -o $@ $(LDFLAGS) $(OBJS)

bin/boot.o: boot.asm
	$(AS) $(ASFLAGS) $< -o $@

bin/kernel.o: kernel.c
	$(CC) $(CFLAGS) -c $< -o $@

bin/text.o: src/text.c
	$(CC) $(CFLAGS) -c $< -o $@

run: $(TARGET)
	$(QEMU) -kernel $(TARGET)

clean:
	rm -rf bin
