import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/grievance.dart';
import '../utils/dummy_data.dart';

class GrievanceNotifier extends StateNotifier<List<Grievance>> {
  GrievanceNotifier() : super(DummyData.grievances);

  // Get all grievances
  List<Grievance> get allGrievances => state;

  // Get grievances by student ID
  List<Grievance> getGrievancesByStudentId(String studentId) {
    return state.where((grievance) => grievance.submittedById == studentId).toList();
  }

  // Get grievances by status
  List<Grievance> getGrievancesByStatus(GrievanceStatus status) {
    return state.where((grievance) => grievance.status == status).toList();
  }

  // Get grievances by department
  List<Grievance> getGrievancesByDepartment(String department) {
    return state.where((grievance) => grievance.department == department).toList();
  }

  // Add new grievance
  void addGrievance(Grievance grievance) {
    state = [...state, grievance];
  }

  // Update grievance
  void updateGrievance(Grievance updatedGrievance) {
    state = state.map((grievance) {
      if (grievance.id == updatedGrievance.id) {
        return updatedGrievance;
      }
      return grievance;
    }).toList();
  }

  // Update grievance status
  void updateGrievanceStatus(String grievanceId, GrievanceStatus newStatus) {
    state = state.map((grievance) {
      if (grievance.id == grievanceId) {
        return grievance.copyWith(status: newStatus);
      }
      return grievance;
    }).toList();
  }

  // Add reply to grievance
  void addReply(String grievanceId, String reply, String repliedBy) {
    state = state.map((grievance) {
      if (grievance.id == grievanceId) {
        return grievance.copyWith(
          reply: reply,
          repliedAt: DateTime.now(),
          repliedBy: repliedBy,
        );
      }
      return grievance;
    }).toList();
  }

  // Delete grievance
  void deleteGrievance(String grievanceId) {
    state = state.where((grievance) => grievance.id != grievanceId).toList();
  }

  // Get grievance by ID
  Grievance? getGrievanceById(String grievanceId) {
    try {
      return state.firstWhere((grievance) => grievance.id == grievanceId);
    } catch (e) {
      return null;
    }
  }

  // Get statistics
  Map<String, int> getStatistics() {
    final total = state.length;
    final pending = state.where((g) => g.status == GrievanceStatus.pending).length;
    final inProgress = state.where((g) => g.status == GrievanceStatus.inProgress).length;
    final resolved = state.where((g) => g.status == GrievanceStatus.resolved).length;
    final rejected = state.where((g) => g.status == GrievanceStatus.rejected).length;

    return {
      'total': total,
      'pending': pending,
      'inProgress': inProgress,
      'resolved': resolved,
      'rejected': rejected,
    };
  }

  // Filter grievances
  List<Grievance> filterGrievances({
    GrievanceStatus? status,
    String? department,
    String? searchQuery,
  }) {
    List<Grievance> filtered = state;

    if (status != null) {
      filtered = filtered.where((g) => g.status == status).toList();
    }

    if (department != null && department.isNotEmpty) {
      filtered = filtered.where((g) => g.department == department).toList();
    }

    if (searchQuery != null && searchQuery.isNotEmpty) {
      filtered = filtered.where((g) =>
          g.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
          g.description.toLowerCase().contains(searchQuery.toLowerCase()) ||
          g.submittedBy.toLowerCase().contains(searchQuery.toLowerCase())).toList();
    }

    return filtered;
  }
}

// Provider for grievance state
final grievanceProvider = StateNotifierProvider<GrievanceNotifier, List<Grievance>>((ref) {
  return GrievanceNotifier();
});

// Provider for all grievances
final allGrievancesProvider = Provider<List<Grievance>>((ref) {
  return ref.watch(grievanceProvider);
});

// Provider for grievance statistics
final grievanceStatisticsProvider = Provider<Map<String, int>>((ref) {
  final grievanceNotifier = ref.watch(grievanceProvider.notifier);
  return grievanceNotifier.getStatistics();
});

// Provider for filtered grievances
final filteredGrievancesProvider = Provider.family<List<Grievance>, Map<String, dynamic>>((ref, filters) {
  final grievanceNotifier = ref.watch(grievanceProvider.notifier);
  return grievanceNotifier.filterGrievances(
    status: filters['status'] as GrievanceStatus?,
    department: filters['department'] as String?,
    searchQuery: filters['searchQuery'] as String?,
  );
});

// Provider for student grievances
final studentGrievancesProvider = Provider.family<List<Grievance>, String>((ref, studentId) {
  final grievanceNotifier = ref.watch(grievanceProvider.notifier);
  return grievanceNotifier.getGrievancesByStudentId(studentId);
});

// Provider for specific grievance
final grievanceByIdProvider = Provider.family<Grievance?, String>((ref, grievanceId) {
  final grievanceNotifier = ref.watch(grievanceProvider.notifier);
  return grievanceNotifier.getGrievanceById(grievanceId);
}); 