;;; 第七章 7.7
;;; 将前面的数据复制到后面那段...中

assume cs:code, ds:data

data segment
	db '0123456789abcdef'
	db '................'
data ends

code segment
start:
	mov ax, data
	mov ds, ax
	
	mov cx, 8;
	mov bx, 0
s:
	mov ax, [bx]
	mov [bx+16], ax
	add bx, 2
	loop s
	
	mov ax, 4c00h
	int 21h
code ends

end start
