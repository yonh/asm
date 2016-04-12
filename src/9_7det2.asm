;;; 第9章9.7监测点 1 p183
;;; 程序执行jmp后跳转到第一条指令

assume cs:code

data segment
	dd 123456789
data ends

code segment
start:
	mov ax, data
	mov ds, ax
	mov bx, 0
	mov [bx], bx
	mov [bx+2], cs
	jmp dword ptr ds:[0]

	mov ax, 4c00h
	int 21h
code ends

end start
