resource "yandex_iam_service_account" "sa" {
  folder_id = var.folder_id
  name      = "bucket-sa"
}

resource "yandex_resourcemanager_folder_iam_member" "sa-editor" {
  folder_id = var.folder_id
  role      = "storage.editor"
  member    = "serviceAccount:${yandex_iam_service_account.sa.id}"
  #depends_on = [yandex_iam_service_account.sa]
}

resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = yandex_iam_service_account.sa.id
  description        = "static access key for object storage"
}

resource "yandex_storage_bucket" "mybucket" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket     = "seleznev-netology-bucket"
  #acl        = "public-read"
  max_size      = 209715200
  force_destroy = true
}
