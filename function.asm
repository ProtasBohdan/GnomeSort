;---------------------------------------------------------------------
;  Підпрограма запису цілого числа з клавіатури з перевіркою на мінус
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
GnomeSort proc
	;Зберігаємо регістри в стек
	push BP
    mov  BP, SP
    push BX
    push SI
    push DI
	
    mov CX, count     ;заносимо в ECX кількість елементів массиву 
    xor AX, AX        ;обнулюємо АХ, який буде ітератором
    
    MainLoop:
        ;Якщо 'i' >= кількості елементів, то виходисо з  циклу
        cmp AX, CX
        jge EndLoop     
        
        ;Якщо 'i' == 0, перейти до наступного елементу
        cmp AX, 0
        je IncreaseCounter
        
        ;Якщо array[i-1] <= array[i], це означає що массив є відсортованим, отже переводимо до наступного елементу
        mov BX, array[SI]      
        mov DX, array[SI-2] 
        cmp DX, BX
        jle IncreaseCounter
        
        ;Інакше міняємо місцями array[i-1] з array[i]
        push array[SI]
        push array[SI-2]
        
        pop array[SI]
        pop array[SI-2]
        
        ;Переходимо до попереднього елементу в масиві і декрементуємо АХ
        sub SI, 2
        dec AX
        
        BackToMainLoop:
        jmp MainLoop
        
        ;Переходимо до наступного елементу в масиві і інкрементуємо АХ
    IncreaseCounter:
        inc AX
        add SI, 2
        jmp BackToMainLoop
    
    EndLoop:
    
    ;Відновлюємо регістри
	pop DI
    pop SI
    pop BX
    pop BP
	
    ret
GnomeSort endp
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
    mov dx, offset buff	
    int 21h
	
    mov dl,0ah
    mov ah,02
    int 21h
	
;обробляємо значення буфера
;адрес початку строки
    mov si, offset buff+2 
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
    PRINTN "Invalid numner!Try again."
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
	
buff   		db 6,7 Dup(?)
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

;----------------------------------------------------------------
;Процедура відкриття файлу
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

;----------------------------------------------------
;Процедура виходу з проограми
;----------------------------------------------------
ExitProgramm   PROC 
	mov  ah,0      
    mov  al,2      
    int  10h 
	
	mov ah,04Ch 	
	mov al,0h 	
	int 21h 	
ExitProgramm    ENDP
;------------------------------------------------------
;Процедура вивиду рядку символів на екран
;------------------------------------------------------
WriteStr    PROC   
     mov ah,09h
     int 21h
	 
     ret
WriteStr  ENDP    