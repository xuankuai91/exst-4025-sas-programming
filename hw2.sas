dm 'log; clear; output; clear';
*HW2.sas- -Kuai, Xuan- -09/15/2016;
*EXST 4025 Assignment 2;
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
title2 'EXST 4025 Assignment 2';

libname hw2 'E:\EXST_4025\Assignment_2';

data work.Exam_Grade;
	infile 'HW2Exam.csv' dsd;
	input ID $
		  Last :$10.
		  First $
		  Classification $
		  Date_Taken :mmddyy.
		  Part_1
		  Part_2
		  Donation :dollar7.2;
	Total_Score=sum(Part_1,Part_2);
	Total_Point=Total_Score*2.5;
	Exam_Day=weekday(Date_Taken);
	label Last='Last Name'
		  First='First Name'
		  Classification='Class'
		  Date_Taken='Exam Date'
		  Donation='Food Bank Donation'
		  Total_Score='Correct Answers'
		  Total_Point='Points'
		  Exam_Day='Exam Day';
	format Date_Taken date9.
		   Donation dollar7.2
		   Total_Point 5.1;
	drop Part_1
		 Part_2;
run;

proc sort data=work.Exam_Grade
		  out=hw2.HW2Exam;
	by ID;
run;

title4 'Exam 1 Data';

proc contents data=hw2.HW2Exam;
run;

proc print data=hw2.HW2Exam noobs label;
	var ID
		Last
		First
		Classification
		Date_Taken
		Exam_Day
		Total_Score
		Total_Point
		Donation;
	sum Donation;
run;

proc format;
	value grade 1='Freshman'
				2='Sophomore'
				3='Junior'
				4='Senior'
				6-7='Grad';
	value wkday 2='Mon'
				3='Tue'
				4='Wed'
				5='Thu'
				6='Fri';
	value tier low-<60='F'
			   60-69='D'
			   70-79='C'
			   80-89='B'
			   90-high='A';
run;

proc sort data=hw2.HW2Exam;
		  out=work.Sorted;
	by Last First;
run;

ods html file='E:\EXST_4025\Assignment_2\HW2.html';

proc print data=work.Sorted noobs label;
	var ID
		Last
		First
		Classification
		Date_Taken
		Exam_Day
		Total_Score
		Total_Point
		Donation;
	format Classification grade.
		   Exam_Day wkday.
		   Total_Point tier.;
	sum Donation;
	label Total_Point='Letter Grade';
run;

ods html close;
