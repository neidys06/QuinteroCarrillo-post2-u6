; lab6_modos.asm — Demostracion de modos de direccionamiento x86
; Estudiante: Neidys Mariana Quintero Carrillo
; Compilar: nasm -f bin lab6_modos.asm -o ../bin/lab6_modos.com

org 100h

; ── Datos de prueba ───────────────────────────────────────────────────────
jmp inicio

; Array de 5 enteros de 16 bits
array   dw 10, 20, 30, 40, 50

; Registro de estudiante
nota1    dw 85
nota2    dw 73
promedio dw 0

; Variable para direccionamiento directo
var_x    dw 0FFFFh

inicio:

; ── MODO 1: INMEDIATO ─────────────────────────────────────────────────────
; El operando es un valor constante dentro de la instruccion
    MOV ax, 100         ; AX = 100 — inmediato decimal
    MOV bx, 0A5h        ; BX = 0xA5 — inmediato hex
    ADD cx, 55          ; CX += 55 — inmediato aritmetico
    AND dx, 00FFh       ; DX AND mascara inmediata

; ── MODO 2: DIRECTO ──────────────────────────────────────────────────────
; La direccion del operando esta fija en la instruccion
    MOV ax, [var_x]         ; AX = 0FFFFh
    MOV bx, [array]         ; BX = 10 (primer elemento)
    MOV cx, [nota1]         ; CX = 85
    MOV [var_x], word 0     ; escribe 0 en var_x

; ── MODO 3: INDIRECTO POR REGISTRO ───────────────────────────────────────
; El registro contiene la direccion — puntero variable
    ; Leer nota1 via puntero
    MOV si, nota1       ; SI = direccion de nota1
    MOV ax, [si]        ; AX = mem[SI] = 85

    ; Leer nota2 via puntero
    MOV si, nota2       ; SI = direccion de nota2
    MOV bx, [si]        ; BX = mem[SI] = 73

    ; Calcular promedio
    ADD ax, bx          ; AX = 85 + 73 = 158
    SHR ax, 1           ; AX = 79 (division por 2)
    MOV si, promedio    ; SI = direccion de promedio
    MOV [si], ax        ; mem[SI] = 79

; ── MODO 4: INDEXADO (BASE + INDICE + DESPLAZAMIENTO) ────────────────────
; Direccion efectiva = Base + Indice + Desplazamiento
    ; Acceso a array[2] = 30
    MOV bx, array       ; BX = direccion base del array
    MOV si, 4           ; SI = 2 * 2 = 4 (indice byte)
    MOV ax, [bx + si]   ; AX = array[2] = 30

    ; Suma acumulada del array: 10+20+30+40+50 = 150
    XOR ax, ax          ; AX = 0 acumulador
    MOV bx, array       ; BX = base
    MOV cx, 5           ; CX = 5 elementos
    XOR si, si          ; SI = 0 indice

.bucle_array:
    ADD ax, [bx + si]   ; AX += array[si/2]
    ADD si, 2           ; avanzar 2 bytes
    LOOP .bucle_array
    ; AX = 150

    ; Acceso a struct con desplazamiento fijo
    MOV bx, nota1       ; BX = base del struct
    MOV ax, [bx]        ; AX = nota1 = 85  (offset 0)
    MOV cx, [bx + 2]    ; CX = nota2 = 73  (offset 2)
    MOV dx, [bx + 4]    ; DX = promedio=79 (offset 4)

    INT 20h             ; retornar a DOS