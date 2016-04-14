;;; 第9章 实验9 p187
;;; 向屏幕输出hello,world
;;; 往内存B8000~BFFFF写入数据可在屏幕显示出来
assume cs:code

data segment
	db 'hello,world!!!  '
data ends

code segment
start:
	mov ax, data
	mov ds, ax
	mov ax, 0b800h
	mov es, ax
	mov bx, 0
	
	mov cx, 16
	mov ah, 1111b 	;设置颜色为黑底白字
	mov si, 0
s:
	mov al, [bx]
	mov es:[si], ax
	inc bx
	add si, 2
	loop s
	
s0: mov ax, 0
	jmp s0
	
	mov ax, 4c00h
	int 21h
code ends

end start
