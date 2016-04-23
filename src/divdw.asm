;;; 第10章
;;; 实现数字转换为字符的子程序

assume cs:code

data segment
	dd 655650
	db 64 dup(0)
data ends

code segment
start:
	mov ax, 0d687h
	mov dx, 0e200h
	mov cx, 10
	call divdw
	
	mov ax, 4c00h
	int 21h
	
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