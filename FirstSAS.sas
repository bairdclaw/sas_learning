

proc contents data=sashelp.demographics;
run;
/* 197 rows, 18 columns */

/* create new dataset */
data mydemographics;
set sashelp.demographics;
/* Calculate approximate Urban pop */
approx_urbanpop = pop * popUrban;
/* Calculate approximate impoverished pop */
approx_povertypop = pop * PopPovertypct;
/* Calculate differences in percentages enrolled Male v Female */
genderenrollment = MaleSchoolpct - FemaleSchoolpct;
run;

/* Print first 10 records */
title "Extended Demographics";
proc print data= mydemographics (obs=10);
run;


/* printing specified columns for original dataset */
proc print data= mydemographics (obs=10);
var Cont ISO ISOName pop genderenrollment approx_povertypop approx_urbanpop;
title 'Limited Demographics';
run;

/* created new dataset based on mydemographics */
/* selected variables for new dataset */
data limited_demographics;
set mydemographics;
keep Cont ISO ISOName pop genderenrollment approx_povertypop approx_urbanpop;
run;

/* printing content information */
proc contents data=limited_demographics;
run;

/* Bonus 1 */
proc print
  data = work.mydemographics (obs = 10);
  keep = Cont ISO ISOName pop approxUrbanPop approxPovertyPop school_sex_dff
  title "Extended Demographics - Limited Fields";
run;

/* Bonus 2 */
proc contents data=work.mydemographics;
run;
