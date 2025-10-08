pipeline {
    agent any
    
    environment {
        // Grafana Cloud 設定
        GRAFANA_URL = 'https://your-instance.grafana.net'
        GRAFANA_API_KEY = credentials('grafana-api-key')
        
        // Terraform 設定
        TF_VAR_grafana_url = "${GRAFANA_URL}"
        TF_VAR_grafana_api_key = "${GRAFANA_API_KEY}"
    }
    
    stages {
        stage('Checkout Code') {
            steps {
                echo '🔍 正在拉取程式碼...'
                checkout scm
                echo '✅ 程式碼拉取完成'
            }
        }
        
        stage('Terraform Init & Plan') {
            steps {
                echo '🚀 初始化 Terraform...'
                dir('terraform') {
                    sh '''
                        terraform init
                        terraform plan -out=tfplan
                    '''
                }
                echo '✅ Terraform 規劃完成'
            }
        }
        
        stage('Terraform Apply') {
            steps {
                echo '🔧 執行 Terraform 部署...'
                dir('terraform') {
                    sh 'terraform apply -auto-approve tfplan'
                }
                echo '✅ Terraform 部署完成'
            }
        }
        
        stage('Upload Dashboard') {
            steps {
                echo '📊 上傳 Dashboard 到 Grafana Cloud...'
                script {
                    // 讀取 dashboard.json 並上傳
                    def dashboardContent = readFile('dashboard.json')
                    
                    sh """
                        curl -X POST \\
                            -H "Authorization: Bearer ${GRAFANA_API_KEY}" \\
                            -H "Content-Type: application/json" \\
                            -d '${dashboardContent}' \\
                            ${GRAFANA_URL}/api/dashboards/db
                    """
                }
                echo '✅ Dashboard 上傳完成'
            }
        }
        
        stage('Verification') {
            steps {
                echo '🔍 驗證部署結果...'
                script {
                    // 檢查 dashboard 是否成功建立
                    def response = sh(
                        script: """
                            curl -s -H "Authorization: Bearer ${GRAFANA_API_KEY}" \\
                                ${GRAFANA_URL}/api/search?query=Sample%20Dashboard
                        """,
                        returnStdout: true
                    )
                    
                    if (response.contains('"title":"Sample Dashboard"')) {
                        echo '✅ Dashboard 驗證成功！'
                    } else {
                        echo '⚠️ Dashboard 驗證失敗，請檢查 Grafana Cloud'
                    }
                }
            }
        }
    }
    
    post {
        success {
            echo '🎉 部署成功！'
            echo "📊 請前往 ${GRAFANA_URL} 查看您的 Dashboard"
            
            // 可選：發送 Slack 通知
            // slackSend channel: '#devops', 
            //          color: 'good', 
            //          message: "✅ Grafana Dashboard 部署成功！\n🔗 ${GRAFANA_URL}"
        }
        
        failure {
            echo '❌ 部署失敗，請檢查日誌'
            
            // 可選：發送失敗通知
            // slackSend channel: '#devops', 
            //          color: 'danger', 
            //          message: "❌ Grafana Dashboard 部署失敗！\n請檢查 Jenkins 日誌"
        }
        
        always {
            echo '🧹 清理工作空間...'
            cleanWs()
        }
    }
}
