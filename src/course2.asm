;;; 课程设计2
;;; 实现输出字符串选项
;;; 实现控制字符串高亮
;;; 实现控制上下选择选项

assume cs:code

code segment
start:

	call copy_boot
	mov bx, 0
	push bx			;push cs
	mov bx, 200h
	push bx			;push ip
	retf			;程序转到 0:7e00h
	
	mov ax, 0


;==========================================
; 安装boot程序
copy_boot:
	push ax
	push ds
	push di
	push si
	
	; ds:si => es:di
	mov ax, cs
	mov ds, ax		; set ds
	mov ax, 0
	mov es, ax		; set es
	mov si, offset boot
	mov di, 200h
	
	mov cx, offset boot_end - offset boot
	cld
	rep movsb
	
	pop si
	pop di
	pop ds
	pop ax
	ret

;==========================================
; 引导程序
boot:
	jmp boot_start
boot_option:
	option_1 db '1) reset pc ',0
	option_2 db '2) reboot',0
	option_3 db '3) clock',0
	option_4 db '4) set clock',0
	option_table dw  option_1 -  boot+200h	; offset option_1 - offset boot+7e00h; 加与不加没什么区别
				 dw  option_2 -  boot+200h
				 dw  option_3 -  boot+200h
				 dw  option_4 -  boot+200h
	current 	 db 0						; 当前选项
boot_start:
	
	call show_option
	s:nop
	jmp s
	
	ret

;==========================================
; 显示选项
show_option:
	push ax
	push es
	push di
	push dx

	mov ax, 0b800h
	mov es, ax
	mov di, 160*12+40
	mov al, 'h'
	mov es:[di], al

	; 获取当前选项地址
	mov bx, offset current-boot+200h
	mov dh, byte ptr cs:[bx] ;当前选项
	
	; 这里的bx只是option_table这个标号的地址,要获取地址内的数据应该加上ds:[bx], ds:[bx] =>字符串的起始地址
	mov bx, option_table -  boot+200h ;同上,为何加上offset和不加没什么区别; offset option_table - offset boot+7e00h
	
	mov dl, 0	; dl保存循环当前行
	mov cx, 4
l_show_option_line:	;===显示一行字符===
	push bx
	mov bx, cs:[bx]			; 获取字符串选项起始地址
	push di	;显示输出字符的位置索引
	
	; 判断是否是当前行, 使用绿色表示当前行, ah保存自负颜色
	cmp dl, dh
	jne neq
	mov ah, 1010b
	jmp l_show_option
neq:
	mov ah, 0fh
	
l_show_option:
	mov al, cs:[bx]
	cmp al, 0
	je l_show_option_line_done
	mov es:[di], al
	mov byte ptr es:[di+1], ah	; 修改字符颜色
	add di, 2
	inc bx
	jmp l_show_option
l_show_option_line_done: ;===显示一行字符结束===
	pop di
	pop bx
	add di, 160
	add bx, 2
	inc dl
	loop l_show_option_line

show_option_ret:
	pop dx
	pop di
	pop es
	pop ax
	ret

boot_end:
	nop
code ends
end start