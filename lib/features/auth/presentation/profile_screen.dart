import 'package:flutter/material.dart';

import '../../auth/data/user_repository_prefs.dart';
import '../../auth/domain/user.dart';
import '../../auth/domain/user_repository.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
    required this.userRepository,
  });

  final SharedPrefsUserRepository userRepository;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _emailController;

  bool _isLoading = true;
  User? _user;

  UserRepository get _repo => widget.userRepository;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await _repo.getCurrentUser();
    if (!mounted) {
      return;
    }

    setState(() {
      _user = user;
      _isLoading = false;
    });

    if (user != null) {
      _nameController.text = user.name;
      _emailController.text = user.email;
    }
  }

  String? _validateName(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) {
      return 'Введіть ім\'я';
    }
    if (RegExp(r'\d').hasMatch(text)) {
      return 'Ім\'я не повинно містити цифр';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) {
      return 'Введіть email';
    }
    final emailRegex =
        RegExp(r'^[\w\.\-]+@([\w\-]+\.)+[a-zA-Z]{2,4}$');
    if (!emailRegex.hasMatch(text)) {
      return 'Некоректний email';
    }
    return null;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate() || _user == null) {
      return;
    }

    final updated = _user!.copyWith(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
    );
    await _repo.updateUser(updated);

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Дані збережено')),
    );
  }

  Future<void> _delete() async {
    await _repo.deleteUser();
    if (!mounted) {
      return;
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Профіль користувача'),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Вийти',
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await _repo.logout();
              if (!mounted) {
                return;
              }
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (_) =>
                      LoginScreen(userRepository: widget.userRepository),
                ),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _user == null
              ? const Center(child: Text('Користувача не знайдено'))
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Email: ${_user!.email}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Ім\'я',
                          ),
                          validator: _validateName,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                          ),
                          validator: _validateEmail,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _save,
                          child: const Text('Зберегти зміни'),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: _delete,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          child: const Text('Видалити акаунт'),
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Повернутися на головну'),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}

