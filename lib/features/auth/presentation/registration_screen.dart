import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/repositories/auth_repository.dart';
import '../../../core/services/connectivity_notifier.dart';
import '../../home/home_screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    final String trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return 'Введіть email';
    }
    if (!trimmed.contains('@') || !trimmed.contains('.')) {
      return 'Невалідний email';
    }
    return null;
  }

  String? _validateName(String? value) {
    final String trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return 'Введіть імʼя';
    }
    final RegExp nameRegExp =
        RegExp(r'^[A-Za-zА-Яа-яЇїІіЄєҐґ\s]+$', unicode: true);
    if (!nameRegExp.hasMatch(trimmed)) {
      return 'Імʼя не повинно містити цифр або спецсимволів';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    final String trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return 'Введіть пароль';
    }
    if (trimmed.length < 6) {
      return 'Пароль має містити мінімум 6 символів';
    }
    return null;
  }

  Future<void> _onRegisterPressed() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    final AuthRepository auth = context.read<AuthRepository>();
    final bool online = await ConnectivityNotifier.checkOnline();
    if (!mounted) {
      return;
    }
    if (!online) {
      setState(() {
        _isLoading = false;
        _error = 'Немає з\'єднання з Інтернетом. Реєстрація недоступна.';
      });
      return;
    }

    try {
      await auth.register(
            email: _emailController.text.trim(),
            name: _nameController.text.trim(),
            password: _passwordController.text.trim(),
          );

      if (!mounted) {
        return;
      }

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute<void>(
          builder: (BuildContext context) => const HomeScreen(
            launchedOffline: false,
          ),
        ),
        (Route<dynamic> route) => false,
      );
    } on Object catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121218),
      appBar: AppBar(
        title: const Text('Реєстрація'),
        centerTitle: true,
        backgroundColor: const Color(0xFF181820),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Card(
              color: const Color(0xFF1A1A22),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
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
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(color: Colors.grey),
                        ),
                        validator: _validateEmail,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _nameController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Імʼя',
                          labelStyle: TextStyle(color: Colors.grey),
                        ),
                        validator: _validateName,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Пароль',
                          labelStyle: TextStyle(color: Colors.grey),
                        ),
                        validator: _validatePassword,
                      ),
                      const SizedBox(height: 16),
                      if (_error != null)
                        Text(
                          _error!,
                          style: const TextStyle(
                            color: Colors.redAccent,
                          ),
                        ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _isLoading ? null : _onRegisterPressed,
                        child: _isLoading
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
            ),
          ),
        ),
      ),
    );
  }
}
