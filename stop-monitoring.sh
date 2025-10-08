#!/bin/bash

# xsong.us 網站監控系統停止腳本

echo "🛑 停止 xsong.us 網站監控系統..."

# 停止所有服務
docker-compose down

# 可選：清理資料卷（取消註解以啟用）
# echo "🧹 清理資料卷..."
# docker-compose down -v

echo "✅ 監控系統已停止"
echo ""
echo "💡 提示："
echo "  - 要完全清理資料，請執行: docker-compose down -v"
echo "  - 要重新啟動，請執行: ./start-monitoring.sh"
