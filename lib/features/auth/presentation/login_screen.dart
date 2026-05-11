import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/cubits/auth/auth_cubit.dart';
import '../../home/home_screen.dart';
import 'widgets/login_form.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121218),
      appBar: AppBar(
        title: const Text('Логін'),
        centerTitle: true,
        backgroundColor: const Color(0xFF181820),
      ),
      body: BlocListener<AuthCubit, AuthState>(
        listener: (BuildContext context, AuthState state) {
          if (state is AuthLoginSuccess) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute<void>(
                builder: (_) => const HomeScreen(launchedOffline: false),
              ),
            );
          }
        },
        child: const Center(child: LoginForm()),
      ),
    );
  }
}
