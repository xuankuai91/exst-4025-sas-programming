dm 'log; clear; output; clear';
*HW1.sas- -Kuai, Xuan- -09/02/2016;
*EXST 4025 Assignment 1;
options pageno=1
	nodate
	rightmargin=.75in
	leftmargin=.75in
	topmargin=1in
	bottommargin=.5in;
ods listing;
ods html close;
ods graphics off;
title1 'Kuai, Xuan';
title2 'EXST 4025 Assignment 1';

libname hw1a 'E:\EXST_4025\Assignment_1';

title4 'Orion Sales Representatives';

proc contents data=hw1a.Hw1Sales;
run;

data work.US_Low_F;
	set hw1a.Hw1Sales;
	where Gender = 'F' and
		  Country = 'US' and
		  Salary <= 27250;
	format Salary comma6.
		   Birth_Date Hire_Date mmddyy8.;
	label Employee_Id='ID'
		  First_Name='First'
		  Last_Name='Last'
		  Job_Title='Position'
		  Birth_Date='Birth Date'
		  Hire_Date='Hired';
run;

title5 'Us Female Employees Earning $27,250 or Less';

proc print data=work.US_Low_F noobs label;
	var First_Name
		Last_Name
		Salary
		Job_Title
		Birth_Date
		Hire_Date;
run;

proc sort data=work.US_Low_F;
	by Job_Title;
run;

proc print data=work.US_Low_F label n;
	var Employee_ID
		First_Name
		Last_Name
		Salary;
	by Job_Title;
	sum Salary;
	format Salary comma7.;
run;

libname hw1b 'E:\EXST_4025\Assignment_1\HW1Sales.xls';

data work.US_M_rep3_4;
	set hw1b.'UnitedStates$'n;
	where Gender='M' and
		  Job_Title in ('Sales Rep. III' 'Sales Rep. Iv');
	keep First_Name
		 Last_Name
		 Salary
		 Job_Title
		 Hire_Date;
	format Salary dollar7.
		   Hire_Date date9.;
	label First_Name='First'
		  Last_Name='Last'
		  Job_Title='Position'
		  Hire_Date='Hired';
run;

proc sort data=work.US_M_rep3_4;
	by descending Salary;
run;

title5 'US Male Sales Reps III and IV';

proc print data=work.US_M_rep3_4 noobs label;
run;

proc sort data=work.US_M_rep3_4;
	by Job_Title;
run;

proc print data=work.US_M_rep3_4 noobs label n;
	var Job_Title
		First_Name
		Last_Name
		Salary;
	by Job_Title;
	id Job_Title;
	sum Salary;
	format Salary dollar8.;
run;
