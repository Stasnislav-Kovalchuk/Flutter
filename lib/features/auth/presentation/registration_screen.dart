import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/cubits/auth/auth_cubit.dart';
import '../../home/home_screen.dart';
import 'widgets/registration_form.dart';

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121218),
      appBar: AppBar(
        title: const Text('Реєстрація'),
        centerTitle: true,
        backgroundColor: const Color(0xFF181820),
      ),
      body: BlocListener<AuthCubit, AuthState>(
        listener: (BuildContext context, AuthState state) {
          if (state is AuthRegisterSuccess) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute<void>(
                builder: (_) => const HomeScreen(launchedOffline: false),
              ),
              (Route<dynamic> route) => false,
            );
          }
        },
        child: const Center(child: RegistrationForm()),
      ),
    );
  }
}
