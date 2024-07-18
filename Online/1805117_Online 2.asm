.MODEL SMALL
.STACK

.DATA
LF EQU 0AH
CR EQU 0DH  



FIRST DB 'IN THE FIRST QUADRANT', '$'
SECOND DB 'IN THE SECOND QUADRANT', '$' 
THIRD DB 'IN THE THIRD QUADRANT', '$'
FOURTH DB 'IN THE FOURTH QUADRANT', '$'
ORIGIN DB 'THE ORIGIN', '$'
XAXIS DB 'ON X-AXIS', '$'
YAXIS DB 'ON Y-AXIS', '$'

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX
    
    ;INPUT 
    MOV AH, 1
    INT 21H
    CMP AL, 0
    JNE NEGX
    JE POSX
    
NEGX:
    MOV AH, 1
    INT 21H
    CMP AL, '0'
    JE AXIS
    MOV AH, 1
    INT 21H
    MOV AH, 1
    INT 21H
    CMP AL, '0'
    JNE THIRDQ
    JE SECONDQ
    
    
POSX:
    MOV AH, 1
    INT 21H
    CMP AL, '0'
    JE AXIS
    MOV AH, 1
    INT 21H
    MOV AH, 1
    INT 21H
    CMP AL, '0'
    JNE FOURTHQ
    JE FIRSTQ
    
AXIS:
    MOV AH, 1
    INT 21H
    MOV AH, 1
    INT 21H
    MOV AH, 1
    INT 21H
    CMP AL, 0  
    JNE AXISX
    ; load address of the string 
    LEA DX, ORIGIN 
  
    ;output the string
    ;loaded in dx 
    MOV AH, 09H
    INT 21H
    JMP ENDIF
    
AXISX:
    ; load address of the string 
    LEA DX, XAXIS 
  
    ;output the string
    ;loaded in dx 
    MOV AH, 09H
    INT 21H
    JMP ENDIF
    
FIRSTQ:
    MOV AH, 1
    INT 21H
    CMP AL, '0'
    JE AXISY
    ; load address of the string 
    LEA DX, FIRST 
  
    ;output the string
    ;loaded in dx 
    MOV AH, 09H
    INT 21H
    JMP ENDIF

SECONDQ:
    MOV AH, 1
    INT 21H
    CMP AL, '0'
    JE AXISY
    ; load address of the string 
    LEA DX, SECOND 
  
    ;output the string
    ;loaded in dx 
    MOV AH, 09H
    INT 21H
    JMP ENDIF
    
THIRDQ:
    MOV AH, 1
    INT 21H
    CMP AL, '0'
    JE AXISY
    ; load address of the string 
    LEA DX, THIRD 
  
    ;output the string
    ;loaded in dx 
    MOV AH, 09H
    INT 21H
    JMP ENDIF

FOURTHQ:
    MOV AH, 1
    INT 21H
    CMP AL, '0'
    JE AXISY
    ; load address of the string 
    LEA DX, FOURTH 
  
    ;output the string
    ;loaded in dx 
    MOV AH, 09H
    INT 21H
    JMP ENDIF
    
AXISY:    
    ; load address of the string 
    LEA DX, YAXIS 
  
    ;output the string
    ;loaded in dx 
    MOV AH, 09H
    INT 21H
    JMP ENDIF
     
ENDIF:
    
    ;TERMINATION
    MOV AH, 4CH
    INT 21H
    
MAIN ENDP
END MAIN