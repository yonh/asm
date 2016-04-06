;;; 将cs:0~16定义为数据段,程序将其位置上的数值相加,结果保存到dx
;;; 但是这样程序就不能正常启动,需要使用debug加载程序,并将ip设置为10h


assume cs:code
code segment
    dw 1, 1, 1, 1, 1, 1, 1, 1
    ;; 此数据的分别为cs:0 cs:2 cs:4 cs:6 cs:8 cs:a cs:c cs:e

    ;; 此处地址为cs:10h
    mov bx, 0
    mov dx, 0

    mov cx, 8
s:  add dx, cs:[bx]
    add bx, 2
    loop s

    mov ax, 4c00h
    int 21h

code ends
end