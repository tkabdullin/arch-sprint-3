
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

### Плюсы и минусы решения AS-IS
<B><I>Плюсы</I></B>
 - Архитектура проста в понимании и реализации
 - Архитектура предоставляет надежность и предсказуемость поведения системы
 - Архитектура не требует специализированных навыков для обслуживания

<B><I>Минусы</I></B>
 - Нет асинхронных вызовов для синхронизации состояний
 - Отсутствует возможность подключения датчиков самими пользователями
 - Архитектура обеспечивает только управление отоплением и снимание показаний температуры в доме, что сильно ограничивает и усложняет возможность расширения функциональных возможностей
 - Расширение возможно только вертикальное, так как горизонтальное масштабирование потребует отдельных ресурсов для переписывания монолита

### Домены и границы контекстов
Ввиду отсутствия явно прописанных бизнес-требований текущего монолитного решения были выявлены следующие домены:
 - Домен "Управление отоплением"
   - Сабдомен "Система отопления"
   - Сабдомен "Система температурных датчиков" 

Данные домены с сабдоменами были выделены на основе функциональности, которая была предоставлена в скриптах самого монолитного приложения.

#### Визуальное представление доменов
![Домены](diagrams/initial-domens-diagram/initial-domens-diagram.png)

### C4 контекстная модель архитектуры монолитного приложения
![Границы контекстов](diagrams/monolitic-c4-context-diagram/monolitic-c4-context-diagram.png)

## Задание 1.2: Архитектура микросервисов
Целевую архитектуру нового приложения для покрытия бизнес-требований было решено реализовывать на микросервисной архитектуре для лучшего потенциального горизонтального масштабирования нагруженной части приложения и будущего улучшения функциональных возможностей приложения без необходимости высчитывать и исправлять внутренние зависимости.

С целью ускорения разработки и устранения синхронизационных проблем было решено оставить текущий стек без изменений.

По результатам проведенного DDD подхода для основного домена системы были выделены 3 микросервиса, которые покрывают бизнес-требования, а именно:
 - Микросервис "Управление пользователями"
 - Микросервис "Телеметрия"
 - Микросервис "Управление устройствами"

Дополнительно во время проектирование было обращено внимание на то, что к реализации микрсервиса "Телеметрия" потребуется применить подход CQRS ля разделения потоков данных на чтение и запись с датчиков в БД.

Итого выделяется подход к архитектуре, представленный в таблице и картинке ниже
|Наименование сервиса/системы|Описание|
|---|---|
|API Gateway|Основной инструмент распределения запросов между необходимыми микросервисами. Подразумевается реализация на open-source решении Kong|
|Микросервис "Управление пользователями"|Отвечает за регистрацию и управления пользователями|
|Микросервис "Телеметрия"|Отвечает за чтение данных с устройств для предоставления данных пользователям. Должен быть разработан с использованием паттерна CQRS|
|Микросервис "Управление устройствами"|Отвечает за регистрацию и управление устройствами|

### Диаграмма контейнеров для микросервисной архитектуры на этап MVP
![Диаграмма контейнеров MVP](diagrams/С4_Container_microservice-arch/С4_Container_microservice-arch.png)

### Диаграмма контейнеров для микросервисной архитектуры TO BE
![Диаграмма контейнеров TO BE](diagrams/С4_Container_microservice-arch-tobe/С4_Container_microservice-arch-tobe.png)

### Диаграмма компонентов
![Диаграмма компонентов TO BE](diagrams/С4_Component_microservice-arch/С4_Component_microservice-arch.png)

### Диаграмма кода
![Диаграмма кода](diagrams/C4_Code_microservice-arch/C4_Code_microservice-arch.png)

## Задание 1.3: ER-диаграмма
![ER-диаграмма](diagrams/ER_microservice-arch/ER_microservice-arch.png)

## Задание 1.4: Создание и документирование API
Смоделированное API представлено в файле [api.yaml](/api.yaml)

# Задание 2.1: Разработка MVP. Новые микросервисы и интеграция с монолитом

## Инструкция для поднятия микросервисов

### Установить PostgreSQL
[Инструкция по установке](https://www.postgresql.org/docs/)

### Поднять микросервисы на Docker Compose

```
docker compose up -d
```

### Проверка API
Выполнить последовательно следующие запросы:

#### Создание пользователя
```curl
curl --location 'http://localhost:8081/api/v1/users/1' \
--header 'Content-Type: application/json' \
--data-raw '{
    "email": "test-user-1@test.com"
}'
```

#### Проверка создания пользователя
```curl
curl --location 'http://localhost:8081/api/v1/users/1'
```

#### Создание дома
```curl
curl --location 'http://localhost:8081/api/v1/users/houses' \
--header 'Content-Type: application/json' \
--data '{
    "userId": 1,
    "address": "test-address-1"
}'
```

#### Проверка созданного дома
```curl
curl --location 'http://localhost:8081/api/v1/users/1/houses/1'
```

#### Добавление девайса
```curl
curl --location 'http://localhost:8082/api/v1/devices' \
--header 'Content-Type: application/json' \
--data '{
    "userId": 1,
    "houseId": 1,
    "deviceType": "test-device-type-1",
    "name": "test-name-1",
    "serialNumber": "test-serial-number-1"
}'
```

#### Проверка созданного девайса
```curl
curl --location 'http://localhost:8082/api/v1/devices/1'
```

<!-- Апдейт ридмифайла для прогрузки диаграмм -->

[//]: # ()
[//]: # ()
[//]: # (---------------------------------------)

[//]: # (OUTDATED)

[//]: # ()
[//]: # ()
[//]: # (# Базовая настройка)

[//]: # ()
[//]: # (## Запуск minikube)

[//]: # ()
[//]: # ([Инструкция по установке]&#40;https://minikube.sigs.k8s.io/docs/start/&#41;)

[//]: # ()
[//]: # (```bash)

[//]: # (minikube start)

[//]: # (```)

[//]: # ()
[//]: # ()
[//]: # (## Добавление токена авторизации GitHub)

[//]: # ()
[//]: # ([Получение токена]&#40;https://github.com/settings/tokens/new&#41;)

[//]: # ()
[//]: # (```bash)

[//]: # (kubectl create secret docker-registry ghcr --docker-server=https://ghcr.io --docker-username=<github_username> --docker-password=<github_token> -n default)

[//]: # (```)

[//]: # ()
[//]: # ()
[//]: # (## Установка API GW kusk)

[//]: # ()
[//]: # ([Install Kusk CLI]&#40;https://docs.kusk.io/getting-started/install-kusk-cli&#41;)

[//]: # ()
[//]: # (```bash)

[//]: # (kusk cluster install)

[//]: # (```)

[//]: # ()
[//]: # ()
[//]: # (## Настройка terraform)

[//]: # ()
[//]: # ([Установите Terraform]&#40;https://yandex.cloud/ru/docs/tutorials/infrastructure-management/terraform-quickstart#install-terraform&#41;)

[//]: # ()
[//]: # ()
[//]: # (Создайте файл ~/.terraformrc)

[//]: # ()
[//]: # (```hcl)

[//]: # (provider_installation {)

[//]: # (  network_mirror {)

[//]: # (    url = "https://terraform-mirror.yandexcloud.net/")

[//]: # (    include = ["registry.terraform.io/*/*"])

[//]: # (  })

[//]: # (  direct {)

[//]: # (    exclude = ["registry.terraform.io/*/*"])

[//]: # (  })

[//]: # (})

[//]: # (```)

[//]: # ()
[//]: # (## Применяем terraform конфигурацию )

[//]: # ()
[//]: # (```bash)

[//]: # (cd terraform)

[//]: # (terraform apply)

[//]: # (```)

[//]: # ()
[//]: # (## Настройка API GW)

[//]: # ()
[//]: # (```bash)

[//]: # (kusk deploy -i api.yaml)

[//]: # (```)

[//]: # ()
[//]: # (## Проверяем работоспособность)

[//]: # ()
[//]: # (```bash)

[//]: # (kubectl port-forward svc/kusk-gateway-envoy-fleet -n kusk-system 8080:80)

[//]: # (curl localhost:8080/hello)

[//]: # (```)

[//]: # ()
[//]: # ()
[//]: # (## Delete minikube)

[//]: # ()
[//]: # (```bash)

[//]: # (minikube delete)

[//]: # (```)
