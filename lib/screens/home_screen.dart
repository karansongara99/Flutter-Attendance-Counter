import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onThemeToggle;

  const HomeScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeToggle,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? selectedClass;
  String? selectedSubject;
  String? selectedSemester;

  // Sample data for dropdowns
  final List<String> classes = [
    'Class A',
    'Class B',
    'Class C',
    'Class D',
    'Class E'
  ];
  final List<String> subjects = [
    'IOT',
    'Java Programming',
    'Web Technology',
    'Computer Network',
    'Flutter',
    'ASP.Net Core',
    'Data Structure'
  ];
  final List<String> semesters = [
    'Semester 1',
    'Semester 2',
    'Semester 3',
    'Semester 4',
    'Semester 5',
    'Semester 6'
  ];

  bool get isFormValid =>
      selectedClass != null &&
      selectedSubject != null &&
      selectedSemester != null;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text('Attendance Counter'),
            const SizedBox(width: 8),
            if (!isSmallScreen) const Text('Attendance Counter'),
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
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(isSmallScreen ? 12.0 : 16.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Card(
                      child: Padding(
                        padding: EdgeInsets.all(isSmallScreen ? 16.0 : 24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Icon(
                                Icons.school_outlined,
                                size: isSmallScreen ? 40 : 48,
                                color: Colors.blue,
                              ),
                            ),
                            SizedBox(height: isSmallScreen ? 20 : 24),
                            _buildDropdownSection(
                              title: 'Select Class',
                              value: selectedClass,
                              items: classes,
                              onChanged: (value) {
                                setState(() {
                                  selectedClass = value;
                                });
                              },
                              isSmallScreen: isSmallScreen,
                            ),
                            SizedBox(height: isSmallScreen ? 16 : 20),
                            _buildDropdownSection(
                              title: 'Select Subject',
                              value: selectedSubject,
                              items: subjects,
                              onChanged: (value) {
                                setState(() {
                                  selectedSubject = value;
                                });
                              },
                              isSmallScreen: isSmallScreen,
                            ),
                            SizedBox(height: isSmallScreen ? 16 : 20),
                            _buildDropdownSection(
                              title: 'Select Semester',
                              value: selectedSemester,
                              items: semesters,
                              onChanged: (value) {
                                setState(() {
                                  selectedSemester = value;
                                });
                              },
                              isSmallScreen: isSmallScreen,
                            ),
                            SizedBox(height: isSmallScreen ? 20 : 24),
                            SizedBox(
                              width: double.infinity,
                              height: isSmallScreen ? 44 : 48,
                              child: ElevatedButton.icon(
                                onPressed: isFormValid
                                    ? () {
                                        int startNumber;
                                        switch (selectedClass) {
                                          case 'Class A':
                                            startNumber = 101;
                                            break;
                                          case 'Class B':
                                            startNumber = 201;
                                            break;
                                          case 'Class C':
                                            startNumber = 301;
                                            break;
                                          case 'Class D':
                                            startNumber = 401;
                                            break;
                                          case 'Class E':
                                            startNumber = 501;
                                            break;
                                          default:
                                            startNumber = 101;
                                        }
                                        Navigator.pushNamed(
                                          context,
                                          '/attendance',
                                          arguments: <String, dynamic>{
                                            'class': selectedClass!,
                                            'subject': selectedSubject!,
                                            'semester': selectedSemester!,
                                            'startNumber': startNumber,
                                          },
                                        );
                                      }
                                    : null,
                                icon: const Icon(Icons.login),
                                label: Text(
                                  'Enter Attendance',
                                  style: TextStyle(
                                    fontSize: isSmallScreen ? 15 : 16,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownSection({
    required String title,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    required bool isSmallScreen,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: isSmallScreen ? 15 : 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: isSmallScreen ? 8 : 12,
            ),
          ),
          hint: Text(
            'Choose ${title.split(' ').last}',
            style: TextStyle(
              fontSize: isSmallScreen ? 14 : 15,
            ),
          ),
          items: items.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: TextStyle(
                  fontSize: isSmallScreen ? 14 : 15,
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
