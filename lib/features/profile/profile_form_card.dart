import 'package:flutter/material.dart';

class ProfileFormCard extends StatelessWidget {
  const ProfileFormCard({
    required this.emailController,
    required this.nameController,
    required this.error,
    required this.onSavePressed,
    required this.onLogoutPressed,
    required this.onDeletePressed,
    super.key,
  });

  final TextEditingController emailController;
  final TextEditingController nameController;
  final String? error;
  final VoidCallback onSavePressed;
  final VoidCallback onLogoutPressed;
  final VoidCallback onDeletePressed;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF1A1A22),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
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
              controller: emailController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Імʼя',
                labelStyle: TextStyle(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 16),
            if (error != null)
              Text(
                error!,
                style: const TextStyle(color: Colors.redAccent),
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onSavePressed,
              child: const Text('Зберегти'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: onLogoutPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                foregroundColor: Colors.white,
              ),
              child: const Text('Вийти'),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: onDeletePressed,
              style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
              child: const Text('Видалити акаунт'),
            ),
          ],
        ),
      ),
    );
  }
}

