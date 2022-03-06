-- Question 1

DECLARE @maxDate DATE
SET @maxDate = (SELECT MAX(dateScanned) FROM Reciepts)

SELECT TOP 5 
    CASE WHEN temp.brandcode IS NULL THEN 'NAME NOT FOUND' ELSE temp.brandCode END AS Brand,
    SUM(scans) AS TotalScans 
FROM (
    SELECT dateScanned,RL.brandcode,RL.barcode,SUM(CASE WHEN dateScanned IS NULL THEN 0 ELSE 1 END) AS scans FROM Reciepts R
    INNER JOIN RewardsRecieptItemList RL ON Rl.recieptId = R.id
    GROUP BY dateScanned,RL.brandcode,RL.barcode
    HAVING DATEDIFF(month,dateScanned,@maxDate) = 0
) temp
GROUP BY temp.brandcode
ORDER BY TotalScans DESC

-- Question 2
DECLARE @maxDate1 DATE
SET @maxDate1 = (SELECT MAX(dateScanned) FROM Reciepts)

SELECT TOP 5 
    CASE WHEN brandcode IS NULL THEN 'NAME NOT FOUND' ELSE brandCode END AS Brand,
    SUM(CASE WHEN scansCurrent IS NULL THEN 0 ELSE scansCurrent END) AS TotalScansCurrent,
    SUM(CASE WHEN scansPrevious IS NULL THEN 0 ELSE scansPrevious END) AS TotalScansPrevious 
FROM (
    SELECT dateScanned,RL.brandcode,
    CASE WHEN DATEDIFF(month,dateScanned,@maxDate1) = 0 THEN SUM(CASE WHEN dateScanned IS NULL THEN 0 ELSE 1 END) END AS scansCurrent,
    CASE WHEN DATEDIFF(month,dateScanned,@maxDate1) = 1 THEN SUM(CASE WHEN dateScanned IS NULL THEN 0 ELSE 1 END) END AS scansPrevious 
    FROM Reciepts R
    INNER JOIN RewardsRecieptItemList RL ON Rl.recieptId = R.id
    --INNER JOIN Brands B ON B.barcode = RL.barcode AND B.brandCode = RL.brandCode
    GROUP BY dateScanned,RL.brandcode
    HAVING DATEDIFF(month,dateScanned,@maxDate1) <= 1
) temp
GROUP BY brandcode
ORDER BY TotalScansCurrent DESC


-- Question 3
SELECT rewardsReceiptStatus,SUM(CAST(totalSpent as DECIMAL(9,2)))/COUNT(1) AS itemsPurchased FROM Reciepts
WHERE rewardsReceiptStatus IN ('FINISHED','REJECTED')
GROUP BY rewardsReceiptStatus

--- Question 4
SELECT rewardsReceiptStatus,SUM(purchasedItemCount) AS itemsPurchased FROM Reciepts
WHERE rewardsReceiptStatus IN ('FINISHED','REJECTED')
GROUP BY rewardsReceiptStatus

--- Question 5
SELECT TOP 1
    B.name,SUM(CAST(CASE WHEN totalSpent IS NULL THEN '0' ELSE totalSpent END as DECIMAL(9,2))) AS TotalSpent
    --DATEDIFF(month,R.createdDate, MAX(R.createdDate)) AS monthsCount
FROM Reciepts R
INNER JOIN users U ON U.id = R.userId
INNER JOIN RewardsRecieptItemList RL ON Rl.recieptId = R.id
INNER JOIN Brands B ON B.barcode = RL.barcode AND B.brandCode = RL.brandCode
GROUP BY R.userId,R.createdDate,U.createdDate,B.name
HAVING DATEDIFF(month,U.createdDate, MAX(R.createdDate)) <= 6
ORDER BY TotalSpent DESC

--- Question 6
SELECT TOP 1 
    B.name,COUNT(1) AS Total
    --,R.createdDate,U.createdDate
    --DATEDIFF(month,R.createdDate, MAX(R.createdDate)) AS monthsCount
FROM Reciepts R
INNER JOIN users U ON U.id = R.userId
INNER JOIN RewardsRecieptItemList RL ON Rl.recieptId = R.id
INNER JOIN Brands B ON B.barcode = RL.barcode AND B.brandCode = RL.brandCode
GROUP BY R.createdDate,U.createdDate,B.name
HAVING DATEDIFF(month,U.createdDate, MAX(R.createdDate)) <= 6
ORDER BY Total DESC

--- Duplicate entries
SELECT id,count(*) FROM users
GROUP BY id
HAVING count(*) > 1
ORDER BY count(*) DESC

SELECT id,count(*) FROM brands
GROUP BY id
--HAVING count(*) > 1
ORDER BY count(*) DESC

SELECT id,count(*) FROM Reciepts
GROUP BY id
--HAVING count(*) > 1
ORDER BY count(*) DESC
