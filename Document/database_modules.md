# Database IELTSFlow - Phân chia theo Module

Dựa vào tài liệu `swp_motabandau.md`, database của hệ thống IELTSFlow được chia thành 7 module riêng biệt như sau:

## 1. Module Quản trị người dùng & Hồ sơ (User & Profile Management)
Module này quản lý thông tin người dùng, phân quyền và mục tiêu điểm IELTS của học viên.

```sql
CREATE TABLE Roles (
    RoleID INT IDENTITY(1,1) PRIMARY KEY,
    RoleName NVARCHAR(50) NOT NULL UNIQUE, -- Admin, Mentor, Candidate
    Description NVARCHAR(255)
);

CREATE TABLE Users (
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    RoleID INT NOT NULL,
    Email NVARCHAR(255) NOT NULL UNIQUE,
    PasswordHash NVARCHAR(255) NULL, -- Cho phép NULL để hỗ trợ Social Login
    AuthProvider NVARCHAR(50) DEFAULT 'Local', -- Local, Google, Facebook
    ProviderID NVARCHAR(100) NULL, -- ID trả về từ Google/Facebook
    FullName NVARCHAR(100) NOT NULL,
    Status NVARCHAR(20) DEFAULT 'Active', -- Active, Inactive, Banned
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (RoleID) REFERENCES Roles(RoleID),
    Deleted BIT DEFAULT 0,
    ProfilePic NVARCHAR(500) NULL
);

CREATE TABLE CandidateTargets (
    TargetID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL,
    TargetBand DECIMAL(3,1) NOT NULL, -- Ví dụ: 6.5, 7.0
    CurrentBand DECIMAL(3,1),
    IsActive BIT DEFAULT 1, -- Đánh dấu mục tiêu hiện tại đang active để AI lên lộ trình
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);
```

## 2. Module Gói cước & Thanh toán (Subscription & Payment)
Module quản lý các gói Pro, giao dịch thanh toán và thời hạn gói cước của người dùng.

```sql
CREATE TABLE SubscriptionPackages (
    PackageID INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    DurationMonths INT NOT NULL,
    Price DECIMAL(18,2) NOT NULL,
    Description NVARCHAR(500),
    Deleted BIT DEFAULT 0
);

CREATE TABLE Transactions (
    TransactionID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL,
    PackageID INT NOT NULL,
    Amount DECIMAL(18,2) NOT NULL,
    PaymentMethod NVARCHAR(50), -- SePay
    GatewayTransactionID NVARCHAR(100) NULL, -- Mã đối soát từ Cổng thanh toán (TxnRef)
    GatewayPayload NVARCHAR(MAX) NULL, -- Lưu trữ JSON payload gốc từ webhook để đối soát khi có lỗi
    Status NVARCHAR(50) DEFAULT 'Pending', -- Pending, Success, Failed
    PaymentDate DATETIME NULL, -- Thời gian thanh toán thực tế ghi nhận từ Webhook
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (PackageID) REFERENCES SubscriptionPackages(PackageID)
);

CREATE TABLE UserSubscriptions (
    UserSubID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL,
    PackageID INT NOT NULL,
    StartDate DATETIME NOT NULL,
    EndDate DATETIME NOT NULL,
    Status NVARCHAR(50) DEFAULT 'Active', -- Active, Expired, Cancelled
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (PackageID) REFERENCES SubscriptionPackages(PackageID)
);
```

## 3. Module Ngân hàng đề thi & Học liệu (Question Bank & Learning Resources)
Chứa dữ liệu về bài giảng, tài liệu, câu hỏi thi, đáp án và thẻ phân loại (tags).

```sql
CREATE TABLE QuestionResource (
    ResourceID INT IDENTITY(1,1) PRIMARY KEY,
    ResourceName NVARCHAR(255),
    ResourceText NVARCHAR(MAX),
    ResourceAudioURL NVARCHAR(500),
    ResourceImageURL NVARCHAR(MAX),
    Type NVARCHAR(50) NOT NULL, -- Passage, Audio
    CreatedBy INT NULL, -- Theo dõi Mentor nào tạo
    FOREIGN KEY (CreatedBy) REFERENCES Users(UserID),
    Deleted BIT DEFAULT 0
);

CREATE TABLE Questions (
    QuestionID INT IDENTITY(1,1) PRIMARY KEY,
    ResourceID INT NULL, 
    Content NVARCHAR(MAX) NOT NULL,
    QuestionType NVARCHAR(50) NOT NULL, 
    Skill NVARCHAR(20) NOT NULL, -- Listening, Reading, Writing, Speaking
    Difficulty NVARCHAR(20), -- Easy, Medium, Hard
    Explanation NVARCHAR(MAX),
    OrderInResource INT NULL, 
    contentJSON NVARCHAR(MAX) NOT NULL, 
    QuestionCount INT DEFAULT 1,
    CreatedBy INT NULL, 
    FOREIGN KEY (ResourceID) REFERENCES QuestionResource(ResourceID),
    FOREIGN KEY (CreatedBy) REFERENCES Users(UserID),
    Deleted BIT DEFAULT 0
);

CREATE TABLE Answers (
    AnswerID INT IDENTITY(1,1) PRIMARY KEY,
    QuestionID INT NOT NULL,
    Content NVARCHAR(MAX) NOT NULL, 
    ContentJson NVARCHAR(MAX) NOT NULL, 
    IsCorrect BIT NOT NULL DEFAULT 0,
    FOREIGN KEY (QuestionID) REFERENCES Questions(QuestionID) ON DELETE CASCADE
);

CREATE TABLE Tags (
    TagID INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    Type NVARCHAR(50), -- Topic, Grammar, Vocabulary...
    Deleted BIT DEFAULT 0
);

CREATE TABLE QuestionTags (
    QuestionID INT NOT NULL,
    TagID INT NOT NULL,
    PRIMARY KEY (QuestionID, TagID),
    FOREIGN KEY (QuestionID) REFERENCES Questions(QuestionID) ON DELETE CASCADE,
    FOREIGN KEY (TagID) REFERENCES Tags(TagID) ON DELETE CASCADE
);

CREATE TABLE Lessons (
    LessonID INT IDENTITY(1,1) PRIMARY KEY,
    Title NVARCHAR(200) NOT NULL,
    Content NVARCHAR(MAX),
    VideoURL NVARCHAR(500),
    DocumentURL NVARCHAR(500) NULL,
    CreatedBy INT NULL, 
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (CreatedBy) REFERENCES Users(UserID),
    Deleted BIT DEFAULT 0,
    Skill NVARCHAR(20)
);

CREATE TABLE UserLessonProgress (
    ProgressID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL,
    LessonID INT NOT NULL,
    IsCompleted BIT DEFAULT 0, 
    IsBookmarked BIT DEFAULT 0, 
    LastAccessed DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE,
    FOREIGN KEY (LessonID) REFERENCES Lessons(LessonID) ON DELETE CASCADE
);

CREATE TABLE UserQuestionBookmarks (
    BookmarkID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL,
    QuestionID INT NOT NULL,
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE,
    FOREIGN KEY (QuestionID) REFERENCES Questions(QuestionID) ON DELETE CASCADE,
    CONSTRAINT UQ_User_Question UNIQUE (UserID, QuestionID)
);
```

## 4. Module Bài thi & Chấm điểm (Exams & Evaluation)
Cấu trúc đề thi, phần thi, lịch sử nộp bài, kết quả chi tiết và phản hồi từ AI.

```sql
CREATE TABLE Exams (
    ExamID INT IDENTITY(1,1) PRIMARY KEY,
    Title NVARCHAR(200) NOT NULL,
    Type NVARCHAR(50) NOT NULL, -- Mock Test, Placement Test, Practice
    SkillFocus NVARCHAR(20) DEFAULT 'All',
    Duration INT NOT NULL, 
    MentorID INT,
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (MentorID) REFERENCES Users(UserID),
    Deleted BIT DEFAULT 0
);

CREATE TABLE ExamSections (
    SectionID INT IDENTITY(1,1) PRIMARY KEY,
    ExamID INT NOT NULL,
    SectionName NVARCHAR(100) NOT NULL, 
    ResourceID INT NULL, 
    OrderIndex INT NOT NULL, 
    Skill NVARCHAR(20) NOT NULL DEFAULT 'Listening',
    FOREIGN KEY (ExamID) REFERENCES Exams(ExamID) ON DELETE CASCADE,
    FOREIGN KEY (ResourceID) REFERENCES QuestionResource(ResourceID)
);

CREATE TABLE ExamQuestions (
    SectionID INT NOT NULL,
    QuestionID INT NOT NULL,
    OrderIndex INT NOT NULL, 
    PRIMARY KEY (SectionID, QuestionID),
    FOREIGN KEY (SectionID) REFERENCES ExamSections(SectionID) ON DELETE CASCADE,
    FOREIGN KEY (QuestionID) REFERENCES Questions(QuestionID) ON DELETE CASCADE
);

CREATE TABLE TestSubmissions (
    SubmissionID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL,
    ExamID INT NOT NULL,
    StartTime DATETIME NOT NULL,
    EndTime DATETIME,
    ListeningBand DECIMAL(3,1) NULL,
    ReadingBand DECIMAL(3,1) NULL,
    WritingBand DECIMAL(3,1) NULL,
    SpeakingBand DECIMAL(3,1) NULL,
    OverallBand DECIMAL(3,1) NULL,
    TotalScore DECIMAL(5,2) NULL,
    ViolationCount INT DEFAULT 0, 
    IsCheated BIT DEFAULT 0, 
    Status NVARCHAR(20) DEFAULT 'InProgress', 
    OverallAIFeedback NVARCHAR(MAX),
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (ExamID) REFERENCES Exams(ExamID)
);

CREATE TABLE SubmissionDetails (
    DetailID INT IDENTITY(1,1) PRIMARY KEY,
    SubmissionID INT NOT NULL,
    QuestionID INT NOT NULL,
    CandidateAnswer NVARCHAR(MAX),
    SpeakingUrl NVARCHAR(500), 
    CandidateTranscript NVARCHAR(MAX) NULL, 
    IsCorrect BIT,
    Score DECIMAL(5,2),
    GradingStatus NVARCHAR(50) DEFAULT 'Graded', 
    FOREIGN KEY (SubmissionID) REFERENCES TestSubmissions(SubmissionID) ON DELETE CASCADE,
    FOREIGN KEY (QuestionID) REFERENCES Questions(QuestionID)
);

CREATE TABLE AIEvaluations (
    EvaluationID INT IDENTITY(1,1) PRIMARY KEY,
    DetailID INT NOT NULL,
    FeedbackJSON NVARCHAR(MAX) NOT NULL,
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (DetailID) REFERENCES SubmissionDetails(DetailID) ON DELETE CASCADE,
    CONSTRAINT CHK_FeedbackJSON CHECK (ISJSON(FeedbackJSON) = 1) 
);
```

## 5. Module Lộ trình học tập - AI Sinh ra (Study Pathway)
Module theo dõi lộ trình cá nhân hóa được AI tự động sinh ra dựa trên bài thi đầu vào.

```sql
CREATE TABLE Pathways (
    PathwayID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL,
    PlacementTestID INT NULL,
    TargetBand DECIMAL(3,1) NOT NULL,
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (PlacementTestID) REFERENCES TestSubmissions(SubmissionID)
);

CREATE TABLE WeeklyPlans (
    PlanID INT IDENTITY(1,1) PRIMARY KEY,
    PathwayID INT NOT NULL,
    WeekNumber INT NOT NULL,
    PlanContent NVARCHAR(MAX) NOT NULL, 
    IsCompleted BIT DEFAULT 0,
    IsCurrentWeek BIT DEFAULT 0, 
    FOREIGN KEY (PathwayID) REFERENCES Pathways(PathwayID) ON DELETE CASCADE,
    CONSTRAINT CHK_PlanContent CHECK (ISJSON(PlanContent) = 1) 
);
```

## 6. Module Hỗ trợ, Thông báo & Log hệ thống (Support, Notifications & Logs)
Quản lý các yêu cầu hỗ trợ (ticket), gửi thông báo cho user và ghi nhận lại nhật ký của hệ thống (system logs).

```sql
CREATE TABLE Tickets (
    TicketID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL,
    Subject NVARCHAR(255) NOT NULL,
    Status NVARCHAR(50) DEFAULT 'Open', 
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

CREATE TABLE TicketReplies (
    ReplyID INT IDENTITY(1,1) PRIMARY KEY,
    TicketID INT NOT NULL,
    SenderID INT NOT NULL, 
    Message NVARCHAR(MAX) NOT NULL,
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (TicketID) REFERENCES Tickets(TicketID) ON DELETE CASCADE,
    FOREIGN KEY (SenderID) REFERENCES Users(UserID)
);

CREATE TABLE Notifications (
    NotificationID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL,
    Title NVARCHAR(200) NOT NULL,
    Content NVARCHAR(MAX) NOT NULL,
    Type NVARCHAR(50) DEFAULT 'System', 
    IsRead BIT DEFAULT 0,
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE
);

CREATE TABLE SystemLogs (
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NULL, 
    Action NVARCHAR(100) NOT NULL, 
    Entity NVARCHAR(50), 
    Details NVARCHAR(MAX), 
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);
```

## 7. Module Quản lý File Upload (File Management)
Lưu vết các file đã upload (hình ảnh, tài liệu) và theo dõi tiến trình upload chunked của tài liệu lớn.

```sql
CREATE TABLE UploadedFiles (
    FileID INT IDENTITY(1,1) PRIMARY KEY,
    OriginalName NVARCHAR(255) NOT NULL,
    SavedPath NVARCHAR(500) NOT NULL,
    FileType NVARCHAR(50) NOT NULL, 
    UploadedBy INT NOT NULL,
    UploadedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (UploadedBy) REFERENCES Users(UserID)
);

CREATE TABLE upload_sessions (
    upload_id VARCHAR(255) PRIMARY KEY,
    file_name VARCHAR(255) NOT NULL,
    total_chunks INT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
```
