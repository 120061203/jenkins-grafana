# Jenkins + GitHub 連接設定指南

## 🔑 **GitHub Personal Access Token 設定**

### 1. 建立 GitHub Token
1. 前往: https://github.com/settings/tokens
2. 點擊: "Generate new token" → "Generate new token (classic)"
3. 設定:
   - **Note**: `Jenkins CI/CD`
   - **Expiration**: `90 days`
   - **Scopes**: 勾選:
     - ✅ `repo` (完整倉庫訪問)
     - ✅ `admin:repo_hook` (管理倉庫 webhooks)
     - ✅ `user:email` (讀取用戶 email)
4. 點擊: "Generate token"
5. **複製並保存 Token** (只會顯示一次！)

### 2. 在 Jenkins 中設定憑證

#### 步驟 1: 進入憑證管理
1. 登入 Jenkins: http://localhost:8080
2. 點擊: "Manage Jenkins" → "Manage Credentials"
3. 選擇: "System" → "Global credentials (unrestricted)"
4. 點擊: "Add Credentials"

#### 步驟 2: 設定 GitHub Token
- **Kind**: `Secret text`
- **Secret**: `貼上您的 GitHub Token`
- **ID**: `github-token`
- **Description**: `GitHub Personal Access Token`
- 點擊: "OK"

#### 步驟 3: 設定 GitHub 用戶名/密碼 (可選)
- **Kind**: `Username with password`
- **Username**: `您的 GitHub 用戶名`
- **Password**: `您的 GitHub Token`
- **ID**: `github-credentials`
- **Description**: `GitHub Username/Token`
- 點擊: "OK"

## 🔧 **Jenkins 插件安裝**

### 必要插件
1. **GitHub Plugin**: 基本 GitHub 整合
2. **GitHub Branch Source Plugin**: 分支管理
3. **GitHub Authentication Plugin**: GitHub 認證
4. **Pipeline Plugin**: Pipeline 支援
5. **Git Plugin**: Git 操作

### 安裝步驟
1. 前往: "Manage Jenkins" → "Manage Plugins"
2. 在 "Available" 標籤中搜尋並安裝:
   - GitHub Plugin
   - GitHub Branch Source Plugin
   - GitHub Authentication Plugin
   - Pipeline Plugin
   - Git Plugin

## 🚀 **建立 Pipeline 專案**

### 1. 建立新專案
1. 點擊: "New Item"
2. 輸入專案名稱: `xsong-us-grafana-deployment`
3. 選擇: "Pipeline"
4. 點擊: "OK"

### 2. 設定 Pipeline
1. **General** 標籤:
   - ✅ "GitHub project"
   - Project url: `https://github.com/120061203/jenkins-grafana`

2. **Pipeline** 標籤:
   - Definition: "Pipeline script from SCM"
   - SCM: "Git"
   - Repository URL: `https://github.com/120061203/jenkins-grafana.git`
   - Credentials: 選擇 `github-credentials`
   - Branch: `*/main`
   - Script Path: `Jenkinsfile`

### 3. 設定 Webhook (自動觸發)
1. 前往 GitHub 倉庫: https://github.com/120061203/jenkins-grafana
2. 點擊: "Settings" → "Webhooks"
3. 點擊: "Add webhook"
4. 設定:
   - **Payload URL**: `http://localhost:8080/github-webhook/`
   - **Content type**: `application/json`
   - **Events**: 選擇 "Just the push event"
   - ✅ "Active"
5. 點擊: "Add webhook"

## 📋 **測試連接**

### 1. 手動觸發
1. 在 Jenkins 專案頁面
2. 點擊: "Build Now"
3. 查看 Console Output

### 2. 自動觸發
1. 在 GitHub 中修改檔案
2. 提交並推送
3. 檢查 Jenkins 是否自動開始建置

## 🔧 **故障排除**

### 常見問題
1. **認證失敗**: 檢查 Token 權限
2. **Webhook 失敗**: 檢查 Jenkins URL 是否可訪問
3. **Git 克隆失敗**: 檢查倉庫 URL 和憑證

### 檢查命令
```bash
# 檢查 Jenkins 狀態
brew services list | grep jenkins

# 檢查 Jenkins 日誌
tail -f ~/.jenkins/logs/jenkins.log

# 測試 GitHub 連接
curl -H "Authorization: token YOUR_TOKEN" https://api.github.com/user
```

## 📞 **支援**

如果遇到問題，請檢查:
1. Jenkins 日誌: `~/.jenkins/logs/jenkins.log`
2. GitHub Token 權限
3. 網路連接
4. Jenkins 插件版本
