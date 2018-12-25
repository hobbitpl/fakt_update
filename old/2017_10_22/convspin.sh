#!/usr/bin/awk -f

# przyk³adowe wywo³anie programu: ./convspin.sh col=2 filename.txt
#
# "k20060106#00003#00000"
# "k";2006-01-06;00003 
#
#
#
#
#


BEGIN	{
	FS = ";";
	OFS=";";
	i = 1;
	}

	function extr(str ) 
	{
		return ( substr(str,1,2) "\";" substr(str,3,4) "-" substr(str,7,2) "-" substr(str,9,2) ";" substr(str,12,5) ) 
	}


	{
		sub ( $col , extr($col), $col)
		print $0
	}


