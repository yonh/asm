;;; 计算ffff:0~ffff:f单元中的和，结果保存到dx中

assume cs:code
code segment
	mov ax, 0ffffh	; 在汇编中程序中,数据不能以字母开头所以补0
	mov ds, ax
	mov dx, 0		; 结果
	
	mov al, ds:[0]
	add dx, ax

	mov al, ds:[1]
	add dx, ax

	mov al, ds:[2]
	add dx, ax

	mov al, ds:[3]
	add dx, ax

	mov al, ds:[4]
	add dx, ax

	mov al, ds:[5]
	add dx, ax

	mov al, ds:[6]
	add dx, ax

	mov al, ds:[7]
	add dx, ax

	mov al, ds:[8]
	add dx, ax

	mov al, ds:[9]
	add dx, ax

	mov al, ds:[0ah]
	add dx, ax

	mov al, ds:[0bh]
	add dx, ax


	mov al, ds:[0ch]
	add dx, ax


	mov al, ds:[0dh]
	add dx, ax


	mov al, ds:[0eh]
	add dx, ax


	mov al, ds:[0fh]
	add dx, ax

	mov ax, 4c00h
	int 21h
code ends
end
