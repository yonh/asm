;;; 11章实验11
;;; 将字符转换为大写

assume cs:code

data segment
	db 'hello world!!!',0
data ends

code segment
start:
	mov ax, data
	mov ds, ax
	mov si, 0

	call letterc

	mov ax, 4c00h
	int 21h

	
; =================================================================
; 子程序功能: 将以0结尾的字符串中小写的字符转换为大写
; 参数 ds:si指向字符串中的首地址
letterc:
	push ax
	push ds
	push si

letterc_start:
	; 获取字符
	; 判断字符是否大于 或小于xx
	mov al, 0
	cmp ds:[si], al		; 等于0,字符串结尾
	je letterc_end
	mov al, 97
	cmp ds:[si], al		; 低于97非小写字母
	jb letterc_next_str
	mov al, 122
	cmp ds:[si], al	; 高于122非小写字母
	ja letterc_next_str
	
	; 小写转换为大写
	and byte ptr ds:[si], 11011111b	;等于 (ds:[si]) = (ds:[si])-30h
	;sub ds:[si], 30h

letterc_next_str:
	inc si
	jmp letterc_start
	
letterc_end:
	pop si
	pop ds
	pop ax
	ret

code ends

end start