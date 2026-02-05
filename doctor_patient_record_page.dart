import 'package:flutter/material.dart';
import 'user.dart';
import 'doctorportal.dart';
import 'patients_page.dart';
import 'doctorappointments.dart';

class DoctorPatientRecordPage extends StatelessWidget {
  final AppUser patient;
  final String doctorId;

  const DoctorPatientRecordPage({
    super.key,
    required this.patient,
    required this.doctorId,
  });

  Widget _recordCard(
    String title,
    List<String> list,
    String emptyText,
  ) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.black12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              if (list.isEmpty)
                Text(
                  emptyText,
                  style: const TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                  ),
                )
              else
                ...list.map(
                  (e) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Text("• $e"),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          "Patient Medical Record",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
          children: [
            // 👤 Patient header
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 26,
                    child: Icon(Icons.person),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          patient.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          patient.email,
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            _recordCard(
              "Allergies",
              patient.allergies,
              "No allergies recorded.",
            ),
            _recordCard(
              "Past Surgeries",
              patient.surgeries,
              "No surgeries recorded.",
            ),
            _recordCard(
              "Medical Conditions",
              patient.conditions,
              "No medical conditions recorded.",
            ),
          ],
        ),
      ),

      // ✅ DOCTOR BOTTOM NAV
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1, // PATIENTS
        selectedItemColor: const Color.fromARGB(255, 44, 56, 56),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 1) return;

          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    DoctorDashboard(doctorId: doctorId),
              ),
            );
          }

          if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => PatientsPage(doctorId: doctorId),
              ),
            );
          }

          if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => DoctorAppointments(
                  doctorId: doctorId,
                ),
              ),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: "DASH",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: "PATIENTS",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: "APPOINTMENTS",
          ),
        ],
      ),
    );
  }
}
