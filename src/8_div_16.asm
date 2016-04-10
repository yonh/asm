;;; 第八章除数为16位的示例代码
;;; 当除数为16位的时候, 被除数需要等于32位,所以高16位会被dx保存, 低16位会被ax保存
;;; 执行div指令后进行除法运算, 商保存在ax, 余数保存在dx
;;; 所以程序执行后我们会看到 ax的值等于fd70h, dx等于40h

;;; 整个除数的最大值不超过FFFE FFFFh (4294901759)
;;; 因为商和余数的最大值为16位,因此被除数的最大值应不超过65535*65536-1
;;; 同时计算的时候也需要考虑,不能让商的值大于65535, 否则会出现溢出

assume cs:code

code segment
start:
	mov dx, 99		; 十进制表示: 99 * 65536+ 0 / 100 = 商64880 余 64
	mov ax, 0		; 十六进制表示: 63h * 10000h + 0 / 64h = 商FD70h 余40h
	mov bx, 100
	div bx
	
	mov ax, 4c00h
	int 21h
code ends

end start
