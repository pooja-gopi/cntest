BEGIN {
	count=0;
	time=0;
	}
{
	if($1=="r"&&$5=="tcp"&&$4==1)
	{
		count+=$6;
		time+=$2;
		print " "count;
	}
}
END {

}