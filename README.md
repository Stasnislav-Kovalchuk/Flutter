### Offroad Companion – Flutter UI Lab

- **Login**
  - Поля: email, password
  - Валідація:
    - email у валідному форматі;
    - пароль мінімум 6 символів.
  - У разі успіху – перехід на

- **Register**
  - Поля: name, email, password
  - Валідація:
    - імʼя не може бути порожнім;
    - email валідний;
    - пароль мінімум 6 символів.
  - У разі успіху – перехід на **Home** та збереження даних користувача в памʼяті додатку.

- **Home – 4WD Mode Selector (головна фіча)**
  - Заголовок: **4WD Mode Selector**
  - Вибір режиму приводу:
    - `2H` – 2 Wheel Drive High
    - `4H` – 4 Wheel Drive High
    - `4L` – 4 Wheel Drive Low
    - `AUTO`

- **Profile**
  - Аватар
  - Імʼя та email користувача (заповнюються з форми реєстрації / логіну)
  - Кнопка **Logout**, що повертає на екран **Login**.


### Запуск проєкту

Переконайся, що встановлено Flutter SDK, потім виконай у корені проєкту:

```bash
flutter clean
flutter pub get
flutter run -d chrome
```

