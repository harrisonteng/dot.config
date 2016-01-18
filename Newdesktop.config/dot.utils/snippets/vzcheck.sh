#!/bin/sh

silent=0
percent=5
all=0
orig_size=0
execute=0
help="usage: $0 [options]\n
    Valid options are:\n
\t-s - silent mode\n
\t-p <num> faulty percents\n
\t-a show all information\n
\t-m show numbers as original value, not K/M/G\n
\t-x execute 'vzctl set' command for fixes\n
"

while [ $# -gt 0 ]; do
    case "$1" in
     -a) all=1
        ;;
     -s) silent=1
        ;;
     -p) percent=$2
         shift
	;;
     -m) orig_size=1
        ;;
     -x) execute=1
	;;
      *) echo -e $help
         exit 1
    esac
    shift
done

awk '
BEGIN {
    KILO = 1024;
    MEGA = KILO * 1024;
    GIGA = MEGA * 1024;
    PERCENT = '"$percent"';
    SILENT  = '"$silent"';
    EXECUTE = '"$execute"';
    ALL='"$all"';
}

function overflowed (v1, v2)
{
    if (v2 == 0)
	return 0;
    v1 += v1/100 * PERCENT;
    return (v1 >= v2);
}

function say_num(val)
{
    if (!'$orig_size')
    {
	if (val >= GIGA)
	    return sprintf ("%.fG", val / GIGA);
	    
	if (val >= MEGA)
	    return sprintf ("%.fM", val / MEGA);
	    
	if (val >= KILO)
	    return sprintf ("%.fK", val / KILO);
    }
    return sprintf ("%d", val);
}

function increase_limit(soft,hard)
{
    delta = soft / 10;
    if (delta == 0)
	delta = 5;
    soft += delta;
    if (overflowed(soft, hard))
    {
	delta = hard / 10;
	if (delta == 0)
	    delta = 5;
	hard += delta;
    }
    return sprintf ("%d:%d", soft, hard);
}

function read_line(uid, res, held, maxheld, barrier, limit, failcnt)
{
	    if (ALL == 0 && failcnt == 0)
		return 0;
		
	    status = " -- FIXED";
	    if (failcnt != 0 && overflowed(maxheld, barrier))
	    {
		status = " !!! FIXME";
		cmd = sprintf ("vzctl set %s --%s %s --save\n", 
			    uid, res,
			    increase_limit(barrier, limit));
		printf ("%s", cmd);
		if (EXECUTE)
		    system (cmd);
	    }
	    if (SILENT)
		return 0;
 	    printf ("#%s %-10s:\tused:%5s:%-5s\tlim:%5s:%-5s\t%s(%s)\n", 
			    uid, res, 
			    say_num(held),
			    say_num(maxheld),
			    say_num(barrier), 
			    say_num(limit), 
			    status,
			    say_num(failcnt));
	    return 1;
}
$1 == "uid" { next }

NF == 7 {
	    
	    host=strtonum ($1); 
	    nf += read_line(host, $2, $3, $4, $5, $6, $7);
}

NF == 6 {
	    nf += read_line(host, $1, $2, $3, $4, $5, $6);
}

END  {
	if (!SILENT && nf == 0) printf ("All are OK!\n"); 
}
' </proc/user_beancounters
