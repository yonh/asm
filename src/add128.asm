;;; 128位的数据相加

assume cs:code

data segment
	;dw 1,1,1,1,1,1,1,1
	;dw 1,1,1,1,1,1,1,1
	dw 0ffffh,0ffffh,0ffffh,0ffffh,0ffffh,0ffffh,0ffffh,0ffffh
	dw 0ffffh,0ffffh,0ffffh,0ffffh,0ffffh,0ffffh,0ffffh,0ffffh
data ends

code segment
start:
	mov ax, data
	mov ds, ax
	mov si, 0
	mov di, 16
	call add128
	
	mov ax, 4c00h
	int 21

; =================================================================
; 子程序功能: 对2个128位的数据进行相加
; 参数
;	ds:si指向第一个数的内存空间,大小16个字节
;	ds:di指向第二个数的内存空间,大小16个字节
; 返回
;	ds:[si]后的18个字节表示返回结果(多出的2个字节用于表示相加后的进位值)
add128:
	push ax
	push cx
	push si
	push di
	
	sub ax, ax		;cf=0
	
	mov cx, 8
l_add128:
	mov ax, [si]
	adc ax, [di]
	mov [si], ax
	inc si			; 此处不能使用add指令实现,会导致cf的值被更改,导致丢失进位数据
	inc si
	inc di
	inc di
	loop l_add128
	mov word ptr [si], 0
	adc word ptr [si], 0
	
	pop di
	pop si
	pop cx
	pop ax
	ret
code ends


end start