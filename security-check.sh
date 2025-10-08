#!/bin/bash

# 🔐 安全檢查腳本
echo "🔍 檢查敏感資訊洩露..."

# 檢查 SSH 私鑰
echo "檢查 SSH 私鑰..."
if grep -r "BEGIN.*PRIVATE KEY" . --exclude-dir=.git > /dev/null; then
    echo "❌ 發現 SSH 私鑰洩露！"
    grep -r "BEGIN.*PRIVATE KEY" . --exclude-dir=.git
else
    echo "✅ 沒有發現 SSH 私鑰洩露"
fi

# 檢查 API Key
echo "檢查 API Key..."
if grep -r "glc_" . --exclude-dir=.git > /dev/null; then
    echo "❌ 發現 Grafana API Key 洩露！"
    grep -r "glc_" . --exclude-dir=.git
else
    echo "✅ 沒有發現 API Key 洩露"
fi

# 檢查密碼
echo "檢查密碼..."
if grep -r "password.*=" . --exclude-dir=.git --exclude="*.md" > /dev/null; then
    echo "⚠️ 發現可能的密碼設定..."
    grep -r "password.*=" . --exclude-dir=.git --exclude="*.md"
else
    echo "✅ 沒有發現密碼洩露"
fi

# 檢查 .gitignore
echo "檢查 .gitignore 設定..."
if grep -q "\.env\|\.key\|\.pem" .gitignore; then
    echo "✅ .gitignore 包含敏感檔案保護"
else
    echo "❌ .gitignore 缺少敏感檔案保護"
fi

echo "🔍 安全檢查完成"
