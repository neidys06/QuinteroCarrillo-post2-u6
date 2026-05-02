; inv.asm — Recorrido inverso del array: 50+40+30+20+10 = 150
; Compilar: nasm -f bin inv.asm -o ../b/inv.com

org 100h

jmp inicio

array dw 10, 20, 30, 40, 50

inicio:
    ; Recorrido inverso: desde array[4] hasta array[0]
    XOR ax, ax          ; AX = 0 acumulador
    MOV bx, array       ; BX = direccion base del array
    MOV cx, 5           ; CX = 5 elementos
    MOV si, 8           ; SI = (5-1)*2 = 8 (apunta al ultimo elemento)

.bucle_inverso:
    ADD ax, [bx + si]   ; AX += array[si/2]
    SUB si, 2           ; retroceder 2 bytes
    LOOP .bucle_inverso
    ; AX = 50+40+30+20+10 = 150

    INT 20h