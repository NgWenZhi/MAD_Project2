import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'user.dart';

class UserDataService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static CollectionReference<Map<String, dynamic>> get _users =>
      _db.collection('users');

  static Future<AppUser?> loginPatient(String email, String password) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final uid = credential.user?.uid;
    if (uid == null) return null;

    final doc = await _users.doc(uid).get();
    final data = doc.data();
    if (data == null || data['role'] != 'patient') {
      await _auth.signOut();
      return null;
    }

    return AppUser.fromMap(data, uid: uid);
  }

  static Future<AppUser?> loginDoctor(String doctorId, String password) async {
    final query = await _users
        .where('role', isEqualTo: 'doctor')
        .where('doctorId', isEqualTo: doctorId)
        .limit(1)
        .get();

    if (query.docs.isEmpty) return null;

    final doctorData = query.docs.first.data();
    final email = (doctorData['email'] ?? '').toString();
    if (email.isEmpty) return null;

    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final uid = credential.user?.uid;
    if (uid == null) return null;

    final doc = await _users.doc(uid).get();
    final data = doc.data();
    if (data == null || data['role'] != 'doctor') {
      await _auth.signOut();
      return null;
    }

    return AppUser.fromMap(data, uid: uid);
  }

  static Future<void> registerPatient(AppUser user) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: user.email,
      password: user.password,
    );

    final uid = credential.user!.uid;
    await _users.doc(uid).set({
      ...user.toMap(),
      'uid': uid,
      'role': 'patient',
      'createdAt': FieldValue.serverTimestamp(),
    });
    await _auth.signOut();
  }

  static Future<void> updatePatient(AppUser updatedUser) async {
    final uid = updatedUser.uid.isNotEmpty
        ? updatedUser.uid
        : _auth.currentUser?.uid;
    if (uid == null || uid.isEmpty) return;

    await _users.doc(uid).set({
      ...updatedUser.toMap(),
      'uid': uid,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  static Future<bool> resetPatientPassword(String email, String _) async {
    await _auth.sendPasswordResetEmail(email: email);
    return true;
  }

  static Future<bool> emailExists(String email) async {
    final snapshot = await _users.where('email', isEqualTo: email).limit(1).get();
    return snapshot.docs.isNotEmpty;
  }

  static Future<List<AppUser>> get patients async {
    final snapshot = await _users.where('role', isEqualTo: 'patient').get();
    return snapshot.docs
        .map((d) => AppUser.fromMap(d.data(), uid: d.id))
        .toList();
  }

  static Future<List<AppUser>> get doctors async {
    final snapshot = await _users.where('role', isEqualTo: 'doctor').get();
    return snapshot.docs
        .map((d) => AppUser.fromMap(d.data(), uid: d.id))
        .toList();
  }

  static Future<String> getDoctorName(String doctorId) async {
    final snapshot = await _users
        .where('role', isEqualTo: 'doctor')
        .where('doctorId', isEqualTo: doctorId)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return 'Dr.';
    return (snapshot.docs.first.data()['name'] ?? 'Dr.').toString();
  }

  static Future<AppUser?> getCurrentUserProfile() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return null;
    final doc = await _users.doc(uid).get();
    final data = doc.data();
    if (data == null) return null;
    return AppUser.fromMap(data, uid: uid);
  }
}
