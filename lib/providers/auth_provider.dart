import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';
import '../utils/dummy_data.dart';

class AuthNotifier extends StateNotifier<User?> {
  AuthNotifier() : super(null);

  // Login with email and password (mock authentication)
  Future<bool> login(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 1000));
    
    // Mock authentication logic
    try {
      final user = DummyData.users.firstWhere(
        (user) => user.email == email,
        orElse: () => throw Exception('User not found'),
      );
      
      // In a real app, you would verify the password here
      // For demo purposes, we'll accept any password
      state = user;
      return true;
    } catch (e) {
      return false;
    }
  }

  // Register new user (mock registration)
  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String studentId,
    required String department,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 1000));
    
    // Mock registration logic
    try {
      // Check if user already exists
      final existingUser = DummyData.users.any((user) => user.email == email);
      if (existingUser) {
        return false; // User already exists
      }
      
      // Create new user
      final newUser = User(
        id: DummyData.generateId(),
        name: name,
        email: email,
        studentId: studentId,
        role: UserRole.student,
        department: department,
      );
      
      // In a real app, you would save to database
      // For demo, we'll just set the current user
      state = newUser;
      return true;
    } catch (e) {
      return false;
    }
  }

  // Logout
  void logout() {
    state = null;
  }

  // Get current user
  User? get currentUser => state;

  // Check if user is logged in
  bool get isLoggedIn => state != null;

  // Check if current user is admin
  bool get isAdmin => state?.role == UserRole.admin;

  // Check if current user is student
  bool get isStudent => state?.role == UserRole.student;
}

// Provider for authentication state
final authProvider = StateNotifierProvider<AuthNotifier, User?>((ref) {
  return AuthNotifier();
});

// Provider for current user (nullable)
final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(authProvider);
});

// Provider for login status
final isLoggedInProvider = Provider<bool>((ref) {
  return ref.watch(authProvider) != null;
});

// Provider for user role
final userRoleProvider = Provider<UserRole?>((ref) {
  return ref.watch(authProvider)?.role;
});

// Provider for isAdmin status
final isAdminProvider = Provider<bool>((ref) {
  return ref.watch(authProvider)?.role == UserRole.admin;
});

// Provider for isStudent status
final isStudentProvider = Provider<bool>((ref) {
  return ref.watch(authProvider)?.role == UserRole.student;
}); 