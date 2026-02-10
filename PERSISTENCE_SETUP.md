# Data Management & Persistence - Quick Setup Guide

## What Was Added

A complete **SQLite-based Data Management & Persistence system** for your Student Academic Platform.

## Files Created

### Database Layer (`lib/services/`)

1. **`database_helper.dart`** - SQLite database initialization and schema
2. **`assignment_dao.dart`** - Assignment database operations
3. **`academic_session_dao.dart`** - Academic session database operations
4. **`user_profile_dao.dart`** - User profile database operations

## Updated Files

1. **`pubspec.yaml`** - Added `sqflite` and `path` dependencies
2. **`main.dart`** - Added database initialization on app startup
3. **`data_provider.dart`** - Integrated database persistence with state management

## How It Works

### Automatic Data Persistence

```
✓ All assignments are saved to SQLite
✓ All sessions are saved to SQLite
✓ User profile is saved to SQLite
✓ Data survives app restarts
✓ Changes are synced in real-time
```

### Data Flow

```
UI (Provider Widget)
  ↓
DataProvider (State Management)
  ↓
DAO Classes (Database Layer)
  ↓
SQLite Database (Persistent Storage)
```

## Quick Start

### 1. Install Dependencies

```bash
flutter pub get
```

### 2. Use in Your App

The database initializes automatically in `main()`. Just use DataProvider as before:

```dart
// In your widgets
final provider = context.read<DataProvider>();

// Add assignment (automatically saves to DB)
provider.addAssignment(assignment);

// Update assignment (automatically saves to DB)
provider.updateAssignment(id, updatedAssignment);

// Delete assignment (automatically removes from DB)
provider.deleteAssignment(id);
```

## Example Usage in Screens

### Adding Data

```dart
import 'package:uuid/uuid.dart';

// In your screen
final provider = context.read<DataProvider>();

final assignment = Assignment(
  id: const Uuid().v4(),
  title: 'New Assignment',
  course: 'Flutter Development',
  dueDate: DateTime.now().add(Duration(days: 7)),
  priority: 'High',
  isCompleted: false,
);

provider.addAssignment(assignment);
```

### Updating User Profile

```dart
// Update and save user profile
await provider.updateUserProfile('John Doe', 'john@example.com');
```

### Querying Data

```dart
// Get all assignments
final allAssignments = provider.assignments;

// Get pending assignments
final pending = provider.assignments.where((a) => !a.isCompleted).toList();

// Get today's sessions
final todaySessions = provider.getTodaySessions();
```

## Database Features

### Assignment Database Operations

```dart
assignmentDAO.getAllAssignments()          // Get all
assignmentDAO.getPendingAssignments()      // Get incomplete
assignmentDAO.getCompletedAssignments()    // Get done
assignmentDAO.getAssignmentsByDateRange()  // Get by date range
assignmentDAO.getAssignmentCount()         // Count total
assignmentDAO.getPendingAssignmentCount()  // Count pending
```

### Session Database Operations

```dart
sessionDAO.getAllSessions()                // Get all
sessionDAO.getSessionsByDate()             // Get by date
sessionDAO.getSessionsByWeek()             // Get by week
sessionDAO.getAttendedSessions()           // Get attended
sessionDAO.getAttendancePercentage()       // Calculate percentage
sessionDAO.getTotalSessionCount()          // Count total
```

## Important Notes

⚠️ **IDs**: Always use `Uuid().v4()` for new records
⚠️ **Sample Data**: Loads only on first app launch
⚠️ **User Profile**: One profile per device (ID: 'default_user')
⚠️ **Timestamps**: Stored in ISO8601 format

## Advantages

✅ **Offline Access** - All data available without internet
✅ **Fast Performance** - Local SQLite queries are instant
✅ **Automatic Backup** - Data persists between sessions
✅ **Type Safe** - Full Dart type checking
✅ **Scalable** - Easy to add more tables and DAOs
✅ **Analytics Ready** - Built-in count and percentage methods

## Next Steps

1. **Test the app** - All existing functionality works with persistence
2. **No UI changes needed** - Database works transparently
3. **Add features** - Use the DAO methods for advanced queries
4. **Optional**: Implement cloud sync with a backend API

## Troubleshooting

### Database not persisting?

- Ensure `flutter pub get` was run
- Check that `initializeData()` is called in `main()`
- Verify the app doesn't clear app data on uninstall

### Getting null values?

- Call `await dataProvider.initializeData()` before using data
- Check that sample data was initialized with `initializeSampleData()`

### Performance issues?

- Consider indexing frequently queried fields
- Use date range queries to limit result sets
- Implement pagination for large data sets

---

**Documentation**: See `DATABASE_DOCUMENTATION.md` for detailed API reference
