import 'package:flutter/material.dart';

Future<bool> confirmLogout(BuildContext context) async {
  final bool? confirmed = await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Вийти з акаунта?'),
        content: const Text(
          'Сесію буде завершено на цьому пристрої. '
          'Потрібно буде увійти знову.',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Скасувати'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Вийти'),
          ),
        ],
      );
    },
  );
  return confirmed ?? false;
}

