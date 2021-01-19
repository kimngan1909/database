CREATE DATABASE LichTrinhBay


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

--Câu 1: Liệt kê thông tin toàn bộ máy bay.
      select * from MayBay
--Câu 2: Xoá toàn bộ máy bay sử dụng động cơ là 'tuoc bin rocket'.
      delete from MayBay where MaLoai In (select MaLoai from LoaiMayBay where DongCo = 'tuoc bin roc ket')
	  
--Câu 3: Cập nhật giá trị của trường NamKN trong bảng PHICONG thành 5 nếu trường NamKN đang có giá trị là 3.
      update PhiCong set NamKN = 5
	  where NamKN = 3
/*Câu 4: Liệt kê thông tin của những máy bay thuộc loại 'Boeing 747' được bắt đầu sử dụng từ ngày 01/01/2014 
và những máy bay thuộc loại 'A321' được bắt đầu sử dụng trước ngày 12/31/2014.*/
      select MayBay.* from MayBay join LoaiMayBay on MayBay.MaLoai = LoaiMayBay.MaLoai
	  where (LoaiMayBay.LoaiMB = 'Boeing 747' and day(MayBay.NgayBatDauSD) > 01/01/2014 )
	  or  (LoaiMayBay.LoaiMB = 'A321' and day(MayBay.NgayBatDauSD) < 12/31/2014 )

--Câu 5: Liệt kê những phi công có tên bắt đầu là ký tự 'N' và có độ dài là 7 ký tự.
      select * from PhiCong
	  where TenPC  Like'N%' and len(TenPC)  = 7

--Câu 6: Liệt kê toàn bộ máy bay, sắp xếp giảm dần theo MaLoai và tăng dần theo NgayBatDauSD.
      select * from MayBay 
	  order by MaLoai desc,NgayBatDauSD 

--Câu 7: Đếm số lần bay tương ứng theo từng phi công, chỉ đếm các lần bay được thực hiện bay trong năm 2014.
     select  MaPC,count(MaLT) as số_lần_bay from LichTrinhBay
	 where YEAR(ThoiGianDi) = 2014
	 group by MaPC
	
--Câu 8: Liệt kê tên của toàn bộ phi công (tên nào giống nhau thì chỉ liệt kê một lần).
     select distinct TenPC FROM PhiCong 
	
--Câu 9: Liệt kê SoHieu, MaLoai, TenPC, NoiDi, NoiDen, ThoiGianDi, ThoiGianDen (của tất cả các lần bay của các máy bay).
     select m.SoHieuMB, m.MaLoai, p.TenPC, l.NoiDi,l.NoiDen,l.ThoiGianDi,l.ThoiGianDen
	 from MayBay m join LichTrinhBay l On m.SoHieuMB=l.SoHieuMB
	 join PhiCong p On l.MaPC = p.MaPC 

/*Câu 10: Liệt kê SoHieu, MaLoai, TenPC, NoiDi, NoiDen, ThoiGianDi, ThoiGianDen
của tất cả các lần bay của máy bay (Liệt kê cả những máy bay chưa được bay lần nào).*/
     select m.SoHieuMB, m.MaLoai, p.TenPC, l.NoiDi,l.NoiDen,l.ThoiGianDi,l.ThoiGianDen
	 from MayBay m left join LichTrinhBay l On m.SoHieuMB=l.SoHieuMB
	 left join PhiCong p On l.MaPC = p.MaPC 

/*Câu 11: Liệt kê SoHieu, MaLoai của những máy bay đã thực hiện bay với 
điểm xuất phát từ sân bay 'Ha noi' hoặc thuộc loại máy bay là 'Boeing 747*/
     select m.SoHieuMB, m.MaLoai
	 from MayBay m join LichTrinhBay l On m.SoHieuMB=l.SoHieuMB
	 join LoaiMayBay  On LoaiMayBay.MaLoai= m.MaLoai 
	 where l.NoiDi = 'Ha Noi' or LoaiMayBay.LoaiMB = 'Boeing 747'

--Câu 12: Liệt kê SoHieu, MaLoai của những máy bay chưa từng thực hiện bay lần nào.
 /* cách 1 */ 
     select SoHieuMB, MaLoai from MayBay
	 where SoHieuMB not in (Select SoHieuMB from LichTrinhBay)
/* cách 2 */ 	 
	  select m.SoHieuMB, m.MaLoai from MayBay m full join LichTrinhBay on m.SoHieuMB= LichTrinhBay.SoHieuMB
	  where MaLT is null

/*Câu 13: Liệt kê SoHieu, MaLoai của những máy bay đã từng thực hiện bay với điểm xuất phát từ sân bay 'Ha noi' 
và chưa từng thực hiện bay lần nào với điểm xuất phát là sân bay 'Thanh pho Ho Chi Minh'.*/

		 select SoHieuMB,MaLoai from MayBay
		 where SoHieuMB in (select SoHieuMB from LichTrinhBay where NoiDi = 'Ha Noi')
		 and  SoHieuMB not in (select SoHieuMB from LichTrinhBay where NoiDi = 'Thanh pho Ho Chi Minh')
    
/*Câu 14: Liệt kê SoHieu, MaLoai, TenPC, NoiDi, NoiDen, ThoiGianDi, ThoiGianDen, TenPC của những máy bay thuộc loại 'A321' 
và chỉ mới thực hiện bay một lần duy nhất. Kết quả liệt kê sắp xếp tăng dần theo ThoiGianDi*/
      select m.SoHieuMB, m.MaLoai, p.TenPC, l.NoiDi,l.NoiDen,l.ThoiGianDi,l.ThoiGianDen
	  from MayBay m join LichTrinhBay l On m.SoHieuMB=l.SoHieuMB
	  join PhiCong p On l.MaPC = p.MaPC 
	  join LoaiMayBay On LoaiMayBay.MaLoai = m.MaLoai
	  where LoaiMayBay.LoaiMB = 'A321'   
	  group by  m.SoHieuMB, m.MaLoai, p.TenPC, l.NoiDi,l.NoiDen,l.ThoiGianDi,l.ThoiGianDen
	  having count(l.MaLT)=1
	  order by l.ThoiGianDi asc

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
create proc Sp_1 
  @MaPC varchar(20) 
as
  begin
    delete from PhiCong where MaPC = @MaPC
  end

exec Sp_1 'PC01'--Thực thi

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
 exec Sp_2 'LT004',	'VN01',	'PC02',	'Ha Noi',	'Nha Trang',	'05-20-15 14:00',	'05-20-15 16:00' --> câu lệnh được insert
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
thời gian đến ít nhất là 30 phút" và thực hiện quay lui giao tác. (1 điểm)
Câu 4: Tạo hàm do người dùng định nghĩa (user-defined function) để tính chi phí bảo trì
cho cả năm 2015. Mã máy bay sẽ được truyền vào thông qua tham số đầu vào của hàm. Cụ
thể như sau:
- Nếu tổng số lần bay của máy bay dưới 25 lần, thì kết quả là chi phí bảo trì được trả
5.000.000 trên mỗi tháng trong năm. (1 điểm)
- Nếu tổng số lần bay của máy bay từ 25 lần trở lên, thì kết quả là chi phí bảo trì được
trả 10.000.000 trên mỗi tháng trong năm. (1 điểm)
Câu 5: Tạo thủ tục Sp_PhiCong tìm những phi công đã từng thực hiện lái một chuyến bay
bất kỳ (nghĩa là có lưu trữ thông tin của phi công trong bảng LICHTRINHBAY) để xóa
thông tin về những phi công đó trong bảng PHICONG và xóa thông tin về những
chuyến bay của những phi công đó (tức là phải xóa những bản ghi trong bảng LICHTRINHBAY có liên quan). (2 điểm)