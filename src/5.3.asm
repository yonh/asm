;;; 使用loop计算(ffff:0006)*3,结果保存在dx中

assume cs:code
code segment
	mov ax, 0ffffh	; 在汇编中程序中,数据不能以字母开头所以补0
	mov ds, ax
	mov bx, 6
	
	mov al, [bx]	; al = ds:bx的值
	mov ah, 0

	mov dx, 0
	mov cx, 3		; 循环3次

	s: add dx, ax
	loop s

	mov ax, 4c00h
	int 21h
code ends
end
