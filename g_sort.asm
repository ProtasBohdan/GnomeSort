.model small
.stack 256h
.data
    array   dw  50 dup (?)
	count	dw	0
	fn 		db 'answer.txt', 0
	dscr    dw ?
	space	dw ' '
	minus 	dw '-'
	endfl	dw '$'
	buf 	dw 5 dup (?)
	
	fname 	db 'data.txt', 0h
	handle  dw '?'
	buff	dw '?'
	position dw 0
	t_buff db ?
.code
LOCALS @@			;для використання локальних міток в процедурах
JUMPS				;для виконання стрибку понад 128 байт
INCLUDE macro.asm	;підключення файлу з макросами

start:
	mov ax, @data	
    mov ds, ax
    ;mov es, ax
	
	;Вивід початкового меню
_again:
	call ShowMenu
	call InputPInt
	
	cmp ax, 1
	je SetUp
	cmp ax, 2
	je Rmfile
	cmp ax, 3
	je PrintMas
	
	cmp ax, 4
	je Sorted
	
	cmp ax, 5
	je SaveAnswer
	cmp ax, 6
	je _eexit
	
	jmp _again
	;ініціалізація початкових данних
SetUp:
	PRINT "Enter the number of element in massive "
	call InputPInt
	mov count, ax
	
	PRINTN "Enter the elements of massive: "
	call GetArray
	
	PRINTN "Digit successfully inputed! "
	xor ax, ax			;Зачекати на нажаття клавіші
    int 16h
	jmp _again
Rmfile:
	call ReadFromFile
	PRINTN "Array successfully readed! "
	xor ax, ax			;Зачекати на нажаття клавіші
    int 16h
	jmp _again
	
	;виведення массиву на екан
PrintMas:
	PRINT "Array at the moment { "
	call OutArray
	PRINT "}"
	xor ax, ax			;Зачекати на нажаття клавіші
    int 16h
	jmp _again
	;Виклик процедури сортування
Sorted:
	push BP
    mov  BP, SP
    push BX
    push SI
    push DI
	
	;xor si, si
    mov CX, count     ;заносимо в ECX кількість елементів массиву 
    xor AX, AX        ;обнулюємо АХ, який буде ітератором
	xor si, si
    
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
	PRINTN "Array successfully sorted!"
	xor ax, ax			;Зачекати на нажаття клавіші
    int 16h
	
	jmp _again
	;збереження відповіді в файл
SaveAnswer:
	call InputToFile
	
	PRINTN "Array  will be saved..."
	xor ax, ax			;Зачекати на нажаття клавіші
    int 16h
	jmp _again
_eexit:
	call ExitProgramm
	
INCLUDE function.asm	;Підключення файлу з основними функціями, які використовуються даною програмою
;Підпрограмма виводу 
ShowMenu proc

    mov  ah,0      
    mov  al,2      
    int  10h       
	
	PRINTN "                                 <<MENU>>                                     "
	PRINTN "=============================================================================="
	PRINTN "     Supported command;                                                       "
	PRINTN "  <1> -- Input array from keyboard;                                           "
	PRINTN "  <2> -- Input array from file;                                               "
	PRINTN "  <3> -- Show array;                                                          "
	PRINTN "  <4> -- Sorted array;                                                        "
	PRINTN "  <5> -- Save array to file 'answer.txt';                                     "
	PRINTN "  <6> -- Exit;                                                                "
	PRINTN "=============================================================================="
	PRINT  "Command "
	
	ret
ShowMenu endp
end start



