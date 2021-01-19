CREATE DATABASE nhanvien
USE nhanvien
CREATE TABLE DONVI 
(
  MADV INT NOT NULL PRIMARY KEY,
  TENDV VARCHAR(50) NOT NULL
)
CREATE TABLE NHANVIEN
(
    HOTEN varchar(20) NOT NULL,
    MADV int 
    FOREIGN KEY (MADV) REFERENCES DONVI(MADV)
)

 

INSERT dbo.DONVI
        ( MADV, TENDV )
VALUES  ( 1, -- MADV - int
          'Doi ngoai'  -- TENDV - varchar(50)
          )
          INSERT dbo.DONVI
        ( MADV, TENDV )
VALUES  ( 2, -- MADV - int
          'Hanh chinh'  -- TENDV - varchar(50)
          )
INSERT dbo.DONVI
        ( MADV, TENDV )
VALUES  ( 3, -- MADV - int
          'Ke toan'  -- TENDV - varchar(50)
          )
INSERT dbo.DONVI
        ( MADV, TENDV )
VALUES  ( 4, -- MADV - int
          'Kinh doanh'  -- TENDV - varchar(50)
          )

 

INSERT dbo.NHANVIEN
        ( HOTEN, MADV )
VALUES  ( 'Thanh', -- MADV - int
          1  -- TENDV - varchar(50)
          )
          INSERT dbo.NHANVIEN
        ( HOTEN, MADV )
VALUES  ( 'Hoa', -- MADV - int
          2  -- TENDV - varchar(50)
          )
INSERT dbo.NHANVIEN
        ( HOTEN, MADV )
VALUES  ( 'Nam', -- MADV - int
          2  -- TENDV - varchar(50)
          )
INSERT dbo.NHANVIEN
        ( HOTEN, MADV )
VALUES  ( 'Vinh', -- MADV - int
          1  -- TENDV - varchar(50)
          )
INSERT dbo.NHANVIEN
        ( HOTEN, MADV )
VALUES  ( 'Hung', -- MADV - int
          4
           
          )
INSERT dbo.NHANVIEN
        ( HOTEN, MADV )
VALUES  ( 'Phuong;', -- MADV - int
          null  -- TENDV - varchar(50)
          )
          DELETE dbo.NHANVIEN
SELECT * FROM dbo.DONVI CROSS JOIN dbo.NHANVIEN 
SELECT * FROM dbo.DONVI  JOIN dbo.NHANVIEN ON dbo.DONVI.MADV=NHANVIEN.MADV
SELECT * FROM dbo.DONVI  FULL OUTER JOIN dbo.NHANVIEN ON dbo.DONVI.MADV=NHANVIEN.MADV
SELECT * FROM dbo.DONVI  LEFT OUTER JOIN dbo.NHANVIEN ON dbo.DONVI.MADV=NHANVIEN.MADV
SELECT * FROM dbo.DONVI  RIGHT OUTER JOIN dbo.NHANVIEN ON dbo.DONVI.MADV=NHANVIEN.MADV
 