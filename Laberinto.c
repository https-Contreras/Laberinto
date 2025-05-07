#include <stdio.h>
#include <Windows.h>
#include <ctype.h>
#include <stdbool.h>
#define REN 10
#define COL 10

// Declaracion de la funcion asm
extern int mover_jugador_asm(char** laberinto, int fila, int col, char direccion);

// Laberinto inicial
char fila0[COL + 1] = "##########";
char fila1[COL + 1] = "#P..#....#";
char fila2[COL + 1] = "###.#.##.#";
char fila3[COL + 1] = "#.#.#.#..#";
char fila4[COL + 1] = "#.#...##.#";
char fila5[COL + 1] = "#.###....#";
char fila6[COL + 1] = "#...####.#";
char fila7[COL + 1] = "###.#....#";
char fila8[COL + 1] = "#.....##X#";
char fila9[COL + 1] = "##########";

char* laberinto[REN] = {fila0, fila1, fila2, fila3, fila4, fila5, fila6, fila7, fila8, fila9};

void imprimir_laberinto() {
    system("cls");
    for (int i = 0; i < REN; i++) {
        printf("%s\n", laberinto[i]);
    }
}

int main() {
    int fila_actual = 1, col_actual = 1;  // Posicion inicial de 'P'
    char input;
    bool juego_activo = true;

    while (juego_activo) {
        imprimir_laberinto();
        printf("\nControles (WASD para mover, Q para salir): ");
        scanf(" %c", &input);
        input = toupper(input);

        if (input == 'Q') {
            juego_activo = false;
            continue;
        }

        // Llamar a la funcion en asm
        int resultado = mover_jugador_asm(laberinto, fila_actual, col_actual, input);

        switch (resultado) {
            case 0:
                printf("¡Movimiento inválido!\n");
                Sleep(1000);
                break;
            case 1:
                // Actualizar posicion
                for (int i = 0; i < REN; i++) {
                    for (int j = 0; j < COL; j++) {
                        if (laberinto[i][j] == 'P') {
                            fila_actual = i;
                            col_actual = j;
                        }
                    }
                }
                break;
            case 2:
                imprimir_laberinto();
                printf("\n¡GANASTE!\n");
                Sleep(3000);
                juego_activo = false;
                break;
        }
    }
    return 0;
}