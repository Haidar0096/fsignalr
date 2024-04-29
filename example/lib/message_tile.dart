import 'package:flutter/material.dart';

import 'message.dart';

class MessageTile extends StatelessWidget {
  final Message message;

  const MessageTile({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        child: Column(
          crossAxisAlignment: switch (message.source) {
            MessageSource.server => CrossAxisAlignment.start,
            MessageSource.client => CrossAxisAlignment.end,
          },
          children: [
            Text(
              _getMessageDisplayText(message.arg1),
              style: TextStyle(
                color: _getMessageColor(message.source),
              ),
            ),
            Text(
              message.arg2 ?? '[arg2 was not provided]',
              style: const TextStyle(
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );

  Color _getMessageColor(MessageSource source) => switch (source) {
        MessageSource.server => Colors.blue,
        MessageSource.client => Colors.green,
      };

  String _getMessageDisplayText(String? messageText) {
    if (messageText == null || messageText.isEmpty) {
      return '[arg1 was not provided]';
    }
    return messageText;
  }
}
