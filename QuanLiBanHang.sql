create database QuanLiBanHang

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
('SP001',	'DM01',	'Dam Maxi',	  195000,200,		'VN'),
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

--Câu 1: Liệt kê thông tin toàn bộ sản phẩm.
     select * from KhachHang
--Câu 2: Xóa toàn bộ khách hàng có DiaChi là 'Lang Son'.
     delete from KhachHang from DonHang join KhachHang on DonHang.MaKH = KhachHang.MaKH
	  where DiaChi = 'Lang Son'
	 
--Câu 3: Cập nhật giá trị của trường XuatXu trong bảng SanPham thành 'Viet Nam' đối với trường XuatXu có giá trị là 'VN'.
     update SanPham set XuatXu = 'Viet Nam'
	 where XuatXu = 'VN'

/*Câu 4: Liệt kê thông tin những sản phẩm có SoLuong lớn hơn 50 thuộc danh mục là 'Thoi trang nu'
và những sản phẩm có SoLuong lớn hơn 100 thuộc danh mục là 'Thoi trang nam'.*/
     select * from SanPham s join DMSanPham d on s.MaDM = d.MaDM
	 where (s.SoLuong > 50 and d.TenDanhMuc = 'Thoi Trang Nu')
	 or (s.SoLuong > 100 and d.TenDanhMuc = 'Thoi Trang Nam')

--Câu 5: Liệt kê những khách hàng có tên bắt đầu là ký tự 'A' và có độ dài là 5 ký tự.
     select * from KhachHang
	 where TenKH  Like'A%' and len(TenKH) = 5

--Câu 6: Liệt kê toàn bộ sản phẩm, sắp xếp giảm dần theo TenSP và tăng dần theo SoLuong.
     select * from SanPham 
	 order by TenSP desc,SoLuong asc
     
--Câu 7: Đếm các sản phẩm tương ứng theo từng khách hàng đã đặt hàng, chỉ đếm những sản phẩm được khách hang đặt hàng trên 5 sản phẩm.
     select  d.MaKH,count(c.MaSP) as Sản_phẩm_đã_đặt from ChiTietDonHang c join DonHang d on c.MaDH =d.MaDH
	 where c.SoLuong >5
	 group by MaKH
--Câu 8: Liệt kê tên của toàn bộ khách hàng (tên nào giống nhau thì chỉ liệt kê một lần).
     select distinct TenKH from KhachHang

--Câu 9: Liệt kê MaKH, TenKH, TenSP, SoLuong, NgayDat, GiaTien,TongTien (của tất cả các lần đặt hàng của khách hàng).
     select k.MaKH,k.TenKH,s.TenSP,c.SoLuong,d.NgayDat,s.GiaTien,c.TongTien
	 from KhachHang k join DonHang d on k.MaKH = d.MaKH  
	 join ChiTietDonHang c on c.MaDH = d.MaDH
	 join SanPham s on s.MaSP = c.MaSP

/*Câu 10: Liệt kê MaKH, TenKH, MaDH, TenSP, SoLuong, TongTien của tất cả các lần đặt hàng của khách hàng.
 (những khách hàng chưa đặt hàng lần nào thì vẫn phải liệt kê khách hàng đó ra).*/
     select k.MaKH,k.TenKH,s.TenSP,c.SoLuong,d.NgayDat,s.GiaTien,c.TongTien
	 from KhachHang k left join DonHang d on k.MaKH = d.MaKH  
	 left join ChiTietDonHang c on c.MaDH = d.MaDH
	 left join SanPham s on s.MaSP = c.MaSP

--Câu 11: Liệt kê MaKH, TenKH của những khách hàng đã từng đặt hàng với thực hiện thanh toán qua 'Visa' hoặc đã thực hiện thanh toán qua 'JCB'.
     select k.MaKH, k.TenKH from KhachHang k join DonHang d on k.MaKH = d.MaKH
	 join ThanhToan t on t.MaTT = d.MaTT
	 where t.PhuongThucTT = 'Visa' or t.PhuongThucTT ='JCB'
	 group by k.MaKH,k.TenKH
--Câu 12: Liệt kê MaKH, TenKH của những khách hàng chưa từng mua bất kỳ sản phẩm nào.
   --c1
	 select k.MaKH, k.TenKH from KhachHang k
	  where k.MaKH not in (Select MaKH from DonHang)
   --c2
	  select k.MaKH, k.TenKH from KhachHang k full join DonHang d on d.MaKH = k.MaKH
	  where d.MaDH is null
--Câu 13: Liệt kê MaKH, TenKH của những khách hàng từng đặt hàng đã thanh toán qua 'VISA' và chưa từng đặt hàng với việc thanh toán qua 'JCB'.
    
	 select MaKH, TenKH from KhachHang where MaKH in 
	 (select MaKH from DonHang d join ThanhToan t on d.MaTT = t.MaTT 
	 where t.PhuongThucTT = 'Visa') and MaKH not in 
	 (select MaKH from DonHang d join ThanhToan t on d.MaTT = t.MaTT 
	 where t.PhuongThucTT = 'JCB')
	
/*Câu 14: Liệt kê MaKH, TenKH, TenSP, SoLuong, GiaTien, PhuongThuc TT, NgayDat, Tong Tien của những Khách hàng có địa chỉ là 'Da Nang' 
và mới thực hiện đặt hàng một lần duy nhất. Kết quả liệt kê được sắp xếp tăng dần của trường TenKH.*/
       
		 select k.MaKH,k.TenKH,s.TenSP,s.SoLuong,s.GiaTien,t.PhuongThucTT,d.NgayDat,c.TongTien
		from KhachHang k join DonHang d on k.MaKH = d.MaKH
		join ChiTietDonHang c on c.MaDH = d.MaDH
		join ThanhToan t on d.MaTT = t.MaTT
		join SanPham s on s.MaSP = c.MaSP
		where  k.DiaChi = 'Da Nang'
		and d.MaKH in 
		(select MaKH from DonHang
		group by MaKH
		having count(MaKH) = 2)
		order by TenKH


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
	if exists (select MaDH from DonHang where MaDH=@MaDH) and exists (select MaSP from SanPham where MaSP=@MaSP)
	begin
		if exists (select MaDH,MaSP from ChiTietDonHang where MaDH=@MaDH and MaSP = @MaSP)
		begin
			print 'khoá chính bị trùng'
			rollback tran -- quay lai trạng thái trước khi có trao đổi
		end
		else insert into ChiTietDonHang values(@MaDH,@MaSP,@SoLuong,@TongTien)
	end
	else
	begin
		print 'không tồn tại dữ liệu'
		rollback tran 
	end
 end
 exec Sp_2 'DH002','SP003',6,120000 --> câu lệnh được insert
 exec Sp_2 'DH002','SP002',6,120000 --> khóa chính bị trùng
 exec Sp_2 'DH004','SP003',6,120000 --> đơn hàng không tồn tại
 

 go
 

 /*Câu 3: Viết 2 bẫy sự kiện (trigger) cho bảng CHITIETDONHANG theo yêu cầu sau:
a. Trigger_1: Khi thực hiện đăng ký mới một đơn đặt hàng cho khách hàng thì cập nhật
lại số lượng sản phẩm trong bảng sản phẩm (tức là số lượng sản phẩm còn lại sau khi
đã bán). Bẫy sự kiện chỉ xử lý 1 bản ghi. (1 điểm)
b. Trigger_2: Khi cập nhập lại số lượng sản phẩm mà khách hàng đã đặt hàng, kiểm tra
xem số lượng cập nhật có phù hợp hay không (số lượng phải lớn hơn 1 và nhỏ hơn
100). Nếu dữ liệu hợp lệ thì cho phép cập nhật, nếu không thì hiển thị thông báo "số
lượng sản phẩm được đặt hàng phải nằm trong khoảng giá trị từ 1 đến 100" và thực
hiện quay lui giao tác. (1 điểm)*/

--a
create trigger Trigger_1
on ChiTietDonHang
for insert
as
begin
	declare @SoLuong int
	declare @MaSP varchar(10 )
	select  @SoLuong = SoLuong  from inserted
	select  @MaSP = MaSP from inserted
	update SANPHAM set SoLuong = SoLuong-@SoLuong where MaSP=@MaSP
	
end


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


/*Câu 4: Tạo hàm do người dùng định nghĩa (user-defined function) để tính điểm thưởng cho
khách hàng của tất cả các lần đặt hàng trong năm 2014, mã khách hàng sẽ được truyền
vào thông qua tham số đầu vào của hàm. Cụ thể như sau:
- Nếu tổng số tiền khách hàng đã trả cho tất cả các lần mua hàng dưới 2.000.000, thì trả
về kết quả là khách hàng được nhận 20 điểm thưởng. (1 điểm)
- Nếu tổng số tiền khách hàng đã trả cho tất cả các lần mua hàng từ 2.000.000 trở đi, thì
trả về kết quả là khách hàng được nhận 50 điểm thưởng. (1 điểm)*/


create function user_defined(@MaKH varchar(10))
returns nvarchar(50)
as
begin
	declare @ketqua nvarchar(50)
	if exists
	  (select KhachHang.MaKH from KhachHang join DonHang on KhachHang.MaKH=DonHang.MaKH join ChiTietDonHang 
	   on DonHang.MaDH=ChiTietDonHang.MaDH 
	   where KhachHang.MaKH=@MaKH
	   and YEAR(DonHang.NgayDat)='2014'
	   group by KhachHang.MaKH having 
	   sum(ChiTietDonHang.TongTien)>2000000)
	begin
	   set @ketqua = 'Khách hàng được nhận 50 điểm thưởng.'
	end
	else
	begin
		set @ketqua ='Khách hàng được nhận 20 điểm thưởng.'
	end
	return @ketqua
end

/*Câu 5: Tạo thủ tục Sp_SanPham tìm những sản phẩm đã từng được khách hàng đặt mua để
xóa thông tin về những sản phẩm đó trong bảng SANPHAM và xóa thông tin những
đơn hàng có liên quan đến những sản phẩm đó (tức là phải xóa những bản ghi trong bảng
DONHANG và CHITIETDONHANG có liên quan đến các sản phẩm đó). (2 điểm)*/
create proc Sp_SanPham1
as
begin
	begin tran deletepro;

	declare contro cursor
	for select MaSP, MaDH 
	from CHITIETDONHANG
	open contro
	declare @masp nchar(10)
	declare @madh nchar(10)

	fetch next from contro
	into @masp, @madh
	while @@FETCH_STATUS = 0
	begin

		delete from CHITIETDONHANG

		if @@ERROR !=0
			begin
				print 'rollback';
				rollback tran deletepro
			end

		delete from SANPHAM where SANPHAM.MaSP = @masp

		if @@ERROR !=0
			begin 
				print 'rollback';
				rollback tran deletepro
			end
		delete from DONHANG where MaDH =@madh

		if @@ERROR !=0
			begin 
				print 'rollback';
				rollback tran deletepro
			end

	fetch next from contro 
	into @madh,@masp

	end
	close contro
	deallocate contro

	commit tran deletepro;

end

exec Sp_SanPham1

--
--
--------------------------------
----------------------------------
-----------contro-----------------
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
---------------------------------------
-----------------------------------------
-------------TRANSACTION-----------------
CREATE PROC For_TransTest 
AS
BEGIN
	BEGIN TRANSACTION updatestaff;    
		UPDATE aspnet.staff SET fk_department = 30 
			WHERE pk_staff = 971;     
		IF @@ERROR != 0  -- neu co loi xay ra, rollback 
			BEGIN
				PRINT 'rollback'; 
				ROLLBACK TRAN updatestaff; 
			END    
		UPDATE aspnet.staff SET fk_department = null
			WHERE pk_staff = 971; 
		IF @@ERROR != 0  -- neu co loi xay ra, rollback 
			BEGIN
				PRINT 'rollback'; 
				ROLLBACK TRAN updatestaff; 
			END
		ELSE
			COMMIT TRANSACTION updatestaff;     
			