enum UserRole { student, admin }

class User {
  final String id;
  final String name;
  final String email;
  final String studentId; // Only for students
  final UserRole role;
  final String department; // Only for students
  final String? profileImage;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.studentId = '',
    this.department = '',
    this.profileImage,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      role: UserRole.values.firstWhere(
        (e) => e.toString() == 'UserRole.${json['role']}',
      ),
      studentId: json['studentId'] as String? ?? '',
      department: json['department'] as String? ?? '',
      profileImage: json['profileImage'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role.toString().split('.').last,
      'studentId': studentId,
      'department': department,
      'profileImage': profileImage,
    };
  }

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? studentId,
    UserRole? role,
    String? department,
    String? profileImage,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      studentId: studentId ?? this.studentId,
      role: role ?? this.role,
      department: department ?? this.department,
      profileImage: profileImage ?? this.profileImage,
    );
  }
} 