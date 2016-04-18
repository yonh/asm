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
rev_str:
	push si
	push ax
	push bx
	push cx
	
	mov cx, 0
	mov bx, 0	;记录字符串长度
rev_str_start:
	; 计算字符串长度,保存在bx
	mov cl, ds:[si]
	jcxz cal_loop_len
	inc bx
	inc si
	jmp rev_str_start
	
cal_loop_len:
	;计算循环次数
	dec si
	mov ax, bx
	mov bx, 2
	div bx
	mov cx, ax
	mov bx, 0
s:
	mov al, ds:[bx]
	mov ah, ds:[si]
	mov byte ptr ds:[si], al
	mov byte ptr ds:[bx], ah
	inc bx
	dec si
	loop s
rev_str_end:
	pop cx
	pop bx
	pop ax
	pop si
	ret

code ends

end start