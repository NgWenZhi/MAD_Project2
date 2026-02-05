import 'package:flutter/material.dart';
import 'userdataservice.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  bool showPassword = false;
  String message = "";

  void resetPassword() {
    String email = emailCtrl.text.trim();
    String password = passCtrl.text;

    if (email.isEmpty || password.isEmpty) {
      setState(() => message = "Please fill in all fields");
      return;
    }

    if (!email.contains("@") || !email.contains(".")) {
      setState(() => message = "Please enter a valid email");
      return;
    }

    if (password.length < 6) {
      setState(() => message = "Password must be at least 6 characters");
      return;
    }

    bool success =
        UserDataService.resetPatientPassword(email, password);

    if (!success) {
      setState(() => message = "Account not found");
      return;
    }

    Navigator.pushReplacementNamed(context, "/login");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: const BackButton(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),

              // Icon
              Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 230, 242, 248),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(
                  Icons.lock_reset,
                  size: 40,
                  color: Color.fromARGB(255, 90, 165, 200),
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                "Reset Password",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                "Enter your email address below and set a new password.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade600),
              ),

              const SizedBox(height: 32),

              // Email label
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Email Address",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
              const SizedBox(height: 6),

              // Email field
              TextField(
                controller: emailCtrl,
                decoration: InputDecoration(
                  hintText: "name@example.com",
                  prefixIcon: const Icon(Icons.email_outlined),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 245, 246, 248),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // New password label
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "New Password",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
              const SizedBox(height: 6),

              // New password field
              TextField(
                controller: passCtrl,
                obscureText: !showPassword,
                decoration: InputDecoration(
                  hintText: "Enter new password",
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      showPassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () =>
                        setState(() => showPassword = !showPassword),
                  ),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 245, 246, 248),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // Forgot password button (actual reset)
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: resetPassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color.fromARGB(255, 30, 123, 187),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Forgot Password",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              if (message.isNotEmpty)
                Text(
                  message,
                  style: const TextStyle(color: Colors.red),
                ),

              const SizedBox(height: 30),

              // Back to login
              TextButton.icon(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, "/login");
                },
                icon: const Icon(Icons.arrow_back, size: 18, color: Colors.blueAccent),
                label: const Text("Back to Login",
                style: TextStyle(color: Colors.blueAccent, fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
