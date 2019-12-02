.model small

.stack

.data
VAL db 20 dup(0)
VAL1 db 20 dup(0)
.code
fact proc
    cmp cl, 1
    ja recu
    mov bx, offset VAL
    mov byte ptr [bx], 1
    ret
recu:
    push cx
    sub cl, 1
    call fact
    ; back
    add cl, 1
    cmp cl, 10
    jb l0
; mul D1
    mov al, cl
    mov ah, 0
    mov cl, 10
    div cl
    push ax
    mov cl, al ; calc high
    mov di, 0
loop0:
    mov al, cl
    mov bx, offset VAL
    mov dl, [bx + di]
    mul dl
    mov bx, offset VAL1
    mov [bx + di], al
    add di, 1
    cmp di, 20
    ja fin0
    jmp loop0
fin0:
    pop ax
    mov cl, ah ; calc low
    mov ax, -17
    push ax
; mul D0
l0:
    mov bx, offset VAL
    mov di, 0
loop1:
    mov al, cl
    mov dl, [bx + di]
    mul dl
    mov [bx + di], al
    add di, 1
    cmp di, 20
    ja fin1
    jmp loop1
fin1:
    mov bp, sp
    cmp [bp], -17
    jne carry
    pop ax
; add mul D1 & D0
    mov di, 0
loop3:
    mov bx, offset VAL1
    mov dl, [bx + di]
    ; mov [bx + di], 0
    add di, 1
    mov bx, offset VAL
    add [bx + di], dl
    cmp di, 20
    jb loop3

carry:
    mov di, 0
    mov bx, offset VAL
loop2:
    mov dl, [bx + di]
    cmp dl, 10
    jb fin2
    mov al, dl
    mov ah, 0
    mov dl, 10
    div dl
    mov dl, ah
    add byte ptr [bx + di + 1], al
fin2:
    mov [bx + di], dl
    add di, 1
    cmp di, 20
    jb loop2
    pop cx
    ret
fact endp
.startup
main:
    mov cx, 0
read:
    mov ah, 01H
    int 21H
    cmp al, ' '
    je work
    mov dl, al
    mov al, 10
    mul cl
    mov cl, al
    sub dl, '0'
    add cl, dl
    jmp read
work:
    call fact

    mov bx, offset VAL
    mov di, 20
trim:
    mov dl, [bx + di]
    cmp dl, 0
    jne print
    sub di, 1
    jmp trim
print:
    mov dl, [bx + di]
    add dl, '0'
    mov ah, 02H
    int 21H
    sub di, 1
    cmp di, 0
    jge print
.exit 0
END
