import 'user.dart';


class UserDataService {
  static List<AppUser> patients = [
    AppUser(
      name: "Test Patient",
      email: "test@example.com",
      password: "123456",
      role: "patient",
      phone: "91511886",
      dob: "19-02-2007",
      emergencyContact: "",
      allergies: ["Peanuts","Peppers","Chocolate","Strawberries"],
      surgeries: ['Sinus surgery']
    ),
    AppUser(
      name: "Amelie Tan",
      email: "tan@example.com",
      password: "123123",
      role: "patient",
      phone: "",
      dob: "",
      emergencyContact: "",
      allergies: ["Cats","Dogs"],
      surgeries: ['Breast biopsy'],
      conditions: ["Ezcyma"]
    ),
  ];

  static List<AppUser> doctors = [
    AppUser(
      name: "Dr. Neo",
      doctorId: "D001",
      password: "123456",
      role: "doctor",
    ),
    AppUser(
      name: "Dr. Smith",
      doctorId: "D002",
      password: "234567",
      role: "doctor",
    ),
    AppUser(
      name: "Dr. Gun",
      doctorId: "D003",
      password: "345678",
      role: "doctor",
    ),
  ];

  // ---------- LOGIN ----------

  static AppUser? loginPatient(String email, String password) {
    for (var u in patients) {
      if (u.email == email && u.password == password) {
        return u;
      }
    }
    return null;
  }

  static AppUser? loginDoctor(String doctorId, String password) {
    for (var d in doctors) {
      if (d.doctorId == doctorId && d.password == password) {
        return d;
      }
    }
    return null;
  }

  // ---------- PATIENT MANAGEMENT ----------

  static void registerPatient(AppUser user) {
    patients.add(user);
  }

  static void updatePatient(AppUser updatedUser) {
    for (int i = 0; i < patients.length; i++) {
      if (patients[i].email == updatedUser.email) {
        patients[i] = updatedUser;
        return;
      }
    }
  }

  static bool resetPatientPassword(String email, String newPassword) {
    for (var user in patients) {
      if (user.email == email) {
        user.password = newPassword;
        return true;
      }
    }
    return false;
  }

  static bool emailExists(String email) {
    for (var user in patients) {
      if (user.email == email) {
        return true;
      }
    }
    return false;
  }

  

  // ---------- DOCTOR HELPERS ----------

  static String getDoctorName(String doctorId) {
    for (var d in doctors) {
      if (d.doctorId == doctorId) {
        return d.name;
      }
    }
    return "Dr.";
  }
}
