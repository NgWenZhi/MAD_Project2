class AppUser {
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
}
