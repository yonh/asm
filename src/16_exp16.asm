;;; 16章 实验16
;;; 编写包含多个功能子程序的中断例程
;;; 参数
;;; ah, 0表示清屏, 1表示设置前景色, 2表示设置背景色, 3表示滚动一行
;;; 对于2,3号程序, al表示设置颜色值

;;; 注意:
;;; 本程序最重要的是要解决调用子程序的偏移地址,不像程序16_4中可以直接使用call word ptr table[bx]
;;; 因为中断程序中的table并不是指向其后面的地址的  
assume cs:code

data segment
	db 'hello'
data ends

code segment
start:
	call install
	call show_str
	
	mov ah, 1
	mov al, 0ah
	int 7ch			; 设置前景色
	call delay
	
	mov ah, 2
	mov al, 1
	int 7ch			; 设置背景色
	call delay
	
	mov ah, 3
	int 7ch
	call delay		; 滚动一行
	
	mov ah, 0
	int 7ch			; 清屏
	call delay
	
	mov ax, 4c00h
	int 21h

; =================================================================
; 子程序功能: 设置屏幕
; 参数: ah表示子程序功能, 0表示清屏, 1表示设置前景色, 2表示设置背景色, 3表示滚动一行
; 设置颜色用参数al表示

setscreen:
	jmp set
	table 	dw offset sub0-setscreen+200h
			dw offset sub1-offset setscreen+200h
			dw offset sub2-offset setscreen+200h
			dw offset sub3-offset setscreen+200h		; 将子程序存储在一个表中,通过偏移量获取子程序地址
set:
	push bx
	cmp ah, 3
	ja sret
	mov bl, ah
	mov bh,0
	add bx, bx	;获取对应功能的子程序偏移  n*2
	add bx, offset table-offset setscreen+200h			; 获取table的偏移地址
	call word ptr cs:[bx]	;调用对应的子程序
sret:
	pop bx
	iret

; 清屏子程序
sub0:
	push bx
	push cx
	push es
	
	mov bx, 0b800h
	mov es, bx
	mov bx, 0
	mov cx, 2000
sub0s:
	mov byte ptr es:[bx], ' '
	add bx, 2
	loop sub0s
	
	pop es
	pop cx
	pop bx
	ret
	
; 设置前景色子程序
sub1:
	push bx
	push cx
	push es
	mov bx, 0b800h
	mov es, bx
	mov bx, 1
	mov cx, 2000
sub1s:
	and byte ptr es:[bx], 11111000b	;将前景色的0,1,2位清零
	or es:[bx], al					;设置前景色
	add bx, 2
	loop sub1s
	pop es
	pop cx
	pop bx
	ret
	
; 设置背景色子程序
sub2:
	push bx
	push cx
	push es
	mov cl, 4
	shl al, cl
	mov bx, 0b800h
	mov es, bx
	mov bx, 1
	mov cx, 2000
sub2s:
	and byte ptr es:[bx], 10001111b	;将背景色位清零
	or es:[bx], al					;设置背景色
	add bx, 2
	loop sub2s
	pop es
	pop cx
	pop bx
	ret
	
; 滚动一行子程序
sub3:
	push cx
	push si
	push di
	push es
	push ds
	
	mov si, 0b800h
	mov es, si
	mov ds, si
	mov si, 160
	mov di, 0
	cld
	mov cx, 24*80
	rep movsb		;复制一行到上一行

	
	; 清空最后一行
	mov cx, 80
	mov si, 0
sub3s2:
	mov byte ptr [160*24+si], ' '
	add si, 2
	loop sub3s2
	pop ds
	pop es
	pop di
	pop si
	pop cx
	ret

;;; 程序等待某段时间
delay:
	push ax
	push dx
	
	mov dx, 4000h
	mov ax, 0
s1:
	sub ax, 1
	sbb dx, 0
	cmp ax, 0
	jne s1
	cmp dx, 0
	jne s1

	pop dx
	pop ax
	ret
setscreen_end:
	nop
	
;安装中断程序
install:
	push ax
	push ds
	push di
	push si
	push es
	push cx
	
	push cs
	pop ds
	mov ax, 0
	mov es, ax
	mov si, offset setscreen
	mov di, 200h
	mov cx, offset setscreen_end-offset setscreen
	cld
	rep movsb
	mov word ptr es:[7ch*4], 200h
	mov word ptr es:[7ch*4+2], 0
	
	pop cx
	pop es
	pop si
	pop di
	pop ds
	pop ax
	ret
	
;;;=======================================================
;显示字符串
show_str:
	mov ax, data
	mov ds, ax
	; 显示字符串
	mov ax, 0b800h
	mov es, ax
	mov di, 160*1+20
	mov bx, 0
	mov cx, 5
l_show:
	mov al, ds:[bx]
	mov byte ptr es:[di], al
	inc bx
	add di, 2
	loop l_show
	ret

code ends
end start