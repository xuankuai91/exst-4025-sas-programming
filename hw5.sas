dm 'log; clear; output; clear';
*HW5.sas- -Kuai, Xuan- -10/27/2016;
*EXST 4025 Assignment 5;
options pageno=1
	nodate
	rightmargin=.75in
	leftmargin=.75in
	topmargin=.5in
	bottommargin=.5in;
ods listing;
ods html close;
ods graphics off;
title1 'Kuai, Xuan';
title2 'EXST 4025 Assignment 5';

libname hw5 'E:\EXST_4025\Assignment_5';
libname library 'E:\EXST_4025\Assignment_5';

data hw5.A_recs (keep=AccNo
					  AccDate
					  WkDay
					  Pop
					  RoadClass
					  LightCond
					  FirstHarm
					  AccSev
					  Weather
					  SurfCond
					  TotalVeh)
	 hw5.B_recs (keep=AccNo
	 				  VYr
					  VStyle
					  VType
					  DrvAge
					  DrvSex
					  Ins
					  DrvID
					  DrvInj
					  VOccs)
	 hw5.C_recs (keep=AccNo
	 				  CasAge
					  CasSex
					  CasVeh
					  CasInj);
*End of the DATA statement;
	infile 'HW5TXAccs2001.txt' missover;
	length AccNo $ 7
		   /*Variables for the A (accident) records*/
		   AccDate 4
		   WkDay 3
		   Pop RoadClass LightCond FirstHarm AccSev Weather SurfCond $ 1
		   TotalVeh 3
		   /*Variables for the B (driver/vehicle) records*/
		   VYr VStyle VType $ 2
		   DrvAge $ 2
		   DrvSex $ 1
		   Ins DrvID DrvInj $ 1
		   VOccs 3
		   /*Variables for the C (casuality) records*/
		   CasAge $ 2
		   CasSex CasVeh CasInj $ 1;
	input @1 AccNo $7.
		  @8 RecType $1.
		  @;
	select(RecType);
		*Read the A (accident) records;
		when('A') do;
			input @18 Pop $1.
				  @19 RoadClass $1.
				  @20 Month 2.
				  @22 Day 2.
				  @27 LightCond $1.
				  @28 FirstHarm $1.
				  @29 AccSev $1.
				  @30 Weather $1.
				  @31 SurfCond $1.
				  @85 TotalVeh 2.;
			AccDate=mdy(Month,Day,2001);
			WkDay=weekday(AccDate);
			output hw5.A_recs;
		end;
		*Read the B (driver/vehicle) records;
		when('B') do;
			input @10 VYr $2.
				  +3  VStyle $2.
				  	  VType $2.
				  +4  DrvAge $2.
				  	  DrvSex $1.
				  +3  Ins $1.
				  +3  DrvID $1.
				  	  DrvInj $1.
				  +11 VOccs 2.
				  	  TempV2 $2.
				  @;
			if DrvSex in ('1','3','7') then DrvSex='M';
			else if DrvSex in ('2','4','8') then DrvSex='F';
			else DrvSex='U';
			output hw5.B_recs;
			*If a second vehicle involved, output hw5.to data set;
			if TempV2 ne ' ' then do;
				input @48 VYr $2.
					  +3  VStyle $2.
						  VType $2.
					  +4  DrvAge $2.
						  DrvSex $1.
					  +3  Ins $1.
					  +3  DrvID $1.
						  DrvInj $1.
					  +11 VOccs 2.;
				if DrvSex in ('1','3','7') then DrvSex='M';
				else if DrvSex in ('2','4','8') then DrvSex='F';
				else DrvSex='U';
				output hw5.B_recs;
			end;
		end;
		*Reading the C (casuality) records;
		otherwise do;
			input @10 (TCas1-TCas4) ($2. +9)
				  @64 TCas5 $2.
				  @;
			*If a first casualty involved, output hw5.to data set;
			if TCas1 ne ' ' then do;
				input @10 CasAge $2.
						  CasSex $1.
						  CasVeh $1.
					  +1  CasInj $1.
					  @;
				if CasSex='1' then CasSex='M';
				else if CasSex='2' then CasSex='F';
				else if CasSex='+' then CasSex='U';
				output hw5.C_recs;
			end;
			*If a second casualty involved, output hw5.to data set;
			if TCas2 ne ' ' then do;
				input @21 CasAge $2.
						  CasSex $1.
						  CasVeh $1.
					  +1  CasInj $1.
					  @;
				if CasSex='1' then CasSex='M';
				else if CasSex='2' then CasSex='F';
				else if CasSex='+' then CasSex='U';
				output hw5.C_recs;
			end;
			*If a third casualty involved, output hw5.to data set;
			if TCas3 ne ' ' then do;
				input @32 CasAge $2.
						  CasSex $1.
						  CasVeh $1.
					  +1  CasInj $1.
					  @;
				if CasSex='1' then CasSex='M';
				else if CasSex='2' then CasSex='F';
				else if CasSex='+' then CasSex='U';
				output hw5.C_recs;
			end;
			*If a first non-vehicle occupant involved, output hw5.to data set;
			if TCas4 ne ' ' then do;
				input @43 CasAge $2.
						  CasSex $1.
						  CasVeh $1.
					  +1  CasInj $1.
					  @;
				if CasSex='1' then CasSex='M';
				else if CasSex='2' then CasSex='F';
				else if CasSex='+' then CasSex='U';
				output hw5.C_recs;
			end;
			*If a second non-vehicle occupant involved, output hw5.to data set;
			if TCas5 ne ' ' then do;
				input @64 CasAge $2.
						  CasSex $1.
						  CasVeh $1.
					  +1  CasInj $1.
					  @;
				if CasSex='1' then CasSex='M';
				else if CasSex='2' then CasSex='F';
				else if CasSex='+' then CasSex='U';
				output hw5.C_recs;
			end;
		end;
	end;
	format AccDate date9.
		   AccSev DrvInj CasInj $Sev.
		   Pop $Pop.
		   RoadClass $RdClass.
		   LightCond $Light.
		   FirstHarm $First.
		   Weather $Weath.
		   SurfCond $Surfcon.
		   WkDay DoW.
		   VStyle $VehSt.
		   VType $VehTy.
		   Ins $Ins.;
run;

title4 'Selected 2001 Texas Traffic Accidents';

proc contents data=hw5.A_Recs position;
run;

proc contents data=hw5.B_Recs position;
run;

proc contents data=hw5.C_Recs position;
run;

proc freq data=hw5.A_Recs;
	tables Pop
		   RoadClass
		   LightCond
		   FirstHarm
		   AccSev
		   Weather
		   SurfCond
		   WkDay
		   TotalVeh;
run;

proc freq data=hw5.B_Recs;
	tables VYr
		   VStyle
		   VType
		   DrvAge
		   DrvSex
		   Ins
		   DrvID
		   DrvInj
		   VOccs;
	format DrvAge $Age.;
run;

proc freq data=hw5.C_Recs;
	tables CasAge
		   CasSex
		   CasInj
		   CasVeh;
	format CasAge $Age.;
run;
