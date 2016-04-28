;;; 13章 使用中断实现模拟loop指令功能

assume cs:code

code segment
start:

	; 安装中断程序
	; from
	mov ax, cs
	mov ds, ax
	mov si, offset lp
	; to
	mov ax, 0
	mov es, ax
	mov ax, 200h
	mov di, ax
	; size
	mov cx, offset lp_end - offset lp
	cld
	rep movsb
	; 设置中断向量
	mov word ptr es:[7ch*4], 200h
	mov word ptr es:[7ch*4+2], 0
	
	mov ax, 0b800h
	mov es, ax
	mov di, 160*12
	
	mov cx, 80
	mov bx, offset s-offset se		; 记录标号se到s的转移位移
s:
	mov byte ptr es:[di], '!'
	add di, 2
	int 7ch						; cx!=0,转移到s
se:
	nop
	
l_stop:
	nop
	jmp l_stop
	

; =================================================================
; 中断例程
; 实现jmp功能
; bx存放转移位移
lp:
	push bp
	mov bp, sp
	dec cx
	jcxz lp_ret				; 当cx!=0的时候,转移位移加上ip的值即可得到标号s的值
	add [bp+2], bx
lp_ret:
	pop bp
	iret
lp_end:
	nop
	
code ends
end start