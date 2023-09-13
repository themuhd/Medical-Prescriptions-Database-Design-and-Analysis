--Checks System for database named prescription and drops it
If Exists (Select * From sys.sysdatabases Where [name] = 'PrescriptionsDB')
Drop Database PrescriptionsDB
Go



--Creating Database: PrescriptionDB
CREATE DATABASE PrescriptionsDB;

--Command lets us use current database
USE PrescriptionsDB;
GO




/**ALTER COMMANDS TO ADD PRIMARY AND 
FOREIGN KEY CONSTRAINTS 
**/
ALTER TABLE Prescriptions
ADD CONSTRAINT FK_PRESCRIPTIONS_Medical_Practice FOREIGN KEY (PRACTICE_CODE)
REFERENCES Medical_Practice (PRACTICE_CODE);
ALTER TABLE Prescriptions
ADD CONSTRAINT FK_Prescriptions_Drugs FOREIGN KEY (Bnf_code) REFERENCES Drugs (BNF_CODE);






--ADDITIONAL QUERY ONE--
/*
--query to list practice names, addresses and postcode together in 
one coulumn as Address  where there is at least 1 items for magnesium in bnf_description 2
*/
SELECT 
    PRACTICE_NAME, 
    CONCAT(ADDRESS_1, ' ', ADDRESS_2, ' ', ADDRESS_3, ' ', ADDRESS_4, ' ', POSTCODE) AS ADDRESS
FROM Medical_Practice MP
WHERE EXISTS (
    SELECT *
    FROM Prescriptions P
    JOIN DRUGS D ON P.BNF_CODE = D.BNF_CODE
    WHERE P.PRACTICE_CODE = MP.PRACTICE_CODE
    AND D.BNF_DESCRIPTION LIKE '%MAGNESIUM%'
    AND P.ITEMS > 1
);


select * from Medical_Practice

--ADDITIONAL QUERY TWO--
/*
--Query to list practice names and addresses from LANCASHIRE that has distinct 
chemical substance in drug table
(chemical substance listed in CHEMICAL_SUBSTANCE_BNF_DESCR column) 
*/
	SELECT
    CONCAT(M.ADDRESS_1, ', ', M.ADDRESS_2, ', ', M.ADDRESS_3, ', ', M.ADDRESS_4, ', ', M.POSTCODE) AS ADDRESS,
    M.PRACTICE_NAME FROM  Medical_Practice M
WHERE 
    M.ADDRESS_3 LIKE '%LANCASHIRE%' OR M.ADDRESS_4 LIKE '%LANCASHIRE%'
    AND M.PRACTICE_CODE IN (
        SELECT DISTINCT P.PRACTICE_CODE 
        FROM 
            PRESCRIPTIONS P 
            INNER JOIN DRUGS D ON P.BNF_CODE = D.BNF_CODE 
        AND D.CHEMICAL_SUBSTANCE_BNF_DESCR IN (SELECT DISTINCT CHEMICAL_SUBSTANCE_BNF_DESCR FROM DRUGS D ));



--ADDITIONAL QUERY THREE--
/* 
Query that returns the BNF chapter code and its total cost for chapters 
that have a total cost greater than the average total cost for all chapters.
*/
SELECT d.BNF_Chapter_plus_code, SUM(p.Actual_cost) AS Total_cost
FROM Drugs d
INNER JOIN Prescriptions p ON d.BNF_code = p.BNF_code
GROUP BY d.BNF_Chapter_plus_code
HAVING SUM(p.Actual_cost) > (SELECT AVG(Total_cost) FROM (
                               SELECT d.BNF_Chapter_plus_code, SUM(p.Actual_cost) AS Total_cost
                               FROM Drugs d
                               INNER JOIN Prescriptions p ON d.BNF_code = p.BNF_code
                               GROUP BY d.BNF_Chapter_plus_code) t)
ORDER BY Total_cost DESC;




--ADDITIONAL QUERY FOUR--
/* 
Query to retrieve the most expensive prescription prescribed by each practice:
*/

SELECT p.PRACTICE_CODE, p.Practice_name, pr.PRESCRIPTION_CODE, d.BNF_DESCRIPTION, pr.ACTUAL_COST
FROM MEDICAL_PRACTICE p
INNER JOIN Prescriptions pr ON p.Practice_code = pr.Practice_code
INNER JOIN Drugs d ON pr.Bnf_code = d.Bnf_code
WHERE pr.ACTUAL_COST = (SELECT MAX(pr2.ACTUAL_COST) 
                        FROM Prescriptions pr2 
                        WHERE pr2.Practice_code = p.Practice_code)
ORDER BY p.Practice_code;






--ADDITIONAL QUERY FIVE--
/* 

Query to get most expensive drugs
*/
SELECT d.Bnf_code, d.BNF_DESCRIPTION, d.CHEMICAL_SUBSTANCE_BNF_DESCR, 
       SUM(p.ACTUAL_COST) AS TotalCost
FROM Drugs d 
INNER JOIN Prescriptions p ON d.Bnf_code = p.Bnf_code
GROUP BY d.Bnf_code, d.BNF_DESCRIPTION, d.CHEMICAL_SUBSTANCE_BNF_DESCR
ORDER BY TotalCost DESC;


--ADDITIONAL QUERY SIX
/*
--query that returns the BNF_DESCRIPTION for drugs that have never been prescribed.
*/
SELECT d.BNF_DESCRIPTION
FROM Drugs d
WHERE d.Bnf_code NOT IN (
    SELECT p.Bnf_code
    FROM Prescriptions p
);
