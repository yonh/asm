;;; ʹ��loop����(ffff:0006)*123,���������dx��

assume cs:code
code segment
	mov ax, 0ffffh	; �ڻ���г�����,���ݲ�������ĸ��ͷ���Բ�0
	mov ds, ax
	mov bx, 6
	
	mov al, [bx]	; al = ds:bx��ֵ
	mov ah, 0

	mov dx, 0
	mov cx, 123		; ѭ��123��

	s: add dx, ax
	loop s

	mov ax, 4c00h
	int 21h
code ends
end
