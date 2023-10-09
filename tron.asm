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

    ; menu input lekezelese
    cmp al, 27 ; ESC
    jz ProgramEnd

    cmp al, "1" ; 1 -> jatek inditasa
    jz Init

    cmp al, "2" ; 2 -> Kilepes
    jz ProgramEnd

Init:
    mov player1X, 0
    mov player2X, 10
    mov player1Dir, 2
    mov player2Dir, 2

    mov al, 13h
    mov ah, 0
    int 10h

    jmp GameLoop

ProgramEnd:
    mov ax, 4c00h
    int 21h

GameLoop:
    call InputHandler
    jmp GameLoop

InputHandler proc
	mov ah, 01h		; ellenorizzuk, hogy lenyomtak e valamit
	int 16h
	jz notPressed
	
	mov ah, 00h 	; ezzel meg is kapom
	int 16h
	pressed:
		cmp ah, 4Bh		; balra nyil
		;je NLeft
		cmp ah, 4Dh		; jobbra nyil
		;je NRight
		cmp ah, 48h		; fel nyil
		;je NUp
		cmp ah, 50h		; le nyil
		;je NDown
		cmp al, "a"
		;je toggleAutoRun
		cmp al, "w"
		;je toggleAutoRun
		cmp al, "s"
		;je toggleAutoRun
		cmp al, "d"
		;je toggleAutoRun
	notPressed:
	ret
InputHandler endp

Code Ends

Data Segment
    mainMenuOption1 db "1) Jatek inditasa","$"
    mainMenuOption2 db "2) Kilepes","$"
    player1X dw 0
    player2X dw 0
    player1Dir dw 0
    player2Dir dw 0
Data Ends

Stack Segment

Stack Ends
	End Start

