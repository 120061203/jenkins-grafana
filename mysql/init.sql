-- MySQL 初始化腳本
-- 建立 xsong.us 網站監控測試資料庫

-- 建立測試資料表
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS page_views (
    id INT AUTO_INCREMENT PRIMARY KEY,
    page_url VARCHAR(255) NOT NULL,
    user_agent TEXT,
    ip_address VARCHAR(45),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS api_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    endpoint VARCHAR(255) NOT NULL,
    method VARCHAR(10) NOT NULL,
    status_code INT NOT NULL,
    response_time DECIMAL(10,3),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 插入測試資料
INSERT INTO users (username, email) VALUES 
('testuser1', 'test1@xsong.us'),
('testuser2', 'test2@xsong.us'),
('testuser3', 'test3@xsong.us');

INSERT INTO page_views (page_url, user_agent, ip_address) VALUES 
('/', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36', '192.168.1.100'),
('/about', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36', '192.168.1.101'),
('/contact', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36', '192.168.1.102');

INSERT INTO api_logs (endpoint, method, status_code, response_time) VALUES 
('/api/users', 'GET', 200, 0.150),
('/api/posts', 'GET', 200, 0.200),
('/api/auth', 'POST', 401, 0.050);

-- 建立索引以提升查詢效能
CREATE INDEX idx_page_views_created_at ON page_views(created_at);
CREATE INDEX idx_api_logs_created_at ON api_logs(created_at);
CREATE INDEX idx_api_logs_status_code ON api_logs(status_code);
