## Offroad Vehicle Monitoring System

Короткий навчальний Flutter‑додаток для IoT‑курсу, який реалізує вимоги лабораторних №1–3.

### Функціонал

- **IoT‑панель (Lab 1/2)**: екран `Dashboard` з вводом режиму руху (`sand/mud/snow/mountain/2wd`), індикаторами 4x4, пониженої передачі та блокування диференціала.
- **Локальна реєстрація (Lab 3)**: екран `Registration` з полями email / ім’я / пароль, валідацією (email містить `@` і `.`, ім’я без цифр та спецсимволів, пароль ≥ 6 символів) і збереженням у локальне сховище.
- **Логін (Lab 3)**: екран `Login` з валідацією та перевіркою введених даних проти збережених у сховищі, при успіху — перехід у додаток, при помилці — повідомлення.
- **Профіль (Lab 3)**: екран `Profile` з відображенням email та імені користувача, можливістю редагувати дані, зберегти зміни, вийти з акаунта або “видалити” акаунт (очистити локальне сховище).

### Архітектура та сховище

- **Розділення на шари**:
  - `core/entities` — сутність `User`;
  - `core/repositories` — абстракція `AuthRepository` (інтерфейс для реєстрації, логіну, оновлення та отримання користувача);
  - `data/storage` — реалізація `LocalAuthRepository` на `SharedPreferences`;
  - `features` — екрани `auth` (login/registration), `home` (bottom‑nav + dashboard), `profile`.
- **Абстракція над сховищем**: робота з користувачем йде лише через `AuthRepository`, що дозволяє легко замінити локальне `SharedPreferences` на API або інший storage.

### Технічні деталі реалізації вимог Lab 3

- **Локальна реєстрація та логування**:
  - при реєстрації `LocalAuthRepository.register()` зберігає `User` + пароль у `SharedPreferences`;
  - при логіні `LocalAuthRepository.login()` дістає користувача й пароль та порівнює їх з введеними значеннями;
  - при логауті/видаленні `logout()` очищає дані користувача в сховищі.
- **Стартова логіка додатку**:
  - у `main.dart` створюється реалізація `LocalAuthRepository`;
  - через `FutureBuilder(isLoggedIn())` визначається стартовий екран: `HomeScreen` (якщо юзер є) або `LoginScreen`.
- **Оперування даними в UI**:
  - усі екрани, де змінюються дані (`Dashboard`, `Login`, `Registration`, `Profile`), реалізовані як `StatefulWidget` зі зрозумілим поділом стану;
  - зміна даних профілю відбувається через `AuthRepository.updateUser()`.

### Запуск

```bash
flutter clean
flutter pub get
flutter run
```

### Техстек

- **Flutter** (Material 3, темна тема, кастомні `AppBar`, `ElevatedButton`, `TextField`).
- **Локальне сховище**: `shared_preferences` — простий key‑value storage на пристрої.

