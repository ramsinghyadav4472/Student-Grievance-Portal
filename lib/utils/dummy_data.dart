import 'package:uuid/uuid.dart';
import '../models/user.dart';
import '../models/grievance.dart';
import '../models/notification.dart';

class DummyData {
  static const _uuid = Uuid();

  // Mock Users
  static final List<User> users = [
    // Students
    User(
      id: 'student1',
      name: 'rsyadav',
      email: 'ramsinghyadav12@university.edu',
      studentId: '2023001',
      role: UserRole.student,
      department: 'Computer Science',
    ),
    User(
      id: 'student2',
      name: 'Jane Smith',
      email: 'jane.smith@university.edu',
      studentId: '2023002',
      role: UserRole.student,
      department: 'Electrical Engineering',
    ),
    User(
      id: 'student3',
      name: 'Mike Johnson',
      email: 'mike.johnson@university.edu',
      studentId: '2023003',
      role: UserRole.student,
      department: 'Mechanical Engineering',
    ),
    User(
      id: 'student4',
      name: 'Sarah Wilson',
      email: 'sarah.wilson@university.edu',
      studentId: '2023004',
      role: UserRole.student,
      department: 'Information Technology',
    ),
    User(
      id: 'student5',
      name: 'David Brown',
      email: 'david.brown@university.edu',
      studentId: '2023005',
      role: UserRole.student,
      department: 'Civil Engineering',
    ),

    // Admins
    User(
      id: 'admin1',
      name: 'Ram Singh Yadav',
      email: 'rsyadav.admin@university.edu',
      role: UserRole.admin,
    ),
    User(
      id: 'admin2',
      name: 'Prof. Lisa Manager',
      email: 'lisa.manager@university.edu',
      role: UserRole.admin,
    ),
  ];

  // Mock Grievances
  static final List<Grievance> grievances = [
    Grievance(
      id: 'grievance1',
      title: 'Internet Connectivity Issues in Hostel',
      description: 'The internet connection in Block A hostel has been very slow for the past week. Students are unable to attend online classes or complete assignments. Please look into this matter urgently.',
      department: 'Information Technology',
      status: GrievanceStatus.pending,
      submittedBy: 'rsyadav',
      submittedById: 'student1',
      submittedAt: DateTime.now().subtract(const Duration(days: 2)),
      priority: 4,
    ),
    Grievance(
      id: 'grievance2',
      title: 'Broken Lab Equipment',
      description: 'Several computers in the Computer Science lab (Room 301) are not working properly. Some have broken keyboards and others have display issues. This is affecting our practical sessions.',
      department: 'Computer Science',
      status: GrievanceStatus.inProgress,
      submittedBy: 'Jane Smith',
      submittedById: 'student2',
      submittedAt: DateTime.now().subtract(const Duration(days: 5)),
      reply: 'We have identified the issue and ordered replacement parts. The equipment will be fixed by next week.',
      repliedAt: DateTime.now().subtract(const Duration(days: 1)),
      repliedBy: 'Dr. Robert Admin',
      priority: 3,
    ),
    Grievance(
      id: 'grievance3',
      title: 'Cafeteria Food Quality',
      description: 'The food quality in the main cafeteria has deteriorated significantly. Many students have reported stomach issues after eating there. Please investigate the food preparation and hygiene standards.',
      department: 'Cafeteria',
      status: GrievanceStatus.resolved,
      submittedBy: 'Mike Johnson',
      submittedById: 'student3',
      submittedAt: DateTime.now().subtract(const Duration(days: 10)),
      reply: 'We have conducted a thorough inspection and addressed the hygiene issues. New quality control measures have been implemented. The cafeteria is now operating under strict food safety guidelines.',
      repliedAt: DateTime.now().subtract(const Duration(days: 3)),
      repliedBy: 'Prof. Lisa Manager',
      priority: 5,
    ),
    Grievance(
      id: 'grievance4',
      title: 'Library Book Availability',
      description: 'Many required textbooks for the current semester are not available in the library. Students are struggling to complete their assignments and research work.',
      department: 'Library',
      status: GrievanceStatus.pending,
      submittedBy: 'Sarah Wilson',
      submittedById: 'student4',
      submittedAt: DateTime.now().subtract(const Duration(days: 1)),
      priority: 3,
    ),
    Grievance(
      id: 'grievance5',
      title: 'Transportation Schedule Issues',
      description: 'The university bus schedule has been inconsistent lately. Buses are often late or don\'t arrive at all, causing students to miss classes. Please review and fix the transportation system.',
      department: 'Transportation',
      status: GrievanceStatus.inProgress,
      submittedBy: 'David Brown',
      submittedById: 'student5',
      submittedAt: DateTime.now().subtract(const Duration(days: 7)),
      reply: 'We are working with the transportation department to improve the schedule reliability. Additional buses have been allocated to reduce delays.',
      repliedAt: DateTime.now().subtract(const Duration(days: 2)),
      repliedBy: 'Dr. Robert Admin',
      priority: 4,
    ),
    Grievance(
      id: 'grievance6',
      title: 'Sports Equipment Maintenance',
      description: 'The gym equipment in the sports complex needs maintenance. Several machines are not functioning properly, and some are completely broken.',
      department: 'Sports',
      status: GrievanceStatus.pending,
      submittedBy: 'rsyadav',
      submittedById: 'student1',
      submittedAt: DateTime.now().subtract(const Duration(hours: 12)),
      priority: 2,
    ),
    Grievance(
      id: 'grievance7',
      title: 'Hostel Room Temperature',
      description: 'The air conditioning in Block B hostel is not working properly. Rooms are too hot during the day and too cold at night. This is affecting students\' sleep and study.',
      department: 'Hostel',
      status: GrievanceStatus.resolved,
      submittedBy: 'Jane Smith',
      submittedById: 'student2',
      submittedAt: DateTime.now().subtract(const Duration(days: 15)),
      reply: 'The HVAC system has been repaired and calibrated. Temperature controls are now working properly in all rooms.',
      repliedAt: DateTime.now().subtract(const Duration(days: 5)),
      repliedBy: 'Prof. Lisa Manager',
      priority: 4,
    ),
  ];

  // Mock Notifications
  static final List<AppNotification> notifications = [
    AppNotification(
      id: 'notif1',
      title: 'Grievance Status Updated',
      message: 'Your grievance "Internet Connectivity Issues in Hostel" is now under review.',
      type: NotificationType.statusChange,
      userId: 'student1',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      grievanceId: 'grievance1',
    ),
    AppNotification(
      id: 'notif2',
      title: 'New Reply Received',
      message: 'You have received a reply for your grievance "Broken Lab Equipment".',
      type: NotificationType.newReply,
      userId: 'student2',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      grievanceId: 'grievance2',
    ),
    AppNotification(
      id: 'notif3',
      title: 'Grievance Resolved',
      message: 'Your grievance "Cafeteria Food Quality" has been resolved.',
      type: NotificationType.grievanceUpdate,
      userId: 'student3',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      grievanceId: 'grievance3',
    ),
    AppNotification(
      id: 'notif4',
      title: 'New Grievance Submitted',
      message: 'A new grievance has been submitted by ramsinghyadav12 regarding sports equipment.',
      type: NotificationType.grievanceUpdate,
      userId: 'admin1',
      createdAt: DateTime.now().subtract(const Duration(hours: 12)),
      grievanceId: 'grievance6',
    ),
    AppNotification(
      id: 'notif5',
      title: 'System Maintenance',
      message: 'The grievance portal will be under maintenance tonight from 2 AM to 4 AM.',
      type: NotificationType.general,
      userId: 'student1',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  // Helper methods
  static User getStudentById(String id) {
    return users.firstWhere((user) => user.id == id && user.role == UserRole.student);
  }

  static User getAdminById(String id) {
    return users.firstWhere((user) => user.id == id && user.role == UserRole.admin);
  }

  static List<Grievance> getGrievancesByStudentId(String studentId) {
    return grievances.where((grievance) => grievance.submittedById == studentId).toList();
  }

  static List<AppNotification> getNotificationsByUserId(String userId) {
    return notifications.where((notification) => notification.userId == userId).toList();
  }

  static String generateId() {
    return _uuid.v4();
  }
} 