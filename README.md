# Collatz

Preforms calculations on a range specified by the user to determine the length of the collatz sequence of every number in the range both 
iteratively and recursively.

After all the calculations are preformed, the array is sorted in ascending order first by sequence length, and then by integer size.
The results are printed to the screen.

Complile and Run Instructions For Both Iterative and Recursive Versions:

Lisp:
chmod u+x collatz.Lisp
Compile and Run: collatz.lisp

Julia:
chmod u+x collatz.jl 
Compile and Run: collatz.jl

Go:
Compile and Run: go run collatz.go

FORTRAN:
Compile: gfortran -fno-range-check collatz.f95
Run: ./a.out
