# Modified Bots for Unikernels

This for of Bots benchmark suite is designed to be run by unikernels. To achieve that, it has been modified to ease its compilation. 
You can find the original repo here : [https://github.com/bsc-pm/bots](https://github.com/bsc-pm/bots).


This repo is able to run on the following unikernels for now :

* HermitCore
* Hermitux

Two scripts have been added in the `run` directory :

* unikernel-run.sh
* benchs.sh

## unikernel-run.sh

This script is for running all the benchs for a given problem.
Here is its syntax command :

```
cd ./run
./unikernel-run.sh <unikernel-name> <unikernel-location> <problem> <problem args>
```

Here is an example for running `health` problem with `HermitCore` unikernel :

```
./unikernel-run.sh hermitcore /opt/hermit health "-f ../inputs/medium.input"
```

For now, supported <unikernel-name> values are :
* hermitcore : for HermitCore unikernel
* hermitux : for Hermitux unikernel
* ./ : for running benchs without unikernel.

> You can avoid using unikernel by typing `./unikernel-sh ./ . <problem> <problem args>`

Results of the script execution are placed inside a results directory, located in the same directory as the script.

## benchs.sh

This script relies on `unikernel-run.sh` to  run several benchs for a given list of cores allocated.
Here is its syntax command :

```
cd ./run
./bench.sh <unikernel-name> <unikernel-location> [cpus-list]
```

<unikernel-name> values are the same as for `unikernel-run.sh` shell script.

> If you don't specify the `cpus-list` parameter, benchs will be performed on a single core by default.

Here is an example of command :

```
./bench.sh hermitux /home/pierre/unikernels/hermitux "1 2 4 8"
```

This script place its results in the `cpus-results` folder. Execution times are gathered in the `times.csv` files, in the `$cpus-cpus-results` sub-folders.


# Compiling for HermitCore

We use all the toolchain provided by HermitCore to compile bots. 
Use the `configure` script to generate a `config/make.config` file.

Then, modify the following variables in the `config/make.config` file :

> If your HermitCore toolchained is installed somewhere else than `/opt/hermit`, replace this part of the paths in the lines below by your hermitCore's location.

```
LABEL=hermit-gcc

OMPC=/opt/hermit/bin/x86_64-hermit-gcc -fopenmp
CC=/opt/hermit/bin/x86_64-hermit-gcc

OMPLINK=/opt/hermit/bin/x86_64-hermit-gcc -fopenmp
CLINK=/opt/hermit/bin/x86_64-hermit-gcc
```

Then, run `make`. The benchmarks should compile.

Once the program is compiled, you can run the benchmarks with `benchs.sh` and `unikernel-run.sh` script.

```
./benchs.sh hermitcore /opt/hermit [cpus-list]
```

or 

```
./unikernel-run.sh hermitcore /opt/hermit <problem> <problem args>
```

## Working benchmarks for HermitCore

* fib benchmarks
* floorplan.serial
* health benchmarks
* nqueens benchmarks
* sparselu benchmarks
* srassen benchmarks

If you try to execute other benchmarks, you will probably experience pagefaults.

# Compiling for Hermitux

Hermitux is not very restrictive about the way you compile the benchs. Any statically compiled program should run on Hermitux.

Run the `configure` script, and then modify the `config/make` file according to your needs. Here is a working example :

```
LABEL=clang-11

OMPC=clang-11 -fopenmp
CC=clang-11

OMPLINK=/home/pierre/unikernels/hermitux/musl/obj/musl-gcc -static -liomp5 -L/home/pierre/unikernels/hermitux/libiomp/build/runtime/src -fopenmp
OMPLINK=/home/pierre/unikernels/hermitux/musl/obj/musl-gcc -static
``` 

> In this example, I chose to use Hermitux's compiler for the linking.

Then, you can use the provided scripts to run your benchmarks on hermitux :

> Of course, you'll need to replace `/home/pierre/unikernels` by you own location of the Hermitux unikernel.

```
./benchs.sh hermitux /home/pierre/unikernels/hermitux [cpus-list]
```

or 

```
./unikernel-run.sh hermitux /home/pierre/unikernels <problem> <problem args>
```

## working benchmarks for Hermitux

* fib benchmarks
* floorplan benchmarks
* health benchmarks
* nqueens benchmarks
* sparselu benchmarks
* strassen benchmarks

If you try to run other benchmarks, you will probably experience pagefaults.


SUITE DESCRIPTION
=================

The objective of the suite is to provide a collection of applications that allow to test
OpenMP tasking implementations. Most of the kernels come from existing ones from other
projects. Each of them comes with different implementations that allow to test different
possibilities of the OpenMP task model (task tiedness, cut-offs, single/multiple generators,
etc). It currently comes with the following kernels:

   + Alignment: Aligns sequences of proteins.
   + FFT: Computes a Fast Fourier Transformation.
   + Floorplan: Computes the optimal placement of cells in a floorplan.
   + Health: Simulates a country health system.
   + NQueens: Finds solutions of the N Queens problem.
   + Sort: Uses a mixture of sorting algorithms to sort a vector.
   + SparseLU: Computes the LU factorization of a sparse matrix.
   + Strassen: Computes a matrix multiply with Strassen's method.

FILE DESCRIPTION
================

The package directory is organized as follows:

   + ./bin: target directory when compiling the benchmarks (generated by `./configure').
   + ./common: source code for common objects.
   + ./config: config directory, assist the compilation phase.
   + ./inputs: input files for some of the benchmarks (when needed).
   + ./omp-tasks: source code for the OpenMP Task versions.
   + ./run: scripts for running the benchmarks.
   + ./serial: source code for the serial versions.
   + ./templates: template directory.

SUITE COMPILATION
=================

Briefly, the shell commands `./configure` and  `make` should configure and build this package.

The `./configure` shell script attempts to guess correct values for various system-dependent
variables used during compilation (compiler and OpenMP specific flags). The shell script
examines the compilers installed in the system and let the user choose among them.  It uses
those values to create a `make.config` in `./config` directory which will be used during
the suite compilation.

If you need to change compilers, linkers or compilation options you can change manually the
file `./config/make.config`.

OTHER ISSUES TO TAKE INTO ACCOUNT
=================================

Some benchmarks are coded following a recursive model which makes an intensive use of stack
frames. It is usually needed to increase default stack sizes when working with high recursion
levels. Main stack size can be increased using `ulimit -s` linux command. Thread stacks are
usually controlled through runtime specific environment variable (e.g. Intel C Compiler uses
`KMP_STACKSIZE=value` for this purpose).

Developer activities and documentation are centralized in our
[repository](https://pm.bsc.es/gitlab/benchmarks/bots).
Mail suggestions, comments and bug reports to **pm-tools**\*. You can also write a bug report 
[here](https://pm.bsc.es/gitlab/benchmarks/bots/issues).
 
***

(\*) All our email accounts are hosted at **bsc.es** (i.e. \<account-name\>@bsc.es).
