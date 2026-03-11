import 'package:flutter/material.dart';
import '../main.dart';
import '../widgets/custom_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final horizontalPadding = size.width * 0.06;
    final appState = AppStateScope.of(context);
    final mode = appState.mode;

    return Scaffold(
      appBar: AppBar(
        title: const Text('4WD Mode Selector'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
            icon: const Icon(Icons.person_outline),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: size.height * 0.03,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Select drivetrain mode',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Choose how power is distributed to the wheels.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade400,
                  ),
            ),
            SizedBox(height: size.height * 0.03),
            Expanded(
              child: GridView.count(
                crossAxisCount: size.width > 700 ? 4 : 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 0.9,
                children: DrivetrainMode.values
                    .map(
                      (m) => _ModeCard(
                        mode: m,
                        selected: m == mode,
                        onTap: () => appState.setMode(m),
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF11151C),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.6),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.settings_input_component,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Current mode: ${mode.label}',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          mode.description,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: Colors.grey.shade400),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ModeCard extends StatelessWidget {
  const _ModeCard({
    required this.mode,
    required this.selected,
    required this.onTap,
  });

  final DrivetrainMode mode;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: selected ? colorScheme.primary : const Color(0xFF151A24),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color:
                selected ? Colors.white.withOpacity(0.9) : Colors.grey.shade700,
            width: selected ? 2 : 1,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: colorScheme.primary.withOpacity(0.4),
                    blurRadius: 16,
                    spreadRadius: 1,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.terrain,
                  color: selected ? Colors.black : colorScheme.primary,
                ),
                const Spacer(),
                if (selected)
                  const Icon(
                    Icons.check_circle,
                    color: Colors.black,
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              mode.label,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: selected ? Colors.black : Colors.white,
                  ),
            ),
            const SizedBox(height: 6),
            Text(
              mode.description,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: selected
                        ? Colors.black.withOpacity(0.8)
                        : Colors.grey.shade400,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
