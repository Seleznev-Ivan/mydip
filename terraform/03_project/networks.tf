resource "yandex_vpc_network" "network-1" {
  name = "network-1"
}

resource "yandex_vpc_subnet" "public-subnet-1" {
  name           = "subnet1"
  v4_cidr_blocks = ["192.168.1.0/24"]
  zone           = var.zone
  network_id     = yandex_vpc_network.network-1.id
}

resource "yandex_vpc_subnet" "public-subnet-2" {
  name           = "subnet2"
  v4_cidr_blocks = ["192.168.2.0/24"]
  zone           = var.zone2
  network_id     = yandex_vpc_network.network-1.id
}

resource "yandex_vpc_subnet" "public-subnet-3" {
  name           = "subnet3"
  v4_cidr_blocks = ["192.168.3.0/24"]
  zone           = var.zone3
  network_id     = yandex_vpc_network.network-1.id
}
