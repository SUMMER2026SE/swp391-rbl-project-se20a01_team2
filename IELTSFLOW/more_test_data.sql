USE IELTSFlow;
GO

-- 1. Insert new Exams
INSERT INTO Exams (Title, Type, SkillFocus, Duration, MentorID, CreatedAt, Deleted)
VALUES 
(N'IELTS Full Practice Test 1', 'Mock Test', 'All', 150, 1, GETDATE(), 0),
(N'Reading Skill Focus Test', 'Practice', 'Reading', 60, 1, GETDATE(), 0),
(N'Listening Full Practice Test', 'Practice', 'Listening', 40, 1, GETDATE(), 0);

IF OBJECT_ID('tempdb..#vars') IS NOT NULL DROP TABLE #vars;
CREATE TABLE #vars (name VARCHAR(100), id INT);
DELETE FROM #vars WHERE name='FullTest1ID';
INSERT INTO #vars (name, id) SELECT 'FullTest1ID', (SELECT ExamID FROM Exams WHERE Title = N'IELTS Full Practice Test 1');
DELETE FROM #vars WHERE name='ReadingTestID';
INSERT INTO #vars (name, id) SELECT 'ReadingTestID', (SELECT ExamID FROM Exams WHERE Title = N'Reading Skill Focus Test');
DELETE FROM #vars WHERE name='ListeningTestID';
INSERT INTO #vars (name, id) SELECT 'ListeningTestID', (SELECT ExamID FROM Exams WHERE Title = N'Listening Full Practice Test');

-- ==========================================
-- IELTS Full Practice Test 1 Sections
-- ==========================================

INSERT INTO ExamSections (ExamID, Skill, SectionName, OrderIndex)
SELECT (SELECT id FROM #vars WHERE name='FullTest1ID'), 'Listening', 'Listening Section', 1;

DELETE FROM #vars WHERE name='FullTestListeningSectionID';
INSERT INTO #vars (name, id) SELECT 'FullTestListeningSectionID', SCOPE_IDENTITY();

INSERT INTO ExamSections (ExamID, Skill, SectionName, OrderIndex)
SELECT (SELECT id FROM #vars WHERE name='FullTest1ID'), 'Reading', 'Reading Section', 2;

DELETE FROM #vars WHERE name='FullTestReadingSectionID';
INSERT INTO #vars (name, id) SELECT 'FullTestReadingSectionID', SCOPE_IDENTITY();

INSERT INTO ExamSections (ExamID, Skill, SectionName, OrderIndex)
SELECT (SELECT id FROM #vars WHERE name='FullTest1ID'), 'Writing', 'Writing Section', 3;

DELETE FROM #vars WHERE name='FullTestWritingSectionID';
INSERT INTO #vars (name, id) SELECT 'FullTestWritingSectionID', SCOPE_IDENTITY();

-- Listening Questions for Full Test
INSERT INTO QuestionResource (ResourceAudioURL, Type) VALUES ('https://actions.google.com/sounds/v1/alarms/alarm_clock.ogg', 'Audio');
DELETE FROM #vars WHERE name='ResListen1';
INSERT INTO #vars (name, id) SELECT 'ResListen1', SCOPE_IDENTITY();
INSERT INTO Questions (Content, QuestionType, Skill, Difficulty, contentJSON, ResourceID, CreatedBy)
SELECT 'What time does the speaker usually wake up?', 'Multiple_Choice', 'Listening', 'Medium', '{}', (SELECT id FROM #vars WHERE name='ResListen1'), 1;

DELETE FROM #vars WHERE name='FQ1';
INSERT INTO #vars (name, id) SELECT 'FQ1', SCOPE_IDENTITY();
INSERT INTO Answers (QuestionID, Content, IsCorrect, ContentJson)
SELECT (SELECT id FROM #vars WHERE name='FQ1'), '6:00 AM', 1, '{}'
UNION ALL SELECT (SELECT id FROM #vars WHERE name='FQ1'), '7:00 AM', 0, '{}'
UNION ALL SELECT (SELECT id FROM #vars WHERE name='FQ1'), '8:00 AM', 0, '{}'
UNION ALL SELECT (SELECT id FROM #vars WHERE name='FQ1'), '6:30 AM', 0, '{}';


-- Reading Questions for Full Test
INSERT INTO QuestionResource (ResourceText, Type) VALUES ('The history of chocolate dates back to the ancient Mayans, and even earlier to the ancient Olmecs of southern Mexico. The word chocolate may conjure up images of sweet candy bars and luscious truffles, but the chocolate of today is little like the chocolate of the past. Throughout much of history, chocolate was a revered but bitter beverage, not a sweet, edible treat.', 'Passage');
DELETE FROM #vars WHERE name='ResRead1';
INSERT INTO #vars (name, id) SELECT 'ResRead1', SCOPE_IDENTITY();

INSERT INTO Questions (Content, QuestionType, Skill, Difficulty, contentJSON, ResourceID, CreatedBy)
SELECT 'According to the text, what was chocolate primarily consumed as in the past?', 'Multiple_Choice', 'Reading', 'Medium', '{}', (SELECT id FROM #vars WHERE name='ResRead1'), 1;

DELETE FROM #vars WHERE name='FQ2';
INSERT INTO #vars (name, id) SELECT 'FQ2', SCOPE_IDENTITY();
INSERT INTO Answers (QuestionID, Content, IsCorrect, ContentJson)
SELECT (SELECT id FROM #vars WHERE name='FQ2'), 'A bitter beverage', 1, '{}'
UNION ALL SELECT (SELECT id FROM #vars WHERE name='FQ2'), 'A sweet candy', 0, '{}'
UNION ALL SELECT (SELECT id FROM #vars WHERE name='FQ2'), 'A medicine', 0, '{}'
UNION ALL SELECT (SELECT id FROM #vars WHERE name='FQ2'), 'A spicy soup', 0, '{}';


-- Writing Questions for Full Test
INSERT INTO Questions (Content, QuestionType, Skill, Difficulty, contentJSON, CreatedBy) VALUES ('Task 2: Some people think that in the modern world we are more dependent on each other, while others think that people have become more independent. Discuss both views and give your own opinion.', 'Essay', 'Writing', 'Hard', '{}', 1);
DELETE FROM #vars WHERE name='FQ3';
INSERT INTO #vars (name, id) SELECT 'FQ3', SCOPE_IDENTITY();

-- Map to ExamQuestions
INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex)
SELECT (SELECT id FROM #vars WHERE name='FullTestListeningSectionID'), (SELECT id FROM #vars WHERE name='FQ1'), 1;

INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex)
SELECT (SELECT id FROM #vars WHERE name='FullTestReadingSectionID'), (SELECT id FROM #vars WHERE name='FQ2'), 1;

INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex)
SELECT (SELECT id FROM #vars WHERE name='FullTestWritingSectionID'), (SELECT id FROM #vars WHERE name='FQ3'), 1;


-- ==========================================
-- Reading Skill Focus Test
-- ==========================================

INSERT INTO ExamSections (ExamID, Skill, SectionName, OrderIndex)
SELECT (SELECT id FROM #vars WHERE name='ReadingTestID'), 'Reading', 'Reading Passage 1', 1;

DELETE FROM #vars WHERE name='ReadingFocusSectionID';
INSERT INTO #vars (name, id) SELECT 'ReadingFocusSectionID', SCOPE_IDENTITY();

INSERT INTO Questions (Content, QuestionType, Skill, Difficulty, contentJSON, CreatedBy) VALUES ('What is the main advantage of solar energy over fossil fuels?', 'Multiple_Choice', 'Reading', 'Easy', '{}', 1);
DELETE FROM #vars WHERE name='RQ1';
INSERT INTO #vars (name, id) SELECT 'RQ1', SCOPE_IDENTITY();
INSERT INTO Answers (QuestionID, Content, IsCorrect, ContentJson)
SELECT (SELECT id FROM #vars WHERE name='RQ1'), 'It is renewable', 1, '{}'
UNION ALL SELECT (SELECT id FROM #vars WHERE name='RQ1'), 'It is cheaper to set up initially', 0, '{}'
UNION ALL SELECT (SELECT id FROM #vars WHERE name='RQ1'), 'It can be used everywhere at night', 0, '{}';


INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex)
SELECT (SELECT id FROM #vars WHERE name='ReadingFocusSectionID'), (SELECT id FROM #vars WHERE name='RQ1'), 1;


-- ==========================================
-- Listening Full Practice Test
-- ==========================================

-- Section 1
INSERT INTO ExamSections (ExamID, Skill, SectionName, OrderIndex)
SELECT (SELECT id FROM #vars WHERE name='ListeningTestID'), 'Listening', 'Section 1: Conversation', 1;

DELETE FROM #vars WHERE name='ListenSec1';
INSERT INTO #vars (name, id) SELECT 'ListenSec1', SCOPE_IDENTITY();

INSERT INTO QuestionResource (ResourceAudioURL, Type) VALUES ('https://actions.google.com/sounds/v1/water/waves_crashing_on_rock_beach.ogg', 'Audio');
DELETE FROM #vars WHERE name='ResListen2';
INSERT INTO #vars (name, id) SELECT 'ResListen2', SCOPE_IDENTITY();
INSERT INTO Questions (Content, QuestionType, Skill, Difficulty, contentJSON, ResourceID, CreatedBy)
SELECT 'Where did the person spend their holiday?', 'Multiple_Choice', 'Listening', 'Easy', '{}', (SELECT id FROM #vars WHERE name='ResListen2'), 1;

DELETE FROM #vars WHERE name='LQ1';
INSERT INTO #vars (name, id) SELECT 'LQ1', SCOPE_IDENTITY();
INSERT INTO Answers (QuestionID, Content, IsCorrect, ContentJson)
SELECT (SELECT id FROM #vars WHERE name='LQ1'), 'At the beach', 1, '{}'
UNION ALL SELECT (SELECT id FROM #vars WHERE name='LQ1'), 'In the mountains', 0, '{}'
UNION ALL SELECT (SELECT id FROM #vars WHERE name='LQ1'), 'In the city center', 0, '{}';

INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex)
SELECT (SELECT id FROM #vars WHERE name='ListenSec1'), (SELECT id FROM #vars WHERE name='LQ1'), 1;


-- Section 2
INSERT INTO ExamSections (ExamID, Skill, SectionName, OrderIndex)
SELECT (SELECT id FROM #vars WHERE name='ListeningTestID'), 'Listening', 'Section 2: Monologue', 2;

DELETE FROM #vars WHERE name='ListenSec2';
INSERT INTO #vars (name, id) SELECT 'ListenSec2', SCOPE_IDENTITY();

INSERT INTO Questions (Content, QuestionType, Skill, Difficulty, contentJSON, ResourceID, CreatedBy)
SELECT 'What time does the museum close on Sundays?', 'Multiple_Choice', 'Listening', 'Medium', '{}', (SELECT id FROM #vars WHERE name='ResListen2'), 1;

DELETE FROM #vars WHERE name='LQ2';
INSERT INTO #vars (name, id) SELECT 'LQ2', SCOPE_IDENTITY();
INSERT INTO Answers (QuestionID, Content, IsCorrect, ContentJson)
SELECT (SELECT id FROM #vars WHERE name='LQ2'), '5:00 PM', 1, '{}'
UNION ALL SELECT (SELECT id FROM #vars WHERE name='LQ2'), '6:00 PM', 0, '{}'
UNION ALL SELECT (SELECT id FROM #vars WHERE name='LQ2'), '4:00 PM', 0, '{}';

INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex)
SELECT (SELECT id FROM #vars WHERE name='ListenSec2'), (SELECT id FROM #vars WHERE name='LQ2'), 1;


-- Section 3
INSERT INTO ExamSections (ExamID, Skill, SectionName, OrderIndex)
SELECT (SELECT id FROM #vars WHERE name='ListeningTestID'), 'Listening', 'Section 3: Academic Discussion', 3;

DELETE FROM #vars WHERE name='ListenSec3';
INSERT INTO #vars (name, id) SELECT 'ListenSec3', SCOPE_IDENTITY();

INSERT INTO Questions (Content, QuestionType, Skill, Difficulty, contentJSON, ResourceID, CreatedBy)
SELECT 'Which aspect of the project did they find most difficult?', 'Multiple_Choice', 'Listening', 'Hard', '{}', (SELECT id FROM #vars WHERE name='ResListen2'), 1;

DELETE FROM #vars WHERE name='LQ3';
INSERT INTO #vars (name, id) SELECT 'LQ3', SCOPE_IDENTITY();
INSERT INTO Answers (QuestionID, Content, IsCorrect, ContentJson)
SELECT (SELECT id FROM #vars WHERE name='LQ3'), 'Data collection', 1, '{}'
UNION ALL SELECT (SELECT id FROM #vars WHERE name='LQ3'), 'Data analysis', 0, '{}'
UNION ALL SELECT (SELECT id FROM #vars WHERE name='LQ3'), 'Writing the report', 0, '{}';

INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex)
SELECT (SELECT id FROM #vars WHERE name='ListenSec3'), (SELECT id FROM #vars WHERE name='LQ3'), 1;


-- Section 4
INSERT INTO ExamSections (ExamID, Skill, SectionName, OrderIndex)
SELECT (SELECT id FROM #vars WHERE name='ListeningTestID'), 'Listening', 'Section 4: Academic Lecture', 4;

DELETE FROM #vars WHERE name='ListenSec4';
INSERT INTO #vars (name, id) SELECT 'ListenSec4', SCOPE_IDENTITY();

INSERT INTO Questions (Content, QuestionType, Skill, Difficulty, contentJSON, ResourceID, CreatedBy)
SELECT 'The lecture primarily discusses the impact of...', 'Multiple_Choice', 'Listening', 'Hard', '{}', (SELECT id FROM #vars WHERE name='ResListen2'), 1;

DELETE FROM #vars WHERE name='LQ4';
INSERT INTO #vars (name, id) SELECT 'LQ4', SCOPE_IDENTITY();
INSERT INTO Answers (QuestionID, Content, IsCorrect, ContentJson)
SELECT (SELECT id FROM #vars WHERE name='LQ4'), 'Climate change on agriculture', 1, '{}'
UNION ALL SELECT (SELECT id FROM #vars WHERE name='LQ4'), 'Urbanization on wildlife', 0, '{}'
UNION ALL SELECT (SELECT id FROM #vars WHERE name='LQ4'), 'Deforestation on local weather', 0, '{}';

INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex)
SELECT (SELECT id FROM #vars WHERE name='ListenSec4'), (SELECT id FROM #vars WHERE name='LQ4'), 1;

GO
