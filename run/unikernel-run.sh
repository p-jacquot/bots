#! /bin/bash

unikernel=$1
unikernel_dir=$2
bench=$3
bench_args=$4

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
    #echo -e "\t Executing $executable..."
    log_file="$results_path/$executable.log"
    touch $log_file
    for ((i = 0; i < 10; i++)); do
        echo -e -n "\r\t Executing $executable : $i..."
        case "$unikernel" in
            "./")
                ./$executable $bench_args >> $log_file
                ;;

            "hermitux")
                HERMIT_ISLE=uhyve HERMIT_TUX=1 \
                    $unikernel_dir/hermitux-kernel/prefix/bin/proxy \
                    $unikernel_dir/hermitux-kernel/prefix/x86_64-hermit/extra/tests/hermitux \
                    $executable $bench_args >> $log_file 
                ;;

            "hermitcore")
                $unikernel_dir/bin/proxy $executable $bench_args >> $log_file
                ;;

            *)
                echo -e "Unknown unikernel : $unikernel"
                ;;
        esac
    done
    echo 
done
