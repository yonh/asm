;;; 16章 17.3
;;; 字符串的输入程序

;;; 本程序注意字符串为空时,字符串输出问题,可能会因为top=0导致,循环输出整个屏幕的乱码


assume cs:code, ds:data
data segment
	strings db 128 dup (0)
	top dw 0
data ends
code segment
start:
	mov ax, data
	mov ds, ax
	mov ax, 0b800h
	mov es, ax
	
	call get_char
	mov ah, 2
	call charstack
	
	s:nop
	jmp start

;============================================================
; 字符串出栈入栈子程序
; 参数
;   ah=0,al=字符ascii 字符入栈
;   ah=1,字符出栈, 删除字符
;   ah=2,显示字符串
charstack:
	jmp char_start
	table dw charpush, charpop, charshow
char_start:
	push ax
	push bx
	cmp ah, 2
	ja sret
	mov bl, ah
	mov bh, 0
	add bx, bx
	jmp word ptr table[bx]
	
sret:
	pop bx
	pop ax
	ret

charpush:
	push bx
	mov bx, top
	mov strings[bx], al
	inc top
	pop bx
	
	jmp sret
charpop:
	push bx
	cmp top, 0
	je char_pop_end
	dec top
	mov bx, top
	mov strings[bx], 0
char_pop_end:
	pop bx
	
	jmp sret
charshow:
	push di
	push si

	mov di, 0
	mov si, 0	
	cmp top, 0			; 字符为空不显示
	je l_show_end
	
	mov cx, top
l_show_char:
	mov al, strings[si]
	mov es:[di], al
	add di, 2
	inc si
	loop l_show_char
	

l_show_end:
	; 最后一个字符设置为空格
	mov al, ' '
	mov es:[di], al
	; 打印当前字符串长度
	mov ax, top
	add ax, 30h
	mov es:[160*23], al
	
	pop si
	pop di
	
	jmp sret
	
;==============================================
get_char:
	mov ah, 0
	int 16h	;获取键盘输入
	cmp al, 20h
	jb is_not_char
	;call char_push
	mov ah, 0
	call charstack	; char push
	
get_char_ret:
	ret

	
is_not_char:
	;是退格键就删除字符
	cmp ah, 0eh			; 退格键的扫描码
	je is_backspace
	
	jmp get_char_ret
is_backspace:
	;call char_pop
	mov ah, 1
	call charstack
	
	jmp get_char_ret


code ends
end start