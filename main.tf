terraform {
  required_version = ">= 0.13.1"

  required_providers {
    shoreline = {
      source  = "shorelinesoftware/shoreline"
      version = ">= 1.11.0"
    }
  }
}

provider "shoreline" {
  retries = 2
  debug = true
}

module "haproxy_number_of_backend_connection_failures_for_host_is_above_normal" {
  source    = "./modules/haproxy_number_of_backend_connection_failures_for_host_is_above_normal"

  providers = {
    shoreline = shoreline
  }
}