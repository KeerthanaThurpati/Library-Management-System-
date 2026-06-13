create database Library_Management_System;

use Library_Management_System;


drop table tbl_publisher;
-- Table: tbl_publisher
CREATE TABLE tbl_publisher (
    publisher_PublisherName VARCHAR(255) PRIMARY KEY,
    publisher_PublisherAddress TEXT,
    publisher_PublisherPhone VARCHAR(15)
);
select * from tbl_publisher;
select count(publisher_PublisherName) from tbl_publisher;

-- Table: tbl_book
CREATE TABLE tbl_book (
    book_BookID INT PRIMARY KEY,
    book_Title VARCHAR(255),
    book_PublisherName VARCHAR(255),
    FOREIGN KEY (book_PublisherName) REFERENCES tbl_publisher(publisher_PublisherName)
);
select  * from tbl_book;
select count(book_BookID) from tbl_book;

-- Table: tbl_book_authors
drop table tbl_book_authors;
CREATE TABLE tbl_book_authors (
    book_authors_AuthorID INT PRIMARY KEY AUTO_INCREMENT,
    book_authors_BookID INT,
    book_authors_AuthorName VARCHAR(255),
    FOREIGN KEY (book_authors_BookID) REFERENCES tbl_book(book_BookID)
);
select * from tbl_book_authors;
select count(book_authors_AuthorID) from tbl_book_authors;

-- Table: tbl_library_branch
CREATE TABLE tbl_library_branch (
    library_branch_BranchID INT PRIMARY KEY AUTO_INCREMENT,
    library_branch_BranchName VARCHAR(255),
    library_branch_BranchAddress TEXT
);
select * from tbl_library_branch;
select count(library_branch_BranchID) from tbl_library_branch;

-- Table: tbl_book_copies
drop table tbl_book_copies;
CREATE TABLE tbl_book_copies (
    book_copies_CopiesID INT PRIMARY KEY AUTO_INCREMENT,
    book_copies_BookID INT,
    book_copies_BranchID INT,
    book_copies_No_Of_Copies INT,
    FOREIGN KEY (book_copies_BookID) REFERENCES tbl_book(book_BookID),
    FOREIGN KEY (book_copies_BranchID) REFERENCES tbl_library_branch(library_branch_BranchID)
);
select * from tbl_book_copies;
select count(book_copies_CopiesID) from tbl_book_copies;

-- Table: tbl_borrower
CREATE TABLE tbl_borrower (
    borrower_CardNo INT PRIMARY KEY,
    borrower_BorrowerName VARCHAR(255),
    borrower_BorrowerAddress TEXT,
    borrower_BorrowerPhone VARCHAR(15)
);
select * from tbl_borrower;


select count(borrower_BorrowerName) from tbl_borrower;
-- Table: tbl_book_loans

drop table tbl_book_loans;
CREATE TABLE tbl_book_loans (
    book_loans_LoansID INT PRIMARY KEY AUTO_INCREMENT,
    book_loans_BookID INT,
    book_loans_BranchID INT,
    book_loans_CardNo INT,
    book_loans_DateOut TEXT,
    book_loans_DueDate TEXT,
    FOREIGN KEY (book_loans_BookID) REFERENCES tbl_book(book_BookID),
    FOREIGN KEY (book_loans_BranchID) REFERENCES tbl_library_branch(library_branch_BranchID),
    FOREIGN KEY (book_loans_CardNo) REFERENCES tbl_borrower(borrower_CardNo)
);

select * from tbl_book_loans;


-- Q1.  How many copies of the book titled "The Lost Tribe" are owned by the library branch whose name is "Sharpstown"?
select bc.book_copies_No_Of_Copies from tbl_book_copies bc join 
tbl_book b on b.book_BookID=bc.book_copies_BookID
join tbl_library_branch lb on lb.library_branch_BranchID=bc.book_copies_BranchID
where b.book_Title= "The Lost Tribe" and lb.library_branch_BranchName="Sharpstown";


-- Q2. How many copies of the book titled "The Lost Tribe" are owned by each library branch?
select lb.library_branch_BranchName,bc. book_copies_No_Of_Copies from tbl_book_copies bc 
join tbl_book b on b.book_BookID=bc.book_copies_bookid 
join tbl_library_branch lb on lb.library_branch_BranchID=bc.book_copies_branchID
 where b.book_title='The Lost Tribe';
 
 

-- Q3.Retrieve the names of all borrowers who do not have any books checked out.
select borrower_BorrowerName from tbl_borrower br 
left join tbl_book_loans bl on br.borrower_CardNo=bl.book_loans_CardNo
 where bl.book_loans_CardNo is null;



-- Q4. For each book that is loaned out from the "Sharpstown" branch and whose DueDate is 2/3/18,
-- retrieve the book title, the borrower's name, and the borrower's address.
select book_Title,borrower_BorrowerName,borrower_BorrowerPhone from tbl_book_loans bl 
join tbl_book b on b.book_BookID=book_loans_BookID
join tbl_borrower br on br.borrower_CardNo=bl.book_loans_CardNo
join tbl_library_branch lb on lb.library_branch_BranchID=bl.book_loans_BranchID
 where lb.library_branch_BranchName='Sharpstown' and bl.book_loans_DueDate='02-03-2018' ;

-- Q5. For each library branch, retrieve the branch name and the total number of books loaned out from that branch.
select lb.library_branch_BranchName,count(*) as Total_number_of_books from tbl_library_branch lb
 join tbl_book_loans bl on  lb.library_branch_BranchID=bl.book_loans_BranchID 
 group by lb.library_branch_branchName;

-- Q6. Retrieve the names, addresses, and number of books checked out for all borrowers who have more than five books checked out.
select  br.borrower_BorrowerName,br.borrower_BorrowerAddress,count(bl.book_loans_BookID) as book_checkout from tbl_borrower br
join tbl_book_loans bl on br.borrower_CardNo=bl.book_loans_CardNo 
group by  br.borrower_BorrowerName,br.borrower_BorrowerAddress, br.borrower_CardNo
having count(bl.book_loans_BookID)>5;


-- Q7.For each book authored by "Stephen King", retrieve the title and the number of copies
-- owned by the library branch whose name is "Central".
select b.book_Title,bc.book_copies_No_Of_Copies as Number_of_copies from tbl_book b join
tbl_book_authors ba on b.book_BookID=ba.book_authors_BookID 
join  tbl_book_copies bc on bc. book_copies_BookID=b.book_BookID
join tbl_library_branch lb on bc.book_copies_BranchID= lb.library_branch_BranchID
where ba.book_authors_AuthorName='Stephen King' and lb.library_branch_BranchName='central';


select * from tbl_borrower limit 4 offset 4;


select bc.book_copies_No_Of_Copies,bc.book_copies_CopiesID,lb.library_branch_BranchName,rank() over(partition by lb.library_branch_BranchName order by book_copies_No_Of_Copies) from tbl_book_copies bc join tbl_library_branch lb on  bc.book_copies_BranchID=lb.library_branch_BranchID;