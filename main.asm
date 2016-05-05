;********************************
;Protas Bohdan, 04.05.2016
;
;********************************
.model small
.stack 256
.data
    array 	 dw 50 dup (?)
	count	 dw	?
.code
INCLUDE io.asm
start:
    mov ax, @data
    mov ds, ax
    mov es, ax
	
	;вводимо кількість елементів масиву
	call InputInt
	mov  count, ax
	
	call GetArray
	
	
	
	call OutArray
	
	xor ax, ax
    int 16h
	
	mov ax, 4c00h
    int 21h
end start

