;;; 第10章 10.11 p205
;;; 此处实现将内存中的字符串转为大写,字符串以0结束
;;; 子程序中可能也修改了寄存器,所以在调用子程序之前,我们需要保存当前寄存器的值,在子程序结束后恢复, 使用栈实现存储

assume cs:code
data segment
	db 'abcdefgh', 0
	db 'abcdefgh', 0
	db 'abcdefgh', 0
	db 'abcdefgh', 0
data ends
code segment
start:
	mov ax, data
	mov ds, ax
	mov bx, 0
	
	mov cx, 4
s:
	mov si, bx
	call capital
	add bx, 9
	loop s
	
	mov ax, 4c00h
	int 21h
capital:
	push cx			; 通过将参数入栈,实现不影响主程序中寄存器的值
	push si
	
change:
	mov ch, 0
	mov cl, [si]
	jcxz ok
	
	and byte ptr [si], 11011111b
	inc si
	jmp change
ok:
	pop si			; 子程序调用结束,恢复寄存器的值, 注意出栈顺序
	pop cx
	ret
	
code ends

end start
