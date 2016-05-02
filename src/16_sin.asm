;;; 16章 16.3
;;; 使用字符表查找数据的16进制

assume cs:code
code segment
start:
	mov al, 150
	call showsin
	s:nop
	jmp s
showsin:
	jmp short show
	table dw ag0, ag30, ag60, ag90, ag120, ag150, ag180
	ag0 db '0', 0
	ag30 db '0.5', 0
	ag60 db '0.866', 0
	ag90 db '1', 0
	ag120 db '0.866', 0
	ag150 db '0.5', 0
	ag180 db '0', 0
show:
	push bx
	push es
	push si
	
	mov bx, 0b800h
	mov es, bx
	mov si, 160*12+80
	
	cmp al, 180		;高于180,跳转至错误处理
	ja err
	
	; 以角度/30获得相对与table的偏移
	mov ah, 0
	mov bl, 30
	div bl
	mov bl, al
	mov bh, 0
	add bx, bx
	mov bx, table[bx]
	
	;显示
shows:
	mov ah, cs:[bx]
	cmp ah, 0
	je showret
	mov es:[si], ah
	inc bx
	add si, 2
	jmp short shows
	
showret:
	pop si
	pop es
	pop bx
	ret

err:
	mov al, 'e'
	mov es:[si], al
	mov al, 'r'
	mov es:[si+2], al
	mov al, 'r'
	mov es:[si+4], al
	mov al, 'o'
	mov es:[si+6], al
	mov al, 'r'
	mov es:[si+8], al
	jmp showret

code ends
end start