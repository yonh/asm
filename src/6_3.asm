;;; 利用栈,将0-e的数据反转

assume cs:code
code segment
	dw 1, 2, 3, 4, 5, 6, 7, 8   ; 数据  0~f
	dw 0, 0, 0, 0, 0, 0, 0, 0   ; 栈    10~1f

start:
    mov ax, cs
    mov ss, ax
    mov sp, 20h     ; 设置栈顶

    mov bx, 0
    mov cx, 8
s:  push cs:[bx]
    add bx, 2
    loop s          ; 将0~e单元中的字型数据入栈

    mov bx, 0
    mov cx, 8
s0: pop cs:[bx]
    add bx, 2
    loop s0         ; 将栈中数据出栈,放到0~e单元中

    mov ax, 4c00h
    int 21h
code ends
end start           ; 指明程序入口