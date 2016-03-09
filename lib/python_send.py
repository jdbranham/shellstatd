#!/usr/bin/env python

import socket
import struct
import sys
import getopt
import pickle
import re
from itertools import groupby
from operator import itemgetter
try:
    import fcntl
except ImportError:
	print "INFO: fcntl module not available on Windows\n"
	
verbose = False

def usage():
  print "Usage: [data to send] | python_send.py --server=[host/ip] [OPTION]=[value]...\n"
  print "The body data should be sent via standard input to this script."
  print "UDP Example: echo \"servers.hostname.up 1 1457373595\" | python_send.py --server=127.0.0.1 --port=2003"
  print "TCP Example: echo \"servers.hostname.up 1 1457373595\" | python_send.py --server=127.0.0.1 --port=2004 --protocol=tcp --pickle=true\n"
  print "OPTIONS"
  print "--server                 Required - The server to connect to."
  print "--interface              default 'eth0' - Linux only! The network interface to bind and send from."
  print "--source-ip              default '0.0.0.0' - The source IP to bind and send from. Overrides --interface option"
  print "--port                   default '2003' - The port to connect to."
  print "--pickle                 default 'true if tcp' - Use the pickle protocol."
  print "--protocol               default 'udp' - Valid values are [tcp, udp]."
  print "--verbose                default 'false' - Valid values are [True, False]."

def get_ip_address(ifname):
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    return socket.inet_ntoa(fcntl.ioctl(
        s.fileno(),
        0x8915,  # SIOCGIFADDR
        struct.pack('256s', ifname[:15])
    )[20:24])
    
def getTuples(lines):
	if verbose: print "Lines: ", lines
	tuples = ([])
	splitLines = []
	for line in lines:
		line = re.sub('[\'\n]', '', line)
		lineParts = line.rsplit()
		if len(lineParts) > 2:
			tuples.append((lineParts[0], (lineParts[2], lineParts[1])))
	if verbose: print "Tuples: ", tuples
	return tuples

def main(argv):

	BUFFER_SIZE = 1024
	netInterface = "eth0"
	port = 2003
	pickleFormat = False
	socketType = socket.SOCK_DGRAM
	sourceIp = "0.0.0.0"
	server = False
	
	try:
		opts, args = getopt.getopt(argv, ":isp", ["interface=", "server=", "port=", "pickle=", "protocol=", "source-ip=", "verbose="])
	except getopt.GetoptError:
		usage()
		sys.exit(2)
	for opt, arg in opts:
		if opt in ("-i", "--interface"):
			netInterface = arg
			sourceIp = get_ip_address(netInterface)
		elif opt in ("-s", "--server"):
			server = arg
		elif opt in ("-p", "--port"):
			port = int(arg)
		elif opt in ("--pickle"):
			pickleFormat = arg
		elif opt in ("--protocol"):
			if arg == "udp":
				socketType = socket.SOCK_DGRAM
			elif arg == "tcp":
				socketType = socket.SOCK_STREAM
				pickleFormat = True
			else:
				print arg + " is not a valid protocol setting\n"
				usage()
				sys.exit(2)
		elif opt in ("--source-ip"):
			sourceIp = arg
		elif opt in ("--verbose"):
			global verbose
			verbose  = arg
	
	if not server:
		print "ERROR: --server is a required argument\n"
		usage()
		sys.exit(2)
	
	serverIp = socket.gethostbyname(server)
	if verbose:
		print "Using source-ip: "+sourceIp
		print "Using server: "+server
		print "Using server-ip: "+serverIp
		print "Using port: "+str(port)
	
	stdin = sys.stdin.readlines()
			
	if pickleFormat:
		if verbose: print "Using pickle format: true"
		tuples = getTuples(stdin)
		payload = pickle.dumps(tuples, protocol=2)
		header = struct.pack("!L", len(payload))
		message = header + payload
	else:
		if verbose: print "Using pickle format: false"
		message = stdin[0]
		
	
	s = socket.socket(socket.AF_INET, socketType)
	s.bind((sourceIp, 0))
	peerAddress = (server, port)
	s.connect(peerAddress)
	if verbose and !pickleFormat: print "Sending message: " + message
	s.sendall(message)
	s.close()

if __name__ =='__main__':
	main(sys.argv[1:])