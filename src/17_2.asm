;;; 16章 17.2
;;; 按下rgb3个键分别更改背景颜色

assume cs:code
code segment
start:
	mov ah, 0
	int 16h		; 从字符缓冲区读取一个字符 ah=扫描码 al=字母的ascii码
	
	mov ah, 1
	cmp al, 'r'
	je red
	cmp al, 'g'
	je green
	cmp al, 'b'
	je blue
	jmp short sret

red:
	shl ah, 1
green:
	shl ah, 1
blue:
	mov bx, 0b800h
	mov es ,bx
	mov bx, 1
	mov cl, 4
	shl ah, cl		; 获取颜色对应的值
	mov cx, 2000
s:
	and byte ptr es:[bx], 10001111b
	or es:[bx], ah
	add bx, 2
	loop s
	
sret:
	jmp start
	mov ax, 4c00h
	int 21h
code ends
end start