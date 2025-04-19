#!/bin/bash

if [ $# -ne 2 ]; then
    echo "Usage: $0 <sv_file> <top_module>"
    exit 1
fi

file=/home/vandan-parekh/Downloads/sv_lab/AHB5_Master_VIP/tb_top/$1
top_module=$2

if [ ! -f "$file" ]; then
    echo "File $file does not exist"
    exit 1
fi

echo "Compiling $file..."
 vlog -cover bcst $file;
if [ $? -eq 0 ]; then
    echo "Compilation successful"
    echo "Running simulation for $top_module in QuestaSim GUI with waveform..."
   vopt work.$top_module -o tb_opt +acc=arn;vsim -c -assertdebug -msgmode both -coverage work.tb_opt -l ahb_m.log -do "add wave -r /*; run -all" 

else
    echo "Compilation failed"
    exit 1
fi
