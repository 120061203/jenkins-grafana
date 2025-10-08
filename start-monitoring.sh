#!/bin/bash

# xsong.us 網站監控系統啟動腳本
# 使用 Docker Compose 啟動完整的監控環境

echo "🚀 啟動 xsong.us 網站監控系統..."

# 檢查 Docker 是否運行
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker 未運行，請先啟動 Docker"
    exit 1
fi

# 檢查 Docker Compose 是否可用
if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose 未安裝，請先安裝 Docker Compose"
    exit 1
fi

# 建立必要的目錄
echo "📁 建立必要的目錄..."
mkdir -p grafana/provisioning/{datasources,dashboards}
mkdir -p nginx/{html,ssl}
mkdir -p mysql

# 設定權限
chmod +x start-monitoring.sh
chmod +x stop-monitoring.sh

# 啟動服務
echo "🐳 啟動 Docker 容器..."
docker-compose up -d

# 等待服務啟動
echo "⏳ 等待服務啟動..."
sleep 30

# 檢查服務狀態
echo "🔍 檢查服務狀態..."
docker-compose ps

# 顯示服務 URL
echo ""
echo "✅ 監控系統啟動完成！"
echo ""
echo "📊 服務 URL："
echo "  - 網站: http://localhost (全新設計的 xsong.us 監控平台)"
echo "  - Grafana: http://localhost:3001 (admin/admin123)"
echo "  - Prometheus: http://localhost:9090"
echo "  - Alertmanager: http://localhost:9093"
echo ""
echo "🔧 監控端點："
echo "  - Node Exporter: http://localhost:9100"
echo "  - Nginx Exporter: http://localhost:9113"
echo "  - MySQL Exporter: http://localhost:9104"
echo "  - Blackbox Exporter: http://localhost:9115"
echo ""
echo "📝 日誌查看："
echo "  docker-compose logs -f [service_name]"
echo ""
echo "🛑 停止服務："
echo "  ./stop-monitoring.sh"
echo ""
