import 'package:flutter/material.dart';
import 'package:mad_project_test1/doctorappointments.dart';
import 'package:mad_project_test1/patients_page.dart';
import 'package:mad_project_test1/userdataservice.dart';
import 'package:mad_project_test1/appointmentsdataservice.dart';

class DoctorDashboard extends StatefulWidget {
  final String doctorId;

  const DoctorDashboard({
    super.key,
    required this.doctorId,
  });

  @override
  State<DoctorDashboard> createState() => _DoctorDashboardState();
}

class _DoctorDashboardState extends State<DoctorDashboard> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final doctorName =
        UserDataService.getDoctorName(widget.doctorId);

    final now = DateTime.now();

    final todaysAppointments =
        AppointmentsDataService.forDoctorOnDay(
          widget.doctorId,
          now,
        )..sort((a, b) => a.dateTime.compareTo(b.dateTime));

    final totalToday = todaysAppointments.length;

    final remaining = todaysAppointments
        .where((a) => a.dateTime.isAfter(now))
        .length;

    final upcomingToday = todaysAppointments
        .where((a) => a.dateTime.isAfter(now))
        .take(5)
        .toList();

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 247, 249, 252),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              "/",
              (route) => false,
            );
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _formattedDate(),
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Good Morning, $doctorName",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              _summaryCard(totalToday, remaining),
              const SizedBox(height: 16),

              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          PatientsPage(doctorId: widget.doctorId),
                    ),
                  );
                },
                child: _recordsCard(),
              ),

              const SizedBox(height: 24),

              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "TODAY'S TIMELINE",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    "View all",
                    style: TextStyle(color: Colors.blue),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              if (upcomingToday.isEmpty)
                const Text(
                  "No more appointments today",
                  style: TextStyle(color: Colors.grey),
                ),

              ...upcomingToday.map((a) => _appointmentTile(
                    name: a.patientName,
                    time: TimeOfDay.fromDateTime(a.dateTime)
                        .format(context),
                  )),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedItemColor:
            const Color.fromARGB(255, 44, 56, 56),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() => currentIndex = index);

          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    PatientsPage(doctorId: widget.doctorId),
              ),
            );
          }

          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    DoctorAppointments(doctorId: widget.doctorId),
              ),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard), label: "DASH"),
          BottomNavigationBarItem(
              icon: Icon(Icons.people), label: "PATIENTS"),
          BottomNavigationBarItem(
              icon: Icon(Icons.event), label: "APPOINTMENTS"),
        ],
      ),
    );
  }

  String _formattedDate() {
    final now = DateTime.now();
    const months = [
      "Jan","Feb","Mar","Apr","May","Jun",
      "Jul","Aug","Sep","Oct","Nov","Dec"
    ];
    const days = [
      "Monday","Tuesday","Wednesday",
      "Thursday","Friday","Saturday","Sunday"
    ];
    return "${days[now.weekday - 1]}, ${months[now.month - 1]} ${now.day}";
  }

  Widget _summaryCard(int total, int remaining) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.calendar_today),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "TOTAL TODAY",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              Text(
                "$total Patients",
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                "$remaining remaining",
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _recordsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: const [
          Icon(Icons.folder),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Patient Records",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "Search and view medical records",
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right),
        ],
      ),
    );
  }

  Widget _appointmentTile({
    required String name,
    required String time,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const CircleAvatar(child: Icon(Icons.person)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style:
                        const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Text(time),
        ],
      ),
    );
  }
}
