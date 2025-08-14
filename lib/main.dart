import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'utils/constants.dart';
import 'utils/router.dart';

void main() {
  runApp(const ProviderScope(child: StudentGrievancePortalApp()));
}

class StudentGrievancePortalApp extends ConsumerWidget {
  const StudentGrievancePortalApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Student Grievance Portal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppConstants.primaryColor,
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppConstants.primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
        cardTheme: CardThemeData(
          elevation: AppConstants.cardElevation,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppConstants.surfaceColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            borderSide: const BorderSide(
              color: AppConstants.primaryColor,
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            borderSide: const BorderSide(
              color: AppConstants.errorColor,
              width: 2,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            borderSide: const BorderSide(
              color: AppConstants.errorColor,
              width: 2,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
        textTheme: const TextTheme(
          headlineLarge: AppConstants.headingStyle,
          headlineMedium: AppConstants.subheadingStyle,
          bodyLarge: AppConstants.bodyStyle,
          bodyMedium: AppConstants.captionStyle,
        ),
      ),
      routerConfig: router,
    );
  }
}
