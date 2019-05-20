set val(chan)   Channel/WirelessChannel
set val(prop)   Propagation/TwoRayGround
set val(netif)  Phy/WirelessPhy
set val(mac)    Mac/802_11
set val(ifq)    Queue/DropTail/PriQueue
set val(ifq)    CMUPriQueue
set val(ll)     LL
set val(ant)    Antenna/OmniAntenna
set val(x)      200
set val(y)      300  
set val(ifqlen) 50
set val(nn)     7
set val(stop)   100.0
set val(rp)     AODV
set val(cp)     "cbrgen"
set val(sc)     "set"

set ns_ [new Simulator]

set tl8 [open l8.tr w]
$ns_ trace-all $tl8

set nl8 [open l8.nam w]
$ns_ namtrace-all-wireless $nl8 $val(x) $val(y)

set prop [new $val(prop)]

set topo [new Topography]
$topo load_flatgrid $val(x) $val(y)

set god_ [create-god $val(nn)]

$ns_ node-config  -adhocRouting $val(rp) \
           -llType $val(ll) \
           -macType $val(mac) \
           -ifqType $val(ifq) \
           -ifqLen $val(ifqlen) \
           -antType  $val(ant) \
           -propType $val(prop) \
           -phyType $val(netif) \
           -channelType $val(chan) \
           -topoInstance $topo \
           -agentTrace ON \
           -routerTrace ON \
           -macTrace ON
         
#Creating nodes
for {set i 0} {$i < $val(nn) } {incr i} {
    set node_($i) [$ns_ node]
    $node_($i) random-motion 0
    }
    
for {set i 0} {$i < $val(nn) } {incr i} {
    set xx [expr rand()*500]
    set yy [expr rand()*400]
    $node_($i) set X_ $xx
    $node_($i) set Y_ $yy
    } 
    
for {set i 0} {$i < $val(nn) } {incr i} {
    $ns_ initial_node_pos $node_($i) 40
    }
  
puts "loading connection file..."
source $val(cp)
puts "loading connection file..."
source $val(sc)

exec  nam l8.nam &

for {set i 0} {$i < $val(nn) } {incr i} {
    $ns_ at $val(stop) "$node_($i) reset" ;
    }
    
$ns_ at $val(stop) "puts \"NS EXITING...\" ; $ns_ halt"
puts "Starting Simualtion..."

$ns_ run
