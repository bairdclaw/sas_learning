data NW_customer_data;
infile
"/home/u57893860/my_shared_file_links/kurtsundermann0/Northwind_Data/NW_Customer.dat" dsd dlm=" " firstobs= 2 ;
input CustomerID: $10. CompanyName: $40. ContactName: $40. ContactTitle: $40. Address: $50. City: $25. Region: $20. PostalCode: $10. Country: $20. Phone: $20. Fax: $20.;
run;


proc sort data=NW_customer_data;
by CustomerID;
run;


data NW_order_data;
infile
"/home/u57893860/my_shared_file_links/kurtsundermann0/Northwind_Data/NW_Order.dat" dsd dlm="" firstobs=2;
input OrderID CustomerID :$10. EmployeeID OrderDate :mmddyy10. RequiredDate :mmddyy10. ShippedDate :mmddyy10. ShipVia Freight ShipCountry :$20.;
format OrderDate :mmddyy10. RequiredDate :mmddyy10. ShippedDate :mmddyy10.;
run;


proc sort data=NW_order_data;
by CustomerID;
run;


data NW_Employee_data;
infile
"/home/u57893860/my_shared_file_links/kurtsundermann0/Northwind_Data/NW_Employee.csv" dsd dlm="," firstobs=2;
input EmployeeID LastName: $25. FirstName: $25. Title: $40. HireDate: mmddyy10.City: $25. Region: $20. PostalCode: $10. Country: $20. ReportsTo $;
format HireDate: mmddyy10.;
run;


proc sort data=NW_Employee_data;
by EmployeeID;
run;


Data NW_Information;
merge NW_Customer_dataNW_Order_data;
run;


proc sort data=NW_Information;
by CustomerID;
run;


data NW_new_Information;
merge NW_InformationNW_Employee_Data;
run;


data NW_no_ShippedDate;
set NW_new_Information;
if missing (ShippedDate);
run;


data NW_ShipVia_ShippedDate;
set NW_new_Information;
if ShipVias = 3;
if ShippedDate >= '01-APR-2020'd;
run;


data NW_New_Datasets;
set NW_no_ShippedDateNW_ShipVia_ShippedDate;
run;


data NW_new_data;
retain LastName FirstName CompanyName ContactName Phone OrderID OrderDate: ShippedDate ShipVia;
set NW_New_Datasets;
keep LastName FirstName CompanyName ContactName Phone OrderID OrderDate: Shippeddate ShipVia;
run;


proc sort data=NW_new_data;
by LastName CompanyName OrderDate;
run;


proc print data=NW_New_Data;
title NW_Sorted_Information;
run;
