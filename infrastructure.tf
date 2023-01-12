# Прописываем инфраструктуру

data "yandex_compute_image" "ubuntu_last" {
  family = "ubuntu-2204-lts"                                                # ОС (Ubuntu 22.04 LTS)
}

data "yandex_vpc_subnet" "default" {
    name = "test2"                                                          # Одна из дефолтных подсетей
}

# Создаём ВМ, TF будет знать её по имени "yandex_compute_instance.web-1"
resource "yandex_compute_instance" "web-1" {
  name = "web-server"                                                       # Имя ВМ в облаке
  platform_id = "standard-v1"                                               # Тип процессора (Intel Broadwell)
  allow_stopping_for_update = true                                          # TF остановит ВМ и обновит хар-ки, после снова запустит её
  description = "Это тестовый Веб-сервер"                                   # Описание ВМ
  
 
resources {
    cores = 2                                                               # vCPU
    memory = 1                                                              # RAM
    core_fraction = 5                                                       # Гарантированная доля vCPU (5,20,50,100), для каждого CPU свой %
}

boot_disk {
    initialize_params {
        image_id = data.yandex_compute_image.ubuntu_last.id                 # Ubuntu 22.04 LTS прописали выше в коде
        size = 7                                                            # Размер диска в Гб
    }
}
network_interface {
    subnet_id = data.yandex_vpc_subnet.default.id                           # Id подсети прописали выше в коде
    nat = true                                                              # Автоматически установить динамический ip
    ip_address = "172.16.0.23"                                              # Назначаем локальный ip
}
metadata = {
    user-data = "${file("/home/test/terraform/cloud-terraform/user1.txt")}" # Файл с метаданными включая ключ ssh
  }
}

# Создаём ВМ, TF будет знать её по имени "yandex_compute_instance.web-1"
resource "yandex_compute_instance" "web-2" {
  name = "web-server-1"                                                     # Имя ВМ в облаке
  platform_id = "standard-v1"                                               # Тип процессора (Intel Broadwell)
  count=0
  allow_stopping_for_update = true                                          # TF остановит ВМ и обновит хар-ки>
  description = "Это тестовый Веб-сервер-1"                                 # Описание ВМ


resources {
    cores = 2                                                               # vCPU
    memory = 1                                                              # RAM
    core_fraction = 5                                                       # Гарантированная доля vCPU (5,20,>
}

boot_disk {
    initialize_params {
        image_id = data.yandex_compute_image.ubuntu_last.id                 # Ubuntu 22.04 LTS прописали выше >
        size = 7                                                            # Размер диска в Гб
    }
}
network_interface {
    subnet_id = data.yandex_vpc_subnet.default.id                           # Id подсети прописали выше в коде
    nat = true                                                              # Автоматически установить динамич>
    ip_address = "172.16.0.24"                                              # Назначаем локальный ip
}
metadata = {
    user-data = "${file("/home/test/terraform/cloud-terraform/user1.txt")}" # Файл с метаданными включая ключ >
  }
}

