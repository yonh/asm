;;; 第10章 10.11 p203
;;; 将参数存在内存中
;;; 将参数存到内存中,子程序需要知道2个内容,参数在哪和参数的长度
;;; 此处实现将内存中的字符串转为大写,字符串以0结束

assume cs:code
data segment
	db 'abcdefgh', 0
data ends
code segment
start:
	mov ax, data
	mov ds, ax
	mov si, 0
	
	call capital
	
	mov ax, 4c00h
	int 21h
capital:
	mov ch, 0
	mov byte ptr cl, [si]
	jcxz ok
	
	and byte ptr [si], 11011111b
	inc si
	loop capital
ok:	ret
	
code ends

end start
