import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/repositories/auth_repository.dart';
import '../../../core/services/connectivity_notifier.dart';
import '../../home/home_screen.dart';
import 'registration_form_card.dart';

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
            child: RegistrationFormCard(
              formKey: _formKey,
              emailController: _emailController,
              nameController: _nameController,
              passwordController: _passwordController,
              isLoading: _isLoading,
              error: _error,
              onRegisterPressed: _onRegisterPressed,
            ),
          ),
        ),
      ),
    );
  }
}
