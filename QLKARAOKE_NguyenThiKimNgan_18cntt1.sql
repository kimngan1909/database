CREATE DATABASE QLKARAOKE_NguyenThiKimNgan_18cntt1

CREATE TABLE KHACHHANG
(
  MaKH VARCHAR(20)PRIMARY KEY,
  TenKH VARCHAR(50)NOT NULL,
  DiaChi VARCHAR(50)NOT NULL,
  SoDT VARCHAR(20) NOT NULl,
  MaSoThue VARCHAR(20) NOT NULL
)

CREATE TABLE PHONG
(
  MaPhong VARCHAR(20) PRIMARY KEY,
  SoKhachToiDa INT NOT NULL,
  TrangThai VARCHAR(30) NOT NULL,
  MoTa VARCHAR(50) NOT NULL
)


CREATE TABLE MUCTIENGIO
(
  MaTienGio VARCHAR(20) PRIMARY KEY,
  DonGia INT NOT NULL,
  MoTa VARCHAR(50) NOT NULL
)



CREATE TABLE DICHVU
(
  MaDV VARCHAR(20) PRIMARY KEY,
  TenDV VARCHAR(50) NOT NULL,
  DonViTinh VARCHAR(20) NOT NULL,
  DonGia INT NOT NULL
)



CREATE TABLE HOADON
(
  MaHD VARCHAR(20) PRIMARY KEY,
  MaKH VARCHAR(20) FOREIGN KEY (MaKH) REFERENCES dbo.KHACHHANG(MaKH),
  MaPhong VARCHAR(20)FOREIGN KEY (MaPhong) REFERENCES dbo.PHONG(MaPhong),
  MaTienGio VARCHAR(20)FOREIGN KEY (MaTienGio) REFERENCES dbo.MUCTIENGIO(MaTienGio),
  ThoiGianBatDauSD SMALLDATETIME NOT NULL,
  ThoiGianKetThucSD SMALLDATETIME NOT NULL,
  TrangThaiHD VARCHAR(50) NOT NULL
  
)



CREATE TABLE CHITIET_SUDUNGDV
(
  MaHD VARCHAR(20) NOT NULL,
  MaDV VARCHAR(20) NOT NULL,
  PRIMARY KEY (MaHD, MaDV),
  SoLuong INT NOT NULL,
  FOREIGN KEY (MaHD) REFERENCES dbo.HOADON(MaHD),
  FOREIGN KEY (MaDV) REFERENCES dbo.DICHVU(MaDV)
  
)

INSERT INTO KHACHHANG VALUES
( 'KH001','Tran Van Nam' ,'Hai Chau' ,'0905123456' ,'12345678' ),
( 'KH002','Nguyen Mai Anh' ,'Lien Chieu' ,'0905123457' ,'12345679' ),
( 'KH003','Phan Hoai Lan Khue' ,'Hoa Vang' ,'0905123458' ,'12345680' ),
( 'KH004','Nguyen Hoai Nguyen' ,'Hoa Cam' ,'0905123459' ,'12345681' ),
( 'KH005','Le Truong Ngoc Anh' ,'Hai Chau' ,'0905123460' ,'12345682' ),
( 'KH006','Ho Hoai Anh' ,'Hai Chau' ,'0905123461' ,'12345683' ),
( 'KH007','Pham Thi Huong' ,'Son Tra' ,'0905123462' ,'12345684' ),
( 'KH008','Chau Tinh Tri' ,'Hai Chau' ,'0905123463' ,'12345685' ),
( 'KH009','Phan Nhu Thao' ,'Hoa Khanh' ,'0905123464' ,'12345686' ),
( 'KH010','Tran Thi To Tam' ,'Son Tra' ,'0905123455' ,'12345687' )


INSERT INTO PHONG VALUES
( 'VIP01','5','Duoc su dung', 'phong vip'),
( 'P02', '10','Duoc su dung', 'phong binh thuong'),
( 'P03', '15','Duoc su dung', 'phong binh thuong'),
('VIP04','20','Duoc su dung', 'phong vip'),
('P05', '25','Duoc su dung', 'phong binh thuong'),
('P06', '30','Duoc su dung', 'phong binh thuong'),
('VIP07', '35','Duoc su dung', 'phong vip'),
('P08', '40','Duoc su dung', 'phong binh thuong'),
('VIP09', '45','Duoc su dung', 'phong vip'),
('P10', '50','Duoc su dung', 'phong binh thuong')


INSERT INTO DICHVU VALUES
( 'DV01','Hat Dua','Bao','5000'),
( 'DV02','Trai Cay','Dia','30000'),
( 'DV03','Bia','Lon','35000'),
( 'DV04','Nuoc Ngot','Chai','10000'),
( 'DV05','Ruou','Chai','200000')

INSERT INTO MUCTIENGIO VALUES
('MT01','60000','Ap dung tu 6 gio den 17 gio'),
('MT02','80000','Ap dung tu 17 gio den 22 gio'),
('MT03','100000','Ap dung tu 22 gio den 6 gio sang')

INSERT INTO HOADON VALUES
('HD001','KH001','VIP01','MT01','11/20/2015 8:15', '11/20/2015 12:30', 'Da thanh toan'),
('HD002','KH002','P02','MT01','12/12/2015 13:10', '12/12/2015 17:20', 'Chua thanh toan'),
('HD003','KH001','P02','MT01','10/15/2014 12:12', '10/15/2015 16:30', 'Da thanh toan'),
('HD004','KH003','VIP01','MT02','9/20/2015 18:30', '9/20/2015 21:00', 'Chua thanh toan'),
('HD005','KH001','P03','MT02','11/25/2014 20:00', '11/25/2015 21:45', 'Thanh toan mot phan'),
('HD006','KH002','VIP01','MT01','9/12/2014 9:20', '9/12/2014 10:45', 'Da thanh toan'),
('HD007','KH006','VIP04','MT01','12/22/2014 11:00', '12/22/2014 14:20', 'Da thanh toan'),
('HD008','KH007','VIP04','MT02','8/23/2014 20:10', '8/23/2014 22:00', 'Chua thanh toan'),
('HD009','KH006','P05','MT03','12/20/2015 22:30 ', '12/21/2015 1:15', 'Chua thanh toan'),
('HD010','KH005','VIP01','MT03','10/10/2015 1:30', '10/10/2015 3:15', 'Da thanh toan'),
('HD011','KH004','VIP07','MT03','12/25/2015 22:15', '12/26/2015 2:00', 'Da thanh toan'),
('HD012','KH008','P06','MT03','7/25/2014 23:45', '7/26/2014 2:15', 'Da thanh toan'),
('HD013','KH007','VIP07','MT02','8/21/2015 18:15', '8/21/2015 20:45', 'Da thanh toan'),
('HD014','KH004','P06','MT02','12/31/2015 19:12', '12/31/2015 21:15', 'Thanh toan mot phan'),
('HD015','KH001','P06','MT01','6/24/2014 13:00', '6/24/2014 13:15', 'Thanh toan mot phan'),
('HD016','KH003','P08','MT01','5/12/2014 8:00', '5/12/2014 10:45', 'Thanh toan mot phan'),
('HD017','KH003','VIP09','MT01','11/20/2015 12:15', '11/20/2015 14:20', 'Da thanh toan'),
('HD018','KH001','P10','MT01','4/12/2015 14:45', '4/12/2015 16:45', 'Da thanh toan'),
('HD019','KH002','VIP09','MT03','11/12/2015 22:12', '11/13/2015 2:0', 'Da thanh toan'),
('HD020','KH004','VIP09','MT03','2/25/2014 1:15', '2/25/2014 4:15', 'Chua thanh toan')
 
 INSERT INTO CHITIET_SUDUNGDV VALUES
 ('HD001','DV01','5'),
 ('HD002','DV01','8'),
 ('HD002','DV02','5'),
 ('HD002','DV03','2'),
 ('HD003','DV04','1'),
 ('HD003','DV05','6'),
 ('HD004','DV01','5'),
 ('HD005','DV02','3'),
 ('HD005','DV03','10'),
 ('HD005','DV04','2'),
 ('HD006','DV01','5'),
 ('HD007','DV03','8'),
 ('HD007','DV04','10'),
 ('HD007','DV05','4'),
 ('HD013','DV02','9'),
 ('HD011','DV02','8')
SELECT * FROM DICHVU

 SELECT * FROM MUCTIENGIO
 
 SELECT * FROM PHONG
  SELECT * FROM KHACHHANG
 SELECT * FROM HOADON
 SELECT * FROM CHITIET_SUDUNGDV

 /*Câu 3:Liệt kê những phòng karaoke chứa được số lượng tối đa dưới 20 khách */

 SELECT * FROM PHONG 
 WHERE SoKhachToiDa <20 ;
 
 /*Câu 4: Liệt kê thông tin của các dịch vụ có đơn vị tính là "Chai" với đơn giá nhỏ hơn 20.000 VNĐ 
 và các dịch vụ có đơn vị tính là "Lon" với đơn giá lớn hơn 30.000 VNĐ */

      SELECT * FROM DICHVU 
      WHERE (Donvitinh = 'Chai' AND DonGia < '20000') 
        OR (Donvitinh = 'Lon' AND DonGia > '30000') ;

/* Câu 5: Liệt kê thông tin của các phòng karaoke có mã phòng bắt đầu bằng cụm từ"VIP" */

SELECT * FROM PHONG  WHERE MaPhong LIKE'VIP%';

 /*Câu 6:Liệt kê thông tin của toàn bộ các dịch vụ, yêu cầu sắp xếp giảm dần theo đơn giá */

 SELECT * FROM DICHVU ORDER BY DonGia desc ;

/*Câu  7:Đếm  số hóa đơn có trạng  thái  là "Chưa thanh toán" và có thời gian bắt đầu sử dụng nằm trong ngày hiện tại */

SELECT TrangThaiHD, COUNT(MaHD) AS SoHD 
FROM HOADON 
WHERE TrangThaiHD ='Chua thanh toan' AND day(ThoiGianBatDauSD)=DAY(GETDATE())
GROUP BY TrangThaiHD;

/*Câu 8:Liệt kê địa chỉ của toàn bộ các khách hàng với yêu cầu mỗi địa chỉ được liệt kê một lần duy nhất */

 SELECT DISTINCT [DiaChi] FROM KHACHHANG;

/*Câu 9:Liệt kê MaHD,MaKH,TenKH,DiaChi,MaPhong,DonGia (Tiền giờ),ThoiGianBatDauSD,ThoiGianKetThucSD của tất cả 
các hóa đơn có trạng thái là "Đã thanh toán" */

SELECT hd.MaHD, hd.MaKH, kh.TenKH, kh.DiaChi,p.MaPhong,mtg.DonGia, ThoiGianBatDauSD,ThoiGianKetThucSD
FROM   HOADON hd JOIN KHACHHANG kh ON hd.MaKH = kh.MaKH 
JOIN PHONG p ON hd.MaPhong = p.MaPhong
JOIN MUCTIENGIO mtg ON hd.MaTienGio = mtg.MaTienGio
WHERE TrangThaiHD ='Da thanh toan ' 

/*Câu  10:Liệt kê MaKH,TenKH,DiaChi,MaHD,TrangThaiHD của tất cả các hóa đơn với yêu cầu những khách hàng chưa từng có 
một hóa đơn nào thì cũng liệt kê thông tin những khách hàng đó ra (0.5 điểm) */
			
SELECT kh.MaKH, kh.TenKH, kh.DiaChi, hd.MaHD, hd.TrangThaiHD
FROM KHACHHANG kh FULL OUTER JOIN HOADON hd ON kh.MaKH = hd.MaKH 

/*Câu 11:Liệt kê thông tin của các khách hàng đã từng sử dụng dịch vụ"Trái cây" hoặc từng sử dụng phòng karaoke
có mã phòng là "VIP07" (0.5 điểm) */

SELECT *FROM KHACHHANG WHERE MAKH IN
(SELECT MaKH FROM HOADON INNER JOIN CHITIET_SUDUNGDV ON HOADON.MaHD = CHITIET_SUDUNGDV.MaHD
     WHERE CHITIET_SUDUNGDV.MaDV='DV02' or MaPhong='VIP07')

/*Câu 12:Liệt kê thông tin của các khách hàng chưa từng sử dụng dịch vụ hát karaoke lần nào cả(0.5 điểm) */

SELECT * FROM KHACHHANG 
WHERE MaKH NOT IN(SELECT MaKH FROM HOADON)

/*Câu 13:Liệt kê thông tin của các khách hàng đã từng sử dụng dịch vụ hát karaoke và chưa từng sử dụng dịch vụ nào khác kèm theo */

SELECT * FROM KHACHHANG 
WHERE MaKH NOT IN 
        (SELECT KHACHHANG.MaKH FROM KHACHHANG  
                JOIN HOADON ON HOADON.MaKH = KHACHHANG.MaKH 
                JOIN CHITIET_SUDUNGDV ON CHITIET_SUDUNGDV.MaHD = HOADON.MaHD ) 
				AND MaKH  IN(SELECT MaKH FROM HOADON)

/*Câu 14:Liệt kê thông tin của những khách hàng đã từng hát karaoke vào năm "2014" nhưng chưa từng hát karaoke vào năm "2015" */

SELECT * FROM KHACHHANG
WHERE MaKH IN
    (SELECT MaKH FROM HOADON 
     WHERE YEAR(ThoiGianBatDauSD)=2014 
         AND MaKH NOT IN(SELECT MaKH FROM HOADON 
                WHERE YEAR(ThoiGianBatDauSD)=2015))
/*Câu 15:Hiển thị thông tin của những khách hàng có số lần hát karaoke nhiều nhất tính từ đầu năm 2014 đến hết năm 2014 */

SELECT * FROM dbo.KHACHHANG 
WHERE MaKH IN(SELECT TOP 1 MaKH FROM HOADON 
              WHERE YEAR(ThoiGianBatDauSD)=2014 AND YEAR(ThoiGianKetThucSD)=2014
			  GROUP BY MaKH ORDER BY MaKH) 

/*Câu  16:Đếm tổng số lượng loại dịch vụ đã được sử dụng trong năm 2014 với  yêu cầu chỉ thực hiện tính đối với 
những loại dịch vụ có đơn giá từ 50.000 VNĐ trở lên (0.5 điểm)*/

SELECT Sum(SoLuong) AS SoLuong FROM HOADON,CHITIET_SUDUNGDV,DICHVU
WHERE YEAR(ThoiGianBatDauSD)=2014 
and CHITIET_SUDUNGDV.MaHD=HOADON.MaHD 
and CHITIET_SUDUNGDV.MaDV=DICHVU.MaDV
and DonGia>50000
select * from CHITIET_SUDUNGDV

/*Câu  17:Liệt kê MaKH, TenKH, MaSoThue của khách hàng có địa  chỉ là "Hải  Châu" và chỉ mới hát karaoke một lần duy nhất,
kết quả được sắp xếp giảm dần theo TenKH(0.5 điểm) */

SELECT MaKH,TenKH,MaSoThue FROM KHACHHANG 
WHERE DiaChi='Hai Chau' AND MaKH IN
               ( SELECT MaKH FROM HOADON GROUP BY MaKH HAVING count(MaKH)=1)ORDER BY TenKH DESC



SELECT hd.MaHD, hd.MaKH, kh.TenKH, kh.DiaChi,p.MaPhong,mtg.DonGia, ThoiGianBatDauSD,ThoiGianKetThucSD
FROM   HOADON hd JOIN KHACHHANG kh ON hd.MaKH = kh.MaKH 
JOIN PHONG p ON hd.MaPhong = p.MaPhong
JOIN MUCTIENGIO mtg ON hd.MaTienGio = mtg.MaTienGio
WHERE TrangThaiHD ='Da thanh toan ' 

--1. tạo bảng kết quả gồm các cột MaHD, TenKH và Soluongdichvusudung,Tổng số lượng dịch vụ sử dụng sắp xếp giảm dần theo bảng hóa đơn
SELECT hd.MaHD, kh.TenKH,count(ct.MaDV) AS SoluongDVSD, sum(Soluong) AS TongsoluongDVSD
FROM CHITIET_SUDUNGDV ct JOIN HOADON hd ON  ct.MaHD = hd.MaHD
JOIN  KHACHHANG kh ON kh.MaKH=hd.MaKH
GROUP BY hd.MaHD,kh.TenKH
--having COUNT(ct.MaDV)>3
ORDER BY hd.MaHD DESC


select*from CHITIET_SUDUNGDV


--2. liệt kê MaKH,TenKH, số lần hát karaoke với yêu cầu khách hàng chưa từng sử dụng cũng được liệt kê
SELECT kh.MaKH,kh.TenKH,COUNT(MaHD)AS Soluonghatkaraoke
FROM KHACHHANG kh LEFT JOIN HOADON hd ON hd.MaKH= kh.MaKH
GROUP BY kh.MaKH, kh.TenKH


--3. cho biết các MaHD mà có số lượng dv là cao nhất và cao nhì
select  top 2 SoLuong,MaHD from CHITIET_SUDUNGDV
order by SoLuong desc









/*Câu 18:Cập nhật cột TrangThaiHD trong bảng HOADON thành giá trị "Đã hết hạn" đối với những  khách  hàng  có  địa  chỉ là
"Hải  Châu" và có ThoiGianKetThucSD trước ngày31/12/2015 (0.5 điểm) */

UPDATE HOADON SET TrangThaiHD = 'Da het han'
WHERE MaKH IN(select MaKH from KHACHHANG where DiaChi='Hai Chau' and ThoiGianKetThucSD < 12/31/2015)

SELECT *FROM KHACHHANG
SELECT *FROM HOADON
/*Câu  19:Cập nhật cột MoTa trong bảng PHONG thành giá trị "Được sử dụng nhiều" cho những phòng được sử dụng từ 5 lần trở lên
trong tháng 5 năm 2015(0.5 điểm) */
update PHONG set MoTa='Duoc su dung nhieu' where MaPhong in 
(select MaPhong from HOADON where year(hoadon.ThoiGianBatDauSD)=2015
and month(HOADON.ThoiGianBatDauSD)=5)
SELECT*FROM PHONG
/*Câu 20:Xóa những hóa đơn có ThoiGianBatDauSDtrước ngày20/11/2015 (0.5 điểm) */
delete HOADON where ThoiGianBatDauSD<20/11/2015
select*from HOADON