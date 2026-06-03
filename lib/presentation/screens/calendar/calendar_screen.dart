import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/models/medication.dart';
import '../../../core/models/appointment.dart';
import '../track/track_screen.dart';
import '../profile/profile_screen.dart';

/// Calendar Screen - Shows calendar with medication and appointment schedules
class CalendarScreen extends StatefulWidget {
  final List<Medication> medications;
  final List<Appointment> appointments;

  const CalendarScreen({
    super.key,
    this.medications = const [],
    this.appointments = const [],
  });

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _selectedDate = DateTime.now();
  DateTime _focusedMonth = DateTime.now();
  Map<DateTime, List<CalendarEvent>> _events = {};

  @override
  void initState() {
    super.initState();
    _generateCalendarEvents();
  }

  void _generateCalendarEvents() {
    _events = {};

    // Generate events for upcoming medications (recurring daily for next 90 days to cover multiple months)
    for (var medication in widget.medications) {
      for (int i = 0; i < 90; i++) {
        final eventDate = DateTime.now().add(Duration(days: i));
        final dateKey = DateTime(
          eventDate.year,
          eventDate.month,
          eventDate.day,
        );

        // Extract time from medication.time (e.g., "Today, 10:00 AM" -> "10:00 AM")
        String time = medication.time.contains(',')
            ? medication.time.split(',').last.trim()
            : medication.time;

        final event = CalendarEvent(
          title: '${medication.name} - ${medication.dosage.split('\n')[0]}',
          time: time,
          type: CalendarEventType.medication,
          status: i == 0 ? medication.status.displayName : 'upcoming',
        );

        _events[dateKey] = (_events[dateKey] ?? [])..add(event);
      }
    }

    // Generate events for appointments
    for (var appointment in widget.appointments) {
      // Parse appointment dateTime to get actual date
      // For now, we'll add appointments to specific dates
      DateTime eventDate;

      if (appointment.dateTime.contains('Oct')) {
        // Parse October dates
        if (appointment.dateTime.contains('9')) {
          eventDate = DateTime(2025, 10, 9); // Today
        } else if (appointment.dateTime.contains('10')) {
          eventDate = DateTime(2025, 10, 10);
        } else if (appointment.dateTime.contains('11')) {
          eventDate = DateTime(2025, 10, 11);
        } else {
          eventDate = DateTime(2025, 10, 15); // Default future date
        }
      } else {
        // Default to next week for other appointments
        eventDate = DateTime.now().add(const Duration(days: 7));
      }

      final dateKey = DateTime(eventDate.year, eventDate.month, eventDate.day);

      final event = CalendarEvent(
        title: appointment.title,
        time: appointment.dateTime.contains('-')
            ? appointment.dateTime.split('-').last.trim()
            : '2:00 pm',
        type: CalendarEventType.appointment,
        status: appointment.status.displayName,
      );

      _events[dateKey] = (_events[dateKey] ?? [])..add(event);
    }
  }

  void _goToPreviousMonth() {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month - 1);
      // Reset selected date to first day of new month
      _selectedDate = DateTime(_focusedMonth.year, _focusedMonth.month, 1);
    });
  }

  void _goToNextMonth() {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1);
      // Reset selected date to first day of new month
      _selectedDate = DateTime(_focusedMonth.year, _focusedMonth.month, 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 24),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_outlined,
              color: Colors.black,
              size: 28,
            ),
            onPressed: () {
              // Handle notifications
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Calendar header with month/year and navigation
          _buildCalendarHeader(),

          // Calendar grid
          _buildCalendar(), const SizedBox(height: 20),

          // Day details section
          _buildDayDetailsSection(),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildCalendarHeader() {
    final monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    final dayNames = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Day name
          Text(
            dayNames[_selectedDate.weekday - 1],
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),

          // Date with navigation arrows
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Previous month button
              GestureDetector(
                onTap: _goToPreviousMonth,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: const Icon(
                    Icons.chevron_left,
                    color: Colors.black,
                    size: 24,
                  ),
                ),
              ),

              // Full date
              Text(
                '${_selectedDate.day} ${monthNames[_focusedMonth.month - 1]} ${_focusedMonth.year}',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),

              // Next month button
              GestureDetector(
                onTap: _goToNextMonth,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: const Icon(
                    Icons.chevron_right,
                    color: Colors.black,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          // Week day headers
          _buildWeekDayHeaders(),

          const SizedBox(height: 16),

          // Calendar dates grid
          _buildCalendarGrid(),
        ],
      ),
    );
  }

  Widget _buildWeekDayHeaders() {
    const weekDays = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: weekDays.map((day) {
        return SizedBox(
          width: 40,
          child: Text(
            day,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCalendarGrid() {
    final firstDayOfMonth = DateTime(
      _focusedMonth.year,
      _focusedMonth.month,
      1,
    );
    final lastDayOfMonth = DateTime(
      _focusedMonth.year,
      _focusedMonth.month + 1,
      0,
    );
    final firstWeekdayOfMonth =
        firstDayOfMonth.weekday % 7; // Convert to 0-6 where Sunday = 0

    final daysInMonth = lastDayOfMonth.day;
    final totalCells = ((daysInMonth + firstWeekdayOfMonth - 1) / 7).ceil() * 7;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1,
      ),
      itemCount: totalCells,
      itemBuilder: (context, index) {
        final dayNumber = index - firstWeekdayOfMonth + 1;

        if (dayNumber < 1 || dayNumber > daysInMonth) {
          return const SizedBox(); // Empty cell
        }

        final date = DateTime(
          _focusedMonth.year,
          _focusedMonth.month,
          dayNumber,
        );
        final isSelected = _isSameDay(date, _selectedDate);
        final hasEvents = _events.containsKey(date);

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedDate = date;
            });
          },
          child: Container(
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF407CE2) : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Text(
                  dayNumber.toString(),
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                ),
                if (hasEvents && !isSelected)
                  Positioned(bottom: 6, child: _buildEventIndicators(date)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEventIndicators(DateTime date) {
    final events = _events[date] ?? [];
    if (events.isEmpty) return const SizedBox();

    // Count different types of events
    final medications = events
        .where((e) => e.type == CalendarEventType.medication)
        .length;
    final appointments = events
        .where((e) => e.type == CalendarEventType.appointment)
        .length;

    List<Widget> indicators = [];

    // Add medication indicator (blue)
    if (medications > 0) {
      indicators.add(
        Container(
          width: 6,
          height: 6,
          margin: const EdgeInsets.symmetric(horizontal: 1),
          decoration: const BoxDecoration(
            color: Color(0xFF407CE2), // Blue for medications
            shape: BoxShape.circle,
          ),
        ),
      );
    }

    // Add appointment indicator (green)
    if (appointments > 0) {
      indicators.add(
        Container(
          width: 6,
          height: 6,
          margin: const EdgeInsets.symmetric(horizontal: 1),
          decoration: const BoxDecoration(
            color: Color(0xFF4CAF50), // Green for appointments
            shape: BoxShape.circle,
          ),
        ),
      );
    }

    return Row(mainAxisSize: MainAxisSize.min, children: indicators);
  }

  Widget _buildDayDetailsSection() {
    final selectedEvents = _events[_selectedDate] ?? [];

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Day Details',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Handle see all
                  },
                  child: Text(
                    'See all',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF407CE2),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Events list
          Expanded(
            child: selectedEvents.isEmpty
                ? _buildEmptyDayState()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: selectedEvents.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildEventCard(selectedEvents[index]),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyDayState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_today_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No events for this day',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard(CalendarEvent event) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Event icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: event.type == CalendarEventType.medication
                  ? const Color(0xFF407CE2).withOpacity(0.1)
                  : const Color(0xFF4CAF50).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              event.type == CalendarEventType.medication
                  ? Icons.medication
                  : Icons.person,
              color: event.type == CalendarEventType.medication
                  ? const Color(0xFF407CE2)
                  : const Color(0xFF4CAF50),
              size: 20,
            ),
          ),

          const SizedBox(width: 12),

          // Event details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  event.time,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

          // Status badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _getStatusColor(event.status),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              event.status,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'completed':
        return const Color(0xFF4CAF50);
      case 'upcoming':
        return const Color(0xFF6B7280);
      case 'missed':
        return const Color(0xFFF44336);
      default:
        return const Color(0xFF6B7280);
    }
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      height: 85,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildBottomNavItem(
            AppAssets.homeMenu,
            AppAssets.homeMenuSelected,
            'Home',
            false,
          ),
          _buildBottomNavItem(
            AppAssets.calendarMenu,
            AppAssets.calendarMenuSelected,
            'Calendar',
            true, // Calendar is selected
          ),
          _buildBottomNavItem(
            AppAssets.trackMenu,
            AppAssets.trackMenuSelected,
            'Track',
            false,
          ),
          _buildBottomNavItem(
            AppAssets.profileMenu,
            AppAssets.profileMenuSelected,
            'Profile',
            false,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavItem(
    String normalAsset,
    String selectedAsset,
    String label,
    bool isSelected,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (!isSelected) {
            _handleNavigation(label);
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              child: Image.asset(
                isSelected ? selectedAsset : normalAsset,
                width: 30,
                height: 30,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isSelected ? const Color(0xFF407CE2) : Colors.grey[400],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleNavigation(String label) {
    switch (label) {
      case 'Home':
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        break;
      case 'Track':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => TrackScreen(
              medications: widget.medications,
              appointments: widget.appointments,
            ),
          ),
        );
        break;
      case 'Profile':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ProfileScreen()),
        );
        break;
    }
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}

/// Calendar event model
class CalendarEvent {
  final String title;
  final String time;
  final CalendarEventType type;
  final String status;

  CalendarEvent({
    required this.title,
    required this.time,
    required this.type,
    required this.status,
  });
}

/// Calendar event types
enum CalendarEventType { medication, appointment }
