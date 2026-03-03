import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final TextEditingController _controller = TextEditingController();

  String _mode = 'None';
  bool _is4x4 = false;
  bool _lowGear = false;
  bool _diffLock = false;
  String? _error;

  void _applyMode() {
    final input = _controller.text.trim().toLowerCase();

    setState(() {
      _error = null;

      if (input == 'sand') {
        _mode = 'Sand';
        _is4x4 = true;
        _lowGear = false;
        _diffLock = false;
      } else if (input == 'mud') {
        _mode = 'Mud';
        _is4x4 = true;
        _lowGear = true;
        _diffLock = true;
      } else if (input == 'snow') {
        _mode = 'Snow';
        _is4x4 = true;
        _lowGear = false;
        _diffLock = false;
      } else if (input == 'mountain') {
        _mode = 'Mountain';
        _is4x4 = true;
        _lowGear = true;
        _diffLock = true;
      } else if (input == '2wd') {
        _mode = 'Eco Mode';
        _is4x4 = false;
        _lowGear = false;
        _diffLock = false;
      } else {
        _error = 'Невідомий режим (sand, mud, snow, mountain)';
      }
    });
  }

  Color get _modeColor {
    switch (_mode) {
      case 'Mud':
        return Colors.brown;
      case 'Sand':
        return Colors.amber;
      case 'Snow':
        return Colors.lightBlue;
      case 'Mountain':
        return Colors.grey;
      default:
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111116),
      appBar: AppBar(
        title: const Text('IoT Drive Mode Lab 1'),
        centerTitle: true,
        backgroundColor: const Color(0xFF1A1A22),
      ),
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/tire_bg.jpg',
              fit: BoxFit.cover,
            ),
          ),

          // Dark overlay
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.7),
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                TextField(
                  controller: _controller,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText:
                        'Введіть режим: sand / mud / snow / mountain',
                    hintStyle:
                        const TextStyle(color: Colors.grey),
                    errorText: _error,
                    filled: true,
                    fillColor: const Color(0xFF1E1E28),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _applyMode,
                  child: const Text('Активувати режим'),
                ),
                const SizedBox(height: 30),
                Text(
                  _mode,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: _modeColor,
                  ),
                ),
                const SizedBox(height: 20),
                _status('4x4 Drive', _is4x4),
                _status('Low Gear', _lowGear),
                _status('Diff Lock', _diffLock),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _status(String title, bool active) {
    return Card(
      color: const Color(0xFF1A1A22),
      child: ListTile(
        leading: Icon(
          active ? Icons.check_circle : Icons.cancel,
          color: active ? Colors.greenAccent : Colors.redAccent,
        ),
        title: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
        trailing: Text(
          active ? 'ON' : 'OFF',
          style: TextStyle(
            color:
                active ? Colors.greenAccent : Colors.redAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}