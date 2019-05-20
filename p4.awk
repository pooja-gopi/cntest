BEGIN {
	b_s=0;
	b_r=0;
}
{
	if($1=="r"&&$5=="tcp"&&$4==1)
		b_r+=$6;
	if($1=="+"&&$5=="tcp"&&$3==0)
		b_s+=$6;
}
END {
	printf("Data sent:%d kbps\n",(b_s)*(1/1000));
	printf("Data received:%d kbps\n",(b_r)*(1/1000));
}