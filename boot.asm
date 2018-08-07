global start  ; global makes 'start' public

section .text ; ".text" section is where code goes
bits 32       ; 32-bit protected mode
start:
    ; Point the first entry of the level 4 page table to
    ;     the first entry in the p3 table
    mov eax, p3_table
    ; First two bits in a page table entry are 
    ;     the present bit and the writable bit
    ;     the below sets the first entry to 
    ;     present and writable.
    or eax, 0b11
    mov dword [p4_table + 0], eax

    mov eax, p2_table
    or eax, 0b11
    mov dword [p3_table + 0], eax

    ; point each page table level two entry to a page
    mov ecx, 0 ; counter variable
.map_p2_table:
    mov eax, 0x200000 ; 2MiB table size
    mul ecx           ; mul takes arg and mults with eax
    ; set the huge page, present, and writable bit
    or eax, 0b10000011 ; eax is mul result
    mov [p2_table + ecx * 8], eax

    inc ecx
    cmp ecx, 512 ; 4096/8bytes per entry = 512
    jne .map_p2_table
    
    ; move page table address to cr3
    ;   control register
    ; control registers only allow mov
    ;   from another register
    mov eax, p4_table
    mov cr3, eax

    ; enable PAE (physical address extension)
    mov eax, cr4
    or eax, 1 << 5
    mov cr4, eax

    ; set the long mode bit
    mov ecx, 0xC0000080
    rdmsr ; read model specific register (outputs to eax)
    or eax, 1 << 8
    wrmsr ; write to model specific register

    ; enable paging
    mov eax, cr0
    or eax, 1 << 31
    or eax, 1 << 16
    mov cr0, eax

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

; block started by symbol section
;  entries in this section are automatically set
;  to zero by the linker
section .bss

; CPU assumes the first 12 bits of all addresses are zero
;   this allows us to store metadata in the first 12 bits
align 4096

p4_table:
    resb 4096 ; resb- reserve bytes "resb {size}"
p3_table:
    resb 4096
p2_table:
    resb 4096
