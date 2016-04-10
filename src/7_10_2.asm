;;; 第七章 7.10 p157
;;; 将每行的字母变为大写

assume cs:code, ds:data, ss:stack

data segment
	db '1. file.........'
	db '2. good.........'
	db '3. edit.........'
data ends

stack segment
	dw 0,0,0,0,0,0,0,0
stack ends

code segment
start:
	mov ax, stack
	mov ss, ax
	mov sp, 16
	mov ax, data
	mov ds, ax
	
	mov bx, 0
	mov cx, 4

s:	
	push cx
	mov si, 3
	
	mov cx, 4
s1:	
	mov al, [bx+si]
	and al, 11011111b
	mov [bx+si], al
	inc si
	loop s1
	
	add bx, 16
	pop cx			; 恢复cx的值
	loop s
	
	mov ax, 4c00h
	int 21h
code ends

end start
