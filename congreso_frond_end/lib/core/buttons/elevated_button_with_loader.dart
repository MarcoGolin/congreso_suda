import 'package:flutter/material.dart';

class ElevatedButtonWithLoader extends StatelessWidget {
  final String label;
  final bool isLoading;
  final void Function() onPressed;
  const ElevatedButtonWithLoader({
    super.key,
    required this.isLoading,
    required this.onPressed,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      child: isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            )
          : Text(label),
    );
  }
}
