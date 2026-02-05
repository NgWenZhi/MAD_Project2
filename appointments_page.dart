import 'package:flutter/material.dart';
import 'package:mad_project_test1/appointmentsdataservice.dart';

class AppointmentsPage extends StatefulWidget {
  final String patientName;

  const AppointmentsPage({
    super.key,
    required this.patientName,
  });

  @override
  State<AppointmentsPage> createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends State<AppointmentsPage> {
  int tabIndex = 0;

  DateTime get _now => DateTime.now();

  bool _isPast(Appointment a) => a.dateTime.isBefore(_now);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Appointments"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                _tabButton("Upcoming", 0),
                const SizedBox(width: 8),
                _tabButton("Past", 1),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<List<Appointment>>(
                future: AppointmentsDataService.forPatient(widget.patientName),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final filtered = snapshot.data!.where((a) {
                    return tabIndex == 0 ? !_isPast(a) : _isPast(a);
                  }).toList()
                    ..sort((a, b) => a.dateTime.compareTo(b.dateTime));

                  if (filtered.isEmpty) {
                    return const Center(
                      child: Text(
                        "No appointments found",
                        style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }

                  return ListView.separated(
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 14),
                    itemBuilder: (_, i) {
                      final a = filtered[i];
                      return _AppointmentCard(
                        appointment: a,
                        isPast: _isPast(a),
                        onCancel: () async {
                          await AppointmentsDataService.remove(a);
                          if (mounted) setState(() {});
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tabButton(String text, int index) {
    final selected = tabIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => tabIndex = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected ? Colors.black : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: selected ? Colors.white : Colors.black54,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AppointmentCard extends StatelessWidget {
  final Appointment appointment;
  final bool isPast;
  final Future<void> Function() onCancel;

  const _AppointmentCard({
    required this.appointment,
    required this.isPast,
    required this.onCancel,
  });

  String _fmt(DateTime d) {
    return "${d.day}/${d.month}/${d.year} • "
        "${d.hour.toString().padLeft(2, '0')}:"
        "${d.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Doctor ID: ${appointment.doctorId}",
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
          ),
          const SizedBox(height: 6),
          Text(
            _fmt(appointment.dateTime),
            style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 14),
          if (!isPast)
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  onCancel();
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                ),
                child: const Text("Cancel"),
              ),
            )
          else
            const Text(
              "Completed",
              style: TextStyle(fontWeight: FontWeight.w700, color: Colors.grey),
            ),
        ],
      ),
    );
  }
}
