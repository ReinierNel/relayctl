terraform {
  required_providers {
    restapi = {
      source = "Mastercard/restapi"
      version = "1.16.2"
    }
  }
}

provider "restapi" {
  uri = "http://192.168.0.3:8000"
  insecure = true
  debug =true
  write_returns_object = true
  id_attribute = "id"
}