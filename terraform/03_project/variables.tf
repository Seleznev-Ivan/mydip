variable "token" {
  type        = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "zone" {
  #type        = string
  default = "ru-central1-a"
  #description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

variable "zone2" {
  #type        = string
  default = "ru-central1-b"
  #description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

variable "zone3" {
  #type        = string
  default = "ru-central1-d"
  #description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

variable "platform" {
  type    = string
  default = "standard-v2"
}


variable "vm1_name" {
  type    = string
  default = "vm1"
}

variable "vm2_name" {
  type    = string
  default = "vm2"
}

variable "vm3_name" {
  type    = string
  default = "vm3"
}

variable "ssh" {
  type = map(any)
  default = {
    serial-port-enable = 1
    ssh-keys           = "ubuntu:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH2VIf95p/dXoynEMlUCEd74TM0AY/SC07/Q4iT+UzNm eddsa-key-20230830"
  }
}
