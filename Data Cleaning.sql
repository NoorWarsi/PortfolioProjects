--Cleaning data in SQL queries

Select * from housing;

----------------------------------
--Standardize date format

Select SaleDateConverted, convert(Date,SaleDate)
from housing

update Housing
set SaleDate = convert(Date,SaleDate)

Alter table Housing
add SaleDateConverted Date;

update Housing
set SaleDateConverted = convert(Date,SaleDate)

--------------------------------------------------------------
--Populate property address data

Select *
from housing
--where PropertyAddress is null
order by ParcelID

--Since the ParcelID is same for most of address, so we populate address which is null based on the same parcelID

Select a.ParcelID,a.PropertyAddress	,b.ParcelID,b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
from housing a
Join Housing b --Self join (the table is joined to itself based on the same column values)
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ] --Offcourse Unique ID is not equal, else it will be error.
where a.PropertyAddress is null 



Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress) --If a.propAd is null then it will populate the cell with b.propAd
from housing a
Join Housing b 
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null 

-----------------------------------------------------------------
--Breaking out address into individual columns (address,city,state)

Select 
SUBSTRING(Propertyaddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address 
--Substring here is used to extract a portion of a string, starting from a specified position, for a specified length of characters.
--Syntax of SubString (string, start_position, length), -1 is used to remve comma from the output address.
--CHARINDEX function is used to search for the starting position of a substring within a given string.
, SUBSTRING(Propertyaddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) as Address --taking the value after comma
from housing 

Alter table Housing
add Propertysplitaddress nvarchar(255);

update Housing
set Propertysplitaddress = SUBSTRING(Propertyaddress, 1, CHARINDEX(',', PropertyAddress)-1)  

Alter table Housing
add Propertysplitcity nvarchar(255);

update Housing
set Propertysplitcity = SUBSTRING(Propertyaddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))

--Selecting/separating owner address with city and state
select owneraddress
from housing

Select 
PARSENAME(REPLACE(owneraddress,',','.'),3) --PARSENAME 
,PARSENAME(REPLACE(owneraddress,',','.'),2)
,PARSENAME(REPLACE(owneraddress,',','.'),1)
from Housing

Alter table Housing
add Ownersplitaddress nvarchar(255);

update Housing
set Ownersplitaddress = PARSENAME(REPLACE(owneraddress,',','.'),3) 

Alter table Housing
add Ownersplitcity nvarchar(255);

update Housing
set Ownersplitcity = PARSENAME(REPLACE(owneraddress,',','.'),2)

Alter table Housing
add Ownersplitstate nvarchar(255);

update Housing
set Ownersplitstate = PARSENAME(REPLACE(owneraddress,',','.'),1)

--------------------------------------------------------------
--Select Y and N as Yes No in Sold as vacant

Select distinct (Soldasvacant), COUNT(soldasvacant)
from housing
group by SoldAsVacant
order by 2;

Select SoldAsVacant
, case when SoldAsVacant = 'Y' then 'Yes' 
       when SoldAsVacant = 'N' then 'NO'
	   Else SoldAsVacant
	   END
from housing;

update Housing 
set SoldAsVacant =  case when SoldAsVacant = 'Y' then 'Yes' 
       when SoldAsVacant = 'N' then 'NO'
	   Else SoldAsVacant
	   END
	   
	   from housing;

------------------------------------------------------------------------------
--Remove Duplicates
WITH RowNumCTE as ( 
Select *,
        ROW_NUMBER() OVER ( 
		PARTITION BY ParcelID,
		             PropertyAddress,
					 SalePrice,
					 SaleDate,
					 LegalReference
					 ORDER BY
					  UniqueID
					 ) row_num
From Housing)

Select * from RowNumCTE
where row_num > 1 

------------------------------------------------------------------------------
--Delete Unused Columns
Select * from Housing

Alter table housing 
Drop column OwnerAddress, TaxDistrict, PropertyAddress

Alter table housing 
Drop column SaleDate