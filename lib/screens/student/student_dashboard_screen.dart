import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';
import '../../providers/grievance_provider.dart';
import '../../providers/notification_provider.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_button.dart';
import '../../models/grievance.dart';

class StudentDashboardScreen extends ConsumerWidget {
  const StudentDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final grievances = ref.watch(studentGrievancesProvider(user?.id ?? ''));
    final unreadNotifications = ref.watch(unreadNotificationsProvider(user?.id ?? ''));

    final pendingCount = grievances.where((g) => g.status == GrievanceStatus.pending).length;
    final inProgressCount = grievances.where((g) => g.status == GrievanceStatus.inProgress).length;
    final resolvedCount = grievances.where((g) => g.status == GrievanceStatus.resolved).length;

    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        title: const Text('Student Dashboard'),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.notifications),
                if (unreadNotifications.isNotEmpty)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: AppConstants.errorColor,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '${unreadNotifications.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            onPressed: () => context.go(AppConstants.notificationsRoute),
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => context.go(AppConstants.profileRoute),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            Card(
              elevation: AppConstants.cardElevation,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                  gradient: const LinearGradient(
                    colors: [AppConstants.primaryColor, AppConstants.secondaryColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.paddingLarge),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.white.withAlpha(51),
                            child: const Icon(
                              Icons.person,
                              size: 30,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Welcome back,',
                                  style: AppConstants.bodyStyle.copyWith(
                                    color: Colors.white.withAlpha(204),
                                  ),
                                ),
                                Text(
                                  user?.name ?? 'Student',
                                  style: AppConstants.headingStyle.copyWith(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                                Text(
                                  user?.department ?? 'Department',
                                  style: AppConstants.captionStyle.copyWith(
                                    color: Colors.white.withAlpha(204),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'How can we help you today?',
                        style: AppConstants.bodyStyle.copyWith(
                          color: Colors.white.withAlpha(230),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Quick Actions
            Text(
              'Quick Actions',
              style: AppConstants.subheadingStyle,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildActionCard(
                    context,
                    icon: Icons.add_circle,
                    title: 'Submit Grievance',
                    subtitle: 'Report an issue',
                    color: AppConstants.primaryColor,
                    onTap: () => context.go(AppConstants.submitGrievanceRoute),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildActionCard(
                    context,
                    icon: Icons.list_alt,
                    title: 'My Grievances',
                    subtitle: 'View your reports',
                    color: AppConstants.accentColor,
                    onTap: () => context.go(AppConstants.myGrievancesRoute),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Statistics
            Text(
              'Your Grievances Overview',
              style: AppConstants.subheadingStyle,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Pending',
                    pendingCount.toString(),
                    AppConstants.pendingColor,
                    Icons.schedule,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    'In Progress',
                    inProgressCount.toString(),
                    AppConstants.inProgressColor,
                    Icons.engineering,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    'Resolved',
                    resolvedCount.toString(),
                    AppConstants.resolvedColor,
                    Icons.check_circle,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Recent Grievances
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Grievances',
                  style: AppConstants.subheadingStyle,
                ),
                TextButton(
                  onPressed: () => context.go(AppConstants.myGrievancesRoute),
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (grievances.isEmpty)
              Card(
                elevation: AppConstants.cardElevation,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.paddingLarge),
                  child: Column(
                    children: [
                      Icon(
                        Icons.inbox,
                        size: 48,
                        color: AppConstants.textSecondaryColor,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No grievances yet',
                        style: AppConstants.bodyStyle.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Submit your first grievance to get started',
                        style: AppConstants.captionStyle,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      CustomButton(
                        text: 'Submit Grievance',
                        onPressed: () => context.go(AppConstants.submitGrievanceRoute),
                        type: ButtonType.primary,
                        icon: Icons.add,
                      ),
                    ],
                  ),
                ),
              )
            else
              ...grievances.take(3).map((grievance) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildGrievanceItem(context, grievance),
              )),
            const SizedBox(height: 24),

            // Logout Button
            CustomButton(
              text: 'Logout',
              onPressed: () {
                ref.read(authProvider.notifier).logout();
                context.go(AppConstants.loginRoute);
              },
              type: ButtonType.danger,
              icon: Icons.logout,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
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
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: color.withAlpha(25),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: AppConstants.bodyStyle.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: AppConstants.captionStyle,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String count, Color color, IconData icon) {
    return Card(
      elevation: AppConstants.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withAlpha(25),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: color,
                size: 20,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              count,
              style: AppConstants.headingStyle.copyWith(
                fontSize: 24,
                color: color,
              ),
            ),
            Text(
              title,
              style: AppConstants.captionStyle,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGrievanceItem(BuildContext context, grievance) {
    return Card(
      elevation: AppConstants.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: _getStatusColor(grievance.status).withAlpha(25),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _getStatusIcon(grievance.status),
            color: _getStatusColor(grievance.status),
            size: 20,
          ),
        ),
        title: Text(
          grievance.title,
          style: AppConstants.bodyStyle.copyWith(
            fontWeight: FontWeight.w600,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          grievance.department,
          style: AppConstants.captionStyle,
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _getStatusColor(grievance.status).withAlpha(25),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            grievance.statusText,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: _getStatusColor(grievance.status),
            ),
          ),
        ),
        onTap: () => context.go('${AppConstants.grievanceDetailsRoute}?id=${grievance.id}'),
      ),
    );
  }

  Color _getStatusColor(status) {
    switch (status) {
      case GrievanceStatus.pending:
        return AppConstants.pendingColor;
      case GrievanceStatus.inProgress:
        return AppConstants.inProgressColor;
      case GrievanceStatus.resolved:
        return AppConstants.resolvedColor;
      case GrievanceStatus.rejected:
        return AppConstants.rejectedColor;
      default:
        return AppConstants.textSecondaryColor;
    }
  }

  IconData _getStatusIcon(status) {
    switch (status) {
      case GrievanceStatus.pending:
        return Icons.schedule;
      case GrievanceStatus.inProgress:
        return Icons.engineering;
      case GrievanceStatus.resolved:
        return Icons.check_circle;
      case GrievanceStatus.rejected:
        return Icons.cancel;
      default:
        return Icons.info;
    }
  }
} 