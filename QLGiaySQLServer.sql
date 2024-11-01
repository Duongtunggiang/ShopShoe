USE master;
GO

-- Xóa database nếu đã tồn tại
DROP DATABASE IF EXISTS quanlygiaydep;
CREATE DATABASE quanlygiaydep;
GO

USE quanlygiaydep;
GO

-- Tạo bảng lưu vai trò người dùng
CREATE TABLE Role (
    RoleID INT PRIMARY KEY IDENTITY,
    RoleName NVARCHAR(50) NOT NULL
);

-- Bảng tài khoản người dùng
CREATE TABLE Account (
    AccountID INT PRIMARY KEY IDENTITY,
    Username NVARCHAR(50) NOT NULL UNIQUE,
    Password NVARCHAR(255) NOT NULL,
    RoleID INT FOREIGN KEY REFERENCES Role(RoleID)
);

-- Bảng lưu thông tin khách hàng, bao gồm ảnh đại diện
CREATE TABLE Customer (
    CustomerID INT PRIMARY KEY IDENTITY,
    AccountID INT FOREIGN KEY REFERENCES Account(AccountID),
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    [From] NVARCHAR(50),
    Address NVARCHAR(255),
    PhoneNumber NVARCHAR(20),
    Email NVARCHAR(50),
    ProfileImagePath NVARCHAR(255) -- Lưu đường dẫn ảnh đại diện
);

-- Bảng lưu thông tin người bán, bao gồm ảnh đại diện
CREATE TABLE Saler (
    SalerID INT PRIMARY KEY IDENTITY,
    AccountID INT FOREIGN KEY REFERENCES Account(AccountID),
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    Address NVARCHAR(255),
    PhoneNumber NVARCHAR(20),
    Email NVARCHAR(50),
    ProfileImagePath NVARCHAR(255) -- Lưu đường dẫn ảnh đại diện
);

-- Bảng lưu thông tin admin, bao gồm ảnh đại diện
CREATE TABLE Admin (
    AdminID INT PRIMARY KEY IDENTITY,
    AccountID INT FOREIGN KEY REFERENCES Account(AccountID),
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    Email NVARCHAR(50),
    ProfileImagePath NVARCHAR(255) -- Lưu đường dẫn ảnh đại diện
);

-- Bảng lưu loại sản phẩm (thương hiệu)
CREATE TABLE Category (
    CategoryID INT PRIMARY KEY IDENTITY,
    CategoryName NVARCHAR(100),
    BrandImagePath NVARCHAR(255) -- Lưu đường dẫn ảnh thương hiệu
);

-- Bảng lưu thông tin sản phẩm
CREATE TABLE Product (
    ProductID INT PRIMARY KEY IDENTITY,
    SalerID INT FOREIGN KEY REFERENCES Saler(SalerID),
    CategoryID INT FOREIGN KEY REFERENCES Category(CategoryID),
    ProductName NVARCHAR(100),
    Quality INT,
    Price DECIMAL(18,2),
    Discount DECIMAL(18,2) NULL,
    ProductImagePath NVARCHAR(255), -- Lưu đường dẫn ảnh sản phẩm
    Color NVARCHAR(50),
    Style NVARCHAR(100)
);

-- Bảng ví cho khách hàng
CREATE TABLE CustomerWallet (
    WalletID INT PRIMARY KEY IDENTITY,
    CustomerID INT NOT NULL,
    Balance DECIMAL(10, 2) NOT NULL DEFAULT 0,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);

-- Bảng ví cho người bán
CREATE TABLE SalerWallet (
    WalletID INT PRIMARY KEY IDENTITY,
    SalerID INT NOT NULL,
    Balance DECIMAL(10, 2) NOT NULL DEFAULT 0,
    FOREIGN KEY (SalerID) REFERENCES Saler(SalerID)
);

-- Bảng hóa đơn
CREATE TABLE Booking (
    BookingID INT PRIMARY KEY IDENTITY,
    CustomerID INT FOREIGN KEY REFERENCES Customer(CustomerID),
    BookingCode AS 'HD' + RIGHT('0000' + CAST(BookingID AS NVARCHAR), 4), -- Tạo mã hóa đơn tự động
    Status NVARCHAR(50), -- Trạng thái đơn hàng
    TotalAmount DECIMAL(18,2),
    CreatedDate DATETIME DEFAULT GETDATE()
);

-- Bảng chi tiết hóa đơn
CREATE TABLE BookingDetails (
    BookingDetailsID INT PRIMARY KEY IDENTITY,
    BookingID INT FOREIGN KEY REFERENCES Booking(BookingID),
    ProductID INT FOREIGN KEY REFERENCES Product(ProductID),
    Quantity INT,
    Price DECIMAL(18,2)
);

-- Bảng quà tặng kèm sản phẩm
CREATE TABLE Gift (
    GiftID INT PRIMARY KEY IDENTITY,
    ProductID INT FOREIGN KEY REFERENCES Product(ProductID),
    GiftName NVARCHAR(100),
    Description NVARCHAR(255),
    Quantity INT
);

-- Bảng giỏ hàng
CREATE TABLE Cart (
    CartID INT PRIMARY KEY IDENTITY,
    CustomerID INT FOREIGN KEY REFERENCES Customer(CustomerID)
);

-- Bảng mục trong giỏ hàng
CREATE TABLE CartItem (
    CartItemID INT PRIMARY KEY IDENTITY,
    CartID INT FOREIGN KEY REFERENCES Cart(CartID),
    ProductID INT FOREIGN KEY REFERENCES Product(ProductID),
    Quantity INT,
    Price DECIMAL(18,2)
);

-- Bảng giao dịch thanh toán
CREATE TABLE Transactions (
    TransactionsID INT PRIMARY KEY IDENTITY,
    BookingID INT FOREIGN KEY REFERENCES Booking(BookingID),
    Amount DECIMAL(18, 2),
    TransactionsDate DATETIME DEFAULT GETDATE(),
    Status NVARCHAR(50), -- Ví dụ: Success, Failed
    PaymentMethod NVARCHAR(50) -- Ví dụ: VNPay, Momo, ...
);

-- Bảng kích thước sản phẩm
CREATE TABLE Size (
    SizeID INT PRIMARY KEY IDENTITY,
    ProductID INT FOREIGN KEY REFERENCES Product(ProductID),
    SizeValue NVARCHAR(10) -- Ví dụ: 36, 37, 38...
);

-- Bảng màu sắc sản phẩm
CREATE TABLE Color (
    ColorID INT PRIMARY KEY IDENTITY,
    ProductID INT FOREIGN KEY REFERENCES Product(ProductID),
    ColorValue NVARCHAR(50)
);

-- Bảng hình ảnh sản phẩm
CREATE TABLE ProductImages (
    ImageID INT PRIMARY KEY IDENTITY,
    ProductID INT FOREIGN KEY REFERENCES Product(ProductID),
    ImagePath NVARCHAR(255) -- Lưu đường dẫn ảnh sản phẩm
);

-- Bảng thông tin chi tiết sản phẩm
CREATE TABLE ProductDetails (
    DetailID INT PRIMARY KEY IDENTITY,
    ProductID INT FOREIGN KEY REFERENCES Product(ProductID),
    Description NVARCHAR(MAX) -- Mô tả sản phẩm
);

-- Bảng bài viết liên quan đến sản phẩm
CREATE TABLE RelatedArticles (
    ArticleID INT PRIMARY KEY IDENTITY,
    ProductID INT FOREIGN KEY REFERENCES Product(ProductID),
    Title NVARCHAR(100),
    Content NVARCHAR(MAX),
    CreatedDate DATETIME DEFAULT GETDATE()
);

-- Kiểm tra tất cả các bảng
SELECT * FROM Account;
SELECT * FROM Role;
SELECT * FROM Customer;
SELECT * FROM Saler;
SELECT * FROM Admin;
SELECT * FROM Category;
SELECT * FROM Product;
SELECT * FROM CustomerWallet;
SELECT * FROM SalerWallet;
SELECT * FROM Booking;
SELECT * FROM BookingDetails;
SELECT * FROM Gift;
SELECT * FROM Cart;
SELECT * FROM CartItem;
SELECT * FROM Transactions;
SELECT * FROM Size;
SELECT * FROM Color;
SELECT * FROM ProductImages;
SELECT * FROM ProductDetails;
SELECT * FROM RelatedArticles;
