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
LOCALS @@
JUMPS
INCLUDE macro.asm

start:
	mov ax, @data
    mov ds, ax
    mov es, ax

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
SetUp:
	PRINT "Enter the numb of element in massive "
	call InputPInt
	mov count, ax
	
	PRINTN "Enter the elements of massive(0 - 65365!):"
	call GetArray
	
	jmp _again
	
PrintMas:
	PRINT "Array at the moment { "
	call OutArray
	PRINT "}"
	xor ax, ax			;Зачекати на нажаття клавіші
    int 16h
	jmp _again
	
Sorted:
	call GnomeSort
	PRINTN "Array successfully sorted!"
	xor ax, ax			;Зачекати на нажаття клавіші
    int 16h
	
	jmp _again
	
SaveAnswer:
	call InputToFile
	
	PRINTN "Array  will be saved to answer.txt..."
	xor ax, ax			;Зачекати на нажаття клавіші
    int 16h
	jmp _again
_eexit:
	call ExitProgramm
	
INCLUDE function.asm
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
	PRINTN "  <4> -- Save massive to file 'answer.txt';                                   "
	PRINTN "  <5> -- Exit;                                                                "
	PRINTN "=============================================================================="
	PRINT  "Command "
	
	ret
ShowMenu endp
end start



