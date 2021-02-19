/* Collecting all Northwind Customer, Order, and Employee data*/
data NW_CUSTOMER_DATA;
infile "/home/u57893860/my_shared_file_links/kurtsundermann0/Northwind_Data/NW_Customer.dat"
dsd dlm = "09"x firstobs=2;
input CustomerID :$10. CompanyName :$40. ContactName :$40.
            ContactTitle :$40.  Address :$50. City :$25. Region :$20.
            PostalCode :$10. Country :$20. Phone :$20. Fax :$20.;
run;

proc sort data=NW_CUSTOMER_DATA;
by CustomerID;
run;

data NW_Order_Data;
infile "/home/u57893860/my_shared_file_links/kurtsundermann0/Northwind_Data/NW_Order.dat"
dsd dlm="09"x firstobs=2;
input OrderID CustomerID :$10. EmployeeID OrderDate :mmddyy10.
RequiredDate :mmddyy10. ShippedDate :mmddyy10. ShipVia Freight ShipCountry :$20.;

format OrderDate :mmddyy10. RequiredDate :mmddyy10.
ShippedDate :mmddyy10.;
run;

proc sort data=NW_Order_Data;
by CustomerID;
run;

data NW_Employee_Data;
infile "/home/u57893860/my_shared_file_links/kurtsundermann0/Northwind_Data/NW_Employee.csv"
dsd dlm="," firstobs=2;
input EmployeeID LastName: $25. Firstname: $25. Title: $40.
Hiredate: mmddyy10. City:$25. Region: $20. PostalCode: $10. Country:$20. ReportsTo $;
format HireDate: mmddyy10.;
run;

proc sort data=NW_Employee_Data;
by EmployeeID;
run;

/*Merging the 2 data sets*/
data NW_Information;
MERGE NW_CUSTOMER_DATA NW_Order_Data;
by CustomerID;
run;

proc sort data=NW_Information;
by EmployeeID;
run;

data NW_Shipping_Information;
merge NW_Information NW_Employee_Data;
by EmployeeID;
run;
/*proc sort data=NW_Shipping_Inform;
by EmployeeID;
run;*/

/*Order without a Shipped date*/
data NW_no_ShippedDate;
set NW_Shipping_Information;
if missing(ShippedDate);
run;

/*Order shipped on or after April 1 2020*/
data NW_ShipVia_ShippedDate;
set  NW_Shipping_Information;
if Shipvia= 3;
if ShippedDate >= '01-APR-2020'd;
run;

/*Merging into one set*/
data NW_new_datasets;
set NW_no_ShippedDate NW_ShipVia_ShippedDate;
run;

/*Reducing Columns*/
data NW_produced_column;
retain LastName FirstName  CompanyName ContactName
Phone OrderID Ordername: ShippedDate ShipVia;
set NW_new_datasets;
keep LastName FirstName CompanyName ContactName Phone OrderID OrderDate: ShippedDate ShipVia;
run;

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
