;;; 实现反转字符串

assume cs:code

data segment
	db '12345678',0
data ends

code segment
start:
	mov ax, data
	mov ds, ax
	mov si, 0
	
	call rev_str

	mov ax, 4c00h
	int 21h

; 子程序功能: 反转字符串
; 参数: ds:si指向字符串首地址,0为结束

; 注意地方
; 1.一个字符的时候没必要反转
; 2.注意字符串长度,div的时候不要使用bx
; 3.注意字符串起始地址,好容易陷入使用0作为开始偏移地址的陷阱

; 这里还只用到比较jcxz实现判断
rev_str:
	push si
	push ax
	push bx
	push cx
	push dx
	
	mov dx, si	; 记录字符串首地址
	mov cx, 0
	mov bx, 0	; 记录字符串长度
rev_str_start:
	; 计算字符串长度,保存在bx
	mov cl, ds:[si]
	jcxz cal_loop_len
	inc bx
	inc si
	jmp rev_str_start
	
cal_loop_len:
	; 判断是否只是只有一个字符只有一个字符不需要反转
	mov cx, bx
	dec cx
	jcxz rev_str_end
	mov cx, 0
	
	;计算循环次数
	dec si
	mov ax, bx
	mov bx, 2
	div bl
	mov cl, al
	mov bx, dx		; 获取字符串首地址
rev_str_main:
	mov al, ds:[bx]
	mov ah, ds:[si]
	mov byte ptr ds:[si], al
	mov byte ptr ds:[bx], ah
	inc bx
	dec si
	loop rev_str_main
rev_str_end:
	pop dx
	pop cx
	pop bx
	pop ax
	pop si
	ret

code ends

end start