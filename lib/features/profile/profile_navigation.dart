import 'package:flutter/material.dart';

import '../auth/presentation/login_screen.dart';

void goToLoginAndClearStack(BuildContext context) {
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute<void>(
      builder: (BuildContext context) => const LoginScreen(),
    ),
    (Route<dynamic> route) => false,
  );
}

