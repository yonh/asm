;;; 移位指令

assume cs:code
code segment
start:
	; shl 寄存器, 移动位数
	mov al, 0ffh	; al= 1111 1111
	shl al, 1		; 左移移位, al = 1111 1110
	mov cl, 2		; 当移位大于1时,需要通过cl保存移动位数
	shl al, cl		; 左移2位, al = 1111 1000
	
	; shr 寄存器, 移动位数
	mov al, 0ffh	; al= 1111 1111
	shr al, 1		; 右移移位, al = 0111 1111
	mov cl, 2		; 当移位大于1时,需要通过cl保存移动位数
	shr al, cl		; 右移2位, al = 0001 1111

	mov ax, 4c00h
	int 21h
code ends
end start