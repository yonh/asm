;;; 第11章movsb代码示例
;;; 将data段第一行数据传送到第二行的位置
assume cs:code

data segment
	db 'welcome to masm!'
	db 16 dup(0)
data ends

code segment
start:
	mov ax, data
	mov ds, ax
	mov es, ax
	mov si, 0
	mov di, 16
	
	cld				; 设置df=0,正向传送
	mov cx, 16
	rep movsb		; 传送数据,每次传送1个字节,传送16次
	
	mov ax, 4c00h
	int 21h

code ends
end start