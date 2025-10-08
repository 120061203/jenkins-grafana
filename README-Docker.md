# Docker 監控環境設定指南

## 🐳 Docker 環境說明

這個專案使用 Docker Compose 來建立完整的監控環境，包含：

### 📊 監控服務
- **Prometheus**: 監控資料收集和儲存
- **Grafana**: 視覺化監控面板
- **Alertmanager**: 告警通知管理

### 🔧 監控工具 (Exporters)
- **Node Exporter**: 系統資源監控 (CPU、記憶體、磁碟)
- **Nginx Exporter**: 網站流量監控
- **MySQL Exporter**: 資料庫監控
- **Blackbox Exporter**: 網站可用性監控

### 🌐 應用服務
- **Nginx**: 模擬 xsong.us 網站
- **MySQL**: 模擬資料庫
- **Redis**: 快取服務

## 🚀 快速啟動

### 1. 啟動監控系統
```bash
# 啟動所有服務
./start-monitoring.sh

# 或手動啟動
docker-compose up -d
```

### 2. 檢查服務狀態
```bash
# 查看所有容器狀態
docker-compose ps

# 查看服務日誌
docker-compose logs -f [service_name]
```

### 3. 訪問服務
- **網站**: http://localhost
- **Grafana**: http://localhost:3000 (admin/admin123)
- **Prometheus**: http://localhost:9090
- **Alertmanager**: http://localhost:9093

## 🔧 服務配置

### Prometheus 設定
- 設定檔: `prometheus-config.yml`
- 告警規則: `alert_rules.yml`
- 資料保留: 200 小時

### Grafana 設定
- 預設帳號: admin/admin123
- 資料來源: 自動連接到 Prometheus
- Dashboard: 自動載入 xsong.us 監控面板

### Nginx 設定
- 網站根目錄: `nginx/html/`
- 狀態端點: `/nginx_status`
- 健康檢查: `/health`
- API 端點: `/api/`

## 📊 監控指標

### 網站監控
- 可用性檢查 (Blackbox Exporter)
- HTTP 狀態碼
- 回應時間
- SSL 憑證狀態

### 系統監控
- CPU 使用率
- 記憶體使用率
- 磁碟使用率
- 網路流量

### 應用監控
- Nginx 請求數
- MySQL 連線數
- API 回應時間
- 錯誤率

## 🛠️ 故障排除

### 常見問題

#### 1. 容器啟動失敗
```bash
# 檢查 Docker 是否運行
docker info

# 檢查端口是否被佔用
netstat -tulpn | grep :3000
```

#### 2. 服務無法訪問
```bash
# 檢查容器狀態
docker-compose ps

# 查看容器日誌
docker-compose logs [service_name]
```

#### 3. 資料庫連線問題
```bash
# 檢查 MySQL 容器
docker-compose logs mysql

# 測試資料庫連線
docker-compose exec mysql mysql -u root -p
```

### 清理和重置

#### 停止所有服務
```bash
./stop-monitoring.sh
```

#### 完全清理（包含資料）
```bash
docker-compose down -v
docker system prune -a
```

#### 重新建立
```bash
docker-compose up -d --force-recreate
```

## 📈 效能調優

### 資源限制
在 `docker-compose.yml` 中可以設定資源限制：

```yaml
services:
  prometheus:
    deploy:
      resources:
        limits:
          memory: 1G
          cpus: '0.5'
```

### 資料保留設定
- Prometheus: 200 小時
- Grafana: 永久保存
- MySQL: 永久保存

## 🔒 安全設定

### 生產環境建議
1. 修改預設密碼
2. 啟用 HTTPS
3. 設定防火牆規則
4. 定期備份資料

### 密碼設定
```bash
# 設定 Grafana 密碼
export GF_SECURITY_ADMIN_PASSWORD=your_secure_password

# 設定 MySQL 密碼
export MYSQL_ROOT_PASSWORD=your_secure_password
```

## 📝 日誌管理

### 查看日誌
```bash
# 查看所有服務日誌
docker-compose logs

# 查看特定服務日誌
docker-compose logs prometheus
docker-compose logs grafana
```

### 日誌輪轉
```yaml
services:
  prometheus:
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"
```

## 🚀 部署到生產環境

### 環境變數
建立 `.env` 檔案：

```env
GRAFANA_ADMIN_PASSWORD=your_secure_password
MYSQL_ROOT_PASSWORD=your_secure_password
PROMETHEUS_RETENTION=30d
```

### 使用環境變數
```bash
docker-compose --env-file .env up -d
```

## 📚 相關資源

- [Docker Compose 文件](https://docs.docker.com/compose/)
- [Prometheus 文件](https://prometheus.io/docs/)
- [Grafana 文件](https://grafana.com/docs/)
- [Nginx 文件](https://nginx.org/en/docs/)
