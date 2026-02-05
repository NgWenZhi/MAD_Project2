import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Appointment {
  final String id;
  final String doctorId;
  final String patientName;
  final String patientUid;
  final DateTime dateTime;

  Appointment({
    this.id = '',
    required this.doctorId,
    required this.patientName,
    required this.patientUid,
    required this.dateTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'doctorId': doctorId,
      'patientName': patientName,
      'patientUid': patientUid,
      'dateTime': Timestamp.fromDate(dateTime),
      'status': 'booked',
    };
  }

  factory Appointment.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return Appointment(
      id: doc.id,
      doctorId: (data['doctorId'] ?? '').toString(),
      patientName: (data['patientName'] ?? '').toString(),
      patientUid: (data['patientUid'] ?? '').toString(),
      dateTime: (data['dateTime'] as Timestamp).toDate(),
    );
  }
}

class AppointmentsDataService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static CollectionReference<Map<String, dynamic>> get _appointments =>
      _db.collection('appointments');

  static Future<void> add(Appointment appt) async {
    await _appointments.add(appt.toMap());
  }

  static Future<void> remove(Appointment appt) async {
    if (appt.id.isEmpty) return;
    await _appointments.doc(appt.id).delete();
  }

  static Future<List<Appointment>> get all async {
    final snap = await _appointments.orderBy('dateTime').get();
    return snap.docs.map(Appointment.fromDoc).toList();
  }

  static Future<List<Appointment>> forDoctorOnDay(String doctorId, DateTime day) async {
    final start = DateTime(day.year, day.month, day.day);
    final end = start.add(const Duration(days: 1));

    final snap = await _appointments
        .where('doctorId', isEqualTo: doctorId)
        .where('dateTime', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('dateTime', isLessThan: Timestamp.fromDate(end))
        .orderBy('dateTime')
        .get();

    return snap.docs.map(Appointment.fromDoc).toList();
  }

  static Future<List<Appointment>> forPatient(String patientName) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return [];
    final snap = await _appointments
        .where('patientUid', isEqualTo: uid)
        .orderBy('dateTime')
        .get();

    return snap.docs.map(Appointment.fromDoc).toList();
  }
}
