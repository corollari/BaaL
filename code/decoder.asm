

;ax=byte counter
;bx=tree pointer
;cx=text pointer
;dl=byte holder
;dh=shift counter

%define len 290 ;  <-- REWORK (check if it works and change const dinamically)
%define text $512

mov ax, encoded ; encoded tag should be in output/encoded.asm
mv cx, text
mv dh, $7
mov bh, 0x7C

	; while(ax<len(encoded)):
startloop:
	cmp ax,len+encoded
	jge display		; Check if the order used in cmp is correct (jump if ax>=len), display tag should be in display.asm
        mov bx,root
innerloop:
	cmp dh, $7
	jne shift
                        mov dl,[ax]
                        inc ax
                        mov dh, $0
			jmp aftershift
	shift:
                        shr dl, $1
                        inc dh
	aftershift:

;bx=[bx+dx&&1]

	and dl, $1
	jnz else
		and [bx+2], ~1
		mov bl, [bx]
		jmp afterelse
	else:
		and [bx+2], ~2
		mov bl, [bx+1]
	afterelse:
		jnz innerloop
		mov [cx],bx
		inc cx
		jmp startloop
