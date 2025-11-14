# Variables
NASM = nasm
NASM_FLAGS = -f bin
QEMU = qemu-system-x86_64
QEMU_FLAGS = -drive format=raw

# Directories
SRC_DIR = src
BUILD_DIR = build

# Source Files
BOOT_SRC = $(SRC_DIR)/boot.asm
KERNEL_SRC = $(SRC_DIR)/kernel.asm

# Output Files
BOOT_BIN = $(BUILD_DIR)/boot.bin
KERNEL_BIN = $(BUILD_DIR)/kernel.bin
OS_IMG = $(BUILD_DIR)/os.img

# Phony Targets
.PHONY: all run clean

# Main Targets

# Default target
all: $(OS_IMG)

run: all
	$(QEMU) $(QEMU_FLAGS),file=$(OS_IMG)

$(OS_IMG): $(BOOT_BIN) $(KERNEL_BIN)
	@mkdir -p $(@D)
	cat $(BOOT_BIN) $(KERNEL_BIN) > $(OS_IMG)

$(BOOT_BIN): $(BOOT_SRC)
	@mkdir -p $(@D)
	$(NASM) $(NASM_FLAGS) $(BOOT_SRC) -o $(BOOT_BIN)

$(KERNEL_BIN): $(KERNEL_SRC)
	@mkdir -p $(@D)
	$(NASM) $(NASM_FLAGS) $(KERNEL_SRC) -o $(KERNEL_BIN)

clean:
	rm -rf $(BUILD_DIR)