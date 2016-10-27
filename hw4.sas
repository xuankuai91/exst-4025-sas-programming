dm 'log; clear; output; clear';
*HW4.sas- -Kuai, Xuan- -10/23/2016;
*EXST 4025 Assignment 4;
options pageno=1
	nodate
	rightmargin=.75in
	leftmargin=.75in
	topmargin=1in
	bottommargin=.5in
	noxwait
	xsync;

data _null_;
	call system("erase E:\EXST_4025\Assignment_4\HW4CrabTotals2.xlsx");
run;

ods listing;
ods html close;
ods graphics off;
title1 'Kuai, Xuan';
title2 'EXST 4025 Assignment 4';

libname hw4 'E:\EXST_4025\Assignment_4';
libname hw4xls 'E:\EXST_4025\Assignment_4\HW4CrabTotals2.xlsx';

data hw4.HW4Crabs11;
	infile 'HW4Crabs11.txt' missover;
	input @1 State $4.
		  @5 Type $13.
		  @18 Pounds comma10.
		  @28 Value dollar11.
		  @39 PricePerLb 4.2;
	format Pounds comma10.
		   Value dollar11.
		   PricePerLb 4.2;
run;

proc print data=hw4.HW4Crabs11;
	title4 'U.S. Blue Crab Harvest Value 2011';
run;

data work.HW4CrabsAll;
	set hw4.HW4Crabs09_10
		hw4.HW4Crabs11 (in=in2011);
	if in2011 then Year=2011;
	if State in ('EFL','WFL','ILFL') then State='FL';
	if Value ne .;
	drop Pounds
		 PricePerLb;
run;

proc sort data=work.HW4CrabsAll
		  out=hw4.HW4CrabsAll;
	by Year
	   State;
run;

title4 'U.S. Blue Crab Harvest Value 2009-2011';

proc contents data=hw4.HW4CrabsAll;
run;

data hw4.HW4CrabTotals1;
	set hw4.HW4CrabsAll;
	by Year
	   State;
	if first.State then TotalValue=0;
	TotalValue+Value;
	if last.State;
	keep Year
		 State
		 TotalValue;
	format TotalValue dollar12.;
run;

proc contents data=hw4.HW4CrabTotals1;
run;

proc print data=hw4.HW4CrabTotals1;
	by Year;
	id Year;
	sum TotalValue;
run;

options nolabel;

proc means data=hw4.HW4CrabsAll sum maxdec=0;
	var Value;
	class Year
		  State;
	output out=hw4.HW4CrabMeans sum=SumValue;
	title4 'U.S. Blue Crab Harvest 2009-2011 Summary Data from PROC MEANS';
run;

options label;

proc print data=hw4.HW4CrabMeans noobs;
	format SumValue dollar12.;
run;

data hw4xls.CrabValue;
	set hw4.HW4CrabMeans;
	if _TYPE_=3;
	keep Year
		 State
		 SumValue;
run;
