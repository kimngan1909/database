CREATE DATABASE De2


create table PhiCong
(
  MaPC varchar(20) primary key,
  TenPC varchar(30) not null,
  TrinhDo varchar(30) not null,
  NamKN int not null
)
create table LichTrinhBay
(
  MaLT varchar(20) primary key,
  SoHieuMB varchar(20) not null,
  MaPC varchar(20) not null,
  NoiDi varchar(30) not null,
  NoiDen varchar(30) not null,
  ThoiGianDi smalldatetime not null,
  ThoiGianDen smalldatetime not null,
)
create table MayBay
(
  SoHieuMB varchar(20) primary key,
  MaLoai varchar(20) not null,
  NgayBatDauSD date not null
)
create table LoaiMayBay
(
  MaLoai varchar(20) primary key,
  LoaiMB varchar(30) not null,
  DongCo varchar(30) not null,
  TocDoToiThieu varchar(30) not null,
  TocDoToiDa varchar(30) not null
)
alter table LichTrinhBay
add foreign key (MaPC) references dbo.PhiCong(MaPC)
alter table LichTrinhBay
add foreign key (SoHieuMB) references dbo.MayBay(SoHieuMB)
alter table MayBay
add foreign key (MaLoai) references dbo.LoaiMayBay(MaLoai)

insert into LoaiMayBay values
('L01',	'Boeing 747',	'tuoc bin canh quat',	'1000km/h',	'3000km/h'),
('L02','A321',	'tuoc bin phan luc',	'1500km/h',	'3200km/h'),
('L03',	'Boeing 737',	'tuoc bin roc ket',	'1100km/h',	'2500km/h')
insert into MayBay values
('VN01',	'L01',	'05-20-15'),
('JS02',	'L01',	'05-21-15'),
('AS01',	'L02',	'05-22-15')
insert into PhiCong values

('PC01',	'Tran Dinh Nam',	'Co Pho',	3),
('PC02',	'jonh henry',	'Co Truong',	8)
insert into LichTrinhBay values
('LT001',	'VN01',	'PC02',	'Ha Noi',	'Da Nang',	'05-20-15 14:00',	'05-20-15 16:00'),
('LT002',	'AS01',	'PC01',	'Da Nang',	'Thai Lan',	'04-13-15 08:00',	'04-13-15 13:00')



	  /*Câu 1: Thực hiện yêu cầu sau:
a. Tạo khung nhìn có tên là V_MayBay để thấy được thông tin của tất cả máy bay có tốc
độ tối thiểu lớn hơn 1100km/h và được bắt đầu sử dụng từ ngày 01/01/2014. (1 điểm)
b. Thông qua khung nhìn V_MayBay thực hiện việc cập ngày bắt đầu sử dụng thành
01/31/2014 đối với những máy bay có ngày bắt đầu sử dụng là 02/28/2014. (1 điểm)*/
--a
Create View V_MayBay as 
      select l.*,m.NgayBatDauSD,m.SoHieuMB from LoaiMayBay l join MayBay m on l.MaLoai = m.MaLoai
	  where l.TocDoToiThieu > '1100km/h' and m.NgayBatDauSD >= '2014/01/01'
	  
--b:
update V_MayBay
set NgayBatDauSD = '2014/01/31'
where NgayBatDauSD = '2014/02/28'

/*
Câu 2: Tạo 2 thủ tục (Stored Procedure):
a. Thủ tục Sp_1: Dùng để xóa thông tin của những phi công có mã phi công được truyền
vào như một tham số của thủ tục. (1 điểm)
b. Thủ tục Sp_2: Dùng để bổ sung thêm bản ghi mới vào bảng LICHTRINHBAY (Sp_2
phải thực hiện kiểm tra tính hợp lệ của dữ liệu được bổ sung là không trùng khóa
chính và đảm bảo toàn vẹn tham chiếu đến các bảng có liên quan). (1 điểm)*/
--a

go 

create proc Sp_1 
  @MaPC varchar(20) 
as
  begin
    delete from PhiCong where MaPC = @MaPC
  end

exec Sp_1 'PC01'--Thực thi

go
--b
create proc Sp_2
 (
	 @MaLT varchar(20) ,
     @SoHieuMB varchar(20) ,
     @MaPC varchar(20) ,
     @NoiDi varchar(30),
     @NoiDen varchar(30),
     @ThoiGianDi smalldatetime ,
     @ThoiGianDen smalldatetime
 )
 as
 begin
	if exists (select SoHieuMB from MayBay  where SoHieuMB=@SoHieuMB) and exists (select MaPC from PhiCong where MaPC=@MaPC)
	begin
		if exists (select MaLT from LichTrinhBay where MaLT = @MaLT)
		begin
			print 'khoá chính bị trùng'
			
		end
		else insert into LichTrinhBay values(@MaLT,@SoHieuMB,@MaPC,@NoiDi,@NoiDen,@ThoiGianDi,@ThoiGianDen)
	end
	else
	begin
		print 'không tồn tại dữ liệu'
		
	end
 end
 exec Sp_2 'LT0004',	'VN01',	'PC02',	'Ha Noi',	'Nha Trang',	'05-20-15 14:00',	'05-20-15 16:00' --> câu lệnh được insert
 exec Sp_2 'LT002',	'VN01',	'PC02',	'Ha Noi',	'Nha Trang',	'05-20-15 14:00',	'05-20-15 16:00' --> khóa chính bị lặp
 exec Sp_2 'LT004',	'VN05',	'PC02',	'Ha Noi',	'Nha Trang',	'05-20-15 14:00',	'05-20-15 16:00' --> không tồn tại dữ liệu


 /*Câu 3: Viết 2 bẫy sự kiện (trigger) cho bảng LICHTRINHBAY theo yêu cầu sau:
a. Trigger_1: Khi thực hiện thêm một lịch trình bay cho một máy bay bất kỳ thì kiểm
tra dữ liệu nơi đi phải khác nơi đến, nếu không hợp lệ thì hiển thị thông báo "Dữ liệu
nơi đi phải khác nơi đến của cùng một chuyến bay" và quay lui (rollback) giao tác.
Bẫy sự kiện chỉ xử lý 1 bản ghi. (1 điểm)
b. Trigger_2: Khi cập nhập lại thời gian đi (tức là thời gian cất cánh), kiểm tra thời gian
cập nhật có phù hợp hay không (thời gian đi phải nhỏ hơn thời gian đến). Nếu dữ liệu
hợp lệ thì cho phép cập nhật, nếu không hiển thị thông báo "thời gian đi phải nhỏ hơn
thời gian đến ít nhất là 30 phút" và thực hiện quay lui giao tác. (1 điểm)*/
go
create trigger Trigger_1
on LichTrinhBay
for insert 
as
 declare @NoiDi  varchar(20)
 declare @NoiDen varchar(20)
 declare @MaLT varchar(20)

 select @NoiDi= NoiDi, @NoiDen= NoiDen
 from inserted
 
 
 if @NoiDi = @NoiDen
       begin
		print N'Dữ liệu nơi đi phải khác nơi đến của cùng một chuyến bay'
		rollback tran
	   end
 else
update LichTrinhBay
 set NoiDen=@NoiDen
 where NoiDi= @NoiDi
 
 insert into LichTrinhBay values
('LT007',	'VN01',	'PC02',	'Ha Noi',	'Ha Noi',	'05-20-15 14:00',	'05-20-15 19:00')--> k insert dc
insert into LichTrinhBay values
('LT007',	'VN01',	'PC02',	'Ha Noi',	'Da Nang',	'05-20-15 14:00',	'05-20-15 16:00')--> dc insert 


 go
--b
create trigger Trigger_2
on LichTrinhBay
for insert 
as
 declare @ThoiGianDi  smalldatetime
 declare @ThoiGianDen smalldatetime
 declare @MaLT varchar(20)

 select @ThoiGianDi= ThoiGianDi, @ThoiGianDen= ThoiGianDen
 from inserted
 select @ThoiGianDen = @ThoiGianDi
 from LichTrinhBay where MaLT=@MaLT
 
 if @ThoiGianDi >= @ThoiGianDen
       begin
		print N'thời gian đi phải nhỏ hơn thời gian đến ít nhất là 30 phút'
		rollback tran
	   end
 else
update LichTrinhBay
 set ThoiGianDen=@ThoiGianDen
 where ThoiGianDi= @ThoiGianDi


 insert into LichTrinhBay values
('LT006',	'VN01',	'PC02',	'Ha Noi',	'Da Nang',	'05-20-15 14:00',	'05-20-15 14:00')--> k insert dc
insert into LichTrinhBay values
('LT006',	'VN01',	'PC02',	'Ha Noi',	'Da Nang',	'05-20-15 14:00',	'05-20-15 16:00')--> dc insert 
select * from LichTrinhBay

go

/*Câu 4: Tạo hàm do người dùng định nghĩa (user-defined function) để tính chi phí bảo trì
cho cả năm 2015. Mã máy bay sẽ được truyền vào thông qua tham số đầu vào của hàm. Cụ
thể như sau:
- Nếu tổng số lần bay của máy bay dưới 25 lần, thì kết quả là chi phí bảo trì được trả
5.000.000 trên mỗi tháng trong năm. (1 điểm)
- Nếu tổng số lần bay của máy bay từ 25 lần trở lên, thì kết quả là chi phí bảo trì được
trả 10.000.000 trên mỗi tháng trong năm. (1 điểm)
*/
create function user_defined(@SoHieuMB nvarchar(50))
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

