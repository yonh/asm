;;; 使用多个段实现反转data段的数据

assume cs:code, ds:data, ss:stack
; 数据段
data segment
    dw 1, 2, 3, 4, 5, 6, 7, 8
data ends
; 栈段
stack segment
    dw 0, 0, 0, 0, 0, 0, 0, 0
	dw 0, 0, 0, 0, 0, 0, 0, 0	; 猜测是因为cpu的某些机制问题，这里的栈的大小不能定义为16个字节，而是要定义为更大的32个字节
stack ends
; 代码段
code segment
start:
    mov ax, stack
    mov ss, ax
    mov sp, 20h     ; 栈顶

    mov ax, data
    mov ds, ax      ; ds指向数据段

    mov bx, 0       ; ds:bx 指向data段的第一个单元

    mov cx, 8
s:  push [bx]
    add bx, 2
    loop s          ; 将data段段中的8个字型数据入栈

    mov bx, 0
    mov cx, 8
s0: pop [bx]
    add bx, 2
    loop s0         ; 将栈中的数据出栈设置数据到data段

    mov ax, 4c00h
    int 21h
code ends
end start