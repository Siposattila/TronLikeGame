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
    jmp Menu

GameOver:
    mov ah, 00h ; kepernyo torles
    mov al, 03h ; video mod dosbox miatt 80x25
    int 10h

    ; Kurzor pozicionalas
    mov ah, 02h
    mov bh, 0
    mov dh, 10 ; sor
    mov dl, 10 ; oszlop
    int 10h

    mov ah, 09h

    cmp winningPlayer, 1
    je player1
    cmp winningPlayer, 2
    je player2
    player1:
        mov dx, offset winningPlayer1Message
        int 21h
        mov dx, offset endGameMessage
        int 21h
        jmp Start
    player2:
        mov dx, offset winningPlayer2Message
        int 21h
        mov dx, offset endGameMessage
        int 21h
        jmp Start

Menu:
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

GameLoop:
    ; vege van e jateknak???
    cmp isGameOver, 1
    je GameOver
    call InputHandler
    call UpdatePlayers

    ; cilus kesleltetes, hogy lehessen ertelmes jatek menet
    mov delay, 32768
    loopDelay:
        dec delay
        jnz loopDelay

    jmp GameLoop

Init:
    mov player1X, 1
    mov player1Y, 0
    mov player2X, -1
    mov player2Y, 0
    mov player1PosX, 0
    mov player1PosY, 0
    mov player2PosX, 0
    mov player2PosY, 5
    mov colorToDraw, 0
    mov isGameOver, 0
    mov winningPlayer, 0

    mov al, 13h
    mov ah, 0
    int 10h

    jmp GameLoop

ProgramEnd:
    mov ax, 4c00h
    int 21h

InputHandler proc
	mov ah, 01h ; ellenorizzuk, hogy lenyomtak e valamit
	int 16h
	jz notPressed

    ; Megmondom neki, hogy input lesz!!!!
	mov ah, 00h ; ezzel meg is kapom
	int 16h
	pressed:
		cmp ah, 4Bh ; balra nyil
		je Player1Left
		cmp ah, 4Dh ; jobbra nyil
		je Player1Right
		cmp ah, 48h ; fel nyil
		je Player1Up
		cmp ah, 50h ; le nyil
		je Player1Down
		cmp al, "a"
		je Player2Left
        cmp al, "d"
        je Player2Right
		cmp al, "w"
		je Player2Up
		cmp al, "s"
		je Player2Down
        cmp al, "q" ; teszt miatt van
        je ProgramEnd
	notPressed:
        ret
InputHandler endp

Player1Left:
    mov player1X, -1
    mov player1Y, 0
    call DecPlayer1X
    ret
Player1Right:
    mov player1X, 1
    mov player1Y, 0
    call AddPlayer1X
    ret
Player1Up:
    mov player1X, 0
    mov player1Y, -1
    call DecPlayer1Y
    ret
Player1Down:
    mov player1X, 0
    mov player1Y, 1
    call AddPlayer1Y
    ret
Player2Left:
    mov player2X, -1
    mov player2Y, 0
    call DecPlayer2X
    ret
Player2Right:
    mov player2X, 1
    mov player2Y, 0
    call AddPlayer2X
    ret
Player2Up:
    mov player2X, 0
    mov player2Y, -1
    call DecPlayer2Y
    ret
Player2Down:
    mov player2X, 0
    mov player2Y, 1
    call AddPlayer2Y
    ret

DecPlayer1X:
    dec player1PosX
    ret

AddPlayer1X:
    add player1PosX, 1
    ret

DecPlayer1Y:
    dec player1PosY
    ret

AddPlayer1Y:
    add player1PosY, 1
    ret

DecPlayer2X:
    dec player2PosX
    ret

AddPlayer2X:
    add player2PosX, 1
    ret

DecPlayer2Y:
    dec player2PosY
    ret

AddPlayer2Y:
    add player2PosY, 1
    ret

DrawPixel:
	mov ah, 0Ch
	mov al, colorToDraw
	int 10h
	ret

UpdatePlayers:
    call AutoRunPlayer1
    mov cx, player1PosX
    mov dx, player1PosY
    mov al, player1Color
    mov colorToDraw, al
    call DrawPixel
    call AutoRunPlayer2
    mov cx, player2PosX
    mov dx, player2PosY
    mov al, player2Color
    mov colorToDraw, al
    call DrawPixel
    ret

AutoRunPlayer1:
    cmp player1X, 1
    je player1XAuto1
    cmp player1X, -1
    je player1XAuto2
    cmp player1Y, 1
    je player1YAuto1
    cmp player1Y, -1
    je player1YAuto2
    ret
    player1XAuto1:
        call AddPlayer1X
        ret
    player1XAuto2:
        call DecPlayer1X
        ret
    player1YAuto1:
        call AddPlayer1Y
        ret
    player1YAuto2:
        call DecPlayer1Y
        ret

AutoRunPlayer2:
    cmp player2X, 1
    je player2XAuto1
    cmp player2X, -1
    je player2XAuto2
    cmp player2Y, 1
    je player2YAuto1
    cmp player2Y, -1
    je player2YAuto2
    ret
    player2XAuto1:
        call AddPlayer2X
        ret
    player2XAuto2:
        call DecPlayer2X
        ret
    player2YAuto1:
        call AddPlayer2Y
        ret
    player2YAuto2:
        call DecPlayer2Y
        ret

Code Ends

Data Segment
    mainMenuOption1 db "1) Jatek inditasa","$"
    mainMenuOption2 db "2) Kilepes","$"
    winningPlayer1Message db "Nyert az elso jatekos!","$"
    winningPlayer2Message db "Nyert a masodik jatekos!","$"
    endGameMessage db "Nyomj egy entert a menube valo visszatershez!"
    player1X dw 0
    player1Y dw 0
    player2X dw 0
    player2Y dw 0
    player1PosX dw 0
    player1PosY dw 0
    player2PosX dw 0
    player2PosY dw 0
    player1Color db 42
    player2Color db 52
    colorToDraw db 0
    delay dw 0
    isGameOver db 0
    winningPlayer db 0
Data Ends

Stack Segment

Stack Ends
	End Start

