class UserNotification {
  const UserNotification({
    required this.id,
    required this.userId,
    required this.title,
    required this.message,
    required this.type,
    required this.bookingId,
    required this.isRead,
    required this.createdAt,
  });

  final String id;
  final String userId;
  final String title;
  final String message;
  final String type;
  final String bookingId;
  final bool isRead;
  final DateTime createdAt;

  UserNotification copyWith({bool? isRead}) => UserNotification(
    id: id,
    userId: userId,
    title: title,
    message: message,
    type: type,
    bookingId: bookingId,
    isRead: isRead ?? this.isRead,
    createdAt: createdAt,
  );

  Map<String, Object> toJson() => {
    'id': id,
    'title': title,
    'message': message,
    'type': type,
    'bookingId': bookingId,
    'isRead': isRead,
    'createdAt': createdAt.toUtc().toIso8601String(),
  };
}
