# Student Academic Platform

A comprehensive Flutter-based mobile application for students to manage their academic life, track attendance, manage assignments, view schedules, and monitor their academic risk status.

## Features

- **Dashboard**: Overview of today's sessions, pending assignments, and attendance metrics
- **Assignments Management**: Create, edit, and track assignments with priority levels and deadlines
- **Schedule Management**: Weekly academic session view with attendance tracking
- **Attendance Tracking**: Detailed attendance history with percentage calculation and risk alerts
- **Announcements**: Dynamic assignment deadline notifications and pending task alerts
- **User Profile**: Manage user information and account settings
- **Responsive Design**: Optimized for various phone screen sizes (small to large devices)

## Project Structure

```
lib/
├── main.dart                    # Application entry point
├── data_provider.dart           # State management using Provider
├── models/
│   └── models.dart             # Data models (Assignment, AcademicSession)
└── screens/
    ├── home.dart               # Main navigation with bottom tab bar
    ├── dashboard.dart          # Dashboard screen with overview metrics
    ├── assignments.dart        # Assignment management with CRUD operations
    ├── schedule.dart           # Weekly schedule with session management
    ├── announcements.dart      # Assignment announcements and deadlines
    ├── attendance_detail.dart  # Detailed attendance tracking and history
    ├── profile.dart            # User profile and account settings
    ├── risk_status.dart        # Academic risk status monitoring
    └── signup.dart             # User registration screen
```

## Key Components

### Data Provider (`data_provider.dart`)

- Central state management using ChangeNotifier
- Manages assignments, academic sessions, and user profile data
- Provides helper methods for attendance calculation, upcoming assignments, and academic week tracking
- Initializes sample data for testing

### Models (`models/models.dart`)

- **Assignment**: Represents student assignments with properties like title, course, due date, priority, and completion status
- **AcademicSession**: Represents academic sessions with date, time, location, type, and attendance status

### Screens

#### Home Screen (`home.dart`)

- Bottom navigation bar with 4 tabs: Dashboard, Assignments, Schedule, Announcements
- Responsive icon and font sizing
- ALU color scheme (Navy #1A2C5A, Yellow #FFB800)

#### Dashboard (`dashboard.dart`)

- Course selection dropdown
- At-risk warning banner (if attendance < 75%)
- Three stat boxes: Pending Assignments, Attendance (clickable), Due Next 7 Days
- Today's sessions with date and academic week
- Upcoming assignments due soon
- Responsive layout with MediaQuery-based sizing

#### Assignments (`assignments.dart`)

- Tab-based filtering: All, Formative, Summative
- Create new assignments with priority levels (High, Medium, Low)
- Edit and delete existing assignments
- Mark assignments as complete/incomplete
- Color-coded priority indicators

#### Schedule (`schedule.dart`)

- Weekly session view with date range
- Add new sessions with time validation
- Session types: Class, Mastery Session, Study Group, PSL Meeting
- Edit and delete sessions
- Mark attendance (Present/Absent)
- Time picker with proper formatting

#### Attendance Detail (`attendance_detail.dart`)

- Attendance percentage with color coding
- Metric cards: Attendance Rate, Present Sessions, Absent Sessions
- Warning banner if attendance < 75%
- "Get Help" button
- Complete session history with present/absent indicators

#### Announcements (`announcements.dart`)

- Pending assignments count
- Upcoming deadlines within 7 days
- Assignment cards with urgency badges
- Color-coded priority indicators
- Days remaining countdown

#### Profile (`profile.dart`)

- User avatar display
- Name and email display
- Edit profile dialog with text controllers
- Account settings menu: Edit Profile, Change Password
- Logout with confirmation dialog
- Responsive sizing for different screen sizes

## Color Scheme

- **Primary Navy**: `#1A2C5A` - Background, headers, text
- **Secondary Yellow**: `#FFB800` - Accent, buttons, highlights
- **Danger Red**: `#E53935` - Warnings, alerts, urgent items
- **Success Green**: `#4CAF50` - Positive indicators
- **Dark Blue**: `#2C4A7E` - Cards, containers

## Responsive Design

The application uses MediaQuery to detect screen size and adjusts:

- Font sizes (18-20px for titles, 13-16px for body text)
- Icon sizes (20-24px)
- Padding and spacing (12-20px)
- Layout constraints based on screen width threshold (360px)

### Breakpoints

- Small screens: < 360px width
- Regular screens: ≥ 360px width

## Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.2 # State management
  intl: ^0.19.0 # Date formatting
  uuid: ^4.5.1 # Unique ID generation
```

## Getting Started

### Prerequisites

- Flutter SDK (latest stable version)
- Dart SDK
- Android Studio / Xcode (for mobile development)
- VS Code or Android Studio

### Installation

1. Clone the repository:

```bash
git clone https://github.com/Umukundwa004/Mobile_formative-_one.git
cd Mobile_formative-_one
```

2. Install dependencies:

```bash
flutter pub get
```

3. Run the app:

```bash
flutter run
```

### For Web:

```bash
flutter run -d chrome
```

### For Mobile:

```bash
flutter run -d <device-id>
```

## Usage

### Dashboard Navigation

- Use the bottom navigation bar to switch between Dashboard, Assignments, Schedule, and Announcements
- Tap the profile icon (top right) to access user settings

### Managing Assignments

1. Go to Assignments tab
2. Tap "Create Group Assignment" button
3. Fill in assignment details (title, course, due date, priority)
4. Save and track progress

### Tracking Attendance

1. View attendance percentage on Dashboard
2. Tap the Attendance stat box for detailed history
3. Monitor sessions and attendance records
4. Get help if attendance falls below 75%

### Managing Schedule

1. Go to Schedule tab
2. Tap "Add New Session" button
3. Enter session details and save
4. Mark attendance as sessions occur

## Architecture

- **State Management**: Provider pattern with ChangeNotifier
- **Navigation**: MaterialPageRoute for screen transitions
- **UI Framework**: Material Design 3
- **Data Persistence**: In-memory (can be extended with local storage or backend)

## Future Enhancements

- Backend integration for data persistence
- Push notifications for assignment deadlines
- Calendar integration
- Grade tracking
- Course materials management
- Real-time synchronization
- Dark mode support
- Multi-language support

## License

This project is for educational purposes.

## Support

For issues or questions, please contact the development team.
## database

database :SQLite

