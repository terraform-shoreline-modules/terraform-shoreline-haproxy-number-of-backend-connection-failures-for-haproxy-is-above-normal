resource "shoreline_notebook" "haproxy_number_of_backend_connection_failures_for_host_is_above_normal" {
  name       = "haproxy_number_of_backend_connection_failures_for_host_is_above_normal"
  data       = file("${path.module}/data/haproxy_number_of_backend_connection_failures_for_host_is_above_normal.json")
  depends_on = [shoreline_action.invoke_backend_server_check,shoreline_action.invoke_backend_status_check]
}

resource "shoreline_file" "backend_server_check" {
  name             = "backend_server_check"
  input_file       = "${path.module}/data/backend_server_check.sh"
  md5              = filemd5("${path.module}/data/backend_server_check.sh")
  description      = "The backend server is experiencing some issues or downtime, causing connection failures."
  destination_path = "/agent/scripts/backend_server_check.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "backend_status_check" {
  name             = "backend_status_check"
  input_file       = "${path.module}/data/backend_status_check.sh"
  md5              = filemd5("${path.module}/data/backend_status_check.sh")
  description      = "Verify that the backend server is running and responding correctly to requests."
  destination_path = "/agent/scripts/backend_status_check.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_backend_server_check" {
  name        = "invoke_backend_server_check"
  description = "The backend server is experiencing some issues or downtime, causing connection failures."
  command     = "`chmod +x /agent/scripts/backend_server_check.sh && /agent/scripts/backend_server_check.sh`"
  params      = ["BACKEND_SERVER_PORT","BACKEND_SERVER_IP"]
  file_deps   = ["backend_server_check"]
  enabled     = true
  depends_on  = [shoreline_file.backend_server_check]
}

resource "shoreline_action" "invoke_backend_status_check" {
  name        = "invoke_backend_status_check"
  description = "Verify that the backend server is running and responding correctly to requests."
  command     = "`chmod +x /agent/scripts/backend_status_check.sh && /agent/scripts/backend_status_check.sh`"
  params      = ["BACKEND_SERVICE_NAME","BACKEND_SERVER_URL"]
  file_deps   = ["backend_status_check"]
  enabled     = true
  depends_on  = [shoreline_file.backend_status_check]
}

