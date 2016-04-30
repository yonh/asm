;;; 13章 实验13.2
;;; 编写并安装7ch中断例程, 用中断实现loop
;;; 在屏幕中间打印一行感叹号

assume cs:code

code segment
start:
	; 安装中断例程
	call install
	
	mov ax, 0b800h
	mov es, ax
	mov di, 160*12 ; at line 12
	
	; mov bx, offset s-offset se 这里我直接保存bx的偏移地址，而不是2个地址的相减的值
	mov bx, offset s
	mov cx, 80
s:
	mov byte ptr es:[di], '!'
	add di, 2
	int 7ch
se:	nop
	

	jmp se

;====================================================
;;; 安装中断例程 7ch
install:
	;ds:si=>es:di
	mov ax, cs
	mov ds, ax
	mov si, offset i_loop
	mov ax, 0
	mov es, ax
	mov di, 200h
	mov cx, offset i_loop_end - offset i_loop
	cld
	rep movsb
	
	; 设置中断向量
	mov word ptr es:[7ch*4], 200h
	mov word ptr es:[7ch*4+2], 0
	ret
	
;====================================================
;;; 中断例程
;;; 实现loop功能
;;; 参数: cx循环次数
i_loop:
	push bp
	mov bp, sp
i_loop_start:
	dec cx
	cmp cx, 0
	je i_loop_ret
	mov [bp+2], bx
i_loop_ret:
	pop bp
	iret
i_loop_end:
	nop
code ends

end start