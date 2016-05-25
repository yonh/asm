; 编写一个用于输出寄存器值的代码到日志


;程序注意
; log.txt文件必须存在,程序并不会创建该文件


; 中间犯的错误
; 1. 读写文件长度的时候,读取缓存大小和数据结构表的不一致导致错误
; 2. print_reg_value返回使用ret,因为这个程序的调用是段间转移,所以需要使用retf返回

assume cs:code

code segment

	
;=============================================
; 打印日志,输出寄存器的值
; 参数:
; ax: 寄存器的值
; bx: 寄存器字符,如bl='A', bh='X',  bx = 'AX'
print_reg_value:
	push ax
	push bx
	push dx
	push cx
	
	push cs
	pop ds
	
	jmp print_reg_value_start
	;;;;;=========================
	read_buf_reg db 10 dup(?)
	log_file_reg db 'log.txt', 0
	log_handle_reg dw ?
	log_str_reg db '==??:????==',10
	log_str_len dw $-offset log_str_reg
	log_findex_reg dw 0
	alphabet_reg db '0123456789ABCDEF'
	;;;;;=========================
print_reg_value_err:
	mov bx, 0b800h
	mov es, bx
	
	cmp ax, 1
	je err_1
	cmp ax, 2
	je err_2
	jmp err_3
err_1:
	mov byte ptr es:[160*2], '1'
err_2:
	mov byte ptr es:[160*2], '2'	; file not exists
	
err_3:
	jmp print_reg_value_err
	jmp print_reg_value_ret

print_reg_value_err2:
	mov bx, 0b800h
	mov es, bx
	mov byte ptr es:[160*2], '?'
	jmp print_reg_value_err2
	
	

print_reg_value_start:

	; 更改log_str_reg中寄存器的字符
	mov word ptr log_str_reg[2], bx
	; 将寄存器中的值转换为十六进制
	mov cx, ax
	mov ah, 8
	call set_reg_byte	; set al
	mov ah, 6
	mov al, ch
	call set_reg_byte	; set ah
	
	
	;获取file handle
	mov al, 2   ;r/w
	mov ah, 3dh
	mov dx, offset log_file_reg	; ds:dx ->filename
	int 21h
	jc print_reg_value_err
	; file handle
	mov log_handle_reg, ax
	;;;;;;;;;
	;获取日志长度
print_reg_value_read_start:
	; 设置文件position
	mov ah, 3fh
	mov cx, 10
	mov dx, offset read_buf_reg
	mov bx, log_handle_reg
	int 21h
	cmp ax, 0
	je print_reg_value_read_done
	add log_findex_reg, ax
	jmp print_reg_value_read_start
print_reg_value_read_done:	
	
	; 设置文件写入位置索引
	mov ah, 42h
	mov al,0
	mov bx, log_handle_reg
	mov cx, 0
	mov dx, log_findex_reg
	int 21h
	jc print_reg_value_err2
	
	; 写入内容到文件
	mov bx, log_handle_reg
	mov cx, log_str_len
	mov dx, offset log_str_reg
	mov ah, 40h
	int 21h
	
	;关闭文件
	mov bx, log_handle_reg
	mov ah, 3eh
	int 21h

	
print_reg_value_ret:
	pop cx
	pop dx
	pop bx
	pop ax
	retf

	
;;=======================================
;; 将8位寄存器转为16进制并保存到log_str_reg
;; 参数: al 字符, ah, 位置
set_reg_byte:
	push ax
	push bx
	push cx
	
	mov bx, 0
	mov ch, ah		;保存位置
	mov cl, al		;保存字符
	
	; al低位
	and al, 00001111b
	mov bl, al
	mov al, alphabet_reg[bx]
	mov bl, ch
	mov byte ptr log_str_reg[bx], al
	
	; al高位
	mov al, cl
	shr al, 1
	shr al, 1
	shr al, 1
	shr al, 1
	mov bl, al
	mov al, alphabet_reg[bx]
	mov bl, ch
	mov byte ptr log_str_reg[bx-1], al
	
	
	pop cx
	pop bx
	pop ax
	ret

code ends