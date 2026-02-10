import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const _databaseName = 'student_platform.db';
  static const _databaseVersion = 1;

  // Table names
  static const String assignmentTable = 'assignments';
  static const String academicSessionTable = 'academic_sessions';
  static const String userProfileTable = 'user_profiles';

  // Assignment table columns
  static const String assignmentId = 'id';
  static const String assignmentTitle = 'title';
  static const String assignmentCourse = 'course';
  static const String assignmentDueDate = 'dueDate';
  static const String assignmentPriority = 'priority';
  static const String assignmentIsCompleted = 'isCompleted';
  static const String assignmentCreatedAt = 'createdAt';
  static const String assignmentUpdatedAt = 'updatedAt';

  // Academic Session table columns
  static const String sessionId = 'id';
  static const String sessionTitle = 'title';
  static const String sessionDate = 'date';
  static const String sessionStartTime = 'startTime';
  static const String sessionEndTime = 'endTime';
  static const String sessionLocation = 'location';
  static const String sessionType = 'sessionType';
  static const String sessionIsPresent = 'isPresent';
  static const String sessionCreatedAt = 'createdAt';
  static const String sessionUpdatedAt = 'updatedAt';

  // User Profile table columns
  static const String userId = 'id';
  static const String userName = 'name';
  static const String userEmail = 'email';
  static const String userUpdatedAt = 'updatedAt';

  static Database? _database;

  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create assignments table
    await db.execute('''
      CREATE TABLE $assignmentTable (
        $assignmentId TEXT PRIMARY KEY,
        $assignmentTitle TEXT NOT NULL,
        $assignmentCourse TEXT NOT NULL,
        $assignmentDueDate TEXT NOT NULL,
        $assignmentPriority TEXT DEFAULT 'Medium',
        $assignmentIsCompleted INTEGER DEFAULT 0,
        $assignmentCreatedAt TEXT DEFAULT CURRENT_TIMESTAMP,
        $assignmentUpdatedAt TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    // Create academic sessions table
    await db.execute('''
      CREATE TABLE $academicSessionTable (
        $sessionId TEXT PRIMARY KEY,
        $sessionTitle TEXT NOT NULL,
        $sessionDate TEXT NOT NULL,
        $sessionStartTime TEXT NOT NULL,
        $sessionEndTime TEXT NOT NULL,
        $sessionLocation TEXT DEFAULT '',
        $sessionType TEXT DEFAULT 'Class',
        $sessionIsPresent INTEGER DEFAULT 0,
        $sessionCreatedAt TEXT DEFAULT CURRENT_TIMESTAMP,
        $sessionUpdatedAt TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    // Create user profile table
    await db.execute('''
      CREATE TABLE $userProfileTable (
        $userId TEXT PRIMARY KEY,
        $userName TEXT NOT NULL,
        $userEmail TEXT NOT NULL,
        $userUpdatedAt TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');
  }

  // Clear all data (useful for testing or resetting)
  Future<void> clearAllData() async {
    final db = await database;
    await db.delete(assignmentTable);
    await db.delete(academicSessionTable);
    await db.delete(userProfileTable);
  }

  // Close database
  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
    }
  }
}
