class AppUser {
  String uid;
  String name;
  String email;
  String phone;
  String password;
  String role;

  String? doctorId; // doctor only

  List<String> allergies;
  List<String> surgeries;
  List<String> conditions;

  String dob;
  String emergencyContact;

  AppUser({
    this.uid = "",
    this.name = "",
    this.email = "",
    this.phone = "",
    this.password = "",
    this.role = "patient",
    this.doctorId,
    List<String>? allergies,
    List<String>? surgeries,
    List<String>? conditions,
    this.dob = "",
    this.emergencyContact = "",
  }) : allergies = allergies ?? [],
       surgeries = surgeries ?? [],
       conditions = conditions ?? [];

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
      'doctorId': doctorId,
      'allergies': allergies,
      'surgeries': surgeries,
      'conditions': conditions,
      'dob': dob,
      'emergencyContact': emergencyContact,
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map, {String uid = ''}) {
    return AppUser(
      uid: uid.isNotEmpty ? uid : (map['uid'] ?? '').toString(),
      name: (map['name'] ?? '').toString(),
      email: (map['email'] ?? '').toString(),
      phone: (map['phone'] ?? '').toString(),
      role: (map['role'] ?? 'patient').toString(),
      doctorId: map['doctorId']?.toString(),
      allergies: List<String>.from(map['allergies'] ?? const []),
      surgeries: List<String>.from(map['surgeries'] ?? const []),
      conditions: List<String>.from(map['conditions'] ?? const []),
      dob: (map['dob'] ?? '').toString(),
      emergencyContact: (map['emergencyContact'] ?? '').toString(),
    );
  }
}
