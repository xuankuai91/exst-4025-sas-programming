dm 'log; clear; output; clear';
*HW3a.sas- -Kuai, Xuan- -10/1/2016;
*EXST 4025 Assignment 3;
*Creates SAS data set of students;
options pageno=1
	nodate
	rightmargin=.6in
	leftmargin=.6in
	topmargin=.6in
	bottommargin=.5in;
ods listing;
ods html close;
ods graphics off;
title1 'Kuai, Xuan';
title2 'EXST 4025 Assignment 3';

title4 'Students';

libname hw3xls 'E:\EXST_4025\Assignment_3\HW3ClassList.xls';
libname hw3 'E:\EXST_4025\Assignment_3';

proc sort data=hw3xls.'ClassList$'n
		  out=hw3.HW3Students;
	by ID;
run;

proc contents data=hw3.HW3Students;	
run;

libname hw3xls clear;
