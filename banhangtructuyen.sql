create database banhangtructuyen
create table NhanVien
(
    MaNV varchar(20) primary key,
    TenNV nvarchar(30) ,
	Email varchar(30) ,
	SoDT varchar(20) ,
	DiaChi nvarchar(50) ,
	TinhTrang nvarchar(50) 
)
create table ThanhToan
(
    MaTT varchar(20) primary key,
	PhuongThucTT nvarchar(30) 
)
create table HoaDon
(
    MaHD varchar(20) primary key,
	MaNV varchar(20) foreign key (MaNV) references dbo.NhanVien(MaNV) on delete cascade,
	MaTT varchar(20) foreign key (MaTT) references dbo.ThanhToan(MaTT) on delete cascade,
	NgayHD date 
)
Create table LoaiHang
(
    MaLH varchar(20) primary key,
	TenLoaiHang nvarchar(30) ,
	MoTa nvarchar(30) 
)
create table MatHang
(
    MaMH varchar(20) primary key,
	MaLH varchar(20) foreign key (MaLH) references dbo.LoaiHang(MaLH) on delete cascade,
	TenSP nvarchar(50) ,
	GiaTien money ,
	SoLuongCon int ,
	XuatXu nvarchar(30) 
)
create table ChiTietDonHang
(
    MaHD varchar(20) foreign key (MaHD) references dbo.HoaDon(MaHD) on delete cascade,
	MaMH varchar(20) foreign key (MaMH) references dbo.MatHang(MaMH) on delete cascade,
	primary key (MaHD, MaMH),
	SoLuong int ,
	ThanhTien money 
)select * from NhanVien
insert into NhanVien values
('NV01', N'Nguyễn Lan Anh','nlanh@gmail.com',  '0909123456',N'Hải Châu', N'đang làm việc'),
('NV02', N'Trần Nhật Linh','tnlinh@gmail.com', '0909223456',N'Liên Chiểu', N'đang nghỉ việc'),
('NV03', N'Nguyễn Văn A','nva@gmail.com','0909323456',N'Sơn Trà', N'đang làm việc'),
('NV04', N'Lê Văn B','lvb@gmail.com','0909423456',N'Hòa Vang', N'đang làm việc'),
('NV05', N'Nguyễn Văn C','nvc@gmail.com','0909523456',N'Hòa Vang', N'đang làm việc')
insert into ThanhToan values
('TT01', N'thanh toán trực tiếp'),
('TT02', N'thanh toán qua thẻ')
insert into HoaDon values
('HD01','NV03','TT01','2020/12/02'),
('HD02','NV02','TT02','2019/09/22'),
('HD03','NV01','TT02','2019/06/02'),
('HD04','NV04','TT01','2020/11/02')
insert into LoaiHang values
('LH01', 'Laptop','HP'),
('LH02', 'Laptop','Dell'),
('LH03', 'Laptop','Macbook'),
('LH04', 'Điện thoại','SamSung'),
('LH05', 'Điện thoại','Iphone')

insert into MatHang values
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
select * from MatHang

--A1. Trigger: kiểm tra các điều kiện đã cho, không thỏa mãn thì hủy thao tác hiện tại phát sinh sự kiện
/* A1.1. Cho sự kiện thêm mới nhiều bản ghi trên bảng MATHANG, giá tiền còn phải lớn hơn 0 và số lượng 
phải bằng 0, mã danh mục phải có trong bảng LOAIHANG */
go

 ---
create trigger a1_1 on MatHang
for insert 
as
declare  
    @MaDM varchar(20),
	@GiaTienCon money,
	@SoLuong int
	select @MaDM = MaLH, @GiaTienCon = GiaTien, @SoLuong = SoLuongCon from inserted
	   if exists (select MaLH from LoaiHang where MaLH = @MaDM) --> kiểm tra khóa ngoại
       begin
	      if @SoLuong = 0 and @GiaTienCon > 0  -- kiểm tra điều kiện thỏa mãn
		    print N'thêm thành công dữ liệu'
          else rollback transaction 
	   end
	   else rollback transaction 
 ---
 --drop trigger a1_1
 --delete MatHang where MaMH = 'MH08'
 --select * from MatHang
 insert into MatHang values('MH08','LH08','HP 15s fq1111TU i3 1005G1','11390000',20,N'Việt Nam') --> 'không tồn tại mã loại hàng này'
 insert into MatHang values('MH08','LH01','HP 15s fq1111TU i3 1005G1','11390000',20,N'Việt Nam') --> 'giá tiền phải lớn hơn 0 và số lượng phải bằng 0'
 insert into MatHang values('MH08','LH01','HP 15s fq1111TU i3 1005G1','11390000',0,N'Việt Nam')
/* A1.2. Cho sự kiện xóa nhiều bản ghi từ bảng HOADON, chỉ những hóa đơn có ngày hóa đơn không thuộc năm hiện tại 
và không có chi tiết hóa đơn mới được phép xóa.*/
go   -- sai

create trigger a1_2
on HoaDon
after delete
as
  begin
  declare @year date
  declare @MaHD varchar(20)
  select @MaHD=MaHD from deleted
  select @year=NgayHD FROM deleted
  if ((Datepart(yyyy,@year)) <> (DATEPART(yyyy, GETDATE()))
  and not exists (select MaHD from ChiTietDonHang where @MaHD=MaHD))
        print 'xóa thành công'
      else
        rollback tran
   end
		insert into HoaDon values('HD03', 'NV03','TT01','2019/12/12')
		insert into ChiTietDonHang values ('HD02','MH01',1,123)
delete from HoaDon where MaHD = 'HD03' --> xóa thành công
drop trigger a1_2
select * from HoaDon
select * from ChiTietDonHang

/* A1.3. Cho sự kiện thêm mới nhiều bản ghi trên bảng HOADON, ngày hóa đơn phải nhỏ hơn hoặc bằng ngày hiện tại 
 và phải thuộc tháng hiện tại; mã hóa đơn phải có trong KHACHHANG */
 go
 ---
create trigger a1_3 on HoaDon
for insert 
as
declare   
    @day int,
	@month int,
    @MaHD varchar(20),
	@MaNV varchar(20)
	select  @day = DAY(NgayHD), @month =MONTH(NgayHD), @MaHD = MaHD, @MaNV = MaNV from inserted
    if (@day <= datepart(DD,getdate()) and (@month = DATEPART(MM,GETDATE()) and exists (select MaNV from NhanVien where @MaNV=MaNV)))
      print N'thêm thành công dữ liệu'
    else 
      begin
        print N'ngày hóa đơn phải nhỏ hơn hoặc bằng ngày hiện tại và phải thuộc tháng hiện tại'--k cần
        rollback transaction 
      end

	  --drop trigger a1_3
	  --delete from HoaDon where MaHD = 'HD05'
	  --select * from NhanVien

	  insert into HoaDon values('HD05','NV04','TT01','2020/11/02') --> k thuộc tháng hiện tại
	  insert into HoaDon values('HD05','NV05','TT01','2020/12/02') --> k tồn tại nv05
	  insert into HoaDon values('HD05','NV04','TT01','2020/12/02') --> thêm thành công

/* A1.4. Cho sự kiện thêm mới nhiều bản ghi trên bảng chitietdonhang, số lượng và tổng thành tiền phải lớn hơn 0,
mã mặt hàng phải có trong bảng MATHANG */
go

create trigger a1_4
on ChiTietDonHang
for insert 
as
     declare @SoLuong int,
             @TongThanhTien money,
			 @MaMH varchar(20)
     select  @SoLuong = SoLuong, @TongThanhTien = ThanhTien, @MaMH = MaMH from inserted

      if ( exists (select MaMH from MatHang where @MaMH=MaMH) and @SoLuong > 0 and @TongThanhTien > 0)
           print N'thêm thành công dữ liệu'
      else
	    begin
          print N'số lượng và tổng thành tiền phải lớn hơn 0'--k cần
		  rollback tran
		end
insert into ChiTietDonHang values ('HD02','MH07',2, 52000000)
--drop trigger a1_4
--select * from HoaDon
--select *from ChiTietDonHang
select * from MatHang


/*A2. Trigger, kiểm tra các điều kiện đã cho, không thỏa mãn thì đưa ra thông báo lỗi tương ứng và hủy thao tác
phát sinh sự kiện*/
/* A2.1. Cho sự kiện cập nhật trên nhiều bản ghi trên bảng chitietdonhang, số lượng phải lớn hơn 0,
số lượng phải thỏa mãn số lượng còn cho mặt hàng đó, cập nhật tăng giảm tương ứng còn trong bảng MATHANG  */
go
--
create trigger a2_1 on ChiTietDonHang
for insert 
as
declare @SoLuong int, -- Số lượng của chi tiết đơn hàng
        @SoLuongCon int, -- Số lượng còn lại của mặt hàng
		@MaMH varchar(20)
	select @SoLuong = SoLuong, @MaMH = MaMH from inserted
	select @SoLuongCon = SoLuongCon from MatHang where @MaMH = MaMH
	if (@SoLuong >0 and @SoLuong <= @SoLuongCon)
	update MatHang set SoLuongCon = SoLuongCon - @SoLuong where MaMH = @MaMH
	else 
	  begin
	         print N'Số lượng phải lớn hơn 0 và phải nhỏ hơn hoặc bằng số lượng còn'
			 rollback tran
	  end

	  insert into ChiTietDonHang values('HD03','MH07',50, 26000000) --> số lượng = 50 > số lượng còn = 40 --> không insert được
	  insert into ChiTietDonHang values('HD03','MH07',0, 26000000) --> số lượng = 0 --> k insert được
	  insert into ChiTietDonHang values('HD04','MH07',2, 26000000) --> Số lượng còn trong bảng mặt hàng của MH07 = 40-20 = 20
	  
	  --insert into HoaDon values ('HD02','NV02','TT02','2019/09/22')
	  --select * from ChiTietDonHang
	  --select * from MatHang
	  --select * from HoaDon

	----
	
	
/* A2.2. Cho sự kiện xóa nhiều bản ghi từ bảng NHANVIEN, không thể xóa nếu nhân viên đó có tình trạng là "đang làm việc"
hoặc tồn tại hóa đơn do nhân viên tương ứng lập cũng như trong các bảng HOADON và chitietdonhang */
go
--

create trigger a2_2
on NhanVien
after delete
as
begin
   
     declare @countMaNV tinyint
     declare @TinhTrang nvarchar(30)
     select  @TinhTrang = deleted.TinhTrang from deleted 
	 select  @countMaNV = COUNT(deleted.MaNV) from deleted join HoaDon ON deleted.MaNV = HoaDon.MaNV
     if @TinhTrang = N'đang làm việc' and @countMaNV <> 0
		begin
    		print 'Xoá thất bại !!!';
    		rollback tran;
		end
end    

select * from HoaDon
select * from NhanVien
delete NhanVien where MaNV = 'NV01' --> k được phép xóa
delete NhanVien where MaNV = 'NV05'
delete NhanVien where MaNV = 'NV02' --> xóa thành công

drop trigger a2_2




/* A2.3. Cho sự kiện xóa nhiều bản ghi từ bảng HOADON, chỉ những hóa đơn có ngày hóa đơn không thuộc năm
hiện tại mới được phép xóa */
go

create trigger a2_3
on HoaDon
for delete
as
     declare @year int
     declare @MaHD varchar(20)
     select  @year = year(NgayHD),@MaHD = MaHD from deleted
      if (@year <> datepart(YYYY,getdate()))
        print 'xóa thành công'
      else
        begin
		  print N'chỉ được phép xóa những hóa đơn không thuộc năm hiện tại'
          rollback tran
		end

delete HoaDon where MaHD = 'HD01' --> k thuộc năm hiện tại nên k xóa được
delete HoaDon where MaHD = 'HD02' --> xóa thành công
--drop trigger a2_3
--select * from HoaDon


/* A2.4. Cho sự kiện thêm mới nhiều bản ghi trên bảng CHITIETDONHANG, số lượng phải lớn hơn 0, 
tính tổng tiền bằng số lượng đặt/bán nhân với giá tiền lấy từ bảng MATHANG, mã đơn hàng phải có trong bảng DONHANG, 
cập nhật giảm tương ứng số lượng hàng còn trong bảng MATHANG */
go
--
select * from ChiTietDonHang
select * from MatHang
select * from HoaDon
go
--
/*
create trigger a2_4 on ChiTietDonHang
for insert 
as
declare @SoLuong int, 
        @TongTien money,
		@GiaTien money,
		@MaDH varchar(20)
	select @SoLuong = SoLuong, @TongTien = ThanhTien, @MaDH = MaMH from inserted
	select @GiaTien = GiaTien  from MatHang where @MaDH = MaMH
	if (@SoLuong > 0 and exists (select @MaDH from MatHang where @MaDH=MaMH))
	update ChiTietDonHang set ThanhTien =   @SoLuong * @GiaTien where MaMH = @MaDH
	else 
	  begin
	         print N'Số lượng phải lớn hơn 0 và mã mặt hàng phải tồn tại trong bảng mặt hàng'
			 rollback tran
	  end*/
	insert into ChiTietDonHang(MaHD,MaMH,SoLuong) values('HD01','MH02',0) --> Số lượng = 0 --> k insert được
	insert into ChiTietDonHang(MaHD,MaMH,SoLuong,ThanhTien) values('HD01','MH05',3,78) --> Số lượng = 0 --> k insert được
	
	
	 select * from HoaDon
	 select * from ChiTietDonHang
	 select *from MatHang
	 drop trigger a2_4
	go

	CREATE TRIGGER a2_4
	ON ChiTietDonHang
    AFTER INSERT AS 
BEGIN
		DECLARE @essitDontHang INT; 
        declare @sl int
        SELECT @essitDontHang = COUNT(HOADON.MaHD)
        FROM HOADON 
        WHERE HOADON.MaHD IN (SELECT MaHD from inserted);
        select @sl =inserted.SoLuong from inserted
     	IF @sl > 0 AND @essitDontHang > 0
		begin
        	UPDATE ChiTietDonHang
        	set ThanhTien = MatHang.GiaTien * inserted.SoLuong
        	FROM inserted
        	JOIN MatHang
        	ON MatHang.MaMH = inserted.MaMH
            
        	UPDATE MatHang 
    		SET MatHang.SoLuongCon = MatHang.soluongcon - inserted.soluong
			FROM inserted 
			WHERE MatHang.MaMH IN (SELECT MaMH from inserted);
		end	
        ELSE
			begin
        		PRINT 'Thêm thất bại !!!';
    			ROLLBACK TRANSACTION;
			end
        	
END

/*B1. Stored Procedure: giả sử không có các trigger như ở A1 */
/*B1.1. Thực hiện thêm mới 1 bản ghi vào bảng MATHANG thỏa mãn các điều kiện ở A1.1 
giá tiền còn phải lớn hơn 0 và số lượng phải bằng 0, mã danh mục phải có trong bảng LOAIHANG */
go
--
create proc b1_1
(
   @MaMH varchar(20),
   @MaDM varchar(20),
   @TenSP nvarchar(30),
   @GiaTien money,
   @SoLuong int,
   @XuatXu nvarchar(30)
)
as
begin
   if exists (select MaLH from LoaiHang where MaLH=@MaDM) and not exists (select MaMH from MatHang where MaMH=@MaMH)--kiểm tra sự tồn tại của khóa ngoại.
	begin
		if @SoLuong = 0 and @GiaTien > 0 
		begin
		  insert into MatHang values(@MaMH,@MaDM,@TenSP,@GiaTien,@SoLuong,@XuatXu)
		  print N'thêm thành công dữ liệu'
		end
        else 
          begin
            print N'giá tiền còn phải lớn hơn 0 và số lượng phải bằng 0'
            rollback transaction 
          end
	end	
	else
	begin
		print N'mã Mặt hàng này đã tồn tại hoặc mã loại hàng này không tồn tại trong bảng LOẠI HÀNG '
		rollback tran
	end 
end


 exec b1_1 'MH01','LH04','Samsung a11','3000000',20,  N'Việt Nam' --> câu lệnh k được insert do mã hàng này đã tồn tại
 exec b1_1 'MH09','LH04','Samsung a11','3000000',0,  N'Việt Nam' --> câu lệnh k được insert vì số lượng > 20
 exec b1_1 'MH08','LH04','Samsung a11','3000000',0,  N'Việt Nam' --> câu lệnh k được insert

 select * from MatHang
 select * from LoaiHang
/*B1.2. Thực hiện xóa 1 bản ghi từ bảng HOADON thỏa mã các điều kiện ở A1.2
chỉ những hóa đơn có ngày hóa đơn không thuộc năm hiện tại 
và không có chi tiết hóa đơn mới được phép xóa
*/
go

create proc b1_2
(
    @MaHD varchar(20)
)
as 
begin
    declare @NgayHD date
	set @NgayHD = (select NgayHD from HoaDon where MaHD = @MaHD)
	     if ((Datepart(yyyy,@NgayHD)) <> (DATEPART(yyyy, GETDATE())) and not exists (select MaHD from ChiTietDonHang where MaHD = @MaHD))
	      begin
		      delete from  HoaDon where MaHD=@MaHD 
		  end
	     else 
		  rollback tran
end
exec b1_2 'HD03'
select * from HoaDon
select * from ChiTietDonHang
drop trigger a2_2
/*B1.3. Thực hiện thêm mới 1 bản ghi vào bảng HOADON thỏa mãn các điều kiện ở A1.3  */
go
create proc b1_3
   (@MaHD varchar(20),
	@MaNV varchar(20),
	@MaTT Varchar(20),
	@NgayHD date)
	as
	begin
	 if exists (select MaNV from NhanVien where @MaNV=MaNV)
	 begin
	    declare   @day int, @month int
		set @day   = day(@NgayHD)
		set @month = MONTH(@NgayHD)
          if (@day <= datepart(DD,getdate()) and (@month = DATEPART(MM,GETDATE()))) 
           begin
	         insert into HoaDon values(@MaHD,@MaNV,@MaTT,@NgayHD)
	       end
          else 
           begin
            print N'ngày hóa đơn phải nhỏ hơn hoặc bằng ngày hiện tại và phải thuộc tháng hiện tại '
            rollback transaction 
           end
	end
	else print N'Mã nhân viên này không tồn tại'
	end
exec b1_3 'HD06','NV01','TT01','2020/12/12'
drop proc b1_3
select * from HoaDon
select * from NhanVien

/*B1.4. Thực hiện thêm mới 1 bản ghi vào bảng chitietdonhang thỏa mãn các điều kiện ở A1.4  */
go

 create proc b1_4
 (
     @MaHD varchar(20),
	 @MaMH varchar(20),
	 @SoLuong int,
	 @ThanhTien money
 )
 as 
 begin
         if ( exists (select MaHD from HoaDon where @MaHD=MaHD) and exists (select MaMH from MatHang where @MaMH=MaMH))
		 begin
		  if @SoLuong > 0 and @ThanhTien > 0
	       begin
		     insert into ChiTietDonHang values(@MaHD,@MaMH,@SoLuong,@ThanhTien)
             print N'thêm thành công dữ liệu'
		  end
          else
	        begin
              print N'số lượng và tổng thành tiền phải lớn hơn 0'
		      rollback tran
		    end
		 end
		else 
		    begin
              print N'k tồn tại mã hd hoặc mã mh này'
		      rollback tran
		    end
		   
end

exec b1_4 'HD03','MH07',0, 52000000 --> Số lượng =0
exec b1_4 'HD01','MH09',20, 52000000 --> k tồn tại mh09
exec b1_4 'HD03','MH03',2, 40000000--> thêm thành công /
select * from ChiTietDonHang
select * from MatHang
/*B2. Stored Procedure: giả sử không có các trigger như ở A2*/
/*B2.1. Thực hiện cập nhật 1 bản ghi vào bảng chitietdonhang thỏa mãn các điều kiện ở A2.1.
Cho sự kiện cập nhật trên nhiều bản ghi trên bảng chitietdonhang, số lượng phải lớn hơn 0,
số lượng phải thỏa mãn số lượng còn cho mặt hàng đó, cập nhật tăng giảm tương ứng còn trong bảng MATHANG*/
go
create proc b2_1
(
 @MaHD varchar(20),
 @MaMH varchar(20),
 @SoLuong int
)
as
begin
    if( (@SoLuong > 0 )and exists (select MaMH from MatHang where @SoLuong <= SoLuongCon))
	update MatHang set SoLuongCon = SoLuongCon - @SoLuong where MaMH = @MaMH
	else
	  begin
	         print N'Số lượng phải lớn hơn 0 và phải nhỏ hơn hoặc bằng số lượng còn'
			 rollback tran
	  end
end

exec b2_1 'HD03','MH03',5 --> Số lượng còn trong bảng mặt hàng giảm 5

select * from MatHang
select * from ChiTietDonHang

drop  proc b2_1




/*B2.2. Thực hiện xóa 1 bản ghi từ bảng NHANVIEN, xóa liên hoàn các bản ghi tương ứng điều kiện 
ở A2.2 và cập nhật tăng tương ứng số lượng còn trong bản MATHANG
không thể xóa nếu nhân viên đó có tình trạng là "đang làm việc"
hoặc tồn tại hóa đơn do nhân viên tương ứng lập cũng như trong các bảng HOADON và chitietdonhang */
go

create trigger a2_2
on NhanVien
after delete
as
begin
   
     declare @countMaNV tinyint
     declare @TinhTrang nvarchar(30)
     select  @TinhTrang = deleted.TinhTrang from deleted 
	 select  @countMaNV = COUNT(deleted.MaNV) from deleted join HoaDon ON deleted.MaNV = HoaDon.MaNV
     if @TinhTrang = N'đang làm việc' and @countMaNV <> 0
		begin
    		print 'Xoá thất bại !!!';
    		rollback tran;
		end
end    
create proc b2_2
    @MaNV varchar(20)
as
begin 
  if (exists  (select MaNV from NhanVien where TinhTrang != N'đang làm việc' )
  or exists (select NhanVien.MaNV from HoaDon join NhanVien on NhanVien.MaNV = HoaDon.MaNV group by NhanVien.MaNV having count(NhanVien.MaNV)=0))
  delete NhanVien where MaNV = @MaNV
  else rollback tran
  end
  /*if (exists (select HoaDon.MaNV from HoaDon join NhanVien on HoaDon.MaNV = NhanVien.MaNV GROUP BY HoaDon.MaNV having count(@MaNV) <> '0'  ) 
  or exists (select MaNV from NhanVien where TinhTrang = N'đang làm việc'))
        begin
		  print N'không được phép xóa'
		  rollback tran
		end
      else
	   begin
	    delete NhanVien where MaNV = @MaNV
	    print N'Xóa thành công dữ liệu'
       end*/


exec b2_2 'NV03' --> đang lm việc nên k xóa đc
exec b2_2'NV13'
select * from NhanVien
select * from HoaDon

/*B2.3. Cho sự kiện xóa 1 bản ghi từ bảng HOADON, xóa liên hoàn các bản ghi tương ứng điều kiện ở A2.3
chỉ những hóa đơn có ngày hóa đơn không thuộc năm
hiện tại mới được phép xóa*/

---sai
create proc b2_3
(@MaHD varchar(20))
as
begin  
      if exists (select MaHD from HoaDon where year(NgayHD) <> datepart(YYYY,getdate()))
	    begin
           delete HoaDon where @MaHD = MaHD
		   print 'xóa thành công'
		end
      else
        begin
		  print N'chỉ được phép xóa những hóa đơn không thuộc năm hiện tại'
          rollback tran
		end
end
exec b2_3 'HD01' --> k xoa dc
exec b2_3 'HD02'
   select * from HoaDon
   drop proc b2_3
		DECLARE @year INT;  
        
    	SELECT @year = YEAR(deleted.NgayHD)
        FROM deleted
     	
        IF @year <> DATEPART(yyyy, GETDATE()) 
        	DELETE chitietdonhang
       		FROM chitietdonhang
      		WHERE chitietdonhang.MaHD IN (SELECT MaHD FROM deleted)
        ELSE 
        	PRINT 'Xoá thất bại !!!';
    		ROLLBACK TRANSACTION;	
create trigger a2_3
on HoaDon
for delete
as
     declare @year int
     declare @MaHD varchar(20)
     select  @year = year(NgayHD),@MaHD = MaHD from deleted
      if (@year = datepart(YYYY,getdate()))
        print 'xóa thành công'
      else
        begin
		  print N'chỉ được phép xóa những hóa đơn không thuộc năm hiện tại'
          rollback tran
		end

/*B2.4. Thực hiện thêm mới 1 bản ghi vào bảng chitietdonhang thỏa mãn các điều kiện ở A2.4.*/
/* A2.4. Cho sự kiện thêm mới nhiều bản ghi trên bảng CHITIETDONHANG, số lượng phải lớn hơn 0, 
tính tổng tiền bằng số lượng đặt/bán nhân với giá tiền lấy từ bảng MATHANG, mã đơn hàng phải có trong bảng DONHANG, 
cập nhật giảm tương ứng số lượng hàng còn trong bảng MATHANG */

create proc b2_4
(
	@MaHD varchar(255),
	@MaMH varchar(255),
	@SoLuong int,
	@ThanhTien float 
)
as
begin

		DECLARE @essitDontHang INT; 
        declare @sl int
        SELECT @essitDontHang = COUNT(HOADON.MaHD)
        FROM HOADON 
        WHERE HOADON.MaHD IN (SELECT MaHD from chitietdonhang)
        select @sl =chitietdonhang.SoLuong from chitietdonhang where SoLuong=@sl
     	IF @sl > 0 AND @essitDontHang > 0
		begin
        	UPDATE chitietdonhang 
        	set ThanhTien = MatHang.GiaTien * chitietdonhang.SoLuong
        	FROM chitietdonhang
        	JOIN MatHang
        	ON MatHang.MaMH = chitietdonhang.MaMH
            
        	UPDATE MatHang 
    		SET MatHang.SoLuongCon = MatHang.soluongcon - chitietdonhang.soluong
			FROM chitietdonhang 
			WHERE MatHang.MaMH IN (SELECT MaMH from chitietdonhang);
		end	
        ELSE
			begin
        		PRINT 'Thêm thất bại !!!';
    			ROLLBACK TRANSACTION;
			end
        	
END 	
exec b2_4  'HD04','MH07',3,12
	drop proc b2_4
	
/*C1.Function; inline table-valued:*/
/*C1.1. Liệt kê thông tin sản phẩm và chi tiết đơn hàng cho những sản phẩm thuộc danh mục và số lượng còn 
lớn hơn số lượng tối thiểu là hai giá trị được nhập theo tham số của hàm  */
go
create function C1_1( @madm nvarchar(255), @num int)
returns table
as
return(select m.MaMH, m.MaLH, m.GiaTien, m.SoLuongCon, m.TenSP, m.XuatXu, c.MaHD, c.SoLuong, c.ThanhTien 
from MATHANG as m join ChiTietDonHang as c on m.MaMH = c.MaMH where MaHD = @madm and m.SoLuongCon > @num)

SELECT * FROM dbo.C1_1('MH07',1)
select * from ChiTietDonHang
select * from MatHang
select * from HoaDon
/*C1.2. Liệt kê thông tin khách hàng và đơn hàng có ngày đặt trong khoảng từ ngày và đến ngày là 
hai giá trị được nhập theo tham số của hàm */

go
create function C1_2 (@fday datetime, @sday datetime)
returns table
as
return ( select * from NHANVIEN as n join HOADON as h on n.MaNV = h.MaNV
where h.NgayHD between @fday and @sday)

select * from HoaDon
SELECT * from  dbo.C1_2('2019/11/11','2020/12/26')
/*C1.3. Liệt kê thông tin danh mục sản phẩm và sản phẩm có các sản phẩm có số lượng còn khoảng tối thiểu và tối đa 
là hai giá trị được nhập theo tham số của hàm*/
go
create function C1_3 (@num1 int, @num2 int)
returns table
as
return (select * from LOAIHANG as l join MATHANG as m on l.MaLH = m.MaLH
where m.SoLuongCon >= @num1 and m.SoLuongCon <= @num2)





/*C2. Function; multi-statement table-valued:*/
/*Tạo một hàm vô hướng để tính điểm thưởng theo ràng buộc dưới đây:
- Nếu tổng số tiền khách hàng đã trả cho tất cả các lần mua hàng dưới 2.000.000, thì trả về kết quả
là khách hàng được nhận 20 điểm thưởng.
- Nếu tổng số tiền khách hàng đã trả cho tất cả các lần mua hàng từ 2.000.000 trở đi, thì trả về kết quả
là khách hàng được nhận 50 điểm thưởng.
Sử dụng hàm vô hướng này trong cấu trúc điều kiện để liệt kê thông tin sau đây:
mã khách hàng, tên khách hàng, mã đơn hàng, ngày đặt, tổng tiền cho đơn hàng, điểm thưởng của khách hàng cho 100 
đơn hàng có tổng số tiền lớn nhất và trên mức tối thiểu, mức tối thiểu được nhập theo tham số của hàm.

*/
go
create function C2 (@makh nvarchar(255))
returns nvarchar(255)
as
begin
	declare @sum int
	set @sum = (select sum(c.ThanhTien) from NHANVIEN as n join HOADON as h on n.MaNV = h.MaNV
					join chitietdonhang as c on c.MaHD = h.MaHD
					where n.MaNV = @makh)
	if(@sum < 2000000) return N'khách hàng được nhận  20 điểm thưởng'
	else return N'khách hàng được nhân được 50 điểm thưởng'
end
/**/
/**/
/**/
/**/
/**/
/**/