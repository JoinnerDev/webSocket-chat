class ChatMessageModel {
  final String message;
  final DateTime date;
  final bool isMe;

  const ChatMessageModel({
    required this.message,
    required this.date,
    required this.isMe,
  });
}