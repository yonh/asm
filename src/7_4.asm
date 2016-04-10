;;; 第七章 7.4转换大小写的问题
;;; 利用and和or转换字母大小写

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
	mov al, [bx]
	and al, 11011111b
	mov [bx], al
	inc bx
	loop s
	
	; 转换为小写
	mov cx, 5
s0:	
	mov al, [bx]
	or al, 00100000b
	mov [bx], al
	inc bx
	loop s0
	
	mov ax, 4c00h
	int 21h
code ends

end start
