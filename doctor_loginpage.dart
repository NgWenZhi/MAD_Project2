import 'package:flutter/material.dart';
import 'userdataservice.dart';
import 'doctorportal.dart';

class DoctorLoginPage extends StatefulWidget {
  const DoctorLoginPage({super.key});

  @override
  State<DoctorLoginPage> createState() => _DoctorLoginPageState();
}

class _DoctorLoginPageState extends State<DoctorLoginPage> {
  final idCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  bool showPassword = false;
  String error = "";

  void login() {
    var doctor = UserDataService.loginDoctor(idCtrl.text, passCtrl.text);

    if (doctor == null) {
      setState(() => error = "Invalid ID/password");
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => DoctorDashboard(doctorId: doctor.doctorId!),
      ),
    );

    idCtrl.clear();
    passCtrl.clear();
    error = "";
    showPassword = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 244, 245),
      appBar: AppBar(
        centerTitle: true, 
        backgroundColor: const Color.fromARGB(255, 242, 244, 245),
        title: Text("MedihBook", 
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),

              // Top icon
              Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 228, 230, 233),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.medical_services, size: 42, color: Color.fromARGB(255, 39, 54, 80)),
              ),

              const SizedBox(height: 20),

              const Text(
                "Doctor Portal Login",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 6),

              Text(
                "Secure access for clinical staff only",
                style: TextStyle(color: Colors.grey.shade600),
              ),

              const SizedBox(height: 30),

              // Staff ID
              TextField(
                controller: idCtrl,
                decoration: InputDecoration(
                  labelText: "Enter your staff ID",
                  prefixIcon: const Icon(Icons.lock_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Password
              TextField(
                controller: passCtrl,
                obscureText: !showPassword,
                decoration: InputDecoration(
                  labelText: "Enter your password",
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      showPassword ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () =>
                        setState(() => showPassword = !showPassword),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Login button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 39, 54, 80),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Login"),
                ),
              ),

              const SizedBox(height: 12),

              // Error message
              if (error.isNotEmpty)
                Text(error, style: const TextStyle(color: Colors.red)),

              const SizedBox(height: 30),

              // Admin notice
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 227, 227, 228),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.info_outline, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Administrative Notice: Accounts are managed by clinic administration. "
                        "Self-registration is disabled. Please contact your department supervisor "
                        "for credential issues or password resets.",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
