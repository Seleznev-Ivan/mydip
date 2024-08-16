terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">=0.13"

  backend "s3" {
    endpoint = "https://storage.yandexcloud.net"
    bucket   = "seleznev-netology-bucket"
    region   = "ru-central1"
    key      = "state/terraform.tfstate"    
    skip_region_validation      = true
    skip_credentials_validation = true

  }
}