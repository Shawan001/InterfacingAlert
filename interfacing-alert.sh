#!/bin/bash
clear
notify-send -u normal "Interfacing: " "Alert script has been started"
echo -e "interfacing-alert.sh"
echo -e "\v<-------------------------->"
echo -e "\v[+]Script is running..."
echo -e "\v[+]Do not close this window"
echo -e "\v<-------------------------->"

declare -A list

############# Test List ######################
#list[1405]="reportSummary.sh+11:00AM+Expect 2 mails - Done from previous day live site+everyday"
#list[1406]="failedLoginSummary.sh+11:05AM+Expect 2 mails - Done form previous day live site+everyday"
#list[1407]="bietl+11:05AM+Script executes but takes time to complete+everyday"
#list[1408]="southCarolina.sh+11:45AM+Check sequence with previous execution+everyday"
#list[1409]="appLogBackup.sh+11:50AM+Check for 2 seperate mails from ta and tb+everyday"

##############################################

list[0030]="vorroInboundADT.sh+12:30AM+Executed 4 times daily+everyday"
list[0630]="vorroInboundADT.sh+6:30AM+Executed 4 times daily+everyday"
list[0800]="thMosaicInbound.sh(2.1.2)+8:00AM+Details unavailable+everyday"
list[0813]="neAuth-tb.sh_before_sftp01-tb+8:13AM+Details unavailable+everyday"
list[0815]="neAuth_interface01-ta+8:15AM+Details unavailable+everyday"
list[0820]="neAuth-sftp01-ta+8:20AM+Details Unavailable+everyday"
list[1100]="reportSummary.sh+11:00AM+Expect 2 mails - Done from previous day live site+everyday"
list[1105]="failedLoginSummary.sh+11:05AM+Expect 2 mails - Done form previous day live site+everyday"
list[1106]="bietl+11:05AM+Script executes but takes time to complete+everyday"
list[1145]="southCarolina.sh+11:45AM+Check sequence with previous execution+everyday"
list[1150]="appLogBackup.sh+11:50AM+Check for 2 seperate mails from ta and tb+everyday"
list[1230]="vorroInboundADT.sh+12:30PM+4 times daily+everyday"
list[1231]="ndDbDumpInbound.sh+12:30PM+Only first day of the month, may be after 12:30PM)+specificDateInMonth+01"
list[1300]="sis2.sh_ta/tb+1:00PM+Expect 2 seperate mails+everyday"

#Following 4 scripts executes at 1:00PM BDT 
list[1301]="newMosaicBillingInbound(2.2.3).sh+1:00PM+Details unavailable+everyday"
list[1302]="thBillingInbound.sh(2.2.2)+1:00PM+Details unavaiable+everyday"
list[1303]="ta/tb_scCaseNote.sh+1:00PM+Should fail from live site other than 8th of the month+everyday"
list[1304]="ndEsitsInbound+1:00PM+Details unavailable+everyday"
list[1305]="ta_scWCNote.sh+1:01PM+Details unavailable right now+everyday"
list[1306]="rdIsland.sh+1:00PM+Done from live site+specificWeekDay+Mon Tue Wed Thu Fri"
list[1315]="sis2_cross_site_copy.sh_ta/tb+1:15PM+Expect 2 seperate mails+everyday"
list[1340]="arkInterface.sh+1:40PM+Details unavailable+everyday"

#Following 2 scripts executes at 2:00PM BDT 
list[1400]="caInterfacing.sh+2:00PM+Details Unavailable+everyday"
list[1401]="mosaicBillingInbound835.sh+2:00PM+Details unavaiable+everyday"

list[1430]="mosaicInbound(1.1.2).sh+2:30PM+Details unavailable+everyday"
list[1500]="cleanup_vorro.sh+3:00PM+Details unavailavle+everyday"
list[1600]="SCEligibility.sh+4:00PM+Details unavailable+everyday"
list[1601]="NFOPROVIDER.txt+4:01PM+Details unavailable+everyday"
list[1603]="NFOSVCAPRV.txt+4:03PM+Details unavaiable+everyday"
list[1605]="NFOCLIENT.txt+4:05PM+Details unavaiable+everyday"

#Following 2 scripts executes at 4:00PM BDT
list[1615]="nfocus_all_files.sh+4:15PM+ta site+everyday"
list[1616]="scLoc.sh+4:15PM+Details unavaialable+everyday"
list[1625]="nfocus_all_files.sh+4:25PM+tb site+everyday"
list[1630]="mosaicOutbound.sh(1.2.1)+4:30PM+Details Unavailable+everyday"
list[1830]="vorroInboundADT.sh+6:30PM+Executed 4 times daily+everyday"
list[1900]="vorro.sh+7:00PM+Executes 2 times daily (Final of the day)+everyday"
list[2245]="southCarolina.sh+10:45PM+Check Sequence. Executes 2 times daily+everyday"
list[2300]="vorro.sh+11:00PM+Executed 2 times daily+everyday"


Eligibility () {
	details=$1
	checkpoint=$(echo $details | awk -F "+" '{print $4}')
	
	case $checkpoint in
		everyday)
			echo 1
			;;
		specificWeekDay)
			days=$(echo $details | awk -F "+" '{print $5}')
			today=$(date '+%a')
			for day in days
			do
				if [[ $today == $day ]]
				then
					echo 1
					break
				fi
			done
			;;
		specificDateInMonth)
			dates=$(echo $details | awk -F "+" '{print $5}')
			today=$(date '+%d')
			for date in $dates
			do
				if [[ $today == $date ]]
				then
					echo 1
					break
				fi
			done
			;;
	esac
}

while true
do
	timeNow=$(date +"%H%M")
	#echo "Time : $timeNow"
	details=${list[$timeNow]}
	#echo "Details : $details"
	
	if [[ ! -z $details ]]
	then
		name=$(echo $details | awk -F "+" '{print $1}')
		time=$(echo $details | awk -F "+" '{print $2}')
		desc=$(echo $details | awk -F "+" '{print $3}')
		showNotification=$(Eligibility "$details")
		
		if [[ $showNotification -eq 1 ]]
		then
			notify-send -u critical "Interfacing : $name ($time BDT)" "$desc"
			espeak "Attention Please, check for interfacing mail"
		fi
	fi
	
	sleep 1m
done
