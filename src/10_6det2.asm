;;; 第10章 监测点10.5.2 p195
;;; 程序最后ax和bx的值是多少
;;; ax = 1, bx = 0
stack segment
	dw 8 dup (0)
stack ends

assume cs:code

code segment
start:
	mov ax, stack
	mov ss, ax
	mov sp, 10h
	mov word ptr ss:[0], offset s
	mov ss:[2], cs
	call dword ptr ss:[0]
	nop

s:	mov ax, offset s
	sub ax, ss:[0ch]
	mov bx, cs
	sub bx, ss:[0eh]
	mov ax, 4c00h
	int 21h

code ends

end start
