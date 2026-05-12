import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:provider/provider.dart';

import '../cubit/simple_counter_cubit.dart';
import '../cubit/simple_counter_state.dart';
import '../model/simple_counter_model.dart';

/// Example widget showing two alternative ways to use the simple templates:
///  - `SimpleCounterCubitView` — using `Cubit`/`flutter_bloc`
///  - `SimpleCounterModelView` — using `ChangeNotifier`/`provider`

class SimpleCounterCubitView extends StatelessWidget {
  const SimpleCounterCubitView({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Cubit counter example'),
            const SizedBox(height: 8),
            BlocBuilder<SimpleCounterCubit, SimpleCounterState>(
              builder: (context, state) {
                if (state.loading) return const CircularProgressIndicator();
                if (state.error != null) return Text('Error: ${state.error}');
                return Text('Value: ${state.value}',
                    style: const TextStyle(fontSize: 20));
              },
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () =>
                      context.read<SimpleCounterCubit>().increment(),
                  child: const Text('Increment'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => context.read<SimpleCounterCubit>().reset(),
                  child: const Text('Reset'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SimpleCounterModelView extends StatelessWidget {
  const SimpleCounterModelView({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<SimpleCounterModel>();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('ChangeNotifier example'),
            const SizedBox(height: 8),
            if (model.loading)
              const CircularProgressIndicator()
            else if (model.error != null)
              Text('Error: ${model.error}')
            else
              Text('Value: ${model.value}',
                  style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 8),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () => model.increment(),
                  child: const Text('Increment'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => model.reset(),
                  child: const Text('Reset'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
