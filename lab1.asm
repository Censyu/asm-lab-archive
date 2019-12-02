.model small

.data
file1: DB "Input1.txt"
DB 0
file2: DB "Output1.txt"
DB 0
buff:  DB 100 dup(0)

.code
.startup
        MOV  DX, OFFSET file1   ; create file1
        MOV  AH, 3CH
        MOV  CX, 00H
        INT  21H
        PUSH AX                 ; push handle
        MOV  CX, 0
        MOV  BX, OFFSET buff
        MOV  AH, 01H
read:
        INT  21H
        CMP  AL, '-'
        JE   write
        MOV  [BX], AL
        ADD  BX, 1
        ADD  CX, 1
        JMP  read
write:
        MOV  AH, 40H
        POP  BX                  ; pop handle
        MOV  DX, OFFSET buff
        INT  21H                 ; write to file
        MOV  AH, 3EH             ; close file1
        INT  21H

        MOV  DX, OFFSET file1   ; open file1
        MOV  AL, 0
        MOV  AH, 3DH
        INT  21H
        PUSH AX                 ; push handle
        MOV  BX, AX
        MOV  DX, OFFSET buff
        MOV  CX, 100
        MOV  AH, 3FH            ; read file1
        INT  21H

        MOV  BX, OFFSET buff
        MOV  CX, 0
read1:
        MOV  AL, [BX]
        CMP  AL, 0
        JE   write1
        CMP  AL, 97
        JB   skip   
        CMP  AL, 122
        JA   skip
        ADD  AL, -32            ; a - A
skip:
        MOV  [BX], AL           ; save to buff
        ADD  BX, 1
        ADD  CX, 1              ; count
        JMP  read1
write1:
        ADD  BX, 1
        MOV  [BX], '$'           ; append $

        POP  BX                  ; close file1
        PUSH CX                  ; push length
        MOV  AH, 3EH
        INT  21H
        
        MOV  DX, OFFSET buff
        MOV  AH, 09H             ; print buff
        INT  21H

        MOV  DX, OFFSET file2    ; create file2
        MOV  CX, 00H
        MOV  AH, 3CH
        INT  21H
        MOV  BX, AX              ; handle
        MOV  DX, OFFSET buff
        POP  CX                  ; pop length
        MOV  AH, 40H             ; write to file2
        INT  21H

        MOV  AH, 3EH             ; close file2
        INT  21H

.exit 0
END
