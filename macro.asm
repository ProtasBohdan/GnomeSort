
;------------------------------------------------
;Опис макросів
;------------------------------------------------
;Макрос виводу символу на екран
PUTC    MACRO   char
        PUSH    AX
        MOV     AL, char
        MOV     AH, 0Eh
        INT     10h     
        POP     AX
ENDM
;-------------------------------------------------
;Макрос виводу рядків символів на екран
;-------------------------------------------------
PRINT   MACRO   sdat
LOCAL   next_char, s_dcl, printed, skip_dcl

PUSH    AX      ; store registers...
PUSH    SI      ;

JMP     skip_dcl        ; skip declaration.
        s_dcl DB sdat, 0

skip_dcl:
        LEA     SI, s_dcl
        
next_char:      
        MOV     AL, CS:[SI]
        CMP     AL, 0
        JZ      printed
        INC     SI
        MOV     AH, 0Eh ; teletype function.
        INT     10h
        JMP     next_char
printed:

POP     SI      ; re-store registers...
POP     AX      ;
ENDM
;----------------------------------------------------------------
; Це макрос друкує рядок символів який передеаємть параметром
; В кінці виводиться кінець рядка
;----------------------------------------------------------------
PRINTN   MACRO   sdat
LOCAL   next_char, s_dcl, printed, skip_dcl

PUSH    AX      ; store registers...
PUSH    SI      ;

JMP     skip_dcl        ; skip declaration.
        s_dcl DB sdat, 13, 10, 0

skip_dcl:
        LEA     SI, s_dcl
        
next_char:      
        MOV     AL, CS:[SI]
        CMP     AL, 0
        JZ      printed
        INC     SI
        MOV     AH, 0Eh ; teletype function.
        INT     10h
        JMP     next_char
printed:

POP     SI      ; re-store registers...
POP     AX      ;
ENDM