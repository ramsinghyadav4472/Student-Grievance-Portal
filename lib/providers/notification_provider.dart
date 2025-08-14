import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/notification.dart';
import '../utils/dummy_data.dart';

class NotificationNotifier extends StateNotifier<List<AppNotification>> {
  NotificationNotifier() : super(DummyData.notifications);

  // Get all notifications
  List<AppNotification> get allNotifications => state;

  // Get notifications by user ID
  List<AppNotification> getNotificationsByUserId(String userId) {
    return state.where((notification) => notification.userId == userId).toList();
  }

  // Get unread notifications by user ID
  List<AppNotification> getUnreadNotificationsByUserId(String userId) {
    return state.where((notification) => 
        notification.userId == userId && !notification.isRead).toList();
  }

  // Add new notification
  void addNotification(AppNotification notification) {
    state = [notification, ...state];
  }

  // Mark notification as read
  void markAsRead(String notificationId) {
    state = state.map((notification) {
      if (notification.id == notificationId) {
        return notification.copyWith(isRead: true);
      }
      return notification;
    }).toList();
  }

  // Mark all notifications as read for a user
  void markAllAsRead(String userId) {
    state = state.map((notification) {
      if (notification.userId == userId) {
        return notification.copyWith(isRead: true);
      }
      return notification;
    }).toList();
  }

  // Delete notification
  void deleteNotification(String notificationId) {
    state = state.where((notification) => notification.id != notificationId).toList();
  }

  // Delete all notifications for a user
  void deleteAllNotifications(String userId) {
    state = state.where((notification) => notification.userId != userId).toList();
  }

  // Get notification count for a user
  int getNotificationCount(String userId) {
    return state.where((notification) => notification.userId == userId).length;
  }

  // Get unread notification count for a user
  int getUnreadNotificationCount(String userId) {
    return state.where((notification) => 
        notification.userId == userId && !notification.isRead).length;
  }

  // Create notification for grievance status change
  void createStatusChangeNotification({
    required String userId,
    required String grievanceId,
    required String grievanceTitle,
    required String newStatus,
  }) {
    final notification = AppNotification(
      id: DummyData.generateId(),
      title: 'Grievance Status Updated',
      message: 'Your grievance "$grievanceTitle" status has been changed to $newStatus.',
      type: NotificationType.statusChange,
      userId: userId,
      createdAt: DateTime.now(),
      grievanceId: grievanceId,
    );
    addNotification(notification);
  }

  // Create notification for new reply
  void createReplyNotification({
    required String userId,
    required String grievanceId,
    required String grievanceTitle,
  }) {
    final notification = AppNotification(
      id: DummyData.generateId(),
      title: 'New Reply Received',
      message: 'You have received a reply for your grievance "$grievanceTitle".',
      type: NotificationType.newReply,
      userId: userId,
      createdAt: DateTime.now(),
      grievanceId: grievanceId,
    );
    addNotification(notification);
  }

  // Create notification for new grievance (for admins)
  void createNewGrievanceNotification({
    required String adminUserId,
    required String grievanceId,
    required String submittedBy,
    required String grievanceTitle,
  }) {
    final notification = AppNotification(
      id: DummyData.generateId(),
      title: 'New Grievance Submitted',
      message: 'A new grievance has been submitted by $submittedBy: "$grievanceTitle".',
      type: NotificationType.grievanceUpdate,
      userId: adminUserId,
      createdAt: DateTime.now(),
      grievanceId: grievanceId,
    );
    addNotification(notification);
  }

  // Create general notification
  void createGeneralNotification({
    required String userId,
    required String title,
    required String message,
  }) {
    final notification = AppNotification(
      id: DummyData.generateId(),
      title: title,
      message: message,
      type: NotificationType.general,
      userId: userId,
      createdAt: DateTime.now(),
    );
    addNotification(notification);
  }
}

// Provider for notification state
final notificationProvider = StateNotifierProvider<NotificationNotifier, List<AppNotification>>((ref) {
  return NotificationNotifier();
});

// Provider for all notifications
final allNotificationsProvider = Provider<List<AppNotification>>((ref) {
  return ref.watch(notificationProvider);
});

// Provider for user notifications
final userNotificationsProvider = Provider.family<List<AppNotification>, String>((ref, userId) {
  final notificationNotifier = ref.watch(notificationProvider.notifier);
  return notificationNotifier.getNotificationsByUserId(userId);
});

// Provider for unread user notifications
final unreadNotificationsProvider = Provider.family<List<AppNotification>, String>((ref, userId) {
  final notificationNotifier = ref.watch(notificationProvider.notifier);
  return notificationNotifier.getUnreadNotificationsByUserId(userId);
});

// Provider for notification count
final notificationCountProvider = Provider.family<int, String>((ref, userId) {
  final notificationNotifier = ref.watch(notificationProvider.notifier);
  return notificationNotifier.getNotificationCount(userId);
});

// Provider for unread notification count
final unreadNotificationCountProvider = Provider.family<int, String>((ref, userId) {
  final notificationNotifier = ref.watch(notificationProvider.notifier);
  return notificationNotifier.getUnreadNotificationCount(userId);
}); 