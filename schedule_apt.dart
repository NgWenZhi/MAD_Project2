import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:mad_project_test1/patient_dashboard.dart';
import 'package:mad_project_test1/user.dart';
import 'package:mad_project_test1/userdataservice.dart';
import 'package:mad_project_test1/slotsdataservice.dart';
import 'package:mad_project_test1/appointmentsdataservice.dart';
import 'package:mad_project_test1/healthsummary.dart';
import 'package:mad_project_test1/profile_page.dart';

class ScheduleAppointmentPage extends StatefulWidget {
  final AppUser user;

  const ScheduleAppointmentPage({super.key, required this.user});

  @override
  State<ScheduleAppointmentPage> createState() =>
      _ScheduleAppointmentPageState();
}

class _ScheduleAppointmentPageState extends State<ScheduleAppointmentPage> {
  String _query = "";
  DateTime selectedDate = DateTime.now();
  int currentIndex = 1;

  // doctorId -> selected slot index
  final Map<String, int> _selectedSlotIndex = {};

  String _formatDate(DateTime date) {
    const months = [
      "JAN",
      "FEB",
      "MAR",
      "APR",
      "MAY",
      "JUN",
      "JUL",
      "AUG",
      "SEP",
      "OCT",
      "NOV",
      "DEC",
    ];
    return "${months[date.month - 1]} ${date.day}, ${date.year}";
  }

  DateTime _combineDateAndTime(DateTime date, String time) {
    final parts = time.split(" ");
    final hm = parts[0].split(":");

    int hour = int.parse(hm[0]);
    int minute = int.parse(hm[1]);

    if (parts[1] == "PM" && hour != 12) hour += 12;
    if (parts[1] == "AM" && hour == 12) hour = 0;

    return DateTime(date.year, date.month, date.day, hour, minute);
  }

  @override
  Widget build(BuildContext context) {
    final doctors = UserDataService.doctors.where((d) {
      if (_query.trim().isEmpty) return true;
      return d.name.toLowerCase().contains(_query.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    "Schedule Visit",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Search
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  onChanged: (v) => setState(() => _query = v),
                  decoration: const InputDecoration(
                    hintText: "Search doctor",
                    prefixIcon: Icon(Icons.search),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Date picker
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: CalendarDatePicker(
                  initialDate: selectedDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2030),
                  onDateChanged: (date) {
                    setState(() {
                      selectedDate = date;
                      _selectedSlotIndex.clear();
                    });
                  },
                ),
              ),

              const SizedBox(height: 12),

              Expanded(
                child: ListView.builder(
                  itemCount: doctors.length,
                  itemBuilder: (_, i) {
                    final doctor = doctors[i];
                    final slotsSet = SlotsDataService.getAvailability(
                      doctor.doctorId!,
                      selectedDate,
                    );

                    if (slotsSet.isEmpty) return const SizedBox();

                    final slots = slotsSet.toList();
                    final selectedIdx = _selectedSlotIndex[doctor.doctorId];

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _DoctorCard(
                        name: doctor.name,
                        initials: doctor.name
                            .split(" ")
                            .map((e) => e[0])
                            .take(2)
                            .join()
                            .toUpperCase(),
                        dateLabel: _formatDate(selectedDate),
                        slots: slots,
                        selectedSlotIndex: selectedIdx,
                        onSlotTap: (idx) {
                          setState(() {
                            final id = doctor.doctorId!;
                            if (_selectedSlotIndex[id] == idx) {
                              _selectedSlotIndex.remove(id);
                            } else {
                              _selectedSlotIndex.clear();
                              _selectedSlotIndex[id] = idx;
                            }
                          });
                        },
                        onConfirm: selectedIdx == null
                            ? null
                            : () {
                                final time = slots[selectedIdx];

                                AppointmentsDataService.add(
                                  Appointment(
                                    doctorId: doctor.doctorId!,
                                    patientName: widget.user.name,
                                    dateTime: _combineDateAndTime(
                                      selectedDate,
                                      time,
                                    ),
                                  ),
                                );

                                slotsSet.remove(time);
                                SlotsDataService.saveAvailability(
                                  doctor.doctorId!,
                                  selectedDate,
                                  slotsSet,
                                );

                                setState(() {
                                  _selectedSlotIndex.clear();
                                });

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "Booked ${doctor.name} • ${_formatDate(selectedDate)} • $time",
                                    ),
                                  ),
                                );
                              },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),

      // ✅ Bottom navigation FIXED
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black45,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          if (index == currentIndex) return;
          setState(() => currentIndex = index);

          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PatientDashboard(user: widget.user),
              ),
            );
          }

          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => HealthSummaryPage(user: widget.user),
              ),
            );
          }

          if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ProfilePage(user: widget.user)),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_note_rounded),
            label: "Appointments",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder_copy_outlined),
            label: "Records",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}

class _DoctorCard extends StatelessWidget {
  final String name;
  final String initials;
  final String dateLabel;
  final List<String> slots;

  final int? selectedSlotIndex;
  final Function(int) onSlotTap;
  final VoidCallback? onConfirm;

  const _DoctorCard({
    required this.name,
    required this.initials,
    required this.dateLabel,
    required this.slots,
    required this.selectedSlotIndex,
    required this.onSlotTap,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Doctor header
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: Colors.grey.shade200,
                child: Text(
                  initials,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Text(
            "AVAILABILITY · $dateLabel",
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: Colors.grey.shade600,
            ),
          ),

          const SizedBox(height: 8),

          SizedBox(
            height: 76,
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                dragDevices: {
                  PointerDeviceKind.touch,
                  PointerDeviceKind.mouse,
                  PointerDeviceKind.trackpad,
                },
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(slots.length, (i) {
                    final bool isSelected = selectedSlotIndex == i;

                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: InkWell(
                        onTap: () => onSlotTap(i),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          width: 110,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.teal
                                : const Color(0xFFF3F5F9),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                dateLabel,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.black87,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                slots[i],
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),

          const SizedBox(height: 14),

          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: onConfirm,
              style: ElevatedButton.styleFrom(
                backgroundColor: onConfirm == null
                    ? Colors.grey.shade400
                    : Colors.teal,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Confirm Appointment",
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
