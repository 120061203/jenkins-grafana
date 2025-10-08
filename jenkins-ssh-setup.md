# Jenkins SSH Key 設定指南

## 🔑 **使用現有 SSH Key**

### 1. 檢查 SSH Key
您的 GitHub SSH Key 已存在：
```
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDFVyYL9o35WxE0DuSD+VrkauckfrdTM6yYi/Q9VPYA/ ccssll120061203@gmail.com
```

### 2. 在 Jenkins 中設定 SSH

#### 步驟 1: 進入憑證管理
1. 登入 Jenkins: http://localhost:8080
2. 點擊: "Manage Jenkins" → "Manage Credentials"
3. 選擇: "System" → "Global credentials (unrestricted)"
4. 點擊: "Add Credentials"

#### 步驟 2: 設定 SSH Key
- **Kind**: `SSH Username with private key`
- **ID**: `github-ssh-key`
- **Description**: `GitHub SSH Key`
- **Username**: `git`
- **Private Key**: 選擇 "Enter directly"
- **Key**: 貼上以下內容：

```bash
# 複製私鑰內容
cat ~/.ssh/id_ed25519_github_120061203
```

### 3. 測試 SSH 連接
```bash
# 測試 GitHub SSH 連接
ssh -T git@github.com

# 應該看到類似：
# Hi 120061203! You've successfully authenticated, but GitHub does not provide shell access.
```

### 4. 設定 Pipeline 使用 SSH

在 Jenkins Pipeline 中：
```groovy
pipeline {
    agent any
    
    stages {
        stage('Checkout') {
            steps {
                checkout([
                    $class: 'GitSCM',
                    branches: [[name: '*/main']],
                    userRemoteConfigs: [[
                        url: 'git@github.com:120061203/jenkins-grafana.git',
                        credentialsId: 'github-ssh-key'
                    ]]
                ])
            }
        }
    }
}
```

## 🔧 **SSH 設定檢查**

### 檢查 SSH 配置
```bash
# 檢查 SSH 配置
cat ~/.ssh/config

# 應該包含：
# Host github.com-120061203
#   HostName github.com
#   User git
#   IdentityFile ~/.ssh/id_ed25519_github_120061203
```

### 測試連接
```bash
# 測試 SSH 連接
ssh -T git@github.com-120061203

# 或直接測試
ssh -T -i ~/.ssh/id_ed25519_github_120061203 git@github.com
```

## 🚀 **建立 Pipeline 專案**

### 1. 建立新專案
1. 點擊: "New Item"
2. 專案名稱: `xsong-us-grafana-deployment`
3. 選擇: "Pipeline"
4. 點擊: "OK"

### 2. 設定 Pipeline
1. **Pipeline** 標籤:
   - Definition: "Pipeline script from SCM"
   - SCM: "Git"
   - Repository URL: `git@github.com:120061203/jenkins-grafana.git`
   - Credentials: 選擇 `github-ssh-key`
   - Branch: `*/main`
   - Script Path: `Jenkinsfile`

### 3. 設定 Webhook
1. GitHub 倉庫 → Settings → Webhooks
2. Payload URL: `http://localhost:8080/github-webhook/`
3. Content type: `application/json`
4. Events: "Just the push event"

## 📋 **故障排除**

### SSH 連接問題
```bash
# 檢查 SSH Agent
ssh-add -l

# 添加 SSH Key
ssh-add ~/.ssh/id_ed25519_github_120061203

# 測試連接
ssh -T git@github.com
```

### Jenkins 權限問題
1. 確保 Jenkins 用戶有 SSH key 訪問權限
2. 檢查 Jenkins 日誌: `~/.jenkins/logs/jenkins.log`
3. 重新啟動 Jenkins: `brew services restart jenkins-lts`
