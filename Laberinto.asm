section .text
%define REN 10   ; Filas
%define COL 10   ; Columnas
global mover_jugador_asm

; int mover_jugador_asm(char** laberinto, int fila, int col, char direccion)
;   RCX: laberinto
;   RDX: fila
;   R8:  col
;   R9:  direccion
mover_jugador_asm:
    push rbp
    mov rbp, rsp

    
    ; 1. Calcular nueva posicion segun direccion
    cmp r9b, 'W'
    je .arriba
    cmp r9b, 'S'
    je .abajo
    cmp r9b, 'A'
    je .izquierda
    cmp r9b, 'D'
    je .derecha
    jmp .invalido


.arriba:
    dec edx     ; fila--
    jmp .verificar


.abajo:
    inc edx     ; fila++
    jmp .verificar

.izquierda:
    dec r8d     ; col--
    jmp .verificar

.derecha:
    inc r8d     ; col++
    jmp .verificar

.verificar:
    ; 2. Verificar limites del laberinto
    cmp edx, 0          ; fila < 0?
    jl .invalido
    cmp edx, REN-1      ; fila >= REN?
    jge .invalido
    cmp r8d, 0          ; col < 0?
    jl .invalido
    cmp r8d, COL-1      ; col >= COL?
    jge .invalido

    ; 3. Obtener celda destino
    mov rax, [rcx + rdx*8]  ; Obtener fila (char*)
    mov al, [rax + r8]      ; Obtener caracter

    ; 4. Verificar contenido
    cmp al, '#'
    je .invalido
    cmp al, 'X'
    je .victoria

    ; 5. Actualizar laberinto (movimiento válido)
    ; 5.1 Buscar posición actual de 'P'
    mov r10, rcx        ; Guardar laberinto
    mov r11d, 0         ; Contador filas
.buscar_p:
    mov rax, [r10 + r11*8]
    mov r12d, 0         ; Contador columnas
.buscar_p_col:
    cmp byte [rax + r12], 'P'
    je .encontrado_p
    inc r12d
    cmp r12d, COL
    jl .buscar_p_col
    inc r11d
    cmp r11d, REN
    jl .buscar_p

.encontrado_p:
    ; 5.2 Actualizar posiciones
    mov byte [rax + r12], '.'  ; Borrar 'P' anterior
    mov rax, [r10 + rdx*8]     ; Obtener nueva fila
    mov byte [rax + r8], 'P'   ; Colocar 'P' nuevo
    mov eax, 1                 ; Retornar 1 (movimiento vlido)
    jmp .fin

.victoria:
    mov eax, 2                 ; Retornar 2 (victoria)
    jmp .fin

.invalido:
    xor eax, eax               ; Retornar 0 (inválido)

.fin:
    pop rbp
    ret