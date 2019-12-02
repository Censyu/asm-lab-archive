.model small
.stack
.data
file    db "in.txt"
        db 0
buff    db 600 dup(0)
array   dw 100 dup(0)

.code
.startup
        mov dx, offset file
        mov ah, 3DH
        mov al, 0
        int 21H
        mov bx, ax
        mov dx, offset buff
        mov cx, 500
        mov ah, 3FH
        int 21H
        push ax                 ; push char count
        mov ah, 3EH             ; close file
        int 21H

        mov ax, 0
        mov di, 0               ; di - buff count
        mov cx, 0
        push cx                 ; push array count
        mov ax, 0
        push ax                 ; push buff count
        mov bp, sp

parse:
        cmp di, [bp + 4]
        jge  sort
        mov dx, 0               ; dx - result
        mov cx, 1               ; cx - sign
        mov bx, offset buff
        mov al, [bx + di]       ; al - buff char
        cmp al, '-'
        jne nneg
        mov cx, -1
        add di, 1
nneg:
        mov al, [bx + di]
        cmp al, ' '
        je  blank
        push ax
        mov al, 10
        mul dl
        mov dx, ax
        pop ax
        sub al, '0'
        mov ah, 0
        add dx, ax
        add di, 1
        jmp nneg
blank:
        add di, 1
        mov [bp], di
        cmp cx, -1
        jne nneg1
        mov ax, dx
        mov dx, 0
        sub dx, ax
nneg1:
        mov di, [bp + 2]
        mov bx, offset array
        mov [bx + di], dx   ; save num
        add di, 2
        mov [bp + 2], di
        mov di, [bp]
        jmp parse

sort:
        pop cx          ; pop buff count
        pop cx
        shr cx, 1
        push cx         ; push N
        mov cx, 0       ; cx - i
        push cx         ; j
        mov bp, sp
        mov bx, offset array
fori:
        cmp cx, [bp + 2]
        je output
        mov [bp], 0     ; [bp] - j
forj:
        mov dx, [bp + 2]
        sub dx, cx
        sub dx, 1
        cmp [bp], dx
        je inci
        ; if
        mov di, [bp]
        add di, di
        mov ax, [bx + di]
        mov dx, [bx + di + 2]
        cmp ax, dx
        jle incj
        mov [bx + di + 2], ax
        mov [bx + di], dx
incj:
        mov di, [bp]
        add di, 1
        mov [bp], di
        jmp forj
inci:
        add cx, 1
        jmp fori

output:
        pop di
        pop di
        sub di, 1
        push di
        mov di, 0
        mov bp, sp
loop1:
        cmp di, [bp]
        jg fin
        push di
        add di, di
        mov dx, [bx + di]
        cmp dx, 0
        jge pos
        push dx
        mov dl, '-'
        mov ah, 02H
        int 21H
        pop ax
        mov dx, 0
        sub dx, ax
pos:
        cmp dx, 10
        jb D0
        cmp dx, 100
        jb D1
        cmp dx, 1000
        jb D2
        sub dx, 1000
        push dx
        mov dl, '1'
        mov ah, 02H
        int 21H
        pop dx
D2:
        cmp dx, 100
        jb D10
        mov ax, dx
        mov dl, 100
        mov dh, 0
        div dl
        push ax
        mov dl, al
        add dl, '0'
        mov ah, 02H
        int 21H
        pop dx
        mov dl, dh
        mov dh, 0
        jmp D1
D10:
        push dx
        mov dl, '0'
        mov ah, 02H
        int 21H
        pop dx
D1:
        cmp dx, 10
        jb D00
        mov ax, dx
        mov dl, 10
        mov dh, 0
        div dl
        push ax
        mov dl, al
        add dl, '0'
        mov ah, 02H
        int 21H
        pop dx
        mov dl, dh
        mov dh, 0
        jmp D0
D00:
        push dx
        mov dl, '0'
        mov ah, 02H
        int 21H
        pop dx
D0:
        add dl, '0'
        mov ah, 02H
        int 21H
        mov dl, ' '
        int 21H

        pop di
        add di, 1
        jmp loop1
fin:

.exit 0
END
