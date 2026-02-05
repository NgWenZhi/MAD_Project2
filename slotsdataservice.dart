import 'package:cloud_firestore/cloud_firestore.dart';

class SlotsDataService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static String _dateKey(DateTime date) {
    final d = DateTime(date.year, date.month, date.day);
    return '${d.year.toString().padLeft(4, '0')}-'
        '${d.month.toString().padLeft(2, '0')}-'
        '${d.day.toString().padLeft(2, '0')}';
  }

  static DocumentReference<Map<String, dynamic>> _slotDoc(
    String doctorId,
    DateTime date,
  ) {
    return _db
        .collection('doctorSlots')
        .doc(doctorId)
        .collection('dates')
        .doc(_dateKey(date));
  }

  static Future<void> saveAvailability(
    String doctorId,
    DateTime date,
    Set<String> slots,
  ) async {
    await _slotDoc(doctorId, date).set({
      'slots': slots.toList()..sort(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  static Future<Set<String>> getAvailability(String doctorId, DateTime date) async {
    final doc = await _slotDoc(doctorId, date).get();
    final data = doc.data();
    if (data == null) return {};
    return Set<String>.from(data['slots'] ?? const <String>[]);
  }
}
