import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/grievance.dart';
import '../utils/constants.dart';
import 'custom_button.dart';

class GrievanceCard extends StatelessWidget {
  final Grievance grievance;
  final VoidCallback? onTap;
  final bool showActions;
  final VoidCallback? onReply;
  final VoidCallback? onStatusChange;

  const GrievanceCard({
    super.key,
    required this.grievance,
    this.onTap,
    this.showActions = false,
    this.onReply,
    this.onStatusChange,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: AppConstants.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      grievance.title,
                      style: AppConstants.subheadingStyle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  _buildStatusChip(),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                grievance.description,
                style: AppConstants.bodyStyle,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.business,
                    size: 16,
                    color: AppConstants.textSecondaryColor,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    grievance.department,
                    style: AppConstants.captionStyle,
                  ),
                  const Spacer(),
                  Icon(
                    Icons.priority_high,
                    size: 16,
                    color: AppConstants.textSecondaryColor,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    grievance.priorityText,
                    style: AppConstants.captionStyle,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.person,
                    size: 16,
                    color: AppConstants.textSecondaryColor,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'By ${grievance.submittedBy}',
                    style: AppConstants.captionStyle,
                  ),
                  const Spacer(),
                  Icon(
                    Icons.schedule,
                    size: 16,
                    color: AppConstants.textSecondaryColor,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    DateFormat('MMM dd, yyyy').format(grievance.submittedAt),
                    style: AppConstants.captionStyle,
                  ),
                ],
              ),
              if (grievance.reply != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppConstants.backgroundColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.reply,
                            size: 16,
                            color: AppConstants.primaryColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Reply from ${grievance.repliedBy ?? 'Admin'}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppConstants.primaryColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        grievance.reply!,
                        style: AppConstants.captionStyle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
              if (showActions) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: SmallButton(
                        text: 'Reply',
                        onPressed: onReply,
                        type: ButtonType.primary,
                        icon: Icons.reply,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: SmallButton(
                        text: 'Change Status',
                        onPressed: onStatusChange,
                        type: ButtonType.outline,
                        icon: Icons.edit,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip() {
    Color chipColor;
    Color textColor;

    switch (grievance.status) {
      case GrievanceStatus.pending:
        chipColor = AppConstants.pendingColor.withAlpha((0.1 * 255).toInt());
        textColor = AppConstants.pendingColor;
        break;
      case GrievanceStatus.inProgress:
        chipColor = AppConstants.inProgressColor.withAlpha((0.1 * 255).toInt());
        textColor = AppConstants.inProgressColor;
        break;
      case GrievanceStatus.resolved:
        chipColor = AppConstants.resolvedColor.withAlpha((0.1 * 255).toInt());
        textColor = AppConstants.resolvedColor;
        break;
      case GrievanceStatus.rejected:
        chipColor = AppConstants.rejectedColor.withAlpha((0.1 * 255).toInt());
        textColor = AppConstants.rejectedColor;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: chipColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        grievance.statusText,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }
}

// Compact grievance card for lists
class CompactGrievanceCard extends StatelessWidget {
  final Grievance grievance;
  final VoidCallback? onTap;

  const CompactGrievanceCard({
    super.key,
    required this.grievance,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: AppConstants.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 40,
                decoration: BoxDecoration(
                  color: _getStatusColor(),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      grievance.title,
                      style: AppConstants.bodyStyle.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          grievance.department,
                          style: AppConstants.captionStyle,
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: _getStatusColor().withAlpha((0.1 * 255).toInt()),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            grievance.statusText,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: _getStatusColor(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right,
                color: AppConstants.textSecondaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor() {
    switch (grievance.status) {
      case GrievanceStatus.pending:
        return AppConstants.pendingColor;
      case GrievanceStatus.inProgress:
        return AppConstants.inProgressColor;
      case GrievanceStatus.resolved:
        return AppConstants.resolvedColor;
      case GrievanceStatus.rejected:
        return AppConstants.rejectedColor;
    }
  }
} 