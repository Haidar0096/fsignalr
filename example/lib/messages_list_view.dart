import 'package:flutter/material.dart';
import 'package:fsignalr/fsignalr.dart';

import 'message.dart';
import 'message_tile.dart';

class MessagesListView extends StatelessWidget {
  final List<Message> messages;
  final Color backgroundColor;
  final String hubName;
  final HubConnectionState connectionState;
  final void Function()? onReloadIconPressed;

  const MessagesListView({
    super.key,
    required this.messages,
    this.backgroundColor = Colors.white,
    required this.hubName,
    required this.connectionState,
    this.onReloadIconPressed,
  });

  @override
  Widget build(BuildContext context) => Container(
        color: backgroundColor,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: messages.length,
                itemBuilder: (context, index) => MessageTile(
                  message: messages[index],
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
                child: Text('$hubName: $connectionState'),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: onReloadIconPressed,
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.refresh),
                ),
              ),
            ),
          ],
        ),
      );
}
