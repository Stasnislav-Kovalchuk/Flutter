import 'package:flutter/material.dart';

import 'auth_validators.dart';

class RegistrationFormCard extends StatelessWidget {
  const RegistrationFormCard({
    required this.formKey,
    required this.emailController,
    required this.nameController,
    required this.passwordController,
    required this.isLoading,
    required this.error,
    required this.onRegisterPressed,
    super.key,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController nameController;
  final TextEditingController passwordController;
  final bool isLoading;
  final String? error;
  final Future<void> Function() onRegisterPressed;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF1A1A22),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Text(
                'Створення акаунта',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.grey),
                ),
                validator: validateEmail,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: nameController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Імʼя',
                  labelStyle: TextStyle(color: Colors.grey),
                ),
                validator: validateName,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Пароль',
                  labelStyle: TextStyle(color: Colors.grey),
                ),
                validator: validatePassword,
              ),
              const SizedBox(height: 16),
              if (error != null)
                Text(
                  error!,
                  style: const TextStyle(color: Colors.redAccent),
                ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: isLoading ? null : onRegisterPressed,
                child: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.black,
                        ),
                      )
                    : const Text('Зареєструватися'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

