import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/grievance_provider.dart';
import '../../utils/constants.dart';
import '../../widgets/grievance_card.dart';
import 'package:go_router/go_router.dart';

class AdminGrievancesScreen extends ConsumerWidget {
  const AdminGrievancesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final grievances = ref.watch(allGrievancesProvider);

    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        title: const Text('All Grievances'),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        itemCount: grievances.length,
        itemBuilder: (context, index) {
          final grievance = grievances[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: GrievanceCard(
              grievance: grievance,
              showActions: true,
              onTap: () => context.go('${AppConstants.grievanceDetailsRoute}?id=${grievance.id}'),
            ),
          );
        },
      ),
    );
  }
} 