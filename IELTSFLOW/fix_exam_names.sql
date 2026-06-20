USE IELTSFlow;
GO

-- Fix corrupted Vietnamese characters for Exams
UPDATE Exams 
SET Title = N'Placement Test Đánh Giá Đầu Vào' 
WHERE Title LIKE 'Placement Test %' OR Title LIKE 'Placement Test ????nh Gi?? ?????u%';

UPDATE Exams 
SET Title = N'Mock Test Luyện Đề Tổng Hợp' 
WHERE Title LIKE 'Mock Test Luy%' OR Title LIKE 'Mock Test Luy???n ????? T???ng H%';

PRINT 'Cập nhật thành công các tên đề thi bị lỗi font trong database!';
GO
