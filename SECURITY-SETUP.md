# 🔐 Jenkins 安全設定指南

## 🚨 **重要：API Key 安全設定**

### ❌ **絕對不要做的事情**
- ❌ 將 API Key 直接寫在 Jenkinsfile 中
- ❌ 將 API Key 提交到 Git 倉庫
- ❌ 在程式碼中硬編碼敏感資訊

### ✅ **正確的做法**

## 方法 1: Jenkins 憑證管理 (推薦)

### 步驟 1: 建立 Grafana API Key
1. 前往 Grafana Cloud: `https://xsong.grafana.net`
2. 點擊: "Configuration" → "API Keys"
3. 點擊: "New API Key"
4. 設定:
   - **Name**: `Jenkins CI/CD`
   - **Role**: `Admin` (或適當權限)
   - **Time to live**: `1 year` (或您喜歡的時間)
5. 點擊: "Add"
6. **複製 API Key** (只會顯示一次！)

### 步驟 2: 在 Jenkins 中設定憑證
1. 前往: `https://jenkins.xsong.us`
2. 點擊: "Manage Jenkins" → "Manage Credentials"
3. 選擇: "System" → "Global credentials (unrestricted)"
4. 點擊: "Add Credentials"
5. 設定:
   - **Kind**: `Secret text`
   - **Secret**: `貼上您的 Grafana API Key`
   - **ID**: `grafana-api-key`
   - **Description**: `Grafana Cloud API Key for CI/CD`
6. 點擊: "OK"

### 步驟 3: 驗證設定
在 Jenkinsfile 中使用：
```groovy
environment {
    GRAFANA_URL = 'https://xsong.grafana.net'
    GRAFANA_API_KEY = credentials('grafana-api-key')  // 安全取得
}
```

## 方法 2: 環境變數 (進階)

### 在 Jenkins 系統設定中
1. 前往: "Manage Jenkins" → "Configure System"
2. 找到: "Global properties"
3. 勾選: "Environment variables"
4. 新增:
   - **Name**: `GRAFANA_API_KEY`
   - **Value**: `您的 API Key`

### 在 Pipeline 中使用
```groovy
environment {
    GRAFANA_URL = 'https://xsong.grafana.net'
    GRAFANA_API_KEY = env.GRAFANA_API_KEY
}
```

## 方法 3: 外部憑證管理 (企業級)

### 使用 HashiCorp Vault
```groovy
script {
    def vault = new VaultBuildWrapper.VaultBuildWrapper()
    def secret = vault.getVaultSecret('secret/grafana')
    env.GRAFANA_API_KEY = secret.api_key
}
```

### 使用 AWS Secrets Manager
```groovy
script {
    def secret = sh(
        script: "aws secretsmanager get-secret-value --secret-id grafana-api-key --query SecretString --output text",
        returnStdout: true
    ).trim()
    env.GRAFANA_API_KEY = secret
}
```

## 🔍 **安全檢查清單**

### ✅ **檢查項目**
- [ ] API Key 不在 Git 倉庫中
- [ ] Jenkins 憑證已正確設定
- [ ] 使用最小權限原則
- [ ] 定期輪換 API Key
- [ ] 監控 API Key 使用情況

### 🔧 **驗證命令**
```bash
# 檢查 .gitignore 是否包含敏感檔案
grep -E "\.env|\.key|credentials" .gitignore

# 檢查 Git 歷史中是否有敏感資訊
git log --all --full-history -- "*.key" "*.env" "credentials*"

# 檢查當前檔案中是否有硬編碼的 API Key
grep -r "glc_" . --exclude-dir=.git
```

## 📋 **最佳實踐**

### 1. **權限最小化**
- 只給予必要的 Grafana 權限
- 定期審查和更新權限

### 2. **監控和日誌**
- 監控 API Key 使用情況
- 記錄所有部署活動
- 設定異常警報

### 3. **備份和恢復**
- 備份 Jenkins 憑證
- 準備 API Key 輪換計劃
- 測試災難恢復流程

## 🚨 **緊急情況處理**

### 如果 API Key 洩露
1. **立即撤銷**: 在 Grafana Cloud 中撤銷 API Key
2. **生成新的**: 建立新的 API Key
3. **更新 Jenkins**: 更新 Jenkins 中的憑證
4. **檢查日誌**: 檢查是否有未授權使用

### 如果 Jenkins 憑證遺失
1. **重新設定**: 在 Jenkins 中重新設定憑證
2. **測試部署**: 執行測試部署確認正常
3. **更新文檔**: 更新相關文檔

## 📞 **支援**

如果遇到問題：
1. 檢查 Jenkins 日誌: `~/.jenkins/logs/jenkins.log`
2. 檢查 Grafana API Key 權限
3. 確認網路連接正常
4. 驗證 URL 和憑證格式
