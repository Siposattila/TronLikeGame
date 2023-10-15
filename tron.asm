Code Segment
	assume CS:Code, DS:Data, SS:Stack

Start:
	mov ax, Data
	mov ds, ax

    jmp Menu

CollisionDetection:
    cmp playerCollisionCheck, 1
    je player1Check
    cmp playerCollisionCheck, 2
    je player2Check
    ret
    player1Check:
        mov ah, 0Dh
        mov cx, [player1PosX]
        mov dx, [player1PosY]
        int 10h

        cmp al, [player2Color]
        je Player1GameOver
        cmp al, [borderColor]
        je Player1GameOver

        mov ah, 0Dh
        mov cx, [player1NextPosX]
        mov dx, [player1NextPosY]
        int 10h

        cmp al, [player1Color]
        je Player1GameOver
        ret
    player2Check:
        mov ah, 0Dh
        mov cx, [player2PosX]
        mov dx, [player2PosY]
        int 10h

        cmp al, [player2Color]
        je Player2GameOver
        cmp al, [player1Color]
        je Player2GameOver
        cmp al, [borderColor]
        je Player2GameOver
        ret

GameOver:
    cmp winningPlayer, 1
    je Player1
    cmp winningPlayer, 2
    je Player2

Player1GameOver:
    mov winningPlayer, 2
    jmp GameOver

Player2GameOver:
    mov winningPlayer, 1
    jmp GameOver

Player1:
    mov ah, 00h ; kepernyo torles
    mov al, 03h ; video mod dosbox miatt 80x25
    int 10h

    ; Kurzor pozicionalas
    mov ah, 02h
    mov bh, 0
    mov dh, 0 ; sor
    mov dl, 0 ; oszlop
    int 10h

    mov dx, offset winningPlayer1Message
    mov ah, 09h
    int 21h

    mov ah, 00h
    int 16h

    cmp al, 13
    je Menu
Player2:
    mov ah, 00h ; kepernyo torles
    mov al, 03h ; video mod dosbox miatt 80x25
    int 10h

    ; Kurzor pozicionalas
    mov ah, 02h
    mov bh, 0
    mov dh, 0 ; sor
    mov dl, 0 ; oszlop
    int 10h

    mov dx, offset winningPlayer2Message
    mov ah, 09h
    int 21h

    mov ah, 00h
    int 16h

    cmp al, 13
    je Menu

Menu:
    mov ah, 00h ; kepernyo torles
    mov al, 03h ; video mod dosbox miatt 80x25
    int 10h

    ; Kurzor pozicionalas
    mov ah, 02h
    mov bh, 0
    mov dh, 0 ; sor
    mov dl, 0 ; oszlop
    int 10h

    ; menu kiiratas
    mov ah, 09h
    mov dx, offset mainMenu
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
    mov player2PosX, 150
    mov player2PosY, 100
    mov player1NextPosX, 1
    mov player1NextPosY, 0
    mov player2NextPosX, 149
    mov player2NextPosY, 100
    mov colorToDraw, 0
    mov winningPlayer, 0
    mov playerCollisionCheck, 0

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
    mov cx, player1PosX
    mov player1NextPosX, cx
    dec player1NextPosX
    ret

AddPlayer1X:
    add player1PosX, 1
    mov cx, player1PosX
    mov player1NextPosX, cx
    add player1NextPosX, 1
    ret

DecPlayer1Y:
    dec player1PosY
    mov cx, player1PosY
    mov player1NextPosY, cx
    dec player1NextPosY
    ret

AddPlayer1Y:
    add player1PosY, 1
    mov cx, player1PosY
    mov player1NextPosY, cx
    add player1NextPosY, 1
    ret

DecPlayer2X:
    dec player2PosX
    mov cx, player2PosX
    mov player2NextPosX, cx
    dec player2NextPosX
    ret

AddPlayer2X:
    add player2PosX, 1
    mov cx, player2PosX
    mov player2NextPosX, cx
    add player2NextPosX, 1
    ret

DecPlayer2Y:
    dec player2PosY
    mov cx, player2PosY
    mov player2NextPosY, cx
    dec player2NextPosY
    ret

AddPlayer2Y:
    add player2PosY, 1
    mov cx, player2PosY
    mov player2NextPosY, cx
    add player2NextPosY, 1
    ret

DrawPixel:
	mov ah, 0Ch
	mov al, colorToDraw
	int 10h
	ret

UpdatePlayers:
    call AutoRunPlayer1
    mov playerCollisionCheck, 1
    call CollisionDetection
    mov cx, player1PosX
    mov dx, player1PosY
    mov al, player1Color
    mov colorToDraw, al
    call DrawPixel
    call AutoRunPlayer2
    mov playerCollisionCheck, 2
    call CollisionDetection
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
    mainMenu db "1) Jatek inditasa", 13, 10, "2) Kilepes$"
    winningPlayer1Message db "Nyert az elso jatekos!", 13, 10, "Nyomj egy entert a menube valo visszatershez!$"
    winningPlayer2Message db "Nyert a masodik jatekos!", 13, 10, "Nyomj egy entert a menube valo visszatershez!$"
    player1X dw 0
    player1Y dw 0
    player2X dw 0
    player2Y dw 0
    player1PosX dw 0
    player1PosY dw 0
    player2PosX dw 0
    player2PosY dw 0
    player1NextPosX dw 0
    player1NextPosY dw 0
    player2NextPosX dw 0
    player2NextPosY dw 0
    player1Color db 42 ; narancssarga
    player2Color db 52 ; vilagos kek
    colorToDraw db 0
    delay dw 0
    winningPlayer db 0
    borderColor db 2 ; zold
    playerCollisionCheck db 0
Data Ends

Stack Segment

Stack Ends
	End Start

