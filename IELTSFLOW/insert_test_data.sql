USE IELTSFlow;
GO

DELETE FROM ExamQuestions WHERE QuestionID IN (SELECT QuestionID FROM Questions WHERE Content LIKE 'What is the capital of France%' OR Content LIKE 'Listen and choose%');
DELETE FROM Answers WHERE QuestionID IN (SELECT QuestionID FROM Questions WHERE Content LIKE 'What is the capital of France%' OR Content LIKE 'Listen and choose%');
DELETE FROM Questions WHERE Content LIKE 'What is the capital of France%' OR Content LIKE 'Listen and choose%' OR Content LIKE 'Write an essay%' OR Content LIKE 'Describe a memorable trip%' OR Content LIKE 'Read the passage%' OR Content LIKE 'Listen to the conversation%' OR Content LIKE 'Task 1: Summarize%' OR Content LIKE 'Part 2: Describe a book%';
DELETE FROM ExamSections WHERE SectionName IN ('Placement Section', 'Mock Section');
DELETE FROM Exams WHERE Title IN (N'Placement Test Đánh Giá Đầu Vào', N'Mock Test Luyện Đề Tổng Hợp');
GO

-- 1. Insert Exams
INSERT INTO Exams (Title, Type, SkillFocus, Duration, MentorID, CreatedAt, Deleted)
VALUES 
(N'Placement Test Đánh Giá Đầu Vào', 'Placement Test', 'All', 45, 1, GETDATE(), 0),
(N'Mock Test Luyện Đề Tổng Hợp', 'Mock Test', 'All', 120, 1, GETDATE(), 0);

IF OBJECT_ID('tempdb..#vars') IS NOT NULL DROP TABLE #vars;
CREATE TABLE #vars (name VARCHAR(100), id INT);
DELETE FROM #vars WHERE name='PlacementExamID';
INSERT INTO #vars (name, id) SELECT 'PlacementExamID', (SELECT ExamID FROM Exams WHERE Title = N'Placement Test Đánh Giá Đầu Vào');
DELETE FROM #vars WHERE name='MockExamID';
INSERT INTO #vars (name, id) SELECT 'MockExamID', (SELECT ExamID FROM Exams WHERE Title = N'Mock Test Luyện Đề Tổng Hợp');

-- 2. Insert ExamSections for Placement Test
INSERT INTO ExamSections (ExamID, Skill, SectionName, OrderIndex)
SELECT (SELECT id FROM #vars WHERE name='PlacementExamID'), 'Listening', 'Placement Section', 1;

DELETE FROM #vars WHERE name='PlacementSectionID';
INSERT INTO #vars (name, id) SELECT 'PlacementSectionID', SCOPE_IDENTITY();

-- Insert Questions for Placement Test
INSERT INTO Questions (Content, QuestionType, Skill, Difficulty, contentJSON, CreatedBy) VALUES ('What is the capital of France?', 'Multiple_Choice', 'Reading', 'Easy', '{}', 1);
DELETE FROM #vars WHERE name='Q1';
INSERT INTO #vars (name, id) SELECT 'Q1', SCOPE_IDENTITY();
INSERT INTO Answers (QuestionID, Content, IsCorrect, ContentJson)
SELECT (SELECT id FROM #vars WHERE name='Q1'), 'Paris', 1, '{}'
UNION ALL SELECT (SELECT id FROM #vars WHERE name='Q1'), 'London', 0, '{}'
UNION ALL SELECT (SELECT id FROM #vars WHERE name='Q1'), 'Berlin', 0, '{}';


INSERT INTO QuestionResource (ResourceAudioURL, Type) VALUES ('https://actions.google.com/sounds/v1/water/rain_on_roof.ogg', 'Audio');
DELETE FROM #vars WHERE name='Res1';
INSERT INTO #vars (name, id) SELECT 'Res1', SCOPE_IDENTITY();
INSERT INTO Questions (Content, QuestionType, Skill, Difficulty, contentJSON, ResourceID, CreatedBy)
SELECT 'Listen and choose: The boy is going to...', 'Multiple_Choice', 'Listening', 'Easy', '{}', (SELECT id FROM #vars WHERE name='Res1'), 1;

DELETE FROM #vars WHERE name='Q2';
INSERT INTO #vars (name, id) SELECT 'Q2', SCOPE_IDENTITY();
INSERT INTO Answers (QuestionID, Content, IsCorrect, ContentJson)
SELECT (SELECT id FROM #vars WHERE name='Q2'), 'The market', 1, '{}'
UNION ALL SELECT (SELECT id FROM #vars WHERE name='Q2'), 'The school', 0, '{}'
UNION ALL SELECT (SELECT id FROM #vars WHERE name='Q2'), 'The park', 0, '{}';


INSERT INTO Questions (Content, QuestionType, Skill, Difficulty, contentJSON, CreatedBy) VALUES ('Write an essay about the importance of learning English.', 'Essay', 'Writing', 'Medium', '{}', 1);
DELETE FROM #vars WHERE name='Q3';
INSERT INTO #vars (name, id) SELECT 'Q3', SCOPE_IDENTITY();

INSERT INTO Questions (Content, QuestionType, Skill, Difficulty, contentJSON, CreatedBy) VALUES ('Describe a memorable trip you had. You should say where you went, what you did, and why it is memorable.', 'Speaking', 'Speaking', 'Medium', '{}', 1);
DELETE FROM #vars WHERE name='Q4';
INSERT INTO #vars (name, id) SELECT 'Q4', SCOPE_IDENTITY();

-- Map to ExamQuestions
INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex)
SELECT (SELECT id FROM #vars WHERE name='PlacementSectionID'), (SELECT id FROM #vars WHERE name='Q1'), 1
UNION ALL SELECT (SELECT id FROM #vars WHERE name='PlacementSectionID'), (SELECT id FROM #vars WHERE name='Q2'), 2
UNION ALL SELECT (SELECT id FROM #vars WHERE name='PlacementSectionID'), (SELECT id FROM #vars WHERE name='Q3'), 3
UNION ALL SELECT (SELECT id FROM #vars WHERE name='PlacementSectionID'), (SELECT id FROM #vars WHERE name='Q4'), 4;



-- 3. Insert ExamSections for Mock Test
INSERT INTO ExamSections (ExamID, Skill, SectionName, OrderIndex)
SELECT (SELECT id FROM #vars WHERE name='MockExamID'), 'Listening', 'Mock Section', 1;

DELETE FROM #vars WHERE name='MockSectionID';
INSERT INTO #vars (name, id) SELECT 'MockSectionID', SCOPE_IDENTITY();

-- Insert Questions for Mock Test
INSERT INTO Questions (Content, QuestionType, Skill, Difficulty, contentJSON, CreatedBy) VALUES ('Read the passage and answer: Global warming is caused by...', 'Multiple_Choice', 'Reading', 'Hard', '{}', 1);
DELETE FROM #vars WHERE name='Q5';
INSERT INTO #vars (name, id) SELECT 'Q5', SCOPE_IDENTITY();
INSERT INTO Answers (QuestionID, Content, IsCorrect, ContentJson)
SELECT (SELECT id FROM #vars WHERE name='Q5'), 'Greenhouse gases', 1, '{}'
UNION ALL SELECT (SELECT id FROM #vars WHERE name='Q5'), 'Solar radiation', 0, '{}'
UNION ALL SELECT (SELECT id FROM #vars WHERE name='Q5'), 'Ocean currents', 0, '{}';


INSERT INTO QuestionResource (ResourceAudioURL, Type) VALUES ('https://actions.google.com/sounds/v1/transportation/subway_train.ogg', 'Audio');
DELETE FROM #vars WHERE name='Res2';
INSERT INTO #vars (name, id) SELECT 'Res2', SCOPE_IDENTITY();
INSERT INTO Questions (Content, QuestionType, Skill, Difficulty, contentJSON, ResourceID, CreatedBy)
SELECT 'Listen to the conversation: What time is the flight?', 'Multiple_Choice', 'Listening', 'Hard', '{}', (SELECT id FROM #vars WHERE name='Res2'), 1;

DELETE FROM #vars WHERE name='Q6';
INSERT INTO #vars (name, id) SELECT 'Q6', SCOPE_IDENTITY();
INSERT INTO Answers (QuestionID, Content, IsCorrect, ContentJson)
SELECT (SELECT id FROM #vars WHERE name='Q6'), '9:00 AM', 1, '{}'
UNION ALL SELECT (SELECT id FROM #vars WHERE name='Q6'), '10:00 AM', 0, '{}'
UNION ALL SELECT (SELECT id FROM #vars WHERE name='Q6'), '11:00 AM', 0, '{}';


INSERT INTO Questions (Content, QuestionType, Skill, Difficulty, contentJSON, CreatedBy) VALUES ('Task 1: Summarize the chart below.', 'Essay', 'Writing', 'Hard', '{}', 1);
DELETE FROM #vars WHERE name='Q7';
INSERT INTO #vars (name, id) SELECT 'Q7', SCOPE_IDENTITY();

INSERT INTO Questions (Content, QuestionType, Skill, Difficulty, contentJSON, CreatedBy) VALUES ('Part 2: Describe a book that had a major influence on you.', 'Speaking', 'Speaking', 'Hard', '{}', 1);
DELETE FROM #vars WHERE name='Q8';
INSERT INTO #vars (name, id) SELECT 'Q8', SCOPE_IDENTITY();

-- Map to ExamQuestions
INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex)
SELECT (SELECT id FROM #vars WHERE name='MockSectionID'), (SELECT id FROM #vars WHERE name='Q5'), 1
UNION ALL SELECT (SELECT id FROM #vars WHERE name='MockSectionID'), (SELECT id FROM #vars WHERE name='Q6'), 2
UNION ALL SELECT (SELECT id FROM #vars WHERE name='MockSectionID'), (SELECT id FROM #vars WHERE name='Q7'), 3
UNION ALL SELECT (SELECT id FROM #vars WHERE name='MockSectionID'), (SELECT id FROM #vars WHERE name='Q8'), 4;

GO
