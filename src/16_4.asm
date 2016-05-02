;;; 16章 16.4
;;; 编写多个功能的子程序调用
;;; 参数
;;; ah, 0表示清屏, 1表示设置前景色, 2表示设置背景色, 3表示滚动一行
;;; 对于2,3号程序, al表示设置颜色值


assume cs:code

data segment
	db 'helloword', 0
data ends

code segment
start:
	mov ax, data
	mov ds, ax
	; 显示字符串
	mov ax, 0b800h
	mov es, ax
	mov di, 160*1+20
	mov bx, 0
l_show:
	mov al, ds:[bx]
	cmp al, 0
	je l_end
	mov byte ptr es:[di], al
	inc bx
	add di, 2
	loop l_show
l_end:
	call delay
	mov ah, 1
	mov al, 0ah
	call setscreen	; 设置前景色
	call delay
	
	mov ah, 2
	mov al, 1
	call setscreen	; 设置背景色
	call delay
	
	mov ah, 3
	call setscreen	; 滚动一行
	call delay
	
	mov ah, 0
	call setscreen	; 清屏
	call delay
	
	mov ax, 4c00h
	int 21h

; =================================================================
; 子程序功能: 设置屏幕
; 参数: ah表示子程序功能, 0表示清屏, 1表示设置前景色, 2表示设置背景色, 3表示滚动一行
; 设置颜色用参数al表示

setscreen:
	jmp short set
	table dw sub0, sub1, sub2, sub3		; 将子程序存储在一个表中,通过偏移量获取子程序地址
set:
	push bx
	cmp ah, 3
	ja sret
	mov bl, ah
	mov bh,0
	add bx, bx	;获取对应功能的子程序偏移  n*2
	call word ptr table[bx]	;调用对应的子程序
sret:
	pop bx
	ret
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
	mov cx, 24*80	;复制一行到上一行		
	rep movsb
	
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
code ends
end start