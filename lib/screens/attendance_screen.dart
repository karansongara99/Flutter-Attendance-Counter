import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:attendance_flutter/screens/attendance_report_screen.dart';

class AttendanceScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onThemeToggle;

  const AttendanceScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeToggle,
  });

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  int _presentCount = 0;
  int _absentCount = 0;
  int _currentNumber = 101;
  final List<String> _absentNumbers = [];
  final List<String> _presentNumbers = [];
  Map<String, String> _classInfo = {};
  final List<Map<String, dynamic>> _attendanceHistory = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null) {
        setState(() {
          _currentNumber = args['startNumber'] as int? ?? 101;
          _classInfo = {
            'class': args['class']?.toString() ?? '',
            'subject': args['subject']?.toString() ?? '',
            'semester': args['semester']?.toString() ?? '',
          };
        });
      }
    });
  }

  void _markPresent() {
    setState(() {
      _presentCount++;
      _presentNumbers.add(_currentNumber.toString());
      _currentNumber++;
    });
    _addToHistory(true);
  }

  void _markAbsent() {
    setState(() {
      _absentCount++;
      _absentNumbers.add(_currentNumber.toString());
      _currentNumber++;
    });
    _addToHistory(false);
  }

  void _updateAttendanceHistory() {
    if (_attendanceHistory.isEmpty) return;

    // Update the last entry
    setState(() {
      _attendanceHistory.last.update('present', (value) => _presentCount);
      _attendanceHistory.last.update('absent', (value) => _absentCount);
      _attendanceHistory.last
          .update('total', (value) => _presentCount + _absentCount);
      _attendanceHistory.last
          .update('presentNumbers', (value) => _presentNumbers.join(', '));
      _attendanceHistory.last
          .update('absentNumbers', (value) => _absentNumbers.join(', '));
    });
  }

  void _addToHistory(bool isPresent) {
    final now = DateTime.now();
    setState(() {
      _attendanceHistory.add({
        'semester': _classInfo['semester'] ?? '',
        'subject': _classInfo['subject'] ?? '',
        'date': DateFormat('yyyy-MM-dd').format(now),
        'time': DateFormat('HH:mm:ss a').format(now),
        'present': isPresent ? 1 : 0,
        'absent': isPresent ? 0 : 1,
        'total': 1,
        'presentNumbers': isPresent ? _currentNumber.toString() : '',
        'absentNumbers': isPresent ? '' : _currentNumber.toString(),
      });
    });
  }

  void _navigateToReport() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AttendanceReportScreen(
          attendanceHistory: _attendanceHistory,
          classInfo: _classInfo,
          isDarkMode: widget.isDarkMode,
          onThemeToggle: widget.onThemeToggle,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('Attendance Counter'),
            const Spacer(),
            IconButton(
              icon:
                  Icon(widget.isDarkMode ? Icons.light_mode : Icons.dark_mode),
              onPressed: widget.onThemeToggle,
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: SingleChildScrollView(
              padding: EdgeInsets.all(isSmallScreen ? 8.0 : 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header with class info
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(isSmallScreen ? 12.0 : 16.0),
                      child: Wrap(
                        spacing: 16,
                        runSpacing: 8,
                        alignment: WrapAlignment.spaceEvenly,
                        children: [
                          Text(
                            'Class: ${_classInfo['class'] ?? ''}',
                            style: TextStyle(
                              fontSize: isSmallScreen ? 16 : 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Subject: ${_classInfo['subject'] ?? ''}',
                            style: TextStyle(
                              fontSize: isSmallScreen ? 16 : 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Semester: ${_classInfo['semester'] ?? ''}',
                            style: TextStyle(
                              fontSize: isSmallScreen ? 16 : 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 16 : 20),

                  // Current Number and Counters
                  if (!isSmallScreen)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: _buildCurrentNumber(isSmallScreen),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 3,
                          child: Row(
                            children: [
                              Expanded(
                                  child: _buildCounter(
                                      'Present', _presentCount, Colors.green)),
                              const SizedBox(width: 16),
                              Expanded(
                                  child: _buildCounter(
                                      'Absent', _absentCount, Colors.red)),
                            ],
                          ),
                        ),
                      ],
                    )
                  else ...[
                    _buildCurrentNumber(isSmallScreen),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                            child: _buildCounter(
                                'Present', _presentCount, Colors.green)),
                        const SizedBox(width: 8),
                        Expanded(
                            child: _buildCounter(
                                'Absent', _absentCount, Colors.red)),
                      ],
                    ),
                  ],
                  SizedBox(height: isSmallScreen ? 16 : 20),

                  // Action Buttons
                  Wrap(
                    spacing: isSmallScreen ? 8 : 16,
                    runSpacing: isSmallScreen ? 8 : 16,
                    alignment: WrapAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: isSmallScreen ? 140 : 160,
                        height: isSmallScreen ? 40 : 48,
                        child: ElevatedButton(
                          onPressed: _markPresent,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Present',
                            style: TextStyle(fontSize: isSmallScreen ? 16 : 18),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: isSmallScreen ? 140 : 160,
                        height: isSmallScreen ? 40 : 48,
                        child: ElevatedButton(
                          onPressed: _markAbsent,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Absent',
                            style: TextStyle(fontSize: isSmallScreen ? 16 : 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: isSmallScreen ? 16 : 20),

                  // Utility Buttons
                  Wrap(
                    spacing: isSmallScreen ? 8 : 16,
                    runSpacing: isSmallScreen ? 8 : 16,
                    alignment: WrapAlignment.center,
                    children: [
                      SizedBox(
                        width: isSmallScreen ? 160 : 180,
                        height: isSmallScreen ? 40 : 48,
                        child: ElevatedButton.icon(
                          onPressed: _navigateToReport,
                          icon: Icon(Icons.assessment,
                              size: isSmallScreen ? 18 : 20),
                          label: Text(
                            'View Report',
                            style: TextStyle(fontSize: isSmallScreen ? 14 : 16),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: isSmallScreen ? 160 : 180,
                        height: isSmallScreen ? 40 : 48,
                        child: ElevatedButton.icon(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(Icons.home, size: isSmallScreen ? 18 : 20),
                          label: Text(
                            'Back to Home',
                            style: TextStyle(fontSize: isSmallScreen ? 13 : 16),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: isSmallScreen ? 16 : 20),

                  // Present Students Section
                  if (_presentNumbers.isNotEmpty) ...[
                    Text(
                      'Present Students',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 18 : 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _presentNumbers.map((number) {
                        return Chip(
                          label: Text(number),
                          backgroundColor: Colors.green.shade100,
                          deleteIcon: const Icon(Icons.close, size: 18),
                          onDeleted: () {
                            setState(() {
                              _presentNumbers.remove(number);
                              _presentCount--;
                              // Update attendance history
                              _updateAttendanceHistory();
                            });
                          },
                        );
                      }).toList(),
                    ),
                    SizedBox(height: isSmallScreen ? 16 : 20),
                  ],

                  // Absent Students Section
                  if (_absentNumbers.isNotEmpty) ...[
                    Text(
                      'Absent Students',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 18 : 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _absentNumbers.map((number) {
                        return Chip(
                          label: Text(number),
                          backgroundColor: Colors.red.shade100,
                          deleteIcon: const Icon(Icons.close, size: 18),
                          onDeleted: () {
                            setState(() {
                              _absentNumbers.remove(number);
                              _absentCount--;
                              // Update attendance history
                              _updateAttendanceHistory();
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentNumber(bool isSmallScreen) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(isSmallScreen ? 16.0 : 24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Current Number',
              style: TextStyle(
                fontSize: isSmallScreen ? 18 : 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: isSmallScreen ? 12 : 16),
            Text(
              _currentNumber.toString(),
              style: TextStyle(
                fontSize: isSmallScreen ? 36 : 48,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCounter(String title, int count, Color color) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              count.toString(),
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
