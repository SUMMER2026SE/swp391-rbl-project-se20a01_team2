CREATE TABLE upload_sessions (
    upload_id VARCHAR(255) PRIMARY KEY,
    file_name VARCHAR(255) NOT NULL,
    total_chunks INT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
