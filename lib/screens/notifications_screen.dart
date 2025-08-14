import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../providers/notification_provider.dart';
import '../utils/constants.dart';
import '../widgets/notification_card.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final notifications = ref.watch(userNotificationsProvider(user?.id ?? ''));

    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: notifications.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_none,
                    size: 64,
                    color: AppConstants.textSecondaryColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No notifications',
                    style: AppConstants.bodyStyle.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'You\'ll see notifications here when there are updates',
                    style: AppConstants.captionStyle,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(AppConstants.paddingMedium),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: NotificationCard(
                    notification: notification,
                    onTap: () {
                      // Handle notification tap
                    },
                    onDismiss: () {
                      ref.read(notificationProvider.notifier).deleteNotification(notification.id);
                    },
                  ),
                );
              },
            ),
    );
  }
} 