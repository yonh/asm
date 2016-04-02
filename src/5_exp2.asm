;;; 第五章练习2
;;; 将内存往内存0200:0~0200:23f 写入 0~23f
;;; 只能使用9行代码, 使用bl替代al的方式减少2行代码

assume cs:code
code segment
	mov ax, 0200h
	mov ds, ax

	mov bx, 0
	mov cx , 40h		;40h = 64
	
	s: mov [bx], bl
	inc bx
	loop s
	
	mov ax, 4c00h
	int 21h
code ends
end
