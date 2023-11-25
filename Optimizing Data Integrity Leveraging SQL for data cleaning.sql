
/*

Cleaning Data in SQL Queries

*/

Select *
From portafolioproject1.dbo.Nashvillehousing


-- Standarizing date format 

Select SaleDateConverted, CONVERT(Date,SaleDate)
From portafolioproject1.dbo.Nashvillehousing

Update Nashvillehousing
SET SaleDate = CONVERT(date, SaleDate)

--- If it doesn't update properyly

ALTER TABLE Nashvillehousing
Add SaleDateConverted Date;

Update Nashvillehousing
SET SaleDateConverted = CONVERT(date,SaleDate)

-- Populating property adress data

Select*
From portafolioproject1.dbo.Nashvillehousing
--Where PropertyAddress is null
Order by ParcelID


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From portafolioproject1.dbo.Nashvillehousing a
JOIN portafolioproject1.dbo.Nashvillehousing b
     on a.ParcelID = b.ParcelID
	 AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From portafolioproject1.dbo.Nashvillehousing a
JOIN portafolioproject1.dbo.Nashvillehousing b
     on a.ParcelID = b.ParcelID
	 AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null



-- Breaking out adress into individual columns ( Address, City, State) 


Select PropertyAddress
From portafolioproject1.dbo.Nashvillehousing
--Where PropertyAddress is null
--Order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress)) as Address

From portafolioproject1.dbo.Nashvillehousing

ALTER TABLE Nashvillehousing
Add PropertySplitAddress Nvarchar(255);

Update Nashvillehousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1)

ALTER TABLE Nashvillehousing
Add PropertySplitCity Nvarchar(255);

Update Nashvillehousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress))


Select *
From portafolioproject1.dbo.Nashvillehousing






Select OwnerAddress
From portafolioproject1.dbo.Nashvillehousing


Select 
PARSENAME(REPLACE(OwnerAddress, ',','.'),3)
,PARSENAME(REPLACE(OwnerAddress, ',','.'),2)
,PARSENAME(REPLACE(OwnerAddress, ',','.'),1)
From portafolioproject1.dbo.Nashvillehousing 


ALTER TABLE Nashvillehousing
Add OwnerSplitAddress Nvarchar(255);

Update Nashvillehousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',','.'),3)

ALTER TABLE Nashvillehousing
Add OwnerSplitCity Nvarchar(255);

Update Nashvillehousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',','.'),2)

ALTER TABLE Nashvillehousing
Add OwnerSplitState Nvarchar(255);

Update Nashvillehousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',','.'),1)


-- Changing Y and N to Yes and No in 'Sold as Vacant' field

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From portafolioproject1.dbo.Nashvillehousing
Group by SoldAsVacant
Order by 2



Select SoldAsVacant
, CASE when SoldAsVacant = 'Y' THEN 'Yes'
       when SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From portafolioproject1.dbo.Nashvillehousing

Update Nashvillehousing
SET SoldAsVacant = CASE when SoldAsVacant = 'Y' THEN 'Yes'
       when SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END



 ---- Removing Duplicates from the data

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 LegalReference
				 ORDER BY 
					UniqueID
					) ROW_num

From portafolioproject1.dbo.Nashvillehousing
--ORDER BY ParcelID
) 
Select*
From RowNumCTE
Where ROW_num > 1
Order by PropertyAddress


Select * 
From portafolioproject1.dbo.Nashvillehousing

-- Deleting unused columns 

Select * 
From portafolioproject1.dbo.Nashvillehousing

ALTER TABLE portafolioproject1.dbo.Nashvillehousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE portafolioproject1.dbo.Nashvillehousing
DROP COLUMN SaleDate