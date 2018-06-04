#!/bin/bash

rustc foo.rs # compile our Rust code to foo
./foo        # run it
echo $?      # print out the exit code

# Clean up
rm foo

