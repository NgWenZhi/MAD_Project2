import 'package:flutter/material.dart';
import 'package:mad_project_test1/doctorappointments.dart';
import 'package:mad_project_test1/doctor_patient_record_page.dart';
import 'package:mad_project_test1/doctorportal.dart';
import 'user.dart';
import 'userdataservice.dart';

class PatientsPage extends StatefulWidget {
  final String doctorId;

  const PatientsPage({
    super.key,
    required this.doctorId,
  });

  @override
  State<PatientsPage> createState() => _PatientsPageState();
}

class _PatientsPageState extends State<PatientsPage> {
  final TextEditingController searchCtrl = TextEditingController();

  List<AppUser> get patients => UserDataService.patients;

  int currentIndex = 1; // 👈 PATIENTS tab

  @override
  Widget build(BuildContext context) {
    final filteredPatients = patients.where((p) {
      return p.name.toLowerCase().contains(searchCtrl.text.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Patient Records",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        foregroundColor: Colors.black,
      ),

      // ---------- BODY ----------
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 🔍 Search bar
            TextField(
              controller: searchCtrl,
              decoration: InputDecoration(
                hintText: "Search patient name",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),

            // 👥 Patient list
            Expanded(
              child: ListView.builder(
                itemCount: filteredPatients.length,
                itemBuilder: (context, index) {
                  final patient = filteredPatients[index];

                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.person),
                      title: Text(
                        patient.name,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(patient.email),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DoctorPatientRecordPage(
                              patient: patient,
                              doctorId: widget.doctorId,
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

      // ---------- BOTTOM NAV ----------
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedItemColor: const Color.fromARGB(255, 44, 56, 56),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == currentIndex) return;

          setState(() => currentIndex = index);

          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => DoctorDashboard(
                  doctorId: widget.doctorId,
                ),
              ),
            );
          }

          if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => DoctorAppointments(
                  doctorId: widget.doctorId,
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
