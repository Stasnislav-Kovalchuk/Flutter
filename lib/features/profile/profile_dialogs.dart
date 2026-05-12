import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../application/cubits/profile/profile_cubit.dart';

Future<void> showLogoutDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: const Text('Вийти з акаунта?'),
      content: const Text(
        'Сесію буде завершено на цьому пристрої. '
        'Потрібно буде увійти знову.',
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Скасувати'),
        ),
        FilledButton(
          onPressed: () {
            Navigator.of(context).pop();
            context.read<ProfileCubit>().logout();
          },
          child: const Text('Вийти'),
        ),
      ],
    ),
  );
}

Future<void> showDeleteDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: const Text('Видалити акаунт?'),
      content: const Text('Акаунт буде безповоротно видалено.'),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Скасувати'),
        ),
        FilledButton(
          onPressed: () {
            Navigator.of(context).pop();
            context.read<ProfileCubit>().deleteAccount();
          },
          child: const Text('Видалити'),
        ),
      ],
    ),
  );
}
