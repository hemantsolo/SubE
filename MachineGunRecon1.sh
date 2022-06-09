#! /usr/bin/bash

figlet "MachineGunR1"
echo ""
echo "By - HemantSolo (@hemantsolo)"
echo ""
echo "Target: "
echo ""
read Target
echo ""
echo "Nuclei? [ 1 - Yes/0 - No ] "
echo
read nuke
echo
echo "Enter 1 for custom settings of each tool (Enter 0 for default setting)"
read setting

if [ $setting == 1 ];
then
	echo ""
	echo "Enter Flags for each tool eg: '-v -a -s' without quotes"
	echo ""
	echo "(!!! Don't enter domain and output flags !!!)"
	echo ""
	declare -a tools=( Findomain subfinder sublist3r amass nuclei )
	declare -a flags
	for i in {0..4}
	do
		echo "Flag for " ${tools[i]} " : "
		read flag
		flags[i]=$flag
	done
	echo ""

	findomain ${flags[0]} -t $Target --output
	subfinder ${flags[1]} -d $Target > subfinder.txt
	sublist3r ${flags[2]} -d $Target -o sublist3r.txt
	amass enum ${flags[3]} -d $Target -o amass.txt

else
	findomain -t $Domain --output
	subfinder -d $Domain > subfinder.txt
	sublist3r -d $Domain -o sublist3r.txt
	amass enum -d $Domain -o amass.txt
fi

cat $Target.txt subfinder.txt sublist3r.txt amass.txt > finalsub.txt
rm $Target.txt subfinder.txt sublist3r.txt amass.txt
sort -u finalsub.txt > $Target.txt
rm finalsub.txt
httprobe < $Target.txt > alive.$Target.txt
if [ $nuke == 1 ];then
	if [ $settings == 1 ];then
		nuclei ${flags[4]} -l alive.$Target.txt -o nuclei.$Target.txt
	else
		nuclei -l alive.$Target.txt -o nuclei.$Target.txt
	fi
fi
echo "Results stored in $Target.txt and alive.$Target.txt in the current directory."
echo ""
echo "Nuclei results stored in nuclei.$Domain.txt file"
echo 
echo "Attack It!!!"