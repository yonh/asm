;;; 第七章 7.6转换大小写的问题
;;; 利用and和or转换字母大小写
;;; 使用[bx+idata]优化程序

assume cs:code, ds:data

data segment
	db 'abcde'
	db 'HIJKL'
data ends

code segment
start:
	mov ax, data
	mov ds, ax
	
	; 转换为大写
	mov cx, 5
	mov bx, 0
s:	
	mov al, [bx+0]
	and al, 11011111b
	mov [bx+0], al
	
	; 转换为小写
	mov al, [bx+5]
	or al, 00100000b
	mov [bx+5], al
	inc bx
	loop s
	
	mov ax, 4c00h
	int 21h
code ends

end start
