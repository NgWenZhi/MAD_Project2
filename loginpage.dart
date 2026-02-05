import 'package:flutter/material.dart';
import 'userdataservice.dart';
import 'user.dart';
import 'patient_dashboard.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  bool showPassword = false;
  String errorMsg = "";

  void login() {
    AppUser? user = UserDataService.loginPatient(
      emailCtrl.text.trim(),
      passCtrl.text,
    );

    if (user == null) {
      setState(() {
        errorMsg = "Invalid email or password. Please try again.";
      });
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => PatientDashboard(user: user),
      ),
    );

    emailCtrl.clear();
    passCtrl.clear();
    errorMsg = "";
    showPassword = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 244, 245),
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 242, 244, 245),
        foregroundColor: Colors.black,
        title: const Text(
          "MedihBook",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),

              Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 230, 242, 248),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(
                  Icons.medical_services,
                  size: 40,
                  color: Color.fromARGB(255, 90, 165, 200),
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                "Patient Login",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 6),

              Text(
                "Welcome back. Please enter your details.",
                style: TextStyle(color: Colors.grey.shade600),
              ),

              const SizedBox(height: 32),

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

              TextField(
                controller: emailCtrl,
                decoration: InputDecoration(
                  hintText: "e.g. david@example.com",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Password",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  HoverText(
                    text: "Forgot Password?",
                    onTap: () {
                      Navigator.pushNamed(context, "/resetPassword");
                    },
                  ),
                ],
              ),

              const SizedBox(height: 6),

              TextField(
                controller: passCtrl,
                obscureText: !showPassword,
                decoration: InputDecoration(
                  hintText: "Enter your password",
                  suffixIcon: IconButton(
                    icon: Icon(
                      showPassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        showPassword = !showPassword;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color.fromARGB(255, 105, 176, 210),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              if (errorMsg.isNotEmpty)
                Text(
                  errorMsg,
                  style: const TextStyle(color: Colors.red),
                ),

              const SizedBox(height: 40),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  HoverText(
                    text: "Sign Up",
                    onTap: () {
                      Navigator.pushNamed(context, "/register");
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HoverText extends StatefulWidget {
  final String text;
  final VoidCallback onTap;

  const HoverText({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  State<HoverText> createState() => _HoverTextState();
}

class _HoverTextState extends State<HoverText> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Text(
          widget.text,
          style: TextStyle(
            color: Colors.blue,
            decoration:
                isHovered ? TextDecoration.underline : TextDecoration.none,
          ),
        ),
      ),
    );
  }
}
