;;; 14章 实验14,访问CMOS RAM获取时间并打印出来

assume cs:code

data segment
	db '00/00/00 00:00:00',0
data ends
code segment
start:
	mov ax, data
	mov ds, ax
	
	; 年
	mov al, 9
	call get_ascii_in_cmos
	mov ds:[0], ax
	; 月
	mov al, 8
	call get_ascii_in_cmos
	mov ds:[3], ax
	; 日
	mov al, 7
	call get_ascii_in_cmos
	mov ds:[6], ax
	; 时
	mov al, 4
	call get_ascii_in_cmos
	mov ds:[9], ax
	; 分
	mov al, 2
	call get_ascii_in_cmos
	mov ds:[12], ax
	; 秒
	mov al, 0
	call get_ascii_in_cmos
	mov ds:[15], ax
	
	
	; show str
	mov bx, 0b800h
	mov es, bx
	mov di, 160*12+60
	
	mov cx, 17
	mov si, 0
l:	
	mov al, ds:[si]
	mov byte ptr es:[di], al
	inc si
	add di, 2
	loop l
	
	
	jmp start

;====================================================
;;; 从CMOS RAM中读取数据
;;; 参数: al,读取数据的单元地址
;;; 返回al,读取到的数据
get_data_in_cmos:
	out 70h, al
	in al, 71h
	ret
;====================================================
;;; 将cmos获取到的数据转为ascii码
;;; 参数: al,读取数据的单元地址
;;; 返回al,读取到的数据
get_ascii_in_cmos:
	call get_data_in_cmos
	mov ah, al
	; 获取个位
	and ah, 00001111b
	; 获取十位
	mov cl, 4
	shr al, cl
	
	add al, 30h
	add ah, 30h
	ret


code ends
end start