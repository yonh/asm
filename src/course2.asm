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
	call press_key
	;s:nop
	jmp boot_start
	
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

;==========================================================
; 接受键盘事件

press_key:
	push ax
	push bx
	push es
	
	; 获取选项
	mov bx, offset current-boot+200h
	
	mov ah, 0
	int 16h
	; 如果按上选项-1,按下选项+1
	cmp ah, 48h
	je is_up
	cmp ah, 50h
	je is_down
	cmp ah, 1
	je is_esc	; esc退出程序
	cmp ah, 1ch
	je is_enter
	jmp press_key_ret

is_esc:
	mov ax, 4c00h
	int 21h
is_enter:
	cmp byte ptr cs:[bx], 0
	je reboot
	cmp byte ptr cs:[bx], 1
	je start_system
	cmp byte ptr cs:[bx], 2
	je clock
	cmp byte ptr cs:[bx], 3
	je set_clock
	
	jmp press_key_ret
	
is_up:
	
	cmp byte ptr cs:[bx], 0		; 等于0的时候不操作
	je press_key_ret
	dec byte ptr cs:[bx]
	jmp press_key_ret
is_down:
	
	cmp byte ptr cs:[bx], 3		; 大于等于3 的时候不操作
	jnb press_key_ret
	inc byte ptr cs:[bx]
	jmp press_key_ret

press_key_ret:
	;显示当前选项
	mov ax, 0b800h
	mov es, ax
	
	mov al, cs:[bx]
	
	mov bx, 160
	mov es:[bx], al
	
	pop es
	pop bx
	pop ax
	ret

	
;=================================
reboot:
	
start_system:

clock:
	

	; 清屏
	mov ax, 3
	int 10H
	
	call show_clock
	


	
set_clock:

;;; 将cmos获取到的数据转为ascii码
;;; 参数: al,读取数据的单元地址
;;; 返回al,读取到的数据
get_ascii_in_cmos:
	out 70h, al
	in al, 71h
	mov ah, al
	; 获取个位
	and ah, 00001111b
	; 获取十位
	mov cl, 4
	shr al, cl
	
	add al, 30h
	add ah, 30h
	ret


;=======================================================
; 显示日期时间
show_clock:
	mov ax, 0b800h
	mov es, ax
	mov si, 160*12+40

show_clock_start:

	mov al, 4				;时
	call get_ascii_in_cmos
	mov es:[si+24], al
	mov es:[si+26], ah
	
	mov al, ':'
	mov es:[si+28], al
	
	mov al, 2				;分
	call get_ascii_in_cmos
	mov es:[si+30], al
	mov es:[si+32], ah
	mov al, ':'
	mov es:[si+34], al
	mov al, 0				;秒
	call get_ascii_in_cmos
	mov es:[si+36], al
	mov es:[si+38], ah
	
	jmp show_clock_start

boot_end:
	nop

;====================================================



code ends
end start