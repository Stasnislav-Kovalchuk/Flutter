class AuthValidators {
  static String? email(String? value) {
    final String trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return 'Введіть email';
    if (!trimmed.contains('@') || !trimmed.contains('.')) {
      return 'Невалідний email';
    }
    return null;
  }

  static String? name(String? value) {
    final String trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return 'Введіть імʼя';
    final RegExp nameRegExp =
        RegExp(r'^[A-Za-zА-Яа-яЇїІіЄєҐґ\s]+$', unicode: true);
    if (!nameRegExp.hasMatch(trimmed)) {
      return 'Імʼя не повинно містити цифр або спецсимволів';
    }
    return null;
  }

  static String? password(String? value) {
    final String trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return 'Введіть пароль';
    if (trimmed.length < 6) {
      return 'Пароль має містити мінімум 6 символів';
    }
    return null;
  }
}
