import 'package:flutter/material.dart';

import 'message.dart';

class MessagesListView extends StatelessWidget {
  final List<Message> messages;
  final Color backgroundColor;
  final String hubName;

  const MessagesListView({
    super.key,
    required this.messages,
    this.backgroundColor = Colors.white,
    required this.hubName,
  });

  @override
  Widget build(BuildContext context) => Container(
        color: backgroundColor,
        child: Stack(
          children: [
            ListView.builder(
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
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.all(8.0),
                child: Text(hubName),
              ),
            ),
          ],
        ),
      );

  String _getMessageDisplayText(String? messageText) {
    if (messageText == null || messageText.isEmpty) {
      return '[Empty message]';
    }
    return messageText;
  }
}
