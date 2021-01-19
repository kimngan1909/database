create database kt
create table KhachHang 
(
makh varchar(20) primary key,
hoten nvarchar(50) not null,
diachi nvarchar(50) not null,
sodienthoai varchar(50) not null
)
create table LoaiXe
(
maloaixe varchar(20) primary key,
mota nvarchar(50) not null
)
create table XeChoThue
(
maxe varchar(20) primary key,
biensoxe varchar(50) not null,
hangxe nvarchar(50) not null,
maloaixe nvarchar(50) not null,
dongiachothue int not null
)
create table LoaiDichVu
(
maloaidichvu varchar(20) primary key,
mataloaidichvu nvarchar(50) 
)
create table HopDongChoThue
(
mahopdong varchar(20)  primary key,
makh varchar(20) foreign key (makh) references dbo.KhachHang(makh),
sotiendatcoc float not null,
trangthaihopdong nvarchar(50) not null
)
create table ChiTietHopDongChoThue
(
mahopdong varchar(20) ,
maxe varchar(20) foreign key (maxe) references dbo.XeChoThue(maxe),
maloaidichvu varchar(20) foreign key (maloaidichvu) references dbo.LoaiDichVu(maloaidichvu) on delete cascade,
ngaynhanxe date not null,
ngaytraxe date not null,
primary key(mahopdong, maxe)
)

insert into KhachHang values
('KH01',N'Đặng Hoài Sơn', N'Liên Chiểu','0905666666'),
('KH02',N'Đặng Ngọc Chi', N'Hải Châu','0905123456' ),
('KH03',N'Nguyễn Thị Kim Ngân',N'Hải Châu','0914987654'),
('KH04',N'Nguyễn Văn Anh', N'Sơn Trà','0914987691'),
('KH05',N'Nguyễn Trần Khánh Vân', N'Hòa Vang','0914987123')
 insert into LoaiXe values
 ('LX01',N'xe 4 chỗ'),
 ('LX02',N'xe 24 chỗ'),
 ('LX03',N'xe 16 chỗ'),
 ('LX04',N'xe 7 chỗ')
 insert into XeChoThue values
 ('MX01','43A-567.28','Kia','LX01','300000'),
 ('MX02','43D-129.98','Honda','LX02','500000'),
 ('MX03','43A-567.99','Toyota','LX01','400000'),
 ('MX04','43A-567.98','Kia','LX04','600000'),
 ('MX05','43A-567.19','Honda','LX01','800000')

 insert into LoaiDichVu values
 ('DV01',N'Đám cưới'),
 ('DV02',N'Du lịch')
 insert into HopDongChoThue values
 ('HD01','KH01','900000',N'Đã kết thúc'),
 ('HD02','KH04','200000',N'Đang cho thuê'),
 ('HD03','KH01','200000',N'Đã kết thúc'),
 ('HD04','KH03','500000',N'Đã kết thúc'),
 ('HD05','KH03','18990',N'Đã kết thúc'),
 ('HD06','KH02','1234560',N'Đã kết thúc'),
 ('HD07','KH01','100000',N'Chưa bắt đầu'),
 ('HD08','KH01','0',N'Chưa bắt đầu')
 insert into ChiTietHopDongChoThue values
 ('HD01','MX05','DV01','2018/06/13','2018/06/24'),
 ('HD02','MX01','DV02','2020/07/07','2020/07/12'),
 ('HD04','MX03','DV01','2020/07/08','2020/07/14'),
 ('HD05','MX05','DV02','2019/09/23','2019/09/25'),
 ('HD05','MX02','DV01','2018/02/01','2018/02/02'),
 ('HD07','MX04','DV02','2020/02/11','2020/02/12'),
 ('HD06','MX02','DV01','2020/01/21','2020/12/02'),
 ('HD08','MX03','DV02','2020/09/03','2020/10/02'),
 ('HD04','MX02','DV02','2020/09/19','2020/09/20'),
 ('HD01','MX01','DV02','2020/12/01','2020/12/02')
--Câu 3: Liệt kê những xe cho thuê gồm các thông tin về mã xe, biển số xe, hãng xe có đơn giá cho thuê nhỏ hơn 500.000 VND
			  select maxe,biensoxe,hangxe from XeChoThue
			  where dongiachothue < 500000
/* Câu 4: Liệt kê những khách hàng gồm thông tin mã khách hàng, họ và tên khách hàng có địa chỉ ở ‘Liên Chiểu’ 
			   mà có số điện thoại bắt đầu bằng ‘090’ và những khách hàng có địa chỉ ở ‘Hải Châu’ mà có số điện thoại bắt đầu bằng ‘091’.*/
			   select makh, hoten from KhachHang
			   where (diachi = N'Liên Chiểu' and sodienthoai LIKE '090%')
			   or (diachi = N'Hải Châu' and sodienthoai LIKE '091%')
-- Câu 5: Liệt kê thông tin của các khách hàng có họ (trong họ tên) là 'Đặng'
			   select * from KhachHang 
			   where hoten like N'Đặng%'

--Câu 6: Liệt kê thông tin mã xe, hãng xe của toàn bộ các xe được thuê một lần duy nhất.
              select x.maxe, x.hangxe from XeChoThue x join ChiTietHopDongChoThue c on x.maxe = c.maxe
              group by x.maxe, x.hangxe
              having count(c.maxe) = 1

-- Câu 7: Liệt kê các hợp đồng cho thuê gồm mã hợp đồng, số tiền đặt cọc có trạng thái hợp đồng là ‘Đã kết thúc’ của khách hàng có tên là ‘Chi’.
             select h.mahopdong, h.sotiendatcoc,h.trangthaihopdong 
			 from HopDongChoThue h join KhachHang k on k.makh = h.makh
             where h.trangthaihopdong =N'Đã kết thúc' and hoten =N'%Chi'
 -- Câu 8: Liệt kê thông tin của các khách hàng mà chưa có hợp đồng cho thuê nào
             select * from KhachHang 
			 where makh not in(select makh from HopDongChoThue )
 -- Câu 9: Cho biết những mã hợp đồng mà vừa sử dụng loại dịch vụ 'Đám cưới' vừa sử dụng loại dịch vụ 'Du lịch'
            select distinct  mahopdong from ChiTietHopDongChoThue
			where mahopdong in
			(select mahopdong from ChiTietHopDongChoThue join LoaiDichVu on LoaiDichVu.maloaidichvu = ChiTietHopDongChoThue.maloaidichvu
			where LoaiDichVu.mataloaidichvu = N'Đám cưới')
			and mahopdong  in 
		    (select mahopdong from ChiTietHopDongChoThue join LoaiDichVu on LoaiDichVu.maloaidichvu = ChiTietHopDongChoThue.maloaidichvu
			where LoaiDichVu.mataloaidichvu = N'Du lịch')
			 -------------------------------------



			 select mahopdong
             from ChiTietHopDongChoThue 
			 inner join LoaiDichVu on ChiTietHopDongChoThue.maloaidichvu = LoaiDichVu.maloaidichvu
             where LoaiDichVu.mataloaidichvu = N'Đám cưới' and LoaiDichVu.mataloaidichvu = N'Du Lịch'


			 select * from ChiTietHopDongChoThue
 /* Câu 10: Liệt kê họ tên, mã hợp đồng, trạng thái hợp đồng của tất cả các hợp đồng với yêu cầu những khách hàng chưa có một hợp đồng nào cũng
            phải liệt kê ra  Kết quả:hợp với tập các bản ghi của A không thoả mãn điều kiện nối kết hợp NULL cho các cột của B */

            select k.hoten,h.mahopdong, h.trangthaihopdong from KhachHang k 
			left join HopDongChoThue h on h.makh = k.makh

 /* Câu 11: Liệt kê không trùng lặp thông tin mã khách hàng, họ và tên khách hàng của các khách hàng có địa chỉ là ‘Hải Châu’ 
			đã từng thuê xê thuộc loại xe có mô tả là ‘Xe 24 chỗ’ hoặc các khách hàng 
			từng thuê xe có thời gian nhận xe là 07/07/2020. Sắp xếp tăng dần theo mã khách hàng và giảm dần theo họ và tên khách hàng.*/
			
			select distinct k.makh, k.hoten from KhachHang k join HopDongChoThue h on h.makh = k.makh
			join ChiTietHopDongChoThue c on c.mahopdong = h.mahopdong
			join XeChoThue x on x.maxe = c.maxe
			join LoaiXe lx on lx.maloaixe = lx.maloaixe
			where c.ngaynhanxe ='2020/07/07' or k.diachi =N'Hải Châu' and lx.mota = N'Xe 24 chỗ'
			order by k.makh asc , k.hoten desc 
			

		
/* Câu 12: Thống kê số lần được thuê của các xe mà xe đó có số ngày mượn lớn hơn 10 ngày gồm các thông tin mã xe, số lần thuê */
            
-- Câu 13: Cho biết có bao nhiêu xe đã được dùng để cho thuê trong tổng số xe
            select count(maloaixe) as số_xe_được_thuê from LoaiXe
-- Câu 14: Liệt kê thông tin của khách hàng đã từng thuê xe vào năm 2018 nhưng từng thuê vào năm 2019

			select distinct k.makh,k.hoten,k.diachi,k.sodienthoai from KhachHang k 
			join HopDongChoThue h on k.makh = h.makh
			join ChiTietHopDongChoThue c on c.mahopdong = h.mahopdong
			where c.mahopdong in
			(select mahopdong from ChiTietHopDongChoThue
			where YEAR(ngaynhanxe) = 2018)
			and c.mahopdong not in 
		    (select mahopdong from ChiTietHopDongChoThue
			where YEAR(ngaynhanxe) = 2019)
-- Câu 15: Liệt kê họ tên của khách hàng mà có từ hai hợp đồng thuê xe trở lên
			select k.hoten from KhachHang k join HopDongChoThue h on h.makh = k.makh
			group by k.hoten
			having count(mahopdong) > 2
-- Câu 16: Cập nhật cột trạng thái hợp đồng thành 'Bị hủy' đối với những trạng thái hợp đồng là 'Chưa bắt đầu' và số tiền đặt cọc =  0
			update HopDongChoThue set trangthaihopdong = N'Bị hủy'
			where trangthaihopdong = N'Chưa bắt đầu' and sotiendatcoc = 0
			select * from HopDongChoThue            
-- Câu 17: Xóa những loại dịch vụ chưa từng được sử dụng trong bất kì một hợp đồng nào
            delete from LoaiDichVu where maloaidichvu not in(select maloaidichvu from ChiTietHopDongChoThue )
			select * from LoaiDichVu




			---------------------------------------
            delete from KhachHang where makh not in(select makh from HopDongChoThue )
			





















			  

			  
			




			  






			 



			
			

		