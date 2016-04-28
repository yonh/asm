;;; 13章 使用中断实现jmp指令功能

assume cs:code
data segment
	db 'conversation', 0
data ends

code segment
start:

	; 安装中断程序
	; from
	mov ax, cs
	mov ds, ax
	mov si, offset i_jmp
	; to
	mov ax, 0
	mov es, ax
	mov ax, 200h
	mov di, ax
	; size
	mov cx, offset i_jmp_end - offset i_jmp
	cld
	rep movsb
	; 设置中断向量
	mov word ptr es:[7ch*4], 200h
	mov word ptr es:[7ch*4+2], 0
	
	
	mov ax, data
	mov ds, ax
	mov si, 0
	mov ax, 0b800h
	mov es, ax
	mov di, 160*12
	
s:
	cmp byte ptr [si], 0
	je ok
	mov al, [si]
	mov es:[di], al
	inc si
	add di, 2
	mov bx, offset s-offset ok		; 记录偏移量
	int 7ch
ok:
	nop
	jmp ok

; =================================================================
; 中断例程
; 实现jmp功能
; bx存放转移位移
i_jmp:
	push bp
	mov bp, sp
	add [bp+2], bx
i_jmp_ret:
	pop bp
	iret
i_jmp_end:
	nop
	
code ends
end start