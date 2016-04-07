;;; 第六章实验5.5
;;; 将a段和b段的数据依次相加，存于c段中
;;; 这里利用多个段寄存器辅助实现

assume cs:code

a segment
	db 1,2,3,4,5,6,7,8
a ends
b segment
	db 1,2,3,4,5,6,7,8
b ends
c segment
	db 0,0,0,0,0,0,0,0
c ends
code segment
start:
	mov ax, c
	mov ds, ax
	mov ax, b
	mov es, ax
	mov ax, a
	mov ss, ax
	
	mov cx, 8
	mov bx, 0
	
s:
	mov al, ss:[bx]
	mov [bx], al		; 需要借助al往内存单元传值
	mov al, es:[bx]
	add [bx], al
	inc bx
	loop s
	
	mov ax, 4c00h
	int 21h
code ends

end start
