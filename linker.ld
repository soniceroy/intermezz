ENTRY(start)

SECTIONS {
    /* 
        ". = 1M;" declares that these sections start at the one megabyte mark (a convention).
        there is used memory below the 1M mark, such as memory-mapped screen, keyboard, etc 
    */
    . = 1M;

    .boot :
    {
        /* ensure that the multiboot header is at the beginning */
        *(.multiboot_header)
    }

    .text :
    {
        *(.text)
    }
}
