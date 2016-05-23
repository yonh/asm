; 编写一个用于输出寄存器值的代码到日志


;程序注意
; log.txt文件必须存在,程序并不会创建该文件


; 中间犯的错误
; 1. 读写文件长度的时候,读取缓存大小和数据结构表的不一致导致错误


assume cs:code


data segment
	filename db "myfile.txt",0
	handle dw ?
	size_buf db 100 dup(?)
	buf db '123456789',10
	findex dw 0,1111b
	
data ends

code segment
start:
	mov ax, cs
	call print_curr_csip
	
	mov al, 34h
	mov ah, 12h
	mov bh, 'X'
	mov bl, 'A'
	call print_reg_value
	
	mov ax, 4c00h
	int 21h


	mov ax, 4c00h
	int 21h
	
	
	
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
	log_file_reg db 'log.txt'
	log_handle_reg dw ?
	log_str_reg db '==??:????==',10
	log_str_len dw $-offset log_str_reg
	log_findex_reg dw 0
	alphabet_reg db '0123456789ABCDEF'
	;;;;;=========================
print_reg_value_err:
	jmp print_reg_value_ret
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
	jc print_reg_value_err
	
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
	ret

	
	
	
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
	
	
	
;=============================================
; 打印日志,输出当前cs:ip
; 参数ax: cs的值
print_curr_csip:
	push ax
	push bx
	push cx
	push dx
	push ds
	
	push cs
	pop ds
	
	jmp print_curr_csip_start
;;;;;=========================
	read_buf db 10 dup(?)
	log_file db 'log.txt'
	log_handle dw ?
	log_str	db '==????:????==',10
	log_line_len dw $-offset log_str
	log_findex dw 0
	alphabet db '0123456789ABCDEF'
;;;;;=========================
	
print_curr_csip_err:
	
	jmp print_curr_csip_ret

print_curr_csip_start:

	
	;CS:IP转换为16进制
	;获取cs:ip
	mov cx, sp
	add cx, 10
	mov bp, cx
	;push [bp]	; push ip
	;push ax		; push cs
	;pop ax
	
	; ax 段地址
	mov bx, [bp]	;偏移地址
	call set_csip
	
	
	
	
	

	;获取file handle
	mov al, 2   ;r/w
	mov ah, 3dh
	mov dx, offset log_file	; ds:dx ->filename
	int 21h
	jc print_curr_csip_err
	; file handle
	mov log_handle, ax
	
	;获取日志长度
print_curr_csip_read_start:
	; 设置文件position
	mov ah, 3fh
	mov cx, 10
	mov dx, offset read_buf
	mov bx, log_handle
	int 21h
	cmp ax, 0
	je print_curr_csip_read_done
	add log_findex, ax
	jmp print_curr_csip_read_start
print_curr_csip_read_done:	
	
	; 设置文件写入位置索引
	mov ah, 42h
	mov al,0
	mov bx, log_handle
	mov cx, 0
	mov dx, log_findex
	int 21h
	jc print_curr_csip_err
	
	; 写入内容到文件
	mov bx, log_handle
	mov cx, log_line_len
	mov dx, offset log_str
	mov ah, 40h
	int 21h
	
	;关闭文件
	mov bx, log_handle
	mov ah, 3eh
	int 21h

print_curr_csip_ret:
	pop ds
	pop dx
	pop cx
	pop bx
	pop ax
	ret

set_csip:
	push cx
	push ax
	;push bx
	
	mov cx, ax
	
	; 段地址
	mov ah, 5
	call set_csip_byte	; set al
	mov ah, 3
	mov al, ch
	call set_csip_byte	; set ah
	mov ax, bx
	; 偏移地址
	mov ah, 10
	call set_csip_byte	; set bl
	mov ah, 8
	mov al, bh
	call set_csip_byte	; set bh
	
	
	;pop bx
	pop ax
	pop cx
	ret
;;=======================================
;; 将8位寄存器转为16进制并保存到log_str
;; 参数: al 字符, ah, 位置
set_csip_byte:
	push ax
	push bx
	push cx
	
	mov bx, 0
	mov ch, ah		;保存位置
	mov cl, al		;保存字符
	
	; al低位
	and al, 00001111b
	mov bl, al
	mov al, alphabet[bx]
	mov bl, ch
	mov byte ptr log_str[bx], al
	
	; al高位
	mov al, cl
	shr al, 1
	shr al, 1
	shr al, 1
	shr al, 1
	mov bl, al
	mov al, alphabet[bx]
	mov bl, ch
	mov byte ptr log_str[bx-1], al
	
	
	pop cx
	pop bx
	pop ax
	ret
	
code ends
end start