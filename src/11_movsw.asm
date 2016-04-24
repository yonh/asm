;;; 第11章movsw代码示例
;;; 将f000h段中的最后16个字节传送到data段

;;; 逆向传送的时候注意di和si的位置,应该指向需要传送数据的最后一个数据的低位的单元地址
assume cs:code

data segment
	db 16 dup(0)
data ends

code segment
start:
	mov ax, 0f000h
	mov ds, ax
	mov ax, data
	mov es, ax
	mov si, 0fffeh
	mov di, 0eh
	
	std				; 设置df=1,逆向传送
	mov cx, 8
	rep movsw		; 传送数据
	
	mov ax, 4c00h
	int 21h

code ends
end start