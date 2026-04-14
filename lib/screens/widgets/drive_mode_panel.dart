import 'package:flutter/material.dart';

class DriveModePanel extends StatefulWidget {
  const DriveModePanel({super.key});

  @override
  State<DriveModePanel> createState() => _DriveModePanelState();
}

class _DriveModePanelState extends State<DriveModePanel> {
  final TextEditingController _controller = TextEditingController();

  String _mode = 'None';
  bool _is4x4 = false;
  bool _lowGear = false;
  bool _diffLock = false;
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _applyMode() {
    final String input = _controller.text.trim().toLowerCase();
    setState(() {
      _error = null;
      switch (input) {
        case 'sand':
          _setMode('Sand', is4x4: true);
          break;
        case 'mud':
          _setMode('Mud', is4x4: true, low: true, diff: true);
          break;
        case 'snow':
          _setMode('Snow', is4x4: true);
          break;
        case 'mountain':
          _setMode('Mountain', is4x4: true, low: true, diff: true);
          break;
        case '2wd':
          _setMode('Eco Mode');
          break;
        default:
          _error = 'Невідомий режим (sand, mud, snow, mountain)';
      }
    });
  }

  void _setMode(
    String mode, {
    bool is4x4 = false,
    bool low = false,
    bool diff = false,
  }) {
    _mode = mode;
    _is4x4 = is4x4;
    _lowGear = low;
    _diffLock = diff;
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        TextField(
          controller: _controller,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Введіть режим: sand / mud / snow / mountain',
            hintStyle: const TextStyle(color: Colors.grey),
            errorText: _error,
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
          textAlign: TextAlign.center,
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
        title: Text(title, style: const TextStyle(color: Colors.white)),
        trailing: Text(
          active ? 'ON' : 'OFF',
          style: TextStyle(
            color: active ? Colors.greenAccent : Colors.redAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

