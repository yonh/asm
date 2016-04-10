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
	dd 100, 200, 300, 400, 500, 600, 700, 800, 900, 1000
	dd 1100, 1200, 1300, 1400, 1500, 1600, 1700, 1800, 1900,2000
	dd 2100
	;以下是21年公司的人数的21个word数据
	dw 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
	dw 11, 12, 13, 14, 15, 16, 17, 18, 19, 20
	dw 21
data ends
table segment
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
s:
	;移动年
	mov ax, [di]
	mov es:[si], ax
	mov ax, [di+2]
	mov es:[si+2], ax
	
	; 收入
	mov ax, [di+84]
	mov es:[si+5], ax
	mov dx, [di+84+2]
	mov es:[si+7], dx

	; 职员数量
	push [bx+168]
	pop es:[si+10]
	
	; 人均收入
	div word ptr es:[si+10]
	mov es:[si+13], ax
	
	add si, 16
	add di, 4
	add bx, 2
	loop s
	
	mov ax, 4c00h
	int 21h
code ends

end start
