import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../application/cubits/dashboard/dashboard_cubit.dart';

class DriveModeInput extends StatefulWidget {
  const DriveModeInput({super.key});

  @override
  State<DriveModeInput> createState() => _DriveModeInputState();
}

class _DriveModeInputState extends State<DriveModeInput> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardCubit, DashboardState>(
      buildWhen: (DashboardState p, DashboardState n) => p.error != n.error,
      builder: (BuildContext context, DashboardState state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _controller,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Введіть режим: sand / mud / snow / mountain',
                hintStyle: const TextStyle(color: Colors.grey),
                errorText: state.error,
                filled: true,
                fillColor: const Color(0xFF1E1E28),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => context
                  .read<DashboardCubit>()
                  .applyDriveMode(_controller.text),
              child: const Text('Активувати режим'),
            ),
          ],
        );
      },
    );
  }
}
