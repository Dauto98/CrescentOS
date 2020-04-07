;;
; Function prints an ascii character to the screen
; Param:
;     bx : the ascii code
;;

print_string:
  pusha

  mov ah, 0x0e ; select a function
  mov cx, 0

print_string_loop:
  cmp BYTE [bx], 0
  je print_string_done

  mov al, [bx] ; char to write
  int 0x10 ; Video service interrupt; interrupt is like a set of fucntion

  add bx, 1

  jmp print_string_loop

print_string_done:
  mov al, 0x0a
  int 0x10

  mov al, 0x0d
  int 0x10

  popa
  ret