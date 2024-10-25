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
USE FinanceLoanDb;

CREATE TABLE Customer(
CustomerID VARCHAR(20) PRIMARY KEY,
CustomerName VARCHAR(20),
LoanID VARCHAR(20),
FOREIGN KEY (LoanID) REFERENCES Loan(LoanID),
Amount INT,
InterestRate INT,
StateID INT,
FOREIGN KEY (StateID) REFERENCES Loan(LoanID)
);

CREATE TABLE Loan(
LoanID VARCHAR(20 PRIMARY KEY,
LoanType VARCHAR(20),
LoanAmount INT,
CustomerID VARCHAR(20),
FOREIGN (CustomerID) REFERENCES Customer(CustomerID)
 );

 CREATE TABLE Statemaster(
 StateID INT PRIIMARY KEY,
StateName VARCHAR(20));

CREATE TABLE Branchmaster(
BranchID VARCHAR(20) PRIMARY KEY,
BranchName VARCHAR(20),
Location VARCHAR(20) );

INSERT INTO Patient(PatientID,PatientName,Age,Gender,DoctorID,StateID)
VALUES
('PT01','John Doe'45,'M',1,101),
('PT02','Jane Smith',30,'F',2,102),
('PT03','Mary Johnson',60,'F',3,103),
('PT04','Michael Brown',50,'M',4,104),
('PT05','Patricia Davis',40,'F',1,105),
('PT06','Robert Miller',55,'M',2,106),
('PT07','Linda Wilson',35,'F',3,107),
('PT08','William Moore',65,'M',4,108),
('PT09','Barbara Taylor',28,'F',1,109),
('PT10','James Anderson',70,'M',2,110);

INSERT INTO Doctor(DoctorID,DoctorName,Specialization)
VALUES
(1,'Dr. Smith','Cardiology'),
(2,'Dr. Adams','Neurology'),
(3,'Dr. White','Orthopedics'),
(4,'Dr. Johnson','Dermatology');


INSERT INTO Statemaster(StateID,StateName)
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


INSERT INTO Department(DepartmentID, DepartmentName)
VALUE 
(1,'Cardiology'),
(2,'Neurology'),
(3,'Orthopedics'),
(4,'Dermatology');


1. Fetch customers with the same loan amount:

SELECT CustomerName, LoanAmount
FROM Customer
GROUP BY LoanAmount
HAVING COUNT(LoanAmount) > 1

2. Find the second highest loan amount and the customer and branch associated with it:

SELECT TOP 1 CustomerName, LoanAmount, BranchName
FROM Customer
JOIN Loan ON Customer.LoanID = Loan.LoanID
JOIN Branchmaster ON Loan.BranchID = Branchmaster.BranchID
ORDER BY LoanAmount DESC
OFFSET 1 ROW

3. Get the maximum loan amount per branch and the customer name:

SELECT BranchName, MAX(LoanAmount) AS MaxLoanAmount, CustomerName
FROM Customer
JOIN Loan ON Customer.LoanID = Loan.LoanID
JOIN Branchmaster ON Loan.BranchID = Branchmaster.BranchID
GROUP BY BranchName, CustomerName

4. Branch-wise count of customers sorted by count in descending order:

SELECT BranchName, COUNT(CustomerID) AS CustomerCount
FROM Customer
JOIN Loan ON Customer.LoanID = Loan.LoanID
JOIN Branchmaster ON Loan.BranchID = Branchmaster.BranchID
GROUP BY BranchName
ORDER BY CustomerCount DESC

5. Fetch only the first name from the CustomerName and append the loan amount:

SELECT LEFT(CustomerName, CHARINDEX(' ', CustomerName) - 1) AS FirstName, LoanAmount
FROM Customer

6. Fetch loans with odd amounts:

SELECT *
FROM Loan
WHERE LoanAmount % 2 != 0

7. Create a view to fetch loan details with an amount greater than $50,000:

CREATE VIEW HighValueLoans AS
SELECT *
FROM Loan
WHERE LoanAmount > 50000

8. Create a procedure to update the loan interest rate by 2% where the loan type is 'Home Loan' and the branch is not 'MainBranch':

CREATE PROCEDURE UpdateInterestRate AS
BEGIN
UPDATE Loan
SET InterestRate = InterestRate * 1.02
WHERE LoanType = 'Home Loan' AND BranchID != 'MainBranch'
END

9. Create a stored procedure to fetch loan details along with the customer, branch, and state, including error handling:

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

