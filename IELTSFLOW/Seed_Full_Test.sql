USE IELTSFlow;
GO

-- Ẩn bài test cũ đi để hệ thống chắc chắn random trúng bài mới này
UPDATE Exams SET Deleted = 1 WHERE Type = 'Placement Test';

DECLARE @ExamID INT;
DECLARE @SectionID INT;
DECLARE @ResourceID INT;
DECLARE @QuestionID INT;

-- ==========================================
-- 1. TẠO VỎ ĐỀ THI (ALL SKILLS)
-- ==========================================
INSERT INTO Exams (Title, Type, SkillFocus, Duration, MentorID, CreatedAt, Deleted) 
VALUES (N'IELTS Full Placement Test - Đề chuẩn', 'Placement Test', 'All', 120, 2, GETDATE(), 0); 
SET @ExamID = SCOPE_IDENTITY();

-- ==========================================
-- PHẦN 1: LISTENING
-- ==========================================
INSERT INTO ExamSections (ExamID, SectionName, OrderIndex, Skill) 
VALUES (@ExamID, 'Listening - Part 1', 1, 'Listening');
SET @SectionID = SCOPE_IDENTITY();

-- Tạo Audio ảo
INSERT INTO QuestionResource (ResourceName, ResourceAudioURL, Type, CreatedBy) 
VALUES (N'Audio Hội thoại mẫu', 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3', 'Audio', 2);
SET @ResourceID = SCOPE_IDENTITY();

-- Câu hỏi Listening
INSERT INTO Questions (ResourceID, Content, QuestionType, Skill, Difficulty, OrderInResource, contentJSON, CreatedBy) 
VALUES (@ResourceID, N'Người đàn ông trong đoạn băng muốn đặt vé đi đâu?', 'Multiple_Choice', 'Listening', 'Medium', 1, '{}', 2);
SET @QuestionID = SCOPE_IDENTITY();
INSERT INTO Answers (QuestionID, Content, ContentJson, IsCorrect) VALUES 
(@QuestionID, N'London', '{}', 1), (@QuestionID, N'Paris', '{}', 0), (@QuestionID, N'New York', '{}', 0), (@QuestionID, N'Tokyo', '{}', 0);
INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex) VALUES (@SectionID, @QuestionID, 1);

-- ==========================================
-- PHẦN 2: READING
-- ==========================================
INSERT INTO ExamSections (ExamID, SectionName, OrderIndex, Skill) 
VALUES (@ExamID, 'Reading - Passage 1', 2, 'Reading');
SET @SectionID = SCOPE_IDENTITY();

-- Tạo đoạn văn Reading
INSERT INTO QuestionResource (ResourceName, ResourceText, Type, CreatedBy) 
VALUES (N'Đoạn văn Khí hậu', N'Biến đổi khí hậu đang là vấn đề cấp bách toàn cầu. Mực nước biển dâng cao đe dọa nhiều thành phố ven biển. Cần có biện pháp giảm thiểu khí thải nhà kính ngay lập tức.', 'Passage', 2);
SET @ResourceID = SCOPE_IDENTITY();

-- Câu hỏi Reading
INSERT INTO Questions (ResourceID, Content, QuestionType, Skill, Difficulty, OrderInResource, contentJSON, CreatedBy) 
VALUES (@ResourceID, N'Theo đoạn văn, mối đe dọa chính đối với các thành phố ven biển là gì?', 'Multiple_Choice', 'Reading', 'Medium', 1, '{}', 2);
SET @QuestionID = SCOPE_IDENTITY();
INSERT INTO Answers (QuestionID, Content, ContentJson, IsCorrect) VALUES 
(@QuestionID, N'Mực nước biển dâng cao', '{}', 1), (@QuestionID, N'Khí thải nhà kính', '{}', 0), (@QuestionID, N'Sự nóng lên của trái đất', '{}', 0), (@QuestionID, N'Bão nhiệt đới', '{}', 0);
INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex) VALUES (@SectionID, @QuestionID, 1);

-- ==========================================
-- PHẦN 3: WRITING
-- ==========================================
INSERT INTO ExamSections (ExamID, SectionName, OrderIndex, Skill) 
VALUES (@ExamID, 'Writing - Task 2', 3, 'Writing');
SET @SectionID = SCOPE_IDENTITY();

-- Câu hỏi Writing (Tự luận)
INSERT INTO Questions (ResourceID, Content, QuestionType, Skill, Difficulty, OrderInResource, contentJSON, CreatedBy) 
VALUES (NULL, N'You should spend about 40 minutes on this task. Write about the following topic: Some people believe that university education should be free for everyone. To what extent do you agree or disagree?', 'Essay', 'Writing', 'Hard', 1, '{}', 2);
SET @QuestionID = SCOPE_IDENTITY();
INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex) VALUES (@SectionID, @QuestionID, 1);

-- ==========================================
-- PHẦN 4: SPEAKING
-- ==========================================
INSERT INTO ExamSections (ExamID, SectionName, OrderIndex, Skill) 
VALUES (@ExamID, 'Speaking - Part 2', 4, 'Speaking');
SET @SectionID = SCOPE_IDENTITY();

-- Câu hỏi Speaking (Nói)
INSERT INTO Questions (ResourceID, Content, QuestionType, Skill, Difficulty, OrderInResource, contentJSON, CreatedBy) 
VALUES (NULL, N'Describe a book that you enjoyed reading. You should say: what it is, what it is about, and why you liked it.', 'Speaking', 'Speaking', 'Medium', 1, '{}', 2);
SET @QuestionID = SCOPE_IDENTITY();
INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex) VALUES (@SectionID, @QuestionID, 1);

GO
