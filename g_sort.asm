.model small
.stack 256h
.data
    array   dw  50 dup (?)
	count	dw	0
	fn 		db 'answer.txt', 0
	dscr    dw ?
	buf 	dw 5 dup (?)
	space	dw ' '
	minus 	dw '-'
	endfl	dw '$'
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
	je PrintMas
	cmp ax, 3
	je Sorted
	cmp ax, 4
	je SaveAnswer
	cmp ax, 5
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
	call GnomeSort
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
	PRINTN "  <1> -- Input array;                                                         "
	PRINTN "  <2> -- Show array;                                                          "
	PRINTN "  <3> -- Sorted array;                                                        "
	PRINTN "  <4> -- Save array to file 'answer.txt';                                     "
	PRINTN "  <5> -- Exit;                                                                "
	PRINTN "=============================================================================="
	PRINT  "Command "
	
	ret
ShowMenu endp
end start



