import 'package:flutter/material.dart';

class AppConstants {
  // App Colors
  static const Color primaryColor = Color(0xFF2196F3);
  static const Color secondaryColor = Color(0xFF1976D2);
  static const Color accentColor = Color(0xFF64B5F6);
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color surfaceColor = Colors.white;
  static const Color errorColor = Color(0xFFD32F2F);
  static const Color successColor = Color(0xFF388E3C);
  static const Color warningColor = Color(0xFFFFA000);
  static const Color textPrimaryColor = Color(0xFF212121);
  static const Color textSecondaryColor = Color(0xFF757575);

  // Status Colors
  static const Color pendingColor = Color(0xFFFFA000);
  static const Color inProgressColor = Color(0xFF2196F3);
  static const Color resolvedColor = Color(0xFF388E3C);
  static const Color rejectedColor = Color(0xFFD32F2F);

  // Departments
  static const List<String> departments = [
    'Computer Science',
    'Electrical Engineering',
    'Mechanical Engineering',
    'Civil Engineering',
    'Chemical Engineering',
    'Information Technology',
    'Mathematics',
    'Physics',
    'Chemistry',
    'Biology',
    'Economics',
    'Business Administration',
    'Arts & Humanities',
    'Social Sciences',
    'Library',
    'Hostel',
    'Transportation',
    'Cafeteria',
    'Sports',
    'General',
  ];

  // Priority Levels
  static const List<String> priorityLevels = [
    'Very Low',
    'Low',
    'Medium',
    'High',
    'Very High',
  ];

  // App Dimensions
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double borderRadius = 12.0;
  static const double cardElevation = 2.0;

  // Animation Durations
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration splashDuration = Duration(seconds: 2);

  // Text Styles
  static const TextStyle headingStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: textPrimaryColor,
  );

  static const TextStyle subheadingStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: textPrimaryColor,
  );

  static const TextStyle bodyStyle = TextStyle(
    fontSize: 16,
    color: textPrimaryColor,
  );

  static const TextStyle captionStyle = TextStyle(
    fontSize: 14,
    color: textSecondaryColor,
  );

  // Route Names
  static const String loginRoute = '/login';
  static const String registerRoute = '/register';
  static const String studentDashboardRoute = '/student/dashboard';
  static const String adminDashboardRoute = '/admin/dashboard';
  static const String submitGrievanceRoute = '/student/submit-grievance';
  static const String myGrievancesRoute = '/student/my-grievances';
  static const String grievanceDetailsRoute = '/grievance-details';
  static const String notificationsRoute = '/notifications';
  static const String adminGrievancesRoute = '/admin/grievances';
  static const String profileRoute = '/profile';
} 