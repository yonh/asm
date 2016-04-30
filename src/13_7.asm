;;; 13.7 DOS中断例程应用
;;; 调用21h号中断的9号程序
;;; 例程作用:输出一行字符串,字符串以$表示结束
assume cs:code

data segment
	db 'welcome to masm!$'
data ends
code segment
start:
	; 设置光标位置于 12行30列
	mov ah, 2
	;mov bh, 0	; 暂时不知设置第0页有何用
	mov dh, 12
	mov dl, 30
	int 10h
	
	; 调用21h号中断的9号程序,输出字符串
	mov ax, data
	mov ds, ax
	mov dx, 0
	mov ah,9
	int 21h
s:	nop
	jmp s
code ends

end start