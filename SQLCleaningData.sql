--Cleaning Data in SQL Queries

SELECT *
FROM post.dbo.NashvilleHousing;


-- Standarize Date Format

SELECT SaleDateConverted,CONVERT(Date, SaleDate)
FROM post.dbo.NashvilleHousing;


Update NashvilleHousing
SET SaleDate = CONVERT(Date, SaleDate)

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date

Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date, SaleDate)




--Populate Property Address data,

SELECT *
FROM post.dbo.NashvilleHousing
WHERE PropertyAddress is null
ORDER BY ParcelID



SELECT a.ParcelID, a.PropertyAddress,b.ParcelID, b.PropertyAddress,ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM post.dbo.NashvilleHousing a
JOIN post.dbo.NashvilleHousing b
     ON a.ParcelID =b.ParcelID
	 AND a.[UniqueID ]<> b.[UniqueID]
WHERE a.PropertyAddress is null



Update a 
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM post.dbo.NashvilleHousing a
JOIN post.dbo.NashvilleHousing b
     ON a.ParcelID =b.ParcelID
	 AND a.[UniqueID ]<> b.[UniqueID]
WHERE a.PropertyAddress is null


----- Breaking out Address into Individual Columns (Address, City, State) 

SELECT PropertyAddress
FROM post.dbo.NashvilleHousing
--WHERE PropertyAddress is null
--ORDER BY ParcelID

SELECT
SUBSTRING(PropertyAddress,1 ,CHARINDEX(',', PropertyAddress) -1) as Address
,SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address
FROM post.dbo.NashvilleHousing



ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress,1 ,CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))

SELECT *
FROM post.dbo.NashvilleHousing

________________________

SELECT OwnerAddress
FROM post.dbo.NashvilleHousing

 SELECT 
 PARSENAME(REPLACE(OwnerAddress, ',', '.') ,3)
 ,PARSENAME(REPLACE(OwnerAddress, ',', '.') ,2)
 ,PARSENAME(REPLACE(OwnerAddress, ',', '.') ,1)
FROM post.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') ,3)

ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') ,2)

ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitstate = PARSENAME(REPLACE(OwnerAddress, ',', '.') ,1)


SELECT *
FROM post.dbo.NashvilleHousing

--------

-- Change Y and N to yes and No in "Sold as Vacant" field

SELECT Distinct(SoldAsVacant), COUNT(SoldAsVacant)
FROM post.dbo.NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2


SELECT SoldAsVacant
, CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
       WHEN SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
FROM post.dbo.NashvilleHousing

UPDATE NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
       WHEN SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END

	   ------
---Remove Duplicates

WITH RowNumCTE AS(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY ParcelID,
             PropertyAddress,
			 SalePrice,
			 SaleDate,
			 LegalReference
			 ORDER BY 
			 UniqueID
			 ) row_num

FROM post.dbo.NashvilleHousing
--ORDER BY ParcelID
)
SELECT *
FROM RowNumCTE
WHERE row_num >1
--order by PropertyAddress

---------------------------------

-- DELETE UNUSED COLUMNS

SELECT * 
FROM post.dbo.NashvilleHousing

ALTER TABLE post.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress


ALTER TABLE post.dbo.NashvilleHousing
DROP COLUMN SaleDate

