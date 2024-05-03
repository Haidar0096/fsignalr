import 'package:flutter/material.dart';

class SendMessageTextField extends StatefulWidget {
  final Future<void> Function({
    required String hubMethodName,
    required String messageText,
  }) onSendMessagePressed;
  final String hintText;
  final List<String> handledHubMethodsNames;

  const SendMessageTextField({
    super.key,
    required this.onSendMessagePressed,
    required this.hintText,
    required this.handledHubMethodsNames,
  });

  @override
  State<SendMessageTextField> createState() => _SendMessageTextFieldState();
}

class _SendMessageTextFieldState extends State<SendMessageTextField> {
  final TextEditingController _messageController = TextEditingController();
  late String _selectedHubMethodName;

  @override
  void initState() {
    super.initState();
    _selectedHubMethodName = widget.handledHubMethodsNames.first;
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 80,
                    child: _buildTextField(),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    flex: 20,
                    child: _buildDropdownButton(),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              widget.onSendMessagePressed(
                messageText: _messageController.text,
                hubMethodName: _selectedHubMethodName,
              );
            },
          ),
        ],
      );

  Widget _buildDropdownButton() => Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: DropdownButton<String>(
          value: _selectedHubMethodName,
          onChanged: (String? value) {
            if (value != null) {
              setState(() => _selectedHubMethodName = value);
            }
          },
          underline: Container(),
          items: widget.handledHubMethodsNames
              .map(
                (String handledHubMethodName) => DropdownMenuItem<String>(
                  value: handledHubMethodName,
                  child: Center(child: Text(handledHubMethodName)),
                ),
              )
              .toList(),
          isExpanded: true,
        ),
      );

  Widget _buildTextField() => TextField(
        controller: _messageController,
        decoration: InputDecoration(
          hintText: widget.hintText,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.zero,
            borderSide: BorderSide(
              color: Colors.black,
            ),
          ),
        ),
        onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
      );
}
