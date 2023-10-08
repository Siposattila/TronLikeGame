Code Segment
	assume CS:Code, DS:Data, SS:Stack

Start:
	mov ax, Code
	mov ds, ax

    mov ah, 00h ; kepernyo torles
    mov al, 04h ; video mod 320x200
    int 10h

    ; menu kiiratas
    mov ah, 09h
    mov dx, offset mainMenu
    int 21h

ProgramEnd:
    mov ax, 4c00h
    int 21h

Code Ends

Data Segment
    mainMenu db "1) Játék indítása$", 10, 13, "2) Kilépés$"
Data Ends

Stack Segment

Stack Ends
	End Start

