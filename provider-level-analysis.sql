
---To check if one address belongs to one facility or not
---Type - O indicates facility

select group_concat(distinct FacilityName_or_Last_name), group_concat(distinct cms_npi), address1, address2, st, countrycode, zip, count(distinct FacilityName_or_Last_name) as count
from CMS_2017
where type = 'O' and address2 is not null 
group by address1, address2, st, countrycode, zip
having count>1

---To check the cases where one address belongs to one facility

select group_concat(distinct FacilityName_or_Last_name), group_concat(distinct cms_npi), address1, address2, st, countrycode, zip, count(distinct FacilityName_or_Last_name) as count
from CMS_2017
where type = 'O' and address2 is not null 
group by address1, address2, st, countrycode, zip
having count>1

---To view procedure wise doctor and facility along with addresses to build a feature like - best doctor in that best facility

with doctor as 
( 
select cms_npi, address1, address2, st, countrycode, zip, code from CMS_2017
where type = 'I' and Drugindicator = 'N'
),
facility as 
(
select cms_npi, address1, address2, st, countrycode, zip, code from CMS_2017
where type = 'O' and Drugindicator = 'N'
)
select distinct d.cms_npi as doctor_npi, f.cms_npi as facility_npi, d.address1, d.address2, d.st, d.countrycode, d.zip, d.code as code
from doctor d
inner join facility f 
on d.address1=f.address1 and d.address2=f.address2 and d.st = f.st and d.countrycode = f.countrycode and d.zip = f.zip and d.code = f.code;


