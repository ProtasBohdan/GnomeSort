;---------------------------------------------------------------------
;  Підпрограма запису цілого числа з клавіатури з перевіркою на знак
;---------------------------------------------------------------------
;	Параматри
;  		ax - введене число
;---------------------------------------------------------------------
InputPInt proc
;збереження значень регістрів у стек
    push dx
    push bx
    push cx
    push si
    push di
    push ds
    push cs
    pop ds
;при невдалому введенні спробувати знову
@@again:
	PRINT "==> "
	;функція вводу символу з клавіатури
    mov ah,0ah
    xor di,di
    mov dx, offset @@buff	
    int 21h
	
    mov dl,0ah
    mov ah,02
    int 21h
;обробляємо значення буфера
;адрес початку строки
    mov si, offset @@buff+2 
    cmp byte ptr [si], "-"	;перевірка першого символу на мінус
    jnz @@ii1
	jmp @@er
@@ii1:
    xor ax, ax
    mov bx, 10				;ініціалізація основи системи числення  
@@ii2:
    mov cl,[si] 			;беремо символ з буферу
    cmp cl,0dh  			;перевіряємо, чи не останній він
    jz @@enddecin
;якщо символ не останній, перевіряємо на правильність вводу
    cmp cl,'0'  
    jl @@er
    cmp cl,'9'  
    ja @@er
 ;перетворюємо символ в 10-ве число
    sub cl,'0'
    mul bx   
    add ax,cx
    inc si    
    jmp @@ii2  
;вивід повідомлення про помилку вводу
@@er:  
    PRINTN "Invalid number!Try again."
    jmp @@again
@@enddecin:
;відновлюємо значення регістів
    pop ds
    pop di
    pop si
    pop cx
    pop bx
    pop dx
    ret							
@@buff   		db 6,7 Dup(?)
InputPInt endp
;---------------------------------------------------------------------
;Підпрограма запису відповіді в файл
;---------------------------------------------------------------------
;Параматри:
;	нічого
;---------------------------------------------------------------------
InputToFile proc
	;Відкриваємо файл
	mov ah,3ch
	xor cx, cx
	lea dx, fn
	int 21h
	;При помилці відкриття виходимо
	jc @exit
	mov dscr, ax
	mov si, 0		;ітератор
	mov di, count
	;ініціалізуємо цикл
@@again:
	cmp di, 0
	je @exit
	;вибираємо число з масиву
	xor cx,cx
	mov ax, array[si]
	add si, 2
	;якщо число відємне, то приводимо його до відповідного типу
	test ax, ax
	jns pos
	neg ax
	
	push ax
	push bx
	push cx
	push dx
	
	mov ah, 40h
	mov bx, dscr
	mov cx, 1
	mov dx, offset minus
	int 21h
	
	pop dx
	pop cx
	pop bx
	pop ax
	;інакше продовжуємо
pos:
	;перетворюємо число
	mov bx, 10
div10:
	xor dx,dx
	div bx
	push dx
	inc cx
	or ax, 0
	jnz div10
	mov dx, cx
	xor bx, bx
nxt:
	pop ax
	add ax, 30h
	mov buf[bx], ax
	inc bx
	loop nxt
;записуємо переведене число в файл
	mov ah, 40h
	mov bx, dscr
	mov cx, dx
	lea dx, buf
	int 21h
	;записуємо пробіл
	mov ah, 40h
	mov bx, dscr
	mov cx, 1
	mov dx, offset space
	int 21h

;декрементуємо di та при необхідності повторюємо
	dec di
	jmp @@again

@exit:
    ret
	
InputToFile endp
	
;--------------------------------------------------------------------
;Підпрограма сортування масиву DWORD алгоритмом "гнома"
;-------------------------------------------------------------------
;Параматри:
;	array - покажчик на масиву
;	count - кількість елементів у масиві
;--------------------------------------------------------------------

;--------------------------------------------------------------
;  Підпрограма запису цілого 10-числа з клавіатури
;--------------------------------------------------------------
;	Параматри
;  		ax - введене число
;--------------------------------------------------------------
InputInt proc
;збереження значень регістрів у стек
    push dx
    push bx
    push cx
    push si
    push di
    push ds
    push cs
    pop ds
	
;при невдалому введенні спробувати знову
again:
	PRINT "==>"
	
	;функція вводу символу з клавіатури
    mov ah,0ah
    xor di,di
    mov dx, offset buffs	
    int 21h
	
    mov dl,0ah
    mov ah,02
    int 21h
	
;обробляємо значення буфера
;адрес початку строки
    mov si, offset buffs+2 
    cmp byte ptr [si], "-"	;перевірка першого символу на мінус
    jnz ii1
    mov di,1  
    inc si    
ii1:
    xor ax,ax
    mov bx,10				;ініціалізація основи системи числення  
ii2:
    mov cl,[si] 			;беремо символ з буферу
    cmp cl,0dh  			;перевіряємо, чи не останній він
    jz enddecin
    
;якщо символ не останній, перевіряємо на правильність вводу
    cmp cl,'0'  
    jl er
    cmp cl,'9'  
    ja er
	
 ;перетворюємо символ в 10-ве число
    sub cl,'0'
    mul bx   
    add ax,cx
    inc si    
    jmp ii2  
	
;вивід повідомлення про помилку вводу
er:  
    PRINTN "Invalid number!Try again."
    jmp again
;якщо встановлений флаг, то робимо число відємним
enddecin:
    cmp di,1 
    jnz ii3
    neg ax   
ii3:
;відновлюємо значення регістів
    pop ds
    pop di
    pop si
    pop cx
    pop bx
    pop dx
	
    ret							
	
buffs   		db 6,7 Dup(?)
InputInt endp
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
;-------------------------------------------------------------
; Підпрограма заповнення массива з клавіатури
;-------------------------------------------------------------
; Параматри:
; 	сх  - кількість елементів у масиві
;-------------------------------------------------------------
GetArray proc
    mov cx, count   ;довжина массива
    mov bx, 0		;ітератор
@@1:
    call InputInt
    mov array[bx], ax
    add bx, 2
    loop @@1
	
    ret
GetArray endp

;------------------------------------------------------------
; Підпрограма виводу масиву на консоль
;------------------------------------------------------------
; Параматри
;	сх - довжина массива
;------------------------------------------------------------
OutArray proc
	cmp count, 0
	je @@Exit
	
    mov cx, count   ;довжина массива
    mov bx, 0
    mov dl, ' '
@@2:
    mov ax, array[bx]
    call OutInt
    mov ah, 2
    int 21h
	
    add bx, 2
    loop @@2
@@Exit:
    ret
OutArray endp

;-----------------------------------------------------------------
;Процедура відкриття файлу
;-----------------------------------------------------------------
;Параматри
; 	немає
;-----------------------------------------------------------------
OpenFileRead    PROC   	
	mov ah,3dh		
	mov al,0		
	int 21h
	
	ret			
OpenFileRead    ENDP              

;-------------------------------------------------------------
;Процедура закриття файлу
;------------------------------------------------------------
;Параматри:
;   BX декриптор файла
;-------------------------------------------------------------
CloseFile    PROC   
     	mov ah,3eh		
		int 21h
		ret			
CloseFile    ENDP  

;------------------------------------------------------------------
;Процедура виходу з проограми
;------------------------------------------------------------------
;Параматри:
;	немає
;----------------------------------------------------
ExitProgramm   PROC 
	mov  ah,0      
    mov  al,2      
    int  10h 
	
	mov ah,04Ch 	
	mov al,0h 	
	int 21h 	
ExitProgramm    ENDP
;------------------------------------------------------------------------
;Процедура вивиду рядку символів на екран
;------------------------------------------------------------------------
;Параматри:
;	bx - символ для виводу
;------------------------------------------------------------------------
WriteStr    PROC   
     mov ah,09h
     int 21h
	 
     ret
WriteStr  ENDP
  
;-----------------------------------------------------------------------
;функція читання з файлу
;----------------------------------------------------------------------
ReadFromFile proc
	;open file
	mov dx, offset fname
	call OpenFileRead
	;jc Error
	mov handle, ax
	
	mov buff, 0
  	mov position, 0	;position in the file
	xor si, si		;iterator for main array
	xor di, di		;pointer for negative digit
	
@@again:
	;--------------------------------------------------------------------
	;counter to correct position
	mov bx, handle
	mov al, 0
	mov cx, 0
	mov dx, position			;start position
	mov ah, 42h
	int 21h
	;jc @@Error
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
	jne @@postv
	mov di, 1
	jmp @@again
	
@@postv:
;checking for space
	cmp t_buff, ' '
	jne @@cont
	
;if space load an array and reset the buff
	cmp position, 3
	jne @@ncount
	push buff
	pop  count
	mov buff, 0
	jmp @@again
@@ncount:
	cmp di,1 
    jne @@pos
	mov bx, buff
    neg bx
	mov buff, bx
@@pos:

	mov bx, buff
	mov array[si], bx
	add si, 2			;shift array index
	mov buff, 0
	xor di, di
	jmp @@again
	
@@cont:
	xor ch, ch
	mov cl, t_buff
	
	;перевіряємо на правильність вводу
    cmp cl,'0'  
    jl Exit
    cmp cl,'9'  
    ja Exit
	
	;початкові установки
    mov bx, 10				;ініціалізація основи системи числення  

 ;перетворюємо символ в 10-ве число
    sub cl,'0'
	xor ch, ch
	
	mov ax, buff
	mul bx
	add ax, cx
	mov buff, ax
	
	jmp @@again
Exit:
	mov bx, handle
	Call CloseFile
	jc Exit
	ret
ReadFromFile endp