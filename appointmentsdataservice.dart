class Appointment {
  final String doctorId;
  final String patientName;
  final DateTime dateTime;

  Appointment({
    required this.doctorId,
    required this.patientName,
    required this.dateTime,
  });
}

class AppointmentsDataService {
  static final List<Appointment> _appointments = [];


  static void add(Appointment appt) {
    _appointments.add(appt);
  }


  static void remove(Appointment appt) {
    _appointments.remove(appt);
  }


  static List<Appointment> get all {
    return List.unmodifiable(_appointments);
  }


  static List<Appointment> forDoctorOnDay(
    String doctorId,
    DateTime day,
  ) {
    return _appointments.where((a) {
      return a.doctorId == doctorId &&
          a.dateTime.year == day.year &&
          a.dateTime.month == day.month &&
          a.dateTime.day == day.day;
    }).toList();
  }

  
  

  
  static List<Appointment> forPatient(String patientName) {
    return _appointments
        .where((a) => a.patientName == patientName)
        .toList();
  }
}

