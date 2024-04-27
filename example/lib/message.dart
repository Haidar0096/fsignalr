class Message {
  final String? arg1;
  final String? arg2;
  final MessageSource source;

  Message({
    required this.source,
    this.arg1,
    this.arg2,
  });
}

enum MessageSource {
  client,
  server,
}
