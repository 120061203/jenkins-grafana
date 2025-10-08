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

# 建立資料夾
resource "grafana_folder" "jenkins_dashboards" {
  title = var.folder_name
}

# 建立 Dashboard（在資料夾中）
resource "grafana_dashboard" "xsong_monitoring_dashboard" {
  config_json = file("${path.module}/../dashboard.json")
  folder      = grafana_folder.jenkins_dashboards.id
  overwrite   = true
  
  # 使用變數設定標籤
  tags = var.dashboard_tags
}
