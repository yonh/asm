;;; 第9章9.7监测点9.2 p184
;;; 利用jcxz指令实现在内存2000h段中查找第一个值为0的字节,并将它的偏移地址保存在dx中
assume cs:code

code segment
start:
	mov ax, 2000h
	mov ds, ax
	mov bx, 0

s:	mov cx, 0
	mov cl, [bx]
	jcxz ok
	inc bx
	jmp short s

ok: mov dx, bx
	
	mov ax, 4c00h
	int 21h
code ends

end start
