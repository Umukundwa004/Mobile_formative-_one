import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../data_provider.dart';

class AnnouncementsScreen extends StatelessWidget {
  const AnnouncementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    final horizontalPadding = isSmallScreen ? 12.0 : 16.0;

    return Scaffold(
      backgroundColor: const Color(0xFF1A2C5A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A2C5A),
        elevation: 0,
        title: Text(
          'Announcements',
          style: TextStyle(
            color: Colors.white,
            fontSize: isSmallScreen ? 18 : 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Consumer<DataProvider>(
        builder: (context, dataProvider, child) {
          final upcomingAssignments = dataProvider.getUpcomingDueAssignments();
          final pendingCount = dataProvider.getPendingAssignmentsCount();

          return SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(horizontalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Announcements Header
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Assignment Announcements',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 18 : 20,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1A2C5A),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Assignments Overview
                  if (pendingCount > 0)
                    _buildAnnouncementCard(
                      title: 'Pending Assignments',
                      description:
                          'You have $pendingCount assignment${pendingCount > 1 ? 's' : ''} to complete. Check the Assignments tab for details.',
                      color: const Color(0xFFFFEBEE),
                      borderColor: const Color(0xFFE53935),
                      isSmallScreen: isSmallScreen,
                    ),
                  if (pendingCount > 0) const SizedBox(height: 16),

                  // Upcoming Assignments
                  if (upcomingAssignments.isNotEmpty)
                    _buildAnnouncementCard(
                      title: 'Upcoming Deadlines',
                      description:
                          'You have ${upcomingAssignments.length} assignment${upcomingAssignments.length > 1 ? 's' : ''} due within the next 7 days.',
                      color: const Color(0xFFF5F5F5),
                      borderColor: const Color(0xFFFFB800),
                      isSmallScreen: isSmallScreen,
                    ),
                  if (upcomingAssignments.isNotEmpty)
                    const SizedBox(height: 16),

                  // List of upcoming assignments
                  if (upcomingAssignments.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      child: Text(
                        'Due Soon',
                        style: TextStyle(
                          fontSize: isSmallScreen ? 14 : 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...upcomingAssignments.map((assignment) {
                      final daysRemaining = assignment.dueDate
                          .difference(DateTime.now())
                          .inDays;
                      final isUrgent = daysRemaining <= 2;

                      return _buildAssignmentAnnouncement(
                        title: assignment.title,
                        course: assignment.course,
                        dueDate: assignment.dueDate,
                        daysRemaining: daysRemaining,
                        priority: assignment.priority,
                        isUrgent: isUrgent,
                        isSmallScreen: isSmallScreen,
                      );
                    }),
                  ],

                  // No pending assignments message
                  if (pendingCount == 0 && upcomingAssignments.isEmpty)
                    _buildAnnouncementCard(
                      title: 'Great Job!',
                      description:
                          'You have no pending assignments. Keep up the good work!',
                      color: const Color(0xFFF1F8E9),
                      borderColor: const Color(0xFF4CAF50),
                      isSmallScreen: isSmallScreen,
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAnnouncementCard({
    required String title,
    required String description,
    required Color color,
    required Color borderColor,
    bool isSmallScreen = false,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isSmallScreen ? 14.0 : 16.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: isSmallScreen ? 14 : 16,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1A2C5A),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              fontSize: isSmallScreen ? 13 : 14,
              color: Colors.grey[700],
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssignmentAnnouncement({
    required String title,
    required String course,
    required DateTime dueDate,
    required int daysRemaining,
    required String priority,
    required bool isUrgent,
    bool isSmallScreen = false,
  }) {
    final dateFormat = DateFormat('MMM d');
    final priorityColor = _getPriorityColor(priority);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(isSmallScreen ? 10.0 : 12.0),
      decoration: BoxDecoration(
        color: const Color(0xFF2C4A7E),
        borderRadius: BorderRadius.circular(12),
        border: isUrgent
            ? Border.all(color: const Color(0xFFE53935), width: 1.5)
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isSmallScreen ? 13 : 14,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      course,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: isSmallScreen ? 11 : 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (isUrgent)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE53935),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'URGENT',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    color: Colors.white70,
                    size: 14,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Due: ${dateFormat.format(dueDate)}',
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: priorityColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: priorityColor),
                ),
                child: Text(
                  priority,
                  style: TextStyle(
                    color: priorityColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            daysRemaining <= 0
                ? 'Due today!'
                : daysRemaining == 1
                ? 'Due tomorrow'
                : 'Due in $daysRemaining days',
            style: TextStyle(
              color: daysRemaining <= 1
                  ? const Color(0xFFE53935)
                  : Colors.white70,
              fontSize: 12,
              fontWeight: daysRemaining <= 1
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'High':
        return const Color(0xFFE53935);
      case 'Medium':
        return const Color(0xFFFFB800);
      case 'Low':
        return const Color(0xFF4CAF50);
      default:
        return Colors.grey;
    }
  }
}
