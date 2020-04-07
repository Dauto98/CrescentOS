; A boot sector that boots a C kernel in 32-bit protecvted mode
; start puting the code below from address 0x7c00, all relative address are relative to This
; from 0x0 to 0x7c00 contain bios interrupt vector
[org 0x7c00]
; This is the memory offset to which we will load our kernel
; it is 0x1000 because we tell the linker to put our C code from 0x1000 address
KERNEL_OFFSET equ 0x1000
mov [BOOT_DRIVE], dl ; BIOS stores our boot drive in DL

mov bp, 0x9000 ; Set up the stack
mov sp, bp

mov bx, MSG_REAL_MODE ; Announce that we are starting booting from 160bit real mode
call print_string

call load_kernel  ; Load our kernel

call switch_to_pm ; Switch to 32-bit protected mode, from which we will not return

jmp $

; Include utility routines
%include "boot/print/print_string.asm"
%include "boot/print/print_hex.asm"
%include "boot/disk/disk_load.asm"
%include "boot/pm/gdt.asm"
%include "boot/pm/print_string_pm.asm"
%include "boot/pm/switch_to_pm.asm"

[bits 16]

; load kernel
load_kernel:
  mov bx, MSG_LOAD_KERNEL
  call print_string

  mov bx, KERNEL_OFFSET
  mov dh, 15
  mov dl, [BOOT_DRIVE]
  call disk_load

  ret

[bits 32]
; This is where we arrive after switching to and initialising protected mode
BEGIN_PM:
  mov ebx, MSG_PROT_MODE
  call print_string_pm

  call KERNEL_OFFSET ; jump to the start of our loaded kernel

  jmp $

; Global variables
BOOT_DRIVE db 0
MSG_REAL_MODE db "Started in 16-bit Real Mode", 0
MSG_PROT_MODE db "Successfully landed in 32-bit Protected Mode", 0
MSG_LOAD_KERNEL db "Loading kernel into memory", 0

; Bootsector padding
times 510-($-$$) db 0
dw 0xaa55