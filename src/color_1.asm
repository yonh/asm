;;; 实现反转字符串

assume cs:code

data segment
	db '12345678',0
data ends

code segment
start:
	mov ax, 0b800h
	mov es, ax
	mov ah, 0fh
	mov al, 60
	
	mov si, 0
	mov di, 0
	mov cx, 0ffh
sss:
	mov ax, si
	mov ah, al
	mov es:[di], ax
	inc si
	add di, 14
	loop sss
	s:mov ax, 12
	jmp s
	mov ax, 4c00h
	int 21h


code ends

end start