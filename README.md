# Offroad Vehicle Monitoring


https://github.com/user-attachments/assets/4accd6a4-ed1c-4b53-ae24-2c1b9a9be0ac


Кросплатформенний застосунок на **Flutter** для симуляції IoT-моніторингу позашляховика: авторизація з безпечним зберіганням сесії, перевірка мережі та підписка на **MQTT** для відображення температури двигуна (дані можна публікувати вручну через Mosquitto).

---

## Можливості

| Область | Опис |
|--------|------|
| **Авторизація** | Реєстрація, логін, автологін за збереженою сесією, вихід з підтвердженням у діалозі |
| **Сесія** | Токен у **Keychain** (`flutter_secure_storage`) з резервом у `SharedPreferences` на iOS, якщо Keychain недоступний |
| **Мережа** | Перевірка перед логіном/реєстрацією; після входу — сповіщення про втрату/відновлення з’єднання |
| **Автологін офлайн** | Доступ за збереженою сесією без Інтернету з попередженням; MQTT у цьому режимі обмежений |
| **MQTT** | Підключення до локального **Mosquitto** або публічного **HiveMQ**; топік `vehicle/motor/temperature` |
| **UI** | Темна тема, панель режимів руху, профіль користувача |

---

## Стек

- **Flutter** (Dart SDK ≥ 3.0)
- **provider** — стан і DI репозиторія
- **flutter_secure_storage** — токен сесії
- **shared_preferences** — профіль, пароль (локальна демо-авторизація), резерв токена
- **connectivity_plus** — наявність мережі
- **mqtt_client** — клієнт MQTT поверх TCP

---

## Вимоги

- [Flutter SDK](https://docs.flutter.dev/get-started/install) у стабільному каналі
- Для **iOS**: Xcode, симулятор або пристрій; для підпису — Apple ID (**Personal Team** достатньо)
- Для **MQTT на ПК**: [Eclipse Mosquitto](https://mosquitto.org/) (або інший брокер на порту `1883`)

---

## Швидкий старт

```bash
git clone <url-репозиторію>
cd <корінь-проєкту>   # тека з pubspec.yaml
flutter pub get
flutter analyze   # має пройти без зауважень
```

Запуск:

```bash
flutter run -d macos      # зручно для локального Mosquitto (127.0.0.1)
flutter run -d chrome
flutter run -d <ios-device-id>
```

Список пристроїв: `flutter devices`.

---

## MQTT: локальний брокер і ручна публікація

У [`lib/core/services/mqtt_sensor_controller.dart`](lib/core/services/mqtt_sensor_controller.dart):

- **`useLocalMosquitto`** — `true`: хост з [`mqtt_loopback_host`](lib/core/services/mqtt_loopback_host.dart) (`127.0.0.1` на macOS/iOS-симулятор, `10.0.2.2` на **Android-емуляторі**)
- **`useLocalMosquitto`** — `false`: `broker.hivemq.com`
- **Топік за замовчуванням:** `vehicle/motor/temperature`

Термінал (брокер на тій самій машині, що й Mosquitto):

```bash
mosquitto -v
```

Публікація температури (приклад):

```bash
mosquitto_pub -h localhost -t vehicle/motor/temperature -m "88.5"
```

На **Android-емуляторі** замість `localhost` у команді публікації з хоста часто використовують IP вашого ПК у LAN або налаштовують проброс; клієнт у застосунку вже звертається на `10.0.2.2`.

У застосунку: вкладка **Панель** → **Підключити** (потрібна мережа для сценарію «логін з Інтернетом»).

---

## Платформи: підпис і Keychain

### iOS

1. Відкрити `ios/Runner.xcworkspace` у Xcode  
2. **Runner** → **Signing & Capabilities** → **Automatically manage signing** + **Team**  
3. Файл [`ios/Runner/Runner.entitlements`](ios/Runner/Runner.entitlements) містить **Keychain Access Groups**

Якщо з’являється помилка **-34018**, після вибору Team зазвичай достатньо `flutter clean` і повторного запуску. У коді є **fallback** токена в `SharedPreferences`, щоб реєстрація не блокувалась на симуляторі без коректного Keychain.

### macOS

Для зручної локальної розробки **App Sandbox вимкнено** в entitlements (деталі в `macos/Runner/*.entitlements`), щоб збірка й `flutter_secure_storage` працювали без обов’язкового **Development Team**. Для розповсюдження через Mac App Store знадобиться повернути sandbox і налаштувати підпис окремо.

---

## Структура `lib/`

```
lib/
├── main.dart                 # Provider, bootstrap автологіну
├── core/
│   ├── entities/             # User
│   ├── repositories/         # AuthRepository
│   └── services/             # ConnectivityNotifier, MQTT, loopback host
├── data/storage/             # LocalAuthRepository
├── features/
│   ├── auth/presentation/    # Логін, реєстрація
│   ├── home/                 # Навігація, слухач мережі
│   └── profile/              # Профіль, вихід з діалогом
├── screens/                  # Dashboard (режими + MQTT-картка)
├── theme/, widgets/
```

---

## Лінтер

У проєкті підключено **flutter_lints**. Перевірка:

```bash
flutter analyze
```

---

## Навчальний контекст

Проєкт відповідає вимогам лабораторної з тем: **async/await**, **Stream** (мережа, MQTT), **Provider**, **плагіни** (MQTT, connectivity, secure storage), сценарії **логін / автологін / офлайн / вихід**.

---

## Ліцензія

Навчальний проєкт; уточніть умови з викладачем або власником репозиторію.
