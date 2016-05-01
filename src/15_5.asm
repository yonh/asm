;;; 15章
;;; 编写int9中断例程
;;; 当按下空格键的时候更改颜色,调用原来的int9中断例程处理硬件细节
;;; 将int9中断例程安装到0:204中

assume cs:code

stack segment
	db 128 dup(0)
stack ends


code segment
start:
	mov ax, stack
	mov ss, ax
	mov sp, 128
	
	call install_int9
	
	mov ax, 0b800h
	mov es, ax
	mov ah, 'a'
s:	mov es:[160*12+80], ah
	call delay
	inc ah
	cmp ah, 'z'
	jna s
	
	; 将中断向量表中的int9中断例程的地址恢复为原来的地址
	mov ax, 0
	mov es, ax
	cli
	push es:[200h]
	pop es:[9*4]
	push es:[202h]
	pop es:[9*4+2]
	
	sti
	
	l_end:
		nop
	jmp l_end

delay:
	push ax
	push dx
	
	mov dx, 2000h
	mov ax, 0
s1:
	sub ax, 1
	sbb dx, 0
	cmp ax, 0
	jne s1
	cmp dx, 0
	jne s1

	pop dx
	pop ax
	ret

;;;=============================================================
;;; 新的int9中断例程
;;; 当按下空格键的时候更改颜色
int9:
	push ax
	push bx
	push es
	push cx
	
	in al, 60h
	
	pushf		; 将flag压栈
	; 调用原来的int9中断处理硬件细节, 原来的int9中断例程的地址保存在ds:[0],ds:[2]
	;pushf		; 由于我们在int9中断例程中,所以设置TF,IF的步骤可以省略的,因此此段代码可删除掉
	;pop bx
	;and bh, 11111100b
	;push bx
	;popf
	call dword ptr cs:[200h]	;调用原来的int9中断例程
	
	cmp al, 39h	; 判断扫描码是否等于空格键的扫描码,不是则返回
	jne int9ret
	; 更改屏幕颜色
	mov ax, 0b800h
	mov bx, 1
	mov cx,2000
change_color:
	mov es, ax
	add byte ptr es:[bx],10	; 将属性+1以改变颜色
	add bx, 2
	loop change_color
	
int9ret:
	pop cx
	pop es
	pop bx
	pop ax
	iret
int9end:
	nop
	
;;;=============================================================
;;; 安装int9中断例程
install_int9:
	push ax
	push es
	push ds
	push si
	push di
	push cx
	
	mov ax, cs
	mov ds, ax
	mov ax, 0
	mov es, ax
	
	mov si, offset int9
	mov di, 204h
	mov cx, offset int9end-offset int9
	cld
	rep movsb
	
	push es:[9*4]
	pop es:[200h]
	push es:[9*4+2]
	pop es:[202h]
	cli
	mov word ptr es:[9*4], 204h
	mov word ptr es:[9*4+2], 0
	sti
	
	pop cx
	pop di
	pop si
	pop ds
	pop es
	pop ax	
	ret
code ends
end start