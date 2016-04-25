;;; 12章实验12
;;; 编写0号中断的处理程序

assume cs:code

code segment
start:
	mov ax, cs
	mov ds, ax
	mov si, offset do0		; 获取中断程序指令的偏移地址
	mov ax, 0
	mov es, ax
	mov di, 200h			; 中断程序存储位置
	
	;安装中断程序
	mov cx, offset do0end - offset do0
	cld
	rep movsb		; 复制中断程序到:0:200地址处

	
	; 设置中断向量表 , 0号中断指向0:200
	mov word ptr es:[0], 200h
	mov word ptr es:[2], 0
	
	
	;触发除法溢出中断
	mov ax, 0ffffh
	mov bl, 1
	div bl
	
	mov ax, 4c00h
	int 21h

do0:
	jmp short do0start
	db "overflow!",0
do0start:
	
	; 显示字符串overflow
	mov ax, cs
	mov ds, ax
	mov ax, 0b800h
	mov es, ax
	mov di, 12*160+33*2	; 设置字符串输出位置为屏幕中间
	mov si, 202h
	mov cx, 9
	
	mov ah, 10			; 设置颜色为亮绿色
	mov cx, 0
s:
	mov cl, [si]
	jcxz s_end
	mov al, cl
	mov es:[di], ax
	add di, 2
	inc si
	loop s
s_end:
	mov ax, 4c00h
	int 21h
	
do0end:
	nop

code ends

end start