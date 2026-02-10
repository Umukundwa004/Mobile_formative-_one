# Database & Persistence Layer Documentation

## Overview

This project implements a **SQLite-based persistence layer** for the Student Academic Platform. The database automatically saves all assignments, academic sessions, and user profile information, ensuring data persists across app sessions.

## Architecture

The persistence layer follows a **Data Access Object (DAO)** pattern:

```
┌─────────────────────────────────────┐
│      DataProvider (State)            │
│   (Flutter Provider Pattern)         │
└──────────────┬──────────────────────┘
               │
    ┌──────────┼──────────┬────────────┐
    │          │          │            │
┌───▼───┐ ┌──▼────┐ ┌──▼────┐ ┌────▼──┐
│Assign │ │Acad   │ │User   │ │Database│
│DAO    │ │Session│ │Profile│ │Helper  │
│       │ │DAO    │ │DAO    │ │(SQLite)│
└───────┘ └───────┘ └───────┘ └────────┘
```

## Components

### 1. **DatabaseHelper** (`lib/services/database_helper.dart`)

Core database initialization and schema management.

**Features:**

- Single database instance management
- Schema creation for all tables
- Database version control
- Data clearing utility

**Tables:**

- `assignments` - Stores assignment data
- `academic_sessions` - Stores class/session data
- `user_profiles` - Stores user profile information

### 2. **AssignmentDAO** (`lib/services/assignment_dao.dart`)

Database operations for assignments.

**Methods:**

```dart
// CRUD Operations
Future<void> insertAssignment(Assignment assignment)
Future<Assignment?> getAssignmentById(String id)
Future<void> updateAssignment(Assignment assignment)
Future<void> deleteAssignment(String id)

// Query Operations
Future<List<Assignment>> getAllAssignments()
Future<List<Assignment>> getPendingAssignments()
Future<List<Assignment>> getCompletedAssignments()
Future<List<Assignment>> getAssignmentsByDateRange(DateTime start, DateTime end)

// Utility Methods
Future<int> getAssignmentCount()
Future<int> getPendingAssignmentCount()
```

### 3. **AcademicSessionDAO** (`lib/services/academic_session_dao.dart`)

Database operations for academic sessions.

**Methods:**

```dart
// CRUD Operations
Future<void> insertSession(AcademicSession session)
Future<AcademicSession?> getSessionById(String id)
Future<void> updateSession(AcademicSession session)
Future<void> deleteSession(String id)

// Query Operations
Future<List<AcademicSession>> getAllSessions()
Future<List<AcademicSession>> getSessionsByDate(DateTime date)
Future<List<AcademicSession>> getSessionsByWeek(DateTime date)
Future<List<AcademicSession>> getSessionsByDateRange(DateTime start, DateTime end)
Future<List<AcademicSession>> getAttendedSessions()

// Analytics
Future<int> getAttendanceCount()
Future<int> getTotalSessionCount()
Future<double> getAttendancePercentage()
```

### 4. **UserProfileDAO** (`lib/services/user_profile_dao.dart`)

Database operations for user profile.

**Methods:**

```dart
// CRUD Operations
Future<void> saveUserProfile(UserProfile profile)
Future<UserProfile?> getUserProfile(String userId)
Future<void> updateUserProfile(UserProfile profile)
Future<void> deleteUserProfile(String userId)

// Utility Methods
Future<bool> userExists(String userId)
Future<UserProfile?> getFirstUserProfile()
```

## Database Schema

### Assignments Table

```sql
CREATE TABLE assignments (
  id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  course TEXT NOT NULL,
  dueDate TEXT NOT NULL,
  priority TEXT DEFAULT 'Medium',
  isCompleted INTEGER DEFAULT 0,
  createdAt TEXT DEFAULT CURRENT_TIMESTAMP,
  updatedAt TEXT DEFAULT CURRENT_TIMESTAMP
)
```

### Academic Sessions Table

```sql
CREATE TABLE academic_sessions (
  id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  date TEXT NOT NULL,
  startTime TEXT NOT NULL,
  endTime TEXT NOT NULL,
  location TEXT DEFAULT '',
  sessionType TEXT DEFAULT 'Class',
  isPresent INTEGER DEFAULT 0,
  createdAt TEXT DEFAULT CURRENT_TIMESTAMP,
  updatedAt TEXT DEFAULT CURRENT_TIMESTAMP
)
```

### User Profiles Table

```sql
CREATE TABLE user_profiles (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  email TEXT NOT NULL,
  updatedAt TEXT DEFAULT CURRENT_TIMESTAMP
)
```

## Usage Examples

### Initialize Database on App Startup

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dataProvider = DataProvider();
  await dataProvider.initializeData();
  await dataProvider.initializeSampleData();

  runApp(MyApp(dataProvider: dataProvider));
}
```

### Add Assignment

```dart
final assignment = Assignment(
  id: const Uuid().v4(),
  title: 'Mobile Project',
  course: 'Flutter Development',
  dueDate: DateTime.now().add(Duration(days: 7)),
  priority: 'High',
  isCompleted: false,
);

dataProvider.addAssignment(assignment);
```

### Add Session and Track Attendance

```dart
final session = AcademicSession(
  id: const Uuid().v4(),
  title: 'Flutter Class',
  date: DateTime.now(),
  startTime: '09:00',
  endTime: '10:30',
  location: 'Room 101',
  sessionType: 'Class',
  isPresent: true,
);

dataProvider.addSession(session);
```

### Update User Profile

```dart
await dataProvider.updateUserProfile(
  'John Doe',
  'john.doe@example.com',
);
```

### Query Data

```dart
// Get pending assignments
final pending = dataProvider.assignments
    .where((a) => !a.isCompleted)
    .toList();

// Get attendance percentage
final percentage = await sessionDAO.getAttendancePercentage();

// Get sessions by date
final today = DateTime.now();
final todaySessions = await sessionDAO.getSessionsByDate(today);
```

## Key Features

✅ **Automatic Persistence** - All changes are saved to SQLite
✅ **Offline Support** - Data available without internet
✅ **Type Safety** - Strong typing with Dart classes
✅ **Scalability** - Easy to add new tables and queries
✅ **Analytics** - Built-in methods for attendance, pending items, etc.
✅ **Transaction Support** - Database transactions via sqflite

## Dependencies

```yaml
sqflite: ^2.3.0 # SQLite database for Flutter
path: ^1.8.3 # Path utilities for database file location
uuid: ^4.0.0 # Generate unique IDs
provider: ^6.0.0 # State management
```

## Important Notes

1. **Database Initialization**: Call `initializeData()` before using the app to load existing data
2. **IDs**: Use `Uuid().v4()` to generate unique IDs for new records
3. **Timestamps**: All timestamps are stored in ISO8601 format
4. **Default User**: User profile uses 'default_user' as the ID (one profile per device)
5. **Sample Data**: Call `initializeSampleData()` only on first launch (it checks if data exists)

## Data Persistence Flow

```
User Action (Add/Update/Delete)
    ↓
DataProvider Method
    ↓
DAO Method (Insert/Update/Delete)
    ↓
SQLite Database (Physical Storage)
    ↓
In-Memory List Updated
    ↓
notifyListeners() - UI Refreshes
```

## Future Enhancements

- [ ] Cloud sync with backend API
- [ ] Data export (CSV, PDF)
- [ ] Backup and restore functionality
- [ ] Search and filtering improvements
- [ ] Database encryption
- [ ] Cached queries for performance
