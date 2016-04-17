;;; 第10章 10.7 p196
;;; 计算data段第一组数据的3次方,结果存于后面一组dword单元中

assume cs:code
data segment
	dw 1, 2, 3, 4, 5, 6, 7, 8
	dd 0, 0, 0, 0, 0, 0, 0, 0
data ends
code segment
start:
	mov ax, data
	mov ds, ax
	mov si, 0		; ds:si指向第一组数据
	mov di, 16		; ds:di指向第二组数据
	
	mov cx, 8
s:
	mov bx, [si]
	call cube
	mov [di], ax
	mov [di].2, dx
	add si, 2
	add di, 4
	loop s
	
	mov ax, 4c00h
	int 21h
cube:
	mov ax, bx
	mul bx
	mul bx
	ret

code ends

end start
