
filenames=(
    "test1_40.S"
    "test1_49_singlewriteloop.S"
    "test1_52_miswrite.S"
    "test1_miswrite_read_misread.S"
    "test1_miswriteread.S"
)
touch cc_report.txt
# Access the filenames in the array
mv ./sbst/tests/test1.S ./.tmp/test1.S
for filename in "${filenames[@]}"; do
    
    cp ./tests/$filename ./sbst/tests/test1.S
   echo $filename >> cc_report.txt
   echo "\n" >> cc_report.txt
    make questa/lsim/gate-timing/shell | grep "cc:" >> cc_report.txt
  
done
mv ./.tmp/test1.S ./sbst/tests/test1.S


