.model small
.stack 256h
.data
	array   dw  50 dup (?)
	fname 	db 'data.txt', 0h
	handle  dw ?
	buff  	db 5 dup('$')
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
	
  	mov position, 0	;position in the file
	xor si, si		;iteraror for buff
	xor di, di		;iterator for main array
again:
	;--------------------------------------------------------------------
	;counter to start file
	mov bx, handle
	mov al, 0
	mov cx, 0
	mov dx, position			;start position
	mov ah, 42h
	int 21h
	jc error
	
	;read from file
	mov bx, handle
	mov ah, 3fh
	mov cx, 1			;how many symbols to read
	mov dx, offset t_buff
	int 21h
	
;checking for end of file
	cmp t_buff, '$'
	je Exit

;checking for space
	cmp t_buff, ' '
	jne cont
;if space, read atoi buf and load an array
	;xor si, si
	;call Atoi	;returned ax - digit
	;mov array[di], ax
	;inc di
	;inc position
	;jmp again
	
cont:
	xor ah, ah
	mov al, t_buff
	mov buff[si], al
	inc si

	inc position	;shift the position in file
	jmp again

Error:
	PRINTN "error"
Exit:
	mov bx, handle
	Call CloseFile
	jc Error
	call ExitProgramm  

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



end start	
	