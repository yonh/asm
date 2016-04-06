;;; 解决6.1程序中程序需要使用debug加载才能正常运行
;;; 将cs:0~16定义为数据段,程序将其位置上的数值相加,结果保存到dx
;;; end的左右除了标志程序的结束,另一功能是指明程序的入口


assume cs:code
code segment
    dw 1, 1, 1, 1, 1, 1, 1, 1
    ;; 此数据的分别为cs:0 cs:2 cs:4 cs:6 cs:8 cs:a cs:c cs:e

    ;; 此处地址为cs:10h
start:
	mov dx, 0
    mov dx, 0

    mov cx, 8
s:  add dx, cs:[bx]
    add bx, 2
    loop s

    mov ax, 4c00h
    int 21h

code ends
end start	; 指明程序的入口