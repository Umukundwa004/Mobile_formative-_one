import 'package:sqflite/sqflite.dart';
import '../models/models.dart';
import 'database_helper.dart';

class AcademicSessionDAO {
  final DatabaseHelper dbHelper = DatabaseHelper.instance;

  // Insert a new session
  Future<void> insertSession(AcademicSession session) async {
    final db = await dbHelper.database;
    await db.insert(
      DatabaseHelper.academicSessionTable,
      {
        DatabaseHelper.sessionId: session.id,
        DatabaseHelper.sessionTitle: session.title,
        DatabaseHelper.sessionDate: session.date.toIso8601String(),
        DatabaseHelper.sessionStartTime: session.startTime,
        DatabaseHelper.sessionEndTime: session.endTime,
        DatabaseHelper.sessionLocation: session.location,
        DatabaseHelper.sessionType: session.sessionType,
        DatabaseHelper.sessionIsPresent: session.isPresent ? 1 : 0,
        DatabaseHelper.sessionCreatedAt: DateTime.now().toIso8601String(),
        DatabaseHelper.sessionUpdatedAt: DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get all sessions
  Future<List<AcademicSession>> getAllSessions() async {
    final db = await dbHelper.database;
    final result = await db.query(DatabaseHelper.academicSessionTable);
    return result.map((json) => _sessionFromMap(json)).toList();
  }

  // Get session by ID
  Future<AcademicSession?> getSessionById(String id) async {
    final db = await dbHelper.database;
    final result = await db.query(
      DatabaseHelper.academicSessionTable,
      where: '${DatabaseHelper.sessionId} = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return _sessionFromMap(result.first);
    }
    return null;
  }

  // Update session
  Future<void> updateSession(AcademicSession session) async {
    final db = await dbHelper.database;
    await db.update(
      DatabaseHelper.academicSessionTable,
      {
        DatabaseHelper.sessionTitle: session.title,
        DatabaseHelper.sessionDate: session.date.toIso8601String(),
        DatabaseHelper.sessionStartTime: session.startTime,
        DatabaseHelper.sessionEndTime: session.endTime,
        DatabaseHelper.sessionLocation: session.location,
        DatabaseHelper.sessionType: session.sessionType,
        DatabaseHelper.sessionIsPresent: session.isPresent ? 1 : 0,
        DatabaseHelper.sessionUpdatedAt: DateTime.now().toIso8601String(),
      },
      where: '${DatabaseHelper.sessionId} = ?',
      whereArgs: [session.id],
    );
  }

  // Delete session
  Future<void> deleteSession(String id) async {
    final db = await dbHelper.database;
    await db.delete(
      DatabaseHelper.academicSessionTable,
      where: '${DatabaseHelper.sessionId} = ?',
      whereArgs: [id],
    );
  }

  // Delete all sessions
  Future<void> deleteAllSessions() async {
    final db = await dbHelper.database;
    await db.delete(DatabaseHelper.academicSessionTable);
  }

  // Get sessions by date range
  Future<List<AcademicSession>> getSessionsByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    final db = await dbHelper.database;
    final result = await db.query(
      DatabaseHelper.academicSessionTable,
      where: '${DatabaseHelper.sessionDate} BETWEEN ? AND ?',
      whereArgs: [start.toIso8601String(), end.toIso8601String()],
      orderBy:
          '${DatabaseHelper.sessionDate} ASC, ${DatabaseHelper.sessionStartTime} ASC',
    );
    return result.map((json) => _sessionFromMap(json)).toList();
  }

  // Get sessions by specific date
  Future<List<AcademicSession>> getSessionsByDate(DateTime date) async {
    final db = await dbHelper.database;
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final result = await db.query(
      DatabaseHelper.academicSessionTable,
      where:
          '${DatabaseHelper.sessionDate} >= ? AND ${DatabaseHelper.sessionDate} < ?',
      whereArgs: [startOfDay.toIso8601String(), endOfDay.toIso8601String()],
      orderBy: '${DatabaseHelper.sessionStartTime} ASC',
    );
    return result.map((json) => _sessionFromMap(json)).toList();
  }

  // Get sessions by week
  Future<List<AcademicSession>> getSessionsByWeek(DateTime date) async {
    final db = await dbHelper.database;
    final startOfWeek = _getStartOfWeek(date);
    final endOfWeek = startOfWeek.add(const Duration(days: 7));

    final result = await db.query(
      DatabaseHelper.academicSessionTable,
      where:
          '${DatabaseHelper.sessionDate} >= ? AND ${DatabaseHelper.sessionDate} < ?',
      whereArgs: [startOfWeek.toIso8601String(), endOfWeek.toIso8601String()],
      orderBy:
          '${DatabaseHelper.sessionDate} ASC, ${DatabaseHelper.sessionStartTime} ASC',
    );
    return result.map((json) => _sessionFromMap(json)).toList();
  }

  // Get attended sessions
  Future<List<AcademicSession>> getAttendedSessions() async {
    final db = await dbHelper.database;
    final result = await db.query(
      DatabaseHelper.academicSessionTable,
      where: '${DatabaseHelper.sessionIsPresent} = ?',
      whereArgs: [1],
      orderBy: '${DatabaseHelper.sessionDate} DESC',
    );
    return result.map((json) => _sessionFromMap(json)).toList();
  }

  // Get attendance count
  Future<int> getAttendanceCount() async {
    final db = await dbHelper.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM ${DatabaseHelper.academicSessionTable} WHERE ${DatabaseHelper.sessionIsPresent} = 1',
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  // Get total session count
  Future<int> getTotalSessionCount() async {
    final db = await dbHelper.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM ${DatabaseHelper.academicSessionTable}',
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  // Calculate attendance percentage
  Future<double> getAttendancePercentage() async {
    final attended = await getAttendanceCount();
    final total = await getTotalSessionCount();
    if (total == 0) return 0.0;
    return (attended / total) * 100;
  }

  // Get sessions by type
  Future<List<AcademicSession>> getSessionsByType(String type) async {
    final db = await dbHelper.database;
    final result = await db.query(
      DatabaseHelper.academicSessionTable,
      where: '${DatabaseHelper.sessionType} = ?',
      whereArgs: [type],
      orderBy: '${DatabaseHelper.sessionDate} DESC',
    );
    return result.map((json) => _sessionFromMap(json)).toList();
  }

  // Helper function to get start of week
  DateTime _getStartOfWeek(DateTime date) {
    final dateOnly = DateTime(date.year, date.month, date.day);
    final daysFromMonday = dateOnly.weekday - DateTime.monday;
    return dateOnly.subtract(Duration(days: daysFromMonday));
  }

  // Convert map to AcademicSession object
  AcademicSession _sessionFromMap(Map<String, dynamic> map) {
    return AcademicSession(
      id: map[DatabaseHelper.sessionId] ?? '',
      title: map[DatabaseHelper.sessionTitle] ?? '',
      date: DateTime.parse(
        map[DatabaseHelper.sessionDate] ?? DateTime.now().toIso8601String(),
      ),
      startTime: map[DatabaseHelper.sessionStartTime] ?? '09:00',
      endTime: map[DatabaseHelper.sessionEndTime] ?? '10:00',
      location: map[DatabaseHelper.sessionLocation] ?? '',
      sessionType: map[DatabaseHelper.sessionType] ?? 'Class',
      isPresent: (map[DatabaseHelper.sessionIsPresent] ?? 0) == 1,
    );
  }
}
