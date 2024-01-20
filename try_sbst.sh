
if [ -z "$1" ]; then
	k=1
else
	k=$1
fi

make compile_sbst
make questa/lsim/gate-timing/shell 
make zoix/fgen/sdd K=$k

make zoix/fsim-timing FAULT_LIST=run/zoix_timing/cv32e40p_top_sdd_K$k.rpt
fault_coverage=$(tail -2 run/zoix_timing/cv32e40p_top_sdd_K$k.rpt.fsim | head -1 | grep -Eo "[0-9.]+%" | head -1)
	{
		echo "Fault coverage: $fault_coverage"
		echo ""
	} 