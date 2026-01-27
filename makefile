CC = gcc
LD = ld
NASM = nasm

SRC_DIR = src
BUILD_DIR = build
INT_DIR = $(BUILD_DIR)/tmp

CFLAGS = -m32 -ffreestanding -c -fno-pie -fno-stack-protector
LDFLAGS = -m i386pe -T linker.ld

BOOT_SRC = $(SRC_DIR)/boot.asm
ENTRY_SRC = $(SRC_DIR)/entry.asm
KERNEL_SRC = $(SRC_DIR)/kernel.c

BOOT_BIN = $(INT_DIR)/boot.bin
ENTRY_OBJ = $(INT_DIR)/entry.o
KERNEL_OBJ = $(INT_DIR)/kernel.o
KERNEL_ELF = $(INT_DIR)/kernel.elf
KERNEL_BIN = $(INT_DIR)/kernel.bin

OS_IMAGE = $(BUILD_DIR)/osimg.bin

all: $(OS_IMAGE)

$(INT_DIR):
	mkdir -p $(INT_DIR)

$(BOOT_BIN): $(BOOT_SRC) | $(INT_DIR)
	$(NASM) -f bin $< -o $@

$(ENTRY_OBJ): $(ENTRY_SRC) | $(INT_DIR)
	$(NASM) -f elf32 $< -o $@

$(KERNEL_OBJ): $(KERNEL_SRC) | $(INT_DIR)
	$(CC) $(CFLAGS) $< -o $@

$(KERNEL_ELF): $(ENTRY_OBJ) $(KERNEL_OBJ)
	$(LD) $(LDFLAGS) -o $@ $^

$(KERNEL_BIN): $(KERNEL_ELF)
	objcopy -O binary $< $@

$(OS_IMAGE): $(BOOT_BIN) $(KERNEL_BIN)
	cat $^ > $@

run: $(OS_IMAGE)
	qemu-system-i386 -drive format=raw,file=$(OS_IMAGE)

clean:
	rm -rf $(BUILD_DIR)