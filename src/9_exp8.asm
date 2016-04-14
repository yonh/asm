;;; 第9章 实验8 p187
;;; 改程序经过一系列的跳转,最终会执行cs:0处的代码

assume cs:code

code segment
	mov ax, 4c00h
	int 21h

start:
	mov ax, 0
s:
	nop
	nop

	mov di, offset s
	mov si, offset s2
	mov ax, cs:[si]
	mov cs:[di], ax
s0:	jmp s

s1: mov ax, 0
	int 21h
	mov ax, 0

s2: jmp s1
	nop
	
code ends

end start
