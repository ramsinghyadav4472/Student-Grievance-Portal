import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/student/student_dashboard_screen.dart';
import '../screens/admin/admin_dashboard_screen.dart';
import '../screens/student/submit_grievance_screen.dart';
import '../screens/student/my_grievances_screen.dart';
import '../screens/grievance/grievance_details_screen.dart';
import '../screens/notifications_screen.dart';
import '../screens/admin/admin_grievances_screen.dart';
import '../screens/profile_screen.dart';
import '../providers/auth_provider.dart';
import '../models/user.dart';
import 'constants.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: AppConstants.loginRoute,
    redirect: (context, state) {
      final isLoggedIn = authState != null;
      final isLoginRoute = state.matchedLocation == AppConstants.loginRoute;
      final isRegisterRoute = state.matchedLocation == AppConstants.registerRoute;

      // If not logged in and not on login/register route, redirect to login
      if (!isLoggedIn && !isLoginRoute && !isRegisterRoute) {
        return AppConstants.loginRoute;
      }

      // If logged in and on login/register route, redirect to appropriate dashboard
      if (isLoggedIn && (isLoginRoute || isRegisterRoute)) {
        if (authState.role == UserRole.admin) {
          return AppConstants.adminDashboardRoute;
        } else {
          return AppConstants.studentDashboardRoute;
        }
      }

      // If logged in as admin and trying to access student routes, redirect to admin dashboard
      if (isLoggedIn && authState.role == UserRole.admin) {
        if (state.matchedLocation.startsWith('/student/')) {
          return AppConstants.adminDashboardRoute;
        }
      }

      // If logged in as student and trying to access admin routes, redirect to student dashboard
      if (isLoggedIn && authState.role == UserRole.student) {
        if (state.matchedLocation.startsWith('/admin/')) {
          return AppConstants.studentDashboardRoute;
        }
      }

      return null;
    },
    routes: [
      // Auth Routes
      GoRoute(
        path: AppConstants.loginRoute,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppConstants.registerRoute,
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),

      // Student Routes
      GoRoute(
        path: AppConstants.studentDashboardRoute,
        name: 'student_dashboard',
        builder: (context, state) => const StudentDashboardScreen(),
      ),
      GoRoute(
        path: AppConstants.submitGrievanceRoute,
        name: 'submit_grievance',
        builder: (context, state) => const SubmitGrievanceScreen(),
      ),
      GoRoute(
        path: AppConstants.myGrievancesRoute,
        name: 'my_grievances',
        builder: (context, state) => const MyGrievancesScreen(),
      ),

      // Admin Routes
      GoRoute(
        path: AppConstants.adminDashboardRoute,
        name: 'admin_dashboard',
        builder: (context, state) => const AdminDashboardScreen(),
      ),
      GoRoute(
        path: AppConstants.adminGrievancesRoute,
        name: 'admin_grievances',
        builder: (context, state) => const AdminGrievancesScreen(),
      ),

      // Common Routes
      GoRoute(
        path: AppConstants.grievanceDetailsRoute,
        name: 'grievance_details',
        builder: (context, state) {
          final grievanceId = state.uri.queryParameters['id'] ?? '';
          return GrievanceDetailsScreen(grievanceId: grievanceId);
        },
      ),
      GoRoute(
        path: AppConstants.notificationsRoute,
        name: 'notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: AppConstants.profileRoute,
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: AppConstants.errorColor,
            ),
            const SizedBox(height: 16),
            Text(
              'Page Not Found',
              style: AppConstants.headingStyle,
            ),
            const SizedBox(height: 8),
            Text(
              'The page you are looking for does not exist.',
              style: AppConstants.bodyStyle,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(AppConstants.loginRoute),
              child: const Text('Go to Login'),
            ),
          ],
        ),
      ),
    ),
  );
}); 