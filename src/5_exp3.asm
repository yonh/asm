;;; 第五章练习3
;;; 将mov ax,4c00h之前的指令复制到0:200处
;;; 注意将mov ax,4c00h所在地址-代码最开始的地址即可得出字节数
assume cs:code
code segment
	mov ax, cs
	mov ds, ax
	mov ax, 0020h
	mov es, ax
	mov bx, 0
	mov cx, 0017h
s:	mov al, [bx]
	mov es:[bx], al
	inc bx
	loop s
	
	mov ax, 4c00h
	int 21h
code ends
end
