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

    ; load the GDT
    lgdt [gdt64.pointer]

    ; update the 16 bit segment registers
    mov ax, gdt64.data ; sixteen bit register version of eax
    mov ss, ax ; stack segment register **N/A but needs to be set
    mov ds, ax ; data segment register
    mov es, ax ; extra segment register **N/A but needs to be set

    ; jump to long mode
    ; foo:bar where foo updates cs (code segment) register
    ;   and bar tells the address to jump to
    ; jump is needed to update cs because cs cannot be
    ;   directly written to.
    jmp gdt64.code:long_mode_start

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



; set up GDT
section .rodata ; read only data
gdt64:
    dq 0 ; define quad-word (64 bit value)
; "." here scopes code under gdt64 (gdt64.code)
.code: equ $ - gdt64 ; set current address for the label
                     ; (equ) to current address minus
                     ; the address for gdt64 
                     ; calculates the offset for this 
                     ; scoped code.
    ; bit meaning for code segment
    ;   44 = 'descriptor type' 1 for code and data segments
    ;   47 = 'present'
    ;   41 = 'read/write' 1 for readable
    ;   43 = 'executable'
    ;   53 = '64-bit'
    dq (1<<44) | (1<<47) | (1<<41) | (1<<43) | (1<<53)

.data: equ $ - gdt64
    ; bit meaning for data segment
    ;   44 = 'descriptor type' 1 for code and data segments
    ;   47 = 'present'
    ;   41 = for data segments, this means it is writable
    ;           which is the opposite than code segments
    dq (1<<44) | (1<<47) | (1<<41)

; Structure used to tell the hardware about our GDT
.pointer:
    dw .pointer - gdt64 - 1 ; calculate the length for GDT
    dq gdt64 ; address of our GDT

section .text
bits 64
long_mode_start:
    mov rax, 0x2f592f412f4b2f4f
    mov qword [0xb8000], rax
    hlt