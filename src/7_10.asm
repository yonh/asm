;;; 第七章 7.10 p152
;;; 将每行第一个字母改为大写

assume cs:code, ds:data

data segment
	db '1. file.........'
	db '2. good.........'
	db '3. edit.........'
data ends

code segment
start:
	mov ax, data
	mov ds, ax
	
	mov cx, 3;
	mov bx, 0
	mov di, 3
s:
	mov al, [bx+di]
	and al, 11011111b
	mov [bx+di], al
	add bx, 16
	loop s
	
	mov ax, 4c00h
	int 21h
code ends

end start
