USE IELTSFlow;
GO

IF OBJECT_ID('tempdb..#vars') IS NOT NULL DROP TABLE #vars;
CREATE TABLE #vars (name VARCHAR(100), id INT);
DELETE FROM #vars WHERE name='MockExamID';
INSERT INTO #vars (name, id) SELECT 'MockExamID', (SELECT ExamID FROM Exams WHERE Title = N'Sample IELTS Reading Mock Test');
DELETE FROM #vars WHERE name='PlacementExamID';
INSERT INTO #vars (name, id) SELECT 'PlacementExamID', (SELECT ExamID FROM Exams WHERE Title = N'Sample IELTS Reading Placement Test');

-- Đổi tên bài thi cho đúng ý nghĩa Full Test
UPDATE Exams SET Title = N'Sample IELTS Full Mock Test' WHERE ExamID = (SELECT id FROM #vars WHERE name='MockExamID');
UPDATE Exams SET Title = N'Sample IELTS Full Placement Test' WHERE ExamID = (SELECT id FROM #vars WHERE name='PlacementExamID');

-- =========================================================
-- LISTENING SECTION
-- =========================================================
INSERT INTO QuestionResource (ResourceAudioURL, Type) VALUES ('https://actions.google.com/sounds/v1/transportation/subway_train.ogg', 'Audio');
DELETE FROM #vars WHERE name='ResAudio';
INSERT INTO #vars (name, id) SELECT 'ResAudio', SCOPE_IDENTITY();

-- Tạo Section Listening cho cả 2 đề
INSERT INTO ExamSections (ExamID, Skill, SectionName, ResourceID, OrderIndex)
SELECT (SELECT id FROM #vars WHERE name='MockExamID'), 'Listening', 'Listening Part 1', (SELECT id FROM #vars WHERE name='ResAudio'), 4;

DELETE FROM #vars WHERE name='MockSecList';
INSERT INTO #vars (name, id) SELECT 'MockSecList', SCOPE_IDENTITY();
INSERT INTO ExamSections (ExamID, Skill, SectionName, ResourceID, OrderIndex)
SELECT (SELECT id FROM #vars WHERE name='PlacementExamID'), 'Listening', 'Listening Part 1', (SELECT id FROM #vars WHERE name='ResAudio'), 4;

DELETE FROM #vars WHERE name='PlaceSecList';
INSERT INTO #vars (name, id) SELECT 'PlaceSecList', SCOPE_IDENTITY();

DELETE FROM #vars WHERE name='QID';
INSERT INTO #vars (name, id) SELECT 'QID', 0;

INSERT INTO Questions (Content, QuestionType, Skill, Difficulty, contentJSON, ResourceID)
SELECT 'Listen to the conversation: What time is the flight?', 'Multiple_Choice', 'Listening', 'Medium', '{}', (SELECT id FROM #vars WHERE name='ResAudio');

DELETE FROM #vars WHERE name='QID';
INSERT INTO #vars (name, id) SELECT 'QID', SCOPE_IDENTITY();
INSERT INTO Answers (QuestionID, Content, IsCorrect, ContentJson) VALUES 
    ((SELECT id FROM #vars WHERE name='QID'), 'A. 9:00 AM', 1, '{}'), 
    ((SELECT id FROM #vars WHERE name='QID'), 'B. 10:00 AM', 0, '{}'), 
    ((SELECT id FROM #vars WHERE name='QID'), 'C. 11:00 AM', 0, '{}');
INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex)
SELECT (SELECT id FROM #vars WHERE name='MockSecList'), (SELECT id FROM #vars WHERE name='QID'), 41
UNION ALL SELECT (SELECT id FROM #vars WHERE name='PlaceSecList'), (SELECT id FROM #vars WHERE name='QID'), 41;


INSERT INTO Questions (Content, QuestionType, Skill, Difficulty, contentJSON, ResourceID)
SELECT 'Complete the sentence: The flight is delayed due to ____.', 'FillInBlanks', 'Listening', 'Hard', '{}', (SELECT id FROM #vars WHERE name='ResAudio');

DELETE FROM #vars WHERE name='QID';
INSERT INTO #vars (name, id) SELECT 'QID', SCOPE_IDENTITY();
INSERT INTO Answers (QuestionID, Content, IsCorrect, ContentJson)
SELECT (SELECT id FROM #vars WHERE name='QID'), 'bad weather', 1, '{}';

INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex)
SELECT (SELECT id FROM #vars WHERE name='MockSecList'), (SELECT id FROM #vars WHERE name='QID'), 42
UNION ALL SELECT (SELECT id FROM #vars WHERE name='PlaceSecList'), (SELECT id FROM #vars WHERE name='QID'), 42;


-- =========================================================
-- WRITING SECTION
-- =========================================================
INSERT INTO ExamSections (ExamID, Skill, SectionName, ResourceID, OrderIndex)
SELECT (SELECT id FROM #vars WHERE name='MockExamID'), 'Writing', 'Writing Task 1 & 2', NULL, 5;

DELETE FROM #vars WHERE name='MockSecWrit';
INSERT INTO #vars (name, id) SELECT 'MockSecWrit', SCOPE_IDENTITY();
INSERT INTO ExamSections (ExamID, Skill, SectionName, ResourceID, OrderIndex)
SELECT (SELECT id FROM #vars WHERE name='PlacementExamID'), 'Writing', 'Writing Task 1 & 2', NULL, 5;

DELETE FROM #vars WHERE name='PlaceSecWrit';
INSERT INTO #vars (name, id) SELECT 'PlaceSecWrit', SCOPE_IDENTITY();

INSERT INTO Questions (Content, QuestionType, Skill, Difficulty, contentJSON, ResourceID) VALUES ('Writing Task 1: The chart below shows the number of men and women in further education in Britain in three periods and whether they were studying full-time or part-time. Summarise the information by selecting and reporting the main features, and make comparisons where relevant. (Write at least 150 words)', 'Essay', 'Writing', 'Medium', '{}', NULL);
DELETE FROM #vars WHERE name='QID';
INSERT INTO #vars (name, id) SELECT 'QID', SCOPE_IDENTITY();
INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex)
SELECT (SELECT id FROM #vars WHERE name='MockSecWrit'), (SELECT id FROM #vars WHERE name='QID'), 43
UNION ALL SELECT (SELECT id FROM #vars WHERE name='PlaceSecWrit'), (SELECT id FROM #vars WHERE name='QID'), 43;


INSERT INTO Questions (Content, QuestionType, Skill, Difficulty, contentJSON, ResourceID) VALUES ('Writing Task 2: Some people believe that unpaid community service should be a compulsory part of high school programmes. To what extent do you agree or disagree? (Write at least 250 words)', 'Essay', 'Writing', 'Hard', '{}', NULL);
DELETE FROM #vars WHERE name='QID';
INSERT INTO #vars (name, id) SELECT 'QID', SCOPE_IDENTITY();
INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex)
SELECT (SELECT id FROM #vars WHERE name='MockSecWrit'), (SELECT id FROM #vars WHERE name='QID'), 44
UNION ALL SELECT (SELECT id FROM #vars WHERE name='PlaceSecWrit'), (SELECT id FROM #vars WHERE name='QID'), 44;


-- =========================================================
-- SPEAKING SECTION
-- =========================================================
INSERT INTO ExamSections (ExamID, Skill, SectionName, ResourceID, OrderIndex)
SELECT (SELECT id FROM #vars WHERE name='MockExamID'), 'Speaking', 'Speaking Part 1, 2 & 3', NULL, 6;

DELETE FROM #vars WHERE name='MockSecSpeak';
INSERT INTO #vars (name, id) SELECT 'MockSecSpeak', SCOPE_IDENTITY();
INSERT INTO ExamSections (ExamID, Skill, SectionName, ResourceID, OrderIndex)
SELECT (SELECT id FROM #vars WHERE name='PlacementExamID'), 'Speaking', 'Speaking Part 1, 2 & 3', NULL, 6;

DELETE FROM #vars WHERE name='PlaceSecSpeak';
INSERT INTO #vars (name, id) SELECT 'PlaceSecSpeak', SCOPE_IDENTITY();

INSERT INTO Questions (Content, QuestionType, Skill, Difficulty, contentJSON, ResourceID) VALUES ('Speaking Part 1: Let''s talk about your hometown. Where is your hometown? What do you like most about it?', 'Speaking', 'Speaking', 'Easy', '{}', NULL);
DELETE FROM #vars WHERE name='QID';
INSERT INTO #vars (name, id) SELECT 'QID', SCOPE_IDENTITY();
INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex)
SELECT (SELECT id FROM #vars WHERE name='MockSecSpeak'), (SELECT id FROM #vars WHERE name='QID'), 45
UNION ALL SELECT (SELECT id FROM #vars WHERE name='PlaceSecSpeak'), (SELECT id FROM #vars WHERE name='QID'), 45;


INSERT INTO Questions (Content, QuestionType, Skill, Difficulty, contentJSON, ResourceID) VALUES ('Speaking Part 2: Describe a book that had a major influence on you. You should say: what the book is, how you found it, what it is about, and explain why it had such an influence on you.', 'Speaking', 'Speaking', 'Medium', '{}', NULL);
DELETE FROM #vars WHERE name='QID';
INSERT INTO #vars (name, id) SELECT 'QID', SCOPE_IDENTITY();
INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex)
SELECT (SELECT id FROM #vars WHERE name='MockSecSpeak'), (SELECT id FROM #vars WHERE name='QID'), 46
UNION ALL SELECT (SELECT id FROM #vars WHERE name='PlaceSecSpeak'), (SELECT id FROM #vars WHERE name='QID'), 46;


GO
