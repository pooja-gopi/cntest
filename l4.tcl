#create simulator
set ns [new Simulator]

#tracing simulator results
set tl4 [open l4.tr w]
$ns trace-all $tl4

#tracing NAM results
set nl4 [open l4.nam w]
$ns namtrace-all $nl4

set cwind1 [open win5.tr w]

#create 6 nodes
set n0 [$ns node]
set n1 [$ns node]

#connecting nodes
$ns duplex-link $n0 $n1 10Mb 22ms DropTail

#orientation
$ns duplex-link-op $n0 $n1 orient right

#create tcp agent
set tcp0 [new Agent/TCP]
$ns attach-agent $n0 $tcp0

#create tcp receiver
set tcp1 [new Agent/TCPSink]
$ns attach-agent $n1 $tcp1

#connect tcp agents
$ns connect $tcp0 $tcp1

#create ftp objects
set ftp [new Application/FTP]

#attach ftp with agent tcp0
$ftp attach-agent $tcp0

#to set packet size
$tcp0 set packetsize_ 1500

#schedule events for ftp
$ns at 0.2 "$ftp start"
$ns at 4.0 "$ftp stop"
proc PlotWindow {tcpSource file} {
	global ns
	set time 0.01
	set now [$ns now]
	set cwind [$tcpSource set cwnd_]
	puts $file "$now $cwind"
	$ns at [expr $now+$time] "PlotWindow $tcpSource $file"
	}

$ns at 0.3 "PlotWindow $tcp0 $cwind1"
#procedure finish
proc finish {} {
 global ns tl4 nl4
 $ns flush-trace
 close $tl4
 close $nl4
 exec nam l4.nam &
 exec awk -F p4.awk l4.tr &
 exec awk -F p4convert.awk l4.tr > win5.tr &
 exec xgraph win5.tr -t "No of bytes received by client" -x "No of secs" -y "Bytes" & 
 exit 0
}

#schedule execution at procedure
$ns at 4.5 "finish"

#to run
$ns run
