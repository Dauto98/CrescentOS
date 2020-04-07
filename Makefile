# Automatically generate lists of sources using wildcards.
C_SOURCES = $(wildcard kernel/*.c drivers/*.c)
HEADERS = $(wildcard kernel/*.h drivers/*.h)

# TODO: Make sources dep on all header files

# Coverts the *.c filenames to *.o to give a list of object files to build
OBJ = $(C_SOURCES:.c=.o)

# Default build target
all: os-image

# Run Qemu to simulate booting of our code
run: all
	qemu-i386

# This is the actual disk image that the computer loads
# which is the combination of our compiled bootsector and kernel
os-image: boot/boot_sect.bin kernel.bin
	cat $^ > os-image

# This builds the binary of our kernel from 2 object files:
#  - the kernel-entry, which jumps to main() in our kernel
#  - the compiled C kernel
kernel.bin: kernel/kernel_entry.o ${OBJ}
	ld -o $@ -Ttext 0x1000 $^ --oformat binary -m elf_i386

# Generic rule for compiling C code to and object file
# For simplicity, C files depend on all header files
%.o: %.c ${HEADERS}
	gcc -ffreestanding -c $< -o $@ -m32

# Assemble the kernel_entry
%.o: %.asm
	nasm $< -f elf -o $@

%.bin: %.asm
	nasm $< -f bin -I '../../16bit' -o $@

clean:
	rm -rf *.bin *.dis *.o os-image
	rm -rf kernel/*.o boot/*.bin drivers/*.o