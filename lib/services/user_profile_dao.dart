import 'package:sqflite/sqflite.dart';
import 'database_helper.dart';

class UserProfile {
  final String id;
  final String name;
  final String email;

  UserProfile({required this.id, required this.name, required this.email});

  Map<String, dynamic> toMap() {
    return {
      DatabaseHelper.userId: id,
      DatabaseHelper.userName: name,
      DatabaseHelper.userEmail: email,
      DatabaseHelper.userUpdatedAt: DateTime.now().toIso8601String(),
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map[DatabaseHelper.userId] ?? '',
      name: map[DatabaseHelper.userName] ?? '',
      email: map[DatabaseHelper.userEmail] ?? '',
    );
  }
}

class UserProfileDAO {
  final DatabaseHelper dbHelper = DatabaseHelper.instance;

  // Insert or update user profile
  Future<void> saveUserProfile(UserProfile profile) async {
    final db = await dbHelper.database;
    await db.insert(
      DatabaseHelper.userProfileTable,
      profile.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get user profile by ID
  Future<UserProfile?> getUserProfile(String userId) async {
    final db = await dbHelper.database;
    final result = await db.query(
      DatabaseHelper.userProfileTable,
      where: '${DatabaseHelper.userId} = ?',
      whereArgs: [userId],
    );

    if (result.isNotEmpty) {
      return UserProfile.fromMap(result.first);
    }
    return null;
  }

  // Get first user profile (assuming one user per device)
  Future<UserProfile?> getFirstUserProfile() async {
    final db = await dbHelper.database;
    final result = await db.query(DatabaseHelper.userProfileTable, limit: 1);

    if (result.isNotEmpty) {
      return UserProfile.fromMap(result.first);
    }
    return null;
  }

  // Update user profile
  Future<void> updateUserProfile(UserProfile profile) async {
    final db = await dbHelper.database;
    await db.update(
      DatabaseHelper.userProfileTable,
      {
        DatabaseHelper.userName: profile.name,
        DatabaseHelper.userEmail: profile.email,
        DatabaseHelper.userUpdatedAt: DateTime.now().toIso8601String(),
      },
      where: '${DatabaseHelper.userId} = ?',
      whereArgs: [profile.id],
    );
  }

  // Delete user profile
  Future<void> deleteUserProfile(String userId) async {
    final db = await dbHelper.database;
    await db.delete(
      DatabaseHelper.userProfileTable,
      where: '${DatabaseHelper.userId} = ?',
      whereArgs: [userId],
    );
  }

  // Delete all user profiles
  Future<void> deleteAllProfiles() async {
    final db = await dbHelper.database;
    await db.delete(DatabaseHelper.userProfileTable);
  }

  // Check if user exists
  Future<bool> userExists(String userId) async {
    final db = await dbHelper.database;
    final result = await db.query(
      DatabaseHelper.userProfileTable,
      where: '${DatabaseHelper.userId} = ?',
      whereArgs: [userId],
    );
    return result.isNotEmpty;
  }
}
