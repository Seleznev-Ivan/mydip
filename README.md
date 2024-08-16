# Дипломный практикум в Yandex.Cloud
  * [Цели:](#цели)
  * [Этапы выполнения:](#этапы-выполнения)
     * [Создание облачной инфраструктуры](#создание-облачной-инфраструктуры)
     * [Создание Kubernetes кластера](#создание-kubernetes-кластера)
     * [Создание тестового приложения](#создание-тестового-приложения)
     * [Подготовка cистемы мониторинга и деплой приложения](#подготовка-cистемы-мониторинга-и-деплой-приложения)
     * [Установка и настройка CI/CD](#установка-и-настройка-cicd)
  * [Что необходимо для сдачи задания?](#что-необходимо-для-сдачи-задания)
  * [Как правильно задавать вопросы дипломному руководителю?](#как-правильно-задавать-вопросы-дипломному-руководителю)

**Перед началом работы над дипломным заданием изучите [Инструкция по экономии облачных ресурсов](https://github.com/netology-code/devops-materials/blob/master/cloudwork.MD).**

---
## Цели:

1. Подготовить облачную инфраструктуру на базе облачного провайдера Яндекс.Облако.
2. Запустить и сконфигурировать Kubernetes кластер.
3. Установить и настроить систему мониторинга.
4. Настроить и автоматизировать сборку тестового приложения с использованием Docker-контейнеров.
5. Настроить CI для автоматической сборки и тестирования.
6. Настроить CD для автоматического развёртывания приложения.

---
## Этапы выполнения:


### Создание облачной инфраструктуры

Для начала необходимо подготовить облачную инфраструктуру в ЯО при помощи [Terraform](https://www.terraform.io/).

Особенности выполнения:

- Бюджет купона ограничен, что следует иметь в виду при проектировании инфраструктуры и использовании ресурсов;
Для облачного k8s используйте региональный мастер(неотказоустойчивый). Для self-hosted k8s минимизируйте ресурсы ВМ и долю ЦПУ. В обоих вариантах используйте прерываемые ВМ для worker nodes.

Предварительная подготовка к установке и запуску Kubernetes кластера.

1. Создайте сервисный аккаунт, который будет в дальнейшем использоваться Terraform для работы с инфраструктурой с необходимыми и достаточными правами. Не стоит использовать права суперпользователя
2. Подготовьте [backend](https://www.terraform.io/docs/language/settings/backends/index.html) для Terraform:  
   а. Рекомендуемый вариант: S3 bucket в созданном ЯО аккаунте(создание бакета через TF)
   б. Альтернативный вариант:  [Terraform Cloud](https://app.terraform.io/)  
3. Создайте VPC с подсетями в разных зонах доступности.
4. Убедитесь, что теперь вы можете выполнить команды `terraform destroy` и `terraform apply` без дополнительных ручных действий.
5. В случае использования [Terraform Cloud](https://app.terraform.io/) в качестве [backend](https://www.terraform.io/docs/language/settings/backends/index.html) убедитесь, что применение изменений успешно проходит, используя web-интерфейс Terraform cloud.

Ожидаемые результаты:

1. Terraform сконфигурирован и создание инфраструктуры посредством Terraform возможно без дополнительных ручных действий.
2. Полученная конфигурация инфраструктуры является предварительной, поэтому в ходе дальнейшего выполнения задания возможны изменения.


## Решение

В Yandex.Cloud создаю отдельный каталог diplom, в котором буду подготавливать облачную инфраструктуру:

![diplom-001](https://github.com/Seleznev-Ivan/devops-netology/blob/main/img/diplom-001.jpg)

При помощи Terraform предварительно подготавливаю сервисный аккаунт:

![diplom-002](https://github.com/Seleznev-Ivan/devops-netology/blob/main/img/diplom-002.jpg)

Подготавливаю S3 bucket и настраиваю хранение tfstate в созданном S3 bucket через Terraform: 

![diplom-003](https://github.com/Seleznev-Ivan/devops-netology/blob/main/img/diplom-003.jpg)

Создаю VPC с подсетями в разных зонах доступности:

![diplom-004](https://github.com/Seleznev-Ivan/devops-netology/blob/main/img/diplom-004.jpg)

---
### Создание Kubernetes кластера

На этом этапе необходимо создать [Kubernetes](https://kubernetes.io/ru/docs/concepts/overview/what-is-kubernetes/) кластер на базе предварительно созданной инфраструктуры.   Требуется обеспечить доступ к ресурсам из Интернета.

Это можно сделать двумя способами:

1. Рекомендуемый вариант: самостоятельная установка Kubernetes кластера.  
   а. При помощи Terraform подготовить как минимум 3 виртуальных машины Compute Cloud для создания Kubernetes-кластера. Тип виртуальной машины следует выбрать самостоятельно с учётом требовании к производительности и стоимости. Если в дальнейшем поймете, что необходимо сменить тип инстанса, используйте Terraform для внесения изменений.  
   б. Подготовить [ansible](https://www.ansible.com/) конфигурации, можно воспользоваться, например [Kubespray](https://kubernetes.io/docs/setup/production-environment/tools/kubespray/)  
   в. Задеплоить Kubernetes на подготовленные ранее инстансы, в случае нехватки каких-либо ресурсов вы всегда можете создать их при помощи Terraform.
2. Альтернативный вариант: воспользуйтесь сервисом [Yandex Managed Service for Kubernetes](https://cloud.yandex.ru/services/managed-kubernetes)  
  а. С помощью terraform resource для [kubernetes](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/kubernetes_cluster) создать **региональный** мастер kubernetes с размещением нод в разных 3 подсетях      
  б. С помощью terraform resource для [kubernetes node group](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/kubernetes_node_group)
  
Ожидаемый результат:

1. Работоспособный Kubernetes кластер.
2. В файле `~/.kube/config` находятся данные для доступа к кластеру.
3. Команда `kubectl get pods --all-namespaces` отрабатывает без ошибок.

## Решение

Подготовил 3 виртуальные машины Compute Cloud для создания Kubernetes-кластера при помощи Terraform. 

![diplom-005](https://github.com/Seleznev-Ivan/devops-netology/blob/main/img/diplom-005.jpg)

Для разворачивания Kubernetes-кластера я использовал Kubespray. Результат выполнения:

![diplom-006](https://github.com/Seleznev-Ivan/devops-netology/blob/main/img/diplom-006.jpg)

Список нод в кластере:

![diplom-007](https://github.com/Seleznev-Ivan/devops-netology/blob/main/img/diplom-007.jpg)

Данные для доступа к кластеру в файле ```~/.kube/config```:

![diplom-008](https://github.com/Seleznev-Ivan/devops-netology/blob/main/img/diplom-008.jpg)

Команда ```kubectl get pods --all-namespaces``` отрабатывает без ошибок:

![diplom-009](https://github.com/Seleznev-Ivan/devops-netology/blob/main/img/diplom-009.jpg)

---
### Создание тестового приложения

Для перехода к следующему этапу необходимо подготовить тестовое приложение, эмулирующее основное приложение разрабатываемое вашей компанией.

Способ подготовки:

1. Рекомендуемый вариант:  
   а. Создайте отдельный git репозиторий с простым nginx конфигом, который будет отдавать статические данные.  
   б. Подготовьте Dockerfile для создания образа приложения.  
2. Альтернативный вариант:  
   а. Используйте любой другой код, главное, чтобы был самостоятельно создан Dockerfile.

Ожидаемый результат:

1. Git репозиторий с тестовым приложением и Dockerfile.
2. Регистри с собранным docker image. В качестве регистри может быть DockerHub или [Yandex Container Registry](https://cloud.yandex.ru/services/container-registry), созданный также с помощью terraform.


## Решение

Создаю nginx конфиг:

![diplom-010](https://github.com/Seleznev-Ivan/devops-netology/blob/main/img/diplom-010.jpg)

Создаю Dockerfile моего приложения:

![diplom-011](https://github.com/Seleznev-Ivan/devops-netology/blob/main/img/diplom-011.jpg)

Собираю образ приложения:

![diplom-012](https://github.com/Seleznev-Ivan/devops-netology/blob/main/img/diplom-012.jpg)

Проверяю список образов:

![diplom-013](https://github.com/Seleznev-Ivan/devops-netology/blob/main/img/diplom-013.jpg)

Запускаю и проверяю работу приложения в браузере. Приложение успешно открывается:

![diplom-014](https://github.com/Seleznev-Ivan/devops-netology/blob/main/img/diplom-014.jpg)

Отправляю свой собранный образ в регистри на DockerHub:

![diplom-015](https://github.com/Seleznev-Ivan/devops-netology/blob/main/img/diplom-015.jpg)

Git репозиторий с тестовым приложением и Dockerfile: https://github.com/Seleznev-Ivan/netology-app/

Регистри с собранным docker image на DockerHub: https://hub.docker.com/repository/docker/vanchester/diplom-nginx/

---
### Подготовка cистемы мониторинга и деплой приложения

Уже должны быть готовы конфигурации для автоматического создания облачной инфраструктуры и поднятия Kubernetes кластера.  
Теперь необходимо подготовить конфигурационные файлы для настройки нашего Kubernetes кластера.

Цель:
1. Задеплоить в кластер [prometheus](https://prometheus.io/), [grafana](https://grafana.com/), [alertmanager](https://github.com/prometheus/alertmanager), [экспортер](https://github.com/prometheus/node_exporter) основных метрик Kubernetes.
2. Задеплоить тестовое приложение, например, [nginx](https://www.nginx.com/) сервер отдающий статическую страницу.

Способ выполнения:
1. Воспользоваться пакетом [kube-prometheus](https://github.com/prometheus-operator/kube-prometheus), который уже включает в себя [Kubernetes оператор](https://operatorhub.io/) для [grafana](https://grafana.com/), [prometheus](https://prometheus.io/), [alertmanager](https://github.com/prometheus/alertmanager) и [node_exporter](https://github.com/prometheus/node_exporter). Альтернативный вариант - использовать набор helm чартов от [bitnami](https://github.com/bitnami/charts/tree/main/bitnami).

2. Если на первом этапе вы не воспользовались [Terraform Cloud](https://app.terraform.io/), то задеплойте и настройте в кластере [atlantis](https://www.runatlantis.io/) для отслеживания изменений инфраструктуры. Альтернативный вариант 3 задания: вместо Terraform Cloud или atlantis настройте на автоматический запуск и применение конфигурации terraform из вашего git-репозитория в выбранной вами CI-CD системе при любом комите в main ветку. Предоставьте скриншоты работы пайплайна из CI/CD системы.

Ожидаемый результат:
1. Git репозиторий с конфигурационными файлами для настройки Kubernetes.
2. Http доступ к web интерфейсу grafana.
3. Дашборды в grafana отображающие состояние Kubernetes кластера.
4. Http доступ к тестовому приложению.


## Решение

Разворачиваю пакет kube-prometheus при помощи набора helm чартов:

![diplom-016](https://github.com/Seleznev-Ivan/devops-netology/blob/main/img/diplom-016.jpg)

Проверяю, что всё успешно запустилось:

![diplom-017](https://github.com/Seleznev-Ivan/devops-netology/blob/main/img/diplom-017.jpg)

Чтобы проверить работы Grafana выполняю проброс порта:

![diplom-018](https://github.com/Seleznev-Ivan/devops-netology/blob/main/img/diplom-018.jpg)

Для проверяю Grafana запускаю браузер и открываю дашборд с кластером Kubernetes:

![diplom-019](https://github.com/Seleznev-Ivan/devops-netology/blob/main/img/diplom-019.jpg)

Создаю и запускаю своё приложение в Kubernetes при помощи Helm:

![diplom-020](https://github.com/Seleznev-Ivan/devops-netology/blob/main/img/diplom-020.jpg)

Проверяю http-доступ к моему приложению в браузере:

![diplom-021](https://github.com/Seleznev-Ivan/devops-netology/blob/main/img/diplom-021.jpg)

---
### Установка и настройка CI/CD

Осталось настроить ci/cd систему для автоматической сборки docker image и деплоя приложения при изменении кода.

Цель:

1. Автоматическая сборка docker образа при коммите в репозиторий с тестовым приложением.
2. Автоматический деплой нового docker образа.

Можно использовать [teamcity](https://www.jetbrains.com/ru-ru/teamcity/), [jenkins](https://www.jenkins.io/), [GitLab CI](https://about.gitlab.com/stages-devops-lifecycle/continuous-integration/) или GitHub Actions.

Ожидаемый результат:

1. Интерфейс ci/cd сервиса доступен по http.
2. При любом коммите в репозиторие с тестовым приложением происходит сборка и отправка в регистр Docker образа.
3. При создании тега (например, v1.0.0) происходит сборка и отправка с соответствующим label в регистри, а также деплой соответствующего Docker образа в кластер Kubernetes.


## Решение

В качестве ci/cd системы буду использовать GitLab CI.

Создаю новый проект:

![diplom-022](https://github.com/Seleznev-Ivan/devops-netology/blob/main/img/diplom-022.jpg)

Регистрирую Gitlab agent для Kubernetes:

![diplom-023](https://github.com/Seleznev-Ivan/devops-netology/blob/main/img/diplom-023.jpg)

Проверяю, что агент успешно подключился:

![diplom-024](https://github.com/Seleznev-Ivan/devops-netology/blob/main/img/diplom-024.jpg)

Разворачиваю Gitlab Runner в кластере Kubernetes:

![diplom-025](https://github.com/Seleznev-Ivan/devops-netology/blob/main/img/diplom-025.jpg)

Проверяю Runner на Gitlab:

![diplom-026](https://github.com/Seleznev-Ivan/devops-netology/blob/main/img/diplom-026.jpg)

Для отправки собранного образа в регистр dockerhub использую переменные:

![diplom-027](https://github.com/Seleznev-Ivan/devops-netology/blob/main/img/diplom-027.jpg)

Мой пайплайн сборки и деплоя приложения:

![diplom-028](https://github.com/Seleznev-Ivan/devops-netology/blob/main/img/diplom-028.jpg)

Создаю тег в репозитории с тестовым приложением:

![diplom-029](https://github.com/Seleznev-Ivan/devops-netology/blob/main/img/diplom-029.jpg)

Происходит сборка и отправка в регистр dockerhub:

![diplom-030](https://github.com/Seleznev-Ivan/devops-netology/blob/main/img/diplom-030.jpg)

Образы приложения на dockerhub:

![diplom-031](https://github.com/Seleznev-Ivan/devops-netology/blob/main/img/diplom-031.jpg)

Приложение деплоится в кластере Kubernetes:

![diplom-032](https://github.com/Seleznev-Ivan/devops-netology/blob/main/img/diplom-032.jpg)

Проверяю доступность в браузере:

![diplom-033](https://github.com/Seleznev-Ivan/devops-netology/blob/main/img/diplom-033.jpg)

Проверка всех подов, деплоя, сервисов в кластере Kubernetes:

![diplom-034](https://github.com/Seleznev-Ivan/devops-netology/blob/main/img/diplom-034.jpg)

---
## Что необходимо для сдачи задания?

1. Репозиторий с конфигурационными файлами Terraform и готовность продемонстрировать создание всех ресурсов с нуля.
2. Пример pull request с комментариями созданными atlantis'ом или снимки экрана из Terraform Cloud или вашего CI-CD-terraform pipeline.
3. Репозиторий с конфигурацией ansible, если был выбран способ создания Kubernetes кластера при помощи ansible.
4. Репозиторий с Dockerfile тестового приложения и ссылка на собранный docker image.
5. Репозиторий с конфигурацией Kubernetes кластера.
6. Ссылка на тестовое приложение и веб интерфейс Grafana с данными доступа.
7. Все репозитории рекомендуется хранить на одном ресурсе (github, gitlab)
