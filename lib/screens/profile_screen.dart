import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../utils/constants.dart';
import '../widgets/custom_button.dart';
import '../models/user.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);

    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          backgroundColor: AppConstants.primaryColor,
          foregroundColor: Colors.white,
        ),
        body: const Center(
          child: Text('User not found'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          children: [
            // Profile Header
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.paddingLarge),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: AppConstants.primaryColor.withAlpha((0.1 * 255).toInt()),
                      child: Icon(
                        user.role == UserRole.admin ? Icons.admin_panel_settings : Icons.person,
                        size: 50,
                        color: AppConstants.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      user.name,
                      style: AppConstants.headingStyle,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      user.email,
                      style: AppConstants.bodyStyle.copyWith(
                        color: AppConstants.textSecondaryColor,
                      ),
                    ),
                    if (user.role == UserRole.student) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Student ID: ${user.studentId}',
                        style: AppConstants.captionStyle,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Department: ${user.department}',
                        style: AppConstants.captionStyle,
                      ),
                    ],
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppConstants.primaryColor.withAlpha((0.1 * 255).toInt()),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        user.role == UserRole.admin ? 'Administrator' : 'Student',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppConstants.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Actions
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.paddingLarge),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Account Actions',
                      style: AppConstants.subheadingStyle,
                    ),
                    const SizedBox(height: 16),
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
            ),
          ],
        ),
      ),
    );
  }
} 