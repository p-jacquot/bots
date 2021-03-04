#! /bin/bash

unikernel_launch=$1
bench=$2
bench_args=$3

if [ ! -e results ]; then
    mkdir results
fi

if [ -e results/$bench ]; then
    echo -e "WARNING : There is already a folder results/$bench."
    echo "Please check what's inside, and remove it manually to avoid making mistakes."
    echo "Aborting script."
    exit
fi

mkdir results/$bench
results_path=$(pwd)/results/$bench
cd ../bin

echo -e "Performing bench $bench :"

for executable in $bench.*; do
    echo -e "\t Executing $executable..."
    if [ "$unikernel_launch" == "./" ]; then
        ./$executable $bench_args > $results_path/$executable.log
    else
        "$unikernel_launch" $executable $bench_args > $results_path/$executable.log
    fi
done
