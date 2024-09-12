class ChatMessageModel {
  final String message;
  final DateTime date;
  final bool isMe;
  bool isLiked;
  bool isDisliked;
  int interactionCount = 0;
  DateTime lastInteraction = DateTime.now();

  ChatMessageModel({
    required this.message,
    required this.date,
    required this.isMe,
    required this.isLiked,
    required this.isDisliked,
  });
}