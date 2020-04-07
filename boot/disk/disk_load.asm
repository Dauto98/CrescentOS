;;
; This function read dh sector from the dl drive, cylinder 0, head 0, starting from the second sector
; Params:
;     dh  :  the number of sectors requested
;     dl  :  the drive id
;     bx  :  the memory destination to write read data to
;;

disk_load:
  pusha

  push dx  ; save dx

  mov ah, 0x02
  mov al, dh ; read dh sectors
  mov ch, 0x00 ; select cylinder 0
  mov dh, 0x00 ; select head 0
  mov cl, 0x02 ; start reading from second sector
  int 0x13

  jc disk_error

  pop dx
  cmp al, dh ; if al (sector read) != dh (sector expected) -> error
  jne sector_error
  popa
  ret

disk_error:
  mov bx, DISK_ERROR_MSG
  call print_string
  mov dl, ah
  call print_hex
  jmp $

sector_error:
  mov bx, SECTOR_ERROR_MSG
  call print_string
  jmp $

; variable
DISK_ERROR_MSG db "Disk load error!", 0
SECTOR_ERROR_MSG db "Sector load error!", 0