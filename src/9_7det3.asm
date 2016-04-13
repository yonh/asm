;;; 第9章9.7监测点 1 p183
;;; 程序执行jmp后cs的值是多少
;;; cs: 0006, ip: 00be

assume cs:code

data segment
	db 0beh,00,06,00
data ends

code segment
start:
	mov ax, data
	mov es, ax
	jmp dword ptr es:[0]

	mov ax, 4c00h
	int 21h
code ends

end start
