import 'package:flutter/material.dart';

import '../../core/entities/user.dart';
import '../../core/repositories/auth_repository.dart';
import '../auth/presentation/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    required this.authRepository,
    super.key,
  });

  final AuthRepository authRepository;

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
    try {
      final User? user = await widget.authRepository.getCurrentUser();
      if (user != null) {
        _emailController.text = user.email;
        _nameController.text = user.name;
      }
    } catch (e) {
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
      await widget.authRepository.updateUser(user);
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Профіль збережено')),
      );
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    }
  }

  Future<void> _onLogoutPressed() async {
    await widget.authRepository.logout();
    if (!mounted) {
      return;
    }
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<LoginScreen>(
        builder: (BuildContext context) => LoginScreen(
          authRepository: widget.authRepository,
        ),
      ),
      (Route<dynamic> route) => false,
    );
  }

  Future<void> _onDeletePressed() async {
    await widget.authRepository.deleteAccount();
    if (!mounted) {
      return;
    }
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<LoginScreen>(
        builder: (BuildContext context) => LoginScreen(
          authRepository: widget.authRepository,
        ),
      ),
      (Route<dynamic> route) => false,
    );
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
                  child: Card(
                    color: const Color(0xFF1A1A22),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
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
                            controller: _emailController,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              labelStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _nameController,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              labelText: 'Імʼя',
                              labelStyle: TextStyle(color: Colors.grey),
                            ),
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
                            onPressed: _onSavePressed,
                            child: const Text('Зберегти'),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: _onLogoutPressed,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Вийти'),
                          ),
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: _onDeletePressed,
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.redAccent,
                            ),
                            child: const Text('Видалити акаунт'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}

