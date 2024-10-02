class InteractionsModel {
  final bool isLiked;
  final bool isDisliked;
  final DateTime createdAt;
  final int messageIndex;
  final bool susses;

  InteractionsModel({
    required this.isLiked,
    required this.isDisliked,
    required this.createdAt,
    required this.messageIndex,
    required this.susses,
  });
}