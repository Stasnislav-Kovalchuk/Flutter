import 'package:flutter/material.dart';
import '../core/plugins/my_torch_shim.dart';

class TorchExample extends StatelessWidget {
  const TorchExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton.icon(
        icon: const Icon(Icons.flash_on),
        label: const Text('Toggle Torch'),
        onPressed: () async {
          final ok = await MyNewPlugin.onLight(context: context);
          final snack =
              ok ? 'Torch toggled' : 'Operation not supported or failed';
          if (context.mounted) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(snack)));
          }
        },
      ),
    );
  }
}
