;;; 实现ds:si指向下一个字符串的首地址

assume cs:code

data segment
	db 'abcde',0,'efghij',0,'heil',0
data ends

code segment
start:
	mov ax, data
	mov ds, ax
	mov si, 0
	
	call next_str
	call next_str
	call next_str
	
	mov ax, 4c00h
	int 21h

; =================================================================
; 子程序功能: 将ds:si指向下一条字符串的首地址,判断字符串是否结束判断字符是否为0
; 参数: ds:si指向字符串首地址,0为字符串结束标志
next_str:
	push cx
	mov cx, 0
next_str_main:
	mov cl, ds:[si]
	inc si
	jcxz next_str_end
	jmp next_str_main
next_str_end:
	pop cx
	ret

code ends
end start