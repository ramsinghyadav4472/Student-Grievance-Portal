import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:file_picker/file_picker.dart';
import '../../models/grievance.dart';
import '../../providers/auth_provider.dart';
import '../../providers/grievance_provider.dart';
import '../../providers/notification_provider.dart';
import '../../utils/constants.dart';
import '../../utils/dummy_data.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class SubmitGrievanceScreen extends ConsumerStatefulWidget {
  const SubmitGrievanceScreen({super.key});

  @override
  ConsumerState<SubmitGrievanceScreen> createState() => _SubmitGrievanceScreenState();
}

class _SubmitGrievanceScreenState extends ConsumerState<SubmitGrievanceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _selectedDepartment;
  int _selectedPriority = 3;
  final List<String> _attachments = [];
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickFiles() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'doc', 'docx'],
      );

      if (result != null) {
        setState(() {
          _attachments.addAll(result.files.map((file) => file.name));
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking files: ${e.toString()}'),
          backgroundColor: AppConstants.errorColor,
        ),
      );
    }
  }

  void _removeAttachment(int index) {
    setState(() {
      _attachments.removeAt(index);
    });
  }

  Future<void> _submitGrievance() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDepartment == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a department'),
          backgroundColor: AppConstants.errorColor,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final user = ref.read(currentUserProvider);
      if (user == null) {
        throw Exception('User not found');
      }

      final newGrievance = Grievance(
        id: DummyData.generateId(),
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        department: _selectedDepartment!,
        status: GrievanceStatus.pending,
        submittedBy: user.name,
        submittedById: user.id,
        submittedAt: DateTime.now(),
        attachments: _attachments,
        priority: _selectedPriority,
      );

      // Add grievance to state
      ref.read(grievanceProvider.notifier).addGrievance(newGrievance);

      // Create notification for admins
      ref.read(notificationProvider.notifier).createNewGrievanceNotification(
        adminUserId: 'admin1', // Notify first admin
        grievanceId: newGrievance.id,
        submittedBy: user.name,
        grievanceTitle: newGrievance.title,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Grievance submitted successfully!'),
            backgroundColor: AppConstants.successColor,
          ),
        );
        context.go(AppConstants.myGrievancesRoute);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit grievance: ${e.toString()}'),
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
        title: const Text('Submit Grievance'),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Card(
                elevation: AppConstants.cardElevation,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.paddingMedium),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: AppConstants.primaryColor.withAlpha(25),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.add_circle,
                          color: AppConstants.primaryColor,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Submit New Grievance',
                              style: AppConstants.subheadingStyle,
                            ),
                            Text(
                              'Report an issue or concern',
                              style: AppConstants.captionStyle,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Form Fields
              Card(
                elevation: AppConstants.cardElevation,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.paddingLarge),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CustomTextField(
                        label: 'Title',
                        hint: 'Enter a brief title for your grievance',
                        controller: _titleController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a title';
                          }
                          if (value.length < 5) {
                            return 'Title must be at least 5 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      CustomDropdownField<String>(
                        label: 'Department',
                        hint: 'Select the relevant department',
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
                            return 'Please select a department';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        label: 'Description',
                        hint: 'Provide detailed description of your grievance',
                        controller: _descriptionController,
                        maxLines: 5,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a description';
                          }
                          if (value.length < 20) {
                            return 'Description must be at least 20 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      _buildPrioritySelector(),
                      const SizedBox(height: 20),
                      _buildFileUploadSection(),
                      const SizedBox(height: 24),
                      CustomButton(
                        text: 'Submit Grievance',
                        onPressed: _submitGrievance,
                        isLoading: _isLoading,
                        icon: Icons.send,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPrioritySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Priority Level',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppConstants.textPrimaryColor,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: AppConstants.backgroundColor,
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          ),
          child: Row(
            children: List.generate(5, (index) {
              final priority = index + 1;
              final isSelected = _selectedPriority == priority;
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedPriority = priority;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? AppConstants.primaryColor : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Text(
                          priority.toString(),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : AppConstants.textPrimaryColor,
                          ),
                        ),
                        Text(
                          AppConstants.priorityLevels[index],
                          style: TextStyle(
                            fontSize: 10,
                            color: isSelected ? Colors.white70 : AppConstants.textSecondaryColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildFileUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Attachments (Optional)',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppConstants.textPrimaryColor,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(
              color: AppConstants.textSecondaryColor.withAlpha(76),
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          ),
          child: Column(
            children: [
              if (_attachments.isEmpty) ...[
                Icon(
                  Icons.attach_file,
                  size: 48,
                  color: AppConstants.textSecondaryColor,
                ),
                const SizedBox(height: 16),
                Text(
                  'No files attached',
                  style: AppConstants.bodyStyle.copyWith(
                    color: AppConstants.textSecondaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Upload supporting documents (images, PDFs, documents)',
                  style: AppConstants.captionStyle,
                  textAlign: TextAlign.center,
                ),
              ] else ...[
                ..._attachments.asMap().entries.map((entry) {
                  final index = entry.key;
                  final fileName = entry.value;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppConstants.backgroundColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.attach_file,
                          size: 20,
                          color: AppConstants.primaryColor,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            fileName,
                            style: AppConstants.bodyStyle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, size: 18),
                          onPressed: () => _removeAttachment(index),
                          color: AppConstants.errorColor,
                        ),
                      ],
                    ),
                  );
                }),
              ],
              const SizedBox(height: 16),
              CustomButton(
                text: _attachments.isEmpty ? 'Add Files' : 'Add More Files',
                onPressed: _pickFiles,
                type: ButtonType.outline,
                icon: Icons.upload_file,
              ),
            ],
          ),
        ),
      ],
    );
  }
} 