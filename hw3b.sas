dm 'log; clear; output; clear';
*HW3b.sas- -Kuai, Xuan- -10/1/2016;
*EXST 4025 Assignment 3;
*Processes exam data;
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

libname hw3 'E:\EXST_4025\Assignment_3';

data work.take;
	infile 'HW3Exam2Take.csv' dsd;
	input StudentID $
		  Score;
run;

data work.retake;
	infile 'HW3Exam2Retake.csv' dsd;
	input StudentID $
		  Score;
run;

proc sort data=work.take;
	by StudentID;
run;

proc sort data=work.retake;
	by StudentID;
run;

data work.grades;
	merge hw3.HW3Students
		  work.take(rename=(StudentID=ID
							Score=Take))
		  work.retake(rename=(StudentID=ID
							  Score=Retake));
	by ID;
	*Switches scores for the students;
	*with "Retake" but without "Take";
	if Take=. and Retake~=. then do;
		Take=Retake;
		Retake=.;
	end;
	*Sets "Exam2" score equal to "Retake";
	*for the students have "Retake" score;
	*Otherwise sets "Exam2" score
	*equal to "Take" score;
	if Retake~=. then Exam2=Retake;
	else Exam2=Take;
	*Calculate the difference between;
	*"Retake" score and "Take" score;
	Diff=Retake-Take;
	format Take Retake Exam2 Diff 5.1;
	label Sec='Section'
		  Diff='Difference';
run;

proc sort data=work.grades
		  out=hw3.HW3Exam2Grades;
	by Sec Name;
run;

title4 'Exam 2 Grades';

proc contents data=hw3.HW3Exam2Grades;
run;

proc print data=hw3.HW3Exam2Grades noobs label n;
	var ID
		Name
		Exam2
		Take
		Retake
		Diff;
	by Sec;
	title5 'By Section';
run;

proc means data=hw3.HW3Exam2Grades maxdec=1 nonobs n mean min max median nmiss;
	var Exam2
		Take
		Retake
		Diff;
	title5;
run;

options nolabel;

proc means data=hw3.HW3Exam2Grades fw=6;
	class Sec;
	title5 'By Section';
run;

options label;

proc format;
	value tier low-<60='F'
			   60-<70='D'
			   70-<80='C'
			   80-<90='B'
			   90-high='A';
run;

proc freq data=hw3.HW3Exam2Grades order=formatted;
	format Exam2 tier.;
	tables Exam2
		   Exam2*Sec;
	title5;
run;

proc freq data=hw3.HW3Exam2Grades;
	tables Exam2
		   Take
		   Retake
		   Diff;
run;

proc tabulate data=hw3.HW3Exam2Grades format=4.;
	class Sec
		  Exam2;
	table Exam2 all,
		  Sec*n all;
	format Exam2 tier.;
run;

proc univariate data=hw3.HW3Exam2Grades plot;
	var Exam2;
run;
