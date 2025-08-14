enum GrievanceStatus { pending, inProgress, resolved, rejected }

class Grievance {
  final String id;
  final String title;
  final String description;
  final String department;
  final GrievanceStatus status;
  final String submittedBy;
  final String submittedById;
  final DateTime submittedAt;
  final String? reply;
  final DateTime? repliedAt;
  final String? repliedBy;
  final List<String> attachments; // File names/paths
  final int priority; // 1-5, 5 being highest

  const Grievance({
    required this.id,
    required this.title,
    required this.description,
    required this.department,
    required this.status,
    required this.submittedBy,
    required this.submittedById,
    required this.submittedAt,
    this.reply,
    this.repliedAt,
    this.repliedBy,
    this.attachments = const [],
    this.priority = 3,
  });

  factory Grievance.fromJson(Map<String, dynamic> json) {
    return Grievance(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      department: json['department'] as String,
      status: GrievanceStatus.values.firstWhere(
        (e) => e.toString() == 'GrievanceStatus.${json['status']}',
      ),
      submittedBy: json['submittedBy'] as String,
      submittedById: json['submittedById'] as String,
      submittedAt: DateTime.parse(json['submittedAt'] as String),
      reply: json['reply'] as String?,
      repliedAt: json['repliedAt'] != null 
          ? DateTime.parse(json['repliedAt'] as String) 
          : null,
      repliedBy: json['repliedBy'] as String?,
      attachments: List<String>.from(json['attachments'] ?? []),
      priority: json['priority'] as int? ?? 3,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'department': department,
      'status': status.toString().split('.').last,
      'submittedBy': submittedBy,
      'submittedById': submittedById,
      'submittedAt': submittedAt.toIso8601String(),
      'reply': reply,
      'repliedAt': repliedAt?.toIso8601String(),
      'repliedBy': repliedBy,
      'attachments': attachments,
      'priority': priority,
    };
  }

  Grievance copyWith({
    String? id,
    String? title,
    String? description,
    String? department,
    GrievanceStatus? status,
    String? submittedBy,
    String? submittedById,
    DateTime? submittedAt,
    String? reply,
    DateTime? repliedAt,
    String? repliedBy,
    List<String>? attachments,
    int? priority,
  }) {
    return Grievance(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      department: department ?? this.department,
      status: status ?? this.status,
      submittedBy: submittedBy ?? this.submittedBy,
      submittedById: submittedById ?? this.submittedById,
      submittedAt: submittedAt ?? this.submittedAt,
      reply: reply ?? this.reply,
      repliedAt: repliedAt ?? this.repliedAt,
      repliedBy: repliedBy ?? this.repliedBy,
      attachments: attachments ?? this.attachments,
      priority: priority ?? this.priority,
    );
  }

  String get statusText {
    switch (status) {
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

  String get priorityText {
    switch (priority) {
      case 1:
        return 'Very Low';
      case 2:
        return 'Low';
      case 3:
        return 'Medium';
      case 4:
        return 'High';
      case 5:
        return 'Very High';
      default:
        return 'Medium';
    }
  }
} 