dm 'log; clear; output; clear';
*Sale.sas- -Kuai, Xuan- -11/22/2016;
*EXST 4025 Final Practical Exam;
options pageno=1
	nodate
	rightmargin=.75in
	leftmargin=.75in
	topmargin=.8in
	bottommargin=.5in;
ods listing;
ods html close;
ods graphics off;
title1 'Kuai, Xuan';
title2 'EXST 4025 Final Practical Exam';

libname final 'C:\Temp';

proc format;
	value $animal 'C'='Calf'
				  'L'='Lamb'
				  'P'='Pig';
run;

data work.animals;
	infile 'animals.txt';
	input @1  OwnerID $3.
		  @4  Type $1.
		  @5  Tag $3.
		  @8  Wt comma5.
		  @13 PossDate date7.;
	format Type $animal.
		   Wt comma5.
		   PossDate mmddyy8.;
	label PossDate='Possession Date';
run;

proc sort data=work.animals;
	by OwnerID;
run;

data work.saletemp;
	length Owner $ 16;
	merge final.Exhibitors(in=inExhi)
		  work.animals(in=inAnim);
	by OwnerID;
	if inExhi and inAnim;
	Name=propcase(Name);
	Owner=catx(' ',scan(Name,2,','),scan(Name,1,','));
	select(Type);
		when('C') SalePrice=Wt*3;
		when('P') SalePrice=Wt*5;
		otherwise do;
			if Wt<105 then SalePrice=Wt*8;
			else if Wt>=135 then SalePrice=Wt*7.5;
			else SalePrice=Wt*7.75;
		end;
	end;
	DaysOwned=today()-PossDate;
	label DaysOwned='Days Owned'
		  SalePrice='Sale Price';
	format SalePrice dollar9.2;
run;

proc sort data=work.saletemp
		  out=final.sale;
	by Tag;
run;

proc print data=final.sale label noobs;
	var Tag
		Type
		Wt
		SalePrice
		Owner;
	title4 'Livestock Sale Data';
run;

proc sort data=final.sale
		  out=work.sorted;
	by Name;
run;

proc print data=work.sorted label;
	by Name;
	id Name;
	var Tag
		Type
		Wt
		SalePrice
		PossDate
		DaysOwned;
	sum SalePrice;
	format SalePrice dollar10.2;
	title4 'Livestock Sale Data by Exhibitor';
run;

options nolabel;

proc means data=final.sale mean min max sum maxdec=1;
	var Wt
		SalePrice
		DaysOwned;
	class Type;
	title4 'Livestock Sale Data Summarized by Animal';
run;

options label;

proc contents data=final.sale;
	title4 'Livestock Sale Data';
run;
