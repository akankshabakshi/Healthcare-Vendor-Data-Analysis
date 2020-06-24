
--Print all rows
select count(*) from CMS_2017; ---9847444

--Check if doctor, zipcode, Code are repeating multiple times
select NPI, Zipcode, HCPCSCode, count(*) from CMS_2017
group by NPI, Zipcode, HCPCSCode;

--Check if one NPI can have multiple names
select NPI, Zipcode, HCPCSCode, count(*) as count from CMS_2017
group by NPI, Zipcode, HCPCSCode;

--This is because of Place of Service 'F' and 'O'
select distinct PlaceofService from CMS_2017;

--Check if there are more than 2 rows for the above CASE using CTE
with result as(
select NPI, Zipcode, HCPCSCode, count(*) as count from CMS_2017
group by NPI, Zipcode, HCPCSCode
) select * from result where count>2;
---no cases other than that

----check if one code can have multiple names
select HCPCSCode, HCPCSDescription, count(*) as count from CMS_2017
group by HCPCSCode, HCPCSDescription;

---View what EntityType entails
select distinct EntityType from CMS_2017;
----Result: 'I' and 'O'
-----check what EntityType denotes
select * FROM CMS_2017 
where EntityType = 'I'; 
-- 'I' denotes doctor
---just to double confirm let's check what the other value entails
select * from CMS_2017
where EntityType = 'O';
--'O' denotes facility_name

--General number of rows analysis
--Print all rows
select count(*) from CMS_2017; ---98,47,444
---Print all 
select count(*) from CMS_2017; ----95,09,701
group by NPI, HCPCSCode;

---count of distinct HCPCSCode
SELECT COUNT(DISTINCT HCPCSCode) FROM CMS_2017; ---6049
---count of distinct NPI
select count(distinct NPI) from CMS_2017; ----1032912

----length of zip codes
select  zipcode, length(Zipcode) from CMS_2017 limit 10;

---top 2 zipcodes 
select zipcode, dense_rank() over(order by length(zipcode) desc) from CMS_2017
 ----so we are getting only 9 digit zip codes only
 
 ----total doctors and facilities
 select count(distinct NPI) from CMS_2017; ----1032912
 ---- doctors
 select count(distinct NPI) from CMS_2017 where EntityType = 'I'; --971638(94%)
 ----facilities
 SELECT COUNT(DISTINCT NPI) FROM CMS_2017 WHERE EntityType = 'O'; --61273(5.9%)
 
---which procedure has maximum NPIs
 select HCPCSCode, HCPCSDescription, count(NPI) as count from CMS_2017 
 group by HCPCSCode
 order by count desc limit 10;
 
 --checking if the numbers above are correct or not 
 CASE: ProcedureCode: 0008M should return 5 NPI results
 select count(NPI) from CMS_2017
 where HCPCSCode = '0008M';
 
 ---check if any procedure has no NPIs
 with result as 
 (
  select HCPCSCode, HCPCSDescription, count(NPI) as count from CMS_2017 
 group by HCPCSCode
 order by count desc
 )
 select * from result where count is NULL;
----conclusion: There is no such case where a 

---check if any procedure has less than 10 NPIs
 select distinct HCPCSCode, HCPCSDescription, count(NPI) as count from CMS_2017 
 group by HCPCSCode
 having count<10
 order by count desc;
---2190 procedures have less than 10 NPIs (36% iof the total procedures)
---all procedures count
select COUNT(DISTINCT HCPCSCode) FROM CMS_2017; ---6049

---doctors results for the procedure
 select distinct HCPCSCode, HCPCSDescription, count(NPI) as count from CMS_2017 
 where EntityType = 'I'
 group by HCPCSCode
 order by count desc limit 5;
---facilities results for the procedure
 select distinct HCPCSCode, HCPCSDescription, count(NPI) as count from CMS_2017 
 where EntityType = 'O'
 group by HCPCSCode
 order by count desc;
 --check if any procedure has no facilities
  select distinct HCPCSCode, HCPCSDescription, count(NPI) as count from CMS_2017 
 where EntityType = 'O'
 group by HCPCSCode
 having count is NULL
 order by count desc;
 ---no null NPI results for any procedure but 1 result is there for few procedures
 
 --check if any procedure has no doctors
 select distinct HCPCSCode, HCPCSDescription, count(NPI) as count from CMS_2017 
 where EntityType = 'I'
 group by HCPCSCode
 having count is NULL
 order by count desc;
 --no null NPI results for any procedure but I result is there for few procedures
 
 
 ----fetch only HCPCSCode and NPI along with EntityType in a separate TABLE
 create table cms_table as select distinct NPI,HCPCSCode, EntityType from CMS_2017; 
 
--all count 
select count(*) from cms_table --9509701
--HCPCSCode count
SELECT COUNT(DISTINCT HCPCSCode) FROM cms_table  --6049
--distinct NPI count
select count(distinct NPI) from cms_table  --1032912
 --all NPI count
 select count(NPI) from cms_table; --9509701
---Conclusion: In the cms_table, NPI column is the primary field

---create final table with all must have and nice of have rows
create table cms_final_tbl as
select NPI, 
LastName_or_OrganizationName,
FirstName, 
MiddleName, 
Credential, 
Gender, 
EntityType, 
Street,
Street_a2,
City, 
Zipcode, 
Statecode, 
Countrycode, 
ProviderType, 
HCPCSCode, 
HCPCSDescription, 
HCPCSDrugIndicator,
AverageMedicareAllowedAmount,
AverageMedicarePaymentAmount, 
AverageMedicareStandarizedAmount, 
AverageSubmittedChargeAmount
from CMS_2017
where HCPCSDrugIndicator = 'N';
---check total Count
select count(*) from cms_final_tbl; ---9231195
---count of procedures
select count(distinct HCPCSCode) from cms_final_tbl; ---5701
---count of NPIs
select count(distinct NPI) from cms_final_tbl; ---1032649
---check if the total rows are equal to count of NPI without distinct 
select count(NPI) from cms_final_tbl; ----9231195

---check if NPI and procedures can be a primary field
select distinct NPI, HCPCSCode, count(*) from cms_final_tbl 
group by NPI, HCPCSCode; 

#With the above analysis, the file looks usable now
