import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../models/user.dart';
import '../../providers/auth_provider.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    // Pre-fill with demo credentials
    _emailController.text = 'ramsinghyadav12@university.edu';
    _passwordController.text = 'password123';
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final success = await ref.read(authProvider.notifier).login(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (success) {
        if (mounted) {
          final user = ref.read(authProvider);
          if (user?.role == UserRole.admin) {
            context.go(AppConstants.adminDashboardRoute);
          } else {
            context.go(AppConstants.studentDashboardRoute);
          }
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Invalid email or password'),
              backgroundColor: AppConstants.errorColor,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login failed: ${e.toString()}'),
            backgroundColor: AppConstants.errorColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.paddingLarge),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo and Title
                  Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppConstants.primaryColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.school,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Student Grievance Portal',
                        style: AppConstants.headingStyle.copyWith(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Sign in to your account',
                        style: AppConstants.bodyStyle.copyWith(
                          color: AppConstants.textSecondaryColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  const SizedBox(height: 48),

                  // Login Form
                  Card(
                    elevation: AppConstants.cardElevation,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(AppConstants.paddingLarge),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            CustomTextField(
                              label: 'Email',
                              hint: 'Enter your email address',
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              prefixIcon: const Icon(Icons.email),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                    .hasMatch(value)) {
                                  return 'Please enter a valid email';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            CustomTextField(
                              label: 'Password',
                              hint: 'Enter your password',
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              prefixIcon: const Icon(Icons.lock),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                if (value.length < 6) {
                                  return 'Password must be at least 6 characters';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 24),
                            CustomButton(
                              text: 'Sign In',
                              onPressed: _handleLogin,
                              isLoading: _isLoading,
                              icon: Icons.login,
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: Divider(
                                    color: AppConstants.textSecondaryColor.withAlpha(77),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: Text(
                                    'OR',
                                    style: AppConstants.captionStyle,
                                  ),
                                ),
                                Expanded(
                                  child: Divider(
                                    color: AppConstants.textSecondaryColor.withAlpha(77),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            CustomButton(
                              text: 'Create Account',
                              onPressed: () => context.go(AppConstants.registerRoute),
                              type: ButtonType.outline,
                              icon: Icons.person_add,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Demo Credentials
                  Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(AppConstants.paddingMedium),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Demo Credentials:',
                            style: AppConstants.bodyStyle.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          _buildDemoCredential('Student', 'ramsinghyadav12@university.edu', 'password123'),
                          const SizedBox(height: 4),
                          _buildDemoCredential('Admin', 'rsyadav.admin@university.edu', 'password123'),
                        ],
                      ),
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

  Widget _buildDemoCredential(String role, String email, String password) {
    return Row(
      children: [
        Text(
          '$role: ',
          style: AppConstants.captionStyle.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        Expanded(
          child: Text(
            '$email / $password',
            style: AppConstants.captionStyle,
          ),
        ),
      ],
    );
  }
} 