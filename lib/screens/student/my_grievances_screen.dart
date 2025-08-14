import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../models/grievance.dart';
import '../../providers/auth_provider.dart';
import '../../providers/grievance_provider.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/grievance_card.dart';

extension GrievanceStatusExtension on GrievanceStatus {
  String get statusText {
    switch (this) {
      case GrievanceStatus.pending:
        return 'Pending';
      case GrievanceStatus.inProgress:
        return 'In Progress';
      case GrievanceStatus.resolved:
        return 'Resolved';
      case GrievanceStatus.rejected:
        return 'Rejected';
    }
  }
}

class MyGrievancesScreen extends ConsumerStatefulWidget {
  const MyGrievancesScreen({super.key});

  @override
  ConsumerState<MyGrievancesScreen> createState() => _MyGrievancesScreenState();
}

class _MyGrievancesScreenState extends ConsumerState<MyGrievancesScreen> {
  final _searchController = TextEditingController();
  GrievanceStatus? _selectedStatus;
  String? _selectedDepartment;
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final grievances = ref.watch(studentGrievancesProvider(user?.id ?? ''));

    // Filter grievances based on search and filters
    final filteredGrievances = grievances.where((grievance) {
      // Status filter
      if (_selectedStatus != null && grievance.status != _selectedStatus) {
        return false;
      }
      
      // Department filter
      if (_selectedDepartment != null && grievance.department != _selectedDepartment) {
        return false;
      }
      
      // Search query
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        return grievance.title.toLowerCase().contains(query) ||
               grievance.description.toLowerCase().contains(query) ||
               grievance.department.toLowerCase().contains(query);
      }
      
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        title: const Text('My Grievances'),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search and Filters
          Container(
            padding: const EdgeInsets.all(AppConstants.paddingMedium),
            color: AppConstants.surfaceColor,
            child: Column(
              children: [
                SearchField(
                  hint: 'Search grievances...',
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildFilterDropdown<GrievanceStatus>(
                        label: 'Status',
                        value: _selectedStatus,
                        items: GrievanceStatus.values,
                        itemToString: (status) => status.statusText,
                        onChanged: (value) {
                          setState(() {
                            _selectedStatus = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildFilterDropdown<String>(
                        label: 'Department',
                        value: _selectedDepartment,
                        items: AppConstants.departments,
                        itemToString: (dept) => dept,
                        onChanged: (value) {
                          setState(() {
                            _selectedDepartment = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      '${filteredGrievances.length} grievance${filteredGrievances.length != 1 ? 's' : ''} found',
                      style: AppConstants.captionStyle,
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _selectedStatus = null;
                          _selectedDepartment = null;
                          _searchQuery = '';
                          _searchController.clear();
                        });
                      },
                      child: const Text('Clear Filters'),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Grievances List
          Expanded(
            child: filteredGrievances.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(AppConstants.paddingMedium),
                    itemCount: filteredGrievances.length,
                    itemBuilder: (context, index) {
                      final grievance = filteredGrievances[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: GrievanceCard(
                          grievance: grievance,
                          onTap: () => context.go(
                            '${AppConstants.grievanceDetailsRoute}?id=${grievance.id}',
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go(AppConstants.submitGrievanceRoute),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildFilterDropdown<T>({
    required String label,
    required T? value,
    required List<T> items,
    required String Function(T) itemToString,
    required void Function(T?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppConstants.textSecondaryColor,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: AppConstants.backgroundColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.withAlpha(76)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: value,
              hint: Text(
                'All $label',
                style: const TextStyle(fontSize: 14),
              ),
              isExpanded: true,
              items: [
                DropdownMenuItem<T>(
                  value: null,
                  child: Text('All'),
                ),
                ...items.map((item) => DropdownMenuItem<T>(
                  value: item,
                  child: Text(
                    itemToString(item),
                    style: const TextStyle(fontSize: 14),
                  ),
                )),
              ],
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox,
            size: 64,
            color: AppConstants.textSecondaryColor,
          ),
          const SizedBox(height: 16),
          Text(
            'No grievances found',
            style: AppConstants.bodyStyle.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search or filters',
            style: AppConstants.captionStyle,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => context.go(AppConstants.submitGrievanceRoute),
            icon: const Icon(Icons.add),
            label: const Text('Submit New Grievance'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.primaryColor,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
} 