    bits 16

    mov ax, 0x07C0
    mov ds, ax
    mov ax, 0x07E0      # 07E0h = (07C00h+200h)/10h, beginning of stack segment.
    mov ss, ax
    mov sp, 0x2000      # 8k of stack space.

    call clearscreen

    push 0x0000
    call movecursor
    add sp, 2

    push msg
    call print
    add sp, 2

    cli
    hlt

    clearscreen:
        push bp
        mov bp, sp
        pusha

        mov ah, 0x07        # tells BIOS to scroll down window
        mov al, 0x00        # clear entire window
        mov bh, 0x07        # white on black
        mov cx, 0x00        # specifies top left of screen as (0,0)
        mov dh, 0x18        # 18h = 24 rows of chars
        mov dl, 0x4f        # 4fh = 79 cols of chars
        int 0x10            # calls video interrupt

        popa
        mov sp, bp
        pop bp
        ret

    movecursor:
        push bp
        mov bp, sp
        pusha

        mov dx, [bp+4]  # get the argument from the stack. |bp| = 2, |arg| = 2
        mov ah, 0x02        # set cursor position
        mov bh, 0x00        # page 0 - doesn't matter, we're not using double-buffering
        int 0x10

        popa
        mov sp, bp
        pop bp
        ret

    print:
        push bp
        mov bp, sp
        pusha
        mov si, [bp+4]      # grab the pointer to the data
        mov bh, 0x00        # page number, 0 again
        mov bl, 0x00        # foreground color, irrelevant - in text mode
        mov ah, 0x0E        # print character to TTY
    .char:
        mov al, [si]        # get the current char from our pointer position
        add si, 1           # keep incrementing si until we see a null char
        or al, 0
        je .return          # end if the string is done
        int 0x10            # print the character if we're not done
        jmp .char           # keep looping
    .return:
        popa
        mov sp, bp
        pop bp
        ret


    msg:    db "Oh boy do I sure love assembly!", 0

times 510-(\$-$$) db 0
dw 0xAA55
