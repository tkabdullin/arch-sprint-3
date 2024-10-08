
# Спринт 3

## Задание 1.1: Анализ и планирование

### Набор функциональных возможностей текущего монолитного приложения
#### Управление отоплением
1. Пользователи могут удалённо включать/выключать отопление в своих домах.
2. Пользователи могут устанавливать желаемую температуру.
3. Система автоматически поддерживает заданную температуру, регулируя подачу тепла.

#### Мониторинг температуры
1. Система получает данные о температуре с датчиков, установленных в домах.
2. Пользователи могут просматривать текущую температуру в своих домах через веб-интерфейс.

### Архитектура монолитного приложения
 - Язык программирования: Java
 - База данных: PostgreSQL
 - Архитектура: Монолитная, все компоненты системы (обработка запросов, бизнес-логика, работа с данными) находятся в рамках одного приложения.
 - Взаимодействие: Синхронное, запросы обрабатываются последовательно.
 - Масштабируемость: Ограничена, так как монолит сложно масштабировать по частям.
 - Развертывание: Требует остановки всего приложения.

### Домены и границы контекстов
Ввиду отсутствия явно прописанных бизнес-требований текущего монолитного решения были выявлены следующие домены:
 - Домен "Управление отоплением"
   - Сабдомен "Система отопления"
   - Сабдомен "Система температурных датчиков" 

Данные домены с сабдоменами были выделены на основе функциональности, которая была предоставлена в скриптах самого монолитного приложения.

#### Визуальное представление доменов
![Домены](diagrams/initial-domens-diagram.svg)

### C4 контекстная модель архитектуры монолитного приложения
![Границы контекстов](diagrams/monolitic-c4-context-diagram.png)


## Задание 1.2: Архитектура микросервисов

### Диаграмма контейнеров
![Диаграмма контейнеров](diagrams/С4_Container_microservice-arch.png)

### Диаграмма компонентов
![Диаграмма компонентов](diagrams/С4_Component_microservice-arch.png)

### Диаграмма кода
![Диаграмма кода](diagrams/C4_Code_microservice-arch.png)

## Задание 1.3: ER-диаграмма
![ER-диаграмма](diagrams/ER_microservice-arch.png)

## Задание 1.4: Создание и документирование API
Смоделированное API представлено в файле [api.yaml](/api.yaml)

---------------------------------------
OUTDATED


# Базовая настройка

## Запуск minikube

[Инструкция по установке](https://minikube.sigs.k8s.io/docs/start/)

```bash
minikube start
```


## Добавление токена авторизации GitHub

[Получение токена](https://github.com/settings/tokens/new)

```bash
kubectl create secret docker-registry ghcr --docker-server=https://ghcr.io --docker-username=<github_username> --docker-password=<github_token> -n default
```


## Установка API GW kusk

[Install Kusk CLI](https://docs.kusk.io/getting-started/install-kusk-cli)

```bash
kusk cluster install
```


## Настройка terraform

[Установите Terraform](https://yandex.cloud/ru/docs/tutorials/infrastructure-management/terraform-quickstart#install-terraform)


Создайте файл ~/.terraformrc

```hcl
provider_installation {
  network_mirror {
    url = "https://terraform-mirror.yandexcloud.net/"
    include = ["registry.terraform.io/*/*"]
  }
  direct {
    exclude = ["registry.terraform.io/*/*"]
  }
}
```

## Применяем terraform конфигурацию 

```bash
cd terraform
terraform apply
```

## Настройка API GW

```bash
kusk deploy -i api.yaml
```

## Проверяем работоспособность

```bash
kubectl port-forward svc/kusk-gateway-envoy-fleet -n kusk-system 8080:80
curl localhost:8080/hello
```


## Delete minikube

```bash
minikube delete
```
