# Database Operations - Quick Reference

## Common Operations

### Adding Data

**Add Assignment:**

```dart
final provider = context.read<DataProvider>();
final assignment = Assignment(
  id: const Uuid().v4(),
  title: 'Mobile Project',
  course: 'Flutter',
  dueDate: DateTime.now().add(Duration(days: 7)),
  priority: 'High',
  isCompleted: false,
);
provider.addAssignment(assignment);
```

**Add Session:**

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
provider.addSession(session);
```

**Update User Profile:**

```dart
await provider.updateUserProfile('John Doe', 'john@example.com');
```

### Updating Data

**Update Assignment:**

```dart
final updatedAssignment = assignment.copyWith(
  title: 'Updated Title',
  isCompleted: true,
);
provider.updateAssignment(assignmentId, updatedAssignment);
```

**Update Session:**

```dart
final updatedSession = session.copyWith(
  isPresent: true,
);
provider.updateSession(sessionId, updatedSession);
```

**Toggle Assignment Status:**

```dart
provider.toggleAssignmentStatus(assignmentId);
```

**Toggle Attendance:**

```dart
provider.toggleAttendance(sessionId);
```

### Deleting Data

**Delete Assignment:**

```dart
provider.deleteAssignment(assignmentId);
```

**Delete Session:**

```dart
provider.deleteSession(sessionId);
```

### Reading Data

**Get All Assignments:**

```dart
List<Assignment> all = provider.assignments;
```

**Get Pending Assignments:**

```dart
List<Assignment> pending = provider.assignments
    .where((a) => !a.isCompleted)
    .toList();
```

**Get Upcoming Assignments (Next 7 Days):**

```dart
List<Assignment> upcoming = provider.getUpcomingAssignments(7);
```

**Get Upcoming Due Assignments:**

```dart
List<Assignment> dueAssignments = provider.getUpcomingDueAssignments();
```

**Get All Sessions:**

```dart
List<AcademicSession> all = provider.sessions;
```

**Get Today's Sessions:**

```dart
List<AcademicSession> today = provider.getTodaySessions();
```

**Get Week Sessions:**

```dart
List<AcademicSession> week = provider.getWeekSessions();
```

### Analytics

**Get Attendance Percentage:**

```dart
double percentage = provider.getAttendancePercentage();
print('Attendance: ${percentage.toStringAsFixed(1)}%');
```

**Get Pending Count:**

```dart
int count = provider.getPendingAssignmentsCount();
print('Pending: $count assignments');
```

**Get Current Academic Week:**

```dart
String week = provider.getCurrentAcademicWeek();
print('Currently in $week');
```

### Advanced DAO Operations

**Get Analytics from DAO:**

```dart
final sessionDAO = AcademicSessionDAO();

// Get attendance percentage
double percentage = await sessionDAO.getAttendancePercentage();

// Get attendance count
int attended = await sessionDAO.getAttendanceCount();

// Get total sessions
int total = await sessionDAO.getTotalSessionCount();

// Get sessions by type
List<AcademicSession> classSessions =
    await sessionDAO.getSessionsByType('Class');
```

**Get Assignments by Date Range:**

```dart
final assignmentDAO = AssignmentDAO();

final start = DateTime.now();
final end = DateTime.now().add(Duration(days: 7));

List<Assignment> range =
    await assignmentDAO.getAssignmentsByDateRange(start, end);
```

## Initialization

**On App Startup:**

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dataProvider = DataProvider();

  // Load existing data
  await dataProvider.initializeData();

  // Initialize sample data (only if empty)
  await dataProvider.initializeSampleData();

  runApp(MyApp(dataProvider: dataProvider));
}
```

## Important Constants

```dart
// Priority levels
const String HIGH = 'High';
const String MEDIUM = 'Medium';
const String LOW = 'Low';

// Session types
const String CLASS = 'Class';
const String MASTERY_SESSION = 'Mastery Session';
const String STUDY_GROUP = 'Study Group';
const String PSL_MEETING = 'PSL Meeting';
const String IN_PERSON = 'In Person';

// Default user ID
const String DEFAULT_USER_ID = 'default_user';
```

## Model Creation Helpers

**Assignment with Defaults:**

```dart
Assignment createAssignment({
  required String title,
  required String course,
  required DateTime dueDate,
  String priority = 'Medium',
  bool isCompleted = false,
}) {
  return Assignment(
    id: const Uuid().v4(),
    title: title,
    course: course,
    dueDate: dueDate,
    priority: priority,
    isCompleted: isCompleted,
  );
}
```

**Session with Defaults:**

```dart
AcademicSession createSession({
  required String title,
  required DateTime date,
  String startTime = '09:00',
  String endTime = '10:30',
  String location = '',
  String sessionType = 'Class',
  bool isPresent = false,
}) {
  return AcademicSession(
    id: const Uuid().v4(),
    title: title,
    date: date,
    startTime: startTime,
    endTime: endTime,
    location: location,
    sessionType: sessionType,
    isPresent: isPresent,
  );
}
```

## Filtering Examples

**Filter by Priority:**

```dart
final high = provider.assignments
    .where((a) => a.priority == 'High')
    .toList();
```

**Filter by Course:**

```dart
final flutter = provider.assignments
    .where((a) => a.course.contains('Flutter'))
    .toList();
```

**Filter by Date Range:**

```dart
final start = DateTime(2024, 1, 1);
final end = DateTime(2024, 1, 31);

final monthly = provider.assignments
    .where((a) => a.dueDate.isAfter(start) && a.dueDate.isBefore(end))
    .toList();
```

**Filter by Completion Status:**

```dart
final completed = provider.assignments.where((a) => a.isCompleted).toList();
final pending = provider.assignments.where((a) => !a.isCompleted).toList();
```

## Sorting Examples

**Sort Assignments by Due Date:**

```dart
final sorted = provider.assignments
    ..sort((a, b) => a.dueDate.compareTo(b.dueDate));
```

**Sort Sessions by Start Time:**

```dart
final sorted = provider.sessions
    ..sort((a, b) => a.startTime.compareTo(b.startTime));
```

---

All database operations are **automatically persisted to SQLite**. The data layer handles all storage details transparently.
