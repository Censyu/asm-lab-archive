.model small
.stack
.data

.code
.startup
    mov cx, 0
    mov dx, 0
read:
    mov ah, 01H
    int 21H
    cmp al, '='
    je print
ifp:
    cmp al, '+'
    jne ifm
    push ax
    mov cx, 1
    jmp read
ifm:
    cmp al, '-'
    jne ifl
    push ax
    mov cx, 1
    jmp read
ifl:
    cmp al, '('
    jne ifr
    push cx
    mov cx, 0
    jmp read
ifr:
    cmp al, ')'
    jne blank
    cmp cx, 1
    jne nopre
    pop dx
    pop cx
    cmp cx, 1
    jne read
    jmp calc1

nopre:
    pop cx
    cmp cx, 1
    jmp read

blank:
    cmp al, ' '
    jne digit
    push dx
    mov dx, 0
    cmp cx, 1
    jne read
calc:
    pop dx
calc1:
    pop ax
    cmp al, '+'
    je plus
    cmp al, '-'
    je minus

    jmp read
digit:
    push ax
    mov ax, 10
    mul dx
    mov dx, ax
    pop ax
    sub al, '0'
    mov ah, 0
    add dx, ax
    jmp read


plus:
    pop bx
    add bx, dx
    push bx
    mov dx, 0
    jmp read
minus:
    pop bx
    sub bx, dx
    push bx
    mov dx, 0
    jmp read

print:
    mov cx, 0
    pop ax
ploop:
    mov dx, 0
    mov bx, 10
    div bx
    cmp dx, 0
    jne goon
    cmp ax, 0
    jne goon
    jmp fin
goon:
    add dl, '0'
    push dx
    add cx, 1
    jmp ploop
fin:
    pop dx
    mov ah, 02H
    int 21H
    loop fin
.exit 0
END
