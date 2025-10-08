# Jenkins + Grafana Cloud 自動部署專案 - xsong.us 網站監控

## 🚀 **專案概述**

本專案實現了完整的 DevOps 自動化流程，使用 Jenkins 自動部署 Grafana Dashboard 到 Grafana Cloud，並建立 24/7 網站監控系統。

## 📁 **專案結構**

```
jenkins-grafana/
├── Jenkinsfile                    # Jenkins Pipeline 配置
├── dashboard.json                 # Grafana Dashboard 定義
├── terraform/                     # Terraform 配置
│   ├── main.tf
│   ├── variables.tf
│   └── terraform.tfvars.example
├── prometheus-config.yml          # Prometheus 配置
├── alert_rules.yml               # 告警規則
├── docker-compose.yml            # Docker 監控環境
├── nginx/                        # 網站檔案
│   ├── nginx.conf
│   └── html/index.html
├── mysql/                        # 資料庫初始化
│   └── init.sql
├── grafana/                      # Grafana 配置
│   └── provisioning/
└── README.md                     # 專案說明
```

## 🎯 **功能特色**

### 自動化 CI/CD
- ✅ **自動觸發**: GitHub 推送 → Jenkins 自動建置
- ✅ **自動部署**: Dashboard 自動上傳到 Grafana Cloud
- ✅ **自動驗證**: 部署結果自動檢查
- ✅ **自動通知**: 告警發送到指定 email

### 24/7 網站監控
- 🌐 **網站可用性**: 監控 `https://xsong.us`
- ⏱️ **回應時間**: 即時監控
- 📊 **HTTP 狀態碼**: 自動檢查
- 🔒 **SSL 憑證**: 到期提醒
- 📈 **流量分析**: 完整統計

### 智能告警系統
- 🚨 **嚴重告警**: 網站無法訪問
- ⚠️ **警告告警**: 效能下降
- 📧 **Email 通知**: 發送到指定 email
- 🔔 **即時通知**: 問題發生時立即通知

## 🚀 **快速開始**

### 方式一：使用 Docker 本地監控環境（推薦）

#### 1. 啟動監控系統
```bash
docker-compose up -d
```

#### 2. 訪問監控服務
- **網站**: http://localhost
- **Grafana**: http://localhost:3000 (admin/請設定您的密碼)
- **Prometheus**: http://localhost:9090
- **Alertmanager**: http://localhost:9093

#### 3. 查看監控面板
1. 登入 Grafana (admin/請設定您的密碼)
2. 前往 Dashboards
3. 查看 "xsong.us 網站監控 Dashboard"

### 方式二：部署到 Grafana Cloud

#### 1. 設定 Jenkins 憑證
1. 前往 Jenkins: `https://jenkins.xsong.us`
2. 點擊: "Manage Jenkins" → "Manage Credentials"
3. 新增: "Secret text"
4. ID: `grafana-api-key`
5. Secret: 您的 Grafana Cloud API Key

#### 2. 建立 Pipeline 專案
1. 點擊: "New Item"
2. 專案名稱: `xsong-us-grafana-deployment`
3. 選擇: "Pipeline"
4. 設定 Pipeline script from SCM

#### 3. 設定 GitHub Webhook
1. 前往: `https://github.com/120061203/jenkins-grafana/settings/hooks`
2. 新增 webhook:
   - **Payload URL**: `https://jenkins.xsong.us/github-webhook/`
   - **Content type**: `application/json`
   - **Events**: "Just the push event"

## 📊 **監控 Dashboard 功能**

### 主要監控指標
1. **網站狀態**: 可用性、回應時間
2. **HTTP 狀態**: 200/404/500 等狀態碼
3. **SSL 憑證**: 到期時間監控
4. **流量趨勢**: 訪問量統計
5. **效能分析**: 回應時間分布

### 告警規則
- 🔴 **嚴重**: 網站完全無法訪問
- 🟡 **警告**: 回應時間 > 3 秒
- 🟠 **提醒**: SSL 憑證 30 天內到期

## 🔧 **監控設定指南**

### Docker 監控環境
```bash
# 啟動監控系統
docker-compose up -d

# 查看服務狀態
docker-compose ps

# 查看日誌
docker-compose logs -f [service_name]
```

### 監控端點
- **Node Exporter**: http://localhost:9100
- **Nginx Exporter**: http://localhost:9113
- **MySQL Exporter**: http://localhost:9104
- **Blackbox Exporter**: http://localhost:9115

## 📋 **設定檢查清單**

### Jenkins 設定
- [ ] Jenkins 服務運行中
- [ ] 專案已建立
- [ ] 憑證已設定
- [ ] Pipeline 配置正確
- [ ] GitHub webhook 已設定

### Grafana Cloud 設定
- [ ] 可以正常訪問
- [ ] API Key 有效
- [ ] 有足夠權限
- [ ] 組織設定正確

### Dashboard 設定
- [ ] JSON 格式正確
- [ ] 包含必要欄位
- [ ] 資料來源設定正確
- [ ] 標題和標籤正確

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
# Jenkins 狀態
brew services list | grep jenkins

# Cloudflare Tunnel 狀態
ps aux | grep cloudflared

# Git 狀態
git status
git log --oneline -5
```

## 📞 **支援**

如果遇到問題：
1. 檢查 Jenkins 日誌: `~/.jenkins/logs/jenkins.log`
2. 確認所有憑證設定
3. 驗證網路連接
4. 查看 GitHub webhook 狀態

## 🎯 **成功指標**

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
- [ ] 告警發送到指定 email

## 🎊 **恭喜！**

您現在擁有一個完整的企業級 DevOps 監控解決方案：

- ✅ **自動化部署**: 代碼推送 → 自動部署
- ✅ **24/7 監控**: 網站狀態實時監控
- ✅ **智能告警**: 問題發生時立即通知
- ✅ **完整日誌**: 所有活動都有記錄
- ✅ **安全設定**: API Key 安全管理

您的 `xsong.us` 網站現在有了專業級的監控保護！🚀✨