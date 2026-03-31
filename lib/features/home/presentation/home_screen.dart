import 'package:flutter/material.dart';

import '../../auth/data/user_repository_prefs.dart';
import '../../auth/domain/user.dart';
import '../../auth/domain/user_repository.dart';
import '../../auth/presentation/profile_screen.dart';
import '../../../screens/dashboard_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.userRepository,
  });

  final SharedPrefsUserRepository userRepository;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = true;
  User? _user;

  UserRepository get _repo => widget.userRepository;

  @override
  void initState() {
    super.initState();
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Головна'),
        centerTitle: true,
        actions: [
          if (_user != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Center(
                child: Text(
                  _user!.email,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ),
          IconButton(
            tooltip: 'Профіль',
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) =>
                      ProfileScreen(userRepository: widget.userRepository),
                ),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF1E1E28), Color(0xFF121218)],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      _user != null
                          ? 'Привіт, ${_user!.name}!'
                          : 'Привіт, водію!',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Обери режим руху для свого позашляховика '
                      'та подивись, як змінюються налаштування авто.',
                    ),
                    const SizedBox(height: 16),
                    const Expanded(
                      child: Card(
                        margin: EdgeInsets.zero,
                        color: Color(0xFF1A1A22),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(24)),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: DashboardScreen(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

