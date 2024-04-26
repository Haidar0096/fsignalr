import 'package:flutter/material.dart';

import 'message.dart';

class MessagesListView extends StatelessWidget {
  final List<Message> messages;
  final Color backgroundColor;

  const MessagesListView({
    super.key,
    required this.messages,
    this.backgroundColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) => Container(
        color: backgroundColor,
        child: ListView.builder(
          itemCount: messages.length,
          itemBuilder: (context, index) => ListTile(
            title: Text(
              _getMessageDisplayText(messages[index].text),
            ),
            subtitle: Text(
              messages[index].user ?? '[Unknown user]',
              style: const TextStyle(
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );

  String _getMessageDisplayText(String? messageText) {
    if (messageText == null || messageText.isEmpty) {
      return '[Empty message]';
    }
    return messageText;
  }
}
