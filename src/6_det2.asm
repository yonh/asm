;;; 将内存中0:0~0e中的内容放到程序中(cs:0~cs:e)
;;; 使用栈实现
assume cs:codesg
codesg segment
    dw 0, 0, 0, 0, 0, 0, 0, 0   ; 存储数据
    dw 0, 0, 0, 0, 0, 0, 0, 0   ; 栈空间

start:
    mov ax, cs
    mov ss, ax
    mov sp, 20h     ; 栈顶

    mov ax, 0
    mov ds, ax
    mov bx, 0
    mov cx, 8

s:  push [bx]
    pop cs:[bx]
    add bx, 2
    loop s

    mov ax, 4c00h
    int 21h
codesg ends
end start