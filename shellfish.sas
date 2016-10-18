dm 'log; clear; output; clear';
*Shellfish.sas- -Kuai, Xuan- -10/11/2016;
*EXST 4025 Mid-Term Practical Exam;
options pageno=1
	nodate label
	rightmargin=.5in
	leftmargin=.5in
	topmargin=.5in
	bottommargin=.5in;
ods listing;
ods html close;
ods graphics off;
title1 'Kuai, Xuan';
title2 'EXST 4025 Mid-Term Practical Exam';

libname fish 'C:\Temp';
libname fishxlsx 'C:\Temp\GulfShellfish.xlsx';

data work.crabs;
	infile 'crabs.txt' dlm='~';
	input Year
		  State :$2.
		  Species :$10.
		  Pounds :comma.
		  Value :dollar.;
run;

proc sort data=work.crabs;
	by Year
	   State
	   Species;
run;

data work.shellfish;
	length Species $ 15;
	set work.crabs
		fishxlsx.'oysters$'n
		fish.shrimp;
	by Year
	   State;
	PricePerLb=Value/Pounds;
	if State='TX' then Checkoff=Value*0.00175;
	else if State='LA' then do;
		if Species='CRAB, BLUE' then Checkoff=Value*0.00125;
		else if Species='OYSTER, EASTERN' then Checkoff=Value*0.001;
		else Checkoff=Value*0.0015;
	end;
	else Checkoff=Value*0.002;
	format Pounds comma13.
		   Value dollar15.
		   Checkoff dollar10.
		   PricePerLb dollar6.2;
	label PricePerLb='Price/Lb.';
run;

proc sort data=work.shellfish
		  out=fish.Shellfish;
	by State
	   Species
	   Year;
run;

title4 'Gulf Coast Shellfish Harvest 2006-2011';

proc contents data=fish.Shellfish;
run;

proc print data=fish.Shellfish label;
	by State;
	id State;
	sum Pounds
		Value
		Checkoff;
run;

proc format;
	value $name AL='Alabama'
				FL='Florida'
				LA='Louisiana'
				MS='Mississippi'
				TX='Texas';
run;

proc print data=fish.Shellfish label noobs;
	by State;
	format State $name.;
	sum Pounds
		Value
		Checkoff;
	where Year=2011;
	title4 'Gulf Coast Shellfish Harvest 2011';
run;

options nolabel;

proc means data=fish.Shellfish mean min max maxdec=2;
	var Pounds
		Value
		PricePerLb
		Checkoff;
	class Species
		  State;
	where State in ('LA', 'TX');
	title4 'Louisiana and Texas Shellfish Harvest 2006-2011 Summary';
run;

options label;

libname fishxlsx clear;
