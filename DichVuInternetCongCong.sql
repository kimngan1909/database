create database ONTAP4

create table May
(
MaMay varchar(10) primary key,
ViTri varchar(20) not null,
TrangThai varchar(20) not null
)
create table KhachHang
(
MaKH varchar(10) primary key,
TenKH varchar(20) not null,
DiaChi varchar(20) not null,
SoDienThoai varchar(20) not null
)
create table SuDungDichVu
(
MaKH varchar(10) not null,
MaDV varchar(10) not null,
NgaySuDung date not null,
GioSuDung time not null,
SoLuong int not null,
primary key(MaKH,MaDV,NgaySuDung,GioSuDung)
)
create table DichVu
(
MaDV varchar(10) primary key,
TenDV varchar(20) not null,
DonViTinh varchar(20) not null,
DonGia int not null
)
create table SuDungMay
(
MaKH varchar(10) not null,
MaMay varchar(10) not null,
NgayBatDauSuDung date not null,
GioBatDauSuDung time not null,
ThoiGianSuDung int not null,
primary key (MaKH,MaMay,NgayBatDauSuDung,GioBatDauSuDung)
)
alter table SuDungMay
add foreign key (MaMay) references dbo.May(MaMay) on delete cascade on update no action
alter table SuDungMay
add foreign key (MaKH) references dbo.KhachHang(MaKH) on delete cascade on update no action
alter table SuDungDichVu
add foreign key (MaKH) references dbo.KhachHang(MaKH) on delete cascade on update no action
alter table SuDungDichVu
add foreign key (MaDV) references dbo.DichVu(MaDV) on delete cascade on update no action
insert into May values
	('M01',	'Trai1',	'Chua su dung'),		
	('M02',	'Trai2',	'Dang su dung'),		
	('M03',	'Phai1',	'Bi hong')		
insert into KhachHang values									
	('KH001',	'Nguyen Van 1',	'Thanh Khe',	'0905778987	'),
	('KH002',	'Nguyen Van 2',	'Lien Chieu',	'0905778988'),	
	('KH003',	'Nguyen Van 3',	'Hai Chau',	'0905778989')	
insert into DichVu values
	
	('DV01',	'Nuoc suoi',	'Chai',	 10000), 	
	('DV02',	'Khan lanh',	'Cai',	 5000), 	
	('DV03',	'Ca phe',	'Ly',	 6000), 	
	('DV04',	'Dieu hoa',	'Gio',	 10000 )	
	
insert into SuDungDichVu values					
	('KH001',	'DV01',	'2015/01/15',	'17:20',	2)
insert into SuDungDichVu values		
	('KH001',	'DV02',	'2015/01/15',	'18:00',	1)
	select * from SuDungDichVu
insert into SuDungMay values					
	('KH001',	'M01',	'2015/01/15',	'16:00',	60)
insert into SuDungMay values	
	('KH001',	'M02',	'2015/01/15',	'20:00',	120)
	select * from SuDungMay

						
--Câu 1:	Liệt kê thông tin của toàn bộ khách hàng				
--Câu 2:	Xóa toàn bộ các máy có trạng thái là 'Bi Hong'				
--Câu 3:	Cập nhật giá trị của trường DiaChi trong bảng KHACHHANG thành 'Lien Chieu'				
	--đối với những bảng ghi có trường DiaChi mang giá trị là 'LC'				
--Câu 4:	Liệt kê những dịch vụ có đơn vị tính là Chai mà đơn giá dưới 10000 và những dịch vụ				
	-- có đơn vị tính là Ly mà đơn giá trên 20000				
--Câu 5:	Liệt kê những khách hàng có tên kết thúc bằng chuỗi ký tự 'NG'				
--Câu 6:	Liệt kê toàn bộ khách hàng, sắp xếp theo chiều giảm dần của TenKH và tăng dần của DiaChi				
--Câu 7:	Đếm số lượng khách hàng có địa chỉ là 'Thanh Khe'				
--Câu 8:	Liệt kê tên của toàn bộ khách hàng (tên nào giống nhau thì chỉ liệt kê một lần)				
--Câu 9:	Liệt kê MaKH, TenKH, MaMay, ViTri, NgayBatDauSuDung, GioBatDauSuDung, ThoiGianSuDung				
	--của tất cả các lần sử dụng máy				
--Câu 10:	Liệt kê MaKH, TenKH, MaMay, ViTri, ThoiGianSuDung của tất cả các lần sử dụng máy				
	--(nếu khách hàng chưa sử dụng máy lần nào thì vẫn phải liệt kê khách hàng đó ra)				
--Câu 11:	Liệt kê MaKH, TenKH của những khách hàng đã từng sử dụng máy hoặc đã từng sử dụng dịch vụ nào đó				
--Câu 12:	Liệt kê MaKH, TenKH của những khách hàng chưa từng sử dụng bất kỳ dịch vụ nào				
--Câu 13:	Liệt kê MaKH, TenKH của những khách hàng đã từng sử dụng máy và cũng đã từng sử dụng dịch vụ nào đó				
/*Câu 14:	Liệt kê MaKH, TenKH, MaMay, ViTri, NgayBatDauSuDung, GioBatDauSuDung, ThoiGianSuDung				
	của những khách hàng có địa chỉ ở 'Quang Nam' và chỉ mới sử dụng máy 1 lần duy nhất.				
	Kết quả liệt kê cần được sắp xếp theo chiều giảm dần của trường ThoiGianSuDung	*/			
					
