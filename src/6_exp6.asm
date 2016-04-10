;;; 第六章实验5.6
;;; 用push实现将a段中的8个字型数据逆序存储到b段中
;;; 

assume cs:code

a segment
	dw 1,2,3,4,5,6,7,8
a ends

b segment
	dw 0,0,0,0,0,0,0,0
b ends
code segment
start:
	mov ax, b
	mov es, ax
	mov ax, a
	mov ds, ax

	
	mov bx, 0
	mov cx, 8
s:
	push [bx]
	add bx, 2
	loop s
	
	mov bx, 0
	mov cx, 8
s0:
	pop es:[bx]
	add bx, 2
	loop s0
	
	mov ax, 4c00h
	int 21h
code ends

end start
