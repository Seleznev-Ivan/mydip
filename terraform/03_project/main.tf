
resource "yandex_compute_instance" "vm-1" {
  name                      = var.vm1_name
  platform_id               = var.platform
  zone                      = var.zone
  allow_stopping_for_update = true

  resources {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id    = "fd80qjt4v3h9ukucg1di" #ubuntu
      description = "ubuntu-2004-lts"
      size        = 17
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.public-subnet-1.id
    nat       = true
  }

  metadata = var.ssh
}


resource "yandex_compute_instance" "vm-2" {
  name                      = var.vm2_name
  platform_id               = var.platform
  zone                      = var.zone2
  allow_stopping_for_update = true

  resources {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }


  boot_disk {
    initialize_params {
      image_id    = "fd80qjt4v3h9ukucg1di" #ubuntu
      description = "ubuntu-2004-lts"
      size        = 10
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.public-subnet-2.id
    nat       = true
  }

  metadata = var.ssh
}

resource "yandex_compute_instance" "vm-3" {
  name                      = var.vm3_name
  platform_id               = var.platform
  zone                      = var.zone3
  allow_stopping_for_update = true

  resources {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }


  boot_disk {
    initialize_params {
      image_id    = "fd80qjt4v3h9ukucg1di" #ubuntu
      description = "ubuntu-2004-lts"
      size        = 10
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.public-subnet-3.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

