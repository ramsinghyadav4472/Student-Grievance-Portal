import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';
import '../../providers/grievance_provider.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_button.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final statistics = ref.watch(grievanceStatisticsProvider);

    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(authProvider.notifier).logout();
              context.go(AppConstants.loginRoute);
            },
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
                              Icons.admin_panel_settings,
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
                                  'Welcome, Admin!',
                                  style: AppConstants.headingStyle.copyWith(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                                Text(
                                  user?.name ?? 'Administrator',
                                  style: AppConstants.bodyStyle.copyWith(
                                    color: Colors.white.withAlpha(204),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Statistics
            Text(
              'Grievance Overview',
              style: AppConstants.subheadingStyle,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Total',
                    statistics['total'].toString(),
                    AppConstants.primaryColor,
                    Icons.list_alt,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    'Pending',
                    statistics['pending'].toString(),
                    AppConstants.pendingColor,
                    Icons.schedule,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'In Progress',
                    statistics['inProgress'].toString(),
                    AppConstants.inProgressColor,
                    Icons.engineering,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    'Resolved',
                    statistics['resolved'].toString(),
                    AppConstants.resolvedColor,
                    Icons.check_circle,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Quick Actions
            Text(
              'Quick Actions',
              style: AppConstants.subheadingStyle,
            ),
            const SizedBox(height: 16),
            CustomButton(
              text: 'View All Grievances',
              onPressed: () => context.go(AppConstants.adminGrievancesRoute),
              icon: Icons.list_alt,
            ),
            const SizedBox(height: 12),
            CustomButton(
              text: 'View Notifications',
              onPressed: () => context.go(AppConstants.notificationsRoute),
              type: ButtonType.outline,
              icon: Icons.notifications,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String count, Color color, IconData icon) {
    return Card(
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
} 