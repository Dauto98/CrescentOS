# CrescentOS

A sample OS created from the book [os-dev](https://www.cs.bham.ac.uk/~exr/lectures/opsys/10_11/lectures/os-dev.pdf)

## Getting Started
### Prerequisites

Install CPU emulator QEmu
```
sudo apt install qemu
```

### Running the os
```
make clean
make
qemu-system-i386 -drive file=os-image,if=floppy,index=0,media=disk,format=raw
```