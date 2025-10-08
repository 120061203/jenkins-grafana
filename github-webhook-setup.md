# GitHub Webhook + Jenkins 自動部署設定指南

## 🔗 **GitHub Webhook 設定**

### 1. 前往 GitHub 倉庫設定
- 網址: `https://github.com/120061203/jenkins-grafana`
- 點擊: "Settings" → "Webhooks"
- 點擊: "Add webhook"

### 2. 設定 Webhook 參數
```
Payload URL: https://jenkins.xsong.us/github-webhook/
Content type: application/json
Secret: 9cdada5c978b8d7b1702986289097a4e2e96c8a064c01ae377c57e60f3b5b313
Events: Just the push event
Active: ✅
```

### 3. 測試 Webhook
- 點擊 "Add webhook" 後
- GitHub 會發送測試請求
- 檢查是否收到 "200 OK" 響應

## 🔧 **Jenkins 設定**

### 1. 安裝必要插件
前往: "Manage Jenkins" → "Manage Plugins" → "Available"

安裝以下插件:
- ✅ GitHub Plugin
- ✅ GitHub Branch Source Plugin  
- ✅ GitHub Authentication Plugin
- ✅ Pipeline Plugin
- ✅ Git Plugin

### 2. 設定 GitHub 憑證
前往: "Manage Jenkins" → "Manage Credentials" → "System" → "Global credentials"

#### SSH Key 憑證:
- **Kind**: `SSH Username with private key`
- **ID**: `github-ssh-key`
- **Description**: `GitHub SSH Key`
- **Username**: `git`
- **Private Key**: 貼上 SSH 私鑰內容

#### Webhook Secret 憑證:
- **Kind**: `Secret text`
- **ID**: `github-webhook-secret`
- **Description**: `GitHub Webhook Secret`
- **Secret**: `9cdada5c978b8d7b1702986289097a4e2e96c8a064c01ae377c57e60f3b5b313`

### 3. 建立 Pipeline 專案

#### 專案設定:
1. **New Item** → 專案名稱: `xsong-us-grafana-deployment`
2. **Pipeline** 類型
3. **Pipeline** 標籤設定:
   - Definition: "Pipeline script from SCM"
   - SCM: "Git"
   - Repository URL: `git@github.com-120061203:120061203/jenkins-grafana.git`
   - Credentials: `github-ssh-key`
   - Branch: `*/main`
   - Script Path: `Jenkinsfile`

#### GitHub 專案設定:
1. **General** 標籤:
   - ✅ "GitHub project"
   - Project url: `https://github.com/120061203/jenkins-grafana`

#### Build Triggers 設定:
1. **Build Triggers** 標籤:
   - ✅ "GitHub hook trigger for GITScm polling"
   - ✅ "Build when a change is pushed to GitHub"

## 🚀 **測試自動部署**

### 1. 手動觸發測試
1. 在 Jenkins 專案頁面
2. 點擊: "Build Now"
3. 查看 Console Output

### 2. 自動觸發測試
1. 修改 GitHub 倉庫中的檔案
2. 提交並推送:
   ```bash
   git add .
   git commit -m "測試自動部署"
   git push origin main
   ```
3. 檢查 Jenkins 是否自動開始建置

### 3. 檢查 Webhook 狀態
- GitHub 倉庫 → Settings → Webhooks
- 查看最近的 deliveries
- 確認狀態為 "200 OK"

## 🔍 **故障排除**

### 常見問題

#### 1. Webhook 無法觸發
**檢查項目**:
- Jenkins 是否運行: `brew services list | grep jenkins`
- Cloudflare Tunnel 是否運行: `ps aux | grep cloudflared`
- GitHub webhook URL 是否正確

#### 2. 認證失敗
**檢查項目**:
- SSH key 是否正確設定
- GitHub 憑證是否有效
- 倉庫 URL 是否正確

#### 3. Pipeline 執行失敗
**檢查項目**:
- Jenkinsfile 語法是否正確
- 必要插件是否已安裝
- 權限設定是否正確

### 檢查命令
```bash
# 檢查 Jenkins 狀態
brew services list | grep jenkins

# 檢查 Cloudflare Tunnel
ps aux | grep cloudflared

# 檢查 Jenkins 日誌
tail -f ~/.jenkins/logs/jenkins.log

# 測試 GitHub SSH 連接
ssh -T git@github.com-120061203
```

## 📋 **完整流程**

1. ✅ GitHub 倉庫推送代碼
2. ✅ GitHub 發送 webhook 到 Jenkins
3. ✅ Jenkins 接收 webhook 觸發
4. ✅ Jenkins 拉取最新代碼
5. ✅ 執行 Pipeline (Terraform + Grafana API)
6. ✅ 部署 Dashboard 到 Grafana Cloud
7. ✅ 發送通知 (可選)

## 🎯 **成功指標**

- ✅ GitHub webhook 狀態: "200 OK"
- ✅ Jenkins 自動開始建置
- ✅ Pipeline 執行成功
- ✅ Dashboard 部署到 Grafana Cloud
- ✅ 收到成功通知
