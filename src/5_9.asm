;;; 将内存ffff:0~ffff:b的值复制到内存0200:0~0200:b
;;; 优化5_8

assume cs:code
code segment
	mov bx, 0
	mov cx, 12

	mov ax, 0ffffh
	mov ds, ax			; ds = 0ffffh
	mov ax, 0200h
	mov es, ax			; es = 0200h
	
	s: mov dl, [bx]
	mov es:[bx], dl		; 将0ffff:[bx]的值复制到0200:[bx]
	
	inc bx
	loop s

	mov ax, 4c00h
	int 21h
code ends
end
