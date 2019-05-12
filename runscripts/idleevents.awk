#!/usr/bin/awk -f

function onIchange( ist) {
	print datetime " I "  ist " " ithreshsec
}

function onSschange( sst) {
	# translate switch Open/Closed to Sit/Stand
	if      ( sst == "Open") {  sss="Stand" }
	else if ( sst == "Closed") { sss="Sit" }
	else { return  }  # not recognized, ignore
	print datetime " S "  sss
}

# utility function to execute system command, returning output
function systemcmd( cmdline) {
	cmdline | getline result
	close(cmdline)
	return result
}

BEGIN {
	istate=0	# 1=Idle, 0=Active
	ithreshsec=300  # idle threshold in seconds
	itime=0

	sspstate=""	# Stand, Sit (padded to 6)
	ssFile="ssstatefile"
	systemcmd( "echo Sit > " ssFile)    # initialize s/s state

	while (1) {
		##### get timestamp
		datetime = systemcmd( "date +'%m/%d/%Y %H:%M:%S'");
		# print datetime

		##### Active/Idle
		result = systemcmd("ioreg -c IOHIDSystem | awk '/HIDIdleTime/{print int( $5 / 1000000000) }'")
		itime =  int( result)
		# print result
		if (!istate &&  ( itime > ithreshsec)) { onIchange("Idle  ")  ; istate=1 }
		if ( istate &&  ( itime < ithreshsec)) { onIchange("Active"); istate=0 }

		##### Sit/Stand
		ss = systemcmd( "cat " ssFile " | dos2unix -f | tail -1")
		# ss = substr(ss,1,length(ss)-1)   # trim windows eol
		# if ( length(ss) < 6) { ss = ss substr("      ",1, 6- length(ss))}  # right pad to 6
		# print "|"ss"|"length(ss)
		if ( ss != sspstate ) { onSschange( ss); sspstate=ss }
		

		systemcmd("sleep 1")
	} # while

} # BEGIN
