import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../application/cubits/profile/profile_cubit.dart';
import '../../core/entities/user.dart';
import '../auth/presentation/login_screen.dart';
import 'profile_dialogs.dart';
import 'profile_form.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final TextEditingController _emailController;
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121218),
      appBar: AppBar(
        title: const Text('Профіль'),
        backgroundColor: const Color(0xFF181820),
      ),
      body: BlocListener<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoaded) {
            _emailController.text = state.user.email;
            _nameController.text = state.user.name;
          }
          if (state is ProfileSaved) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Профіль збережено')));
          }
          if (state is ProfileLoggedOut || state is ProfileDeleted) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
              (Route<dynamic> route) => false,
            );
          }
        },
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
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

            return Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: ProfileForm(
                  emailController: _emailController,
                  nameController: _nameController,
                  onSave: () => _onSavePressed(context),
                  onLogout: () => _showLogoutDialog(context),
                  onDelete: () => _showDeleteDialog(context),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _onSavePressed(BuildContext context) {
    final String email = _emailController.text.trim();
    final String name = _nameController.text.trim();
    if (email.isEmpty || name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email та імʼя не можуть бути порожніми')),
      );
      return;
    }
    final user = User(email: email, name: name);
    context.read<ProfileCubit>().updateUser(user);
  }

  void _showLogoutDialog(BuildContext context) {
    showLogoutDialog(context);
  }

  void _showDeleteDialog(BuildContext context) {
    showDeleteDialog(context);
  }
}
