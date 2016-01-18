#!/usr/bin/awk -f
#
# Usage: 
# /usr/sbin/tcpdump -l -s65536 -x -i DEVICE | fil
# and then ping yerself or something
#
# the "margin" variable can be changed to change the size of the margins.
# the "startip" variable defines when to start reading the IP
#  header... this is for when tcpdump decides to break on FDDI
#  interfaces.. 8 (or as it 6?) is the # to use for FDDI, if you
#  need something that tcpdump clips, use the flag to show link
#  layer level headers and set the size of the headers to this
#  variable.
# the "BIGENDIAN" must be set to 1 if you are using a big
#  endian machine (non vax, non pc)
#
# Nirva <nirva@ishiboo.com>
#

BEGIN {
	BIGENDIAN = 0
	margin="   "
	startip=0
	FS = " "
}


$1 ~ /\./ {
#	printf("\n\n%s > %s %s\n**", $2, $4, $5)
	printf("\n----------------------------------------\n**", $2, $4, $5)
	drawn = 0
	next
}

function hexidec(I,N)
{
	for(i=1; i <= N; i++)
	{
		digits[i] = substr(I,i,1)

		if(digits[i] == "a") digits[i] = 10
		else if(digits[i] == "b") digits[i] = 11
		else if(digits[i] == "c") digits[i] = 12
		else if(digits[i] == "d") digits[i] = 13
		else if(digits[i] == "e") digits[i] = 14
		else if(digits[i] == "f") digits[i] = 15
	}

	char1 = digits[1]*16 + digits[2];
	if(N > 2)
		char2 = digits[3]*16 + digits[4];
}

{
	startpos=1;
	if ( $1 ~ /0x/ ) startpos=2;

	for(j=startpos; j <= NF; j++)
	{
		if(length($j) == 4)
		{
			hexidec($j,4)
			analyzebyte(char1)
			analyzebyte(char2)
		}
		else
		{
			hexidec($j,2)
			analyzebyte(char1)
		}
	}
}

function analyzebyte(X)
{
	if(drawn == startip)
	{
		if(BIGENDIAN == 1)
		{
			iplen=X/4;
			printf("IP ver(%d), iplen(%d) ",X%16, iplen/4)
			
		}
		else
		{
			iplen=(X%16)*4;
			printf("IP ver(%d), iplen(%d) ",X/16, X%16)
		}
		packtype=0;
		headlen=0;
	}
	else if(drawn == startip+1)
		printf("TOS(0x%x) ",X)
	else if(drawn == startip+2)
		len=X * 256;
	else if(drawn == startip+3)
	{
		totlen=X+len
		printf("totlen(%d) ",totlen)
	}
	else if(drawn == startip+4)
		len=X * 256;
	else if(drawn == startip+5)
		printf("ID(%u) ",X+len)
	else if(drawn == startip+6)
		len=X * 256;
	else if(drawn == startip+7)
	{
		X += len
		Y=X%8192
		X=X-Y;

		printf("Frag(%d) Flags( ",Y)

		if(X >= 32768)
		{
			printf("MF ")
			X -= 32768
		}
		if(X >= 16384)
			printf("DF ")

		printf(") ")
	}
	else if(drawn == startip+8)
		printf("\n**TTL(%d) ",X)
	else if(drawn == startip+9)
	{
		if(X == 1)
			printf("(**ICMP**) ")
		else if(X == 2)
			printf("(**IGMP**) ")
		else if(X == 6)
			printf("(**TCP**) ")
		else if(X == 17)
			printf("(**UDP**) ")
		packtype=X
	}
	else if(drawn == startip+10)
		len=X*256
	else if(drawn == startip+11)
		printf("Chk(0x%x) ",X+len)
	else if(drawn == startip+12)
		printf("IP(%d.",X)
	else if(drawn == startip+13)
		printf("%d.",X)
	else if(drawn == startip+14)
		printf("%d.",X)
	else if(drawn == startip+15)
		printf("%d->",X)
	else if(drawn == startip+16)
		printf("%d.",X)
	else if(drawn == startip+17)
		printf("%d.",X)
	else if(drawn == startip+18)
		printf("%d.",X)
	else if(drawn == startip+19)
		printf("%d) ",X)
	else if(packtype && headlen && drawn >= startip+headlen+iplen)
	{
		if(!((drawn-startip-headlen-iplen) % 40))
			printf("\n%s",margin);
		if (sprintf("%c", X) >= " " && sprintf("%c", X) <= "~")
			printf("%c", X)
		else
			printf("\\%02X", X)
	}
	else if(packtype == 1) #ICMP
	{
		if(drawn == startip+iplen)
			icmptype=X;
		else if(drawn == startip+iplen+1)
		{
			printf("\n*ICMP---Type(")
			if(icmptype == 0)
			{
				printf("Echo reply")
			}
			else if(icmptype == 3)
			{
				if(X == 0)
					printf("Network unreachable")
				else if(X == 1)
					printf("Host unreachable")
				else if(X == 2)
					printf("Protocol unreachable")
				else if(X == 3)
					printf("Port unreachable")
				else if(X == 4)
					printf("Fragmentation required but DF bit set")
				else if(X == 5)
					printf("Source route failed")
				else if(X == 6)
					printf("Destination network unknown")
				else if(X == 7)
					printf("Destination host unknown")
				else if(X == 8)
					printf("Source host isolated")
				else if(X == 9)
					printf("Destination network administrativly prohibited")
				else if(X == 10)
					printf("Destination host administrativly prohibited")
				else if(X == 11)
					printf("Network unreachable for TOS")
				else if(X == 12)
					printf("Host unreachable for TOS")
				else if(X == 13)
					printf("Communication administrativly prohibited by filtering")
				else if(X == 14)
					printf("Host precedence violation")
				else if(X == 15)
					printf("Precedence cutoff in effect")
				else
					printf("Unknown ICMP code %d (type: detination unreachable)",X)
			}
			else if(icmptype == 4)
				printf("Source Quench")
			else if(icmptype == 5)
			{
				printf("Redirect ")
				if(X == 0)
					printf("for network")
				else if(X == 1)
					printf("for host")
				else if(X == 2)
					printf("for TOS and network")
				else if(X == 3)
					printf("for TOS and host")
				else
					printf("Unknown ICMP code %d (type: redirect)",X)
			}
			else if(icmptype == 8)
				printf("Echo Request")
			else if(icmptype == 9)
				printf("Router Advertisment")
			else if(icmptype == 10)
				printf("Router Solicitation")
			else if(icmptype == 11)
			{
				if(X == 0)
					printf("Time-to-live is 0 during transit")
				else
					printf("Time-to-live is 0 during reassembly")
			}
			else if(icmptype == 12)
			{
				if(X == 0)
					printf("IP header bad")
				else
					printf("Required option missing")
			}
			else if(icmptype == 13)
				printf("Timestamp request")
			else if(icmptype == 14)
				printf("Timestamp reply")
			else if(icmptype == 17)
				printf("Address mask request")
			else if(icmptype == 18)
				printf("Address mask reply")
			else
				printf("Unknown ICMP type %d",icmptype)
			printf(") ")
	
		}
		else if(drawn == startip+iplen+2)
			len=X*256
		else if(drawn == startip+iplen+3)
			printf("ICMP-Chk(0x%x) ",X+len)
	}
	else if(packtype == 6) #TCP
	{
		if(drawn == startip+iplen)
			len=X*256
		else if(drawn == startip+iplen+1)
			printf("\n*TCP---Ports(**%d->",X+len)
		else if(drawn == startip+iplen+2)
			len=X*256
		else if(drawn == startip+iplen+3)
			printf("%d**) ",X+len)
		else if(drawn == startip+iplen+12)
			len=X*256
		else if(drawn == startip+iplen+13)
		{
			X += len
			headlen=X-(X%4096)
			headlen /= 1024
			datalen=totlen-headlen
			X = X-(X-(X%64))
	
			printf("tcplen(%d) Flags( ",headlen)
	
			if(X >= 32)
			{
				printf("URG ")
				X -= 32
			}
			if(X >= 16)
			{
				printf("ACK ")
				X -= 16
			}
			if(X >= 8)
			{
				printf("PSH ")
				X -= 8
			}
			if(X >= 4)
			{
				printf("RST ")
				X -= 4
			}
			if(X >= 2)
			{
				printf("SYN ")
				X -= 16
			}
			if(X >= 1)
				printf("FIN ")
	
			printf(") ")
		}
		else if(drawn == startip+iplen+14)
			len=X*256
		else if(drawn == startip+iplen+15)
			printf("\n*TCP---Win(%d) ",X+len)
		else if(drawn == iplen+16)
			len=X*256
		else if(drawn == startip+iplen+17)
			printf("TCP-Chk(0x%x) ",X+len)
		else if(drawn == startip+iplen+18)
			len=X*256
		else if(drawn == startip+iplen+19)
			printf("TCP-URG(%d)\n%s",X+len,margin)
	}
	else if(packtype == 17) #UDP
	{
		if(drawn == startip+iplen)
			len=X*256
		else if(drawn == startip+iplen+1)
			printf("\n*UDP---Ports(**%d->",X+len)
		else if(drawn == startip+iplen+2)
			len=X*256
		else if(drawn == startip+iplen+3)
			printf("%d**) ",X+len)
		else if(drawn == startip+iplen+4)
			len=X*256
		else if(drawn == startip+iplen+5)
		{
			headlen=8
			datalen=X+len-headlen
			printf("udplen(%d) ",headlen)
		}
		else if(drawn == startip+iplen+6)
			len=X*256
		else if(drawn == startip+iplen+7)
			printf("UDP-Chk(0x%x) ",X+len)
	}
	drawn++;
	return;
}

