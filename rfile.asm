.model small
.stack 256h
.data
	array   dw  50 dup (?)
	count	dw	0
	fname 	db 'data.txt', 0h
	handle  dw '?'
	buff	dw '?'
	position dw 0
	t_buff db ?
.code
LOCALS @@
JUMPS
INCLUDE macro.asm

start:
	mov ax, @data
    mov ds, ax
	
	
	;open file
	mov dx, offset fname
	call OpenFileRead
	jc Error
	mov handle, ax
	
	mov buff, 0
  	mov position, 0	;position in the file
	xor si, si		;iterator for main array
	xor di, di		;pointer for negative digit
	
again:
	;--------------------------------------------------------------------
	;counter to correct position
	mov bx, handle
	mov al, 0
	mov cx, 0
	mov dx, position			;start position
	mov ah, 42h
	int 21h
	jc error
	inc position	;shift the position in file
	
	;read from file
	mov bx, handle
	mov ah, 3fh
	mov cx, 1			;how many symbols to read
	mov dx, offset t_buff
	int 21h
	
;checking for end of file
	cmp t_buff, '$'
	je Exit
;checking fo negative digit
	cmp t_buff, '-'
	jne postv
	mov di, 1
	jmp again
postv:
;checking for space
	cmp t_buff, ' '
	jne cont
	
;if space load an array and reset the buff
	cmp position, 4
	jne ncount
	
	push buff
	pop  count
	inc position
	jmp again
ncount:
	cmp di,1 
    jnz pos
	mov bx, buff
    neg bx
	mov buff, bx
pos:

	mov bx, buff
	mov array[si], bx
	add si, 2			;shift array index
	mov buff, 0
	xor di, di
	jmp again
	
cont:
	xor ch, ch
	mov cl, t_buff
	
	;перевіряємо на правильність вводу
    cmp cl,'0'  
    jl Error
    cmp cl,'9'  
    ja Error
	
	;початкові установки
    mov bx, 10				;ініціалізація основи системи числення  

 ;перетворюємо символ в 10-ве число
    sub cl,'0'
	xor ch, ch
	
	mov ax, buff
	mul bx
	add ax, cx
	mov buff, ax
	
	jmp again

Exit:
	
	
	mov bx, handle
	Call CloseFile
	jc Error
	
	mov ax, buff
	call OutInt
	
	call ExitProgramm

Error:
	PRINTN "error"
	jmp Exit

ExitProgramm   PROC
	mov ah,04Ch 	
	mov al,0h 	
	int 21h 	
ExitProgramm    ENDP
OpenFileRead    PROC   
     mov ah,3dh		
	mov al,0		
	int 21h
	ret			
OpenFileRead    ENDP
CloseFile    PROC   
    mov ah,3eh		
	int 21h
	ret			
CloseFile    ENDP  

;--------------------------------------------------------------
;Підпрограма виводу цілого 10-го числа
;--------------------------------------------------------------
; Параматри:
;  ах - чило для виводу
;--------------------------------------------------------------
OutInt proc
;Зберігаємо значення регістрів
    push ax
    push dx
    push bx
    push cx
    push ds
    push di
    push cs
    pop ds
	;Перевіряємо число на знак
    test ax, ax
    jns oi1
    mov di, 1
    neg ax
oi1:
    xor cx, cx
    mov bx, 10				;основа СЧ
oi2:
    xor dx, dx
    div bx
    add dx, '0'
    push dx					;зберігаємо значення в стек
    inc cx
	;Відділяємо цифру справа поки не залишиться 0
    test ax, ax
    jne oi2
	;Виводимо отримане значення
    mov ah, 2
    cmp di, 1
    jne oi3
	;При відємному числі виводимо знак '-'
    mov dl, '-'
    int 21h
oi3:
    pop dx					;Виштовхеємо цифру, переводимо її в символ і виводимо
    int 21h
    loop oi3				;повторюємо стільки разів, скільки цифр було нараховано
;Відновлюємо значення регістрів
    pop di
    pop ds
    pop cx
    pop bx
    pop dx
    pop ax
	
    ret
OutInt endp




end start	
	