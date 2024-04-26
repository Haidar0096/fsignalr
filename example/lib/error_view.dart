import 'package:flutter/material.dart';

class ErrorView extends StatelessWidget {
  final String errorMessage;

  const ErrorView({
    super.key,
    required this.errorMessage,
  });

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: ListView(
            children: [
              Text(
                errorMessage,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 24,
                ),
              ),
            ],
          ),
        ),
      );
}
