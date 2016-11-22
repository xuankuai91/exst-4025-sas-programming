dm 'log; clear; output; clear';
*hw6.sas- -Kuai, Xuan- -11/8/2016;
*EXST 4025 Assignment 6;
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
title2 'EXST 4025 Assignment 6';

libname hw6 'E:\EXST_4025\Assignment_6';
libname library 'E:\EXST_4025\Assignment_6';

data hw6.A_recs(keep=AccNo
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
	 hw6.B_recs(keep=AccNo
	 				 VYr
					 VStyle
					 VType
					 DrvAge
					 DrvSex
					 Ins
					 DrvID
					 DrvInj
					 VOccs)
	 hw6.C_recs(keep=AccNo
	 				 CasAge
					 CasSex
					 CasVeh
					 CasInj);
*End of the DATA statement;
	infile 'hw5TXAccs2001.txt' missover;
	length AccNo $ 7
		   /*Variables for the A (accident) records*/
		   AccDate 4
		   WkDay 3
		   Pop RoadClass LightCond FirstHarm AccSev Weather SurfCond $ 1
		   TotalVeh 3
		   /*Variables for the B (driver/vehicle) records*/
		   VYr 3
		   VStyle VType $ 2
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
			output hw6.A_recs;
		end;
		*Read the B (driver/vehicle) records;
		when('B') do;
			input @10 VYrTemp1 $2.
				  @48 VYrTemp2 $2.
				  @;
			array VehYr{2} VYrTemp1 VYrTemp2;
			do b=1 to 2;
				if b=1 then Bptr=15;
				else Bptr=53;
				*If a vehicle involved, output to data set;
				if VehYr{b} ne ' ' then do;
					input @Bptr VStyle $2.
							  	VType $2.
						  +4  	DrvAge $2.
							  	DrvSex $1.
						  +3  	Ins $1.
						  +3  	DrvID $1.
							  	DrvInj $1.
						  +11 	VOccs 2.
						  @;
					if VehYr{b}='++' then VYr=.;
					else if input(VehYr{b},2.)>=70 then VYr=input('19'!!VehYr{b},4.);
					else VYr=input('20'!!VehYr{b},4.);
					if DrvSex in ('1','3','7') then DrvSex='M';
					else if DrvSex in ('2','4','8') then DrvSex='F';
					else DrvSex='U';
					output hw6.B_recs;
				end;
			end;
		end;
		*Reading the C (casuality) records;
		otherwise do;
			input @10 (TCas1-TCas4) ($2. +9)
				  @64 TCas5 $2.
				  @;
			array Cas{5} TCas1-TCas5;
			array Cptr{5} (10,21,32,43,64);
			*If a casualty involved, output hw6.to data set;
			do c=1 to 5;
				if Cas{c} ne ' ' then do;
					input @(Cptr{c}) CasAge $2.
							  		 CasSex $1.
							  		 CasVeh $1.
						  +1  		 CasInj $1.
						  @;
					if CasSex='1' then CasSex='M';
					else if CasSex='2' then CasSex='F';
					else if CasSex='+' then CasSex='U';
					output hw6.C_recs;
				end;
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

proc contents data=hw6.B_Recs position;
run;

proc contents data=hw6.C_Recs position;
run;

proc freq data=hw6.A_Recs;
	tables Weather
		   TotalVeh;
run;

proc freq data=hw6.B_Recs;
	tables VYr
		   VStyle;
run;

data work.PickupAccNos;
	set hw6.B_recs;
	by AccNo;
	where VStyle='30';
	if first.AccNo;
	keep AccNo;
run;

data work.PickupAccs;
	merge work.PickupAccNos(in=inNos)
		  hw6.A_recs;
	by AccNo;
	if inNos;
run;

data work.PickupAccVehs;
	merge work.PickupAccNos(in=inNos)
		  hw6.B_recs;
	by AccNo;
	if inNos;
run;

data work.PickupAccCas;
	merge work.PickupAccNos(in=inNos)
		  hw6.C_recs(in=inCas);
	by AccNo;
	if inNos and inCas;
run;

data work.PickupSingleRainyAccs
	 work.Temp(keep=AccNo);
	set work.PickupAccs;
	if Weather='2' and TotalVeh=1;
run;

data work.RainySinglePickups;
	merge work.Temp(in=inTemp)
		  work.PickupAccVehs;
	by AccNo;
	if inTemp;
run;
