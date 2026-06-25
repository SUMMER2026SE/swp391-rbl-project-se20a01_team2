USE IELTSFlow;
GO

-- Xóa các đề mẫu cũ để tránh trùng lặp
DELETE FROM Exams WHERE Title LIKE N'Sample IELTS Reading%';
GO

-- 1. TẠO MOCK TEST
INSERT INTO Exams (Title, Type, SkillFocus, Duration, MentorID, CreatedAt, Deleted)
VALUES (N'Sample IELTS Reading Mock Test', 'Mock Test', 'All', 60, 1, GETDATE(), 0);
DECLARE @MockExamID INT = SCOPE_IDENTITY();

-- 2. TẠO PLACEMENT TEST (Theo yêu cầu: liên kết dữ liệu với placement test)
INSERT INTO Exams (Title, Type, SkillFocus, Duration, MentorID, CreatedAt, Deleted)
VALUES (N'Sample IELTS Reading Placement Test', 'Placement Test', 'All', 60, 1, GETDATE(), 0);
DECLARE @PlacementExamID INT = SCOPE_IDENTITY();

-- Biến chung
DECLARE @QID INT;

-- =========================================================
-- PASSAGE 1
-- =========================================================

-- Thêm bài đọc (Resource)
INSERT INTO QuestionResource (ResourceText, Type) 
VALUES (N'A. The ping of a text message has never sounded so sweet. In what is being touted as a world first, Kenya''s biggest mobile operator is allowing subscribers to send cash to other phone users by SMS. Known as M-Pesa, or mobile money, the service is expected to revolutionise banking in a country where more than 80% of people are excluded from the formal financial sector. Apart from transferring cash - a service much in demand among urban Kenyans supporting relatives in rural areas - customers of the Safaricom network will be able to keep up to 50,000 shillings (£370) in a "virtual account" on their handsets.

B. Developed by Vodafone, which holds a 35% share in Safaricom, M-Pesa was formally launched in Kenya two weeks ago. More than 10,000 people have signed up for the service, with around 8 million shillings transferred so far, mostly in tiny denominations. Safaricom''s executives are confident that growth will be strong in Kenya, and later across Africa. “We are effectively giving people ATM cards without them ever having to open a real bank account,” said Michael Joseph, chief executive of Safaricom, who called the money transfer concept the “next big thing” in mobile telephony.

C. M-Pesa''s is simple. There is no need for a new handset or SIM card. To send money, you hand over the cash to a registered agent - typically a retailer - who credits your virtual account. You then send between 100 shillings (74p) and 35,000 shillings (£259) via text message to the desired recipient - even someone on a different mobile network - who cashes it at an agent by entering a secret code and showing ID. A commission of up to 170 shillings (£1.25) is paid by the recipient but it compares favourably with fees levied by the major banks, whose services are too expensive for most of the population.

D. Mobile phone growth in Kenya, as in most of Africa, has been remarkable, even among the rural poor. In June 1999, Kenya had 15,000 mobile subscribers. Today, it has nearly 8 million out of a population of 35 million, and the two operators'' networks are as extensive as the access to banks is limited. Safaricom says it is not so much competing with financial services companies as filling a void. In time, M-Pesa will allow people to borrow and repay money, and make purchases. Companies will be able to pay salaries directly into workers'' phones - something that has already attracted the interest of larger employers, such as the tea companies, whose workers often have to be paid in cash as they do not have bank accounts. There are concerns about security, but Safaricom insists that even if someone''s phone is stolen, the PIN system prevents unauthorised withdrawals. Mr. Joseph said the only danger is sending cash to the wrong mobile number and the recipient redeeming it straight away.

E. The project is being watched closely by mobile operators around the world as a way of targeting the multibillion pound international cash transfer industry long dominated by companies such as Western Union and Moneygram. Remittances sent from nearly 200 million migrant workers to developing countries totalled £102 billion last year, according to the World Bank. The GSM Association, which represents more than 700 mobile operators worldwide, believes this could quadruple by 2012 if transfers by SMS become the norm. Vodafone has entered a partnership with Citigroup that will soon allow Kenyans in the UK to send money home via text message. The charge for sending £50 is expected to be about £3, less than a third of what some traditional services charge.', 'Passage');
DECLARE @Res1 INT = SCOPE_IDENTITY();

-- Tạo Section cho cả 2 đề
INSERT INTO ExamSections (ExamID, SectionName, ResourceID, OrderIndex) VALUES (@MockExamID, 'Reading Passage 1: Money Transfers by Mobile', @Res1, 1);
DECLARE @MockSec1 INT = SCOPE_IDENTITY();
INSERT INTO ExamSections (ExamID, SectionName, ResourceID, OrderIndex) VALUES (@PlacementExamID, 'Reading Passage 1: Money Transfers by Mobile', @Res1, 1);
DECLARE @PlaceSec1 INT = SCOPE_IDENTITY();

-- Câu 1-4: Matching Information 
INSERT INTO Questions (Content, QuestionType, Skill, Difficulty, contentJSON, ResourceID) VALUES ('Which paragraph contains the following information: A possible security problem', 'Multiple_Choice', 'Reading', 'Medium', '{}', @Res1);
SET @QID = SCOPE_IDENTITY();
INSERT INTO Answers (QuestionID, Content, IsCorrect, ContentJson) VALUES (@QID, 'A', 0, '{}'), (@QID, 'B', 0, '{}'), (@QID, 'C', 0, '{}'), (@QID, 'D', 1, '{}'), (@QID, 'E', 0, '{}');
INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex) VALUES (@MockSec1, @QID, 1), (@PlaceSec1, @QID, 1);

INSERT INTO Questions (Content, QuestionType, Skill, Difficulty, contentJSON, ResourceID) VALUES ('Which paragraph contains the following information: The cost of M-Pesa', 'Multiple_Choice', 'Reading', 'Medium', '{}', @Res1);
SET @QID = SCOPE_IDENTITY();
INSERT INTO Answers (QuestionID, Content, IsCorrect, ContentJson) VALUES (@QID, 'A', 0, '{}'), (@QID, 'B', 0, '{}'), (@QID, 'C', 1, '{}'), (@QID, 'D', 0, '{}'), (@QID, 'E', 0, '{}');
INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex) VALUES (@MockSec1, @QID, 2), (@PlaceSec1, @QID, 2);

INSERT INTO Questions (Content, QuestionType, Skill, Difficulty, contentJSON, ResourceID) VALUES ('Which paragraph contains the following information: An international service similar to M-Pesa', 'Multiple_Choice', 'Reading', 'Medium', '{}', @Res1);
SET @QID = SCOPE_IDENTITY();
INSERT INTO Answers (QuestionID, Content, IsCorrect, ContentJson) VALUES (@QID, 'A', 0, '{}'), (@QID, 'B', 0, '{}'), (@QID, 'C', 0, '{}'), (@QID, 'D', 0, '{}'), (@QID, 'E', 1, '{}');
INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex) VALUES (@MockSec1, @QID, 3), (@PlaceSec1, @QID, 3);

INSERT INTO Questions (Content, QuestionType, Skill, Difficulty, contentJSON, ResourceID) VALUES ('Which paragraph contains the following information: The fact that most Kenyans do not have a bank account', 'Multiple_Choice', 'Reading', 'Medium', '{}', @Res1);
SET @QID = SCOPE_IDENTITY();
INSERT INTO Answers (QuestionID, Content, IsCorrect, ContentJson) VALUES (@QID, 'A', 1, '{}'), (@QID, 'B', 0, '{}'), (@QID, 'C', 0, '{}'), (@QID, 'D', 0, '{}'), (@QID, 'E', 0, '{}');
INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex) VALUES (@MockSec1, @QID, 4), (@PlaceSec1, @QID, 4);

-- Câu 5-8: Fill In Blanks
INSERT INTO Questions (Content, QuestionType, Skill, Difficulty, contentJSON, ResourceID) VALUES ('Complete the sentence (NO MORE THAN THREE WORDS): Safaricom is the _____ mobile phone company in Kenya.', 'FillInBlanks', 'Reading', 'Easy', '{}', @Res1);
SET @QID = SCOPE_IDENTITY();
INSERT INTO Answers (QuestionID, Content, IsCorrect, ContentJson) VALUES (@QID, 'biggest', 1, '{}');
INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex) VALUES (@MockSec1, @QID, 5), (@PlaceSec1, @QID, 5);

INSERT INTO Questions (Content, QuestionType, Skill, Difficulty, contentJSON, ResourceID) VALUES ('Complete the sentence (NO MORE THAN THREE WORDS): An M-Pesa account needs to be credited by _____.', 'FillInBlanks', 'Reading', 'Easy', '{}', @Res1);
SET @QID = SCOPE_IDENTITY();
INSERT INTO Answers (QuestionID, Content, IsCorrect, ContentJson) VALUES (@QID, 'a registered agent', 1, '{}');
INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex) VALUES (@MockSec1, @QID, 6), (@PlaceSec1, @QID, 6);

INSERT INTO Questions (Content, QuestionType, Skill, Difficulty, contentJSON, ResourceID) VALUES ('Complete the sentence (NO MORE THAN THREE WORDS): _____ companies are particularly interested in using M-Pesa.', 'FillInBlanks', 'Reading', 'Easy', '{}', @Res1);
SET @QID = SCOPE_IDENTITY();
INSERT INTO Answers (QuestionID, Content, IsCorrect, ContentJson) VALUES (@QID, 'tea', 1, '{}');
INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex) VALUES (@MockSec1, @QID, 7), (@PlaceSec1, @QID, 7);

INSERT INTO Questions (Content, QuestionType, Skill, Difficulty, contentJSON, ResourceID) VALUES ('Complete the sentence (NO MORE THAN THREE WORDS): Companies like Moneygram and Western Union have _____ the international money transfer market.', 'FillInBlanks', 'Reading', 'Medium', '{}', @Res1);
SET @QID = SCOPE_IDENTITY();
INSERT INTO Answers (QuestionID, Content, IsCorrect, ContentJson) VALUES (@QID, 'long dominated', 1, '{}');
INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex) VALUES (@MockSec1, @QID, 8), (@PlaceSec1, @QID, 8);

-- Câu 9-13: TRUE/FALSE/NOT GIVEN
INSERT INTO Questions (Content, QuestionType, Skill, Difficulty, contentJSON, ResourceID) VALUES ('TRUE/FALSE/NOT GIVEN: Most Kenyans working in urban areas have relatives in rural areas.', 'Multiple_Choice', 'Reading', 'Medium', '{}', @Res1);
SET @QID = SCOPE_IDENTITY();
INSERT INTO Answers (QuestionID, Content, IsCorrect, ContentJson) VALUES (@QID, 'TRUE', 0, '{}'), (@QID, 'FALSE', 0, '{}'), (@QID, 'NOT GIVEN', 1, '{}');
INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex) VALUES (@MockSec1, @QID, 9), (@PlaceSec1, @QID, 9);

INSERT INTO Questions (Content, QuestionType, Skill, Difficulty, contentJSON, ResourceID) VALUES ('TRUE/FALSE/NOT GIVEN: So far, most of the people using M-Pesa have used it to send small amounts of money.', 'Multiple_Choice', 'Reading', 'Easy', '{}', @Res1);
SET @QID = SCOPE_IDENTITY();
INSERT INTO Answers (QuestionID, Content, IsCorrect, ContentJson) VALUES (@QID, 'TRUE', 1, '{}'), (@QID, 'FALSE', 0, '{}'), (@QID, 'NOT GIVEN', 0, '{}');
INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex) VALUES (@MockSec1, @QID, 10), (@PlaceSec1, @QID, 10);

INSERT INTO Questions (Content, QuestionType, Skill, Difficulty, contentJSON, ResourceID) VALUES ('TRUE/FALSE/NOT GIVEN: M-Pesa can only be used by people using one phone network.', 'Multiple_Choice', 'Reading', 'Medium', '{}', @Res1);
SET @QID = SCOPE_IDENTITY();
INSERT INTO Answers (QuestionID, Content, IsCorrect, ContentJson) VALUES (@QID, 'TRUE', 0, '{}'), (@QID, 'FALSE', 1, '{}'), (@QID, 'NOT GIVEN', 0, '{}');
INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex) VALUES (@MockSec1, @QID, 11), (@PlaceSec1, @QID, 11);

INSERT INTO Questions (Content, QuestionType, Skill, Difficulty, contentJSON, ResourceID) VALUES ('TRUE/FALSE/NOT GIVEN: M-Pesa can be used to buy products and services.', 'Multiple_Choice', 'Reading', 'Medium', '{}', @Res1);
SET @QID = SCOPE_IDENTITY();
INSERT INTO Answers (QuestionID, Content, IsCorrect, ContentJson) VALUES (@QID, 'TRUE', 0, '{}'), (@QID, 'FALSE', 1, '{}'), (@QID, 'NOT GIVEN', 0, '{}');
INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex) VALUES (@MockSec1, @QID, 12), (@PlaceSec1, @QID, 12);

INSERT INTO Questions (Content, QuestionType, Skill, Difficulty, contentJSON, ResourceID) VALUES ('TRUE/FALSE/NOT GIVEN: The GSM Association is a consumer organisation.', 'Multiple_Choice', 'Reading', 'Easy', '{}', @Res1);
SET @QID = SCOPE_IDENTITY();
INSERT INTO Answers (QuestionID, Content, IsCorrect, ContentJson) VALUES (@QID, 'TRUE', 0, '{}'), (@QID, 'FALSE', 1, '{}'), (@QID, 'NOT GIVEN', 0, '{}');
INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex) VALUES (@MockSec1, @QID, 13), (@PlaceSec1, @QID, 13);


-- =========================================================
-- PASSAGE 2
-- =========================================================
INSERT INTO QuestionResource (ResourceText, Type) 
VALUES (N'A. More than a million people are likely to be disappointed by their experience of the Government''s attempts to improve the democratic process. They may have signed an online petition against road pricing, but ministers are determined to push ahead with plans to make it more expensive to drive. The Government is convinced that this is the only way to reduce congestion and the environmental damage caused by motoring.

B. Why wait until you are forced off the road by costly charges? You may enjoy the convenience of your car, but the truth is that for huge numbers of people, owning a car makes little financial sense. You''d be far better off giving it up and relying on other forms of transport. "I''m 47 and I''ve never owned a car, despite having a job that requires me to travel all over the South-East to visit clients," says Donnachadh McCarthy, an environmental expert who specialises in advising people how to be greener. "A car is a huge financial commitment, as well as being a psychological addiction. Not owning a vehicle is far more practical than most people realise."

C. It may seem as if cars have never been cheaper. After all, it is now possible to buy a brand new car for less than £4,800 - the Perodua Kelisa, if you''re interested. There are plenty of decent vehicles you can buy straight from the showroom for between £5,000 and £7,000. Of course, if you buy second-hand, the prices will be even lower. However, the falling purchase price of cars masks the fact that it has never been more expensive to own and run a vehicle. The estimate is that the cost of running a car rose by more than ten per cent last year alone. The annual cost of running your own vehicle is put at an average of £5,539, or £107 a week. While drivers who do less or more than the average mileage each year will spend correspondingly less or more, many of the costs of car ownership are fixed - and therefore unavoidable.

D. Depreciation - the fact that your vehicle loses a large chunk of its resale value each year - is one problem, accounting for £2,420 a year. The cost of finance packages, which most people have to resort to to pay for at least part of the price of a new car, has also been rising - to an average of £1,040 a year. Then there''s insurance, maintenance, tax, and breakdown insurance, all of which will cost you broadly the same amount, however many miles you do. Only fuel costs are truly variable. While petrol prices are the most visible indicator of the cost of running a car, for the typical driver they account for less than one fifth of the real costs each year. In other words, leaving aside all the practical and psychological barriers to giving up your car, in financial terms, doing so makes sense for many people.

E. Take the cost of public transport, for example. In London, the most expensive city in the UK, the most expensive annual travel card, allowing travel in any zone at any time, costs just over £1,700. You could give up your car and still have thousands of pounds to spare to spend on occasional car hire. In fact, assuming that you have the most expensive travel card in London, you could hire a cheap car from a company, such as easyCar for about 30 weeks a year, and still be better off overall than if you own your own vehicle. Not that car hire is necessarily the most cost-effective option for people who are prepared to do without a car but may still need to drive occasionally.

F. Streetcar, one of several "car clubs" with growing numbers of members, reckons that using its vehicles twice a week, every week, for a year, would cost you just £700. Streetcar''s model works very similarly to those of its main rivals, Citycarclub and Whizzgo. These three companies, which now operate in 20 of Britain''s towns and cities, charge their members a refundable deposit - £150 at Streetcar - and then provide them with an electronic smart card. This enables members to get into the vehicles, which are left parked in set locations, and the keys are then found in the glove compartment. Members pay an hourly rate for the car - £4.95 is the cost at Streetcar - and return it to the same spot, or to a different designated parking place.

G. Car sharing is an increasingly popular option for people making the same journeys regularly - to and from work, for example. Many companies run schemes that help colleagues who live near to each other and work in the same place to contact each other so they can share the journey to work. Liftshare and Carshare are two national organisations that maintain online databases of people who would be prepared to team up. Other people may be able to replace part or all of their journey to work - or any journeys, for that matter - with low-cost transport such as a bicycle, or even by just walking. The more you can reduce your car use, however you gain access to it, the more you will save.', 'Passage');
DECLARE @Res2 INT = SCOPE_IDENTITY();

INSERT INTO ExamSections (ExamID, SectionName, ResourceID, OrderIndex) VALUES (@MockExamID, 'Reading Passage 2: Park the Car Permanently', @Res2, 2);
DECLARE @MockSec2 INT = SCOPE_IDENTITY();
INSERT INTO ExamSections (ExamID, SectionName, ResourceID, OrderIndex) VALUES (@PlacementExamID, 'Reading Passage 2: Park the Car Permanently', @Res2, 2);
DECLARE @PlaceSec2 INT = SCOPE_IDENTITY();

-- Câu 14-17: Matching Headings
INSERT INTO Questions (Content, QuestionType, Skill, Difficulty, contentJSON, ResourceID) VALUES ('Which paragraph does the following heading best fit: Don''t wait!', 'Multiple_Choice', 'Reading', 'Medium', '{}', @Res2);
SET @QID = SCOPE_IDENTITY();
INSERT INTO Answers (QuestionID, Content, IsCorrect, ContentJson) VALUES (@QID, 'A', 0, '{}'), (@QID, 'B', 1, '{}'), (@QID, 'C', 0, '{}'), (@QID, 'D', 0, '{}'), (@QID, 'E', 0, '{}'), (@QID, 'F', 0, '{}'), (@QID, 'G', 0, '{}');
INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex) VALUES (@MockSec2, @QID, 14), (@PlaceSec2, @QID, 14);

INSERT INTO Questions (Content, QuestionType, Skill, Difficulty, contentJSON, ResourceID) VALUES ('Which paragraph does the following heading best fit: Team up', 'Multiple_Choice', 'Reading', 'Medium', '{}', @Res2);
SET @QID = SCOPE_IDENTITY();
INSERT INTO Answers (QuestionID, Content, IsCorrect, ContentJson) VALUES (@QID, 'A', 0, '{}'), (@QID, 'B', 0, '{}'), (@QID, 'C', 0, '{}'), (@QID, 'D', 0, '{}'), (@QID, 'E', 0, '{}'), (@QID, 'F', 0, '{}'), (@QID, 'G', 1, '{}');
INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex) VALUES (@MockSec2, @QID, 15), (@PlaceSec2, @QID, 15);

INSERT INTO Questions (Content, QuestionType, Skill, Difficulty, contentJSON, ResourceID) VALUES ('Which paragraph does the following heading best fit: Join a club', 'Multiple_Choice', 'Reading', 'Medium', '{}', @Res2);
SET @QID = SCOPE_IDENTITY();
INSERT INTO Answers (QuestionID, Content, IsCorrect, ContentJson) VALUES (@QID, 'A', 0, '{}'), (@QID, 'B', 0, '{}'), (@QID, 'C', 0, '{}'), (@QID, 'D', 0, '{}'), (@QID, 'E', 0, '{}'), (@QID, 'F', 1, '{}'), (@QID, 'G', 0, '{}');
INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex) VALUES (@MockSec2, @QID, 16), (@PlaceSec2, @QID, 16);

INSERT INTO Questions (Content, QuestionType, Skill, Difficulty, contentJSON, ResourceID) VALUES ('Which paragraph does the following heading best fit: Use public transport', 'Multiple_Choice', 'Reading', 'Medium', '{}', @Res2);
SET @QID = SCOPE_IDENTITY();
INSERT INTO Answers (QuestionID, Content, IsCorrect, ContentJson) VALUES (@QID, 'A', 0, '{}'), (@QID, 'B', 0, '{}'), (@QID, 'C', 0, '{}'), (@QID, 'D', 0, '{}'), (@QID, 'E', 1, '{}'), (@QID, 'F', 0, '{}'), (@QID, 'G', 0, '{}');
INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex) VALUES (@MockSec2, @QID, 17), (@PlaceSec2, @QID, 17);

-- Câu 18-22: Choose 5 statements
DECLARE @I INT = 18;
WHILE @I <= 22
BEGIN
    INSERT INTO Questions (Content, QuestionType, Skill, Difficulty, contentJSON, ResourceID) VALUES ('Choose one of the FIVE true statements from A-H (Options: A, B, C, F, G). Statement ' + CAST((@I-17) AS VARCHAR), 'Multiple_Choice', 'Reading', 'Hard', '{}', @Res2);
    SET @QID = SCOPE_IDENTITY();
    INSERT INTO Answers (QuestionID, Content, IsCorrect, ContentJson) VALUES 
        (@QID, 'A. McCarthy claims people can become addicted to using cars.', CASE WHEN @I=18 THEN 1 ELSE 0 END, '{}'),
        (@QID, 'B. The cost of using a car rose by over ten per cent last year.', CASE WHEN @I=19 THEN 1 ELSE 0 END, '{}'),
        (@QID, 'C. Most British people borrow money to help buy cars.', CASE WHEN @I=20 THEN 1 ELSE 0 END, '{}'),
        (@QID, 'D. Many people need cars to drive in London occasionally.', 0, '{}'),
        (@QID, 'E. Streetcar operates in over 20 cities in Britain.', 0, '{}'),
        (@QID, 'F. Streetcar''s cars must be left at specific locations.', CASE WHEN @I=21 THEN 1 ELSE 0 END, '{}'),
        (@QID, 'G. Car sharing is becoming more popular with people who live and work near each other.', CASE WHEN @I=22 THEN 1 ELSE 0 END, '{}'),
        (@QID, 'H. The government wants to encourage people to go to work on foot or by bicycle.', 0, '{}');
    INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex) VALUES (@MockSec2, @QID, @I), (@PlaceSec2, @QID, @I);
    SET @I = @I + 1;
END

-- Câu 23-26: Multiple Choice
INSERT INTO Questions (Content, QuestionType, Skill, Difficulty, contentJSON, ResourceID) VALUES ('According to the information given in the text, the government has decided', 'Multiple_Choice', 'Reading', 'Medium', '{}', @Res2);
SET @QID = SCOPE_IDENTITY();
INSERT INTO Answers (QuestionID, Content, IsCorrect, ContentJson) VALUES 
    (@QID, 'A. not to follow protestors'' suggestions.', 0, '{}'),
    (@QID, 'B. to become more democratic.', 0, '{}'),
    (@QID, 'C. to go ahead with charging drivers to use roads.', 1, '{}'),
    (@QID, 'D. Both A and C', 0, '{}'),
    (@QID, 'E. Both B and C', 0, '{}');
INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex) VALUES (@MockSec2, @QID, 23), (@PlaceSec2, @QID, 23);

INSERT INTO Questions (Content, QuestionType, Skill, Difficulty, contentJSON, ResourceID) VALUES ('Cars are often', 'Multiple_Choice', 'Reading', 'Medium', '{}', @Res2);
SET @QID = SCOPE_IDENTITY();
INSERT INTO Answers (QuestionID, Content, IsCorrect, ContentJson) VALUES 
    (@QID, 'A. relatively cheap in Britain.', 0, '{}'),
    (@QID, 'B. relatively expensive to operate in Britain.', 0, '{}'),
    (@QID, 'C. sold second-hand in Britain.', 0, '{}'),
    (@QID, 'D. Both A and C', 1, '{}'),
    (@QID, 'E. Both A and B', 0, '{}');
INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex) VALUES (@MockSec2, @QID, 24), (@PlaceSec2, @QID, 24);

INSERT INTO Questions (Content, QuestionType, Skill, Difficulty, contentJSON, ResourceID) VALUES ('Fuel costs', 'Multiple_Choice', 'Reading', 'Medium', '{}', @Res2);
SET @QID = SCOPE_IDENTITY();
INSERT INTO Answers (QuestionID, Content, IsCorrect, ContentJson) VALUES 
    (@QID, 'A. make up about 20% of the cost of running a car.', 0, '{}'),
    (@QID, 'B. are related to the amount drivers pay for their cars.', 0, '{}'),
    (@QID, 'C. depend on how far you drive.', 1, '{}'),
    (@QID, 'D. Both A and C', 0, '{}'),
    (@QID, 'E. Both B and C', 0, '{}');
INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex) VALUES (@MockSec2, @QID, 25), (@PlaceSec2, @QID, 25);

INSERT INTO Questions (Content, QuestionType, Skill, Difficulty, contentJSON, ResourceID) VALUES ('Using public transport', 'Multiple_Choice', 'Reading', 'Medium', '{}', @Res2);
SET @QID = SCOPE_IDENTITY();
INSERT INTO Answers (QuestionID, Content, IsCorrect, ContentJson) VALUES 
    (@QID, 'A. will save money for British motorists, except in London.', 0, '{}'),
    (@QID, 'B. and renting a car part of the time can save money.', 1, '{}'),
    (@QID, 'C. costs Londoners about £1,700 a year.', 0, '{}');
INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex) VALUES (@MockSec2, @QID, 26), (@PlaceSec2, @QID, 26);

-- =========================================================
-- PASSAGE 3
-- =========================================================

INSERT INTO QuestionResource (ResourceText, Type) 
VALUES (N'Until three months ago, life in this humble village without electricity would come to a halt after sunset. Inside his mud-and-clay home, Ganpat Jadhav’s three children used to study in the dim, smoky glow of a kerosene lamp, when their monthly fuel quota of four litres dried up in just a fortnight, they had to strain their eyes using the light from a cooking fire. That all changed with the installation of low-cost, energy-efficient lamps that are powered entirely by the sun. The lights were installed by the Grameen Surya Bijli Foundation (GSBF), an Indian non-governmental organisation focused on bringing light to rural India. Some 100,000 Indian villages do not yet have electricity. The GSBF lamps use LEDs - light emitting diodes - that are four times more efficient than a normal bulb. After a $55 installation cost, solar energy lights the lamp free of charge. LED lighting, like cell phones, is another example of a technology whose low cost could allow the rural poor to leap into the 21st century.

As many as 1.5 billion people - nearly 80 million in India alone - light their houses using kerosene as the primary lighting media. The fuel is dangerous, dirty, and - despite being subsidised - consumes nearly four per cent of a typical rural Indian household''s budget. A recent report by the Intermediate Technology Development Group suggests that indoor air pollution from such lighting media results in 1.6 million deaths worldwide every year. LED lamps, or more specifically white LEDs, are believed to produce nearly 200 times more useful light than a kerosene lamp and almost 50 times the amount of useful light of a conventional bulb. "This technology can light an entire rural village with less energy than that used by a single conventional 100-watt light bulb," says Dave Irvine-Halliday, a professor of electrical engineering at the University of Calgary, Canada and the founder of Light up the World Foundation (LUTW). Founded in 1997, LUTW has used LED technology to bring light to nearly 10,000 homes in remote and disadvantaged corners of some 27 countries like India, Nepal, Sri Lanka, Bolivia, and the Philippines.

The technology, which is not yet widely known in India, faces some scepticism here. “LED systems are revolutionising rural lighting, but this isn''t a magic solution to the world''s energy problems,” says Ashok Jhunjhunwala, head of the electrical engineering department at the Indian Institute of Technology, Madras. In a scenario in which nearly 60 per cent of India''s rural population uses 180 million tons of biomass per year for cooking via primitive wood stoves - which are smoky and provide only 10-15 per cent efficiency in cooking -Jhunjhunwala emphasises the need for a clean energy source, not just for lighting but for other domestic purposes as well. The Indian government in April launched an ambitious project to bring electricity to 112,000 rural villages in the next decade. However, the remote locations of the village will make reaching this goal difficult. A. K. Lakhina, the chairman of India''s Rural Electrification Corporation, says the Indian government recognises the potential of LED lighting powered by solar technology, but expressed reservations about its high costs. "If only LEDs weren''t imported but manufactured locally," he says, "and in bulk."

The lamps installed in nearly 300 homes by GSBF cost nearly half the price of other solar lighting systems. Jasjeet Singh Chaddha, the founder of the NGO, currently imports his LEDs from China. He wants to set up an LED manufacturing unit and a solar panel manufacturing unit in India. If manufactured locally, the cost of his LED lamp could plummet to $25. But because the Indian government charges a 32 per cent import duty on LED systems, the price remains high. "We just need $5 million for this," he says. Mr. Chaddha says he has also asked the government to exempt the lamps from such duties, but to no avail. An entrepreneur who made his money in plastics, Chaddha, has poured his own money into the project, providing the initial installations free of charge. As he looks to make the project self-sustainable, he recognises that it is only urban markets -which have also shown an avid interest in LED lighting - that can pay. The rural markets in India cannot afford it, he says, until the prices are brought down. The rural markets would be able to afford it, says Mr. Irvine-Halliday, if they had access to microcredit. He says that in Tembisa, a shanty town in Johannesburg, he found that almost 10,000 homes spent more than $60 each on candles and paraffin every year. As calculations revealed, these families can afford to purchase a solid state lighting system in just over a year of paying per week what they would normally spend on candles and paraffin - if they have access to microcredit. LUTW is in the process of creating such a microcredit facility for South Africa.

In villages near Khadakwadi, the newly installed LED lamps are a subject of envy, even for those connected to the grid. Those connected to the grid have to face power cuts up to 6 or 7 hours a day. Constant energy shortages and blackouts are a common problem due to a lack of power plants, transmission, and distribution losses caused by old technology and illegal stealing of electricity from the grid. LED systems require far less maintenance, a longer life, and as villagers jokingly say, "no electricity bills". The lamps provided by GSBF have enough power to provide just four hours of light a day. However, that is enough for people to get their work done in the early hours of the night, and is more reliable than light generated off India''s electrical grid. Villagers are educated by GSBF officials to make the most of the new lamps. An official from GSBF instructs Jadhav and his family to clean the lamp regularly. "Its luminosity and life will diminish if you let the dust settle on it," he warns them.', 'Passage');
DECLARE @Res3 INT = SCOPE_IDENTITY();

INSERT INTO ExamSections (ExamID, SectionName, ResourceID, OrderIndex) VALUES (@MockExamID, 'Reading Passage 3: Low-Cost Lamps Light Rural India', @Res3, 3);
DECLARE @MockSec3 INT = SCOPE_IDENTITY();
INSERT INTO ExamSections (ExamID, SectionName, ResourceID, OrderIndex) VALUES (@PlacementExamID, 'Reading Passage 3: Low-Cost Lamps Light Rural India', @Res3, 3);
DECLARE @PlaceSec3 INT = SCOPE_IDENTITY();

-- Câu 27-30: Multiple Choice
INSERT INTO Questions (Content, QuestionType, Skill, Difficulty, contentJSON, ResourceID) VALUES ('The GSBF lamps', 'Multiple_Choice', 'Reading', 'Medium', '{}', @Res3);
SET @QID = SCOPE_IDENTITY();
INSERT INTO Answers (QuestionID, Content, IsCorrect, ContentJson) VALUES 
    (@QID, 'A. provide light for 100,000 Indian villages.', 0, '{}'),
    (@QID, 'B. are very expensive to install.', 0, '{}'),
    (@QID, 'C. are powered by the sun.', 1, '{}');
INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex) VALUES (@MockSec3, @QID, 27), (@PlaceSec3, @QID, 27);

INSERT INTO Questions (Content, QuestionType, Skill, Difficulty, contentJSON, ResourceID) VALUES ('More than half of India''s population uses', 'Multiple_Choice', 'Reading', 'Medium', '{}', @Res3);
SET @QID = SCOPE_IDENTITY();
INSERT INTO Answers (QuestionID, Content, IsCorrect, ContentJson) VALUES 
    (@QID, 'A. kerosene as a cooking fuel.', 0, '{}'),
    (@QID, 'B. biomass as a cooking fuel.', 1, '{}'),
    (@QID, 'C. solar power as a cooking fuel.', 0, '{}');
INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex) VALUES (@MockSec3, @QID, 28), (@PlaceSec3, @QID, 28);

INSERT INTO Questions (Content, QuestionType, Skill, Difficulty, contentJSON, ResourceID) VALUES ('In India, the GSBF lamps are too expensive for most people', 'Multiple_Choice', 'Reading', 'Medium', '{}', @Res3);
SET @QID = SCOPE_IDENTITY();
INSERT INTO Answers (QuestionID, Content, IsCorrect, ContentJson) VALUES 
    (@QID, 'A. in rural areas.', 1, '{}'),
    (@QID, 'B. in urban areas.', 0, '{}'),
    (@QID, 'C. in all areas.', 0, '{}');
INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex) VALUES (@MockSec3, @QID, 29), (@PlaceSec3, @QID, 29);

INSERT INTO Questions (Content, QuestionType, Skill, Difficulty, contentJSON, ResourceID) VALUES ('The GSBF lamps', 'Multiple_Choice', 'Reading', 'Medium', '{}', @Res3);
SET @QID = SCOPE_IDENTITY();
INSERT INTO Answers (QuestionID, Content, IsCorrect, ContentJson) VALUES 
    (@QID, 'A. are not as reliable as electricity from the national power grid.', 0, '{}'),
    (@QID, 'B. require skill to use.', 0, '{}'),
    (@QID, 'C. only provide four hours of light a day.', 1, '{}');
INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex) VALUES (@MockSec3, @QID, 30), (@PlaceSec3, @QID, 30);

-- Câu 31-35: Fill In Blanks
INSERT INTO Questions (Content, QuestionType, Skill, Difficulty, contentJSON, ResourceID) VALUES ('Complete the sentence (NO MORE THAN THREE WORDS): Another example of cheap technology helping poor people in the countryside is _____.', 'FillInBlanks', 'Reading', 'Easy', '{}', @Res3);
SET @QID = SCOPE_IDENTITY();
INSERT INTO Answers (QuestionID, Content, IsCorrect, ContentJson) VALUES (@QID, 'cell phones', 1, '{}');
INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex) VALUES (@MockSec3, @QID, 31), (@PlaceSec3, @QID, 31);

INSERT INTO Questions (Content, QuestionType, Skill, Difficulty, contentJSON, ResourceID) VALUES ('Complete the sentence (NO MORE THAN THREE WORDS): Kerosene lamps and conventional bulbs give off less _____ than GSBF lamps.', 'FillInBlanks', 'Reading', 'Medium', '{}', @Res3);
SET @QID = SCOPE_IDENTITY();
INSERT INTO Answers (QuestionID, Content, IsCorrect, ContentJson) VALUES (@QID, 'useful light', 1, '{}');
INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex) VALUES (@MockSec3, @QID, 32), (@PlaceSec3, @QID, 32);

INSERT INTO Questions (Content, QuestionType, Skill, Difficulty, contentJSON, ResourceID) VALUES ('Complete the sentence (NO MORE THAN THREE WORDS): It is unlikely that the Indian government will achieve its aim of connecting 112,000 villages to electricity because many villages are _____.', 'FillInBlanks', 'Reading', 'Medium', '{}', @Res3);
SET @QID = SCOPE_IDENTITY();
INSERT INTO Answers (QuestionID, Content, IsCorrect, ContentJson) VALUES (@QID, 'remote', 1, '{}');
INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex) VALUES (@MockSec3, @QID, 33), (@PlaceSec3, @QID, 33);

INSERT INTO Questions (Content, QuestionType, Skill, Difficulty, contentJSON, ResourceID) VALUES ('Complete the sentence (NO MORE THAN THREE WORDS): GSBF lamps would be cheaper if it weren''t for _____.', 'FillInBlanks', 'Reading', 'Medium', '{}', @Res3);
SET @QID = SCOPE_IDENTITY();
INSERT INTO Answers (QuestionID, Content, IsCorrect, ContentJson) VALUES (@QID, 'import duty', 1, '{}');
INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex) VALUES (@MockSec3, @QID, 34), (@PlaceSec3, @QID, 34);

INSERT INTO Questions (Content, QuestionType, Skill, Difficulty, contentJSON, ResourceID) VALUES ('Complete the sentence (NO MORE THAN THREE WORDS): Users need to wipe _____ from the LED in order to keep it working well.', 'FillInBlanks', 'Reading', 'Easy', '{}', @Res3);
SET @QID = SCOPE_IDENTITY();
INSERT INTO Answers (QuestionID, Content, IsCorrect, ContentJson) VALUES (@QID, 'dust', 1, '{}');
INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex) VALUES (@MockSec3, @QID, 35), (@PlaceSec3, @QID, 35);

-- Câu 36-40: TRUE/FALSE/NOT GIVEN
INSERT INTO Questions (Content, QuestionType, Skill, Difficulty, contentJSON, ResourceID) VALUES ('TRUE/FALSE/NOT GIVEN: Ganpat Jadhav''s monthly ration of kerosene was insufficient.', 'Multiple_Choice', 'Reading', 'Easy', '{}', @Res3);
SET @QID = SCOPE_IDENTITY();
INSERT INTO Answers (QuestionID, Content, IsCorrect, ContentJson) VALUES (@QID, 'TRUE', 1, '{}'), (@QID, 'FALSE', 0, '{}'), (@QID, 'NOT GIVEN', 0, '{}');
INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex) VALUES (@MockSec3, @QID, 36), (@PlaceSec3, @QID, 36);

INSERT INTO Questions (Content, QuestionType, Skill, Difficulty, contentJSON, ResourceID) VALUES ('TRUE/FALSE/NOT GIVEN: Kerosene causes many fires in homes in developing countries.', 'Multiple_Choice', 'Reading', 'Medium', '{}', @Res3);
SET @QID = SCOPE_IDENTITY();
INSERT INTO Answers (QuestionID, Content, IsCorrect, ContentJson) VALUES (@QID, 'TRUE', 0, '{}'), (@QID, 'FALSE', 0, '{}'), (@QID, 'NOT GIVEN', 1, '{}');
INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex) VALUES (@MockSec3, @QID, 37), (@PlaceSec3, @QID, 37);

INSERT INTO Questions (Content, QuestionType, Skill, Difficulty, contentJSON, ResourceID) VALUES ('TRUE/FALSE/NOT GIVEN: LED systems could solve the world''s energy problems.', 'Multiple_Choice', 'Reading', 'Easy', '{}', @Res3);
SET @QID = SCOPE_IDENTITY();
INSERT INTO Answers (QuestionID, Content, IsCorrect, ContentJson) VALUES (@QID, 'TRUE', 0, '{}'), (@QID, 'FALSE', 1, '{}'), (@QID, 'NOT GIVEN', 0, '{}');
INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex) VALUES (@MockSec3, @QID, 38), (@PlaceSec3, @QID, 38);

INSERT INTO Questions (Content, QuestionType, Skill, Difficulty, contentJSON, ResourceID) VALUES ('TRUE/FALSE/NOT GIVEN: Chaddha has so far funded the GSBF lamp project himself.', 'Multiple_Choice', 'Reading', 'Medium', '{}', @Res3);
SET @QID = SCOPE_IDENTITY();
INSERT INTO Answers (QuestionID, Content, IsCorrect, ContentJson) VALUES (@QID, 'TRUE', 1, '{}'), (@QID, 'FALSE', 0, '{}'), (@QID, 'NOT GIVEN', 0, '{}');
INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex) VALUES (@MockSec3, @QID, 39), (@PlaceSec3, @QID, 39);

INSERT INTO Questions (Content, QuestionType, Skill, Difficulty, contentJSON, ResourceID) VALUES ('TRUE/FALSE/NOT GIVEN: Microcredit would help to get more people to use LED lamps.', 'Multiple_Choice', 'Reading', 'Medium', '{}', @Res3);
SET @QID = SCOPE_IDENTITY();
INSERT INTO Answers (QuestionID, Content, IsCorrect, ContentJson) VALUES (@QID, 'TRUE', 1, '{}'), (@QID, 'FALSE', 0, '{}'), (@QID, 'NOT GIVEN', 0, '{}');
INSERT INTO ExamQuestions (SectionID, QuestionID, OrderIndex) VALUES (@MockSec3, @QID, 40), (@PlaceSec3, @QID, 40);

GO
