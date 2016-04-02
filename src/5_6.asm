;;; 计算ffff:0~ffff:f单元中的和，结果保存到dx中

assume cs:code
code segment
	mov ax, 0eeeeh	; 在汇编中程序中,数据不能以字母开头所以补0
	mov ds, ax
	mov dx, 0		; 结果
	

	mov ah, 0
	mov bx, 0		; 保存当前读取单元的索引
	mov cx, 0fh		; 循环次数
	s:mov al, [bx]	; 这里可不能用cx,至于原因我还不知道
	add dx, ax
	inc bx
	loop s
	
	mov ax, 4c00h	;程序返回
	int 21h
code ends
end
