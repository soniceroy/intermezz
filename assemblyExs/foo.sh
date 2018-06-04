#!/bin/bash

nasm -f elf64 foo.asm # assemble into foo.o
ld foo.o              # link into a.out
./a.out               # run it
echo $?               # print out the exit code

# Cleanup
rm a.out foo.o
