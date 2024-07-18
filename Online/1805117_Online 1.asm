.MODEL SMALL 
.STACK 100H
 
.DATA
;The string to be printed 

INPUT DB 'INPUT A CAPITAL LETTER:', '$'
OUTPUT DB 'THE OUTPUT CHARACTER IS: ', '$'
LF EQU 0AH
CR EQU 0DH
A DB ?
 
.CODE 
MAIN PROC
 MOV AX, @DATA
 MOV DS, AX
 
 ; load address of the string 
 LEA DX, INPUT 
  
 ;output the string
 ;loaded in dx 
 MOV AH, 09H
 INT 21H
 
 ;INPUT 
 MOV AH, 1
 INT 21H
 MOV A, AL 
 
 ;OUTPUT A NEW LINE
 MOV AH, 2
 MOV DL, CR
 INT 21H
 MOV DL, LF
 INT 21H
 
 MOV CL, A
 
 SUB CL, 'A'
 XOR CL, 1
 MOV BL, 'z'
 SUB BL, CL
 
 ; load address of the string 
 LEA DX, OUTPUT 
  
 ;output the string
 ;loaded in dx 
 MOV AH, 09H
 INT 21H
 
 ; output
 MOV AH, 2
 INT 21H
 MOV DL, BL
 INT 21H
  
 ;interrupt to exit
 MOV AH, 4CH
 INT 21H 
  
MAIN ENDP 
END MAIN 