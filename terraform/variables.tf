# Terraform 變數定義

variable "grafana_url" {
  description = "Grafana Cloud URL"
  type        = string
  default     = "https://your-instance.grafana.net"
}

variable "grafana_api_key" {
  description = "Grafana API Key"
  type        = string
  sensitive   = true
}

variable "dashboard_title" {
  description = "Dashboard 標題"
  type        = string
  default     = "xsong.us 網站監控 Dashboard"
}

variable "dashboard_tags" {
  description = "Dashboard 標籤"
  type        = list(string)
  default     = ["xsong.us", "website", "monitoring", "traffic", "performance"]
}

variable "folder_name" {
  description = "Dashboard 資料夾名稱"
  type        = string
  default     = "Jenkins Dashboards"
}
