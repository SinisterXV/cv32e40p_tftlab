#!/bin/bash

echo "fault_site,max_rise,max_fall" > cv32e40p_top.gsf.csv
tail cv32e40p_top.gsf -n+10 | head -n-3 | awk '{OFS=","}{print $3,$1,$2}' >>  cv32e40p_top.gsf.csv