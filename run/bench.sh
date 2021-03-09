#! /bin/bash

unikernel=$1
unikernel_dir=$2
cpus=1

if [ -n "$3" ]; then
    cpus=$3
fi

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
        exit
        ;;
esac

if [ -e cpus-results ]; then
    echo -e "Warning : A directory results already exists !"
    echo -e "Please remove it manually to avoid making mistakes."
    echo -e "Aborting script."
    exit
fi

mkdir cpus-results

for cpu in $cpus; do
    
    mkdir results

    export HERMIT_CPUS=$cpu
    export OMP_NUM_THREADS=$cpu
    
    echo -e "Starting benchs with $cpu cores."

    ./unikernel-run.sh $unikernel $unikernel_dir fib
    #./unikernel-run.sh $unikernel $unikernel_dir health "-f ../inputs/health/medium.input"
    #./unikernel-run.sh $unikernel $unikernel_dir nqueens
    #./unikernel-run.sh $unikernel $unikernel_dir sparselu
    #./unikernel-run.sh $unikernel $unikernel_dir strassen
    
    cd ./results
    folders=`ls`
    touch times.csv

    for name in $folders; do
        for bench in $name/*; do
            cat $bench | grep "Time Program" \
                | awk '{print $4}' > tmp
            
            echo -n "$bench;" >> times.csv
            cat tmp | while read line; do
                echo -n "$line;" >> times.csv
            done
            echo >> times.csv
        done
    done
    
    rm tmp
    cd ..
    mv results cpus-results/$cpu-cpus
done

