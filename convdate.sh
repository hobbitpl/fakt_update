#!/usr/bin/awk -f

# przyk¿adowe wywo¿anie programu: ./convdate.sh col=2 filename.txt



BEGIN	{
	FS = ";";
	OFS=";";
	i = 1;
	}

	function revdate(str) 
	{
		return ( substr(str,7,4) "-" substr(str,4,2) "-" substr(str,1,2) ) 
	}


	{
		sub ( $col , revdate($col), $col)
		print $0
	}
