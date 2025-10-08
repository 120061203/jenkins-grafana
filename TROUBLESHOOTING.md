# 🔧 Dashboard 部署問題診斷指南

## 🚨 **問題：Dashboard 沒有出現在 Grafana Cloud**

### **可能的原因和解決方案**

## 1. Jenkins 建置問題

### 檢查 Jenkins 建置狀態
1. **前往 Jenkins**: `https://jenkins.xsong.us`
2. **查看專案**: `xsong-us-grafana-deployment`
3. **檢查建置歷史**: 是否有建置記錄
4. **查看 Console Output**: 檢查錯誤訊息

### 常見 Jenkins 問題
- ❌ **憑證未設定**: `grafana-api-key` 憑證不存在
- ❌ **API Key 無效**: Grafana API Key 過期或權限不足
- ❌ **URL 錯誤**: Grafana URL 設定錯誤
- ❌ **網路問題**: 無法連接到 Grafana Cloud

## 2. Grafana Cloud 設定問題

### 檢查 Grafana Cloud 設定
1. **確認 URL**: 應該是 `https://xsong.grafana.net`
2. **檢查 API Key**: 權限是否足夠
3. **確認組織**: 是否在正確的組織中

### 手動測試 API 連接
```bash
# 測試 Grafana API 連接
curl -H "Authorization: Bearer YOUR_API_KEY" \
     https://xsong.grafana.net/api/search
```

## 3. Dashboard JSON 問題

### 檢查 dashboard.json
1. **JSON 格式**: 確保 JSON 格式正確
2. **必要欄位**: 確保有 `title`, `panels` 等必要欄位
3. **資料來源**: 確保 Prometheus 資料來源存在

## 4. 手動上傳 Dashboard

### 方法 1: 使用 Grafana UI
1. **前往**: `https://xsong.grafana.net`
2. **點擊**: "+" → "Import"
3. **上傳**: 選擇 `dashboard.json` 檔案
4. **設定**: 選擇資料來源
5. **儲存**: 點擊 "Import"

### 方法 2: 使用 curl 命令
```bash
# 手動上傳 Dashboard
curl -X POST \
  -H "Authorization: Bearer YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d @dashboard.json \
  https://xsong.grafana.net/api/dashboards/db
```

## 5. 檢查步驟

### 步驟 1: 驗證 Jenkins 設定
```bash
# 檢查 Jenkins 狀態
brew services list | grep jenkins

# 檢查 Jenkins 日誌
tail -f ~/.jenkins/logs/jenkins.log
```

### 步驟 2: 驗證 Grafana 連接
```bash
# 測試 Grafana API
curl -I https://xsong.grafana.net

# 測試 API Key (替換 YOUR_API_KEY)
curl -H "Authorization: Bearer YOUR_API_KEY" \
     https://xsong.grafana.net/api/user
```

### 步驟 3: 檢查 Dashboard JSON
```bash
# 驗證 JSON 格式
python -m json.tool dashboard.json > /dev/null && echo "JSON 格式正確" || echo "JSON 格式錯誤"

# 檢查必要欄位
grep -q '"title"' dashboard.json && echo "有標題" || echo "缺少標題"
grep -q '"panels"' dashboard.json && echo "有面板" || echo "缺少面板"
```

## 6. 快速修復方案

### 方案 A: 重新設定 Jenkins 憑證
1. **前往**: Jenkins → Manage Credentials
2. **刪除**: 現有的 `grafana-api-key`
3. **重新建立**: 使用正確的 API Key
4. **測試**: 手動觸發建置

### 方案 B: 手動上傳 Dashboard
1. **下載**: `dashboard.json` 檔案
2. **前往**: Grafana Cloud → Import
3. **上傳**: 選擇檔案
4. **設定**: 資料來源和標題
5. **儲存**: 完成匯入

### 方案 C: 使用簡化版 Pipeline
1. **替換**: 使用 `Jenkinsfile-simple`
2. **測試**: 手動觸發建置
3. **檢查**: Console Output

## 7. 檢查清單

### Jenkins 設定檢查
- [ ] Jenkins 服務運行中
- [ ] 專案已建立
- [ ] 憑證已設定
- [ ] Pipeline 配置正確
- [ ] GitHub webhook 已設定

### Grafana Cloud 檢查
- [ ] 可以正常訪問
- [ ] API Key 有效
- [ ] 有足夠權限
- [ ] 組織設定正確

### Dashboard 檢查
- [ ] JSON 格式正確
- [ ] 包含必要欄位
- [ ] 資料來源設定正確
- [ ] 標題和標籤正確

## 8. 下一步行動

1. **立即檢查**: Jenkins 建置狀態
2. **手動測試**: 上傳 Dashboard
3. **修復問題**: 根據錯誤訊息修復
4. **重新部署**: 測試完整流程

## 📞 **需要協助**

如果問題持續，請提供：
1. Jenkins Console Output
2. Grafana Cloud 錯誤訊息
3. 網路連接狀態
4. API Key 權限確認
