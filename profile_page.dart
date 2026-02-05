import 'package:flutter/material.dart';
import 'package:mad_project_test1/schedule_apt.dart';
import 'user.dart';
import 'userdataservice.dart';
import 'patient_dashboard.dart';
//import 'appointments_page.dart';
import 'healthsummary.dart';

class ProfilePage extends StatefulWidget {
  final AppUser user;

  const ProfilePage({
    super.key,
    required this.user,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late AppUser _user;
  int currentIndex = 3;

  @override
  void initState() {
    super.initState();
    _user = widget.user;
  }

  Future<void> _editField({
    required String title,
    required String initialValue,
    required ValueChanged<String> onSaved,
    TextInputType keyboardType = TextInputType.text,
  }) async {
    final controller = TextEditingController(text: initialValue);

    final result = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Edit $title"),
        content: TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text("Save"),
          ),
        ],
      ),
    );

    if (result != null && result.isNotEmpty) {
      setState(() => onSaved(result));
      UserDataService.updatePatient(_user);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bg = const Color(0xFFF6F7FB);
    final card = Colors.white;
    final muted = const Color(0xFF9AA3AF);

    final headerName = _user.name.trim().isEmpty ? " " : _user.name;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: bg,
        elevation: 0,
        title: const Text(
          "Profile",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 18),
          children: [
            const SizedBox(height: 6),

            _AvatarHeader(
              displayName: headerName,
              onChangePhoto: () {},
            ),

            const SizedBox(height: 16),

            _InfoCard(
              background: card,
              label: "FULL NAME",
              value: _user.name,
              onEdit: () => _editField(
                title: "Full Name",
                initialValue: _user.name,
                onSaved: (v) => _user.name = v,
              ),
            ),
            const SizedBox(height: 12),

            _InfoCard(
              background: card,
              label: "PHONE NUMBER",
              value: _user.phone,
              onEdit: () => _editField(
                title: "Phone Number",
                initialValue: _user.phone,
                keyboardType: TextInputType.phone,
                onSaved: (v) => _user.phone = v,
              ),
            ),
            const SizedBox(height: 12),

            _InfoCard(
              background: card,
              label: "EMAIL",
              value: _user.email,
            ),
            const SizedBox(height: 12),

            _InfoCard(
              background: card,
              label: "DATE OF BIRTH",
              value: _user.dob,
              onEdit: () => _editField(
                title: "Date of Birth",
                initialValue: _user.dob,
                onSaved: (v) => _user.dob = v,
              ),
            ),
            const SizedBox(height: 12),

            _InfoCard(
              background: card,
              label: "EMERGENCY CONTACT",
              value: _user.emergencyContact,
              onEdit: () => _editField(
                title: "Emergency Contact",
                initialValue: _user.emergencyContact,
                onSaved: (v) => _user.emergencyContact = v,
              ),
            ),

            const SizedBox(height: 18),

            SizedBox(
              height: 52,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  backgroundColor: card,
                  side: const BorderSide(color: Color(0xFFE5E7EB)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    "/",
                    (_) => false,
                  );
                },
                icon: const Icon(Icons.logout, color: Colors.redAccent),
                label: const Text(
                  "Logout",
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 18),

            Center(
              child: Text(
                "MedihBook v1.2.1",
                style: TextStyle(color: muted, fontSize: 12),
              ),
            ),
          ],
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

          if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => HealthSummaryPage(user: _user),
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

/// ---------- UI WIDGETS ----------

class _AvatarHeader extends StatelessWidget {
  final String displayName;
  final VoidCallback onChangePhoto;

  const _AvatarHeader({
    required this.displayName,
    required this.onChangePhoto,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 44,
          backgroundColor: const Color(0xFF1F2937),
          child: Text(
            displayName.isNotEmpty ? displayName[0].toUpperCase() : "U",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          displayName,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  final Color background;
  final String label;
  final String value;
  final VoidCallback? onEdit;

  const _InfoCard({
    required this.background,
    required this.label,
    required this.value,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF9AA3AF),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          if (onEdit != null)
            InkWell(
              onTap: onEdit,
              child: const Icon(Icons.edit, color: Color(0xFF2F6FED)),
            ),
        ],
      ),
    );
  }
}
