;;; 第10章 监测点10.5.1 p195
;;; 
stack segment
	dw 8 dup (0)
stack ends

assume cs:code

code segment
start:
	mov ax, stack
	mov ss, ax
	mov sp, 10h
	mov ds, ax
	mov ax, 0
	call word ptr ds:[0eh]
	inc ax
	inc ax
	inc ax
	mov ax, 4c00h
	int 21h

code ends

end start
