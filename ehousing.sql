drop table eHousing;

create table eHousing
(
UniqueID int,
ParcelID varchar(100),
LandUse varchar(100),
PropertyAddress varchar(250),
SaleDate date,
SalePrice int,
LegalReference text,
SoldAsVacant varchar(50),
OwnerName varchar(200),
OwnerAddress varchar(250),
Acreage decimal,
TaxDistrict varchar(100),
LandValue int ,
BuildingValue int,
TotalValue  int,
YearBuil  int,
Bedrooms int,
FullBath int,
HalfBath int
);

select * from eHousing;

-- Standardize date Format


select 
     Saledate 
from eHousing;

update  ehousing
set Saledate =  Saledate ::date;

Alter table eHousing
add Salesdateconverted Date;

update ehousing
set Salesdateconverted = Saledate::date;


select
   * 
from ehousing;

-- Populate Property Address date

select 
        propertyAddress 
from ehousing
where 
      propertyAddress is null;


select 
      a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress
from ehousing  a
join ehousing b
       on a.parcelid=b.parcelid
       and
	      a.UniqueID<>b.UniqueID
where 
       a.propertyAddress is null;

select 
      a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,coalesce(a.PropertyAddress,b.PropertyAddress)
from ehousing  a
join ehousing b
       on a.parcelid=b.parcelid
       and
	      a.UniqueID<>b.UniqueID
where 
       a.propertyAddress is null;

Update eHousing
set  PropertyAddress = coalesce(a.PropertyAddress,b.PropertyAddress)
from ehousing  a
join ehousing b
       on a.parcelid=b.parcelid
       and                                                         
	      a.UniqueID<>b.UniqueID
where 
       a.propertyAddress is null;
                        where 
       a.propertyAddress is null;                  --- "NO  NULL VALUES ARE PRESENT AFTER THIS IN PROPERTY ADDRESS COLUMN"


--Breaking out Address into Individual Columns (Address,City,State)

Select 
   propertyAddress
from eHousing ;


select 
      substring(PropertyAddress from 1 for position(',' in PropertyAddress)-1) as address,                                  --" SO HERE 'FROM 1 FOR POSITION(',' IN PROPERTYADDRESS)' RETURNS THE POSITION OF THE , SO IT IS RETURNING A NUMERIC VALUE AND WE CAN USE -1  SO THAT , IS ELIMINATED "
     substring(PropertyAddress from position(',' in PropertyAddress)+1 for length(PropertyAddress))
                                                                                                            --" SO HERE 'FROM 1 FOR POSITION(',' IN PROPERTYADDRESS)' RETURNS THE POSITION OF THE , SO IT IS RETURNING A NUMERIC VALUE AND WE CAN USE -1  SO THAT , IS ELIMINATED "

from ehousing;
        
Alter table eHousing
add PropertySplitAddress varchar(100);
		
		
update ehousing
set PropertySplitAddress = substring(PropertyAddress from 1 for position(',' in PropertyAddress)-1)


Alter table eHousing
add PropertySplitCity varchar(100);
		
update ehousing
set PropertySplitCity  = substring(PropertyAddress from position(',' in PropertyAddress)+1 for length(PropertyAddress))	
		
		
select * from eHousing;		
		
select 
    OwnerAddress  
from eHousing
where 
          OwnerAddress  is not null;

select 
     SPLIT_PART(ownerAddress,',',1) ,
     SPLIT_PART(ownerAddress,',',2) ,
     SPLIT_PART(ownerAddress,',',3) 
from eHousing

where 
       ownerAddress is not null;


Alter table eHousing
add Ownersplitaddress varchar(100);

update ehousing
set Ownersplitaddress =  SPLIT_PART(ownerAddress,',',1) 


Alter table eHousing
add OwnerSplitCity varchar(100);

update ehousing
set OwnerSplitCity = SPLIT_PART(ownerAddress,',',2);

  
Alter table eHousing
add ownerSplitstate varchar(100);

update ehousing
set ownerSplitstate =  SPLIT_PART(ownerAddress,',',3) ;

select * from ehousing;


-- Change Y and N to Yes and NO in " Sold as Vancant"


select
     distinct soldasvacant,
	 count(*)
from eHousing
group by soldasvacant
order by 2 desc;


select 
      soldasvacant,
case
      when soldasvacant ='N' then 'No'
      when soldasvacant='Y' then 'Yes'
	  else soldasvacant
end 
from eHousing;

update eHousing
set    soldasvacant = 
case
      when soldasvacant ='N' then 'No'
      when soldasvacant='Y' then 'Yes'
	  else soldasvacant
end ;

--Remove Duplicates    " Basically we donts prefer removing the duplicates we just place the duplicates in some table which isa created"

WITH rownumcte AS
(
select *,
      row_number() 
	  over(
	  partition by ParcelID,
	               PropertyAddress,
				   SalePrice,
				   SaleDate,
				   LegalReference
	  order by 
				        UniqueID
						) as row_num
from eHousing
order by ParcelID
)
Delete 
from eHousing
where 
      uniqueID in (
	select
	  uniqueID
	from rownumcte
	where
      row_num>1
);

-- select * from rownumcte
-- where row_num>1
-- order by propertyAddress       this is for checking wheather the duplicated row are deleted are not

-- Delete unused columns               "think twice before deletlind the columns "

select 
   *
from ehousing;

Alter table eHousing
drop column OwnerAddress,
drop column TaxDistrict,
drop column PropertyAddress;

select * from eHousing;

Alter Table eHousing
drop column Saledate;


