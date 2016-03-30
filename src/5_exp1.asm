;;; 第五章练习1
;;; 将内存往内存0200:0~0200:23f 写入 0~23f

assume cs:code
code segment
	mov ax, 0200h
	mov ds, ax

	mov ax, 0
	mov bx, 0
	mov cx , 40h		;4h = 64
	
	s: mov [bx], al
	inc ax
	inc bx
	loop s
	
	mov ax, 4c00h
	int 21h
code ends
end
