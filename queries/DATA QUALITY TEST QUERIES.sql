---- Test Case 1: Created Date <= Last Login date ----
------------------------------------------------------
SELECT DATEDIFF(ss, createdDate,lastLogin) FROM Users
WHERE DATEDIFF(ss, createdDate,lastLogin) < 0

-- Findings for TC 1:
-- a. No inconsistencies found for created and last login date

------------- Test Case 2: Valid data ----------------
------------------------------------------------------
SELECT 
    --role,
    --active,
    --state,
    signUpSource,
    count(*) FROM Users
GROUP BY 
    --role 
    --active
    --STATE
    signUpSource

--Findings for TC 2:
-- a. active status has a value as fals

------------- Test Case 3: Inconsistent data ----------------
-------------------------------------------------------------
SELECT RL.barcode,RL.brandCode,COUNT(*) FROM RewardsRecieptItemList RL
JOIN Brands B ON B.barcode <> RL.barcode AND RL.brandCode <> B.brandCode
GROUP BY
    RL.barcode,RL.brandCode

SELECT R.userId,COUNT(*) FROM Reciepts R
JOIN Users U ON U.id <> R.userId
GROUP BY
    R.userId

--Findings for TC 3:
-- a. Inconsistency found in Reciepts table & Brands table - brands not found in RewardsRecieptItemList table
-- b. Inconsistency found in Reciepts table & Users table - users not found in RewardsRecieptItemList table

------------- Test Case 4: Inconsistent data ----------------
------- Final Price & total Spent should be equal -----------
-------------------------------------------------------------


SELECT RL.recieptId,SUM(RL.finalPrice) AS IndividualSum,SUM(RL.quantityPurchased) AS totalCount,R.totalSpent, R.purchasedItemCount FROM RewardsRecieptItemList RL 
INNER JOIN Reciepts R ON R.id = RL.recieptId
WHERE 
--id = '5f9c74f90a7214ad07000038' AND
RL.needsFetchReview <> 'true'
GROUP BY RL.recieptId, R.totalSpent, R.purchasedItemCount
HAVING SUM(RL.finalPrice) <> R.totalSpent

--Findings for TC 4:
-- a. Inconsistency found in price from Reciepts & RewardsRecieptItemList table

----------- Test Case 5: Duplication in data ----------------
-------------------------------------------------------------

--Duplicates
SELECT 
    id,
    --recieptId,
    count(*) as counts
FROM 
    --brands
    users
    --Reciepts
    --RewardsRecieptItemList
GROUP BY 
    id
    --recieptId
HAVING
    count(*) > 1
ORDER BY   
    counts DESC

-- Findings for TC 5:
-- 1. Duplication observed in User table, with multiple entries for userId attached in the document
-- 2. No duplicates found in Reciepts & Brands table based on the unique id

-------------------------- Find nulls -----------------------------------
-------------------------------------------------------------------------

-- NULL VALUES IN Brands
;WITH XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as ns)
SELECT COUNT(*)
FROM   Brands
WHERE  (SELECT Brands.*
        FOR xml path('row'), elements xsinil, type
        ).value('count(//*[local-name() != "colToIgnore"]/@ns:nil)', 'int') > 0

-- NULL VALUES IN USERS

;WITH XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as ns)
SELECT COUNT(*)
FROM   Users
WHERE  (SELECT Users.*
        FOR xml path('row'), elements xsinil, type
        ).value('count(//*[local-name() != "colToIgnore"]/@ns:nil)', 'int') > 0

-- NULL VALUES IN Reciepts

;WITH XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as ns)
SELECT COUNT(*)
FROM   Reciepts
WHERE  (SELECT Reciepts.*
        FOR xml path('row'), elements xsinil, type
        ).value('count(//*[local-name() != "colToIgnore"]/@ns:nil)', 'int') > 0

--- NULL VALUES IN RewardsRecieptItemList

;WITH XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as ns)
SELECT COUNT(*)
FROM   RewardsRecieptItemList
WHERE  (SELECT RewardsRecieptItemList.*
        FOR xml path('row'), elements xsinil, type
        ).value('count(//*[local-name() != "colToIgnore"]/@ns:nil)', 'int') > 0
        

-- Findings for NULL value check
-- 1. NULL VALUES FOUND IN ALMOST EVERY TABLE

-------------------------------------------------------------------------
-------------------------------------------------------------------------

