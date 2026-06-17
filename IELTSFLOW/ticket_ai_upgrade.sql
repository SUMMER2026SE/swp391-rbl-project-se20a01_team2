-- Chạy script này trong SQL Server để thêm các cột phục vụ tính năng AI Pre-screening cho Ticket

ALTER TABLE Tickets ADD TicketType NVARCHAR(50) DEFAULT 'General';
ALTER TABLE Tickets ADD MediaUrl NVARCHAR(MAX) NULL;
ALTER TABLE Tickets ADD Transcript NVARCHAR(MAX) NULL;
ALTER TABLE Tickets ADD AIReport NVARCHAR(MAX) NULL;

-- Cập nhật các bản ghi cũ nếu cần thiết
UPDATE Tickets SET TicketType = 'General' WHERE TicketType IS NULL;
