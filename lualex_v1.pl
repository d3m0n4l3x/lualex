#!/usr/bin/perl -w
#TCPKill Example:tcpkill -i wlan0 -9 host 52.22.130.181 and tcp port 443
#Blacklist Path: /usr/local/sbin/lualex/blacklist.lst
#Format of Blacklist: IP1-IP2
#Example of Blacklist: 192.168.0.2-52.22.130.181
use Thread;
$|=1;


$interface='wlan0';
$tcpkill_command='/usr/sbin/tcpkill';
$blacklist='/usr/local/sbin/lualex/blacklist.lst';
$timeout_command='/usr/bin/timeout';
$blocking_period=1800;				#30 minutes
$app_rerun_freq=$blocking_period*2;


sub check(){
	if( -e $tcpkill_command) {
		;
	}else{
		die "$tcpkill_command does not exist!\n";
	}
	if( -e $blacklist) {
		;
	}else{
		die "$blacklist does not exist!\n";
	}
	if( -e $timeout_command) {
		;
	}else{
		die "$timeout_command does not exist!\n";
	}
	return;
}


sub kill_conn($$){
	$ip_1=shift;
	$ip_2=shift;
	Thread->self->detach;
	$whole_command="$timeout_command $blocking_period $tcpkill_command -i $interface -9 host $ip_1 and host $ip_2";
	system("$whole_command");
	return;
}


#sub main()
while(1){
	open(BLACKLIST, $blacklist);
	@blacklist_array=<BLACKLIST>;
	chomp(@blacklist_array);
	close(BLACKLIST);
	
	foreach $each_line (@blacklist_array){
		if($each_line=~/(.*)-(.*)/){
			$ip1=$1;
			$ip2=$2;
			print "$ip1-$ip2\n";			#Debug
			Thread->new(\&kill_conn, $ip1, $ip2);
		}
	}
	sleep($app_rerun_freq);
}