terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    endpoint                    = "https://storage.yandexcloud.net"
    bucket                      = "seleznev-netology-bucket"
    region                      = "ru-central1"
    key                         = "state/terraform.tfstate"
    skip_region_validation      = true
    skip_credentials_validation = true
    access_key                  = "YCA***"
    secret_key                  = "YCN***"
  }
}

