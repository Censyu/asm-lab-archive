.model small

.data
N:      db 0
buff:   db 100 dup(0)

.code
.startup
        mov ah, 01H
        int 21H
        sub al, '0'
        mov N, al
        mov dl, al              ; copy N
        mul dl
        mov dl, al              ; save N^2
        mov bx, offset buff
        mov cl, 1
save:
        mov [bx], cl
        add bx, 1
        add cl, 1
        cmp cl, dl
        jbe save

        mov bx, offset buff
        mov ch, 0
        mov cl, 0
        mov ah, 02H
        mov dl, 13
        int 21H
        mov dl, 10
        int 21H
read:
        cmp ch, cl
        jb  update
print:
        mov al, [bx]
        mov ah, 0
        aam
        mov dx, ax
        mov ah, 02H
        push dx
        cmp dh, 0               ; high = 0?
        je  skip
        add dh, '0'
        mov dl, dh
        int 21H
skip:
        pop dx
        add dl, '0'             ; print low
        int 21H
        mov dl, 32              ; print space
        int 21H
update:
        add bx, 1
        push bx                 ; can only use bx for memread
        mov bx, offset N
        add cl, 1
        cmp cl, [bx]
        jne skip2
        mov cl, 0
        add ch, 1
        
        cmp ch, [bx]
        jae fin
        mov dl, 13
        int 21H                 ; newline
        mov dl, 10
        int 21H
skip2:
        pop bx
        jmp read
fin:


.exit 0
END
