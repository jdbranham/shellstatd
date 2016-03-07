#!/usr/bin/perl

use strict;
use warnings;

use IO::Socket;
use IO::Socket::INET;
use Getopt::Long;

my $server = "localhost";
my $serverPort = 80;
my $localInterface = "eth0";
my $protocol = "tcp";
my $data = "GET / HTTP/1.1\r\n\r\n";

GetOptions (
    "server=s"     => \$server,     # string
    "serverPort=s" => \$serverPort, # string
    "local=s"  => \$localInterface,
    "protocol=s" => \$protocol,
    "data=s" => \$data
) or die("Error in command line arguments\n: \$");  # flag

my @ips = (`/sbin/ifconfig -a | grep -A1 $localInterface` =~ /inet addr:(\S+)/g);
my $localAdd = $ips[0] or die("Unable to get ip for local interface: $localInterface");

my $PeerAddr;

my $packed_ip = gethostbyname($server);
    if (defined $packed_ip) {
        $PeerAddr = inet_ntoa($packed_ip);
    }
    else {die("No IP address found for: $server")}

printf "Attempting to connect -\n";
printf "Remote Server: %s\n", $server;
printf "Remote IP: %s\n", $PeerAddr;
printf "Remote Port: %s\n", $serverPort;
printf "Local Network Interface: %s\n", $localInterface;

# creating object interface of IO::Socket::INET modules which internally does 
# socket creation, binding on the specified port address.
my $socket = new IO::Socket::INET(
    #PeerAddr    => $PeerAddr,
    #PeerPort    => $serverPort,
    Proto       => $protocol,
    LocalAddr   => $localAdd
) or die("Can't connect to server: $!");

my $iaddr = inet_aton($PeerAddr) 
    or die "Unable to resolve hostname : $PeerAddr";
my $paddr = sockaddr_in($serverPort, $iaddr);    #socket address structure
 
connect($socket , $paddr) 
    or die "connect failed : $!";
print "Connected to $PeerAddr on port $serverPort\n";

print "Sending data to socket: $data";
send($socket, $data, 0) or die("Send failed: $!");

print "Recieving data from socket";
# Receive reply from server - perl way of reading from stream
# can also do recv($sock, $msg, 2000 , 0);
while (my $line = <$socket>) {
	print $line;
}
END{
	# notify server that request has been sent
	shutdown($socket, 1);
	close($socket) or die("Close: $!");
}

exit(0);