SRC_DIR = src
BUILD_DIR = build

ASM = nasm
CC = gcc
LD = ld
OBJCOPY = objcopy
QEMU = qemu-system-i386

ASM_FLAGS = -f win32
GCC_FLAGS = -ffreestanding -m32 -c
LD_FLAGS = -m i386pe -Ttext 0x1000

all: $(BUILD_DIR)/os-image.bin

run: $(BUILD_DIR)/os-image.bin
	$(QEMU) -drive format=raw,file=$<

$(BUILD_DIR)/os-image.bin: $(BUILD_DIR)/boot.bin $(BUILD_DIR)/kernel.bin
	cat $^ > $@

$(BUILD_DIR)/kernel.bin: $(BUILD_DIR)/kernel.tmp
	$(OBJCOPY) -O binary $< $@

$(BUILD_DIR)/kernel.tmp: $(BUILD_DIR)/entry.o $(BUILD_DIR)/kernel.o
	$(LD) $(LD_FLAGS) -o $@ $^

$(BUILD_DIR)/boot.bin: $(SRC_DIR)/boot.asm
	@mkdir -p $(BUILD_DIR)
	$(ASM) -f bin $< -o $@

$(BUILD_DIR)/entry.o: $(SRC_DIR)/entry.asm
	@mkdir -p $(BUILD_DIR)
	$(ASM) $(ASM_FLAGS) $< -o $@

$(BUILD_DIR)/kernel.o: $(SRC_DIR)/kernel.c
	@mkdir -p $(BUILD_DIR)
	$(CC) $(GCC_FLAGS) $< -o $@

clean:
	rm -rf $(BUILD_DIR)