Code Segment
	assume CS:Code, DS:Data, SS:Stack

Start:
	mov ax, Data
	mov ds, ax

    mov ah, 00h ; kepernyo torles
    mov al, 03h ; video mod dosbox miatt 80x25
    int 10h

    ; Kurzor pozicionalas
    mov ah, 02h
    mov bh, 0
    mov dh, 10 ; sor
    mov dl, 10 ; oszlop
    int 10h

    ; menu kiiratas
    mov ah, 09h
    mov dx, offset mainMenuOption1
    int 21h

    mov dx, offset mainMenuOption2
    int 21h

    ; Megmondom neki, hogy input lesz!!!
    mov ah, 00h
    int 16h

    ; menu input lekezelese
    cmp al, 27 ; ESC
    jz ProgramEnd

    cmp al, "1" ; 1 -> jatek inditasa
    jz Init

    cmp al, "2" ; 2 -> Kilepes
    jz ProgramEnd

Init:
    mov player1X, 0
    mov player1Y, 0
    mov player2X, 0
    mov player2Y, 0
    mov player1PosX, 0
    mov player1PosY, 0
    mov player2PosX, 150
    mov player2PosY, 100
    mov colorToDraw, 0

    mov al, 13h
    mov ah, 0
    int 10h

    jmp GameLoop

ProgramEnd:
    mov ax, 4c00h
    int 21h

GameLoop:
    call InputHandler
    call UpdatePlayers

    jmp GameLoop

InputHandler proc
	mov ah, 01h ; ellenorizzuk, hogy lenyomtak e valamit
	int 16h
	jz notPressed

    ; Megmondom neki, hogy input lesz!!!!
	mov ah, 00h ; ezzel meg is kapom
	int 16h
	pressed:
		cmp ah, 4Bh ; balra nyil
		je player1
		cmp ah, 4Dh ; jobbra nyil
		je player1
		cmp ah, 48h ; fel nyil
		je player1
		cmp ah, 50h ; le nyil
		je player1
		cmp al, "a"
		je player2
		cmp al, "w"
		je player2
		cmp al, "s"
		je player2
		cmp al, "d"
		je player2
        cmp al, "q" ; teszt miatt van
        je ProgramEnd
	notPressed:
        ret
    player1:
		cmp ah, 4Bh ; balra nyil
		je SetPlayer1Left
		cmp ah, 4Dh ; jobbra nyil
		je SetPlayer1Right
		cmp ah, 48h ; fel nyil
		je SetPlayer1Up
		cmp ah, 50h ; le nyil
		je SetPlayer1Down
    player2:
		cmp al, "a"
		je SetPlayer2Left
        cmp al, "d"
        je SetPlayer2Right
		cmp al, "w"
		je SetPlayer2Up
		cmp al, "s"
		je SetPlayer2Down
InputHandler endp

SetPlayer1Left:
    mov player1X, -1
    mov player1Y, 0
    dec player1PosX
    ret
SetPlayer1Right:
    mov player1X, 1
    mov player1Y, 0
    add player1PosX, 1
    ret
SetPlayer1Up:
    mov player1X, 0
    mov player1Y, -1
    dec player1PosY
    ret
SetPlayer1Down:
    mov player1X, 0
    mov player1Y, 1
    add player1PosY, 1
    ret
SetPlayer2Left:
    mov player2X, -1
    mov player2Y, 0
    dec player2PosX
    ret
SetPlayer2Right:
    mov player2X, 1
    mov player2Y, 0
    add player2PosX, 1
    ret
SetPlayer2Up:
    mov player2X, 0
    mov player2Y, -1
    dec player2PosY
    ret
SetPlayer2Down:
    mov player2X, 0
    mov player2Y, 1
    add player2PosY, 1
    ret

DrawPixel:
	mov ah, 0Ch
	mov al, colorToDraw
	int 10h
	ret

UpdatePlayers:
    mov cx, player1PosX
    mov dx, player1PosY
    mov al, player1Color
    mov colorToDraw, al
    call DrawPixel
    mov cx, player2PosX
    mov dx, player2PosY
    mov al, player2Color
    mov colorToDraw, al
    call DrawPixel
    ret

Code Ends

Data Segment
    mainMenuOption1 db "1) Jatek inditasa","$"
    mainMenuOption2 db "2) Kilepes","$"
    player1X dw 0
    player1Y dw 0
    player2X dw 0
    player2Y dw 0
    player1PosX dw 0
    player1PosY dw 0
    player2PosX dw 0
    player2PosY dw 0
    player1Color db 64
    player2Color db 50
    colorToDraw db 0
Data Ends

Stack Segment

Stack Ends
	End Start

