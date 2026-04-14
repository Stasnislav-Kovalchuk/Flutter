import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/entities/user.dart';
import '../../core/repositories/auth_repository.dart';
import 'profile_dialogs.dart';
import 'profile_form_card.dart';
import 'profile_navigation.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _loadUser() async {
    final AuthRepository repo = context.read<AuthRepository>();
    try {
      final User? user = await repo.getCurrentUser();
      if (user != null) {
        _emailController.text = user.email;
        _nameController.text = user.name;
      }
    } on Object catch (e) {
      _error = e.toString();
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _onSavePressed() async {
    setState(() {
      _error = null;
    });

    final String email = _emailController.text.trim();
    final String name = _nameController.text.trim();

    if (email.isEmpty || name.isEmpty) {
      setState(() {
        _error = 'Email та імʼя не можуть бути порожніми';
      });
      return;
    }

    final User user = User(email: email, name: name);

    try {
      await context.read<AuthRepository>().updateUser(user);
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Профіль збережено')),
      );
    } on Object catch (e) {
      setState(() {
        _error = e.toString();
      });
    }
  }

  Future<void> _onLogoutPressed() async {
    final bool confirmed = await confirmLogout(context);
    if (!confirmed || !mounted) {
      return;
    }

    await context.read<AuthRepository>().logout();
    if (!mounted) {
      return;
    }
    goToLoginAndClearStack(context);
  }

  Future<void> _onDeletePressed() async {
    await context.read<AuthRepository>().deleteAccount();
    if (!mounted) {
      return;
    }
    goToLoginAndClearStack(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121218),
      appBar: AppBar(
        title: const Text('Профіль'),
        backgroundColor: const Color(0xFF181820),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: ProfileFormCard(
                    emailController: _emailController,
                    nameController: _nameController,
                    error: _error,
                    onSavePressed: _onSavePressed,
                    onLogoutPressed: _onLogoutPressed,
                    onDeletePressed: _onDeletePressed,
                  ),
                ),
              ),
            ),
    );
  }
}
