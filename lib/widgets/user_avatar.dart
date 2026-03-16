import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({
    super.key,
    this.size = 96,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: size / 2,
      backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
      child: Icon(
        Icons.person,
        size: size * 0.6,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
