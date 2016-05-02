;;; 16章 16.3
;;; 使用字符表查找数据的16进制

assume cs:code
code segment
start:
	mov al, 0bfh
	call showbyte
	s:nop
	jmp s
showbyte:
	jmp short show
	table db '0123456789ABCDEF'	;字符表
show:
	push bx
	push es
	
	mov ah, al
	shr ah, 1
	shr ah, 1
	shr ah, 1
	shr ah, 1			; 右移4位获得高位数据
	and al, 00001111b	; 获取低位数据
	
	mov bl, ah
	mov bh, 0
	mov ah, table[bx]	;利用表获取对应的字符
	mov bx, 0b800h
	mov es, bx
	mov es:[160*12+80], ah
	
	mov bl, al
	mov bh, 0
	mov al, table[bx]	; 同上
	mov es:[160*12+80+2], al
	pop es
	pop bx
	ret
code ends
end start