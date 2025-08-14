import 'package:flutter/material.dart';
import '../models/notification.dart';
import '../utils/constants.dart';

class NotificationCard extends StatelessWidget {
  final AppNotification notification;
  final VoidCallback? onTap;
  final VoidCallback? onDismiss;

  const NotificationCard({
    super.key,
    required this.notification,
    this.onTap,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        onDismiss?.call();
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: AppConstants.errorColor,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      child: Card(
        elevation: notification.isRead ? 1 : 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              border: notification.isRead
                  ? null
                  : Border.all(
                      color: AppConstants.primaryColor.withAlpha((0.3 * 255).toInt()),
                      width: 1,
                    ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.paddingMedium),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _getNotificationColor().withAlpha((0.1 * 255).toInt()),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getNotificationIcon(),
                      size: 20,
                      color: _getNotificationColor(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                notification.title,
                                style: AppConstants.bodyStyle.copyWith(
                                  fontWeight: notification.isRead
                                      ? FontWeight.normal
                                      : FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (!notification.isRead)
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: AppConstants.primaryColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          notification.message,
                          style: AppConstants.captionStyle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.schedule,
                              size: 12,
                              color: AppConstants.textSecondaryColor,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              notification.timeAgo,
                              style: TextStyle(
                                fontSize: 12,
                                color: AppConstants.textSecondaryColor,
                              ),
                            ),
                            const Spacer(),
                            if (notification.grievanceId != null)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppConstants.primaryColor.withAlpha((0.1 * 255).toInt()),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'View Grievance',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: AppConstants.primaryColor,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  IconData _getNotificationIcon() {
    switch (notification.type) {
      case NotificationType.grievanceUpdate:
        return Icons.update;
      case NotificationType.newReply:
        return Icons.reply;
      case NotificationType.statusChange:
        return Icons.change_circle;
      case NotificationType.general:
        return Icons.notifications;
    }
  }

  Color _getNotificationColor() {
    switch (notification.type) {
      case NotificationType.grievanceUpdate:
        return AppConstants.primaryColor;
      case NotificationType.newReply:
        return AppConstants.successColor;
      case NotificationType.statusChange:
        return AppConstants.warningColor;
      case NotificationType.general:
        return AppConstants.textSecondaryColor;
    }
  }
}

// Compact notification card for lists
class CompactNotificationCard extends StatelessWidget {
  final AppNotification notification;
  final VoidCallback? onTap;

  const CompactNotificationCard({
    super.key,
    required this.notification,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor: _getNotificationColor().withAlpha((0.1 * 255).toInt()),
        child: Icon(
          _getNotificationIcon(),
          size: 18,
          color: _getNotificationColor(),
        ),
      ),
      title: Text(
        notification.title,
        style: AppConstants.bodyStyle.copyWith(
          fontWeight: notification.isRead ? FontWeight.normal : FontWeight.w600,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            notification.message,
            style: AppConstants.captionStyle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            notification.timeAgo,
            style: TextStyle(
              fontSize: 11,
              color: AppConstants.textSecondaryColor,
            ),
          ),
        ],
      ),
      trailing: !notification.isRead
          ? Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: AppConstants.primaryColor,
                shape: BoxShape.circle,
              ),
            )
          : null,
    );
  }

  IconData _getNotificationIcon() {
    switch (notification.type) {
      case NotificationType.grievanceUpdate:
        return Icons.update;
      case NotificationType.newReply:
        return Icons.reply;
      case NotificationType.statusChange:
        return Icons.change_circle;
      case NotificationType.general:
        return Icons.notifications;
    }
  }

  Color _getNotificationColor() {
    switch (notification.type) {
      case NotificationType.grievanceUpdate:
        return AppConstants.primaryColor;
      case NotificationType.newReply:
        return AppConstants.successColor;
      case NotificationType.statusChange:
        return AppConstants.warningColor;
      case NotificationType.general:
        return AppConstants.textSecondaryColor;
    }
  }
} 