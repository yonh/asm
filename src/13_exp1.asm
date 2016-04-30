;;; 13章 实验13
;;; 编写并安装7ch中断例程, 功能为输出一个以0结束的字符串,中断例程安装在0:200处
;;; 参数: dh行号, dl列号, cl颜色, ds:si字符串首地址

assume cs:code

data segment
	db 'welcome to masm!',0
data ends

code segment
start:
	; 安装中断例程
	cld
	rep movsb
	
	; 设置中断向量
	mov word ptr es:[7ch*4], 200h
	mov word ptr es:[7ch*4+2], 0
	
	mov ax, data
	mov ds, ax
	mov si, 0
	mov dh, 1
	mov dl, 1
	call show_str
	
	s:nop
	jmp s

;====================================================
;;; 中断例程
;;; 输出一个以0结束的字符串,中断例程安装在0:200处
;;; 参数: dh行号, dl列号, cl颜色, ds:si字符串首地址
show_str:
	mov ax, 0b800h
	mov es, ax
	mov di, 0
	; 计算行号的偏移位置
	mov al, dh
	mov bl, 160
	mul bl
	; 计算列号的偏移位置
	mov dh,0
	add ax, dx
	add ax, dx
	mov di, ax
	
show_str_start:
	cmp word ptr ds:[si], 0
	je show_str_end
	
	
	mov al, ds:[si]
	mov es:[di], al
	inc si
	add di, 2
	jmp show_str_start
show_str_end:
	nop
	ret
code ends

end start