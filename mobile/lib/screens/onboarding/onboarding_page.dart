import 'package:flutter/material.dart';
import '../../models/onboarding_model.dart';

class OnboardingPage extends StatelessWidget {
  final OnboardingModel model;

  const OnboardingPage({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    if (model.isLast) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Column(
          children: [
            const SizedBox(height: 20),

            Text(
              model.title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0E2A47),
              ),
            ),

            const SizedBox(height: 30),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.lightBlue.shade50,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Image.asset(model.image, height: 220),
            ),

            const Spacer(),

            // Sign up
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/signup");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF45BB89),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "Sign up",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 14),

            // Log in
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/login");
                },
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  side: const BorderSide(color: Color(0xFF45BB89)),
                ),
                child: const Text(
                  "Log in",
                  style: TextStyle(fontSize: 16, color: Color(0xFF45BB89)),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Column(
        children: [
          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: model.title == "Welcome to our app"
                    ? const Color(0xFF45BB89)
                    : Colors.transparent,
                width: 2,
              ),
            ),
            child: Image.asset(model.image, height: 250, fit: BoxFit.contain),
          ),

          const SizedBox(height: 30),

          Text(
            model.title,
            style: const TextStyle(
              color: Color(0xFF45BB89),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 10),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              model.subtitle,
              style: const TextStyle(fontSize: 14, color: Color(0xFF0E2A47)),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
