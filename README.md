# Student Grievance Portal

A complete Flutter application for managing student grievances and complaints in educational institutions. This is a **frontend-only** application with mock data and simulated functionality.

## 🎯 Features

### 👨‍🎓 Student Features
- **Authentication**: Login and registration with mock credentials
- **Dashboard**: Overview of submitted grievances with statistics
- **Submit Grievance**: Form to submit new complaints with file attachments
- **My Grievances**: View and filter personal grievances
- **Notifications**: Real-time status updates and replies
- **Profile Management**: View and manage account information

### 🧑‍💼 Admin Features
- **Admin Dashboard**: Overview of all grievances with statistics
- **Grievance Management**: View, filter, and manage all student grievances
- **Reply System**: Respond to student grievances
- **Status Updates**: Change grievance status (Pending, In Progress, Resolved, Rejected)
- **Notifications**: Receive alerts for new grievances

## 🛠 Technical Stack

- **Framework**: Flutter 3.8+
- **State Management**: Riverpod
- **Routing**: GoRouter
- **UI Design**: Material 3
- **File Handling**: File Picker (simulated)
- **Date Formatting**: Intl package
- **Mock Data**: Hardcoded dummy data with UUID generation

## 📱 Screenshots

The app includes the following screens:
- Login/Registration screens
- Student Dashboard with statistics
- Submit Grievance form with file upload
- My Grievances with filtering
- Grievance Details with admin actions
- Admin Dashboard with overview
- Notifications screen
- Profile management

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.8 or higher
- Dart SDK 3.0 or higher
- Android Studio / VS Code with Flutter extensions

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd student_grievance_portal
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the application**
   ```bash
   flutter run
   ```

## 🔐 Demo Credentials

### Student Login
- **Email**: `john.doe@university.edu`
- **Password**: `password123`

### Admin Login
- **Email**: `admin@university.edu`
- **Password**: `password123`

### Additional Student Accounts
- `jane.smith@university.edu` / `password123`
- `mike.johnson@university.edu` / `password123`
- `sarah.wilson@university.edu` / `password123`
- `david.brown@university.edu` / `password123`

## 📁 Project Structure

```
lib/
├── models/
│   ├── user.dart              # User model with roles
│   ├── grievance.dart         # Grievance model with status
│   └── notification.dart      # Notification model
├── providers/
│   ├── auth_provider.dart     # Authentication state management
│   ├── grievance_provider.dart # Grievance data management
│   └── notification_provider.dart # Notification management
├── screens/
│   ├── auth/
│   │   ├── login_screen.dart
│   │   └── register_screen.dart
│   ├── student/
│   │   ├── student_dashboard_screen.dart
│   │   ├── submit_grievance_screen.dart
│   │   └── my_grievances_screen.dart
│   ├── admin/
│   │   ├── admin_dashboard_screen.dart
│   │   └── admin_grievances_screen.dart
│   ├── grievance/
│   │   └── grievance_details_screen.dart
│   ├── notifications_screen.dart
│   └── profile_screen.dart
├── widgets/
│   ├── custom_button.dart     # Reusable button components
│   ├── custom_text_field.dart # Form field components
│   ├── grievance_card.dart    # Grievance display cards
│   └── notification_card.dart # Notification display cards
├── utils/
│   ├── constants.dart         # App constants and styles
│   ├── dummy_data.dart        # Mock data for the app
│   └── router.dart           # Navigation configuration
└── main.dart                 # App entry point
```

## 🎨 UI/UX Features

- **Material 3 Design**: Modern, clean interface
- **Responsive Layout**: Works on different screen sizes
- **Color-coded Status**: Visual indicators for grievance status
- **Smooth Animations**: Transitions and micro-interactions
- **Accessibility**: Proper contrast and readable fonts
- **Loading States**: Loading indicators for better UX

## 🔧 Customization

### Colors and Themes
Edit `lib/utils/constants.dart` to customize:
- Primary and secondary colors
- Status colors (pending, in progress, resolved, rejected)
- Text styles and typography
- Border radius and spacing

### Mock Data
Modify `lib/utils/dummy_data.dart` to:
- Add more users (students/admins)
- Create additional grievances
- Customize departments and priorities
- Add more notifications

### Departments
Update the departments list in `lib/utils/constants.dart`:
```dart
static const List<String> departments = [
  'Computer Science',
  'Electrical Engineering',
  // Add your departments here
];
```

## 📊 Features Overview

### Grievance Management
- **Status Tracking**: Pending → In Progress → Resolved/Rejected
- **Priority Levels**: Very Low to Very High (1-5)
- **File Attachments**: Support for images, PDFs, documents
- **Department Assignment**: Route grievances to appropriate departments
- **Reply System**: Admin responses with timestamps

### Search and Filtering
- **Text Search**: Search by title, description, or submitter
- **Status Filter**: Filter by grievance status
- **Department Filter**: Filter by department
- **Real-time Updates**: Live filtering as you type

### Notifications
- **Status Updates**: Notify students of status changes
- **New Replies**: Alert students when admin responds
- **New Grievances**: Notify admins of new submissions
- **Read/Unread States**: Visual indicators for unread notifications

## 🚧 Future Enhancements

This is a frontend-only implementation. For a production app, consider adding:

- **Backend Integration**: Real API endpoints
- **Database**: Persistent data storage
- **Authentication**: Real user authentication
- **File Storage**: Cloud storage for attachments
- **Push Notifications**: Real-time push notifications
- **Email Notifications**: Email alerts for updates
- **Analytics**: Usage tracking and reporting
- **Multi-language Support**: Internationalization
- **Offline Support**: Offline data synchronization

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🆘 Support

For support and questions:
- Create an issue in the repository
- Check the documentation
- Review the code comments

---

**Note**: This is a demonstration application with mock data. All functionality is simulated for educational and demonstration purposes.
