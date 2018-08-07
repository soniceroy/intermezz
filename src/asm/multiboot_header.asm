; Header code for grub multiboot spec

; First Requires four parts, each of size 32bit(double word):
;   1. magic number
;   2. mode code (protected, etc)
;   3. header length
;   4. checksum - has three parts: magic + architecture + header_length.
;          checksum + magic_number + architecture + header_length
;          must equal zero.
;
; Second, Requires an end tag of 3 parts:
;   1. type  - size 16bits(word)
;   2. flags - size 16bits(word)
;   3. size  - size 32bits(double word)
section .multiboot_header
header_start:
    ; dd: define double word (32bits)
    ; dw: define word (16bits)
    dd 0xe85250d6                ; magic number
    dd 0                         ; protected mode code
    dd header_end - header_start ; header length

    ; checksum
    ; 0x100000000 would normally overflow to dd 0 (its 33bit).
    ; x + n = 0 where
    ; x = 0x100000000 - n.
    dd 0x100000000 - (0xe85250d6 + 0 + (header_end - header_start))

    ; required end tag
    dw 0 ; type
    dw 0 ; flags
    dd 8 ; size
header_end:

