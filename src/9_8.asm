;;; 第9章9.8监测点9.3 p185
;;; 利用jcxz指令实现在内存2000h段中查找第一个值为0的字节,并将它的偏移地址保存在dx中
;;; 作用同监测点9.2

assume cs:code

code segment
start:
	mov ax, 2000h
	mov ds, ax
	mov bx, 0

s:	mov cl, [bx]
	mov ch, 0
	inc cx
	inc bx
	loop s

ok: dec bx
	mov dx, bx
	
	mov ax, 4c00h
	int 21h
code ends

end start
