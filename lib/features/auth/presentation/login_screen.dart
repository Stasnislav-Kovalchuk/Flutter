import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/repositories/auth_repository.dart';
import '../../../core/services/connectivity_notifier.dart';
import '../../home/home_screen.dart';
import 'login_form_card.dart';
import 'registration_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onLoginPressed() async {
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
        _error = 'Немає з\'єднання з Інтернетом. Перевірте мережу.';
      });
      return;
    }

    try {
      await auth.login(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );

      if (!mounted) {
        return;
      }

      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (BuildContext context) => const HomeScreen(
            launchedOffline: false,
          ),
        ),
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

  void _onRegisterPressed() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => const RegistrationScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121218),
      appBar: AppBar(
        title: const Text('Логін'),
        centerTitle: true,
        backgroundColor: const Color(0xFF181820),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: LoginFormCard(
              formKey: _formKey,
              emailController: _emailController,
              passwordController: _passwordController,
              isLoading: _isLoading,
              error: _error,
              onLoginPressed: _onLoginPressed,
              onRegisterPressed: _onRegisterPressed,
            ),
          ),
        ),
      ),
    );
  }
}
