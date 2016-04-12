;;; 第9章9.1 p172
;;; 复制s处的代码到s0处

assume cs:code


code segment
start:

s:	mov ax, bx		; 此行代码占2个字节
	mov si, offset s
	mov di, offset s0
	
	push cs:[si]
	pop cs:[di]

s0:	nop				; nop占一个字节
	nop
	
	mov ax, 4c00h
	int 21h
code ends

end start
