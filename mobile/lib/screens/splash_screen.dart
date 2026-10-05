import 'package:flutter/material.dart';
import 'package:atuimate_app/screens/onboarding/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool startAnimation = false;
  bool showText = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          startAnimation = true;
        });
      }
    });

    Future.delayed(const Duration(milliseconds: 1800), () {
      if (mounted) {
        setState(() {
          showText = true;
        });
      }
    });

    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const OnboardingScreen(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 260,
              height: 120,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  /// البازل
                  AnimatedAlign(
                    duration: const Duration(milliseconds: 1400),
                    curve: Curves.easeOutBack,
                    alignment: startAnimation
                        ? const Alignment(-0.15, 0)
                        : const Alignment(-2, 0),
                    child: Image.asset(
                      "assets/images/البازل.png",
                      width: 150,
                    ),
                  ),

                  /// القلب
                  AnimatedAlign(
                    duration: const Duration(milliseconds: 1400),
                    curve: Curves.easeOutBack,
                    alignment: startAnimation
                        ? const Alignment(0.15, 0)
                        : const Alignment(2, 0),
                    child: Transform.translate(
                      offset: const Offset(-15, 0),
                      child: Image.asset(
                        "assets/images/القلب.png",
                        width: 150,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 0),

            AnimatedOpacity(
              opacity: showText ? 1 : 0,
              duration: const Duration(milliseconds: 700),
              child: Transform.translate(
                offset: const Offset(0, -30),
                child: const Text(
                  "Autimate",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF45BB89),
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}