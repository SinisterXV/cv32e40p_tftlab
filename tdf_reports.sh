
filenames=(
    "test1_first.S"
    "test1_second.S"
    "test1_third.S"
    "test1_fourth.S"
    "test1_fifth.S"
)

# Access the filenames in the array
mv ./sbst/tests/test1.S ./.tmp/test1.S
for filename in "${filenames[@]}"; do
    cp ./tests/$filename ./sbst/tests/test1.S
    make compile_sbst
    make questa/lsim/gate/shell
    make zoix/fgen/tdf
    make zoix/fsim FAULT_LIST=run/zoix/cv32e40p_top_tdf.rpt
    cp /home/s317703/assignment/run/zoix/cv32e40p_top_tdf.rpt.hier ./result/tdf/${filename:0:-2}.txt
done
mv ./.tmp/test1.S ../sbst/tests/test1.S


