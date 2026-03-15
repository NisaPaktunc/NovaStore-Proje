-- ============================================================
-- NovaStore E-Ticaret Veri Yönetim Sistemi
-- Hazırlayan: Fatma Nisa PAKTUNÇ
-- Tarih: 2026
-- ============================================================


-- ============================================================
-- BÖLÜM 1: VERİ TABANI TASARIMI (DDL)
-- ============================================================

-- Görev 1.1: Veritabanı Oluşturma
CREATE DATABASE NovaStoreDB;
GO

USE NovaStoreDB;
GO

-- -------------------------------------------------------
-- Görev 1.2-A: Categories (Kategoriler) Tablosu
-- -------------------------------------------------------
CREATE TABLE Categories (
    CategoryID   INT           IDENTITY(1,1) PRIMARY KEY,
    CategoryName VARCHAR(50)   NOT NULL
);
GO

-- -------------------------------------------------------
-- Görev 1.2-B: Products (Ürünler) Tablosu
-- -------------------------------------------------------
CREATE TABLE Products (
    ProductID    INT             IDENTITY(1,1) PRIMARY KEY,
    ProductName  VARCHAR(100)    NOT NULL,
    Price        DECIMAL(10,2),
    Stock        INT             DEFAULT 0,
    CategoryID   INT,
    CONSTRAINT FK_Products_Categories FOREIGN KEY (CategoryID)
        REFERENCES Categories(CategoryID)
);
GO

-- -------------------------------------------------------
-- Görev 1.2-C: Customers (Müşteriler) Tablosu
-- -------------------------------------------------------
CREATE TABLE Customers (
    CustomerID   INT           IDENTITY(1,1) PRIMARY KEY,
    FullName     VARCHAR(50),
    City         VARCHAR(20),
    Email        VARCHAR(100)  UNIQUE
);
GO

-- -------------------------------------------------------
-- Görev 1.2-D: Orders (Siparişler) Tablosu
-- -------------------------------------------------------
CREATE TABLE Orders (
    OrderID      INT             IDENTITY(1,1) PRIMARY KEY,
    CustomerID   INT,
    OrderDate    DATETIME        DEFAULT GETDATE(),
    TotalAmount  DECIMAL(10,2),
    CONSTRAINT FK_Orders_Customers FOREIGN KEY (CustomerID)
        REFERENCES Customers(CustomerID)
);
GO

-- -------------------------------------------------------
-- Görev 1.2-E: OrderDetails (Sipariş Detayları) Tablosu
-- -------------------------------------------------------
CREATE TABLE OrderDetails (
    DetailID   INT  IDENTITY(1,1) PRIMARY KEY,
    OrderID    INT,
    ProductID  INT,
    Quantity   INT,
    CONSTRAINT FK_OrderDetails_Orders   FOREIGN KEY (OrderID)
        REFERENCES Orders(OrderID),
    CONSTRAINT FK_OrderDetails_Products FOREIGN KEY (ProductID)
        REFERENCES Products(ProductID)
);
GO


-- ============================================================
-- BÖLÜM 2: VERİ GİRİŞİ (DML - INSERT)
-- ============================================================

-- -------------------------------------------------------
-- Görev 2.1: 5 Kategori Ekleme
-- -------------------------------------------------------
INSERT INTO Categories (CategoryName) VALUES
('Elektronik'),
('Giyim'),
('Kitap'),
('Kozmetik'),
('Ev ve Yaşam');
GO

-- -------------------------------------------------------
-- Görev 2.2: En Az 10-12 Ürün Ekleme
-- -------------------------------------------------------
INSERT INTO Products (ProductName, Price, Stock, CategoryID) VALUES
-- Elektronik (CategoryID = 1)
('Samsung Galaxy S23',        18999.99,  15, 1),
('Apple AirPods Pro',          4599.00,  30, 1),
('Logitech MX Keys Klavye',    2299.00,   8, 1),

-- Giyim (CategoryID = 2)
('Nike Air Force 1 Spor Ayakkabı', 2850.00, 25, 2),
('Levi''s 501 Kot Pantolon',        1299.00, 40, 2),
('Columbia Kışlık Mont',            3450.00, 12, 2),

-- Kitap (CategoryID = 3)
('Dune - Frank Herbert',     149.00,  50, 3),
('Sapiens - Yuval Noah Harari', 185.00, 45, 3),

-- Kozmetik (CategoryID = 4)
('Nivea Nemlendirici Krem',    89.90, 60, 4),
('L''Oreal Revitalift Serum', 349.00, 18, 4),
('Maybelline Fit Me Fondöten', 179.00, 35, 4),

-- Ev ve Yaşam (CategoryID = 5)
('Tefal Tencere Seti',        1250.00, 20, 5),
('Philips Airfryer',          3899.00,  9, 5);
GO

-- -------------------------------------------------------
-- Görev 2.3: 5-6 Müşteri Kaydı
-- -------------------------------------------------------
INSERT INTO Customers (FullName, City, Email) VALUES
('Ahmet Yılmaz',  'İstanbul', 'ahmet.yilmaz@email.com'),
('Elif Kaya',     'Ankara',   'elif.kaya@email.com'),
('Mehmet Demir',  'İzmir',    'mehmet.demir@email.com'),
('Zeynep Çelik',  'Bursa',    'zeynep.celik@email.com'),
('Can Arslan',    'Antalya',  'can.arslan@email.com'),
('Selin Öztürk',  'İstanbul', 'selin.ozturk@email.com');
GO

-- -------------------------------------------------------
-- Görev 2.4: Siparişler ve Sipariş Detayları
-- -------------------------------------------------------
INSERT INTO Orders (CustomerID, OrderDate, TotalAmount) VALUES
(1, '2025-01-10', 23598.99),  -- OrderID = 1 : Ahmet
(2, '2025-01-15',  4599.00),  -- OrderID = 2 : Elif
(3, '2025-02-03',  4149.00),  -- OrderID = 3 : Mehmet
(4, '2025-02-20',   268.90),  -- OrderID = 4 : Zeynep
(1, '2025-03-01',  3899.00),  -- OrderID = 5 : Ahmet (2. sipariş)
(5, '2025-03-08',  6300.00),  -- OrderID = 6 : Can
(6, '2025-03-12',  1250.00),  -- OrderID = 7 : Selin
(2, '2025-03-14',  5149.00),  -- OrderID = 8 : Elif (2. sipariş)
(3, '2025-04-01',  2850.00),  -- OrderID = 9 : Mehmet
(4, '2025-04-05',   334.00);  -- OrderID = 10: Zeynep
GO

INSERT INTO OrderDetails (OrderID, ProductID, Quantity) VALUES
-- Sipariş 1: Samsung (18999.99) + AirPods (4599.00)
(1, 1, 1),
(1, 2, 1),

-- Sipariş 2: AirPods
(2, 2, 1),

-- Sipariş 3: Mont (3450) + Kot Pantolon (1299) x 2 = 4749 → yaklaşık
(3, 6, 1),
(3, 5, 1),

-- Sipariş 4: Nemlendirici (89.90) + Fondöten (179.00)
(4, 9, 1),
(4, 11, 1),

-- Sipariş 5: Airfryer
(5, 13, 1),

-- Sipariş 6: Spor Ayakkabı (2850 x 2) + Mont (3450) → Can
(6, 4, 2),
(6, 6, 1),

-- Sipariş 7: Tencere Seti
(7, 12, 1),

-- Sipariş 8: Logitech Klavye (2299) + Serum (349) x 2
(8, 3, 1),
(8, 10, 2),

-- Sipariş 9: Spor Ayakkabı
(9, 4, 1),

-- Sipariş 10: Sapiens + Dune
(10, 8, 1),
(10, 7, 1);
GO


-- ============================================================
-- BÖLÜM 3: SORGULAMA VE ANALİZ (DQL)
-- ============================================================

-- -------------------------------------------------------
-- Görev 3.1: Stok Miktarı 20'den Az Ürünler (AZALAN sıra)
-- -------------------------------------------------------
SELECT
    ProductName     AS [Ürün Adı],
    Stock           AS [Stok Miktarı]
FROM Products
WHERE Stock < 20
ORDER BY Stock DESC;
GO

-- -------------------------------------------------------
-- Görev 3.2: Müşteri - Sipariş Birleştirme (JOIN)
-- -------------------------------------------------------
SELECT
    c.FullName      AS [Müşteri Adı],
    c.City          AS [Şehir],
    o.OrderDate     AS [Sipariş Tarihi],
    o.TotalAmount   AS [Toplam Tutar (TL)]
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
ORDER BY o.OrderDate;
GO

-- -------------------------------------------------------
-- Görev 3.3: Ahmet Yılmaz'ın Aldığı Ürünler (Çoklu JOIN)
-- -------------------------------------------------------
SELECT
    c.FullName      AS [Müşteri],
    p.ProductName   AS [Ürün Adı],
    p.Price         AS [Birim Fiyat],
    cat.CategoryName AS [Kategori]
FROM Customers c
INNER JOIN Orders       o   ON c.CustomerID  = o.CustomerID
INNER JOIN OrderDetails od  ON o.OrderID     = od.OrderID
INNER JOIN Products     p   ON od.ProductID  = p.ProductID
INNER JOIN Categories   cat ON p.CategoryID  = cat.CategoryID
WHERE c.FullName = 'Ahmet Yılmaz';
GO

-- -------------------------------------------------------
-- Görev 3.4: Kategorilere Göre Ürün Sayısı (GROUP BY)
-- -------------------------------------------------------
SELECT
    cat.CategoryName    AS [Kategori],
    COUNT(p.ProductID)  AS [Ürün Sayısı]
FROM Categories cat
LEFT JOIN Products p ON cat.CategoryID = p.CategoryID
GROUP BY cat.CategoryName
ORDER BY [Ürün Sayısı] DESC;
GO

-- -------------------------------------------------------
-- Görev 3.5: Müşteri Ciro Analizi (SUM + GROUP BY)
-- -------------------------------------------------------
SELECT
    c.FullName          AS [Müşteri Adı],
    SUM(o.TotalAmount)  AS [Toplam Ciro (TL)]
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.FullName
ORDER BY [Toplam Ciro (TL)] DESC;
GO

-- -------------------------------------------------------
-- Görev 3.6: Siparişlerin Üzerinden Kaç Gün Geçti? (DATEDIFF)
-- -------------------------------------------------------
SELECT
    o.OrderID                                       AS [Sipariş No],
    c.FullName                                      AS [Müşteri Adı],
    o.OrderDate                                     AS [Sipariş Tarihi],
    DATEDIFF(DAY, o.OrderDate, GETDATE())           AS [Geçen Gün]
FROM Orders o
INNER JOIN Customers c ON o.CustomerID = c.CustomerID
ORDER BY [Geçen Gün] DESC;
GO


-- ============================================================
-- BÖLÜM 4: İLERİ SEVİYE VERİTABANI NESNELERİ
-- ============================================================

-- -------------------------------------------------------
-- Görev 4.1: VIEW Oluşturma - vw_SiparisOzet
-- -------------------------------------------------------
CREATE VIEW vw_SiparisOzet AS
SELECT
    c.FullName      AS [Müşteri Adı],
    o.OrderDate     AS [Sipariş Tarihi],
    p.ProductName   AS [Ürün Adı],
    od.Quantity     AS [Adet]
FROM Customers c
INNER JOIN Orders       o   ON c.CustomerID = o.CustomerID
INNER JOIN OrderDetails od  ON o.OrderID    = od.OrderID
INNER JOIN Products     p   ON od.ProductID = p.ProductID;
GO

-- VIEW'ı kullanmak için:
SELECT * FROM vw_SiparisOzet;
GO

-- -------------------------------------------------------
-- Görev 4.2: Veritabanı Yedeği Alma
-- -------------------------------------------------------
BACKUP DATABASE NovaStoreDB
TO DISK = 'C:\Yedek\NovaStoreDB.bak'
WITH FORMAT,
     MEDIANAME = 'NovaStoreDBYedek',
     NAME = 'NovaStoreDB Tam Yedek';
GO

-- ============================================================
-- PROJE SONU
-- ============================================================