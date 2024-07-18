.MODEL SMALL
.STACK 100H

.DATA
CR DB 0DH
LF DB 0AH
SPA DB 20H
HYP DB 2DH
NEGATIVE DB 0
ARRAY DW 100 DUP(?)
N DW ?
M DW ?
TEMP DW ?
INPUT_NUM DB 'INPUT THE NUMBER OF ELEMENTS IN THE ARRAY: ', '$'
OUTPUT_ARRAY DB 'FOLLOWING IS THE SORTED ARRAY: ', '$'
INPUT_ARRAY DB 'ENTER THE NUMBERS IN THE ARRAY: ', '$'
FOUND_STR DB 'NUMBER FOUND AT POSITION: ', '$'
NOT_FOUND DB 'NUMBER NOT FOUND', '$'
BINARY DB 'DO YOU WANT TO SEARCH A NUMBER?(Y/N)', '$'
INPUT_BN DB 'ENTER THE NUMBER TO SEARCH FOR: ', '$' 


.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX
    
    LEA DX, INPUT_NUM
    MOV AH, 09H
    INT 21H
    ; fast BX = 0
    XOR BX, BX
    
    INPUT_LOOP_N:
        ; char input 
        MOV AH, 1
        INT 21H
    
        ; if \n\r, stop taking input
        CMP AL, CR    
        JE END_INPUT_LOOP_N
        CMP AL, LF
        JE END_INPUT_LOOP_N
        CMP AL, HYP
        JE END_PROGRAM
    
        ; fast char to digit
        ; also clears AH
        AND AX, 000FH
    
        ; save AX 
        MOV CX, AX
    
        ; BX = BX * 10 + AX
        MOV AX, 10
        MUL BX
        ADD AX, CX
        MOV BX, AX
        JMP INPUT_LOOP_N
    
    END_INPUT_LOOP_N:
    MOV N, BX
    
    ; printing CR and LF
    MOV AH, 2
    MOV DL, CR
    INT 21H
    MOV DL, LF
    INT 21H
    
    LEA DX, INPUT_ARRAY
    MOV AH, 09H
    INT 21H
    
    MOV SI, 0
    
    MOV CX, N
    
    ARRAY_INPUT:
        ; fast BX = 0
        XOR BX, BX
        
        MOV TEMP, CX
        INPUT_LOOP:
            ; char input 
            MOV AH, 1
            INT 21H
    
            ; if \n\r, stop taking input
            CMP AL, CR    
            JE END_INPUT_LOOP
            CMP AL, LF
            JE END_INPUT_LOOP
            CMP AL, SPA
            JE END_INPUT_LOOP
            CMP AL, HYP
            JE NEG_NUM
    
            ; fast char to digit
            ; also clears AH
            AND AX, 000FH
            
            ; save AX 
            MOV CX, AX
    
            ; BX = BX * 10 + AX
            MOV AX, 10
            MUL BX
            ADD AX, CX
            MOV BX, AX
            JMP INPUT_LOOP
            
            NEG_NUM:
                MOV NEGATIVE, 1
                JMP INPUT_LOOP
    
        END_INPUT_LOOP:
        CMP NEGATIVE, 1
        JE NEGATE
        JMP END
        NEGATE:
            NEG BX
            MOV NEGATIVE, 0
        END:
        MOV ARRAY[SI], BX
        ADD SI, 2
        MOV CX, TEMP
        
    LOOP ARRAY_INPUT 
    
    ; printing CR and LF
    MOV AH, 2
    MOV DL, CR
    INT 21H
    MOV DL, LF
    INT 21H
    
    ;INSERTION SORT
    MOV CX, N
    SUB CX, 1
    
    MOV SI, 2
    
    FOR_:
        MOV DX, ARRAY[SI]
    
        MOV DI, SI
        SUB DI, 2
                    
        WHILE_:
            CMP DX, ARRAY[DI]
            JGE END_WHILE
            MOV BX, ARRAY[DI]
            MOV ARRAY[DI+2], BX
            SUB DI, 2
            CMP DI, 0
            JGE WHILE_
        END_WHILE:
        MOV ARRAY[DI+2], DX
        ADD SI, 2

    LOOP FOR_
    
    ;OUTPUT THE SORTED ARRAY
    LEA DX, OUTPUT_ARRAY
    MOV AH, 09H
    INT 21H
    
    MOV CX, N
    MOV SI, 0
    ARRAY_OUTPUT:
        MOV AX, ARRAY[SI]
        MOV TEMP, CX
        MOV BX, 10
        XOR DX, DX
        XOR CX, CX
        
        CMP AX, 0
        JL NEG_OUT
        OUTPUT_LOOP:
            XOR DX, DX
            DIV BX
            PUSH DX
            INC CX
            CMP AX, 0
            JNE OUTPUT_LOOP
        END_OUTPUT_LOOP:
        
        PRINT_NUM:
            POP DX
            ADD DX, 48
            MOV AH, 2
            INT 21H
        LOOP PRINT_NUM
        
        
        ADD SI, 2
        MOV CX, TEMP
        MOV DX, 20H
        INT 21H
    LOOP ARRAY_OUTPUT
    JMP END_OUT
    
    NEG_OUT:
            MOV DL, HYP
            PUSH AX
            MOV AH, 2
            INT 21H
            POP AX
            NEG AX
            JMP OUTPUT_LOOP
    
    END_OUT:
    
    ; printing CR and LF
    MOV AH, 2
    MOV DL, CR
    INT 21H
    MOV DL, LF
    INT 21H
    
    ;PROMPT USER FOR BINARY SEARCH
BINARY_SEARCH:
    ; printing CR and LF
    MOV AH, 2
    MOV DL, CR
    INT 21H
    MOV DL, LF
    INT 21H
    
    LEA DX, BINARY
    MOV AH, 09H
    INT 21H
    
    MOV AH, 1
    INT 21H
    CMP AL, 'N'
    JE END_SEARCH
    
    ; printing CR and LF
    MOV AH, 2
    MOV DL, CR
    INT 21H
    MOV DL, LF
    INT 21H
    
    LEA DX, INPUT_BN
    MOV AH, 09H
    INT 21H
     
    XOR BX, BX
    INPUT_LOOP_M:
        ; char input 
        MOV AH, 1
        INT 21H
    
        ; if \n\r, stop taking input
        CMP AL, CR    
        JE END_INPUT_LOOP_M
        CMP AL, LF
        JE END_INPUT_LOOP_M
        CMP AL, SPA
        JE END_INPUT_LOOP_M
        CMP AL, HYP
        JE NEG_NUM_M
    
        ; fast char to digit
        ; also clears AH
        AND AX, 000FH
            
        ; save AX 
        MOV CX, AX
    
        ; BX = BX * 10 + AX
        MOV AX, 10
        MUL BX
        ADD AX, CX
        MOV BX, AX
        JMP INPUT_LOOP_M
            
        NEG_NUM_M:
            MOV NEGATIVE, 1
            JMP INPUT_LOOP_M
    
    END_INPUT_LOOP_M:
        CMP NEGATIVE, 1
        JE NEGATE_M
        JMP END_M
    NEGATE_M:
        NEG BX
        MOV NEGATIVE, 0
    END_M:
        MOV M, BX
        
        
    
    ; printing CR and LF
    MOV AH, 2
    MOV DL, CR
    INT 21H
    MOV DL, LF
    INT 21H
    
    ;BINARY SEARCH
    MOV DX, M
    MOV CX, N
    ADD CX, CX
    DEC CX      ;UPPER
    XOR AX, AX  ;LOWER
    
    WHILEBN_:
        CMP AX, CX
        JG END_WHILE_BN
        
        MOV SI, AX
        ADD SI, CX
        SHR SI, 1 
        ADD SI, SI
        
        CMP DX, ARRAY[SI]
        JE FOUND
        JL CHANGE_HIGH
        JG CHANGE_LOW
        
        CHANGE_HIGH:
            SUB SI, 1
            MOV CX, SI
            JMP WHILEBN_
        CHANGE_LOW:
            ADD SI, 1
            MOV AX, SI
            JMP WHILEBN_    
        END_WHILE_BN:
            XOR AX, AX
            LEA DX, NOT_FOUND
            MOV AH, 09H
            INT 21H 
            JMP END_BN
        FOUND:
            ;ADD SI, 2
            MOV BX, SI
            SHR BX, 1
            ADD BX, 1
            LEA DX, FOUND_STR
            MOV AH, 09H
            INT 21H
            MOV DX, BX
            ADD DX, 48
            MOV AH, 2
            INT 21H
        END_BN:
       
        JMP BINARY_SEARCH        

    END_SEARCH:
    END_PROGRAM:
    
    MOV AH, 4CH
    INT 21H 

MAIN ENDP    
END MAIN