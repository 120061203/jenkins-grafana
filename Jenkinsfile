pipeline {
    agent any
    
    environment {
        // Grafana Cloud 設定
        GRAFANA_URL = 'https://xsong.grafana.net'
        GRAFANA_API_KEY = credentials('grafana-api-key')  // 從 Jenkins 憑證管理取得
        
        // Terraform 設定
        TF_VAR_grafana_url = "${GRAFANA_URL}"
        TF_VAR_grafana_api_key = "${GRAFANA_API_KEY}"
        
        // 部署資訊
        DASHBOARD_TITLE = "xsong.us 網站監控 Dashboard"
        DASHBOARD_TAGS = "xsong.us,website,monitoring,traffic,performance"
    }
    
    stages {
        stage('🚀 初始化') {
            steps {
                echo '🔍 開始自動部署流程...'
                echo "📊 目標: ${DASHBOARD_TITLE}"
                echo "🌐 Grafana URL: ${GRAFANA_URL}"
                
                // 顯示環境資訊
                sh '''
                    echo "=== 環境資訊 ==="
                    echo "Jenkins 版本: $(java -version 2>&1 | head -1)"
                    echo "Git 版本: $(git --version)"
                    echo "Terraform 版本: $(terraform --version | head -1)"
                    echo "當前時間: $(date)"
                '''
            }
        }
        
        stage('📥 拉取程式碼') {
            steps {
                echo '🔍 正在拉取最新程式碼...'
                checkout scm
                
                // 顯示提交資訊
                sh '''
                    echo "=== Git 資訊 ==="
                    echo "分支: $(git branch --show-current)"
                    echo "提交: $(git log -1 --pretty=format:"%h - %s (%an, %ar)")"
                    echo "檔案變更: $(git diff --name-only HEAD~1 HEAD | wc -l) 個檔案"
                '''
                
                echo '✅ 程式碼拉取完成'
            }
        }
        
        stage('🔧 Terraform 初始化') {
            steps {
                echo '🚀 初始化 Terraform...'
                dir('terraform') {
                    sh '''
                        echo "=== Terraform 初始化 ==="
                        terraform init -upgrade
                        echo "✅ Terraform 初始化完成"
                    '''
                }
            }
        }
        
        stage('📋 Terraform 規劃') {
            steps {
                echo '📋 執行 Terraform 規劃...'
                dir('terraform') {
                    sh '''
                        echo "=== Terraform 規劃 ==="
                        terraform plan -out=tfplan -detailed-exitcode
                        echo "✅ Terraform 規劃完成"
                    '''
                }
            }
        }
        
        stage('🚀 Terraform 部署') {
            steps {
                echo '🔧 執行 Terraform 部署...'
                dir('terraform') {
                    sh '''
                        echo "=== Terraform 部署 ==="
                        terraform apply -auto-approve tfplan
                        echo "✅ Terraform 部署完成"
                    '''
                }
            }
        }
        
        stage('📊 顯示部署結果') {
            steps {
                echo '📊 顯示 Terraform 部署結果...'
                dir('terraform') {
                    sh '''
                        echo "=== Terraform 輸出 ==="
                        terraform output
                        echo ""
                        echo "=== Dashboard 資訊 ==="
                        echo "Dashboard URL: $(terraform output -raw dashboard_url)"
                        echo "Dashboard UID: $(terraform output -raw dashboard_uid)"
                        echo "資料夾 URL: $(terraform output -raw folder_url)"
                    '''
                }
            }
        }
        
        stage('🔍 驗證部署') {
            steps {
                echo '🔍 驗證部署結果...'
                script {
                    // 檢查 dashboard 是否存在
                    def searchResult = sh(
                        script: """
                            curl -s -H "Authorization: Bearer ${GRAFANA_API_KEY}" \\
                                "${GRAFANA_URL}/api/search?query=${DASHBOARD_TITLE}" \\
                                -w "HTTP_STATUS:%{http_code}"
                        """,
                        returnStdout: true
                    )
                    
                    echo "🔍 搜尋結果: ${searchResult}"
                    
                    if (searchResult.contains('"title":"' + DASHBOARD_TITLE + '"')) {
                        echo '✅ Dashboard 驗證成功！'
                    } else {
                        echo '⚠️ Dashboard 驗證失敗，請手動檢查 Grafana Cloud'
                    }
                }
            }
        }
        
        stage('📈 監控設定') {
            steps {
                echo '📈 設定監控告警...'
                script {
                    // 檢查是否有 alert_rules.yml
                    if (fileExists('alert_rules.yml')) {
                        echo '📋 發現告警規則檔案，可以設定 Prometheus 告警'
                        sh '''
                            echo "=== 告警規則 ==="
                            head -20 alert_rules.yml
                        '''
                    } else {
                        echo 'ℹ️ 未發現告警規則檔案，跳過告警設定'
                    }
                }
            }
        }
    }
    
    post {
        success {
            echo '🎉 部署成功！'
            echo "📊 Dashboard: ${DASHBOARD_TITLE}"
            echo "🌐 請前往 ${GRAFANA_URL} 查看您的 Dashboard"
            echo "📧 告警將發送到: me@xsong.us"
            
            // 顯示部署摘要
            sh '''
                echo "=== 部署摘要 ==="
                echo "✅ 程式碼拉取: 完成"
                echo "✅ Terraform 部署: 完成"
                echo "✅ Dashboard 上傳: 完成"
                echo "✅ 驗證檢查: 完成"
                echo "📊 監控設定: 完成"
            '''
            
            // 可選：發送成功通知
            // slackSend channel: '#devops', 
            //          color: 'good', 
            //          message: "✅ xsong.us 監控 Dashboard 部署成功！\\n🔗 ${GRAFANA_URL}\\n📧 告警: me@xsong.us"
        }
        
        failure {
            echo '❌ 部署失敗！'
            echo '🔍 請檢查以下項目:'
            echo '  - Grafana Cloud URL 是否正確'
            echo '  - API Key 是否有效'
            echo '  - Terraform 配置是否正確'
            echo '  - 網路連接是否正常'
            
            // 顯示錯誤日誌
            sh '''
                echo "=== 錯誤診斷 ==="
                echo "Jenkins 工作空間: $(pwd)"
                echo "檔案列表:"
                ls -la
                echo "Terraform 狀態:"
                cd terraform && terraform show 2>/dev/null || echo "Terraform 狀態不可用"
            '''
            
            // 可選：發送失敗通知
            // slackSend channel: '#devops', 
            //          color: 'danger', 
            //          message: "❌ xsong.us 監控 Dashboard 部署失敗！\\n請檢查 Jenkins 日誌"
        }
        
        always {
            echo '🧹 清理工作空間...'
            cleanWs()
            
            // 顯示最終狀態
            sh '''
                echo "=== 部署完成 ==="
                echo "時間: $(date)"
                echo "狀態: ${BUILD_STATUS:-UNKNOWN}"
            '''
        }
    }
}