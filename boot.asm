global start  ; global makes 'start' public

section .text ; ".text" section is where code goes
bits 32       ; 32-bit protected mode
start:
    ; mov command: format - "mov {size} {place}, {thing}
    ; "[" and "]" around a number indicate a specific
    ;     memory location (here [0xb8000] is the VGA text buffer)
    mov word [0xb8000], 0x0248 ; H
    mov word [0xb8002], 0x0265 ; e
    mov word [0xb8004], 0x026C ; l
    mov word [0xb8006], 0x026C ; l
    mov word [0xb8008], 0x026F ; o
    mov word [0xb800a], 0x0220 ; space
    mov word [0xb800c], 0x0257 ; W
    mov word [0xb800e], 0x026F ; o
    mov word [0xb8010], 0x0272 ; r
    mov word [0xb8012], 0x026C ; l
    mov word [0xb8014], 0x0264 ; d
    mov word [0xb8016], 0x0221 ; !
    hlt
