;;; 第10章 监测点10.1 p191
;;; 实现从内存1000:0处开始执行指令
assume cs:code

stack segment
	db 16 dup (0)
stack ends

code segment
start:
	mov ax, stack
	mov ss, ax
	mov sp, 10h
	mov ax, 1000h
	push ax
	mov ax, 0
	push ax
	
	retf
code ends

end start
