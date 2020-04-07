[bits 16]
; Switch to protected mode
switch_to_pm:
  cli ; disable interrupt

  lgdt [gdt_descriptor] ; load our gdt, which defind protected mode segment

  mov eax, cr0 ; to make the switch to protected mode, we set the first bit
  or eax, 0x1 ; of cr0, a control register, to 1
  mov cr0, eax

  jmp CODE_SEG:init_pm ; Make a far jump (i.e. to a new segment) to our 32-bit
                       ; code. This also forces the CPU to flush its cache of
                       ; pre-fetched and real-mode decoded instructions, which
                       ; can cause problems
  [bits 32]
  ; Initialize registers and stack once in PM
init_pm:
  mov ax, DATA_SEG ; now in PM, our old segment are meaningless
  mov ds, ax       ; so we point our segment register to the data selector we
  mov ss, ax       ; defined in our gdt
  mov es, ax
  mov fs, ax
  mov gs, ax

  mov ebp, 0x00090000 ; update stack position
  mov esp, ebp

  call BEGIN_PM ; Finally call some well known label