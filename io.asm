;--------------------------------------------------
;  Підпрограма вводу цілого 10-числа з клавіатури
;  ax - введене число
;--------------------------------------------------
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

	mov dx, offset inp_message
    mov ah, 09
    int 21h
	
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
    mov dx, offset error
    mov ah,09
    int 21h
	
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
	
error 		db 'incorrect number', 0ah, 0dh, '$'
inp_message db 'Enter digit: $'
buff    db 6,7 Dup(?)
InputInt endp
 
 
 ;---------------------------------------------------
 ;  Підпрограма виводу цілого 10-го числа
 ;  ах - чило для виводу
 ;---------------------------------------------------
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
;Ділимо число на основу СЧ. В залишку
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
;-------------------------------------------
; Процедуро заповнення массива з клавіатури
; сх  - кількість елементів массива
;-------------------------------------------
GetArray proc
    mov cx, count   ;длинна массива
    mov bx, 0	;ітератор
@@1:
    call InputInt
    mov array[bx], ax
    add bx, 2
    loop @@1
	

    ret
GetArray endp

;---------------------------------------------
;Процедура виводу масиву на консоль
;сх - довжина массива
;---------------------------------------------
OutArray proc
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
	
    ret
OutArray endp
	


 
 
 