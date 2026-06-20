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

DECLARE @PlacementExamID INT = (SELECT ExamID FROM Exams WHERE Title = N'Placement Test Đánh Giá Đầu Vào');
DECLARE @MockExamID INT = (SELECT ExamID FROM Exams WHERE Title = N'Mock Test Luyện Đề Tổng Hợp');

-- 2. Insert ExamSections for Placement Test
INSERT INTO ExamSections (ExamID, SectionName, OrderIndex) VALUES (@PlacementExamID, 'Placement Section', 1);
DECLARE @PlacementSectionID INT = SCOPE_IDENTITY();

-- Insert Questions for Placement Test
INSERT INTO Questions (Content, QuestionType, Skill, Difficulty, contentJSON) VALUES ('What is the capital of France?', 'Multiple_Choice', 'Reading', 'Easy', '{}');
DECLARE @Q1 INT = SCOPE_IDENTITY();
INSERT INTO Answers (QuestionID, Content, IsCorrect, ContentJson) VALUES (@Q1, 'Paris', 1, '{}'), (@Q1, 'London', 0, '{}'), (@Q1, 'Berlin', 0, '{}');

INSERT INTO QuestionResource (ResourceAudioURL, Type) VALUES ('https://actions.google.com/sounds/v1/water/rain_on_roof.ogg', 'Audio');
DECLARE @Res1 INT = SCOPE_IDENTITY();
INSERT INTO Questions (Content, QuestionType, Skill, Difficulty, contentJSON, ResourceID) VALUES ('Listen and choose: The boy is going to...', 'Multiple_Choice', 'Listening', 'Easy', '{}', @Res1);
DECLARE @Q2 INT = SCOPE_IDENTITY();
INSERT INTO Answers (QuestionID, Content, IsCorrect, ContentJson) VALUES (@Q2, 'The market', 1, '{}'), (@Q2, 'The school', 0, '{}'), (@Q2, 'The park', 0, '{}');

INSERT INTO Questions (Content, QuestionType, Skill, Difficulty, contentJSON) VALUES ('Write an essay about the importance of learning English.', 'Essay', 'Writing', 'Medium', '{}');
DECLARE @Q3 INT = SCOPE_IDENTITY();

INSERT INTO Questions (Content, QuestionType, Skill, Difficulty, contentJSON) VALUES ('Describe a memorable trip you had. You should say where you went, what you did, and why it is memorable.', 'Speaking', 'Speaking', 'Medium', '{}');
DECLARE @Q4 INT = SCOPE_IDENTITY();

-- Map to ExamQuestions
INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex) VALUES (@PlacementSectionID, @Q1, 1), (@PlacementSectionID, @Q2, 2), (@PlacementSectionID, @Q3, 3), (@PlacementSectionID, @Q4, 4);


-- 3. Insert ExamSections for Mock Test
INSERT INTO ExamSections (ExamID, SectionName, OrderIndex) VALUES (@MockExamID, 'Mock Section', 1);
DECLARE @MockSectionID INT = SCOPE_IDENTITY();

-- Insert Questions for Mock Test
INSERT INTO Questions (Content, QuestionType, Skill, Difficulty, contentJSON) VALUES ('Read the passage and answer: Global warming is caused by...', 'Multiple_Choice', 'Reading', 'Hard', '{}');
DECLARE @Q5 INT = SCOPE_IDENTITY();
INSERT INTO Answers (QuestionID, Content, IsCorrect, ContentJson) VALUES (@Q5, 'Greenhouse gases', 1, '{}'), (@Q5, 'Solar radiation', 0, '{}'), (@Q5, 'Ocean currents', 0, '{}');

INSERT INTO QuestionResource (ResourceAudioURL, Type) VALUES ('https://actions.google.com/sounds/v1/transportation/subway_train.ogg', 'Audio');
DECLARE @Res2 INT = SCOPE_IDENTITY();
INSERT INTO Questions (Content, QuestionType, Skill, Difficulty, contentJSON, ResourceID) VALUES ('Listen to the conversation: What time is the flight?', 'Multiple_Choice', 'Listening', 'Hard', '{}', @Res2);
DECLARE @Q6 INT = SCOPE_IDENTITY();
INSERT INTO Answers (QuestionID, Content, IsCorrect, ContentJson) VALUES (@Q6, '9:00 AM', 1, '{}'), (@Q6, '10:00 AM', 0, '{}'), (@Q6, '11:00 AM', 0, '{}');

INSERT INTO Questions (Content, QuestionType, Skill, Difficulty, contentJSON) VALUES ('Task 1: Summarize the chart below.', 'Essay', 'Writing', 'Hard', '{}');
DECLARE @Q7 INT = SCOPE_IDENTITY();

INSERT INTO Questions (Content, QuestionType, Skill, Difficulty, contentJSON) VALUES ('Part 2: Describe a book that had a major influence on you.', 'Speaking', 'Speaking', 'Hard', '{}');
DECLARE @Q8 INT = SCOPE_IDENTITY();

-- Map to ExamQuestions
INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex) VALUES (@MockSectionID, @Q5, 1), (@MockSectionID, @Q6, 2), (@MockSectionID, @Q7, 3), (@MockSectionID, @Q8, 4);
GO
