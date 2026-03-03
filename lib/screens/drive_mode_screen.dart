import 'package:flutter/material.dart';

enum DriveMode {
  sand,
  mud,
  snow,
  mountain,
  twoWd,
}

@immutable
class DriveState {
  const DriveState({
    required this.modeName,
    required this.is4x4,
    required this.lowGear,
    required this.diffLock,
  });

  final String modeName;
  final bool is4x4;
  final bool lowGear;
  final bool diffLock;
}

class DriveModeScreen extends StatefulWidget {
  const DriveModeScreen({super.key});

  @override
  State<DriveModeScreen> createState() => _DriveModeScreenState();
}

class _DriveModeScreenState extends State<DriveModeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();

  DriveMode? _activeMode;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _normalize(String raw) => raw.trim().toLowerCase();

  DriveMode? _parseMode(String raw) {
    switch (_normalize(raw)) {
      case 'sand':
        return DriveMode.sand;
      case 'mud':
        return DriveMode.mud;
      case 'snow':
        return DriveMode.snow;
      case 'mountain':
        return DriveMode.mountain;
      case '2wd':
        return DriveMode.twoWd;
      default:
        return null;
    }
  }

  DriveState _stateFor(DriveMode? mode) {
    switch (mode) {
      case DriveMode.sand:
        return const DriveState(
          modeName: 'Sand',
          is4x4: true,
          lowGear: false,
          diffLock: false,
        );
      case DriveMode.mud:
        return const DriveState(
          modeName: 'Mud',
          is4x4: true,
          lowGear: true,
          diffLock: true,
        );
      case DriveMode.snow:
        return const DriveState(
          modeName: 'Snow',
          is4x4: true,
          lowGear: false,
          diffLock: false,
        );
      case DriveMode.mountain:
        return const DriveState(
          modeName: 'Mountain',
          is4x4: true,
          lowGear: true,
          diffLock: true,
        );
      case DriveMode.twoWd:
        return const DriveState(
          modeName: '2WD',
          is4x4: false,
          lowGear: false,
          diffLock: false,
        );
      case null:
        return const DriveState(
          modeName: '—',
          is4x4: false,
          lowGear: false,
          diffLock: false,
        );
    }
  }

  String? _validator(String? value) {
    final input = _normalize(value ?? '');
    if (input.isEmpty) {
      return 'Введіть режим (sand, mud, snow, mountain) або 2wd';
    }
    if (_parseMode(input) == null) {
      return 'Невірний режим. Дозволено: sand, mud, snow, mountain, 2wd';
    }
    return null;
  }

  void _apply() {
    FocusManager.instance.primaryFocus?.unfocus();

    final formState = _formKey.currentState;
    if (formState == null) return;

    if (!formState.validate()) return;

    final mode = _parseMode(_controller.text);
    if (mode == null) return;

    setState(() => _activeMode = mode);
  }

  @override
  Widget build(BuildContext context) {
    final drive = _stateFor(_activeMode);

    return Scaffold(
      appBar: AppBar(
        title: const Text('IoT Flutter Lab 1'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/tire_bg.jpg',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF101018),
                        Color(0xFF0A0A0F),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.70)),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: _CardSurface(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Drive mode',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Form(
                          key: _formKey,
                          child: TextFormField(
                            controller: _controller,
                            textInputAction: TextInputAction.done,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: _validator,
                            onFieldSubmitted: (_) => _apply(),
                            decoration: const InputDecoration(
                              labelText: 'Mode',
                              hintText: 'sand / mud / snow / mountain / 2wd',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        FilledButton(
                          onPressed: _apply,
                          child: const Text('Apply'),
                        ),
                        const SizedBox(height: 20),
                        const Divider(height: 1),
                        const SizedBox(height: 16),
                        _ModeHeader(modeName: drive.modeName),
                        const SizedBox(height: 14),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            StatusChip(
                              label: '4x4',
                              isOn: drive.is4x4,
                              iconOn: Icons.directions_car_filled,
                              iconOff: Icons.directions_car_outlined,
                            ),
                            StatusChip(
                              label: 'Low gear',
                              isOn: drive.lowGear,
                              iconOn: Icons.speed,
                              iconOff: Icons.speed_outlined,
                            ),
                            StatusChip(
                              label: 'Diff lock',
                              isOn: drive.diffLock,
                              iconOn: Icons.lock,
                              iconOff: Icons.lock_open,
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CardSurface extends StatelessWidget {
  const _CardSurface({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFF141421).withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        boxShadow: const [
          BoxShadow(
            color: Color(0xAA000000),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: child,
      ),
    );
  }
}

class _ModeHeader extends StatelessWidget {
  const _ModeHeader({required this.modeName});

  final String modeName;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(Icons.terrain, color: cs.primary),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            modeName == '—' ? 'No mode applied' : modeName,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class StatusChip extends StatelessWidget {
  const StatusChip({
    super.key,
    required this.label,
    required this.isOn,
    required this.iconOn,
    required this.iconOff,
  });

  final String label;
  final bool isOn;
  final IconData iconOn;
  final IconData iconOff;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final bg = isOn ? cs.primary.withValues(alpha: 0.18) : Colors.white.withValues(alpha: 0.06);
    final fg = isOn ? cs.primary : Colors.white.withValues(alpha: 0.80);
    final border = isOn ? cs.primary.withValues(alpha: 0.40) : Colors.white.withValues(alpha: 0.10);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: border),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(isOn ? iconOn : iconOff, size: 18, color: fg),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: fg,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              isOn ? 'ON' : 'OFF',
              style: TextStyle(
                color: fg,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
