# Terraform 設定檔 - Grafana Cloud Dashboard 管理
terraform {
  required_version = ">= 1.0"
  required_providers {
    grafana = {
      source  = "grafana/grafana"
      version = "~> 2.0"
    }
  }
}

# 設定 Grafana Provider
provider "grafana" {
  url  = var.grafana_url
  auth = var.grafana_api_key
}

# 建立 Dashboard
resource "grafana_dashboard" "sample_dashboard" {
  config_json = file("${path.module}/../dashboard.json")
  
  # 設定 Dashboard 屬性
  overwrite = true
  
  # 標籤
  tags = ["jenkins", "automation", "terraform"]
}

# 建立資料夾（可選）
resource "grafana_folder" "jenkins_dashboards" {
  title = "Jenkins Dashboards"
}

# 將 Dashboard 移動到指定資料夾
resource "grafana_dashboard" "sample_dashboard_in_folder" {
  config_json = file("${path.module}/../dashboard.json")
  folder      = grafana_folder.jenkins_dashboards.id
  overwrite   = true
  
  tags = ["jenkins", "automation", "terraform", "folder"]
}
