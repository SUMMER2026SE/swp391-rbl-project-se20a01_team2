-- =============================================
-- IELTSFlow Database Schema
-- Run this on SQL Server Management Studio
-- =============================================

IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'IELTSFlow')
BEGIN
    CREATE DATABASE IELTSFlow;
END
GO

USE IELTSFlow;
GO

-- ==========================================
-- NHÓM QUẢN TRỊ NGƯỜI DÙNG & HỒ SƠ
-- ==========================================

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Roles' AND xtype='U')
CREATE TABLE Roles (
    RoleID INT IDENTITY(1,1) PRIMARY KEY,
    RoleName NVARCHAR(50) NOT NULL UNIQUE,
    Description NVARCHAR(255)
);
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Users' AND xtype='U')
CREATE TABLE Users (
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    RoleID INT NOT NULL,
    Email NVARCHAR(255) NOT NULL UNIQUE,
    PasswordHash NVARCHAR(255) NULL,
    AuthProvider NVARCHAR(50) DEFAULT 'Local',
    ProviderID NVARCHAR(100) NULL,
    FullName NVARCHAR(100) NOT NULL,
    Status NVARCHAR(20) DEFAULT 'Active',
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (RoleID) REFERENCES Roles(RoleID)
);
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='CandidateTargets' AND xtype='U')
CREATE TABLE CandidateTargets (
    TargetID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL,
    TargetBand DECIMAL(3,1) NOT NULL,
    CurrentBand DECIMAL(3,1),
    ExamDate DATE,
    IsActive BIT DEFAULT 1,
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);
GO

-- ==========================================
-- NHÓM GÓI CƯỚC & THANH TOÁN
-- ==========================================

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='SubscriptionPackages' AND xtype='U')
CREATE TABLE SubscriptionPackages (
    PackageID INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    DurationMonths INT NOT NULL,
    Price DECIMAL(18,2) NOT NULL,
    Description NVARCHAR(500)
);
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Transactions' AND xtype='U')
CREATE TABLE Transactions (
    TransactionID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL,
    PackageID INT NOT NULL,
    Amount DECIMAL(18,2) NOT NULL,
    PaymentMethod NVARCHAR(50),
    GatewayTransactionID NVARCHAR(100) NULL,
    GatewayPayload NVARCHAR(MAX) NULL,
    Status NVARCHAR(50) DEFAULT 'Pending',
    PaymentDate DATETIME NULL,
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (PackageID) REFERENCES SubscriptionPackages(PackageID)
);
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='UserSubscriptions' AND xtype='U')
CREATE TABLE UserSubscriptions (
    UserSubID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL,
    PackageID INT NOT NULL,
    StartDate DATETIME NOT NULL,
    EndDate DATETIME NOT NULL,
    Status NVARCHAR(50) DEFAULT 'Active',
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (PackageID) REFERENCES SubscriptionPackages(PackageID)
);
GO

-- ==========================================
-- NHÓM NGÂN HÀNG ĐỀ THI & HỌC LIỆU
-- ==========================================

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='QuestionResource' AND xtype='U')
CREATE TABLE QuestionResource (
    ResourceID INT IDENTITY(1,1) PRIMARY KEY,
    ResourceText NVARCHAR(MAX),
    ResourceAudioURL NVARCHAR(500),
    ResourceImageURL NVARCHAR(500),
    Type NVARCHAR(50) NOT NULL,
    CreatedBy INT NULL,
    FOREIGN KEY (CreatedBy) REFERENCES Users(UserID)
);
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Questions' AND xtype='U')
CREATE TABLE Questions (
    QuestionID INT IDENTITY(1,1) PRIMARY KEY,
    ResourceID INT NULL,
    Content NVARCHAR(MAX) NOT NULL,
    QuestionType NVARCHAR(50) NOT NULL,
    Skill NVARCHAR(20) NOT NULL,
    Difficulty NVARCHAR(20),
    Explanation NVARCHAR(MAX),
    OrderInResource INT NULL,
    MetadataJSON NVARCHAR(MAX) NULL,
    CreatedBy INT NULL,
    FOREIGN KEY (ResourceID) REFERENCES QuestionResource(ResourceID),
    FOREIGN KEY (CreatedBy) REFERENCES Users(UserID)
);
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Answers' AND xtype='U')
CREATE TABLE Answers (
    AnswerID INT IDENTITY(1,1) PRIMARY KEY,
    QuestionID INT NOT NULL,
    Content NVARCHAR(MAX) NOT NULL,
    IsCorrect BIT NOT NULL DEFAULT 0,
    FOREIGN KEY (QuestionID) REFERENCES Questions(QuestionID) ON DELETE CASCADE
);
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Tags' AND xtype='U')
CREATE TABLE Tags (
    TagID INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    Type NVARCHAR(50)
);
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='QuestionTags' AND xtype='U')
CREATE TABLE QuestionTags (
    QuestionID INT NOT NULL,
    TagID INT NOT NULL,
    PRIMARY KEY (QuestionID, TagID),
    FOREIGN KEY (QuestionID) REFERENCES Questions(QuestionID) ON DELETE CASCADE,
    FOREIGN KEY (TagID) REFERENCES Tags(TagID) ON DELETE CASCADE
);
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Lessons' AND xtype='U')
CREATE TABLE Lessons (
    LessonID INT IDENTITY(1,1) PRIMARY KEY,
    Title NVARCHAR(200) NOT NULL,
    Content NVARCHAR(MAX),
    VideoURL NVARCHAR(500),
    DocumentURL NVARCHAR(500) NULL,
    CreatedBy INT NULL,
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (CreatedBy) REFERENCES Users(UserID)
);
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='UserLessonProgress' AND xtype='U')
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
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='UserQuestionBookmarks' AND xtype='U')
CREATE TABLE UserQuestionBookmarks (
    BookmarkID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL,
    QuestionID INT NOT NULL,
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE,
    FOREIGN KEY (QuestionID) REFERENCES Questions(QuestionID) ON DELETE CASCADE,
    CONSTRAINT UQ_User_Question UNIQUE (UserID, QuestionID)
);
GO

-- ==========================================
-- NHÓM BÀI THI & CHẤM ĐIỂM
-- ==========================================

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Exams' AND xtype='U')
CREATE TABLE Exams (
    ExamID INT IDENTITY(1,1) PRIMARY KEY,
    Title NVARCHAR(200) NOT NULL,
    Type NVARCHAR(50) NOT NULL,
    SkillFocus NVARCHAR(20) DEFAULT 'All',
    Duration INT NOT NULL,
    MentorID INT,
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (MentorID) REFERENCES Users(UserID)
);
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='ExamQuestions' AND xtype='U')
CREATE TABLE ExamQuestions (
    ExamID INT NOT NULL,
    QuestionID INT NOT NULL,
    OrderIndex INT NOT NULL,
    PRIMARY KEY (ExamID, QuestionID),
    FOREIGN KEY (ExamID) REFERENCES Exams(ExamID) ON DELETE CASCADE,
    FOREIGN KEY (QuestionID) REFERENCES Questions(QuestionID) ON DELETE CASCADE
);
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='TestSubmissions' AND xtype='U')
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
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (ExamID) REFERENCES Exams(ExamID)
);
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='SubmissionDetails' AND xtype='U')
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
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='AIEvaluations' AND xtype='U')
CREATE TABLE AIEvaluations (
    EvaluationID INT IDENTITY(1,1) PRIMARY KEY,
    DetailID INT NOT NULL,
    FeedbackJSON NVARCHAR(MAX) NOT NULL,
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (DetailID) REFERENCES SubmissionDetails(DetailID) ON DELETE CASCADE,
    CONSTRAINT CHK_FeedbackJSON CHECK (ISJSON(FeedbackJSON) = 1)
);
GO

-- ==========================================
-- NHÓM LỘ TRÌNH HỌC TẬP
-- ==========================================

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Pathways' AND xtype='U')
CREATE TABLE Pathways (
    PathwayID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL,
    PlacementTestID INT NULL,
    TargetBand DECIMAL(3,1) NOT NULL,
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (PlacementTestID) REFERENCES TestSubmissions(SubmissionID)
);
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='WeeklyPlans' AND xtype='U')
CREATE TABLE WeeklyPlans (
    PlanID INT IDENTITY(1,1) PRIMARY KEY,
    PathwayID INT NOT NULL,
    WeekNumber INT NOT NULL,
    PlanContent NVARCHAR(MAX) NOT NULL,
    IsCompleted BIT DEFAULT 0,
    FOREIGN KEY (PathwayID) REFERENCES Pathways(PathwayID) ON DELETE CASCADE,
    CONSTRAINT CHK_PlanContent CHECK (ISJSON(PlanContent) = 1)
);
GO

-- ==========================================
-- NHÓM HỖ TRỢ & THÔNG BÁO
-- ==========================================

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Tickets' AND xtype='U')
CREATE TABLE Tickets (
    TicketID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL,
    Subject NVARCHAR(255) NOT NULL,
    Status NVARCHAR(50) DEFAULT 'Open',
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='TicketReplies' AND xtype='U')
CREATE TABLE TicketReplies (
    ReplyID INT IDENTITY(1,1) PRIMARY KEY,
    TicketID INT NOT NULL,
    SenderID INT NOT NULL,
    Message NVARCHAR(MAX) NOT NULL,
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (TicketID) REFERENCES Tickets(TicketID) ON DELETE CASCADE,
    FOREIGN KEY (SenderID) REFERENCES Users(UserID)
);
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Notifications' AND xtype='U')
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
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='SystemLogs' AND xtype='U')
CREATE TABLE SystemLogs (
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NULL,
    Action NVARCHAR(100) NOT NULL,
    Entity NVARCHAR(50),
    Details NVARCHAR(MAX),
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);
GO

-- ==========================================
-- DỮ LIỆU MẶC ĐỊNH
-- ==========================================

IF NOT EXISTS (SELECT * FROM Roles WHERE RoleName = 'Admin')
INSERT INTO Roles (RoleName, Description) VALUES
    ('Admin', N'Quản trị viên hệ thống'),
    ('Mentor', N'Giảng viên / Mentor IELTS'),
    ('Candidate', N'Học viên luyện thi IELTS');
GO

PRINT N'IELTSFlow schema created successfully!';
GO
