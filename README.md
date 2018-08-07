Learning OS stuff from this: http://intermezzos.github.io/book/first-edition/


Assembly compile commands:
    nasm -f elf64 {file.asm}

Current Linker command:
    ld --nmagic --output=kernel.bin --script=linker.ld multiboot_header.o boot.o
    
Grub commands:
    grub-mkrescue -o os.iso isofiles
    
Qemu commands:
    qemu-system-x86_64 -cdrom os.iso
