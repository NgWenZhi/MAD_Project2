import 'package:flutter/material.dart';
import 'package:mad_project_test1/schedule_apt.dart';
import 'user.dart';
import 'userdataservice.dart';
import 'patient_dashboard.dart';
//import 'appointments_page.dart';
import 'profile_page.dart';

class HealthSummaryPage extends StatefulWidget {
  final AppUser user;

  const HealthSummaryPage({
    super.key,
    required this.user,
  });

  @override
  State<HealthSummaryPage> createState() => _HealthSummaryPageState();
}

class _HealthSummaryPageState extends State<HealthSummaryPage> {
  late AppUser _user;
  int currentIndex = 2;

  @override
  void initState() {
    super.initState();
    _user = widget.user;
  }

  void _editList(String title, List<String> list) {
    final controller = TextEditingController(text: list.join("\n"));

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Edit $title"),
        content: TextField(
          controller: controller,
          maxLines: 6,
          decoration: const InputDecoration(
            hintText: "One item per line",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                list
                  ..clear()
                  ..addAll(
                    controller.text
                        .split("\n")
                        .map((e) => e.trim())
                        .where((e) => e.isNotEmpty),
                  );
              });

              UserDataService.updatePatient(_user);
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  Widget summaryCard(String title, List<String> list, String emptyText) {
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
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => _editList(title, list),
                    child: const Text("Edit"),
                  ),
                ],
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          "Health Summary",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: ListView(
            children: [
              const SizedBox(height: 20),

              summaryCard(
                "Allergies",
                _user.allergies,
                "No allergies recorded.",
              ),
              summaryCard(
                "Past Surgeries",
                _user.surgeries,
                "No surgeries recorded.",
              ),
              summaryCard(
                "Medical Conditions",
                _user.conditions,
                "No medical conditions recorded.",
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black45,
        onTap: (index) {
          if (index == currentIndex) return;

          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => PatientDashboard(user: _user),
              ),
            );
          }

          if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => ScheduleAppointmentPage(user: _user),
              ),
            );
          }

          if (index == 3) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => ProfilePage(user: _user),
              ),
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
