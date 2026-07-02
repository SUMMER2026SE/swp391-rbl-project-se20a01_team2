USE IELTSFlow;
GO

UPDATE Exams SET Deleted = 1 WHERE Type = 'Mock Test';

DECLARE @ExamID INT;
DECLARE @SectionID INT;
DECLARE @ResourceID INT;
DECLARE @QuestionID INT;

INSERT INTO Exams (Title, Type, SkillFocus, Duration, MentorID, CreatedAt, Deleted) 
VALUES (N'IELTS Full Mock Test 1', 'Mock Test', 'All', 120, 2, GETDATE(), 0); 
SET @ExamID = SCOPE_IDENTITY();

-- ==========================================
-- LISTENING
-- ==========================================
INSERT INTO ExamSections (ExamID, SectionName, OrderIndex, Skill) 
VALUES (@ExamID, 'Listening Part 1', 1, 'Listening');
SET @SectionID = SCOPE_IDENTITY();

INSERT INTO QuestionResource (ResourceName, ResourceAudioURL, Type, CreatedBy) 
VALUES (N'Audio Hội thoại', 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3', 'Audio', 2);
SET @ResourceID = SCOPE_IDENTITY();

INSERT INTO Questions (ResourceID, Content, QuestionType, Skill, Difficulty, OrderInResource, contentJSON, CreatedBy) 
VALUES (@ResourceID, N'1. What is the main topic of the conversation?', 'Multiple_Choice', 'Listening', 'Easy', 1, '{}', 2);
SET @QuestionID = SCOPE_IDENTITY();
INSERT INTO Answers (QuestionID, Content, ContentJson, IsCorrect) VALUES 
(@QuestionID, N'A holiday', '{}', 1), (@QuestionID, N'A job interview', '{}', 0), (@QuestionID, N'A party', '{}', 0);
INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex) VALUES (@SectionID, @QuestionID, 1);

INSERT INTO Questions (ResourceID, Content, QuestionType, Skill, Difficulty, OrderInResource, contentJSON, CreatedBy) 
VALUES (@ResourceID, N'2. What time will the train arrive?', 'Fill_In_Blank', 'Listening', 'Medium', 2, '{}', 2);
SET @QuestionID = SCOPE_IDENTITY();
INSERT INTO Answers (QuestionID, Content, ContentJson, IsCorrect) VALUES (@QuestionID, N'10:30', '{}', 1);
INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex) VALUES (@SectionID, @QuestionID, 2);

-- ==========================================
-- READING
-- ==========================================
INSERT INTO ExamSections (ExamID, SectionName, OrderIndex, Skill) 
VALUES (@ExamID, 'Reading Passage 1', 2, 'Reading');
SET @SectionID = SCOPE_IDENTITY();

INSERT INTO QuestionResource (ResourceName, ResourceText, Type, CreatedBy) 
VALUES (N'The life and work of Marie Curie', N'<p>Marie Curie is probably the most famous woman scientist who has ever lived. Born Maria Sklodowska in Poland in 1867, she is famous for her work on radioactivity, and was twice a winner of the Nobel Prize. With her husband, Pierre Curie, and Henri Becquerel, she was awarded the 1903 Nobel Prize for Physics, and was then sole winner of the 1911 Nobel Prize for Chemistry. She was the first woman to win a Nobel Prize.</p><p>From childhood, Marie was remarkable for her prodigious memory, and at the age of 16 won a gold medal on completion of her secondary education. Because her father lost his savings through bad investment, she then had to take work as a teacher. From her earnings she was able to finance her sister Bronia''s medical studies in Paris, on the understanding that Bronia would, in turn, later help her to get an education.</p><p>In 1891 this promise was fulfilled and Marie went to Paris and began to study at the Sorbonne (the University of Paris). She often worked far into the night and lived on little more than bread and butter and tea. She came first in the examination in the physical sciences in 1893, and in 1894 was placed second in the examination in mathematical sciences.</p>', 'Passage', 2);
SET @ResourceID = SCOPE_IDENTITY();

INSERT INTO Questions (ResourceID, Content, QuestionType, Skill, Difficulty, OrderInResource, contentJSON, CreatedBy) 
VALUES (@ResourceID, N'3. Marie Curie’s husband was a joint winner of both Marie’s Nobel Prizes.', 'Multiple_Choice', 'Reading', 'Medium', 1, '{}', 2);
SET @QuestionID = SCOPE_IDENTITY();
INSERT INTO Answers (QuestionID, Content, ContentJson, IsCorrect) VALUES 
(@QuestionID, N'TRUE', '{}', 0), (@QuestionID, N'FALSE', '{}', 1), (@QuestionID, N'NOT GIVEN', '{}', 0);
INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex) VALUES (@SectionID, @QuestionID, 3);

INSERT INTO Questions (ResourceID, Content, QuestionType, Skill, Difficulty, OrderInResource, contentJSON, CreatedBy) 
VALUES (@ResourceID, N'4. Marie became interested in science when she was a child.', 'Multiple_Choice', 'Reading', 'Medium', 2, '{}', 2);
SET @QuestionID = SCOPE_IDENTITY();
INSERT INTO Answers (QuestionID, Content, ContentJson, IsCorrect) VALUES 
(@QuestionID, N'TRUE', '{}', 0), (@QuestionID, N'FALSE', '{}', 0), (@QuestionID, N'NOT GIVEN', '{}', 1);
INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex) VALUES (@SectionID, @QuestionID, 4);

INSERT INTO Questions (ResourceID, Content, QuestionType, Skill, Difficulty, OrderInResource, contentJSON, CreatedBy) 
VALUES (@ResourceID, N'5. Marie was able to attend the Sorbonne because of her sister''s financial contribution.', 'Multiple_Choice', 'Reading', 'Medium', 3, '{}', 2);
SET @QuestionID = SCOPE_IDENTITY();
INSERT INTO Answers (QuestionID, Content, ContentJson, IsCorrect) VALUES 
(@QuestionID, N'TRUE', '{}', 1), (@QuestionID, N'FALSE', '{}', 0), (@QuestionID, N'NOT GIVEN', '{}', 0);
INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex) VALUES (@SectionID, @QuestionID, 5);

INSERT INTO Questions (ResourceID, Content, QuestionType, Skill, Difficulty, OrderInResource, contentJSON, CreatedBy) 
VALUES (@ResourceID, N'6. Marie stopped doing research for several years when her children were born.', 'Multiple_Choice', 'Reading', 'Medium', 4, '{}', 2);
SET @QuestionID = SCOPE_IDENTITY();
INSERT INTO Answers (QuestionID, Content, ContentJson, IsCorrect) VALUES 
(@QuestionID, N'TRUE', '{}', 0), (@QuestionID, N'FALSE', '{}', 0), (@QuestionID, N'NOT GIVEN', '{}', 1);
INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex) VALUES (@SectionID, @QuestionID, 6);

-- ==========================================
-- WRITING
-- ==========================================
INSERT INTO ExamSections (ExamID, SectionName, OrderIndex, Skill) 
VALUES (@ExamID, 'Writing Task 1', 3, 'Writing');
SET @SectionID = SCOPE_IDENTITY();

INSERT INTO Questions (ResourceID, Content, QuestionType, Skill, Difficulty, OrderInResource, contentJSON, CreatedBy) 
VALUES (NULL, N'7. You should spend about 20 minutes on this task. Write at least 150 words.<br/><br/>The graph below shows the number of tourists visiting a particular Caribbean island between 2010 and 2017.<br/>Summarise the information by selecting and reporting the main features, and make comparisons where relevant.', 'Essay', 'Writing', 'Medium', 1, '{}', 2);
SET @QuestionID = SCOPE_IDENTITY();
INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex) VALUES (@SectionID, @QuestionID, 7);

-- ==========================================
-- SPEAKING
-- ==========================================
INSERT INTO ExamSections (ExamID, SectionName, OrderIndex, Skill) 
VALUES (@ExamID, 'Speaking Part 2', 4, 'Speaking');
SET @SectionID = SCOPE_IDENTITY();

INSERT INTO Questions (ResourceID, Content, QuestionType, Skill, Difficulty, OrderInResource, contentJSON, CreatedBy) 
VALUES (NULL, N'8. Describe a time when you helped someone.<br/><br/>You should say:<br/>- who you helped<br/>- how you helped them<br/>- why you helped them<br/>and explain how you felt about it.', 'Speaking', 'Speaking', 'Medium', 1, '{}', 2);
SET @QuestionID = SCOPE_IDENTITY();
INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex) VALUES (@SectionID, @QuestionID, 8);

GO
