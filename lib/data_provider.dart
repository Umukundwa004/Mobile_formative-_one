import 'package:flutter/material.dart';
import 'models/models.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'services/assignment_dao.dart';
import 'services/academic_session_dao.dart';
import 'services/user_profile_dao.dart';
import 'dart:io' show Platform;

class DataProvider with ChangeNotifier {
  List<Assignment> assignments = [];
  List<AcademicSession> sessions = [];
  String userName = 'vestine UMUKUNDWA';
  String userEmail = 'vestine.umukundwa@alu.com';

  // Database DAOs
  late AssignmentDAO assignmentDAO;
  late AcademicSessionDAO sessionDAO;
  late UserProfileDAO userProfileDAO;

  bool _isInitialized = false;
  bool _isWeb = false;

  DataProvider() {
    _initializeDAOs();
    _isWeb = _checkIfWeb();
  }

  bool _checkIfWeb() {
    try {
      return !Platform.isAndroid &&
          !Platform.isIOS &&
          !Platform.isWindows &&
          !Platform.isLinux &&
          !Platform.isMacOS;
    } catch (e) {
      // If we can't determine platform, assume it might be web
      return true;
    }
  }

  void _initializeDAOs() {
    assignmentDAO = AssignmentDAO();
    sessionDAO = AcademicSessionDAO();
    userProfileDAO = UserProfileDAO();
  }

  // Initialize data from database
  Future<void> initializeData() async {
    if (_isInitialized) return;

    try {
      if (_isWeb) {
        // On web, skip database and use in-memory data
        _isInitialized = true;
        notifyListeners();
        return;
      }

      // Load assignments from database
      assignments = await assignmentDAO.getAllAssignments();

      // Load sessions from database
      sessions = await sessionDAO.getAllSessions();

      // Load user profile from database
      final userProfile = await userProfileDAO.getFirstUserProfile();
      if (userProfile != null) {
        userName = userProfile.name;
        userEmail = userProfile.email;
      } else {
        // If no user profile exists, save the default one
        await _initializeDefaultUserProfile();
      }

      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      print('Error initializing data: $e');
      // Continue with in-memory data
      _isInitialized = true;
      notifyListeners();
    }
  }

  Future<void> _initializeDefaultUserProfile() async {
    if (_isWeb) return;

    final profile = UserProfile(
      id: 'default_user',
      name: userName,
      email: userEmail,
    );
    await userProfileDAO.saveUserProfile(profile);
  }

  // Initialize with sample data (optional - for first time setup)
  Future<void> initializeSampleData() async {
    final now = DateTime.now();
    const uuid = Uuid();

    // Check if data already exists (skip on web)
    if (_isWeb) {
      // Initialize sample data in memory for web
      if (assignments.isNotEmpty) return;

      assignments = [
        Assignment(
          id: uuid.v4(),
          title: 'Mobile App Development Project',
          course: 'Introduction to Flutter Programming',
          dueDate: now.add(const Duration(days: 3)),
          priority: 'High',
          isCompleted: false,
        ),
        Assignment(
          id: uuid.v4(),
          title: 'Assignment 2',
          course: 'Web Development',
          dueDate: now.add(const Duration(days: 5)),
          priority: 'Medium',
          isCompleted: false,
        ),
        Assignment(
          id: uuid.v4(),
          title: 'Group Project',
          course: 'Mobile App (Flutter)',
          dueDate: now.add(const Duration(days: 20)),
          priority: 'Medium',
          isCompleted: false,
        ),
        Assignment(
          id: uuid.v4(),
          title: 'Quiz 1',
          course: 'Introduction to Linux',
          dueDate: now.add(const Duration(days: 7)),
          priority: 'Low',
          isCompleted: true,
        ),
      ];

      sessions = [
        AcademicSession(
          id: uuid.v4(),
          title: 'Introduction to Linux',
          date: now,
          startTime: '09:00',
          endTime: '10:30',
          location: 'egypt',
          sessionType: 'Class',
          isPresent: true,
        ),
        AcademicSession(
          id: uuid.v4(),
          title: 'Flutter Programming',
          date: now,
          startTime: '11:00',
          endTime: '12:30',
          location: 'morocco',
          sessionType: 'Class',
          isPresent: true,
        ),
        AcademicSession(
          id: uuid.v4(),
          title: 'Web Development',
          date: now.add(const Duration(days: 1)),
          startTime: '14:00',
          endTime: '15:30',
          location: 'ethiopia',
          sessionType: 'Class',
          isPresent: false,
        ),
        AcademicSession(
          id: uuid.v4(),
          title: 'Mastery Session - Flutter',
          date: now.add(const Duration(days: 2)),
          startTime: '15:00',
          endTime: '16:30',
          location: 'liberia',
          sessionType: 'In Person',
          isPresent: false,
        ),
      ];

      notifyListeners();
      return;
    }

    // Database version (mobile)
    final existingAssignments = await assignmentDAO.getAllAssignments();
    if (existingAssignments.isNotEmpty) {
      return; // Data already exists
    }

    // Sample assignments
    final sampleAssignments = [
      Assignment(
        id: uuid.v4(),
        title: 'Mobile App Development Project',
        course: 'Introduction to Flutter Programming',
        dueDate: now.add(const Duration(days: 3)),
        priority: 'High',
        isCompleted: false,
      ),
      Assignment(
        id: uuid.v4(),
        title: 'Assignment 2',
        course: 'Web Development',
        dueDate: now.add(const Duration(days: 5)),
        priority: 'Medium',
        isCompleted: false,
      ),
      Assignment(
        id: uuid.v4(),
        title: 'Group Project',
        course: 'Mobile App (Flutter)',
        dueDate: now.add(const Duration(days: 20)),
        priority: 'Medium',
        isCompleted: false,
      ),
      Assignment(
        id: uuid.v4(),
        title: 'Quiz 1',
        course: 'Introduction to Linux',
        dueDate: now.add(const Duration(days: 7)),
        priority: 'Low',
        isCompleted: true,
      ),
    ];

    // Sample sessions
    final sampleSessions = [
      AcademicSession(
        id: uuid.v4(),
        title: 'Introduction to Linux',
        date: now,
        startTime: '09:00',
        endTime: '10:30',
        location: 'egypt',
        sessionType: 'Class',
        isPresent: true,
      ),
      AcademicSession(
        id: uuid.v4(),
        title: 'Flutter Programming',
        date: now,
        startTime: '11:00',
        endTime: '12:30',
        location: 'morocco',
        sessionType: 'Class',
        isPresent: true,
      ),
      AcademicSession(
        id: uuid.v4(),
        title: 'Web Development',
        date: now.add(const Duration(days: 1)),
        startTime: '14:00',
        endTime: '15:30',
        location: 'ethiopia',
        sessionType: 'Class',
        isPresent: false,
      ),
      AcademicSession(
        id: uuid.v4(),
        title: 'Mastery Session - Flutter',
        date: now.add(const Duration(days: 2)),
        startTime: '15:00',
        endTime: '16:30',
        location: 'liberia',
        sessionType: 'In Person',
        isPresent: false,
      ),
    ];

    // Save to database
    for (var assignment in sampleAssignments) {
      await assignmentDAO.insertAssignment(assignment);
    }

    for (var session in sampleSessions) {
      await sessionDAO.insertSession(session);
    }

    // Update in-memory lists
    assignments = sampleAssignments;
    sessions = sampleSessions;
    notifyListeners();
  }

  // Assignment methods
  Future<void> addAssignment(Assignment assignment) async {
    assignments.add(assignment);
    if (!_isWeb) {
      await assignmentDAO.insertAssignment(assignment);
    }
    notifyListeners();
  }

  Future<void> updateAssignment(String id, Assignment updatedAssignment) async {
    final index = assignments.indexWhere((a) => a.id == id);
    if (index != -1) {
      assignments[index] = updatedAssignment;
      if (!_isWeb) {
        await assignmentDAO.updateAssignment(updatedAssignment);
      }
      notifyListeners();
    }
  }

  Future<void> deleteAssignment(String id) async {
    assignments.removeWhere((a) => a.id == id);
    if (!_isWeb) {
      await assignmentDAO.deleteAssignment(id);
    }
    notifyListeners();
  }

  Future<void> toggleAssignmentStatus(String id) async {
    final assignment = assignments.firstWhere((a) => a.id == id);
    assignment.isCompleted = !assignment.isCompleted;
    if (!_isWeb) {
      await assignmentDAO.updateAssignment(assignment);
    }
    notifyListeners();
  }

  List<Assignment> getUpcomingAssignments(int days) {
    final now = DateTime.now();
    final cutoffDate = now.add(Duration(days: days));
    final upcoming = assignments
        .where((a) => a.dueDate.isAfter(now) && a.dueDate.isBefore(cutoffDate))
        .toList();
    upcoming.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    return upcoming;
  }

  // Session methods
  Future<void> addSession(AcademicSession session) async {
    sessions.add(session);
    if (!_isWeb) {
      await sessionDAO.insertSession(session);
    }
    notifyListeners();
  }

  Future<void> updateSession(String id, AcademicSession updatedSession) async {
    final index = sessions.indexWhere((s) => s.id == id);
    if (index != -1) {
      sessions[index] = updatedSession;
      if (!_isWeb) {
        await sessionDAO.updateSession(updatedSession);
      }
      notifyListeners();
    }
  }

  Future<void> deleteSession(String id) async {
    sessions.removeWhere((s) => s.id == id);
    if (!_isWeb) {
      await sessionDAO.deleteSession(id);
    }
    notifyListeners();
  }

  Future<void> toggleAttendance(String id) async {
    final session = sessions.firstWhere((s) => s.id == id);
    session.isPresent = !session.isPresent;
    if (!_isWeb) {
      await sessionDAO.updateSession(session);
    }
    notifyListeners();
  }

  DateTime _dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  DateTime _startOfWeek(DateTime date) {
    final dateOnly = _dateOnly(date);
    final daysFromMonday = dateOnly.weekday - DateTime.monday;
    return dateOnly.subtract(Duration(days: daysFromMonday));
  }

  List<AcademicSession> getTodaySessions() {
    final now = DateTime.now();
    final today = _dateOnly(now);
    return sessions
        .where((s) => _dateOnly(s.date).compareTo(today) == 0)
        .toList();
  }

  List<AcademicSession> getWeekSessions() {
    final now = DateTime.now();
    final startOfWeek = _startOfWeek(now);
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    final weeklySessions = sessions.where((s) {
      final sessionDate = _dateOnly(s.date);
      return !sessionDate.isBefore(startOfWeek) &&
          !sessionDate.isAfter(endOfWeek);
    }).toList();
    weeklySessions.sort((a, b) => a.date.compareTo(b.date));
    return weeklySessions;
  }

  // Attendance calculation
  double getAttendancePercentage() {
    if (sessions.isEmpty) return 0.0;
    final presentCount = sessions.where((s) => s.isPresent).length;
    return (presentCount / sessions.length) * 100;
  }

  int getPendingAssignmentsCount() {
    return assignments.where((a) => !a.isCompleted).length;
  }

  // Calculate current academic week
  String getCurrentAcademicWeek() {
    final now = DateTime.now();
    // Assuming academic year starts in September
    final academicYearStart = DateTime(
      now.month >= 9 ? now.year : now.year - 1,
      9,
      1,
    );
    final weekNumber = ((now.difference(academicYearStart).inDays) ~/ 7) + 1;
    return 'Week $weekNumber';
  }

  // Get formatted date
  String getFormattedDate() {
    return DateFormat('EEEE, MMMM d, yyyy').format(DateTime.now());
  }

  // Get assignments due in next 7 days (excluding completed ones)
  List<Assignment> getUpcomingDueAssignments() {
    final now = DateTime.now();
    final sevenDaysLater = now.add(const Duration(days: 7));
    return assignments
        .where(
          (a) =>
              !a.isCompleted &&
              a.dueDate.isAfter(now) &&
              a.dueDate.isBefore(sevenDaysLater),
        )
        .toList()
      ..sort((a, b) => a.dueDate.compareTo(b.dueDate));
  }

  // Update user profile
  Future<void> updateUserProfile(String name, String email) async {
    userName = name;
    userEmail = email;

    if (!_isWeb) {
      // Save to database only on mobile/desktop
      final profile = UserProfile(id: 'default_user', name: name, email: email);
      await userProfileDAO.saveUserProfile(profile);
    }
    notifyListeners();
  }
}
