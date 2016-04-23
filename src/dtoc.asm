;;; 第10章
;;; 实现数字转换为字符的子程序

assume cs:code

data segment
	dd 6556500
	db 64 dup(0)
data ends

code segment
start:
	mov ax, data
	mov ds, ax
	mov ax, ds:[0]
	mov dx, ds:[2]
	mov si, 4
	
	call dtoc
	call rev_str

	mov ax, 4c00h
	int 21h
	
; =================================================================
; 子程序功能: 将word型数据转变为是10进制的字符串,字符串结尾以0结束
; 参数 ax:低16位, dx:高16位
; ds:si指向字符串首地址
dtoc:
	push si
	push cx
	push dx
	push bx

dtoc_start:
	mov cx, 10
	call divdw
	; 判断商是否为0 (dx, ax)
	push cx
	mov cx, ax
	add cx, dx
	jcxz dtoc_end
	pop cx
	
	add cx, 30h
	mov byte ptr ds:[si], cl
	inc si
	
	jmp dtoc_start

dtoc_end:
	pop cx
	add cx, 30h
	mov byte ptr ds:[si], cl
	inc si
	mov byte ptr ds:[si], 0
	inc si

	pop bx
	pop dx
	pop cx
	pop si
	ret

; =================================================================
; 子程序功能: 反转字符串
; 参数: ds:si指向字符串首地址,0为结束

; 注意地方
; 1.一个字符的时候没必要反转
; 2.注意字符串长度,div的时候不要使用bx
; 3.注意字符串起始地址,好容易陷入使用0作为开始偏移地址的陷阱

; 这里还只用到比较jcxz实现判断
rev_str:
	push si
	push ax
	push bx
	push cx
	push dx
	
	mov dx, si	; 记录字符串首地址
	mov cx, 0
	mov bx, 0	; 记录字符串长度
rev_str_start:
	; 计算字符串长度,保存在bx
	mov cl, ds:[si]
	jcxz cal_loop_len
	inc bx
	inc si
	jmp rev_str_start
	
cal_loop_len:
	; 判断是否只是只有一个字符只有一个字符不需要反转
	mov cx, bx
	dec cx
	jcxz rev_str_end
	mov cx, 0
	
	;计算循环次数
	dec si
	mov ax, bx
	mov bx, 2
	div bl
	mov cl, al
	mov bx, dx		; 获取字符串首地址
rev_str_main:
	mov al, ds:[bx]
	mov ah, ds:[si]
	mov byte ptr ds:[si], al
	mov byte ptr ds:[bx], ah
	inc bx
	dec si
	loop rev_str_main
rev_str_end:
	pop dx
	pop cx
	pop bx
	pop ax
	pop si
	ret

; =================================================================
; 子程序功能: 将ds:si指向下一条字符串的首地址,判断字符串是否结束判断字符是否为0
; 参数: ds:si指向字符串首地址,0为字符串结束标志
next_str:
	push cx
	mov cx, 0
next_str_main:
	mov cl, ds:[si]
	inc si
	jcxz next_str_end
	jmp next_str_main
next_str_end:
	pop cx
	ret

; =================================================================
; 子程序功能: 解决除法溢出问题
; 参数
; ax dword的低16位
; dx dword的高16位
; cx 除数
; 返回
; dx 结果高16位, ax结果低16位
; cx 余数
divdw:
	push bx
	
	mov bx, ax	; 低位
	
	; int(H/N) * 65536
	mov ax, dx
	mov dx, 0
	div cx
	push ax	; 保存商
	
	; 余数*65536 等价于将一个低位的数直接移动高位,所以这里dx就是*65536的结果
	mov ax, bx
	div cx
	
	mov cx, dx		; 余数
	pop dx			; 上面保留的商
	
	pop bx
	ret
	
code ends
end start