;;; 13章 实验13.3
;;; 在屏幕上的2,4,6,8行输出4据英文诗


assume cs:code
code segment
	s1:db 'Good,better, best,$'
	s2:db 'Never let it rest,$'
	s3:db 'Till good is better,$'
	s4:db 'And better,best.$'
	s: dw offset s1, offset s2, offset s3, offset s4
	row:db 1,3,5,7
start:
	mov ax, cs
	mov ds, ax
	mov bx, offset s
	mov si, offset row
	mov cx, 4
ok:
	mov bh, 0
	mov dh, [si]
	mov dl, 0
	mov ah, 2
	int 10h
	
	mov dx, [bx]
	mov ah, 9
	int 21h
	add bx,2
	inc si
	loop ok
se: nop
	jmp se
	
code ends
end start