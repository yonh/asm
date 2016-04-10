;;; p171 问题8.1代码
;;; 计算data段中第一个数据初一第二个数据后的结果,商存于第三个数据的存储单元中

assume cs:code, ds:data

data segment
	dd 100001
	dw 100
	dw 0
data ends

code segment
start:
	mov ax, data
	mov ds, ax
	mov ax, ds:[0]
	mov dx, ds:[2]
	div word ptr ds:[4]
	mov ds:[6], ax
	
	mov ax, 4c00h
	int 21h
code ends

end start
