/*
Cleaning data in SQL queries
*/
select * 
from NashvilleHousing;

 --Standardize Date Format
 select SaleDateConverted,CONVERT(date,SaleDate)
 from NashvilleHousing;

 alter table NashvilleHousing
 Add SaleDateConverted Date

 update NashvilleHousing
 set SaleDateConverted=convert(date,SaleDate)

  --Populate Property Address data
 select *
 from NashvilleHousing
 order by ParcelID

 select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,
 isnull(a.PropertyAddress,b.PropertyAddress)
 from NashvilleHousing a
 join NashvilleHousing b
 on a.ParcelID=b.ParcelID
 and a.[UniqueID ] <> b.[UniqueID ]
 where a.PropertyAddress is null

 update a
 set PropertyAddress =isnull(a.PropertyAddress,b.PropertyAddress)
 from NashvilleHousing a
 join NashvilleHousing b
 on a.ParcelID=b.ParcelID
 and a.[UniqueID ] <> b.[UniqueID ]
 where a.PropertyAddress is null


 --Breaking out Address Into Individual Columns (Address,City,State)
 select PropertyAddress
 from NashvilleHousing

 select PropertyAddress,
 substring(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1 ) as address,
  substring(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,len(PropertyAddress)) as city
 from NashvilleHousing

 alter table NashvilleHousing
 add PropertySplitAddress Nvarchar(255);

 update NashvilleHousing
 set PropertySplitAddress=substring(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1 )

 alter table NashvilleHousing
 add PropertySplitCity Nvarchar(255);

 update NashvilleHousing
 set PropertySplitCity=substring(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,len(PropertyAddress))


 select *
 from NashvilleHousing

 select OwnerAddress
 from NashvilleHousing

 select
 PARSENAME(Replace(OwnerAddress,',','.'),3),
 PARSENAME(Replace(OwnerAddress,',','.'),2),
 PARSENAME(Replace(OwnerAddress,',','.'),1)
 from NashvilleHousing

 alter table NashVilleHousing
 add OwnerSplitAddress Nvarchar(255)

 update NashvilleHousing
 set OwnerSplitAddress=PARSENAME(Replace(OwnerAddress,',','.'),3)

 alter table NashVilleHousing
 add OwnerSplitCity Nvarchar(255)

 update NashvilleHousing
 set OwnerSplitCity=PARSENAME(Replace(OwnerAddress,',','.'),2)

 alter table NashVilleHousing
 add OwnerSplitState Nvarchar(255)

 update NashvilleHousing
 set OwnerSplitState=PARSENAME(Replace(OwnerAddress,',','.'),1)

 select * 
 from NashvilleHousing

--Change Y and N to Yes and No in "Sold as Vacant" field

 select Distinct(SoldAsVacant),count(SoldAsVacant)
 from NashvilleHousing
 group by SoldAsVacant
 order by 2

 select SoldAsVacant,
 Case
 when SoldAsVacant='Y' Then 'Yes'
 when SoldAsVacant='N' Then 'No'
 Else SoldAsVacant
 End
 from NashvilleHousing

 update NashvilleHousing
 set SoldAsVacant=
 Case
 when SoldAsVacant='Y' Then 'Yes'
 when SoldAsVacant='N' Then 'No'
 Else SoldAsVacant
 End
 from NashvilleHousing


 --Remove Duplicates
  with RowNumCTE as(
  select *,
  ROW_NUMBER() Over (
  Partition by ParcelID,
  PropertyAddress,
  SalePrice,
  SaleDate,
  LegalReference
  Order By UniqueID
  ) row_num
  from NashvilleHousing
  )
  --delete
  select *
  from RowNumCTE
  where row_num>1


  --Delete Unused Columns
  
   select * 
   from NashvilleHousing

   Alter table NashvilleHousing
   drop column PropertyAddress, OwnerAddress, TaxDistrict, SaleDate