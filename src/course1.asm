;;; 第八章实验7 p172
;;; 

assume cs:code

data segment
	; 以下是21年的21个字符串;共占84个字节
	; 每个字符占1个字节 '1975'则占4个字节
	db '1975','1976','1977','1978','1979','1980','1981','1982','1983','1984'
	db '1985','1986','1987','1988','1989','1990','1991','1992','1993','1994'
	db '1995'
	
	; 以下是21年公司的收入的21个dword数据
	dd 1000, 2000, 3000, 4000, 5000, 6000, 7000, 8000, 9000, 10000
	dd 11000, 12000, 13000, 14000, 15000, 16000, 17000, 18000, 19000,20000
	dd 21000
	;以下是21年公司的人数的21个word数据
	dw 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
	dw 11, 12, 13, 14, 15, 16, 17, 18, 19, 20
	dw 21
data ends
table segment
	db 1680 dup (0)
	db 21 dup ('year summ ne ?? ')
table ends


code segment
start:
	mov ax, data	; 从哪读取数据
	mov ds, ax
	
	mov ax, table	; 数据放到哪去
	mov es, ax
	
	mov cx, 21
	mov si, 0		; 保存当前年份的索引,用来索引该年相应的数据
	mov di, 0		; 保存每次循环当年记录的偏移地址的基址,通过es:[si+idata]定位不同数据的位置,每次循环si+=16,指向下一年的数据段开始的位置
	mov bx, 0		; 记录每次当年的职员数量的偏移位置
	

	call write_years	; 年
	call write_income	; 收入
	call write_count	; 雇员数
	call write_avg		; 平均
	call print			; 输出

l_pause:
	jmp l_pause
	
	mov ax, 4c00h
	int 21h

print:
	mov cx, 1680
	mov dx, 0

	mov si, 0
	mov di, 0
	mov ax, table
	mov ds, ax
	mov ax, 0b800h
	mov es, ax
l_print:
	; 将字符写入到显示区域
	mov ah, 0fh
	mov al, ds:[di]
	mov es:[si], ax
	inc di
	add si, 2
	loop l_print
	ret
; 将年的数据写入table
write_years:
	mov ax, data	; 年数据段
	mov ds, ax
	mov ax, table
	mov es, ax		; table段
	
	; 写入年到输出源
	mov cx, 21
	mov si, 0		; 数据段中的偏移地址
	mov di, 0		; table段中的偏移地址

	; 便利年数据段, 将数据移到table段对应的位置
l_years:
	mov ax, ds:[di]
	mov es:[si], ax
	mov ax, ds:[di+2]
	mov es:[si+2], ax	; 移动数据
	
	add di, 4
	add si, 80
	loop l_years
	
	ret

write_income:
	mov ax, data
	mov es, ax
	mov ax, table
	mov ds, ax

	mov si, 20
	mov di, 84
	mov cx, 21
l_income:
	mov ax, es:[di]
	mov dx, es:[di+2]
	call dtoc
	call rev_str
	add si, 80
	add di, 4
	loop l_income
	
	ret

write_count:
	mov ax, data
	mov es, ax
	mov ax, table
	mov ds, ax

	mov si, 40
	mov di, 168
	mov cx, 21
l_count:
	mov ax, es:[di]
	mov dx, 0
	call dtoc
	call rev_str
	add si, 80
	add di, 2
	loop l_count
	
	ret

write_avg:
	mov di, 84
	mov si, 60
	mov cx, 21
	mov bp, 168
l_avg:
	push cx
	mov ax, table
	mov ds, ax
	mov ax, data
	mov es, ax
	
	; 获取收入
	mov ax, es:[di]
	mov dx, es:[di+2]
	; 获取雇员数
	mov cx, es:[bp]
	; 计算平均数
	call divdw
	call dtoc
	call rev_str
	
	add si, 80
	add di, 4
	add bp, 2
	pop cx
	loop l_avg
	
	ret
	
clear_table:
	push ax
	push es
	push cx
	push si
	
	mov ax, table
	mov es, ax
	mov cx, 40
	mov si, 0

clear_table_loop:
	mov ax, 0
	mov es:[si], ax
	add si, 2
	loop clear_table_loop
	
	pop si
	pop cx
	pop es
	pop ax
	ret

; =================================================================
; 子程序功能: 将word型数据转变为是10进制的字符串,字符串结尾以0结束
; 参数 ax:低16位, dx:高16位
; ds:si指向字符串首地址
dtoc:
	push si
	push cx
	push dx
	push bx

dtoc_start:
	mov cx, 10
	call divdw
	; 判断商是否为0 (dx, ax)
	push cx
	mov cx, ax
	add cx, dx
	jcxz dtoc_end
	pop cx
	
	add cx, 30h
	mov byte ptr ds:[si], cl
	inc si
	
	jmp dtoc_start

dtoc_end:
	pop cx
	add cx, 30h
	mov byte ptr ds:[si], cl
	inc si
	mov byte ptr ds:[si], 0
	inc si

	pop bx
	pop dx
	pop cx
	pop si
	ret

; =================================================================
; 子程序功能: 反转字符串
; 参数: ds:si指向字符串首地址,0为结束

; 注意地方
; 1.一个字符的时候没必要反转
; 2.注意字符串长度,div的时候不要使用bx
; 3.注意字符串起始地址,好容易陷入使用0作为开始偏移地址的陷阱

; 这里还只用到比较jcxz实现判断
rev_str:
	push si
	push ax
	push bx
	push cx
	push dx
	
	mov dx, si	; 记录字符串首地址
	mov cx, 0
	mov bx, 0	; 记录字符串长度
rev_str_start:
	; 计算字符串长度,保存在bx
	mov cl, ds:[si]
	jcxz cal_loop_len
	inc bx
	inc si
	jmp rev_str_start
	
cal_loop_len:
	; 判断是否只是只有一个字符只有一个字符不需要反转
	mov cx, bx
	dec cx
	jcxz rev_str_end
	mov cx, 0
	
	;计算循环次数
	dec si
	mov ax, bx
	mov bx, 2
	div bl
	mov cl, al
	mov bx, dx		; 获取字符串首地址
rev_str_main:
	mov al, ds:[bx]
	mov ah, ds:[si]
	mov byte ptr ds:[si], al
	mov byte ptr ds:[bx], ah
	inc bx
	dec si
	loop rev_str_main
rev_str_end:
	pop dx
	pop cx
	pop bx
	pop ax
	pop si
	ret

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