libname school'H:/laxmi/Assesment1/assesment2';

proc import datafile='H:/laxmi/school.csv'
out=school.stud
dbms=csv
replace;
getnames=yes;
run;


proc print data= school.stud(obs=20);
run;



proc contents data=school.stud;
run;

proc means data=school.stud n nmiss mean median std max ;
run;


proc means data=school.stud n nmiss mean median std max ;
var 	RAM_GB	Storage_GB	Purchase_Year		Price_USD	Warranty_Years ;
run;

proc freq data=school.stud ;
tables School_ID	School_Name	City	Device_Brand	Device_Model	Device_Type	In_Service;  
run;

proc sort data=school.stud noduprecs dupout=school.stud_nodup;
by _all_;
run;

title "duplicate records (if any)";
run;


proc univariate data=school.stud;
var _numeric_; 
histogram;
inset mean std min max / position=ne;
run;

PROC UNIVARIATE DATA=school.stud;
var RAM_GB	Storage_GB	Purchase_Year		Price_USD	Warranty_Years;
RUN;


proc corr data=school.stud noprob outp=school.stud;
var RAM_GB	Storage_GB	Purchase_Year		Price_USD	Warranty_Years;
run ;

proc freq data=school.stud;
tables  in_service*city / chisq;
run;

proc anova data=school.stud;
class in_service;
model Storage_GB = in_service;
run; 
quit;


proc sgplot data=school.stud;
histogram Purchase_Year;
density Purchase_Year / type=normal;
title "Histogram of Purchase_Year";
run;

proc sgplot data=school.stud;
histogram Price_USD ;
density Price_USD  / type=normal;
title "Histogram of Price_USD";
run;

proc sgplot data=school.stud;
histogram Warranty_Years ;
density 	Warranty_Years	 / type=normal;
title "Histogram of Warranty_Years	";
run;

proc sgplot data=school.stud;
vbox Storage_GB;
title "Boxplot of Storage_GB";
run;

proc sgplot data=school.stud;
vbox Price_USD;
title "Boxplot of Price_USD";
run;

 proc sgplot data=school.stud;
scatter x=Device_Brand	 y=Purchase_Year / group=City;
title "Scatterplot: Cab_Type vs Device_Name by City";
run;

 proc sgplot data=school.stud;
scatter x=Storage_GB	 y=RAM_GB / group=Device_Brand	;
title "Scatterplot: RAM_GB vs storage by paid";
run;

 data school.studclean;
set school.stud;
drop Warranty_Years;
run;

proc print data=school.studclean(obs=30);
run;

proc reg data=school.studclean;
model Purchase_Year = Storage_GB ;
output out=work.reg_out predicted=Predicted_service; 
run;


 proc sgplot data=work.reg_out;
scatter x=Pickup_Location y=Driver_Rating;
lineparm x=0 y=0 slope=1 / lineattrs=(color=red);
 title "Predicted vs Observed location";
run;


proc ttest data=work.reg_out;
class in_service; 

var Warranty_Years;
title "T-Test: Comparing Mean Warranty_Years by in_service";
run ;

 proc logistic data=work.reg_out;
model in_service(event='yes') =RAM_GB	Storage_GB	Purchase_Year		Price_USD	 ;
output out=work.reg_out p=Pred_prob; 
 title "Logistic Regression: Predicted Probability of service";
run;


proc sgplot data=work.reg_out;
    scatter x=Storage_GB y=Purchase_Year; 
    refline 0 1 / axis=y lineattrs=(pattern=shortdash);
run;



