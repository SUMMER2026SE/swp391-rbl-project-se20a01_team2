USE IELTSFlow;
GO

-- =========================================================
-- CREATE MOCK TEST 2
-- =========================================================
INSERT INTO Exams (Title, Type, SkillFocus, Duration, MentorID, CreatedAt, Deleted)
VALUES (N'Sample IELTS Full Mock Test 2', 'Mock Test', 'All', 90, 1, GETDATE(), 0);
DECLARE @Exam2ID INT = SCOPE_IDENTITY();

DECLARE @QID INT;

-- =========================================================
-- LISTENING SECTION
-- =========================================================
INSERT INTO QuestionResource (ResourceAudioURL, Type) VALUES ('https://actions.google.com/sounds/v1/water/rain_on_roof.ogg', 'Audio');
DECLARE @ResAudio2 INT = SCOPE_IDENTITY();

INSERT INTO ExamSections (ExamID, SectionName, ResourceID, OrderIndex) VALUES (@Exam2ID, 'Listening Part 1 & 2', @ResAudio2, 1);
DECLARE @SecList2 INT = SCOPE_IDENTITY();

INSERT INTO Questions (Content, QuestionType, Skill, Difficulty, contentJSON, ResourceID) VALUES ('What is the main topic of the conversation?', 'Multiple_Choice', 'Listening', 'Easy', '{}', @ResAudio2);
SET @QID = SCOPE_IDENTITY();
INSERT INTO Answers (QuestionID, Content, IsCorrect, ContentJson) VALUES 
    (@QID, 'A. The weather forecast', 1, '{}'), 
    (@QID, 'B. A travel plan', 0, '{}'), 
    (@QID, 'C. A business meeting', 0, '{}');
INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex) VALUES (@SecList2, @QID, 1);

INSERT INTO Questions (Content, QuestionType, Skill, Difficulty, contentJSON, ResourceID) VALUES ('When will the rain stop according to the speaker?', 'Multiple_Choice', 'Listening', 'Medium', '{}', @ResAudio2);
SET @QID = SCOPE_IDENTITY();
INSERT INTO Answers (QuestionID, Content, IsCorrect, ContentJson) VALUES 
    (@QID, 'A. Tomorrow morning', 0, '{}'), 
    (@QID, 'B. Tonight', 1, '{}'), 
    (@QID, 'C. Next week', 0, '{}');
INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex) VALUES (@SecList2, @QID, 2);

INSERT INTO Questions (Content, QuestionType, Skill, Difficulty, contentJSON, ResourceID) VALUES ('Complete the sentence (NO MORE THAN TWO WORDS): The speaker advises listeners to bring an _____.', 'FillInBlanks', 'Listening', 'Easy', '{}', @ResAudio2);
SET @QID = SCOPE_IDENTITY();
INSERT INTO Answers (QuestionID, Content, IsCorrect, ContentJson) VALUES (@QID, 'umbrella', 1, '{}');
INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex) VALUES (@SecList2, @QID, 3);

INSERT INTO Questions (Content, QuestionType, Skill, Difficulty, contentJSON, ResourceID) VALUES ('Complete the sentence (NO MORE THAN TWO WORDS): Due to the heavy rain, the _____ is temporarily closed.', 'FillInBlanks', 'Listening', 'Hard', '{}', @ResAudio2);
SET @QID = SCOPE_IDENTITY();
INSERT INTO Answers (QuestionID, Content, IsCorrect, ContentJson) VALUES (@QID, 'main road', 1, '{}');
INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex) VALUES (@SecList2, @QID, 4);

-- =========================================================
-- READING SECTION
-- =========================================================
INSERT INTO QuestionResource (ResourceText, Type) 
VALUES (N'A. The history of chocolate begins in Mesoamerica. Fermented beverages made from chocolate date back to 1900 BC. The Aztecs believed that cacao seeds were the gift of Quetzalcoatl, the god of wisdom, and the seeds once had so much value that they were used as a form of currency. Originally prepared only as a drink, chocolate was served bitter, mixed with spices or corn puree. It was believed to have aphrodisiac powers and to give the drinker strength. Today, such drinks are also known as "Chilate" and are made by locals in the South of Mexico. 

B. After its arrival to Europe in the sixteenth century, sugar was added to it and it became popular throughout society, first among the ruling classes and then among the common people. In the 20th century, chocolate was considered essential in the rations of United States soldiers during war. The word "chocolate" comes from the Classical Nahuatl word chocolātl.

C. Chocolate is made from cacao beans, the dried and fermented seeds of the cacao tree (Theobroma cacao), a small evergreen tree native to the deep tropical regions of the Americas. The seeds must be fermented to develop the flavor. After fermentation, the beans are dried, cleaned, and roasted. The shell is removed to produce cacao nibs, which are then ground to cocoa mass, unadulterated chocolate in rough form. Once the cocoa mass is liquefied by heating, it is called chocolate liquor. The liquor may also be cooled and processed into its two components: cocoa solids and cocoa butter.

D. Much of the chocolate consumed today is in the form of sweet chocolate, a combination of cocoa solids, cocoa butter or added vegetable oils, and sugar. Milk chocolate is sweet chocolate that additionally contains milk powder or condensed milk. White chocolate contains cocoa butter, sugar, and milk, but no cocoa solids. Chocolate contains alkaloids such as theobromine and phenethylamine, which have physiological effects on the body. It has been linked to serotonin levels in the brain.', 'Passage');
DECLARE @ResRead2 INT = SCOPE_IDENTITY();

INSERT INTO ExamSections (ExamID, SectionName, ResourceID, OrderIndex) VALUES (@Exam2ID, 'Reading Passage 1: The History of Chocolate', @ResRead2, 2);
DECLARE @SecRead2 INT = SCOPE_IDENTITY();

INSERT INTO Questions (Content, QuestionType, Skill, Difficulty, contentJSON, ResourceID) VALUES ('Which paragraph contains information about the process of making chocolate?', 'Multiple_Choice', 'Reading', 'Medium', '{}', @ResRead2);
SET @QID = SCOPE_IDENTITY();
INSERT INTO Answers (QuestionID, Content, IsCorrect, ContentJson) VALUES (@QID, 'A', 0, '{}'), (@QID, 'B', 0, '{}'), (@QID, 'C', 1, '{}'), (@QID, 'D', 0, '{}');
INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex) VALUES (@SecRead2, @QID, 5);

INSERT INTO Questions (Content, QuestionType, Skill, Difficulty, contentJSON, ResourceID) VALUES ('Which paragraph mentions chocolate being used as money?', 'Multiple_Choice', 'Reading', 'Medium', '{}', @ResRead2);
SET @QID = SCOPE_IDENTITY();
INSERT INTO Answers (QuestionID, Content, IsCorrect, ContentJson) VALUES (@QID, 'A', 1, '{}'), (@QID, 'B', 0, '{}'), (@QID, 'C', 0, '{}'), (@QID, 'D', 0, '{}');
INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex) VALUES (@SecRead2, @QID, 6);

INSERT INTO Questions (Content, QuestionType, Skill, Difficulty, contentJSON, ResourceID) VALUES ('Complete the sentence: In the 16th century, _____ was added to chocolate when it arrived in Europe.', 'FillInBlanks', 'Reading', 'Easy', '{}', @ResRead2);
SET @QID = SCOPE_IDENTITY();
INSERT INTO Answers (QuestionID, Content, IsCorrect, ContentJson) VALUES (@QID, 'sugar', 1, '{}');
INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex) VALUES (@SecRead2, @QID, 7);

INSERT INTO Questions (Content, QuestionType, Skill, Difficulty, contentJSON, ResourceID) VALUES ('TRUE/FALSE/NOT GIVEN: White chocolate contains cocoa solids.', 'Multiple_Choice', 'Reading', 'Medium', '{}', @ResRead2);
SET @QID = SCOPE_IDENTITY();
INSERT INTO Answers (QuestionID, Content, IsCorrect, ContentJson) VALUES (@QID, 'TRUE', 0, '{}'), (@QID, 'FALSE', 1, '{}'), (@QID, 'NOT GIVEN', 0, '{}');
INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex) VALUES (@SecRead2, @QID, 8);

INSERT INTO Questions (Content, QuestionType, Skill, Difficulty, contentJSON, ResourceID) VALUES ('TRUE/FALSE/NOT GIVEN: The word chocolate originates from a European language.', 'Multiple_Choice', 'Reading', 'Medium', '{}', @ResRead2);
SET @QID = SCOPE_IDENTITY();
INSERT INTO Answers (QuestionID, Content, IsCorrect, ContentJson) VALUES (@QID, 'TRUE', 0, '{}'), (@QID, 'FALSE', 1, '{}'), (@QID, 'NOT GIVEN', 0, '{}');
INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex) VALUES (@SecRead2, @QID, 9);

-- =========================================================
-- WRITING SECTION
-- =========================================================
INSERT INTO ExamSections (ExamID, SectionName, ResourceID, OrderIndex) VALUES (@Exam2ID, 'Writing Task 1 & 2', NULL, 3);
DECLARE @SecWrit2 INT = SCOPE_IDENTITY();

INSERT INTO Questions (Content, QuestionType, Skill, Difficulty, contentJSON, ResourceID) VALUES ('Writing Task 1: The graph below shows the changes in food consumption by Chinese people between 1985 and 2010. Summarise the information by selecting and reporting the main features. (Write at least 150 words)', 'Essay', 'Writing', 'Medium', '{}', NULL);
SET @QID = SCOPE_IDENTITY();
INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex) VALUES (@SecWrit2, @QID, 10);

INSERT INTO Questions (Content, QuestionType, Skill, Difficulty, contentJSON, ResourceID) VALUES ('Writing Task 2: With the development of online communication, people will never be alone. To what extent do you agree or disagree? (Write at least 250 words)', 'Essay', 'Writing', 'Hard', '{}', NULL);
SET @QID = SCOPE_IDENTITY();
INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex) VALUES (@SecWrit2, @QID, 11);

-- =========================================================
-- SPEAKING SECTION
-- =========================================================
INSERT INTO ExamSections (ExamID, SectionName, ResourceID, OrderIndex) VALUES (@Exam2ID, 'Speaking Part 1, 2 & 3', NULL, 4);
DECLARE @SecSpeak2 INT = SCOPE_IDENTITY();

INSERT INTO Questions (Content, QuestionType, Skill, Difficulty, contentJSON, ResourceID) VALUES ('Speaking Part 1: Let''s talk about food. What is your favorite food? Do you prefer eating at home or eating out?', 'Speaking', 'Speaking', 'Easy', '{}', NULL);
SET @QID = SCOPE_IDENTITY();
INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex) VALUES (@SecSpeak2, @QID, 12);

INSERT INTO Questions (Content, QuestionType, Skill, Difficulty, contentJSON, ResourceID) VALUES ('Speaking Part 2: Describe a restaurant that you enjoyed going to. You should say: where the restaurant was, why you chose this restaurant, what type of food you ate, and explain why you enjoyed eating there.', 'Speaking', 'Speaking', 'Medium', '{}', NULL);
SET @QID = SCOPE_IDENTITY();
INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex) VALUES (@SecSpeak2, @QID, 13);

GO
