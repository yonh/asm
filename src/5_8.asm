;;; 将内存ffff:0~ffff:b的值复制到内存0200:0~0200:b

assume cs:code
code segment
	mov bx, 0
	mov cx, 12

	s: mov ax, 0ffffh
	mov ds, ax
	mov dl, [bx]		;将ffff:[bx]的值送入dl

	mov ax, 0020h
	mov ds, ax
	mov [bx], dl		;将ffff[bx]的值通过dl送入0200:[bx]

	inc bx
	loop s

	mov ax, 4c00h
	int 21h
code ends
end
