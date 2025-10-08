# 🚀 部署檢查清單

## ✅ **已完成項目**

### 基礎設施
- [x] Jenkins 已安裝並啟動
- [x] Cloudflare Tunnel 已連接
- [x] GitHub 倉庫已設定
- [x] 代碼已推送
- [x] 安全設定已完成

## 🔧 **需要完成的設定**

### 1. Jenkins 憑證設定
- [ ] 前往: `https://jenkins.xsong.us`
- [ ] 點擊: "Manage Jenkins" → "Manage Credentials"
- [ ] 新增: "Secret text"
- [ ] ID: `grafana-api-key`
- [ ] Secret: 您的 Grafana Cloud API Key
- [ ] 點擊: "OK"

### 2. 建立 Pipeline 專案
- [ ] 點擊: "New Item"
- [ ] 專案名稱: `xsong-us-grafana-deployment`
- [ ] 選擇: "Pipeline"
- [ ] 點擊: "OK"

#### 專案設定:
- [ ] **General** 標籤:
  - [ ] ✅ "GitHub project"
  - [ ] Project url: `https://github.com/120061203/jenkins-grafana`

- [ ] **Build Triggers** 標籤:
  - [ ] ✅ "GitHub hook trigger for GITScm polling"
  - [ ] ✅ "Build when a change is pushed to GitHub"

- [ ] **Pipeline** 標籤:
  - [ ] Definition: "Pipeline script from SCM"
  - [ ] SCM: "Git"
  - [ ] Repository URL: `git@github.com-120061203:120061203/jenkins-grafana.git`
  - [ ] Credentials: 選擇 `github-ssh-key`
  - [ ] Branch: `*/main`
  - [ ] Script Path: `Jenkinsfile`

### 3. GitHub Webhook 設定
- [ ] 前往: `https://github.com/120061203/jenkins-grafana/settings/hooks`
- [ ] 點擊: "Add webhook"
- [ ] 設定:
  - [ ] **Payload URL**: `https://jenkins.xsong.us/github-webhook/`
  - [ ] **Content type**: `application/json`
  - [ ] **Secret**: `9cdada5c978b8d7b1702986289097a4e2e96c8a064c01ae377c57e60f3b5b313`
  - [ ] **Events**: "Just the push event"
  - [ ] ✅ "Active"
- [ ] 點擊: "Add webhook"

### 4. 測試部署
- [ ] 手動觸發: 在 Jenkins 中點擊 "Build Now"
- [ ] 檢查 Console Output
- [ ] 確認部署成功

### 5. 自動觸發測試
- [ ] 修改檔案並推送
- [ ] 檢查 Jenkins 是否自動開始建置
- [ ] 確認 Dashboard 部署到 Grafana Cloud

## 🔍 **驗證步驟**

### Jenkins 狀態檢查
```bash
# 檢查 Jenkins 狀態
brew services list | grep jenkins

# 檢查 Cloudflare Tunnel
ps aux | grep cloudflared

# 測試 Jenkins 連接
curl -I https://jenkins.xsong.us
```

### GitHub 連接檢查
```bash
# 測試 SSH 連接
ssh -T git@github.com-120061203

# 檢查 webhook 狀態
# 前往 GitHub 倉庫 → Settings → Webhooks
# 查看最近的 deliveries
```

### 部署驗證
- [ ] 檢查 Grafana Cloud 是否有新的 Dashboard
- [ ] 確認 Dashboard 標題為 "xsong.us 網站監控 Dashboard"
- [ ] 檢查告警設定是否正確

## 🚨 **故障排除**

### 常見問題
1. **Jenkins 無法訪問**
   - 檢查 Cloudflare Tunnel 狀態
   - 確認 Jenkins 服務運行

2. **GitHub 連接失敗**
   - 檢查 SSH key 設定
   - 確認憑證 ID 正確

3. **部署失敗**
   - 檢查 Grafana API Key
   - 確認 URL 設定正確
   - 查看 Jenkins Console Output

4. **Webhook 不觸發**
   - 檢查 GitHub webhook 設定
   - 確認 URL 可訪問
   - 檢查 Jenkins 日誌

### 檢查命令
```bash
# Jenkins 日誌
tail -f ~/.jenkins/logs/jenkins.log

# Cloudflare Tunnel 狀態
cloudflared tunnel list

# Git 狀態
git status
git log --oneline -5
```

## 📊 **成功指標**

### 部署成功
- [ ] Jenkins 自動開始建置
- [ ] Pipeline 執行成功
- [ ] Dashboard 出現在 Grafana Cloud
- [ ] 收到成功通知

### 監控正常
- [ ] 網站可用性監控
- [ ] 回應時間監控
- [ ] HTTP 狀態碼監控
- [ ] SSL 憑證監控
- [ ] 告警發送到 me@xsong.us

## 🎯 **下一步**

完成所有設定後，您將擁有：
- ✅ 自動化 CI/CD 流程
- ✅ 24/7 網站監控
- ✅ 自動告警通知
- ✅ 完整的 DevOps 解決方案

## 📞 **支援**

如果遇到問題：
1. 檢查 Jenkins 日誌
2. 確認所有憑證設定
3. 驗證網路連接
4. 查看 GitHub webhook 狀態
