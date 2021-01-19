create database NhatKyBanHang
CREATE TABLE mathang
(
mahang NVARCHAR(5) PRIMARY KEY, /*mã hàng*/
tenhang NVARCHAR(50) NOT NULL, /*tên hàng*/
soluong INT, /*số lượng hàng hiện có*/
) 
CREATE TABLE nhatkybanhang
(
stt INT IDENTITY PRIMARY KEY,
 ngay DATETIME, /*ngày bán hàng*/ 
 nguoimua NVARCHAR(30), /*tên người mua hàng*/
 mahang NVARCHAR(5) /*mã mặt hàng được bán*/
 FOREIGN KEY REFERENCES mathang(mahang),
 soluong INT, /*giá bán hàng*/
 giaban MONEY /*số lượng hàng được bán*/
) 


insert into mathang values
('H1',N'Xà phòng','30'),
('H2',N'Kem đánh ren','45')


go
-- Ví dụ 5.12
CREATE TRIGGER trg_nhatkybanhang_insert
ON nhatkybanhang
FOR INSERT
AS
 UPDATE mathang
 SET mathang.soluong=mathang.soluong-inserted.soluong
 FROM mathang INNER JOIN inserted
 ON mathang.mahang=inserted.mahang

 INSERT INTO nhatkybanhang
 (ngay,nguoimua,mahang,soluong,giaban)
VALUES('5/5/2004','Tran Ngoc Thanh','H1',10,5200) 
select * from mathang
select * from nhatkybanhang

--Ví dụ 5.13:
/*Xét lại ví dụ với hai bảng MATHANG và NHATKYBANHANG, trigger
dưới đây được kích hoạt khi ta tiến hành cập nhật cột SOLUONG cho một bản ghi của
bảng NHATKYBANHANG (lưu ý là chỉ cập nhật đúng một bản ghi)*/
go
CREATE TRIGGER trg_nhatkybanhang_update_soluong
ON nhatkybanhang
FOR UPDATE
AS
IF UPDATE(soluong)
 UPDATE mathang
 SET mathang.soluong = mathang.soluong - (inserted.soluong-deleted.soluong)
 FROM (deleted INNER JOIN inserted ON
 deleted.stt = inserted.stt) INNER JOIN mathang
 ON mathang.mahang = deleted.mahang 

 -- được kích hoạt
 UPDATE nhatkybanhang
SET soluong=soluong+20
WHERE stt=1 

-- không được kích hoạt
UPDATE nhatkybanhang
SET nguoimua='Mai Hữu Toàn'
WHERE stt=3 
select * from nhatkybanhang

-- Ví dụ 5.15:
go
CREATE TRIGGER trg_mathang_delete
ON mathang
FOR DELETE
AS
 ROLLBACK TRANSACTION

--Thì câu lệnh DELETE sẽ không thể có tác dụng đối với bảng MATHANG. Hay nói cách khác, ta không thể xoá được dữ liệu trong bảng. 
 delete from mathang -->không xóa được bảng mathang

 -- ví dụ 5.16:
 /*Trigger dưới đây được kích hoạt khi câu lệnh INSERT được sử dụng để bổ
sung một bản ghi mới cho bảng NHATKYBANHANG. Trong trigger này kiểm tra
điều kiện hợp lệ của dữ liệu là số lượng hàng bán ra phải nhỏ hơn hoặc bằng số lượng
hàng hiện có. Nếu điều kiện này không thoả mãn thì huỷ bỏ thao tác bổ sung dữ liệu. */
go

CREATE TRIGGER trg_nhatkybanhang_insert1
ON NHATKYBANHANG
FOR INSERT
AS
 DECLARE @sl_co int /* Số lượng hàng hiện có */
 DECLARE @sl_ban int /* Số lượng hàng được bán */
 DECLARE @mahang nvarchar(5) /* Mã hàng được bán */
 SELECT @mahang=mahang,@sl_ban=soluong
 FROM inserted
 SELECT @sl_co = soluong
 FROM mathang where mahang=@mahang
 /*Nếu số lượng hàng hiện có nhỏ hơn số lượng bán
 thì huỷ bỏ thao tác bổ sung dữ liệu */ 
 IF @sl_co<@sl_ban
 ROLLBACK TRANSACTION
 /* Nếu dữ liệu hợp lệ
 thì giảm số lượng hàng hiện có */
 ELSE
 UPDATE mathang
 SET soluong=soluong-@sl_ban
 WHERE mahang=@mahang 


 insert into nhatkybanhang values ('5/15/2005','Nguyen Kim Ngan','H1',10,5200) 
 -- không insert được,, vì soluong.nhatkybanhang > số lượng còn lại của mặt hàng H1=0
 insert into nhatkybanhang values ('5/15/2005','Nguyen Kim Ngan','H2',10,5200) 
 -- lệnh insert được thực hiện, soluowng.nhatkybanhang < số lượng còn lại của mặt hàng H2 = 45

 select * from nhatkybanhang
 select * from mathang

 -------------------------------------------------

 -- Ví dụ 5.17: xét lại trường hợp của mặt hàng và nhật ký bán hàng.
 
insert into mathang values
('H1',N'Xà phòng','30'),
('H2',N'Kem đánh ren','45')


 insert into nhatkybanhang (ngay,nguoimua,mahang,soluong,giaban)
values
('1-1-2004','Ha','H1',10,10000),
('2-2-2004','Phong','H2',20,5000),
('3-3-2004','Thuy','H2',30,6000)
select * from nhatkybanhang
select * from mathang
go
 /*Trigger dưới đây cập nhật lại số lượng hàng của bảng MATHANG khi câu lệnh
UPDATE được sử dụng để cập nhật cột SOLUONG của bảng NHATKYBANHANG.*/
CREATE TRIGGER trg_nhatkybanhang_update_soluong
ON nhatkybanhang
FOR UPDATE
AS
IF UPDATE(soluong)
 UPDATE mathang
 SET mathang.soluong = mathang.soluong -
 (inserted.soluong-deleted.soluong)
 FROM (deleted INNER JOIN inserted ON
 deleted.stt = inserted.stt) INNER JOIN mathang
 ON mathang.mahang = deleted.mahang
/*Với trigger được định nghĩa như trên, nếu thực hiện câu lệnh:*/
UPDATE nhatkybanhang
SET soluong = soluong + 10
WHERE stt = 1 
--> soluong.nhatkybanhang.h1 = 20
UPDATE nhatkybanhang
 SET soluong=soluong + 5
 WHERE mahang='H2' 

 select * from mathang
 select * from nhatkybanhang
-->soluong.nhatkybanhang.h2 = 25
-->soluong.nhatkybanhang.h2 = 35

/*Ta có thể nhận thấy số lượng của mặt hàng có mã H2 còn lại 40 (giảm đi 5) trong khi
đúng ra phải là 35 (tức là phải giảm 10). Như vậy, trigger ở trên không hoạt động đúng
trong trường hợp này.
Để khắc phục lỗi gặp phải như trên, ta định nghĩa lại trigger như sau: */

delete from mathang
delete from nhatkybanhang

go

CREATE TRIGGER trg_nhatkybanhang_update_soluong1
ON nhatkybanhang
FOR UPDATE
AS
IF UPDATE(soluong)
 UPDATE mathang
 SET mathang.soluong = mathang.soluong -
 (SELECT SUM(inserted.soluong-deleted.soluong)
 FROM inserted INNER JOIN deleted
 ON inserted.stt=deleted.stt
 WHERE inserted.mahang = mathang.mahang)
 WHERE mathang.mahang IN (SELECT mahang
 FROM inserted) 


 /*Với trigger được định nghĩa như trên, nếu thực hiện câu lệnh:*/
UPDATE nhatkybanhang
SET soluong = soluong + 10
WHERE stt = 1 
select * from mathang
select * from nhatkybanhang
--> soluong.nhatkybanhang.h1 = 20
UPDATE nhatkybanhang
 SET soluong=soluong + 5
 WHERE mahang='H2' 
 -->số lượng còn lại của mã hàng h2 là 35

 
 --hoặc
 go

 CREATE TRIGGER trg_nhatkybanhang_update_soluong
ON nhatkybanhang
FOR UPDATE
AS
IF UPDATE(soluong)
/* Nếu số lượng dòng được cập nhật bằng 1 */
 IF @@ROWCOUNT = 1
 BEGIN
 UPDATE mathang
 SET mathang.soluong = mathang.soluong -
 (inserted.soluong-deleted.soluong)
 FROM (deleted INNER JOIN inserted ON
 deleted.stt = inserted.stt) INNER JOIN mathang
 ON mathang.mahang = deleted.mahang 
 END
 ELSE
 BEGIN
 UPDATE mathang
 SET mathang.soluong = mathang.soluong -
 (SELECT SUM(inserted.soluong-deleted.soluong)
 FROM inserted INNER JOIN deleted
 ON inserted.stt=deleted.stt
 WHERE inserted.mahang = mathang.mahang)
 WHERE mathang.mahang IN (SELECT mahang
 FROM inserted)
 END 



 -- Sử dụng biến con trỏ:
-- Ví dụ 5.18: Tập các câu lệnh trong ví dụ dưới đây minh hoạ cách sử dụng biến con trỏ để duyệt qua các dòng trong kết quả của câu lệnh SELECT 

go
DECLARE contro CURSOR
 FOR SELECT mahang,tenhang,soluong FROM mathang
OPEN contro
DECLARE @mahang NVARCHAR(10)
DECLARE @tenhang NVARCHAR(10)
DECLARE @soluong INT
/*Bắt đầu duyệt qua các dòng trong kết quả truy vấn*/
FETCH NEXT FROM contro
 INTO @mahang,@tenhang,@soluong
WHILE @@FETCH_STATUS=0
 BEGIN
 PRINT 'Ma hang:'+@mahang
 PRINT 'Ten hang:'+@tenhang
 PRINT 'So luong:'+STR(@soluong)
FETCH NEXT FROM contro
 INTO @mahang,@tenhang,@soluong
 END
/*Đóng con trỏ và giải phóng vùng nhớ*/
CLOSE contro
DEALLOCATE contro 

go
--Ví dụ 5.19: Trigger dưới đây là một cách giải quyết khác của trường hợp được đề cập ở ví dụ 5.17
CREATE TRIGGER trg_nhatkybanhang_update_soluong2
ON nhatkybanhang
FOR UPDATE
AS
IF UPDATE(soluong)
BEGIN
DECLARE @mahang NVARCHAR(10)
DECLARE @soluong INT
DECLARE contro CURSOR FOR
 SELECT inserted.mahang,
 inserted.soluong-deleted.soluong AS soluong
 FROM inserted INNER JOIN deleted
 ON inserted.stt=deleted.stt
 OPEN contro 

 FETCH NEXT FROM contro INTO @mahang,@soluong
 WHILE @@FETCH_STATUS=0
 BEGIN
UPDATE mathang SET soluong=soluong-@soluong
 WHERE mahang=@mahang
FETCH NEXT FROM contro INTO @mahang,@soluong
 END
 CLOSE contro
 DEALLOCATE contro
END
