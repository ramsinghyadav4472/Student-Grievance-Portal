import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../models/grievance.dart';
import '../../providers/grievance_provider.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_button.dart';

// Add GrievanceStatusExtension for statusText if not present
extension GrievanceStatusExtension on GrievanceStatus {
  String get statusText {
    switch (this) {
      case GrievanceStatus.pending:
        return 'Pending';
      case GrievanceStatus.inProgress:
        return 'In Progress';
      case GrievanceStatus.resolved:
        return 'Resolved';
      case GrievanceStatus.rejected:
        return 'Rejected';
    }
  }
}

class GrievanceDetailsScreen extends ConsumerWidget {
  final String grievanceId;

  const GrievanceDetailsScreen({
    super.key,
    required this.grievanceId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final grievance = ref.watch(grievanceByIdProvider(grievanceId));

    if (grievance == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Grievance Details'),
          backgroundColor: AppConstants.primaryColor,
          foregroundColor: Colors.white,
        ),
        body: const Center(
          child: Text('Grievance not found'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        title: const Text('Grievance Details'),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.paddingLarge),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            grievance.title,
                            style: AppConstants.headingStyle,
                          ),
                        ),
                        const SizedBox(width: 12),
                        _buildStatusChip(grievance.status),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow('Department', grievance.department, Icons.business),
                    const SizedBox(height: 8),
                    _buildInfoRow('Priority', grievance.priorityText, Icons.priority_high),
                    const SizedBox(height: 8),
                    _buildInfoRow('Submitted by', grievance.submittedBy, Icons.person),
                    const SizedBox(height: 8),
                    _buildInfoRow(
                      'Submitted on',
                      DateFormat('MMM dd, yyyy - HH:mm').format(grievance.submittedAt),
                      Icons.schedule,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Description Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.paddingLarge),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Description',
                      style: AppConstants.subheadingStyle,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      grievance.description,
                      style: AppConstants.bodyStyle,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Attachments Card (if any)
            if (grievance.attachments.isNotEmpty) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.paddingLarge),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Attachments',
                        style: AppConstants.subheadingStyle,
                      ),
                      const SizedBox(height: 12),
                      ...grievance.attachments.map((attachment) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.attach_file,
                              color: AppConstants.primaryColor,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                attachment,
                                style: AppConstants.bodyStyle,
                              ),
                            ),
                          ],
                        ),
                      )),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Reply Card (if any)
            if (grievance.reply != null) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.paddingLarge),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.reply,
                            color: AppConstants.primaryColor,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Reply from ${grievance.repliedBy ?? 'Admin'}',
                            style: AppConstants.subheadingStyle,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        grievance.repliedAt != null
                            ? DateFormat('MMM dd, yyyy - HH:mm').format(grievance.repliedAt!)
                            : '',
                        style: AppConstants.captionStyle,
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppConstants.backgroundColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          grievance.reply!,
                          style: AppConstants.bodyStyle,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Actions (for admin)
            if (grievance.status != GrievanceStatus.resolved) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.paddingLarge),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Actions',
                        style: AppConstants.subheadingStyle,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: CustomButton(
                              text: 'Reply',
                              onPressed: () => _showReplyDialog(context, ref, grievance),
                              type: ButtonType.primary,
                              icon: Icons.reply,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: CustomButton(
                              text: 'Change Status',
                              onPressed: () => _showStatusDialog(context, ref, grievance),
                              type: ButtonType.outline,
                              icon: Icons.edit,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(GrievanceStatus status) {
    Color chipColor;
    Color textColor;

    switch (status) {
      case GrievanceStatus.pending:
        chipColor = AppConstants.pendingColor.withAlpha(25);
        textColor = AppConstants.pendingColor;
        break;
      case GrievanceStatus.inProgress:
        chipColor = AppConstants.inProgressColor.withAlpha(25);
        textColor = AppConstants.inProgressColor;
        break;
      case GrievanceStatus.resolved:
        chipColor = AppConstants.resolvedColor.withAlpha(25);
        textColor = AppConstants.resolvedColor;
        break;
      case GrievanceStatus.rejected:
        chipColor = AppConstants.rejectedColor.withAlpha(25);
        textColor = AppConstants.rejectedColor;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: chipColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        status.statusText,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: AppConstants.textSecondaryColor,
        ),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: AppConstants.captionStyle.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: AppConstants.captionStyle,
          ),
        ),
      ],
    );
  }

  void _showReplyDialog(BuildContext context, WidgetRef ref, Grievance grievance) {
    final replyController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Reply'),
        content: TextField(
          controller: replyController,
          maxLines: 4,
          decoration: const InputDecoration(
            hintText: 'Enter your reply...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (replyController.text.trim().isNotEmpty) {
                ref.read(grievanceProvider.notifier).addReply(
                  grievance.id,
                  replyController.text.trim(),
                  'Admin',
                );
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Reply added successfully'),
                    backgroundColor: AppConstants.successColor,
                  ),
                );
              }
            },
            child: const Text('Send Reply'),
          ),
        ],
      ),
    );
  }

  void _showStatusDialog(BuildContext context, WidgetRef ref, Grievance grievance) {
    GrievanceStatus selectedStatus = grievance.status;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Status'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: GrievanceStatus.values.map((status) {
            return RadioListTile<GrievanceStatus>(
              title: Text(status.statusText),
              value: status,
              groupValue: selectedStatus,
              onChanged: (value) {
                selectedStatus = value!;
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(grievanceProvider.notifier).updateGrievanceStatus(
                grievance.id,
                selectedStatus,
              );
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Status updated to ${selectedStatus.statusText}'),
                  backgroundColor: AppConstants.successColor,
                ),
              );
            },
            child: const Text('Update Status'),
          ),
        ],
      ),
    );
  }
} 