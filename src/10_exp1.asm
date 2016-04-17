;;; 第10章实验10 (1)  p206
;;; 实现显示字符串子程序

assume cs:code

data segment
	db 'hello', 0
data ends

code segment
start:
	mov ax, data
	mov ds, ax
	
	mov si, 0
	mov dh, 1
	mov dl, 75
	mov cl, 2
	call show_str

s:	mov ax, 0
	jmp s
	
; 子程序功能, 显示字符串,字符串存储在ds:si中,以0为结束符
; 参数
; 	dh 行号 (0~24)
; 	dl 列号 (0~80)
; 	cl 颜色
; 	ds:si 指向字符串的首地址
show_str:
	push dx
	push si
	push cx
	push ax
	push bx
	
	; 计算写入字符位置的偏移地址
	mov ax, 160			; 每列的开头的偏移地址等于 列数 * 80 * 2 (每个字符占2个字节,字符一个,属性一个)
	mul dh				; 计算列偏移地址
	mov bx, ax			; bx存储字符串写入地址的偏移地址
	mov dh, 0
	add dx, dx			; 计算行偏移地址
	add bx, dx
	
	mov ax, 0b800h		; 写入到b800:0以显示字符
	mov es, ax
	mov ah, cl			; ax存储每次写入的字符
	
show_str_start:
	mov ch, 0			; 字符为0则终止子程序
	mov cl, ds:[si]
	jcxz show_str_end

	mov al, ds:[si]		; 字符ascii
	mov es:[bx], ax		; 写入字符
	
	inc si
	add bx, 2
	jmp show_str_start

show_str_end:
	pop bx
	pop ax
	pop cx
	pop si
	pop dx
	ret

code ends

end start