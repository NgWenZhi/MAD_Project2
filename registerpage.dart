import 'package:flutter/material.dart';
import 'userdataservice.dart';
import 'user.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  bool showPassword = false;
  String errorMsg = "";

  void register() {
    String name = nameCtrl.text.trim();
    String email = emailCtrl.text.trim();
    String phone = phoneCtrl.text.trim();
    String password = passCtrl.text;

    if (name.isEmpty || email.isEmpty || phone.isEmpty || password.isEmpty) {
      setState(() => errorMsg = "Please fill in all fields");
      return;
    }

    if (!email.contains("@") || !email.contains(".")) {
      setState(() => errorMsg = "Please enter a valid email address");
      return;
    }

    if (phone.length != 8 || int.tryParse(phone) == null) {
      setState(() => errorMsg = "Please enter a valid 8-digit phone number");
      return;
    }

    if (password.length < 6) {
      setState(() => errorMsg = "Password must be at least 6 characters");
      return;
    }

    if (UserDataService.emailExists(email)) {
      setState(() => errorMsg = "Email already registered");
      return;
    }

    UserDataService.registerPatient(
      AppUser(
        name: name,
        email: email,
        phone: phone,
        password: password,
        role: "patient",
      ),
    );

    nameCtrl.clear();
    emailCtrl.clear();
    phoneCtrl.clear();
    passCtrl.clear();

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
        title: const Text(
          "Create Account",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 16),

              _inputField(
                controller: nameCtrl,
                hint: "Full Name",
              ),

              const SizedBox(height: 14),

              _inputField(
                controller: emailCtrl,
                hint: "Email Address",
              ),

              const SizedBox(height: 14),

              _inputField(
                controller: phoneCtrl,
                hint: "Phone Number",
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 14),

              TextField(
                controller: passCtrl,
                obscureText: !showPassword,
                decoration: InputDecoration(
                  hintText: "Password",
                  filled: true,
                  fillColor: const Color.fromARGB(255, 245, 246, 248),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      showPassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: () =>
                        setState(() => showPassword = !showPassword),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color.fromARGB(255, 45, 96, 235),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Sign Up",
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

              const SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account? ",
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  HoverText(
                    text: "Login",
                    onTap: () {
                      Navigator.pushReplacementNamed(context, "/login");
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

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color.fromARGB(255, 245, 246, 248),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
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
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
