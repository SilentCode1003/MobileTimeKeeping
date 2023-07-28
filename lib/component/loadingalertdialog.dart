import 'package:flutter/material.dart';

class LoadingAlertDialog extends StatelessWidget {
  const LoadingAlertDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Row(
        children: const [
          CircularProgressIndicator(),
          SizedBox(width: 16.0),
          Text('Loading...'),
        ],
      ),
    );
  }
}
