create database kiemtracuoiki

create table KhachHang
(
MaKH varchar(20) primary key,
TenKH nvarchar(50),
Email varchar(50),
SoDT varchar(20),
DiaChi nvarchar(50)
)
create table ThanhToan
(
    MaTT varchar(20) primary key,
	PhuongThucTT nvarchar(30) 
)
create table DMSanPham 
(
    MaDM varchar(20) primary key,
	TenDanhMuc varchar(50),
	MoTa nvarchar(50)
)
create table SanPham
(
    MaSP varchar(20) primary key,
	MaDM varchar(20) foreign key (MaDM) references dbo.DMSanPham(MaDM) on delete cascade,
	TenSP nvarchar(50) ,
	GiaTien money ,
	SoLuongCon int ,
	XuatXu nvarchar(30) 
)
create table DonHang
(
    MaDH varchar(20) primary key,
	MaKH varchar(20) foreign key (MaKH) references dbo.KhachHang(MaKH) on delete cascade,
	MaTT varchar(20) foreign key (MaTT) references dbo.ThanhToan(MaTT) on delete cascade,
	NgayDat date 
)
create table ChiTietDonHang
(
   MaDH varchar(20) foreign key (MaDH) references dbo.DonHang(MaDH) on delete cascade,
   MaSP varchar(20) foreign key (MaSP) references dbo.SanPham(MaSP) on delete cascade,
   primary key(MaDH,MaSP),
   SoLuong int,
   TongTien money
)
insert into KhachHang values
('NV01', N'Nguyễn Lan Anh','nlanh@gmail.com',  '0909123456',N'Hải Châu'),
('NV02', N'Trần Nhật Linh','tnlinh@gmail.com', '0909223456',N'Liên Chiểu'),
('NV03', N'Nguyễn Văn A','nva@gmail.com','0909323456',N'Sơn Trà'),
('NV04', N'Lê Văn B','lvb@gmail.com','0909423456',N'Hòa Vang'),
('NV05', N'Nguyễn Văn C','nvc@gmail.com','0909523456',N'Hòa Vang')
insert into ThanhToan values
('TT01', N'thanh toán trực tiếp'),
('TT02', N'thanh toán qua thẻ')
insert into DonHang values
('HD01','NV03','TT01','2020/12/02'),
('HD02','NV02','TT02','2019/09/22'),
('HD03','NV01','TT02','2019/06/02'),
('HD04','NV04','TT01','2020/11/02')
insert into DMSanPham values
('LH01', 'Laptop','HP'),
('LH02', 'Laptop','Dell'),
('LH03', 'Laptop','Macbook'),
('LH04', 'Điện thoại','SamSung'),
('LH05', 'Điện thoại','Iphone')

insert into SanPham values
('MH01','LH01','HP 15s du1103TU i5 10210U','16490000',50,N'Việt Nam'),
('MH02','LH01','HP Envy 13 ba0047TU i7 1065G7','27990000',20,N'Việt Nam'),
('MH03','LH02','Dell Vostro 3590 i7 10510U','20990000',30,N'Việt Nam'),
('MH04','LH02','Dell Inspiron 5593 i5 1035G1','17990000',60,N'Việt Nam'),
('MH05','LH03','Apple MacBook Air 2020 i3 256 GB','28990000',10,N'Việt Nam'),
('MH06','LH04','Samsung Galaxy M51','8990000',20,N'Việt Nam'),
('MH07','LH05','Iphone 12 128GB','25990000',40,N'Việt Nam')

insert into ChiTietDonHang values
('HD01','MH07',1, 26000000),
--('HD02','MH04',2, 36000000),
('HD03','MH03',3, 63000000),
('HD04','MH05',1, 29000000)
--A1.Trigger
--Số TT 115 x 19 tổng 134 A1.3
go
create trigger a1_3 on DonHang
for insert 
as
begin
    declare   
    @day int,
    @MaHD varchar(20),
	@MaKH varchar(20)
	select  @day = DAY(NgayDat), @MaKH = MaKH from inserted
    if (@day <= datepart(DD,getdate())  and exists (select MaKH from KhachHang where @MaKH=MaKH))
      print N'thêm thành công dữ liệu'
    else 
        rollback transaction 
end
select * from DonHang
insert into DonHang values
('HD05','NV03','TT01','2020/12/26')

--A2
--Số TT 115 x 09 tổng 124 A2.2
go
	  create trigger a2_2 on ChiTietDonHang
	  for update  
	  as
	  begin
		declare @countUpdate int; 
    	declare @countItems int; 
		declare @num int;
    	select @countUpdate = inserted.SoLuong from inserted
		select @num = @countUpdate - deleted.SoLuong from deleted
   		select @countItems = SanPham.SoLuongCon from SanPham
    	where SanPham.MaSP in (select MaSP from inserted);
		print @countUpdate
    	if (@countUpdate > 0 AND @num <= @countItems  )
    		update SanPham
    		set SoLuongCon = SoLuongCon - @num
			where SanPham.MaSP in (select MaSP from inserted);	
      	else
		begin
    		print N'Số lượng phải lớn hơn 0, số lượng phải thỏa mãn số lượng còn cho mặt hàng này';
    		rollback tran
		end
      end
	  select * from ChiTietDonHang
	  select * from SanPham
	  update ChiTietDonHang set SoLuong = 2 where MaDH = 'HD03'
--B1.Stored Procedure
--Số TT 115 x 09 tổng 124 B1.2
go
select * from SanPham

create proc b1_2
(
   @MaSP varchar(20),
   @MaDM varchar(20),
   @TenSP nvarchar(30),
   @GiaTien money,
   @SoLuongCon int,
   @XuatXu nvarchar(30)
)
as
begin
   if exists (select MaDM from DMSanPham where MaDM=@MaDM) 
   and not exists (select MaSP from SanPham where MaSP=@MaSP)--kiểm tra sự tồn tại của khóa ngoại và khóa chính.
	begin
		if @SoLuongCon > 0 and @GiaTien > 0 
		begin
		  insert into SanPham values(@MaSP,@MaDM,@TenSP,@GiaTien,@SoLuongCon,@XuatXu)
		  print N'thêm thành công sản phẩm'
		end
        else 
          begin
            print N'giá tiền và số lượng phải lớn hơn 0'
            rollback transaction 
          end
	end	
	else
	begin
		print N'mã sản phẩm này đã tồn tại hoặc mã danh mục sản phẩm này không tồn tại trong bảng DMSanPham '
		rollback tran
	end 
end
exec b1_2 'MH08','LH01','uhjb','2','2','vN'
select * from SanPham
--B2
--Số TT 115 x 19 tổng 134 B2.3
go
create proc b2_3
(
   @MaKH varchar(20)
)
as 
begin
 if not exists (select MaKH from DonHang join ChiTietDonHang on DonHang.MaDH = ChiTietDonHang.MaDH where MaKH = @MaKH )
 begin
   delete KhachHang where MaKH = @MaKH
   update SanPham set SoLuongCon = SanPham.SoLuongCon + ChiTietDonHang.SoLuong 
   from ChiTietDonHang join SanPham on ChiTietDonHang.MaSP = SanPham.MaSP
end 
else
  begin
     print 'không thể xóa dữ liệu'
	 rollback tran
  end
end --
select * from KhachHang
select * from ChiTietDonHang
select * from DonHang
delete KhachHang where MaKH = 'NV02'
--C1
--Số TT 115 x 00 tổng 115 C1.2
/*C1.1. Liệt kê thông tin sản phẩm và chi tiết đơn hàng cho những sản phẩm thuộc danh mục và số lượng còn 
lớn hơn số lượng tối thiểu là hai giá trị được nhập theo tham số của hàm  */
go
create function c1_2( @MaDM varchar(20), @minnum int,@maxnum int)
returns table
as
return(select  d.MaDM,d.TenDanhMuc,d.MoTa,sp.MaSP,sp.TenSP,sp.GiaTien,sp.SoLuongCon,sp.XuatXu 
from SanPham as sp join DMSanPham as d on sp.MaDM = d.MaDM where d.MaDM = @MaDM and (@minnum < sp.SoLuongCon )and (sp.SoLuongCon < @maxnum))

select * from dbo.c1_2 ('LH01', 1,100)
select * from DMSanPham
select * from SanPham
--C2 Function

 create function c2 (@MaKH varchar(20))
	returns nvarchar(80)
	as
	begin
		declare @print nvarchar(80)
		if exists (select KhachHang.MaKH from KhachHang join DonHang ON KhachHang.MaKH = DonHang.MaKH
						join ChiTietDonHang on DonHang.MaDH = ChiTietDonHang.MaDH where KhachHang.MaKH =@MAKH
						group by KhachHang.MaKH having sum(ChiTietDonHang.TongTien) > 2000000)
		begin
			set @print = N'Khách hàng nhận 50 điểm thưởng'
		end
		else
		begin
			set @print = N'Khách hàng nhận 20 điểm thưởng'
		end
		return @print
	end
	select * from ChiTietDonHang
	select * from DonHang
	