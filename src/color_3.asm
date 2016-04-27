;;; 实现显示文字颜色表

assume cs:code

data segment
	db '00','10','20','30','40','50','60','70','80','90','A0','B0','C0','D0','E0','F0'
data ends

code segment
start:
	call print_col
	call print_row
	call print_00
	ssss: nop
	jmp ssss
	
mov ax, 4c00h
int 21h

print_00:
	mov ax, data
	mov ds, ax
	mov si, 8+80*4
	mov di, 0
	mov ax, 0b800h
	mov es, ax

	mov cx, 16
	mov dl, 0		; 保存当前颜色值 0~ff
l_l:
	push cx
	mov cx, 16
	mov bx, 30h
l_r:
	cmp bl, 3ah
	jne skip
	add bl, 7
skip:
	mov ah, dl
	mov al, bl		;	输出笑脸图案
	mov es:[si], ax
	add si, 4
	inc dl
	inc bl
	loop l_r
	
	add si, 96
	pop cx
	loop l_l
	ret

; 打印顶部行
print_row:
	mov ax, data
	mov ds, ax
	mov si, 8+80*2
	mov di, 0
	mov ax, 0b800h
	mov es, ax
	
	mov cx, 16
l_row:
	mov ah, 0fh
	mov al, ds:[di]
	mov es:[si], ax
	
	add di, 2
	add si, 4
	loop l_row
	ret
; 打印左侧列
print_col:
	mov ax, data
	mov ds, ax
	mov si, 80*2*2
	mov di, 0
	mov ax, 0b800h
	mov es, ax
	
	mov cx, 16
l_col:
	mov ah, 0fh
	mov al, ds:[di]
	mov es:[si], ax
	mov al, ds:[di+1]
	mov es:[si+2], ax
	add di, 2
	add si, 80*2
	loop l_col
	ret

code ends
end start