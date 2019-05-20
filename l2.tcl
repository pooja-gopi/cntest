set ns [new Simulator]

set tl1 [open program2.tr w]
$ns trace-all $tl1

set nl1 [open program2.nam w]
$ns namtrace-all $nl1

set cwind1 [open win2.tr w]
set cwind2 [open win3.tr w]

set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
set n6 [$ns node]

$ns duplex-link $n1 $n3 1.5Mb 5ms DropTail
$ns duplex-link $n2 $n3 1.5Mb 5ms DropTail
$ns duplex-link $n3 $n4 1.5Mb 5ms DropTail
$ns duplex-link $n4 $n5 1.5Mb 5ms DropTail
$ns duplex-link $n4 $n6 1.5Mb 5ms DropTail

$ns duplex-link-op $n1 $n3 orient right-down
$ns duplex-link-op $n2 $n3 orient right-up
$ns duplex-link-op $n3 $n4 orient right
$ns duplex-link-op $n4 $n5 orient right-up
$ns duplex-link-op $n4 $n6 orient right-down

set tcp0 [new Agent/TCP]
$ns attach-agent $n1 $tcp0

set sink0 [new Agent/TCPSink]
$ns attach-agent $n6 $sink0

$ns connect $tcp0 $sink0

set tcp1 [new Agent/TCP]
$ns attach-agent $n2 $tcp1

set sink1 [new Agent/TCPSink]
$ns attach-agent $n5 $sink1

$ns connect $tcp1 $sink1

set ftp [new Application/FTP]
$ftp attach-agent $tcp0

set telnet [new Application/Telnet]
$telnet attach-agent $tcp1

$telnet set type -Telnet

proc PlotWindow {tcpSource file} {
	global ns
	set time 0.01
	set now [$ns now]
	set cwind [$tcpSource set cwnd_]
	puts $file "$now $cwind"
	$ns at [expr $now+$time] "PlotWindow $tcpSource $file" 
}

$ns at 0.2 "$ftp start"
$ns at 3.0 "$ftp stop"

$ns at 3.5 "$telnet start"
$ns at 5.0 "$telnet stop"

$ns at 1.0 "PlotWindow $tcp0 $cwind1"
$ns at 4.0 "PlotWindow $tcp1 $cwind2"

proc finish { } {
	global ns tl1 nl1 cwind1 cwind2
	$ns flush-trace 
	close $tl1
	close $nl1
	exec nam program2.nam &
	exec xgraph win2.tr &
	exec xgraph win3.tr &
	exit 0
}

$ns at 5.5 "finish"
$ns run

