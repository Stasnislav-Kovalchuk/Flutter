## IoT Flutter Lab 1 — Drive Mode Controller

Мінімальний навчальний Flutter-додаток (IoT-тема: керування режимами трансмісії позашляховика), який демонструє роботу з інтерактивним полем вводу, валідацією та динамічним оновленням UI.

### Вимоги лабораторної (чеклист)

- **Flutter проєкт**: так
- **StatefulWidget**: `DriveModeScreen`
- **Інтерактивний input**: `TextFormField`
- **Логіка по вводу**: парсинг режиму + мапінг стану трансмісії
- **Динамічний UI**: оновлення назви режиму та статусів
- **Валідація**: дозволені значення + повідомлення про помилки
- **Помилки**: показ через `TextFormField` validation message
- **Assets**: `assets/images/tire_bg.jpg` + темний overlay
- **Лінтер**: `analysis_options.yaml` (flutter_lints)
- **CI**: `.github/workflows/validation.yaml` (`flutter pub get` / `flutter analyze` / `flutter test`)

### Функціонал

- **StatefulWidget**: один головний екран `DriveModeScreen`.
- **Інтерактивне поле вводу**: `TextFormField` + кнопка `Apply`.
- **Валідація**: дозволені значення: `sand`, `mud`, `snow`, `mountain`, `2wd` (без регістру/пробілів).
- **Логіка на основі вводу**:
  - `sand` → 4x4 ON, low gear OFF, diff lock OFF
  - `mud` → 4x4 ON, low gear ON, diff lock ON
  - `snow` → 4x4 ON, low gear OFF, diff lock OFF
  - `mountain` → 4x4 ON, low gear ON, diff lock ON
  - `2wd` → усе OFF
- **Динамічний UI**: відображає назву режиму та стан 4x4 / low gear / diff lock.
- **Чистий UI**: фон `assets/images/tire_bg.jpg` + темний overlay.
- **Лінтер**: `analysis_options.yaml` на базі `flutter_lints`.
- **CI/Validation**: `.github/workflows/validation.yaml` виконує `flutter pub get`, `flutter analyze`, `flutter test`.

### Структура

```
lib/
  main.dart
  screens/
    drive_mode_screen.dart
```

### Запуск

```bash
flutter pub get
flutter analyze
flutter test
flutter run -d chrome
```
