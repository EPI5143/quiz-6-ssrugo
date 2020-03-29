/*
EPI5143 Winter 2020 Quiz 6.
Due Tuesday March 31st at 11:59PM via Github (link will be provided)

Sebastian Srugo (8900077)

Using the Nencounter table from the class data:
a) How many patients had at least 1 inpatient encounter that started in 2003?
b) How many patients had at least 1 emergency room encounter that started in 2003? 
c) How many patients had at least 1 visit of either type (inpatient or emergency room encounter) 
	that started in 2003?
d) In patients from c) who had at least 1 visit of either type, create a variable that counts 
	the total number encounters (of either type)-for example, a patient with one inpatient 
	encounter and one emergency room encounter would have a total encounter count of 2. 
	Generate a frequency table of total encounter number for this data set, and paste the (text) 
	table into your assignment- use the SAS tip from class to make the table output text-friendly
	ie: 
	options formchar="|----|+|---+=|-/\<>*"; 

Additional Info/hints
-you only need to use the NENCOUNTER table for this question 
-EncWID uniquely identifies encounters
-EncPatWID uniquely identifies patients
-Use EncStartDtm to identify encounters occurring in 2003
-EncVisitTypeCd identifies encounter types (EMERG/INPT)

-You will need to flatfile to end up 1 row per patient id, and decide on a strategy to count inpatient, 
emerg and total encounters for each patient to answer each part of the assignment. 
-There are many ways to accomplish these tasks. You could create one final dataset that can be used to 
answer all of a) through d), or you may wish to create different datasets/use different approaches to 
answer different parts. Choose an approach you are most comfortable with, and include lots of comments 
with your SAS code to describe what your code is doing (makes part marks easier to award and a good 
practice regardless).

Please submit your solutions through Github as a plain text .sas or .txt file. 
*/

libname in "/folders/myfolders/LargeData";
libname out "/folders/myfolders/LargeData/WorkFolder/Data";

/*Flatfiling encounter table*/
data out.encounter2003; /*n=3327*/
	set in.nencounter;
	if year(datepart(EncStartDtm)) = 2003; 
	inpt=0; 
		if EncVisitTypeCd = "INPT" then inpt=1;
	emerg=0;
		if EncVisitTypeCd = "EMERG" then emerg=1;
run;

proc means data=out.encounter2003 noprint; /*n=2891*/
	class EncPatWID;
	types EncPatWID;
	var emerg inpt;
	Output out=out.output max(emerg)=emerg max(inpt)=inpt sum(emerg)=n_emerg sum(inpt)=n_inpt;
run;

/*Question A: How many patients had at least 1 inpatient encounter that started in 2003?*/
title 'number of patients with at least 1 inpatient encounter starting in 2003'; /*n=1074*/
proc freq data=out.output;
	Tables inpt;
run;

/*Question B: How many patients had at least 1 emergency room encounter that started in 2003?*/
title 'number of patients with at least 1 emergency room encounter starting in 2003'; /*n=1978*/
proc freq data=out.output;
	Tables emerg;
run;

/*Question C: How many patients had at least 1 visit of either type (inpatient or emergency room encounter) 
	that started in 2003?*/
title 'number of patients with at least 1 visit of either type'; /*n=2891*/
proc freq data=out.output;	
	tables emerg*inpt;
run;

/*Question D: In patients from c) who had at least 1 visit of either type, create a variable that counts 
	the total number encounters (of either type)-for example, a patient with one inpatient 
	encounter and one emergency room encounter would have a total encounter count of 2.*/
data out.output2;
	set out.output;
	tot=n_emerg+n_inpt;
run;

options formchar="|----|+|---+=|-/\<>*"; 

title 'total number of encounters (of either type) among those with at least 1 of each';
proc freq data=out.output2;
	tables tot; 
run;

/*
tot	Frequency	Percent	Cumulative Frequency	Cumulative Percent
1	2556		88.41	2556			88.41
2	270		9.34	2826			97.75
3	45		1.56	2871			99.31
4	14		0.48	2885			99.79
5	3		0.10	2888			99.90
6	1		0.03	2889			99.93
7	1		0.03	2890			99.97
12	1		0.03	2891			100.00
*/