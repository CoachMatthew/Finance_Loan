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
