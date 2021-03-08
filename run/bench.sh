#! /bin/bash

unikernel=$1
unikernel_dir=$2

case $unikernel in
    "hermitux")
        echo -e "Hermitux selected."
        ;;

    "hermitcore")
        echo -e "HermitCore selected."
        ;;

    "./")
        echo -e "Current OS selected. (Using ./ to invoke process)"
        ;;

    *)
        echo -e "Unknown unikernel $unikernel.\n Aborting script."
        ;;
esac

if [ -e results ]; then
    echo -e "Warning : A directory results already exists !"
    echo -e "Please remove it manually to avoid making mistakes."
    echo -e "Aborting script."
    exit
fi

mkdir results

./unikernel-run.sh $unikernel $unikernel_dir fib
./unikernel-run.sh $unikernel $unikernel_dir health "-f ../inputs/health/medium.input"
./unikernel-run.sh $unikernel $unikernel_dir nqueens
./unikernel-run.sh $unikernel $unikernel_dir sparselu
./unikernel-run.sh $unikernel $unikernel_dir strassen
