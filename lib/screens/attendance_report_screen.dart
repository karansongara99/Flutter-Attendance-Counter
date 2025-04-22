import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class AttendanceReportScreen extends StatelessWidget {
  final List<Map<String, dynamic>> attendanceHistory;
  final Map<String, String> classInfo;
  final bool isDarkMode;
  final VoidCallback onThemeToggle;

  const AttendanceReportScreen({
    super.key,
    required this.attendanceHistory,
    required this.classInfo,
    required this.isDarkMode,
    required this.onThemeToggle,
  });

  void _saveData(BuildContext context) {
    // TODO: Implement save functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Data saved successfully!')),
    );
  }

  void _copyData(BuildContext context) {
    final String data = attendanceHistory.map((record) {
      return '${record['semester']}, ${record['subject']}, ${record['date']}, '
          '${record['time']}, ${record['presentNumbers']}, ${record['absent']}, '
          '${record['total']}, ${record['absentNumbers']}';
    }).join('\n');

    Clipboard.setData(ClipboardData(text: data));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Data copied to clipboard!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance Report'),
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: onThemeToggle,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(isSmallScreen ? 8.0 : 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Class Info Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: EdgeInsets.all(isSmallScreen ? 12.0 : 16.0),
                  child: Wrap(
                    spacing: 16,
                    runSpacing: 8,
                    alignment: WrapAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Class: ${classInfo['class'] ?? ''}',
                        style: TextStyle(
                          fontSize: isSmallScreen ? 16 : 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Subject: ${classInfo['subject'] ?? ''}',
                        style: TextStyle(
                          fontSize: isSmallScreen ? 16 : 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Semester: ${classInfo['semester'] ?? ''}',
                        style: TextStyle(
                          fontSize: isSmallScreen ? 16 : 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Utility Buttons
              Wrap(
                spacing: isSmallScreen ? 8 : 16,
                runSpacing: isSmallScreen ? 8 : 16,
                alignment: WrapAlignment.center,
                children: [
                  _buildUtilityButton(
                    context: context,
                    onPressed: () => _saveData(context),
                    icon: Icons.save,
                    label: 'Save Data',
                    color: Colors.green,
                    isSmallScreen: isSmallScreen,
                  ),
                  _buildUtilityButton(
                    context: context,
                    onPressed: () => _copyData(context),
                    icon: Icons.copy,
                    label: 'Copy Data',
                    color: Colors.blue,
                    isSmallScreen: isSmallScreen,
                  ),
                  _buildUtilityButton(
                    context: context,
                    onPressed: () => Navigator.pop(context),
                    icon: Icons.home,
                    label: 'Back to Home',
                    color: Colors.grey,
                    isSmallScreen: isSmallScreen,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Summary Statistics
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: EdgeInsets.all(isSmallScreen ? 12.0 : 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Summary Statistics',
                        style: TextStyle(
                          fontSize: isSmallScreen ? 18 : 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStatCard(
                            'Total Records',
                            attendanceHistory.length.toString(),
                            Icons.list_alt,
                            Colors.blue,
                            isSmallScreen,
                          ),
                          _buildStatCard(
                            'Total Present',
                            attendanceHistory.isEmpty
                                ? '0'
                                : attendanceHistory.last['presentNumbers']
                                    .toString()
                                    .split(', ')
                                    .where((s) => s.isNotEmpty)
                                    .length
                                    .toString(),
                            Icons.check_circle,
                            Colors.green,
                            isSmallScreen,
                          ),
                          _buildStatCard(
                            'Total Absent',
                            attendanceHistory.isEmpty
                                ? '0'
                                : attendanceHistory.last['absentNumbers']
                                    .toString()
                                    .split(', ')
                                    .where((s) => s.isNotEmpty)
                                    .length
                                    .toString(),
                            Icons.cancel,
                            Colors.red,
                            isSmallScreen,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Attendance History Table
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Latest Attendance',
                        style: TextStyle(
                          fontSize: isSmallScreen ? 16 : 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (attendanceHistory.isNotEmpty)
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _buildInfoColumn(
                                  'Date',
                                  attendanceHistory.last['date'].toString(),
                                  isSmallScreen),
                              const SizedBox(width: 24),
                              _buildInfoColumn(
                                  'Time',
                                  attendanceHistory.last['time'].toString(),
                                  isSmallScreen),
                              const SizedBox(width: 24),
                              _buildInfoColumn(
                                  'Present Numbers',
                                  attendanceHistory.last['presentNumbers']
                                      .toString(),
                                  isSmallScreen,
                                  valueColor: Colors.green),
                              const SizedBox(width: 24),
                              _buildInfoColumn(
                                  'Absent Numbers',
                                  attendanceHistory.last['absentNumbers']
                                      .toString(),
                                  isSmallScreen,
                                  valueColor: Colors.red),
                            ],
                          ),
                        )
                      else
                        const Text('No attendance records yet')
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
    bool isSmallScreen,
  ) {
    return Card(
      elevation: 2,
      color: color.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: EdgeInsets.all(isSmallScreen ? 8.0 : 12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: isSmallScreen ? 24 : 32),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: isSmallScreen ? 12 : 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: isSmallScreen ? 16 : 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoColumn(String label, String value, bool isSmallScreen,
      {Color? valueColor}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isSmallScreen ? 12 : 14,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: isSmallScreen ? 14 : 16,
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
      ],
    );
  }

  Widget _buildUtilityButton({
    required BuildContext context,
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
    required Color color,
    required bool isSmallScreen,
  }) {
    return SizedBox(
      width: isSmallScreen ? 140 : 160,
      height: isSmallScreen ? 40 : 48,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: isSmallScreen ? 18 : 20),
        label: Text(
          label,
          style: TextStyle(fontSize: isSmallScreen ? 13 : 16),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: isSmallScreen ? 12 : 24,
            vertical: isSmallScreen ? 10 : 12,
          ),
        ),
      ),
    );
  }
}
