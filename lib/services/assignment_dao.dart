import 'package:sqflite/sqflite.dart';
import '../models/models.dart';
import 'database_helper.dart';

class AssignmentDAO {
  final DatabaseHelper dbHelper = DatabaseHelper.instance;

  // Insert a new assignment
  Future<void> insertAssignment(Assignment assignment) async {
    final db = await dbHelper.database;
    await db.insert(DatabaseHelper.assignmentTable, {
      DatabaseHelper.assignmentId: assignment.id,
      DatabaseHelper.assignmentTitle: assignment.title,
      DatabaseHelper.assignmentCourse: assignment.course,
      DatabaseHelper.assignmentDueDate: assignment.dueDate.toIso8601String(),
      DatabaseHelper.assignmentPriority: assignment.priority,
      DatabaseHelper.assignmentIsCompleted: assignment.isCompleted ? 1 : 0,
      DatabaseHelper.assignmentCreatedAt: DateTime.now().toIso8601String(),
      DatabaseHelper.assignmentUpdatedAt: DateTime.now().toIso8601String(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Get all assignments
  Future<List<Assignment>> getAllAssignments() async {
    final db = await dbHelper.database;
    final result = await db.query(DatabaseHelper.assignmentTable);
    return result.map((json) => _assignmentFromMap(json)).toList();
  }

  // Get assignment by ID
  Future<Assignment?> getAssignmentById(String id) async {
    final db = await dbHelper.database;
    final result = await db.query(
      DatabaseHelper.assignmentTable,
      where: '${DatabaseHelper.assignmentId} = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return _assignmentFromMap(result.first);
    }
    return null;
  }

  // Update assignment
  Future<void> updateAssignment(Assignment assignment) async {
    final db = await dbHelper.database;
    await db.update(
      DatabaseHelper.assignmentTable,
      {
        DatabaseHelper.assignmentTitle: assignment.title,
        DatabaseHelper.assignmentCourse: assignment.course,
        DatabaseHelper.assignmentDueDate: assignment.dueDate.toIso8601String(),
        DatabaseHelper.assignmentPriority: assignment.priority,
        DatabaseHelper.assignmentIsCompleted: assignment.isCompleted ? 1 : 0,
        DatabaseHelper.assignmentUpdatedAt: DateTime.now().toIso8601String(),
      },
      where: '${DatabaseHelper.assignmentId} = ?',
      whereArgs: [assignment.id],
    );
  }

  // Delete assignment
  Future<void> deleteAssignment(String id) async {
    final db = await dbHelper.database;
    await db.delete(
      DatabaseHelper.assignmentTable,
      where: '${DatabaseHelper.assignmentId} = ?',
      whereArgs: [id],
    );
  }

  // Delete all assignments
  Future<void> deleteAllAssignments() async {
    final db = await dbHelper.database;
    await db.delete(DatabaseHelper.assignmentTable);
  }

  // Get assignments by due date range
  Future<List<Assignment>> getAssignmentsByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    final db = await dbHelper.database;
    final result = await db.query(
      DatabaseHelper.assignmentTable,
      where: '${DatabaseHelper.assignmentDueDate} BETWEEN ? AND ?',
      whereArgs: [start.toIso8601String(), end.toIso8601String()],
      orderBy: '${DatabaseHelper.assignmentDueDate} ASC',
    );
    return result.map((json) => _assignmentFromMap(json)).toList();
  }

  // Get pending assignments (not completed)
  Future<List<Assignment>> getPendingAssignments() async {
    final db = await dbHelper.database;
    final result = await db.query(
      DatabaseHelper.assignmentTable,
      where: '${DatabaseHelper.assignmentIsCompleted} = ?',
      whereArgs: [0],
      orderBy: '${DatabaseHelper.assignmentDueDate} ASC',
    );
    return result.map((json) => _assignmentFromMap(json)).toList();
  }

  // Get completed assignments
  Future<List<Assignment>> getCompletedAssignments() async {
    final db = await dbHelper.database;
    final result = await db.query(
      DatabaseHelper.assignmentTable,
      where: '${DatabaseHelper.assignmentIsCompleted} = ?',
      whereArgs: [1],
      orderBy: '${DatabaseHelper.assignmentUpdatedAt} DESC',
    );
    return result.map((json) => _assignmentFromMap(json)).toList();
  }

  // Get count of assignments
  Future<int> getAssignmentCount() async {
    final db = await dbHelper.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM ${DatabaseHelper.assignmentTable}',
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  // Count pending assignments
  Future<int> getPendingAssignmentCount() async {
    final db = await dbHelper.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM ${DatabaseHelper.assignmentTable} WHERE ${DatabaseHelper.assignmentIsCompleted} = 0',
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  // Convert map to Assignment object
  Assignment _assignmentFromMap(Map<String, dynamic> map) {
    return Assignment(
      id: map[DatabaseHelper.assignmentId] ?? '',
      title: map[DatabaseHelper.assignmentTitle] ?? '',
      course: map[DatabaseHelper.assignmentCourse] ?? '',
      dueDate: DateTime.parse(
        map[DatabaseHelper.assignmentDueDate] ??
            DateTime.now().toIso8601String(),
      ),
      priority: map[DatabaseHelper.assignmentPriority] ?? 'Medium',
      isCompleted: (map[DatabaseHelper.assignmentIsCompleted] ?? 0) == 1,
    );
  }
}
