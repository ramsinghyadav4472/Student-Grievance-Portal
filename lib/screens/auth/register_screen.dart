import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _studentIdController = TextEditingController();
  String? _selectedDepartment;
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _studentIdController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final success = await ref.read(authProvider.notifier).register(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        studentId: _studentIdController.text.trim(),
        department: _selectedDepartment!,
      );

      if (success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Registration successful! Welcome to the portal.'),
              backgroundColor: AppConstants.successColor,
            ),
          );
          context.go(AppConstants.studentDashboardRoute);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Registration failed. Email might already be registered.'),
              backgroundColor: AppConstants.errorColor,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registration failed: ${e.toString()}'),
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(AppConstants.loginRoute),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.paddingLarge),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Title
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
                          Icons.person_add,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Create Account',
                        style: AppConstants.headingStyle.copyWith(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Join the Student Grievance Portal',
                        style: AppConstants.bodyStyle.copyWith(
                          color: AppConstants.textSecondaryColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Registration Form
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
                              label: 'Full Name',
                              hint: 'Enter your full name',
                              controller: _nameController,
                              prefixIcon: const Icon(Icons.person),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your name';
                                }
                                if (value.length < 2) {
                                  return 'Name must be at least 2 characters';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
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
                              label: 'Student ID',
                              hint: 'Enter your student ID',
                              controller: _studentIdController,
                              prefixIcon: const Icon(Icons.badge),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your student ID';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            CustomDropdownField<String>(
                              label: 'Department',
                              hint: 'Select your department',
                              value: _selectedDepartment,
                              items: AppConstants.departments,
                              itemToString: (dept) => dept,
                              onChanged: (value) {
                                setState(() {
                                  _selectedDepartment = value;
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select your department';
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
                            const SizedBox(height: 20),
                            CustomTextField(
                              label: 'Confirm Password',
                              hint: 'Confirm your password',
                              controller: _confirmPasswordController,
                              obscureText: _obscureConfirmPassword,
                              prefixIcon: const Icon(Icons.lock_outline),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureConfirmPassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureConfirmPassword = !_obscureConfirmPassword;
                                  });
                                },
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please confirm your password';
                                }
                                if (value != _passwordController.text) {
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 24),
                            CustomButton(
                              text: 'Create Account',
                              onPressed: _handleRegister,
                              isLoading: _isLoading,
                              icon: Icons.person_add,
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: Divider(
                                    color: AppConstants.textSecondaryColor.withAlpha(76),
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
                                    color: AppConstants.textSecondaryColor.withAlpha(76),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            CustomButton(
                              text: 'Back to Login',
                              onPressed: () => context.go(AppConstants.loginRoute),
                              type: ButtonType.outline,
                              icon: Icons.login,
                            ),
                          ],
                        ),
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
} 