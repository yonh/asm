;;; 15章
;;; 编写int9中断例程
;;; 当按下空格键的时候更改颜色,调用原来的int9中断例程处理硬件细节

assume cs:code

stack segment
	db 128 dup(0)
stack ends
data segment
	dw 0,0		; 存放原来的int9中断例程地址
data ends

code segment
start:
	mov ax, stack
	mov ss, ax
	mov sp, 128
	
	; 将原来的int9中断例程的地址保存到ds:[0],ds:[2]
	mov ax, data
	mov ds, ax
	mov ax, 0
	mov es, ax
	push es:[9*4]
	pop ds:[0]
	push es:[9*4+2]
	pop ds:[2]
	
	; 设置新的int9中断例程
	cli ;防止在修改中断向量的时候触发键盘中断
	mov word ptr es:[9*4], offset int9	;偏移地址
	mov es:[9*4+2], cs					;段地址
	sti
	
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
	push ds:[0]
	pop es:[9*4]
	push ds:[2]
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
	
	in al, 60h
	
	pushf		; 将flag压栈
	; 调用原来的int9中断处理硬件细节, 原来的int9中断例程的地址保存在ds:[0],ds:[2]
	;pushf		; 由于我们在int9中断例程中,所以设置TF,IF的步骤可以省略的,因此此段代码可删除掉
	;pop bx
	;and bh, 11111100b
	;push bx
	;popf
	call dword ptr ds:[0]	;调用原来的int9中断例程
	
	cmp al, 39h	; 判断扫描码是否等于空格键的扫描码,不是则返回
	jne int9ret
	mov ax, 0b800h
	mov es, ax
	inc byte ptr es:[160*12+40*2+1]	; 将属性+1以改变颜色
	
int9ret:
	pop es
	pop bx
	pop ax
	iret
	
code ends
end start