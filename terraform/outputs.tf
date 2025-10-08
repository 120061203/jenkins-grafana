# Terraform 輸出定義

output "dashboard_url" {
  description = "Dashboard URL"
  value       = "${var.grafana_url}/d/${grafana_dashboard.sample_dashboard.uid}"
}

output "dashboard_uid" {
  description = "Dashboard UID"
  value       = grafana_dashboard.sample_dashboard.uid
}

output "dashboard_id" {
  description = "Dashboard ID"
  value       = grafana_dashboard.sample_dashboard.id
}

output "folder_id" {
  description = "資料夾 ID"
  value       = grafana_folder.jenkins_dashboards.id
}

output "folder_url" {
  description = "資料夾 URL"
  value       = "${var.grafana_url}/dashboards/f/${grafana_folder.jenkins_dashboards.uid}"
}
