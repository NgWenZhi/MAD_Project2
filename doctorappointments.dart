import 'package:flutter/material.dart';
import 'package:mad_project_test1/doctorportal.dart';
import 'package:mad_project_test1/patients_page.dart';
import 'package:mad_project_test1/slotsdataservice.dart';

class DoctorAppointments extends StatefulWidget {
  final String doctorId;

  const DoctorAppointments({super.key, required this.doctorId});

  @override
  State<DoctorAppointments> createState() => _DoctorAppointmentsState();
}

class _DoctorAppointmentsState extends State<DoctorAppointments> {
  DateTime selectedDate = DateTime.now();

  /// 🔹 Slots patient CAN still book
  Set<String> availableSlots = {};

  /// 🔹 Slots doctor currently selected (UI only)
  Set<String> selectedSlots = {};

  final Map<String, List<String>> slots = {
    "Morning": [
      "08:00 AM",
      "08:30 AM",
      "09:00 AM",
      "09:30 AM",
      "10:00 AM",
      "10:30 AM",
      "11:00 AM",
      "11:30 AM",
    ],
    "Afternoon": [
      "12:00 PM",
      "12:30 PM",
      "01:00 PM",
      "01:30 PM",
      "02:00 PM",
      "02:30 PM",
      "03:00 PM",
      "03:30 PM",
      "04:00 PM",
      "04:30 PM",
      "05:00 PM",
      "05:30 PM",
    ],
    "Evening": [
      "06:00 PM",
      "06:30 PM",
      "07:00 PM",
      "07:30 PM",
      "08:00 PM",
      "08:30 PM",
    ],
  };

  /// Flatten all possible slots
  Set<String> get allSlots => slots.values.expand((e) => e).toSet();

  @override
  void initState() {
    super.initState();
    _loadAvailability(selectedDate);
  }

  void _loadAvailability(DateTime date) {
    final saved = SlotsDataService.getAvailability(widget.doctorId, date);

    availableSlots = saved.isEmpty ? Set.from(allSlots) : Set.from(saved);

    selectedSlots = {};
  }

  Widget slotButton(String time) {
    final bool isAvailable = availableSlots.contains(time);
    final bool isSelected = selectedSlots.contains(time);

    return GestureDetector(
      onTap: isAvailable
          ? () {
              setState(() {
                isSelected
                    ? selectedSlots.remove(time)
                    : selectedSlots.add(time);
              });
            }
          : null,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: !isAvailable
              ? Colors
                    .grey
                    .shade400 // booked
              : isSelected
              ? const Color.fromARGB(255, 123, 194, 123)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          time,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: !isAvailable
                ? Colors.grey.shade700
                : isSelected
                ? Colors.white
                : Colors.black,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => DoctorDashboard(doctorId: widget.doctorId),
              ),
            );
          },
        ),
      ),
      body: Column(
        children: [
          CalendarDatePicker(
            initialDate: selectedDate,
            firstDate: DateTime.now(),
            lastDate: DateTime(2030),
            onDateChanged: (date) {
              setState(() {
                selectedDate = date;
                _loadAvailability(date);
              });
            },
          ),

          Expanded(
            child: Container(
              color: const Color.fromARGB(255, 242, 244, 245),
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: slots.entries.map((section) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      Text(
                        section.key,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      GridView.count(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 2.5,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: section.value.map(slotButton).toList(),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    availableSlots = Set.from(selectedSlots); 
                    selectedSlots.clear();
                  });

                  SlotsDataService.saveAvailability(
                    widget.doctorId,
                    selectedDate,
                    availableSlots,
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Availability saved"),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },

                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 44, 56, 56),
                  foregroundColor: Colors.white,
                ),
                child: const Text("Save Availability"),
              ),
            ),
          ),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        selectedItemColor: const Color.fromARGB(255, 44, 56, 56),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => DoctorDashboard(doctorId: widget.doctorId),
              ),
            );
          }
          if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => PatientsPage(doctorId: widget.doctorId),
              ),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "DASH"),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: "PATIENTS"),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: "APPOINTMENTS",
          ),
        ],
      ),
    );
  }
}
