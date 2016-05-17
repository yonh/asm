; 编写一个用于输出下一句代码的CS:IP到日志的程序


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
	
	mov ax, 4c00h
	int 21h


	mov ax, 4c00h
	int 21h
	
	
	
	

	
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
	mov bx, sp
	add bx, 10
	mov bp, bx
	push [bp]	; push ip
	push ax		; push cs
	pop ax
	
	call set_csip_byte
	
	
	
	;mov byte ptr log_str[5], 30h
	pop ax
	
	
	
	

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
	
;;=======================================
;; 将8位寄存器转为16进制并保存到log_str
;; 参数: ax
set_csip_byte:
	push ax
	push bx
	
	; al低位
	push ax
	and al, 00001111b
	mov bx, 0
	mov bl, al
	mov al, alphabet[bx]
	mov byte ptr log_str[5], al
	pop ax
	
	; al高位
	push ax
	shr al, 1
	shr al, 1
	shr al, 1
	shr al, 1
	mov bx, 0
	mov bl, al
	mov al, alphabet[bx]
	mov byte ptr log_str[4], al
	pop ax
	
	; ah低位
	push ax
	and ah, 00001111b
	mov bx, 0
	mov bl, ah
	mov ah, alphabet[bx]
	mov byte ptr log_str[3], ah
	pop ax
	
	; ah高位
	push ax
	shr ah, 1
	shr ah, 1
	shr ah, 1
	shr ah, 1
	mov bx, 0
	mov bl, ah
	mov ah, alphabet[bx]
	mov byte ptr log_str[2], ah
	pop ax
	
	pop bx
	pop ax
	ret

	
	
	
	
	
	
code ends
end start