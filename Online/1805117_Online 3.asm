.MODEL SMALL 
.STACK 100H
 
.DATA
INPUT DB 'INPUT A NUMBER:', '$'
OUTPUT DB 'THE NUMBER OF COPRIMES: ', '$'
LF EQU 0AH
CR EQU 0DH
SPA EQU 20H
TEMP DW ?
N DW ?
CNT DW ?
ARRAY DW  ?
 
.CODE 
MAIN PROC
 MOV AX, @DATA
 MOV DS, AX
 
 ; load address of the string 
 LEA DX, INPUT 
 MOV AH, 09H
 INT 21H
 
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
        CMP AL, SPA
        JE END_INPUT_LOOP_N
    
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
 
 ;OUTPUT A NEW LINE
 MOV AH, 2
 MOV DL, CR
 INT 21H
 MOV DL, LF
 INT 21H
 
 MOV SI, 0
 MOV CX, N
 MOV AX, 2
 MOV TEMP, AX
 
 WHILE_OUT: 
    WHILE_IN:   
        CMP CX, AX
        JE END_WHILE_IN
        JG CNG_NUM1
        JL CNG_NUM2
        
        CNG_NUM1:
            SUB CX, AX
            JMP WHILE_IN
        CNG_NUM2:
            SUB AX, CX
            JMP WHILE_IN
    END_WHILE_IN:
        ;MOV ARRAY[SI], CX
        ;ADD SI, 2
        CMP CX, 1
        JE INC_CNT
        JNE OTHER
        INC_CNT:
            INC CNT
            MOV AX, TEMP
            MOV BX, 10
            XOR DX, DX
            XOR CX, CX
        
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
            ;OUTPUT A NEW LINE
            MOV AH, 2
            MOV DL, SPA
            INT 21H
        OTHER:
        MOV AX, TEMP
        INC AX
        MOV TEMP, AX
        MOV CX, N
        CMP AX, CX    
        JL WHILE_IN
        JNL END_WHILE_    
 END_WHILE_:
    
    
;OUTPUT A NEW LINE
 MOV AH, 2
 MOV DL, CR
 INT 21H
 MOV DL, LF
 INT 21H    
 
 
 
 MOV AX, CNT
 MOV BX, 10
 XOR DX, DX
 XOR CX, CX
       
OUTPUT_LOOP_CNT:
    XOR DX, DX
    DIV BX
    PUSH DX
    INC CX
    CMP AX, 0
    JNE OUTPUT_LOOP_CNT
END_OUTPUT_LOOP_CNT:
        
PRINT_NUM_CNT:
    POP DX
    ADD DX, 48
    MOV AH, 2
    INT 21H
    LOOP PRINT_NUM_CNT
       
  
 ;interrupt to exit
 MOV AH, 4CH
 INT 21H 
  
MAIN ENDP 
END MAIN 