;;; 第10章实验10 (2)  p208
;;; 解决除法溢出问题
;;; 公式:
;;; 商 =  取商(H/N) * 65536 + [取余数(H/N) * 65536+L] / N	; H高位 L低位 N除数
;;; 余数= [取余数(H/N) * 65536+L] / N

;;; 这道题最重要是要理解高位和低位的分开计算
;;; 高位/商得出结果 商我们保留(存到栈中), 得到的余数我们让其和低位相加,得到另一个被除数(32位)
;;; 用这个被除数/除数 得到结果, 余数不变, 商再加上上面保存的商,即可算出结果
assume cs:code

code segment
start:
	mov ax, 0ffffh
	mov dx, 0ffffh
	mov cx, 2
	call divdw

	mov ax, 4c00h
	int 21h

;解决除法溢出问题
; 参数
; ax dword的低16位
; dx dword的高16位
; cx 除数
; 返回
; dx 结果高16位, ax结果低16位
; cx 余数

divdw:
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
	ret
code ends

end start