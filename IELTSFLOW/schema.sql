-- Tạo cơ sở dữ liệu
CREATE DATABASE IELTSFlow;
GO

USE IELTSFlow;
GO

-- ==========================================
-- NHÓM QUẢN TRỊ NGƯỜI DÙNG & HỒ SƠ
-- ==========================================

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
    Deleted BIT DEFAULT 0
);

CREATE TABLE CandidateTargets (
    TargetID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL,
    TargetBand DECIMAL(3,1) NOT NULL, -- Ví dụ: 6.5, 7.0
    CurrentBand DECIMAL(3,1),
    ExamDate DATE,
    IsActive BIT DEFAULT 1, -- [CẬP NHẬT] Đánh dấu mục tiêu hiện tại đang active để AI lên lộ trình
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

-- ==========================================
-- NHÓM GÓI CƯỚC & THANH TOÁN
-- ==========================================

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
    PaymentMethod NVARCHAR(50), -- VNPay, MoMo, Stripe
    GatewayTransactionID NVARCHAR(100) NULL, -- Mã đối soát từ Cổng thanh toán (TxnRef)
    GatewayPayload NVARCHAR(MAX) NULL, -- [CẬP NHẬT] Lưu trữ JSON payload gốc từ webhook để đối soát khi có lỗi
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

-- ==========================================
-- NHÓM NGÂN HÀNG ĐỀ THI & HỌC LIỆU
-- ==========================================

CREATE TABLE QuestionResource (
    ResourceID INT IDENTITY(1,1) PRIMARY KEY,
    ResourceText NVARCHAR(MAX),
    ResourceAudioURL NVARCHAR(500),
    ResourceImageURL NVARCHAR(500),
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
    OrderInResource INT NULL, -- [CẬP NHẬT] Thứ tự câu hỏi đi theo 1 bài đọc (Passage) hoặc audio
    MetadataJSON NVARCHAR(MAX) NULL, -- [CẬP NHẬT] Lưu meta data cấu trúc UI hoặc rule chấm thi cho các câu dị (matching, kéo thả)
    CreatedBy INT NULL, -- Theo dõi Mentor nào tạo
    FOREIGN KEY (ResourceID) REFERENCES QuestionResource(ResourceID),
    FOREIGN KEY (CreatedBy) REFERENCES Users(UserID),
    Deleted BIT DEFAULT 0
);

CREATE TABLE Answers (
    AnswerID INT IDENTITY(1,1) PRIMARY KEY,
    QuestionID INT NOT NULL,
    Content NVARCHAR(MAX) NOT NULL,
    IsCorrect BIT NOT NULL DEFAULT 0,
    FOREIGN KEY (QuestionID) REFERENCES Questions(QuestionID) ON DELETE CASCADE
);

CREATE TABLE Tags (
    TagID INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    Type NVARCHAR(50) -- Topic, Grammar, Vocabulary...
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
    DocumentURL NVARCHAR(500) NULL, -- Lưu trữ PDF/Tài liệu
    CreatedBy INT NULL, -- Theo dõi Mentor đăng bài
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (CreatedBy) REFERENCES Users(UserID),
    Deleted BIT DEFAULT 0,
    Skill NVARCHAR(20)
);

-- Bảng quản lý Tiến độ & Đánh dấu bài học
CREATE TABLE UserLessonProgress (
    ProgressID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL,
    LessonID INT NOT NULL,
    IsCompleted BIT DEFAULT 0, -- Đã học xong chưa
    IsBookmarked BIT DEFAULT 0, -- Đánh dấu bài học
    LastAccessed DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE,
    FOREIGN KEY (LessonID) REFERENCES Lessons(LessonID) ON DELETE CASCADE
);

-- [CẬP NHẬT BẢNG MỚI] Bảng lưu lại các câu hỏi/bài tập học viên muốn đánh dấu học lại
CREATE TABLE UserQuestionBookmarks (
    BookmarkID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL,
    QuestionID INT NOT NULL,
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE,
    FOREIGN KEY (QuestionID) REFERENCES Questions(QuestionID) ON DELETE CASCADE,
    CONSTRAINT UQ_User_Question UNIQUE (UserID, QuestionID)
);

-- ==========================================
-- NHÓM BÀI THI & CHẤM ĐIỂM
-- ==========================================

CREATE TABLE Exams (
    ExamID INT IDENTITY(1,1) PRIMARY KEY,
    Title NVARCHAR(200) NOT NULL,
    Type NVARCHAR(50) NOT NULL, -- Mock Test, Placement Test, Practice
    SkillFocus NVARCHAR(20) DEFAULT 'All', -- [CẬP NHẬT] Đánh dấu đề là Reading, Listening, Writing, Speaking hay Full Test (All)
    Duration INT NOT NULL, 
    MentorID INT,
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (MentorID) REFERENCES Users(UserID),
    Deleted BIT DEFAULT 0
);

CREATE TABLE ExamQuestions (
    ExamID INT NOT NULL,
    QuestionID INT NOT NULL,
    OrderIndex INT NOT NULL, 
    PRIMARY KEY (ExamID, QuestionID),
    FOREIGN KEY (ExamID) REFERENCES Exams(ExamID) ON DELETE CASCADE,
    FOREIGN KEY (QuestionID) REFERENCES Questions(QuestionID) ON DELETE CASCADE
);

CREATE TABLE TestSubmissions (
    SubmissionID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL,
    ExamID INT NOT NULL,
    StartTime DATETIME NOT NULL,
    EndTime DATETIME,
    
    -- Điểm thành phần để vẽ biểu đồ
    ListeningBand DECIMAL(3,1) NULL,
    ReadingBand DECIMAL(3,1) NULL,
    WritingBand DECIMAL(3,1) NULL,
    SpeakingBand DECIMAL(3,1) NULL,
    OverallBand DECIMAL(3,1) NULL,
    TotalScore DECIMAL(5,2) NULL,
    
    -- Chống gian lận & Trạng thái làm bài
    ViolationCount INT DEFAULT 0, 
    IsCheated BIT DEFAULT 0, 
    Status NVARCHAR(20) DEFAULT 'InProgress', -- InProgress, Completed, Abandoned
    -- AI feedback
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
    CandidateTranscript NVARCHAR(MAX) NULL, -- [CẬP NHẬT] Lưu text sau khi Speech-to-text dịch ra để user xem lại và AI đọc
    IsCorrect BIT,
    Score DECIMAL(5,2),
    GradingStatus NVARCHAR(50) DEFAULT 'Graded', -- 'Pending_AI', 'Processing', 'Graded', 'Failed'
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

-- ==========================================
-- NHÓM LỘ TRÌNH HỌC TẬP (AI SINH RA)
-- ==========================================

CREATE TABLE Pathways (
    PathwayID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL,
    PlacementTestID INT NULL, -- Link với bài test đầu vào để biết điểm yếu
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
    FOREIGN KEY (PathwayID) REFERENCES Pathways(PathwayID) ON DELETE CASCADE,
    CONSTRAINT CHK_PlanContent CHECK (ISJSON(PlanContent) = 1) 
);

-- ==========================================
-- NHÓM HỖ TRỢ, THÔNG BÁO & LOG HỆ THỐNG
-- ==========================================

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

-- Bảng quản lý Thông báo
CREATE TABLE Notifications (
    NotificationID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL,
    Title NVARCHAR(200) NOT NULL,
    Content NVARCHAR(MAX) NOT NULL,
    Type NVARCHAR(50) DEFAULT 'System', -- System, Reminder, Payment, Exam
    IsRead BIT DEFAULT 0,
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE
);

-- Bảng lưu Log hệ thống cho Admin
CREATE TABLE SystemLogs (
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NULL, -- ID người thực hiện (NULL nếu là auto system event)
    Action NVARCHAR(100) NOT NULL, -- Ví dụ: 'DELETE_USER', 'API_ERROR'
    Entity NVARCHAR(50), -- Bảng hoặc Module bị tác động
    Details NVARCHAR(MAX), -- Lưu raw error message hoặc JSON thao tác
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);
GO
