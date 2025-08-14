enum NotificationType { grievanceUpdate, newReply, statusChange, general }

class AppNotification {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final String userId;
  final DateTime createdAt;
  final bool isRead;
  final String? grievanceId;
  final Map<String, dynamic>? metadata;

  const AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.userId,
    required this.createdAt,
    this.isRead = false,
    this.grievanceId,
    this.metadata,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      type: NotificationType.values.firstWhere(
        (e) => e.toString() == 'NotificationType.${json['type']}',
      ),
      userId: json['userId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      isRead: json['isRead'] as bool? ?? false,
      grievanceId: json['grievanceId'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'type': type.toString().split('.').last,
      'userId': userId,
      'createdAt': createdAt.toIso8601String(),
      'isRead': isRead,
      'grievanceId': grievanceId,
      'metadata': metadata,
    };
  }

  AppNotification copyWith({
    String? id,
    String? title,
    String? message,
    NotificationType? type,
    String? userId,
    DateTime? createdAt,
    bool? isRead,
    String? grievanceId,
    Map<String, dynamic>? metadata,
  }) {
    return AppNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
      grievanceId: grievanceId ?? this.grievanceId,
      metadata: metadata ?? this.metadata,
    );
  }

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
} 