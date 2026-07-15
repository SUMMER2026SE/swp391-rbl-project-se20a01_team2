USE IELTSFLOW;
GO

-- ============================================================
--  SEED: Cambridge IELTS 18 – Test 1 (Full Mock)
--  Listening: 2 sections x 5 questions = 10
--  Reading:   2 sections x 6 questions = 12
--  Writing:   1 section  x 2 tasks
--  Speaking:  1 section  x 3 parts
-- ============================================================

DECLARE @MentorID INT = 1;

-- ── INSERT EXAM ──────────────────────────────────────────────
INSERT INTO Exams (Title, Type, SkillFocus, Duration, MentorID)
VALUES ('Cambridge IELTS 18 - Test 1', 'Placement Test', 'All', 180, @MentorID);
DECLARE @ExamID INT = SCOPE_IDENTITY();

-- ── RESOURCES ────────────────────────────────────────────────
INSERT INTO QuestionResource (ResourceName, ResourceAudioURL, Type, CreatedBy)
VALUES ('Listening Part 1 – Daily Conversation', 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3', 'Audio', @MentorID);
DECLARE @ResL1 INT = SCOPE_IDENTITY();

INSERT INTO QuestionResource (ResourceName, ResourceAudioURL, Type, CreatedBy)
VALUES ('Listening Part 2 – Public Talk', 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3', 'Audio', @MentorID);
DECLARE @ResL2 INT = SCOPE_IDENTITY();

INSERT INTO QuestionResource (ResourceName, ResourceText, Type, CreatedBy)
VALUES ('Reading Passage 1: Urban Farming',
'<h3>Urban Farming</h3>
<p>In Paris, a team of entrepreneurs led by Paul-Albert is converting a series of underground car parks into organic mushroom farms. The initiative began in 2018 and has expanded rapidly, now covering over 14,000 square metres beneath the bustling city streets.</p>
<p>The farms grow 30 different species of vegetables and herbs. Their yields have increased by 40% compared to conventional surface farming, largely because the underground environment provides stable temperature and humidity year-round.</p>
<p>The team believes urban farming can significantly reduce the carbon footprint associated with transporting food from rural areas. By growing produce within the city, delivery distances shrink from hundreds of kilometres to just a few.</p>
<p>Critics, however, point out that the artificial lighting required underground consumes substantial electricity. The founders counter this by powering the farms with 100% renewable energy and argue that the overall lifecycle emissions are still lower than conventional supply chains.</p>
<p>The project has attracted significant investment and interest from other European cities looking to replicate the model. Amsterdam and Berlin are currently running pilot programmes based on the Paris design.</p>', 'Passage', @MentorID);
DECLARE @ResR1 INT = SCOPE_IDENTITY();

INSERT INTO QuestionResource (ResourceName, ResourceText, Type, CreatedBy)
VALUES ('Reading Passage 2: Forest Management',
'<h3>Forest Management and Biodiversity</h3>
<p>Forests cover approximately 31% of the Earth''s total land area and are home to more than 80% of terrestrial species. Despite their importance, deforestation continues at an alarming rate, with an estimated 10 million hectares lost each year.</p>
<p>Many governments have introduced legislation requiring companies to offset carbon emissions by planting trees in deforested areas. While these programmes have led to an increase in total tree cover globally, scientists warn that the quality of new forests is often poor.</p>
<p>Critics argue that monoculture plantations — which consist of a single tree species — cannot replicate the complex ecosystem functions of natural forests. Biodiversity remains extremely limited in such environments, meaning that most wildlife cannot return.</p>
<p>More effective approaches involve restoring natural forests by removing invasive species and allowing native vegetation to regenerate. This method, known as passive rewilding, has shown promising results in parts of Europe and South America.</p>
<p>Ultimately, experts agree that preventing deforestation in the first place remains the most effective conservation strategy, as regrowing a primary forest can take centuries.</p>', 'Passage', @MentorID);
DECLARE @ResR2 INT = SCOPE_IDENTITY();

-- ── SECTIONS ─────────────────────────────────────────────────
INSERT INTO ExamSections (ExamID, SectionName, Skill, ResourceID, OrderIndex)
VALUES (@ExamID, 'Listening - Part 1', 'Listening', @ResL1, 1);
DECLARE @SecL1 INT = SCOPE_IDENTITY();

INSERT INTO ExamSections (ExamID, SectionName, Skill, ResourceID, OrderIndex)
VALUES (@ExamID, 'Listening - Part 2', 'Listening', @ResL2, 2);
DECLARE @SecL2 INT = SCOPE_IDENTITY();

INSERT INTO ExamSections (ExamID, SectionName, Skill, ResourceID, OrderIndex)
VALUES (@ExamID, 'Reading - Passage 1', 'Reading', @ResR1, 3);
DECLARE @SecR1 INT = SCOPE_IDENTITY();

INSERT INTO ExamSections (ExamID, SectionName, Skill, ResourceID, OrderIndex)
VALUES (@ExamID, 'Reading - Passage 2', 'Reading', @ResR2, 4);
DECLARE @SecR2 INT = SCOPE_IDENTITY();

INSERT INTO ExamSections (ExamID, SectionName, Skill, ResourceID, OrderIndex)
VALUES (@ExamID, 'Writing - Task 1 & Task 2', 'Writing', NULL, 5);
DECLARE @SecW INT = SCOPE_IDENTITY();

INSERT INTO ExamSections (ExamID, SectionName, Skill, ResourceID, OrderIndex)
VALUES (@ExamID, 'Speaking - Full Interview', 'Speaking', NULL, 6);
DECLARE @SecS INT = SCOPE_IDENTITY();

-- ═══════════════════════════════════════════════════════════
-- LISTENING PART 1 – 5 Questions
-- ═══════════════════════════════════════════════════════════
DECLARE @Q INT;

INSERT INTO Questions (ResourceID, Content, QuestionType, Skill, Difficulty, contentJSON, CreatedBy)
VALUES (@ResL1, 'Q1. Where does the conversation take place?', 'Multiple_Choice', 'Listening', 'Easy', '{}', @MentorID);
SET @Q = SCOPE_IDENTITY();
INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex) VALUES (@SecL1, @Q, 1);
INSERT INTO Answers (QuestionID, Content, ContentJson, IsCorrect)
VALUES (@Q, 'A. A university office', '{}', 1),
       (@Q, 'B. A public library', '{}', 0),
       (@Q, 'C. A shopping centre', '{}', 0),
       (@Q, 'D. A sports centre', '{}', 0);

INSERT INTO Questions (ResourceID, Content, QuestionType, Skill, Difficulty, contentJSON, CreatedBy)
VALUES (@ResL1, 'Q2. What is the main purpose of the conversation?', 'Multiple_Choice', 'Listening', 'Easy', '{}', @MentorID);
SET @Q = SCOPE_IDENTITY();
INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex) VALUES (@SecL1, @Q, 2);
INSERT INTO Answers (QuestionID, Content, ContentJson, IsCorrect)
VALUES (@Q, 'A. To book a room', '{}', 0),
       (@Q, 'B. To register for a course', '{}', 1),
       (@Q, 'C. To pay a fee', '{}', 0),
       (@Q, 'D. To request information', '{}', 0);

INSERT INTO Questions (ResourceID, Content, QuestionType, Skill, Difficulty, contentJSON, CreatedBy)
VALUES (@ResL1, 'Q3. What time does the class start?', 'Multiple_Choice', 'Listening', 'Easy', '{}', @MentorID);
SET @Q = SCOPE_IDENTITY();
INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex) VALUES (@SecL1, @Q, 3);
INSERT INTO Answers (QuestionID, Content, ContentJson, IsCorrect)
VALUES (@Q, 'A. 9:00 AM', '{}', 0),
       (@Q, 'B. 10:00 AM', '{}', 1),
       (@Q, 'C. 11:00 AM', '{}', 0),
       (@Q, 'D. 2:00 PM', '{}', 0);

INSERT INTO Questions (ResourceID, Content, QuestionType, Skill, Difficulty, contentJSON, CreatedBy)
VALUES (@ResL1, 'Q4. How much does the registration cost?', 'Multiple_Choice', 'Listening', 'Medium', '{}', @MentorID);
SET @Q = SCOPE_IDENTITY();
INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex) VALUES (@SecL1, @Q, 4);
INSERT INTO Answers (QuestionID, Content, ContentJson, IsCorrect)
VALUES (@Q, 'A. £25', '{}', 0),
       (@Q, 'B. £35', '{}', 0),
       (@Q, 'C. £45', '{}', 1),
       (@Q, 'D. £55', '{}', 0);

INSERT INTO Questions (ResourceID, Content, QuestionType, Skill, Difficulty, contentJSON, CreatedBy)
VALUES (@ResL1, 'Q5. The student needs to bring a ________ to the first class.', 'FillBlank', 'Listening', 'Medium', '{}', @MentorID);
SET @Q = SCOPE_IDENTITY();
INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex) VALUES (@SecL1, @Q, 5);
INSERT INTO Answers (QuestionID, Content, ContentJson, IsCorrect) VALUES (@Q, 'photograph', '{}', 1);

-- ═══════════════════════════════════════════════════════════
-- LISTENING PART 2 – 5 Questions
-- ═══════════════════════════════════════════════════════════
INSERT INTO Questions (ResourceID, Content, QuestionType, Skill, Difficulty, contentJSON, CreatedBy)
VALUES (@ResL2, 'Q6. What is the main topic of the talk?', 'Multiple_Choice', 'Listening', 'Easy', '{}', @MentorID);
SET @Q = SCOPE_IDENTITY();
INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex) VALUES (@SecL2, @Q, 1);
INSERT INTO Answers (QuestionID, Content, ContentJson, IsCorrect)
VALUES (@Q, 'A. Wildlife conservation', '{}', 0),
       (@Q, 'B. Climate change solutions', '{}', 1),
       (@Q, 'C. Urban planning', '{}', 0),
       (@Q, 'D. Renewable energy costs', '{}', 0);

INSERT INTO Questions (ResourceID, Content, QuestionType, Skill, Difficulty, contentJSON, CreatedBy)
VALUES (@ResL2, 'Q7. According to the speaker, what percentage of energy now comes from solar power?', 'Multiple_Choice', 'Listening', 'Medium', '{}', @MentorID);
SET @Q = SCOPE_IDENTITY();
INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex) VALUES (@SecL2, @Q, 2);
INSERT INTO Answers (QuestionID, Content, ContentJson, IsCorrect)
VALUES (@Q, 'A. 12%', '{}', 0),
       (@Q, 'B. 18%', '{}', 0),
       (@Q, 'C. 23%', '{}', 1),
       (@Q, 'D. 31%', '{}', 0);

INSERT INTO Questions (ResourceID, Content, QuestionType, Skill, Difficulty, contentJSON, CreatedBy)
VALUES (@ResL2, 'Q8. What does the speaker say is the biggest challenge facing renewable energy?', 'Multiple_Choice', 'Listening', 'Medium', '{}', @MentorID);
SET @Q = SCOPE_IDENTITY();
INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex) VALUES (@SecL2, @Q, 3);
INSERT INTO Answers (QuestionID, Content, ContentJson, IsCorrect)
VALUES (@Q, 'A. Public acceptance', '{}', 0),
       (@Q, 'B. Storage technology', '{}', 1),
       (@Q, 'C. Government policy', '{}', 0),
       (@Q, 'D. Manufacturing costs', '{}', 0);

INSERT INTO Questions (ResourceID, Content, QuestionType, Skill, Difficulty, contentJSON, CreatedBy)
VALUES (@ResL2, 'Q9. The new battery technology can store energy for up to ________ hours.', 'FillBlank', 'Listening', 'Hard', '{}', @MentorID);
SET @Q = SCOPE_IDENTITY();
INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex) VALUES (@SecL2, @Q, 4);
INSERT INTO Answers (QuestionID, Content, ContentJson, IsCorrect) VALUES (@Q, '72', '{}', 1);

INSERT INTO Questions (ResourceID, Content, QuestionType, Skill, Difficulty, contentJSON, CreatedBy)
VALUES (@ResL2, 'Q10. What does the speaker recommend listeners do first?', 'Multiple_Choice', 'Listening', 'Medium', '{}', @MentorID);
SET @Q = SCOPE_IDENTITY();
INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex) VALUES (@SecL2, @Q, 5);
INSERT INTO Answers (QuestionID, Content, ContentJson, IsCorrect)
VALUES (@Q, 'A. Contact their local council', '{}', 0),
       (@Q, 'B. Reduce personal energy consumption', '{}', 0),
       (@Q, 'C. Sign up to the campaign website', '{}', 1),
       (@Q, 'D. Donate to the charity', '{}', 0);

-- ═══════════════════════════════════════════════════════════
-- READING PASSAGE 1 – 6 Questions
-- ═══════════════════════════════════════════════════════════
INSERT INTO Questions (ResourceID, Content, QuestionType, Skill, Difficulty, contentJSON, CreatedBy)
VALUES (@ResR1, 'Q11. The urban farm in Paris was established in 2018.', 'Multiple_Choice', 'Reading', 'Easy', '{}', @MentorID);
SET @Q = SCOPE_IDENTITY();
INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex) VALUES (@SecR1, @Q, 1);
INSERT INTO Answers (QuestionID, Content, ContentJson, IsCorrect)
VALUES (@Q, 'True', '{}', 1), (@Q, 'False', '{}', 0), (@Q, 'Not Given', '{}', 0);

INSERT INTO Questions (ResourceID, Content, QuestionType, Skill, Difficulty, contentJSON, CreatedBy)
VALUES (@ResR1, 'Q12. The underground farms cover more than 10,000 square metres.', 'Multiple_Choice', 'Reading', 'Easy', '{}', @MentorID);
SET @Q = SCOPE_IDENTITY();
INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex) VALUES (@SecR1, @Q, 2);
INSERT INTO Answers (QuestionID, Content, ContentJson, IsCorrect)
VALUES (@Q, 'True', '{}', 1), (@Q, 'False', '{}', 0), (@Q, 'Not Given', '{}', 0);

INSERT INTO Questions (ResourceID, Content, QuestionType, Skill, Difficulty, contentJSON, CreatedBy)
VALUES (@ResR1, 'Q13. Yields have increased by 40% compared to ________ farming.', 'FillBlank', 'Reading', 'Medium', '{}', @MentorID);
SET @Q = SCOPE_IDENTITY();
INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex) VALUES (@SecR1, @Q, 3);
INSERT INTO Answers (QuestionID, Content, ContentJson, IsCorrect) VALUES (@Q, 'conventional surface', '{}', 1);

INSERT INTO Questions (ResourceID, Content, QuestionType, Skill, Difficulty, contentJSON, CreatedBy)
VALUES (@ResR1, 'Q14. Why does the underground environment improve yield?', 'Multiple_Choice', 'Reading', 'Medium', '{}', @MentorID);
SET @Q = SCOPE_IDENTITY();
INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex) VALUES (@SecR1, @Q, 4);
INSERT INTO Answers (QuestionID, Content, ContentJson, IsCorrect)
VALUES (@Q, 'A. It uses less water', '{}', 0),
       (@Q, 'B. Stable temperature and humidity year-round', '{}', 1),
       (@Q, 'C. It receives more sunlight', '{}', 0),
       (@Q, 'D. Soil quality is better underground', '{}', 0);

INSERT INTO Questions (ResourceID, Content, QuestionType, Skill, Difficulty, contentJSON, CreatedBy)
VALUES (@ResR1, 'Q15. The founders power their farms using 100% ________ energy.', 'FillBlank', 'Reading', 'Medium', '{}', @MentorID);
SET @Q = SCOPE_IDENTITY();
INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex) VALUES (@SecR1, @Q, 5);
INSERT INTO Answers (QuestionID, Content, ContentJson, IsCorrect) VALUES (@Q, 'renewable', '{}', 1);

INSERT INTO Questions (ResourceID, Content, QuestionType, Skill, Difficulty, contentJSON, CreatedBy)
VALUES (@ResR1, 'Q16. Which TWO cities are running pilot programmes based on the Paris design?', 'Multiple_Choice', 'Reading', 'Hard', '{}', @MentorID);
SET @Q = SCOPE_IDENTITY();
INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex) VALUES (@SecR1, @Q, 6);
INSERT INTO Answers (QuestionID, Content, ContentJson, IsCorrect)
VALUES (@Q, 'A. Amsterdam and Berlin', '{}', 1),
       (@Q, 'B. London and Rome', '{}', 0),
       (@Q, 'C. Madrid and Vienna', '{}', 0),
       (@Q, 'D. Brussels and Prague', '{}', 0);

-- ═══════════════════════════════════════════════════════════
-- READING PASSAGE 2 – 6 Questions
-- ═══════════════════════════════════════════════════════════
INSERT INTO Questions (ResourceID, Content, QuestionType, Skill, Difficulty, contentJSON, CreatedBy)
VALUES (@ResR2, 'Q17. Forests cover approximately 31% of the Earth''s total land area.', 'Multiple_Choice', 'Reading', 'Easy', '{}', @MentorID);
SET @Q = SCOPE_IDENTITY();
INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex) VALUES (@SecR2, @Q, 1);
INSERT INTO Answers (QuestionID, Content, ContentJson, IsCorrect)
VALUES (@Q, 'True', '{}', 1), (@Q, 'False', '{}', 0), (@Q, 'Not Given', '{}', 0);

INSERT INTO Questions (ResourceID, Content, QuestionType, Skill, Difficulty, contentJSON, CreatedBy)
VALUES (@ResR2, 'Q18. According to the passage, how many hectares of forest are lost each year?', 'Multiple_Choice', 'Reading', 'Easy', '{}', @MentorID);
SET @Q = SCOPE_IDENTITY();
INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex) VALUES (@SecR2, @Q, 2);
INSERT INTO Answers (QuestionID, Content, ContentJson, IsCorrect)
VALUES (@Q, 'A. 5 million', '{}', 0),
       (@Q, 'B. 10 million', '{}', 1),
       (@Q, 'C. 15 million', '{}', 0),
       (@Q, 'D. 20 million', '{}', 0);

INSERT INTO Questions (ResourceID, Content, QuestionType, Skill, Difficulty, contentJSON, CreatedBy)
VALUES (@ResR2, 'Q19. Critics argue that monoculture plantations have limited ________.', 'FillBlank', 'Reading', 'Medium', '{}', @MentorID);
SET @Q = SCOPE_IDENTITY();
INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex) VALUES (@SecR2, @Q, 3);
INSERT INTO Answers (QuestionID, Content, ContentJson, IsCorrect) VALUES (@Q, 'biodiversity', '{}', 1);

INSERT INTO Questions (ResourceID, Content, QuestionType, Skill, Difficulty, contentJSON, CreatedBy)
VALUES (@ResR2, 'Q20. What is "passive rewilding"?', 'Multiple_Choice', 'Reading', 'Medium', '{}', @MentorID);
SET @Q = SCOPE_IDENTITY();
INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex) VALUES (@SecR2, @Q, 4);
INSERT INTO Answers (QuestionID, Content, ContentJson, IsCorrect)
VALUES (@Q, 'A. Planting monoculture forests', '{}', 0),
       (@Q, 'B. Removing invasive species and allowing native vegetation to regenerate', '{}', 1),
       (@Q, 'C. Building wildlife corridors', '{}', 0),
       (@Q, 'D. Introducing new animal species', '{}', 0);

INSERT INTO Questions (ResourceID, Content, QuestionType, Skill, Difficulty, contentJSON, CreatedBy)
VALUES (@ResR2, 'Q21. Passive rewilding has shown promising results in parts of Europe and ________.', 'FillBlank', 'Reading', 'Medium', '{}', @MentorID);
SET @Q = SCOPE_IDENTITY();
INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex) VALUES (@SecR2, @Q, 5);
INSERT INTO Answers (QuestionID, Content, ContentJson, IsCorrect) VALUES (@Q, 'South America', '{}', 1);

INSERT INTO Questions (ResourceID, Content, QuestionType, Skill, Difficulty, contentJSON, CreatedBy)
VALUES (@ResR2, 'Q22. According to experts, regrowing a primary forest can take ________.', 'Multiple_Choice', 'Reading', 'Hard', '{}', @MentorID);
SET @Q = SCOPE_IDENTITY();
INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex) VALUES (@SecR2, @Q, 6);
INSERT INTO Answers (QuestionID, Content, ContentJson, IsCorrect)
VALUES (@Q, 'A. Decades', '{}', 0),
       (@Q, 'B. Centuries', '{}', 1),
       (@Q, 'C. Millennia', '{}', 0),
       (@Q, 'D. A generation', '{}', 0);

-- ═══════════════════════════════════════════════════════════
-- WRITING – 2 Tasks
-- ═══════════════════════════════════════════════════════════
INSERT INTO Questions (ResourceID, Content, QuestionType, Skill, Difficulty, contentJSON, CreatedBy)
VALUES (NULL,
'<b>Writing Task 1</b><br><br>
The bar chart below shows the percentage of men and women enrolled in further education in Britain across three time periods: 1970–71, 1980–81, and 1990–91. It also distinguishes between full-time and part-time students.<br><br>
<b>Summarise the information by selecting and reporting the main features, and make comparisons where relevant.</b><br><br>
<i>Write at least <b>150 words</b>.</i>',
'Essay', 'Writing', 'Medium', '{}', @MentorID);
SET @Q = SCOPE_IDENTITY();
INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex) VALUES (@SecW, @Q, 1);

INSERT INTO Questions (ResourceID, Content, QuestionType, Skill, Difficulty, contentJSON, CreatedBy)
VALUES (NULL,
'<b>Writing Task 2</b><br><br>
Some people believe that unpaid community service should be a compulsory part of high school programmes (for example, working for a charity, improving the neighbourhood, or teaching sports to younger children).<br><br>
<b>To what extent do you agree or disagree with this view?</b><br><br>
Give reasons for your answer and include any relevant examples from your own knowledge or experience.<br><br>
<i>Write at least <b>250 words</b>.</i>',
'Essay', 'Writing', 'Hard', '{}', @MentorID);
SET @Q = SCOPE_IDENTITY();
INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex) VALUES (@SecW, @Q, 2);

-- ═══════════════════════════════════════════════════════════
-- SPEAKING – 3 Parts
-- ═══════════════════════════════════════════════════════════
INSERT INTO Questions (ResourceID, Content, QuestionType, Skill, Difficulty, contentJSON, CreatedBy)
VALUES (NULL,
'<b>Part 1 – Introduction &amp; Interview</b> <span style="font-size:0.9rem;color:#6b7280;">(4–5 minutes)</span><br><br>
The examiner will ask you general questions about familiar topics.<br><br>
<b>Topic: Your Home Town &amp; Daily Routine</b><br>
1. Where do you come from?<br>
2. What do you like most about your home town?<br>
3. Has it changed much since you were a child?<br>
4. What do you usually do in the evenings?<br>
5. Do you prefer to spend time alone or with others? Why?',
'Speaking', 'Speaking', 'Easy', '{}', @MentorID);
SET @Q = SCOPE_IDENTITY();
INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex) VALUES (@SecS, @Q, 1);

INSERT INTO Questions (ResourceID, Content, QuestionType, Skill, Difficulty, contentJSON, CreatedBy)
VALUES (NULL,
'<b>Part 2 – Individual Long Turn</b> <span style="font-size:0.9rem;color:#6b7280;">(3–4 minutes)</span><br><br>
You will have <b>1 minute to prepare</b>. Then speak for <b>1–2 minutes</b> on the following topic.<br><br>
<div style="background:#f8fafc;border:1px solid #e2e8f0;border-radius:8px;padding:1.25rem;margin-top:1rem;">
<b>Describe a memorable journey you have taken.</b><br><br>
You should say:<br>
• &nbsp;where you went and why<br>
• &nbsp;who you went with<br>
• &nbsp;what happened during the journey<br>
• &nbsp;and explain why this journey was particularly memorable for you.
</div>',
'Speaking', 'Speaking', 'Medium', '{}', @MentorID);
SET @Q = SCOPE_IDENTITY();
INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex) VALUES (@SecS, @Q, 2);

INSERT INTO Questions (ResourceID, Content, QuestionType, Skill, Difficulty, contentJSON, CreatedBy)
VALUES (NULL,
'<b>Part 3 – Two-Way Discussion</b> <span style="font-size:0.9rem;color:#6b7280;">(4–5 minutes)</span><br><br>
The examiner will ask you more abstract questions related to the topic in Part 2.<br><br>
<b>Topic: Travel &amp; Tourism</b><br>
1. Why do you think people enjoy travelling to new places?<br>
2. How has the way people travel changed over the past 20 years?<br>
3. What are the advantages and disadvantages of mass tourism for a country?<br>
4. Do you think it is important for people to experience different cultures? Why?<br>
5. Some people say that virtual reality will replace actual travel in the future. Do you agree?',
'Speaking', 'Speaking', 'Hard', '{}', @MentorID);
SET @Q = SCOPE_IDENTITY();
INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex) VALUES (@SecS, @Q, 3);

-- ── RESULT ───────────────────────────────────────────────────
PRINT '══════════════════════════════════════════════';
PRINT ' SUCCESS – Mock Exam inserted!';
PRINT ' ExamID = ' + CAST(@ExamID AS VARCHAR);
PRINT ' Listening: Part 1 (5 Qs) + Part 2 (5 Qs)';
PRINT ' Reading:   Passage 1 (6 Qs) + Passage 2 (6 Qs)';
PRINT ' Writing:   Task 1 + Task 2';
PRINT ' Speaking:  Part 1 + Part 2 + Part 3';
PRINT '══════════════════════════════════════════════';
