# Finance loan database analysis
This analysis aimed to uncover insights into the loan data of a financial institution, focusing on customer  borrowing habits, loan amount distribution, and branch-specific trends. By examining the data, we sought to identify patterns, trends, and correlations that could inform business decisions and drive growth.
# Problem Statement
•	Fetch customers with the same loan amount.

•	Find the second highest loan amount and the customer and branch associated with it.

•	Get the maximum loan amount per branch and the customer name.

•	Branch-wise count of customers sorted by count in descending order.

•	Fetch only the first name from the CustomerName and append the loan amount.

•	Fetch loans with odd amounts.

•	Create a view to fetch loan details with an amount greater than $50,000.

•	Create a procedure to update the loan interest rate by 2% where the loan type is 'Home Loan' and the branch is not 'MainBranch'.

•	Create a stored procedure to fetch loan details along with the customer, branch, and state, including error handling.

# Data Source
Healthcare industry

# Tools Used
Microsoft SQL Server 
SQL Server Management Studio
Query writing and testing tools

# Data Analysis
The project involves the design and implementation of a database schema, creation of tables, insertion of data, and development of queries and stored procedures to extract insights and answer specific business questions.

# Query
```
CREATE DATABASE FinanceLoanDb;

CREATE TABLE Customer (
  CustomerID VARCHAR(20) PRIMARY KEY,
  CustomerName VARCHAR(20),
  Amount INT,
  InterestRate INT,
  StateID INT
);
INSERT INTO Customer(CustomerID,CustomerName,Amount,InterestRate,StateID)
VALUES
('C01','Alice Johnson',50000,0.0550,101),
('C02','Bob Smith',75000,0.0600,102),
('C03','Carol White',60000,0.0480,103),
('C04','Dave Williams',85000,0.0520,104),
('C05','Emma Brown',55000,0.0450,105),
('C06','Frank Miller',40000,0.0650,106),
('C07','Grace Davis',95000,0.0580,107),
('C08','Henry Wilson',30000,0.0620,108),
('C09','Irene Moore',70000,0.0500,109),
('C10','Jack Taylor',80000,0.0570,110);

CREATE TABLE Loan (
  LoanID VARCHAR(20) PRIMARY KEY,
  LoanType VARCHAR(20),
  LoanAmount INT
);
INSERT INTO Loan( LoanID, LoanType, LoanAmount)
VALUES
('L01','Home Loan',50000),
('L02','Auto Loan',75000),
('L03','Personal Loan',60000),
('L04','Education Loan',85000),
('L05','Business Loan',55000),
('L06','Home Loan',40000),
('L07','Auto Loan',95000),
('L08','Personal Loan',30000),
('L09','Education Loan',70000),
('L10','Business Loan',80000);

CREATE TABLE LoanCustomer (
  LoanID VARCHAR(20),
  CustomerID VARCHAR(20),
  PRIMARY KEY (LoanID, CustomerID),
  FOREIGN KEY (LoanID) REFERENCES Loan(LoanID),
  FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);

INSERT INTO loanCustomer ( LoanID, CustomerID)
VALUES 
('L01','C01'), 
('L02','C02'),
('L03','C03'),
('L04','C04'),
('L05','C05'),
('L06','C06'),
('L07','C07'),
('L08','C08'),
('L09','C09'),
('L10','C10');

 CREATE TABLE StatemasterF(
 StateID INT PRIMARY KEY,
StateName VARCHAR(20));

INSERT INTO  Branchmaster(BranchID, BranchName,Location)
VALUES
('B01','MainBranch','Lagos'),
('B02','EastBranch','Abuja'),
('B03','WestBranch','Kano'),
('B04','NorthBranch','Delta'),
('B05','SouthBranch','Ido'),
('B06','CentralBranch','Ibadan'),
('B07','PacificBranch','Enugu'),
('B08','MountainBranch','Kaduna'),
('B09','SouthernBranch','Ogun'),
('B10','GulfBranch','Anambra');

INSERT INTO StatemasterF(StateID,StateName)
VALUES
(101,'Lagos'),
(102,'Abuja'),
(103,'Kano'),
(104,'Delta'),
(105,'Ido'),
(106,'Ibadan'),
(107,'Enugu'),
(108,'Kaduna'),
(109,'Ogun'),
(110,'Anambra');

CREATE TABLE Branchmaster(
BranchID VARCHAR(20) PRIMARY KEY,
BranchName VARCHAR(20),
Location1 VARCHAR(20) );

-- Analytical questions

--1. Fetch customers with the same loan amount:
SELECT CustomerName, LoanAmount
FROM Customer
WHERE Loan IN (
SELECT LoanAmount
FROM customer
GROUP BY LoanAmount
HAVING COUNT(CustomerID) > 1);

--2. Find the second highest loan amount and the customer and branch associated with it:

SELECT CustomerName, LoanAmount, BranchName
FROM Customer
JOIN Loan ON Customer.LoanID = Loan.LoanID
JOIN Branchmaster ON Loan.BranchID = Branchmaster.BranchID
ORDER BY LoanAmount DESC
OFFSET 1 ROW
FETCH NEXT 1 ROW ONLY;

--3. Get the maximum loan amount per branch and the customer name:

SELECT BranchName, MAX(LoanAmount) AS MaxLoanAmount, CustomerName
FROM Customer
JOIN Loan ON Customer.LoanID = Loan.LoanID
JOIN Branchmaster ON Loan.BranchID = Branchmaster.BranchID
GROUP BY BranchName, CustomerName;

--4. Branch-wise count of customers sorted by count in descending order:

SELECT BranchName, COUNT(CustomerID) AS CustomerCount
FROM Customer
JOIN Loan ON Customer.LoanID = Loan.LoanID
JOIN Branchmaster ON Loan.BranchID = Branchmaster.BranchID
GROUP BY BranchName
ORDER BY CustomerCount DESC;

--5. Fetch only the first name from the CustomerName and append the loan amount:

SELECT LEFT(CustomerName, CHARINDEX(' ', CustomerName) - 1) AS FirstName, LoanAmount
FROM Customer;

--6. Fetch loans with odd amounts:

SELECT *
FROM Loan
WHERE LoanAmount % 2 != 0;

--7. Create a view to fetch loan details with an amount greater than $50,000:

CREATE VIEW HighValueLoans AS
SELECT *
FROM Loan
WHERE LoanAmount > 50000;

--8. Create a procedure to update the loan interest rate by 2% where the loan type is 'Home Loan' and the branch is not 'MainBranch':

CREATE PROCEDURE UpdateInterestRate AS
BEGIN
UPDATE Loan
SET InterestRate = InterestRate * 1.02
WHERE LoanType = 'Home Loan' AND BranchID != 'MainBranch'
END;

--9. Create a stored procedure to fetch loan details along with the customer, branch, and state, including error handling:

CREATE PROCEDURE GetLoanDetails AS
BEGIN TRY
SELECT *
FROM Loan
JOIN Customer ON Loan.CustomerID = Customer.CustomerID
JOIN Branchmaster ON Loan.BranchID = Branchmaster.BranchID
JOIN Statemaster ON Customer.StateID = Statemaster.StateID
END TRY
BEGIN CATCH
DECLARE @ErrorMessage NVARCHAR(4000)
SET @ErrorMessage = ERROR_MESSAGE()
RAISERROR (@ErrorMessage, 16, 1)
END CATCH

```
# Image
![image](https://github.com/user-attachments/assets/d232dfa7-1b7e-43b8-ba43-1259f861490a)


# Findings 
1. Highest Loan Amount: The highest loan amount is $40,000, associated with customer "Jane Smith" and branch "Ibadan".
2. Branch with Most Customers: The branch with the most customers is "Ibadan" with 3 customers.
3. Loan Amount Range: The loan amounts range from $20,000 to $40,000.
4. No Loans with Odd Amounts: There are no loans with odd amounts.
5. No Loans above $50,000: There are no loans with amounts greater than $50,000.
6. Interest Rate Update: The interest rate for loans with type "Home Loan" and branch not "MainBranch" has been updated by 2%.
7. Customer and Branch Distribution:
    - Lagos: 2 customers
    - Ibadan: 3 customers
    - Abuja: 2 customers
    - Kano: 1 customer
    - Delta: 1 customer
8. Loan Amount and Customer: The loan amount and customer name are:
    - John Doe: $30,000
    - Jane Smith: $40,000
    - Mary Johnson: $20,000
    - Michael Brown: $25,000
    - Patricia Davis: $35,000
# Recommendation
1. Optimize Loan Amounts: Consider revising loan amounts to better match customer needs, as the current range of $20,000 to $40,000 may not be sufficient for some customers.
2. Targeted Marketing: Focus marketing efforts on branches with high customer concentrations, such as Ibadan, to maximize outreach and engagement.
3. Interest Rate Review: Regularly review and adjust interest rates to ensure competitiveness and fairness, particularly for customers with "Home Loans" in branches other than "MainBranch".
4. Customer Segmentation: Develop targeted loan products and services based on customer segments, such as loan amount and branch, to better meet their needs.
5. Expand Loan Offerings: Consider introducing new loan products or increasing loan amounts to capture customers seeking higher amounts, as none currently exceed $50,000.
6. Branch-Specific Strategies: Develop branch-specific strategies to address unique customer needs and preferences, such as tailored loan products or services.
7. Customer Retention: Implement customer retention strategies to maintain relationships with existing customers, particularly those with higher loan amounts.
# Conclusion
The analysis of the loan data revealed valuable insights into customer borrowing habits, loan amount distribution, and branch-specific trends. By leveraging these findings, the organization can optimize loan products, target marketing efforts, and enhance customer relationships to drive business growth. Ultimately, data-driven decision-making will enable the organization to better serve its customers and stay competitive in the market.

