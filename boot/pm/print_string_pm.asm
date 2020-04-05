[bits 32]

; Define some constants
VIDEO_MEMORY equ 0xb8000
WHITE_ON_BLACK equ 0x0f

; prints a null-terminated string pointed to by EDX
print_string_pm:
  pusha
  mov edx, VIDEO_MEMORY ; Set edx to the start of VIDEO_MEMORY

print_string_pm_loop:
  mov al, [ebx] ; store the char content at ebx to al
  mov ah, WHITE_ON_BLACK ; store the attribute in ah

  cmp al, 0 ; if al == 0 (NULL) end of string
  je print_string_pm_done

  mov [edx], ax ; store the char and attribute at current character cell

  add ebx, 1
  add edx, 2 ; move to next char cell in VIDEO_MEMORY

  jmp print_string_pm_loop

print_string_pm_done:
  popa
  ret