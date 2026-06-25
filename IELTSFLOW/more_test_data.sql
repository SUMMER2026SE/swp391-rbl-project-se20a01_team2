USE IELTSFlow;
GO

-- 1. Insert new Exams
INSERT INTO Exams (Title, Type, SkillFocus, Duration, MentorID, CreatedAt, Deleted)
VALUES 
(N'IELTS Full Practice Test 1', 'Mock Test', 'All', 150, 1, GETDATE(), 0),
(N'Reading Skill Focus Test', 'Practice', 'Reading', 60, 1, GETDATE(), 0),
(N'Listening Full Practice Test', 'Practice', 'Listening', 40, 1, GETDATE(), 0);

DECLARE @FullTest1ID INT = (SELECT ExamID FROM Exams WHERE Title = N'IELTS Full Practice Test 1');
DECLARE @ReadingTestID INT = (SELECT ExamID FROM Exams WHERE Title = N'Reading Skill Focus Test');
DECLARE @ListeningTestID INT = (SELECT ExamID FROM Exams WHERE Title = N'Listening Full Practice Test');

-- ==========================================
-- IELTS Full Practice Test 1 Sections
-- ==========================================

INSERT INTO ExamSections (ExamID, SectionName, OrderIndex) VALUES (@FullTest1ID, 'Listening Section', 1);
DECLARE @FullTestListeningSectionID INT = SCOPE_IDENTITY();

INSERT INTO ExamSections (ExamID, SectionName, OrderIndex) VALUES (@FullTest1ID, 'Reading Section', 2);
DECLARE @FullTestReadingSectionID INT = SCOPE_IDENTITY();

INSERT INTO ExamSections (ExamID, SectionName, OrderIndex) VALUES (@FullTest1ID, 'Writing Section', 3);
DECLARE @FullTestWritingSectionID INT = SCOPE_IDENTITY();

-- Listening Questions for Full Test
INSERT INTO QuestionResource (ResourceAudioURL, Type) VALUES ('https://actions.google.com/sounds/v1/alarms/alarm_clock.ogg', 'Audio');
DECLARE @ResListen1 INT = SCOPE_IDENTITY();
INSERT INTO Questions (Content, QuestionType, Skill, Difficulty, contentJSON, ResourceID) VALUES ('What time does the speaker usually wake up?', 'Multiple_Choice', 'Listening', 'Medium', '{}', @ResListen1);
DECLARE @FQ1 INT = SCOPE_IDENTITY();
INSERT INTO Answers (QuestionID, Content, IsCorrect, ContentJson) VALUES (@FQ1, '6:00 AM', 1, '{}'), (@FQ1, '7:00 AM', 0, '{}'), (@FQ1, '8:00 AM', 0, '{}'), (@FQ1, '6:30 AM', 0, '{}');

-- Reading Questions for Full Test
INSERT INTO QuestionResource (ResourceText, Type) VALUES ('The history of chocolate dates back to the ancient Mayans, and even earlier to the ancient Olmecs of southern Mexico. The word chocolate may conjure up images of sweet candy bars and luscious truffles, but the chocolate of today is little like the chocolate of the past. Throughout much of history, chocolate was a revered but bitter beverage, not a sweet, edible treat.', 'Passage');
DECLARE @ResRead1 INT = SCOPE_IDENTITY();

INSERT INTO Questions (Content, QuestionType, Skill, Difficulty, contentJSON, ResourceID) VALUES ('According to the text, what was chocolate primarily consumed as in the past?', 'Multiple_Choice', 'Reading', 'Medium', '{}', @ResRead1);
DECLARE @FQ2 INT = SCOPE_IDENTITY();
INSERT INTO Answers (QuestionID, Content, IsCorrect, ContentJson) VALUES (@FQ2, 'A bitter beverage', 1, '{}'), (@FQ2, 'A sweet candy', 0, '{}'), (@FQ2, 'A medicine', 0, '{}'), (@FQ2, 'A spicy soup', 0, '{}');

-- Writing Questions for Full Test
INSERT INTO Questions (Content, QuestionType, Skill, Difficulty, contentJSON) VALUES ('Task 2: Some people think that in the modern world we are more dependent on each other, while others think that people have become more independent. Discuss both views and give your own opinion.', 'Essay', 'Writing', 'Hard', '{}');
DECLARE @FQ3 INT = SCOPE_IDENTITY();

-- Map to ExamQuestions
INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex) VALUES (@FullTestListeningSectionID, @FQ1, 1);
INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex) VALUES (@FullTestReadingSectionID, @FQ2, 1);
INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex) VALUES (@FullTestWritingSectionID, @FQ3, 1);

-- ==========================================
-- Reading Skill Focus Test
-- ==========================================

INSERT INTO ExamSections (ExamID, SectionName, OrderIndex) VALUES (@ReadingTestID, 'Reading Passage 1', 1);
DECLARE @ReadingFocusSectionID INT = SCOPE_IDENTITY();

INSERT INTO Questions (Content, QuestionType, Skill, Difficulty, contentJSON) VALUES ('What is the main advantage of solar energy over fossil fuels?', 'Multiple_Choice', 'Reading', 'Easy', '{}');
DECLARE @RQ1 INT = SCOPE_IDENTITY();
INSERT INTO Answers (QuestionID, Content, IsCorrect, ContentJson) VALUES (@RQ1, 'It is renewable', 1, '{}'), (@RQ1, 'It is cheaper to set up initially', 0, '{}'), (@RQ1, 'It can be used everywhere at night', 0, '{}');

INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex) VALUES (@ReadingFocusSectionID, @RQ1, 1);

-- ==========================================
-- Listening Full Practice Test
-- ==========================================

-- Section 1
INSERT INTO ExamSections (ExamID, SectionName, OrderIndex) VALUES (@ListeningTestID, 'Section 1: Conversation', 1);
DECLARE @ListenSec1 INT = SCOPE_IDENTITY();

INSERT INTO QuestionResource (ResourceAudioURL, Type) VALUES ('https://actions.google.com/sounds/v1/water/waves_crashing_on_rock_beach.ogg', 'Audio');
DECLARE @ResListen2 INT = SCOPE_IDENTITY();
INSERT INTO Questions (Content, QuestionType, Skill, Difficulty, contentJSON, ResourceID) VALUES ('Where did the person spend their holiday?', 'Multiple_Choice', 'Listening', 'Easy', '{}', @ResListen2);
DECLARE @LQ1 INT = SCOPE_IDENTITY();
INSERT INTO Answers (QuestionID, Content, IsCorrect, ContentJson) VALUES (@LQ1, 'At the beach', 1, '{}'), (@LQ1, 'In the mountains', 0, '{}'), (@LQ1, 'In the city center', 0, '{}');
INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex) VALUES (@ListenSec1, @LQ1, 1);

-- Section 2
INSERT INTO ExamSections (ExamID, SectionName, OrderIndex) VALUES (@ListeningTestID, 'Section 2: Monologue', 2);
DECLARE @ListenSec2 INT = SCOPE_IDENTITY();

INSERT INTO Questions (Content, QuestionType, Skill, Difficulty, contentJSON, ResourceID) VALUES ('What time does the museum close on Sundays?', 'Multiple_Choice', 'Listening', 'Medium', '{}', @ResListen2);
DECLARE @LQ2 INT = SCOPE_IDENTITY();
INSERT INTO Answers (QuestionID, Content, IsCorrect, ContentJson) VALUES (@LQ2, '5:00 PM', 1, '{}'), (@LQ2, '6:00 PM', 0, '{}'), (@LQ2, '4:00 PM', 0, '{}');
INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex) VALUES (@ListenSec2, @LQ2, 1);

-- Section 3
INSERT INTO ExamSections (ExamID, SectionName, OrderIndex) VALUES (@ListeningTestID, 'Section 3: Academic Discussion', 3);
DECLARE @ListenSec3 INT = SCOPE_IDENTITY();

INSERT INTO Questions (Content, QuestionType, Skill, Difficulty, contentJSON, ResourceID) VALUES ('Which aspect of the project did they find most difficult?', 'Multiple_Choice', 'Listening', 'Hard', '{}', @ResListen2);
DECLARE @LQ3 INT = SCOPE_IDENTITY();
INSERT INTO Answers (QuestionID, Content, IsCorrect, ContentJson) VALUES (@LQ3, 'Data collection', 1, '{}'), (@LQ3, 'Data analysis', 0, '{}'), (@LQ3, 'Writing the report', 0, '{}');
INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex) VALUES (@ListenSec3, @LQ3, 1);

-- Section 4
INSERT INTO ExamSections (ExamID, SectionName, OrderIndex) VALUES (@ListeningTestID, 'Section 4: Academic Lecture', 4);
DECLARE @ListenSec4 INT = SCOPE_IDENTITY();

INSERT INTO Questions (Content, QuestionType, Skill, Difficulty, contentJSON, ResourceID) VALUES ('The lecture primarily discusses the impact of...', 'Multiple_Choice', 'Listening', 'Hard', '{}', @ResListen2);
DECLARE @LQ4 INT = SCOPE_IDENTITY();
INSERT INTO Answers (QuestionID, Content, IsCorrect, ContentJson) VALUES (@LQ4, 'Climate change on agriculture', 1, '{}'), (@LQ4, 'Urbanization on wildlife', 0, '{}'), (@LQ4, 'Deforestation on local weather', 0, '{}');
INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex) VALUES (@ListenSec4, @LQ4, 1);
GO
