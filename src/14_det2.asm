;;; 监测点14.2, p269
;;; 用加法和移位指令计算ax = ax*10

assume cs:code
code segment
start:
	; 加法
	mov ax, 10
	mov cx, 9
s_add:
	add ax, 10
	loop s_add
	
	; 移位指令
	mov ax, 10
	shl ax, 1
	mov bx, ax
	mov ax, 10
	mov cl, 3
	shl ax, cl
	add ax, bx
	
	mov ax, 4c00h
	int 21h
code ends
end start