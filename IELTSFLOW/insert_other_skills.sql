USE IELTSFlow;
GO

DECLARE @MockExamID INT = (SELECT ExamID FROM Exams WHERE Title = N'Sample IELTS Reading Mock Test');
DECLARE @PlacementExamID INT = (SELECT ExamID FROM Exams WHERE Title = N'Sample IELTS Reading Placement Test');

-- Đổi tên bài thi cho đúng ý nghĩa Full Test
UPDATE Exams SET Title = N'Sample IELTS Full Mock Test' WHERE ExamID = @MockExamID;
UPDATE Exams SET Title = N'Sample IELTS Full Placement Test' WHERE ExamID = @PlacementExamID;

-- =========================================================
-- LISTENING SECTION
-- =========================================================
INSERT INTO QuestionResource (ResourceAudioURL, Type) VALUES ('https://actions.google.com/sounds/v1/transportation/subway_train.ogg', 'Audio');
DECLARE @ResAudio INT = SCOPE_IDENTITY();

-- Tạo Section Listening cho cả 2 đề
INSERT INTO ExamSections (ExamID, SectionName, ResourceID, OrderIndex) VALUES (@MockExamID, 'Listening Part 1', @ResAudio, 4);
DECLARE @MockSecList INT = SCOPE_IDENTITY();
INSERT INTO ExamSections (ExamID, SectionName, ResourceID, OrderIndex) VALUES (@PlacementExamID, 'Listening Part 1', @ResAudio, 4);
DECLARE @PlaceSecList INT = SCOPE_IDENTITY();

DECLARE @QID INT;

INSERT INTO Questions (Content, QuestionType, Skill, Difficulty, contentJSON, ResourceID) VALUES ('Listen to the conversation: What time is the flight?', 'Multiple_Choice', 'Listening', 'Medium', '{}', @ResAudio);
SET @QID = SCOPE_IDENTITY();
INSERT INTO Answers (QuestionID, Content, IsCorrect, ContentJson) VALUES 
    (@QID, 'A. 9:00 AM', 1, '{}'), 
    (@QID, 'B. 10:00 AM', 0, '{}'), 
    (@QID, 'C. 11:00 AM', 0, '{}');
INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex) VALUES (@MockSecList, @QID, 41), (@PlaceSecList, @QID, 41);

INSERT INTO Questions (Content, QuestionType, Skill, Difficulty, contentJSON, ResourceID) VALUES ('Complete the sentence: The flight is delayed due to ____.', 'FillInBlanks', 'Listening', 'Hard', '{}', @ResAudio);
SET @QID = SCOPE_IDENTITY();
INSERT INTO Answers (QuestionID, Content, IsCorrect, ContentJson) VALUES (@QID, 'bad weather', 1, '{}');
INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex) VALUES (@MockSecList, @QID, 42), (@PlaceSecList, @QID, 42);

-- =========================================================
-- WRITING SECTION
-- =========================================================
INSERT INTO ExamSections (ExamID, SectionName, ResourceID, OrderIndex) VALUES (@MockExamID, 'Writing Task 1 & 2', NULL, 5);
DECLARE @MockSecWrit INT = SCOPE_IDENTITY();
INSERT INTO ExamSections (ExamID, SectionName, ResourceID, OrderIndex) VALUES (@PlacementExamID, 'Writing Task 1 & 2', NULL, 5);
DECLARE @PlaceSecWrit INT = SCOPE_IDENTITY();

INSERT INTO Questions (Content, QuestionType, Skill, Difficulty, contentJSON, ResourceID) VALUES ('Writing Task 1: The chart below shows the number of men and women in further education in Britain in three periods and whether they were studying full-time or part-time. Summarise the information by selecting and reporting the main features, and make comparisons where relevant. (Write at least 150 words)', 'Essay', 'Writing', 'Medium', '{}', NULL);
SET @QID = SCOPE_IDENTITY();
INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex) VALUES (@MockSecWrit, @QID, 43), (@PlaceSecWrit, @QID, 43);

INSERT INTO Questions (Content, QuestionType, Skill, Difficulty, contentJSON, ResourceID) VALUES ('Writing Task 2: Some people believe that unpaid community service should be a compulsory part of high school programmes. To what extent do you agree or disagree? (Write at least 250 words)', 'Essay', 'Writing', 'Hard', '{}', NULL);
SET @QID = SCOPE_IDENTITY();
INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex) VALUES (@MockSecWrit, @QID, 44), (@PlaceSecWrit, @QID, 44);

-- =========================================================
-- SPEAKING SECTION
-- =========================================================
INSERT INTO ExamSections (ExamID, SectionName, ResourceID, OrderIndex) VALUES (@MockExamID, 'Speaking Part 1, 2 & 3', NULL, 6);
DECLARE @MockSecSpeak INT = SCOPE_IDENTITY();
INSERT INTO ExamSections (ExamID, SectionName, ResourceID, OrderIndex) VALUES (@PlacementExamID, 'Speaking Part 1, 2 & 3', NULL, 6);
DECLARE @PlaceSecSpeak INT = SCOPE_IDENTITY();

INSERT INTO Questions (Content, QuestionType, Skill, Difficulty, contentJSON, ResourceID) VALUES ('Speaking Part 1: Let''s talk about your hometown. Where is your hometown? What do you like most about it?', 'Speaking', 'Speaking', 'Easy', '{}', NULL);
SET @QID = SCOPE_IDENTITY();
INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex) VALUES (@MockSecSpeak, @QID, 45), (@PlaceSecSpeak, @QID, 45);

INSERT INTO Questions (Content, QuestionType, Skill, Difficulty, contentJSON, ResourceID) VALUES ('Speaking Part 2: Describe a book that had a major influence on you. You should say: what the book is, how you found it, what it is about, and explain why it had such an influence on you.', 'Speaking', 'Speaking', 'Medium', '{}', NULL);
SET @QID = SCOPE_IDENTITY();
INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex) VALUES (@MockSecSpeak, @QID, 46), (@PlaceSecSpeak, @QID, 46);

GO
