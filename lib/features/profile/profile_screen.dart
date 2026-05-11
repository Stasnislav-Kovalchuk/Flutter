import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../application/cubits/auth/auth_cubit.dart';
import '../../application/cubits/profile/profile_cubit.dart';
import '../auth/presentation/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121218),
      appBar: AppBar(
        title: const Text('Профіль'),
        backgroundColor: const Color(0xFF181820),
      ),
      body: BlocListener<AuthCubit, AuthState>(
        listener: (BuildContext context, AuthState state) {
          if (state is AuthLogoutSuccess) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
              (Route<dynamic> route) => false,
            );
          }
        },
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (BuildContext context, ProfileState state) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Card(
                    color: const Color(0xFF1A1A22),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: _buildContent(context, state),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, ProfileState state) {
    if (state is ProfileLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is ProfileError) {
      return Center(
        child: Text(
          state.message,
          style: const TextStyle(color: Colors.redAccent),
        ),
      );
    }

    if (state is ProfileLoaded) {
      final user = state.user;
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const Text(
            'Дані користувача',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          TextField(
            readOnly: true,
            style: const TextStyle(color: Colors.white70),
            decoration: InputDecoration(
              labelText: 'Email',
              labelStyle: const TextStyle(color: Colors.grey),
              hintText: user.email,
              hintStyle: const TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            readOnly: true,
            style: const TextStyle(color: Colors.white70),
            decoration: InputDecoration(
              labelText: 'Імʼя',
              labelStyle: const TextStyle(color: Colors.grey),
              hintText: user.name,
              hintStyle: const TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => _showLogoutDialog(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey,
              foregroundColor: Colors.white,
            ),
            child: const Text('Вийти'),
          ),
        ],
      );
    }

    return const Center(child: Text('Завантажуємо профіль...'));
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog<void>(
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
              context.read<AuthCubit>().logout();
            },
            child: const Text('Вийти'),
          ),
        ],
      ),
    );
  }
}
