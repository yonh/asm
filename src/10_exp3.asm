;;; 第10章实验10 (1)  p206
;;; 实现显示数字

;;; 数字的ascii码为30~39h
assume cs:code

data segment
	dw 123, 166, 8, 3, 38, 667, 389, 888
	db 64 dup(0)
data ends

code segment
start:
	mov ax, data
	mov ds, ax
	mov di, 0		; 指向数字的位置
	mov si, 10h		; 指向字符串的首地址
	
	mov dh, 0
	mov dl, 0
	mov cl, 1
	
	mov cx, 8
	mov di, 0
s:
	; 将多个数字转换为字符串
	mov ax, ds:[di]
	call dtoc			; 将数字转换为字符串,保存到ds:[si]
	call rev_str		; 反转字符串
	
	; 打印字符串
	push cx				; 因为与外层cx冲突,所以临时存入栈,待调用子程序后返回,当然,不做处理的话会得到不同颜色的值,也无所谓
	mov cl, 0fh
	call show_str
	pop cx
	inc dh				; 行号++
	
	call next_str		; ds:[si]指向下一条字符串
	add di, 2
	loop s
	
	;; note 这里还要做的是将rev_str和dtoc的si 保留结果,而不是直接修改,让next_str来修改si的地址
	
	
	; call show_str		; 打印字符串

sloop:
	mov ax, 0
	jmp sloop
	
; =================================================================
; 子程序功能: 将word型数据转变为是10进制的字符串,字符串结尾以0结束
; 参数 ax:word数据
; ds:si指向字符串首地址
dtoc:
	push si
	push cx
	push dx
	push bx

dtoc_start:
	mov bx, 10
	mov dx, 0
	div bx
	mov cx, ax
	jcxz dtoc_end
	add dx, 30h
	mov byte ptr ds:[si], dl
	inc si
	
	jmp dtoc_start

dtoc_end:
	add dx, 30h
	mov byte ptr ds:[si], dl
	inc si
	mov byte ptr ds:[si], 0
	inc si

	pop bx
	pop dx
	pop cx
	pop si
	ret


; =================================================================
; 子程序功能: 显示字符串,字符串存储在ds:si中,以0为结束符
; 参数
; 	dh 行号 (0~24)
; 	dl 列号 (0~80)
; 	cl 颜色
; 	ds:si 指向字符串的首地址
show_str:
	push dx
	push si
	push cx
	push ax
	push bx
	
	; 计算写入字符位置的偏移地址
	mov ax, 160			; 每列的开头的偏移地址等于 列数 * 80 * 2 (每个字符占2个字节,字符一个,属性一个)
	mul dh				; 计算列偏移地址
	mov bx, ax			; bx存储字符串写入地址的偏移地址
	mov dh, 0
	add dx, dx			; 计算行偏移地址
	add bx, dx
	
	mov ax, 0b800h		; 写入到b800:0以显示字符
	mov es, ax
	mov ah, cl			; ax存储每次写入的字符
	
show_str_start:
	mov ch, 0			; 字符为0则终止子程序
	mov cl, ds:[si]
	jcxz show_str_end

	mov al, ds:[si]		; 字符ascii
	mov es:[bx], ax		; 写入字符
	
	inc si
	add bx, 2
	jmp show_str_start

show_str_end:
	pop bx
	pop ax
	pop cx
	pop si
	pop dx
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

	
code ends
end start