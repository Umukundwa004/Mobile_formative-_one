import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data_provider.dart';
import 'attendance_detail.dart';
import 'profile.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    final horizontalPadding = screenWidth < 360 ? 12.0 : 16.0;

    return Scaffold(
      backgroundColor: const Color(0xFF1A2C5A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A2C5A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Dashboard',
          style: TextStyle(
            color: Colors.white,
            fontSize: isSmallScreen ? 18 : 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
        ],
      ),
      body: Consumer<DataProvider>(
        builder: (context, dataProvider, child) {
          final todaySessions = dataProvider.getTodaySessions();
          final upcomingAssignments = dataProvider.getUpcomingDueAssignments();
          final attendancePercentage = dataProvider.getAttendancePercentage();
          final pendingCount = dataProvider.getPendingAssignmentsCount();
          final formattedDate = dataProvider.getFormattedDate();
          final academicWeek = dataProvider.getCurrentAcademicWeek();
          final attendanceLabel = '${attendancePercentage.toStringAsFixed(0)}%';

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // All Selected Courses Dropdown
                Container(
                  margin: EdgeInsets.all(horizontalPadding),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2C4A7E),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'All Selected Courses',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isSmallScreen ? 12 : 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Icon(Icons.keyboard_arrow_down, color: Colors.white),
                    ],
                  ),
                ),

                // ATRISK WARNING Button
                if (attendancePercentage < 75)
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: horizontalPadding),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE53935),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.warning, color: Colors.white, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'ATRISK WARNING',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: isSmallScreen ? 12 : 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 16),

                // Stats Row
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final boxSpacing = isSmallScreen ? 8.0 : 12.0;
                      return Row(
                        children: [
                          Expanded(
                            child: _buildStatBox(
                              count: pendingCount.toString(),
                              label: 'Pending\nAssignments',
                              isSmallScreen: isSmallScreen,
                            ),
                          ),
                          SizedBox(width: boxSpacing),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const AttendanceDetailScreen(),
                                  ),
                                );
                              },
                              child: _buildStatBox(
                                count: attendanceLabel,
                                label: 'Attendance',
                                isClickable: true,
                                isSmallScreen: isSmallScreen,
                              ),
                            ),
                          ),
                          SizedBox(width: boxSpacing),
                          Expanded(
                            child: _buildStatBox(
                              count: upcomingAssignments.length.toString(),
                              label: 'Due Next\n7 Days',
                              isSmallScreen: isSmallScreen,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),

                // Today's Classes Section
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: Text(
                    'Today\'s Sessions',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isSmallScreen ? 14 : 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Date and Academic Week
                Container(
                  margin: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2C4A7E),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        formattedDate,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isSmallScreen ? 12 : 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        academicWeek,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: isSmallScreen ? 11 : 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                if (todaySessions.isEmpty)
                  _buildEmptyState(context, 'No sessions scheduled for today')
                else
                  ...todaySessions.map(
                    (session) => _buildClassItem(
                      context,
                      title: session.title,
                      subtitle: '${session.startTime} - ${session.endTime}',
                    ),
                  ),

                const SizedBox(height: 20),

                // Upcoming Assignments Section
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: Text(
                    'Assignments Due Soon',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isSmallScreen ? 14 : 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                if (upcomingAssignments.isEmpty)
                  _buildEmptyState(
                    context,
                    'No assignments due in the next 7 days',
                  )
                else
                  ...upcomingAssignments.map(
                    (assignment) => _buildClassItem(
                      context,
                      title: assignment.title,
                      subtitle:
                          'Due ${assignment.dueDate.day}/${assignment.dueDate.month}',
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatBox({
    required String count,
    required String label,
    bool isClickable = false,
    bool isSmallScreen = false,
  }) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 12.0 : 16.0),
      decoration: BoxDecoration(
        color: const Color(0xFF2C4A7E),
        borderRadius: BorderRadius.circular(8),
        border: isClickable
            ? Border.all(color: const Color(0xFFFFB800), width: 1.5)
            : null,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                count,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isSmallScreen ? 20 : 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (isClickable) ...[
                const SizedBox(width: 4),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Color(0xFFFFB800),
                  size: 14,
                ),
              ],
            ],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white70,
              fontSize: isSmallScreen ? 10 : 11,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClassItem(
    BuildContext context, {
    required String title,
    String? subtitle,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth < 360 ? 12.0 : 16.0;
    final isSmallScreen = screenWidth < 360;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: const Color(0xFF1A2C5A),
                    fontSize: isSmallScreen ? 13 : 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: isSmallScreen ? 11 : 12,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, String message) {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth < 360 ? 12.0 : 16.0;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        message,
        style: const TextStyle(
          color: Color(0xFF1A2C5A),
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
