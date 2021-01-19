create database De1

create table KhachHang
(
  MaKH varchar(10) primary key,
  TenKH varchar(30) not null,
  Email varchar(30) not null,
  SoDT varchar(30) not null,
  DiaChi varchar(30) not null
)
create table ChiTietDonHang
(
  MaDH varchar(10) not null,
  MaSP varchar(10) not null,
  primary key(MaDH,MaSP),
  SoLuong int not null,
  TongTien int not null
)
create table SanPham
(
  MaSP varchar(10) primary key,
  MaDM varchar(10) not null,
  TenSP nvarchar(30) not null,
  GiaTien int not null,
  SoLuong int not null,
  XuatXu varchar(30) not null
)
create table ThanhToan
( 
  MaTT varchar(10) primary key,
  PhuongThucTT varchar(30) not null
)
create table DonHang 
(
  MaDH varchar(10) primary key,
  MaKH varchar(10) foreign key (MaKH) references dbo.KhachHang(MaKH) on delete cascade,
  MaTT varchar(10) foreign key (MaTT) references dbo.ThanhToan(MaTT)on delete cascade,
  NgayDat date not null
)
create table DMSanPham
(
  MaDM varchar(10) primary key,
  TenDanhMuc varchar(30) not null,
  MoTa varchar(30) not null
)
alter table ChiTietDonHang
add foreign key (MaSP) references dbo.SanPham(MaSP) on delete cascade
alter table ChiTietDonHang
add foreign key (MaDH) references dbo.DonHang(MaDH) on delete cascade
alter table SanPham
add foreign key (MaDM) references dbo.DMSanPham(MaDM) on delete cascade
 
 insert into KhachHang values
('KH001',	'Tran Van An',	'antv@gmail.com','0905123564',	'Lang Son'),
('KH002',	'Phan Phuoc',	'phuocp@gmail.com','0932568984',	'Da Nang'),
('KH003',	'Tran Huu Anh',	'anhth@gmail.com','0901865232',	'Ha Noi')
insert into DMSanPham values
('DM01',	'Thoi Trang Nu',	'vay, ao danh cho nu'),
('DM02',	'Thoi Trang Nam',	'quan danh cho nam'),
('DM03',	'Trang suc',	'danh cho nu va nam')
insert into SanPham values
('SP001',	'DM01',	'Dam Maxi',	        195000,200, 'VN'),
('SP002',	'DM01',	N'Tui Da Mỹ',		3000000,50,	'HK'),
('SP003',	'DM02',	'Lac tay Uc',		300000,300,	'HQ')
insert into ThanhToan values
('TT01',	'Visa'),
('TT02',	'Master Card'),
('TT03',	'JCB')
insert into DonHang values
('DH001',	'KH002',	'TT01',	'2014/10/20'),
('DH002',	'KH002',	'TT01',	'2015/5/15'),
('DH003',	'KH001',	'TT03',	'2015/4/20')
insert into ChiTietDonHang values
('DH001',	'SP002',	3,	56000),
('DH003',	'SP001',	10, 27444), 
('DH002',	'SP002',	10,	 67144) 

		/* Câu 1: Thực hiện yêu cầu sau:
a. Tạo một khung nhìn có tên là V_KhachHang để thấy được thông tin của tất cả các
đơn hàng có ngày đặt hàng nhỏ hơn ngày 06/15/2015 của những khách hàng có địa
chỉ là "Da Nang". (1 điểm)
b. Thông qua khung nhìn V_KhachHang thực hiện việc cập nhật ngày đặt hàng thành
06/15/2015 đối với những khách hang đặt hàng vào ngày 06/15/2014. (1 điểm) */
--a:
Create View V_KhachHang as 
      select k.*,d.MaDH,d.MaTT,d.NgayDat from KhachHang k join DonHang d on k.MaKH = d.MaKH
	  where k.DiaChi = 'Da Nang' and d.NgayDat < '2015/06/15'
--b:
update V_KhachHang
set NgayDat = '2015/06/15'
where NgayDat = '2014/06/15'

/*Câu 2: Tạo 2 thủ tục:
a. Thủ tục Sp_1: Dùng để xóa thông tin của những sản phẩm có mã sản phẩm được
truyền vào như một tham số của thủ tục. (1 điểm)
b. Thủ tục Sp_2: Dùng để bổ sung thêm bản ghi mới vào bảng CHITIETDONHANG
(Sp_2 phải thực hiện kiểm tra tính hợp lệ của dữ liệu được bổ sung là không trùng
khóa chính và đảm bảo toàn vẹn tham chiếu đến các bảng có liên quan). (1 điểm)*/
--a
go

create proc Sp_1 
  @MaSP varchar(10) 
as
  begin
    delete from SanPham where MaSP = @MaSP
  end
exec Sp_1 'SP001'--Thực thi

--b
create proc Sp_2
 (
	@MaDH nvarchar(50) ,
	@MaSP nvarchar(50 )	,
	@SoLuong int ,
	@TongTien float
 )
 as
 begin
	if exists (select MaDH from DonHang where MaDH=@MaDH) and exists (select MaSP from SanPham where MaSP=@MaSP)--kiểm tra sự tồn tại của khóa ngoại.
	begin
		if exists (select MaDH,MaSP from ChiTietDonHang where MaDH=@MaDH and MaSP = @MaSP)
		begin
			print 'khoá chính bị trùng'
		end
		else insert into ChiTietDonHang values(@MaDH,@MaSP,@SoLuong,@TongTien)
	end
	else
	begin
		print 'không tồn tại đơn hàng hoặc sản phẩm'
	end
 end
 exec Sp_2 'DH001','SP003',6,120000 --> câu lệnh được insert
 exec Sp_2 'DH002','SP002',6,120000 --> khóa chính bị trùng
 exec Sp_2 'DH004','SP003',6,120000 --> đơn hàng không tồn tại
 select * from DonHang
 select * from SanPham
 select * FRom ChiTietDonHang
  /*Câu 3: Viết 2 bẫy sự kiện (trigger) cho bảng CHITIETDONHANG theo yêu cầu sau:
a. Trigger_1: Khi thực hiện đăng ký mới một đơn đặt hàng cho khách hàng thì cập nhật
lại số lượng sản phẩm trong bảng sản phẩm (tức là số lượng sản phẩm còn lại sau khi
đã bán). Bẫy sự kiện chỉ xử lý 1 bản ghi. (1 điểm)
b. Trigger_2: Khi cập nhập lại số lượng sản phẩm mà khách hàng đã đặt hàng, kiểm tra
xem số lượng cập nhật có phù hợp hay không (số lượng phải lớn hơn 1 và nhỏ hơn
100). Nếu dữ liệu hợp lệ thì cho phép cập nhật, nếu không thì hiển thị thông báo "số
lượng sản phẩm được đặt hàng phải nằm trong khoảng giá trị từ 1 đến 100" và thực
hiện quay lui giao tác. (1 điểm)*/

go
--a
create trigger Trigger_1
on ChiTietDonHang
for insert
as
begin
	update SanPham set SanPham.SoLuong = SanPham.SoLuong- inserted.SoLuong 
	from SanPham inner join inserted
	on SanPham.MaSP = inserted.MaSP	
end

select * from ChiTietDonHang
select * from SanPham

--số lượng ban đầu SP03 có 300
insert into ChiTietDonHang values('DH01','SP003','60','12212')
-- số lượng còn lại sau khi insert của sp03 là 280;
go

--b.	
create trigger Trigger_2
on ChiTietDonHang
for update
as
begin
	declare @SoLuong int
	select  @SoLuong=SoLuong from inserted
	if(@SoLuong between 1 and 100) update ChiTietDonHang set SoLuong=@SoLuong
	  else
	   begin
		print 'số lượng phải lớn hơn 1 và nhỏ hơn 100'
		rollback tran
	   end
end
insert into ChiTietDonHang values ('DH002','SP001',20,1234567)--> dc insert
insert into ChiTietDonHang values ('DH003','SP002',120,1234567)

go
/*Câu 4: Tạo hàm do người dùng định nghĩa (user-defined function) để tính điểm thưởng cho
khách hàng của tất cả các lần đặt hàng trong năm 2014, mã khách hàng sẽ được truyền
vào thông qua tham số đầu vào của hàm. Cụ thể như sau:
- Nếu tổng số tiền khách hàng đã trả cho tất cả các lần mua hàng dưới 2.000.000, thì trả
về kết quả là khách hàng được nhận 20 điểm thưởng. (1 điểm)
- Nếu tổng số tiền khách hàng đã trả cho tất cả các lần mua hàng từ 2.000.000 trở đi, thì
trả về kết quả là khách hàng được nhận 50 điểm thưởng. (1 điểm)
*/

create function user_defined(@MaKH nvarchar(50))
returns nvarchar(100)
as
begin
	declare @KetQua nvarchar(100)
	if exists (select KhachHang.MaKH from KhachHang join DonHang on KhachHang.MaKH=DonHang.MaKH join ChiTietDonHang
	on DonHang.MaDH=ChiTietDonHang.MaDH where KhachHang.MaKH=@MaKH
	 and YEAR(DonHang.NgayDat)='2014' group by KhachHang.MaKH having sum(ChiTietDonHang.TongTien)>2000000)
	begin
		set @KetQua = 'Khách hàng được nhận 50 điểm thưởng.'
	end
	else
	begin
		set @KetQua ='Khách hàng được nhận 20 điểm thưởng.'
	end
	return @KetQua
end

