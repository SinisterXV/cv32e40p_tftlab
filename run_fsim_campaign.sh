#!/bin/bash

function perform_fsim_iteration {
	make zoix/fgen/sdd K=${k} # generate fault list
	SECONDS=0 # reset timer
	make zoix/fsim-timing FAULT_LIST=run/zoix_timing/cv32e40p_top_sdd_K${k}.rpt # run fault sim

	# read the second-to-last line of the report: it contains the fault coverage
	# then isolate the two percentages
	# then select only the first (they are identical)
	fault_coverage=$(tail -2 run/zoix_timing/cv32e40p_top_sdd_K${k}.rpt.fsim | head -1 | grep -Eo "[0-9.]+%" | head -1)
	{
		echo "K = ${k}"
		echo "Simulation duration: ${SECONDS}s"
		echo "Fault coverage: $fault_coverage"
		echo ""
	} >> $rpt_file
}

echo "Starting fault simulation campaign"

rpt_file="reports/fsim_campaign.rpt"
true > $rpt_file # clear report
{
	echo "FAULT CAMPAIGN REPORT"
	echo "Started on $(date)" 
	echo ""
} >> $rpt_file

# iterate over the interval [1; 2] with a step of 0.1
for k in $(seq 1 0.1 2); do
	perform_fsim_iteration
done

# iterate over the interval [3; 10] with a step of 1
for k in $(seq 3 10); do
	perform_fsim_iteration
done

# iterate over the interval [20; 90] with a step of 10
for k in $(seq 20 10 90); do
	perform_fsim_iteration
done

# use the maximum k value, found experimentally
k=94
perform_fsim_iteration

echo "Finished execution on $(date)" >> $rpt_file

# save all report to the `reports` folder so they survive a `make clean`
mv run/zoix_timing/cv32e40p_top_sdd_K*.rpt.fsim reports/