----- To check if one npi - national provider identifier can have multiple names or not using group_concat function to concancenate it in the form of array and see results in one row
----For querying purposes, we will take a small set of facilities which we can differenciate using entity type as "O"

select NPI, group_concat(distinct Facilityname), count(*) as count
from CMS
where type = 'O'
group by NPI;
---type 'O' indicates that the NPI is a facility and count above would return the count of times those NPI rows have repeated, not exactly the different names count as 1

---To find the NPI having multiple names
select NPI, group_concat(distinct Facilityname), count(distinct n.Facilityname) as count
from CMS
where type = 'O'
group by NPI;

----After runnning the query to "having count>1" it returned no results which means one NPI is having a facility name. That is a good news and it is coming as expected

----Also, I was looking into primary fields NPI and HCPCSCode but there is a problem the same values is returning multiple rows due to field - place of service which contains facility setting or freestanding physicians office and corresponding field - prices is coming multiple times. In order to eliminate multiple rows issue and mark NPI and HCPCSCode as primary field we would need to group by the primary fields and take average of prices to resolve this

create table CMS_2017_table as 
select 
distinct NPI,
Last_name_or_organization_name,
First_name,
Middle_name, 
Credentials,
Gender,
Entity_type,
Street_a1,
Street_a2,
City,
ZIP,
State,
Countrycode,
ProviderType, 
HCPCSCode, 
HCPCSDescription,
avg(AverageMedicareAllowedAmount),
avg(AverageSubmittedChargeAmount),
avg(AverageMedicarePaymentAmount),
avg(AverageMedicareStandarizedAmount)
from CMS_2017
where HCPCSDrugIndicator = 'N'
group by NPI, HCPCSCode; 
