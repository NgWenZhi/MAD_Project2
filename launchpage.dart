import 'package:flutter/material.dart';

class LaunchPage extends StatelessWidget {
  const LaunchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 244, 245),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // TOP HALF
            Column(
              children: [
                const SizedBox(height: 30),
                Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 210, 231, 227),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.medical_services, size: 42, color: Color.fromARGB(255, 86, 131, 121)),
              ),
                const SizedBox(height: 10),
                const Text(
                  "MedihBook",
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Your health, simplified.",
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                const SizedBox(height: 350),
              ],
            ),

            // BUTTONS
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, "/register");
                    },
                    child: const Text("Sign Up"),
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                      foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                      shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, "/login");
                    },
                    child: const Text("Login"),
                  ),
                ),
              ],
            ),

            HoverText(
              text: "Doctor Portal >",
              onTap: () {
                Navigator.pushNamed(context, "/doctorLogin");
              },
            ),
          ],
        ),
      ),
    );
  }
}

class HoverText extends StatefulWidget {
  final String text;
  final VoidCallback onTap;

  const HoverText({super.key, required this.text, required this.onTap});

  @override
  State<HoverText> createState() => _HoverTextState();
}

class _HoverTextState extends State<HoverText> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        setState(() {
          isHovered = true;
        });
      },
      onExit: (_) {
        setState(() {
          isHovered = false;
        });
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: Text(
          widget.text,
          style: TextStyle(
            color: const Color.fromARGB(255, 0, 126, 230),
            fontSize: 16,
            decoration: isHovered
                ? TextDecoration.underline
                : TextDecoration.none,
          ),
        ),
      ),
    );
  }
}
