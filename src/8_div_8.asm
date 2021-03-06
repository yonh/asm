;;; 第八章除数为8位的示例代码
;;; 当除数为8位的时候, ax保存被除数
;;; 执行div指令后进行除法运算, 商保存在al, 余数保存在ah

;;; 被除数最大值为65279

;;; 当除数为8位的时候,商也是8位, 其最大值位255
;;; 因此在忽略余数的情况下,被除数的最大值为255*255 = 65025
;;; 余数的最大值应为254, 余数不能等于除数且这里不考虑小数

;;; 因此被除数ax的最大值等于 255*255+254 = 65025+254 = 65279
;;; 根据上面可推算出 	255*255+255 - 1 => 255*256-1

;;; 我们也可用此法推算出当除数是16位的时候被除数的最大值
assume cs:code

code segment
start:
	mov ax, 65279
	mov bl, 255
	div bl
	
	mov ax, 4c00h
	int 21h
code ends

end start
