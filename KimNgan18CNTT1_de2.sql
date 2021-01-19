CREATE DATABASE KimNgan18CNTT1_de2

USE KimNgan18CNTT1_de2
CREATE TABLE KHACHHANG
(
  MaKH VARCHAR(20)PRIMARY KEY,
  HoTenKH VARCHAR(50)NOT NULL,
  DiaChiKH VARCHAR(50)NOT NULL,
  SoDienThoaiKH VARCHAR(20) NOT NULl
)

CREATE TABLE CAYCANH
(
MaCayCanh VARCHAR(20) PRIMARY KEY,
MoTa VARCHAR(50) NOT NULL,
MaLoaiCC VARCHAR(50) NOT NULL,
DonGiaChoThue INT NOT NULL
)
CREATE TABLE LOAICAYCANH
(
MaLoaiCC VARCHAR(50) PRIMARY KEY,
MoTaLoaiCC VARCHAR(50) NOT NULL
)
CREATE TABLE HOPDONGCHOTHUE
(
  MaHopDong VARCHAR(20) PRIMARY KEY,
  MaKH VARCHAR(20) FOREIGN KEY (MaKH) REFERENCES dbo.KHACHHANG(MaKH),
  SoTienDuocGiamGia INT NOT NULL,
  SoTienDatCoc INT NOT NULL,
  TrangThaiHopDong VARCHAR(50)
)

CREATE TABLE CHITIETHOPDONG
(
MaHopDong VARCHAR(20) NOT NULL, 
MaCayCanh VARCHAR(20) NOT NULL,
PRIMARY KEY (MaHopDong, MaCayCanh),
SoLuong INT NOT NULL,
MaLoaiDV VARCHAR(20) NOT NULL,
NgayBatDauChoThue DATE,
NgayKetThucChoThue DATE NOT NULL
)
CREATE TABLE LOAIDICHVU
(
MaLoaiDV VARCHAR(20) PRIMARY KEY,
MoTaLoaiDV VARCHAR(50) NOT NULL
)
ALTER TABLE  CHITIETHOPDONG
ADD FOREIGN KEY (MaHopDong) REFERENCES dbo.HOPDONGCHOTHUE(MaHopDong)
ALTER TABLE  CHITIETHOPDONG
ADD FOREIGN KEY (MaCayCanh) REFERENCES dbo.CAYCANH(MaCayCanh)
ALTER TABLE CHITIETHOPDONG
ADD FOREIGN KEY (MaLoaiDV) REFERENCES dbo.LOAIDICHVU(MaLoaiDV)
ALTER TABLE CAYCANH
ADD FOREIGN KEY (MaLoaiCC) REFERENCES dbo.LOAICAYCANH(MaLoaiCC)

INSERT INTO KHACHHANG 
    VALUES
      ('KH0001', 'Bui A', 'Lien Chieu', '09012345' ),
      ('KH0002', 'Bui B', 'Thanh Khe', '09112345'),
      ('KH0003', 'Nguyen A', 'Lien Chieu', '09112346'),
      ('KH0004', 'Nguyen B', 'Thanh Khe', '09012346'),
      ('KH0005', 'Bui A', 'Hai Chau', '09012347'),
      ('KH0006', 'Nguyen B', 'Hai Chau', '09112347')

 INSERT INTO LOAICAYCANH 
    VALUES
      ('LCC01', 'Chung o phong khach'),
      ('LCC02','Chung o cau thang'),
      ('LCC03', 'Chung o ngoai san')

INSERT INTO CAYCANH VALUES
      ('CC001', 'Hoa hong', 'LCC01', '10000')
INSERT INTO CAYCANH VALUES
      ('CC002', 'Mai tu quy', 'LCC01', '20000')
INSERT INTO CAYCANH VALUES
      ( 'CC003', 'Hoa anh dao', 'LCC01', '60000')
INSERT INTO CAYCANH VALUES
      ( 'CC004', 'Bonsai', 'LCC03', '100000')
INSERT INTO CAYCANH VALUES
      ( 'CC005', 'Hong tieu muoi','LCC02',  '70000' )

 
INSERT INTO HOPDONGCHOTHUE 
    VALUES
      ('HD0001','KH0002','0','1000000', 'Da ket thuc'),
      ('HD0002','KH0002','0','0', NULL),
      ('HD0003','KH0001','0','0', 'Da ket thuc'),
      ('HD0004', 'KH0005', '0', '0', 'Dang cho thue'),
      ('HD0005', 'KH0004', '0', '0', 'Dang cho thue'),
      ('HD0006','KH0004', '0','0', 'Chua bat dau'),
      ('HD0007','KH0002', '0','0','Da ket thuc'),
      ('HD0008','KH0004','0','0',NULL)
  

INSERT INTO LOAIDICHVU 
   VALUES
      ('L01', 'Chung Tet'),
      ('L02', 'Chung nha moi') 


INSERT INTO CHITIETHOPDONG VALUES
      ('HD0001', 'CC003', '100', 'L01', '7/3/2016', '7/3/2016')
INSERT INTO CHITIETHOPDONG VALUES
      ('HD0002', 'CC001', '150', 'L01', '10/11/2015', '10/22/2015')
INSERT INTO CHITIETHOPDONG VALUES
      ('HD0003', 'CC004', '20', 'L01', '12/23/2017', '12/30/2017')
INSERT INTO CHITIETHOPDONG VALUES
      ('HD0004', 'CC002', '5', 'L01', '1/1/2014', '1/10/2014')
INSERT INTO CHITIETHOPDONG VALUES
      ('HD0005', 'CC005', '10', 'L01', '10/16/2016', '10/18/2016')
INSERT INTO CHITIETHOPDONG VALUES
      ('HD0006', 'CC001', '300', 'L01', '12/11/2017', '12/22/2017')
INSERT INTO CHITIETHOPDONG VALUES
      ('HD0007', 'CC004', '5', 'L01', '2/1/2016', '2/10/2016')
INSERT INTO CHITIETHOPDONG VALUES
      ('HD0007', 'CC001', '15', 'L01', '2/10/2016', '2/12/2016')
	  select *from CHITIETHOPDONG
	  

--Câu 3: Liệt kê những cây cảnh có DonGiaChoThue nhỏ hơn 50000 VND. (0.5 điểm) 
 
 SELECT *FROM CAYCANH
   WHERE Dongiachothue < 50000

/* Câu 4: Liệt kê những khách hàng có địa chỉ ở 'Lien Chieu' mà có 
số điện thoại bắt đầu bằng '090' và những khách hàng có địa chỉ ở 'Thanh Khe'
mà có số điện thoại bắt đầu bằng '091'. (0.5 điểm) */
 
 SELECT * FROM KHACHHANG 
   WHERE (DiaChiKH ='Lien Chieu' AND SoDienThoaiKH LIKE'090%')
     OR  (DiaChiKH ='Thanh Khe' AND SoDienThoaiKH LIKE '091%')
	 
--Câu 5: Liệt kê thông tin của các khách hàng có họ (trong họ tên) là 'Bui'. (0.5 điểm) 
 
 SELECT * FROM KHACHHANG
   WHERE HoTenKH LIKE'Bui%'

/*Câu 6: Liệt kê thông tin của toàn bộ các cây cảnh, yêu cầu 
sắp xếp giảm dần theo MoTa và giảm dần theo DonGiaChoThue. (0.5 điểm)*/ 
 
 SELECT * FROM CAYCANH ORDER BY MoTa , DonGiaChoThue DESC 

/* Câu 7: Liệt kê các hợp đồng cho thuê có trạng thái là 'Da ket thuc'
hoặc chưa xác định (có giá trị là NULL). (0.5 điểm) */
 
 SELECT * FROM HOPDONGCHOTHUE
   WHERE TrangThaiHopDong ='Da ket thuc' OR TrangThaiHopDong IS NULL;

/* Câu 8: Liệt kê họ tên của toàn bộ khách hàng với yêu cầu mỗi
họ tên chỉ được liệt kê một lần duy nhất. (0.5 điểm) */
 
 SELECT DISTINCT [HoTenKH] FROM KHACHHANG;

/* Câu 9: Liệt kê MaHopDong, MaKH, TrangThaiHopDong, MaCayCanh, SoLuong 
của tất cả các hợp đồng có trạng thái là 'Dang cho thue'. (0.5 điểm) */
 
 SELECT h.MaHopDong, h.MaKH, h.TrangThaiHopDong, ct.MaCayCanh, ct.SoLuong 
    FROM HOPDONGCHOTHUE h JOIN CHITIETHOPDONG ct ON h.MaHopDong = ct.MaHopDong
	WHERE TrangThaiHopDong = 'Dang cho thue'

/* Câu 10: Liệt kê MaHopDong, MaKH, TrangThaiHopDong, MaCayCanh, SoLuong
của tất cả các hợp đồng với yêu cầu những hợp đồng nào chưa có một chi tiết 
hợp đồng nào thì cũng phải liệt kê thông tin những hợp đồng đó ra. (0.5 điểm) */
 
 SELECT h.MaHopDong, h.MaKH, h.TrangThaiHopDong, ct.MaCayCanh, ct.SoLuong
    FROM HOPDONGCHOTHUE h FULL JOIN CHITIETHOPDONG ct ON h.MaHopDong = ct.MaHopDong

/* Câu 11: Liệt kê thông tin của các khách hàng ở địa chỉ là 'Hai Chau'
đã từng thuê cây cảnh thuộc loại cây cảnh có mô tả là 'Chung o phong khach'
hoặc các khách hàng từng thuê cây cảnh với thời gian bắt đầu thuê là '11/12/2017'. (0.5 điểm) */
 
 SELECT * FROM KHACHHANG 
 WHERE MaKH IN
 (select MaKH from CHITIETHOPDONG INNER JOIN CAYCANH ON CHITIETHOPDONG.MaCayCanh = CAYCANH.MaCayCanh
 JOIN HOPDONGCHOTHUE ON HOPDONGCHOTHUE.MaHopDong=CHITIETHOPDONG.MaHopDong
  WHERE KHACHHANG.DiaChiKH='Hai Chau'
  AND CAYCANH.MaLoaiCC ='LCC01'
  OR KHACHHANG.DiaChiKH='Hai Chau' AND day(NgayBatDauChoThue) >= 2017/12/11 )
	
--Câu 12: Liệt kê thông tin của các khách hàng chưa từng thuê cây cảnh một lần nào cả. (0.5 điểm) 
 
 SELECT * FROM KHACHHANG
 WHERE MaKH NOT IN(SELECT MaKH FROM HOPDONGCHOTHUE)
 
/* Câu 13: Liệt kê thông tin của các khách hàng đã từng thuê loại cây cảnh được 
mô tả là 'Chung o phong khach' và đã từng thuê cây cảnh vào tháng 12 năm 2017 
(gợi ý: dựa theo ngày bắt đầu thuê). (0.5 điểm) */

SELECT * FROM KHACHHANG
 WHERE MaKH IN
 (select MaKH from CHITIETHOPDONG INNER JOIN CAYCANH ON CHITIETHOPDONG.MaCayCanh = CAYCANH.MaCayCanh
 JOIN HOPDONGCHOTHUE ON HOPDONGCHOTHUE.MaHopDong=CHITIETHOPDONG.MaHopDong
 WHERE CAYCANH.MaLoaiCC='LCC01'
 AND CHITIETHOPDONG.NgayBatDauChoThue >= '2017-12-1')
 
/* Câu 14: Liệt kê thông tin của những khách hàng đã từng thuê cây cảnh vào năm 2016 
nhưng chưa từng thuê vào năm 2017 (gợi ý: dựa theo ngày bắt đầu thuê). (0.5 điểm) */
 
 SELECT * FROM KHACHHANG
 WHERE MaKH IN
 (SELECT MaKH FROM CHITIETHOPDONG INNER JOIN HOPDONGCHOTHUE ON CHITIETHOPDONG.MaHopDong = HOPDONGCHOTHUE.MaHopDong
 WHERE YEAR(CHITIETHOPDONG.NgayBatDauChoThue) = 2016
 AND MaKH NOT IN(SELECT MaKH FROM CHITIETHOPDONG INNER JOIN HOPDONGCHOTHUE ON CHITIETHOPDONG.MaHopDong = HOPDONGCHOTHUE.MaHopDong
 WHERE YEAR(CHITIETHOPDONG.NgayBatDauChoThue) = 2017))

/* Câu 15: Hiển thị MaCayCanh, MaLoaiCC của những cây cảnh từng được thuê với số lượng lớn hơn 10 
trong một hợp đồng bất kỳ nào đó. Kết quả hiển thị cần được xóa bớt dữ liệu bị trùng lặp. (0.5 điểm) */
 
 SELECT DISTINCT CAYCANH.MaCayCanh, CAYCANH.MaLoaiCC 
 FROM CAYCANH JOIN CHITIETHOPDONG ON CHITIETHOPDONG.MaCayCanh = CAYCANH.MaCayCanh
 WHERE SoLuong > 10

/* Câu 16: Đếm tổng số khách hàng đã thuê cây cảnh trong năm 2016 với yêu cầu chỉ thực hiện tính đối với 
những khách hàng đã từng thuê ít nhất 2 lần (có từ 2 hợp đồng khác nhau với công ty trở lên) vào năm 2016. (0.5 điểm) */
 
 SELECT DISTINCT COUNT(MaKH) AS Số_khách_hàng FROM HOPDONGCHOTHUE
 WHERE MaKH IN
 (SELECT MaKH  FROM HOPDONGCHOTHUE h JOIN CHITIETHOPDONG c
 ON h.MaHopDong = c.MaHopDong
 WHERE YEAR(c.NgayBatDauChoThue) = 2016 
 GROUP BY h.MaKH
 HAVING COUNT(h.MaHopDong) >= 2)
 GROUP BY MaHopDong

/* Câu 17: Liệt kê những khách hàng chỉ mới thuê 1 lần duy nhất (chỉ có 1 hợp đồng duy nhất với công ty) 
và chỉ thuê 1 nhóm cây cảnh duy nhất trong năm 2017, kết quả được sắp xếp giảm dần theo MaKhachHang. (0.5 điểm)*/ 
 
 SELECT h.MaKH FROM HOPDONGCHOTHUE h JOIN CHITIETHOPDONG c ON h.MaHopDong = c.MaHopDong
 WHERE YEAR(c.NgayBatDauChoThue) = 2017
 GROUP BY h.MaKH, c.MaCayCanh
 HAVING COUNT(h.MaKH) = 1 
 ORDER BY h.MaKH DESC
/* Câu 18: Cập nhật cột TrangThaiHopDong trong bảng HOPDONGCHOTHUE thành giá trị 'Bi huy' 
đối với những hợp đồng có TrangThaiHopDong là 'Chua bat dau' và có SoTienDatCoc là 0 VND. (0.5 điểm) */
 
 UPDATE HOPDONGCHOTHUE 
 SET TrangThaiHopDong = 'Bi huy' 
 WHERE TrangThaiHopDong = 'Chua bat dau' AND SoTienDatCoc = '0';

 SELECT * FROM HOPDONGCHOTHUE
/* Câu 19: Cập nhật cột NgayKetThucChoThue trong bảng CHITIETHOPDONG thành NULL 
cho những cây cảnh đã từng được cho thuê từ 2 lần trở lên. (0.5 điểm) */
 
 UPDATE CHITIETHOPDONG SET NgayBatDauChoThue = NULL
 WHERE MaCayCanh IN
( SELECT MaCayCanh FROM CHITIETHOPDONG
 GROUP BY MaCayCanh
 HAVING COUNT(MaCayCanh) >= 2)

 SELECT * FROM CHITIETHOPDONG
 
-- Câu 20: Xóa những loại dịch vụ chưa từng được sử dụng trong bất kỳ một hợp đồng nào. (0.5 điểm) 
 DELETE FROM LOAIDICHVU WHERE MaLoaiDV NOT IN(SELECT MaLoaiDV FROM CHITIETHOPDONG)

 SELECT * FROM LOAIDICHVU

--1. Cho biết ba loại cây cảnh được thuê nhiều nhất và ít nhất gồm hai cột Loại cây cảnh, số lần thuê

SELECT TOP 3 MoTa,COUNT(CHITIETHOPDONG.MaCayCanh) AS SoLanThue 
FROM dbo.CHITIETHOPDONG JOIN dbo.CAYCANH ON CAYCANH.MaCayCanh = CHITIETHOPDONG.MaCayCanh
GROUP BY CHITIETHOPDONG.MaCayCanh,mota
ORDER BY COUNT(CHITIETHOPDONG.MaCayCanh) DESC
SELECT TOP 3 MoTa,COUNT(CHITIETHOPDONG.MaCayCanh) AS SoLanThue
FROM dbo.CHITIETHOPDONG JOIN dbo.CAYCANH ON CAYCANH.MaCayCanh = CHITIETHOPDONG.MaCayCanh 
GROUP BY CHITIETHOPDONG.MaCayCanh,mota 
ORDER BY COUNT(CHITIETHOPDONG.MaCayCanh)
              


--2.Với các hợp đồng cho thuê có trạng thái đã kết thúc, tính tống số tiền phải trả của mỗi hợp đồng theo công thức: Tổng số tiền bằng số lượng cây thuê * đơn giá thuê (theo ngày) * số ngày thuê -số tiền được giảm - số tiền đặt cọc.
SELECT CHITIETHOPDONG.MaHopDong,
SUM(SoLuong*DonGiaChoThue*(DAY(NgayKetThucChoThue)-DAY(NgayBatDauChoThue))-SoTienDuocGiamGia-SoTienDatCoc) AS Sotienphaitra 
FROM dbo.CHITIETHOPDONG JOIN dbo.HOPDONGCHOTHUE ON HOPDONGCHOTHUE.MaHopDong = CHITIETHOPDONG.MaHopDong
JOIN dbo.CAYCANH ON CAYCANH.MaCayCanh = CHITIETHOPDONG.MaCayCanh 
WHERE TrangThaiHopDong='Da ket thuc' 
GROUP BY CHITIETHOPDONG.MaHopDong
--3.Cho biết hợp đồng nào thuê cây với thời gian dài nhất?
SELECT TOP 1 * FROM CHITIETHOPDONG 
ORDER BY DAY(NgayKetThucChoThue)-DAY(NgayBatDauChoThue) DESC
--4.Thống kê số lượng cây thuê của mỗi loại dịch vụ, loại dịch vụ không thuê cây nào cũng phải được liệt kê
SELECT LOAIDICHVU.MaLoaiDV,SUM(SoLuong) AS SoLuong 
FROM CHITIETHOPDONG FULL OUTER JOIN LOAIDICHVU ON LOAIDICHVU.MaLoaiDV = CHITIETHOPDONG.MaLoaiDV 
GROUP BY LOAIDICHVU.MaLoaiDV

	
	