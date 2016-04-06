;;; 将内存中0:0~0e中的内容放到程序中(cs:0~cs:e)
assume cs:codesg
codesg segment
    dw 0, 0, 0, 0, 0, 0, 0, 0
start:
    mov ax, 0
    mov ds, ax
    mov bx, 0

    mov cx, 8
s:  mov ax, [bx]
    mov cs:[bx], ax
    add bx, 2
    loop s

    mov ax, 4c00h
    int 21h
codesg ends
end start