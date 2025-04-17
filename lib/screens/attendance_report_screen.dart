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
                            attendanceHistory
                                .fold(
                                    0,
                                    (sum, item) =>
                                        sum + (item['present'] as int))
                                .toString(),
                            Icons.check_circle,
                            Colors.green,
                            isSmallScreen,
                          ),
                          _buildStatCard(
                            'Total Absent',
                            attendanceHistory
                                .fold(
                                    0,
                                    (sum, item) =>
                                        sum + (item['absent'] as int))
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
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: screenSize.width - (isSmallScreen ? 32 : 48),
                    ),
                    child: DataTable(
                      columnSpacing: isSmallScreen ? 16 : 24,
                      horizontalMargin: isSmallScreen ? 8 : 16,
                      headingRowColor: MaterialStateProperty.all(
                        Theme.of(context).colorScheme.primaryContainer,
                      ),
                      dataRowColor: MaterialStateProperty.all(
                        Theme.of(context).colorScheme.surface,
                      ),
                      columns: [
                        DataColumn(
                          label: Text(
                            'Date',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: isSmallScreen ? 14 : 16,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Time',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: isSmallScreen ? 14 : 16,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Present Numbers',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: isSmallScreen ? 14 : 16,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Absent Numbers',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: isSmallScreen ? 14 : 16,
                            ),
                          ),
                        ),
                      ],
                      rows: attendanceHistory.map((record) {
                        return DataRow(
                          cells: [
                            DataCell(
                              Text(
                                record['date'].toString(),
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 12 : 14,
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                record['time'].toString(),
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 12 : 14,
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                record['presentNumbers'].toString(),
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: isSmallScreen ? 12 : 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                record['absentNumbers'].toString(),
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: isSmallScreen ? 12 : 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
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
          style: TextStyle(fontSize: isSmallScreen ? 14 : 16),
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
