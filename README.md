# CA (Computer Architecture 2023)

## hw1 and hw2 are **RISC-V assembly language** programs.
* `hw1` is a simple calculator which can support the following operations: +, −, ×, /, min, ^, !

* `hw2` requires the implementation of two recursive functions.

* The detailed requirements for the homework are in the PDF files located in the `hw1` and `hw2` folders.

* A [useful link](https://godbolt.org/) to learn how the assembly code generated by the compiler for a C/C++ program. 

### How to run the programs?
1. Go to [here](https://github.com/andrescv/Jupiter/releases), and download the zip file of Jupiter v3.1 corresponding to your OS. (Jupiter is a RISC-V simulator.)

2. Unzip the zip file and run the executable file (`image/bin/jupiter`) from  the command line.
    ```bash
    image/bin/jupiter /path/to/hw1.s < /path/to/sample_input.txt
    ```

## lab1, lab2 and lab3 are **Verilog** programs.
* `lab1` requires the implementation of a single-cycle CPU.

* `lab2` requires the implementation of a pipelined CPU.

* The detailed requirements for the homework are in the PDF files located in the `lab1` and `lab2` folders.

* A [useful link](https://hdlbits.01xz.net/wiki/Step_one) to learn how to write Verilog.

### How to run the programs?
1. Download iverilog and gtkwave.
    ```bash
    sudo apt install iverilog # to execute the verilog code

    sudo apt install gtkwave # to view the waveform
    ```

1. Go to the folder of the lab you want to run.
    ```bash
    cd lab1/lab1
    ```
2. Use the following command to run the testbench and the result will be stored in `lab1/lab1/log` floder.
    ```bash
    make
    ```
    or
    ```bash
    cp testcases/instruction_n.txt instruction.txt

    iverilog -o cpu code/src/*.v code/supplied/*.v

    vvp cpu
    ```